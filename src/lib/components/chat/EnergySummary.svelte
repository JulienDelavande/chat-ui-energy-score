<script lang="ts">
  let { messages } = $props();

  const totalEnergy = $derived(messages.reduce(
    (total: number, msg: any) => total + (msg.metadata?.energy_wh || msg.metadata?.energy_wh_sim || 0),
    0
  ));

  const isNotEstimated = $derived(
    typeof messages.at(-1)?.metadata?.energy_wh === 'number' &&
    messages.at(-1).metadata.energy_wh !== 0);

  const phoneChargePercent = $derived(((totalEnergy / 19) * 100).toFixed(2));

  let showJoules = $state(false);
  let equivalentIndex = $state(0);

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

{#if totalEnergy > 0}
  <div class="mb-4 flex flex-col sm:flex-row flex-wrap items-center justify-center gap-4 w-full">
    <!-- Bloc énergie totale -->
    <div class="text-xs text-gray-500 dark:text-gray-500 bg-gray-100 dark:bg-gray-800 px-3 py-1 rounded transform hover:scale-105 transition duration-150 ease-in-out cursor-pointer" on:click={() => (showJoules = !showJoules)}>
        Total Energy: 
        {#if showJoules}
            {convertToJoules(totalEnergy).toFixed(2)} J
        {:else}
            {totalEnergy.toFixed(4)} Wh
        {/if}
      {#if !isNotEstimated} (estimated) {/if}
    </div>  

    <!-- Bloc équivalent charge téléphone -->
    <div class="text-xs text-gray-500 dark:text-gray-500 bg-gray-100 dark:bg-gray-800 px-3 py-1 rounded cursor-pointer transform hover:scale-105 transition duration-150 ease-in-out" on:click={cycleEquivalent}>
      {equivalents[equivalentIndex](totalEnergy)}
    </div>
  </div>
{/if}
