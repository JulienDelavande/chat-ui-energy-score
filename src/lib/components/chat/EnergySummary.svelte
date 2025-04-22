<script lang="ts">
  let { messages } = $props();

  const totalEnergy = $derived(messages.reduce(
    (total: number, msg: any) => total + (msg.metadata?.energy_wh || msg.metadata?.energy_wh_sim || 0),
    0
  ));

  const totalDuration = $derived(messages.reduce(
    (total: number, msg: any) => total + (msg.metadata?.duration_seconds || 0),
    0
  ));   

  const isEstimated = $derived(!(
    typeof messages.at(-1)?.metadata?.energy_wh === 'number' &&
    messages.at(-1).metadata.energy_wh !== 0));

  let showJoules = $state(false);
  let equivalentIndex = $state(0);
  let showTooltip = $state(false);

  const equivalents = [
    (wh: number) => `≈ ${((wh / 19) * 100).toFixed(2)}% of a phone charge (19Wh)`,
    (wh: number) => `≈ ${(wh / 0.04).toFixed(2)} minutes of LED bulb (10W)`, // 0.04Wh/min
    (wh: number) => `≈ ${(wh / 1.5).toFixed(2)} seconds of microwave (1000W)`,
    (wh: number) => `≈ ${(wh / 0.2).toFixed(2)} pedal strokes on an e-bike (200W)`,
    (wh: number) => `≈ ${(wh / 12).toFixed(2)} seconds of toaster use (1kW)`
  ];

  function cycleEquivalent() {
    equivalentIndex = (equivalentIndex + 1) % equivalents.length;
  }

  function convertToJoules(wh: number): number {
		return wh * 3600;
	}
</script>

<style>
    .tooltip {
    position: absolute;
    bottom: 100%; /* Positionne au-dessus de l’élément parent */
    margin-bottom: 0.5rem; /* Équivalent de mb-2 */
    left: 50%;
    transform: translateX(-50%);
    background-color: #f3f4f6; /* bg-gray-200 */
    color: #1f2937; /* text-gray-800 */
    font-size: 0.75rem; /* text-xs */
    padding: 0.5rem 0.75rem; /* px-3 py-2 */
    border-radius: 0.25rem; /* rounded */
    box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1),
                0 4px 6px -4px rgba(0, 0, 0, 0.1); /* shadow-lg */
    z-index: 10;
    width: 16rem; /* w-64 */
    text-align: center;
    }

</style>

{#if totalEnergy > 0}
  <div class="mb-4 flex flex-col sm:flex-row flex-wrap items-center justify-center gap-4 w-full">
    <!-- Bloc énergie totale -->
    <div class="text-xs text-gray-600 dark:text-gray-500 bg-gray-100 dark:bg-gray-800 px-3 py-1 rounded transform hover:scale-105 transition duration-150 ease-in-out cursor-pointer" on:click={() => (showJoules = !showJoules)}>
        Total Energy: 
        {#if showJoules}
            {convertToJoules(totalEnergy).toFixed(2)} J
        {:else}
            {totalEnergy.toFixed(4)} Wh
        {/if}
      {#if isEstimated} (estimated) {/if}
    </div>  

    <!-- Bloc équivalent charge téléphone -->
    <div class="text-xs text-gray-600 dark:text-gray-500 bg-gray-100 dark:bg-gray-800 px-3 py-1 rounded cursor-pointer transform hover:scale-105 transition duration-150 ease-in-out" on:click={cycleEquivalent}>
      {equivalents[equivalentIndex](totalEnergy)}
    </div>

    <!-- Bloc d urée -->
    <div class="text-xs text-gray-600 dark:text-gray-500 bg-gray-100 dark:bg-gray-800 px-3 py-1 rounded">
      Total Duration: {totalDuration.toFixed(3)} sec
    </div>

    <!-- info button -->
    <div
        class="relative"
        on:mouseover={() => (showTooltip = true)}
        on:mouseleave={() => (showTooltip = false)}>
            <button
                class="text-xs text-gray-600 dark:text-gray-500 bg-gray-100 dark:bg-gray-800 px-2 py-1 rounded-full info-button">
                ⓘ
            </button>

      <!-- Tooltip -->
      {#if showTooltip}
      <div class="tooltip">
          {#if isEstimated}
              Estimated energy consumption based on the average GPU power and inference duration for all messages. Use Qwen/Qwen/Qwen2.5-VL-7B-Instruct model for exact results.
          {:else}
              Energy consumption measured directly on the GPU during inference for all messages.
          {/if}
      </div>
  {/if}
    </div>
  </div>
{/if}
