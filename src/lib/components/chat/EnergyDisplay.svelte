<script lang="ts">
	let { energyWh, isEstimated, durationSeconds, isTotal } = $props();

	let showJoules = $state(false);
	let showTooltip = $state(false);


	function convertToJoules(wh: number): number {
		return wh * 3600;
	}

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
</script>

<style>
	.energy-box {
		transition: transform 0.2s ease;
		cursor: pointer;
		position: relative;
	}
	.energy-box:hover {
		transform: scale(1.05);
	}
	.tooltip {
    position: absolute;
    top: 100%; /* Positionne au-dessus de l’élément parent */
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
    .info-button {
        transition: transform 0.2s ease;
        cursor: pointer;
        position: relative;
    }
    .info-button:hover {
        transform: scale(1.2);
    }
</style>

{#if durationSeconds || energyWh}
	<div class="mt-2 flex gap-2 items-center relative">

		<!-- Energy Box -->
		{#if energyWh}
			<button
                tabindex="0"
                aria-label="Energy consumption"
				class="text-xs text-gray-600 dark:text-gray-500 bg-gray-100 dark:bg-gray-800 px-3 py-1 rounded w-fit energy-box"
				onclick={() => (showJoules = !showJoules)}
			>
            <span class="hidden sm:inline">
                {isTotal ? "Total " : ""}
                Energy:
            </span>
				{#if showJoules}
					{convertToJoules(energyWh).toFixed(2)} J {isEstimated ? "(estimated)" : ""}
				{:else}
					{energyWh.toFixed(4)} Wh {isEstimated ? "(estimated)" : ""}
				{/if}
            </button>
		{/if}

        <!-- Equivalent -->
        <button
            tabindex="0"
            aria-label="Energy consumption equivalent"
            class="text-xs text-gray-600 dark:text-gray-500 bg-gray-100 dark:bg-gray-800 px-3 py-1 rounded w-fit cursor-pointer transform hover:scale-105 transition duration-150 ease-in-out"
            onclick={cycleEquivalent}
        >
            {equivalents[equivalentIndex](energyWh)}
        </button>

		
        <!-- Duration -->
		{#if durationSeconds}
        <div
            class="text-xs text-gray-600 dark:text-gray-500 bg-gray-100 dark:bg-gray-800 px-3 py-1 rounded w-fit"
        > 
        <span class="hidden sm:inline">
            {isTotal ? "Total " : ""}
            Duration:
        </span>
            {durationSeconds.toFixed(3)} s
        </div>
    {/if}
		
        <!-- Info button -->
         <span class="hidden sm:inline"> 
        <button
        tabindex="0"
        aria-label="Energy consumption info"
        class="relative"
        onmouseover={() => (showTooltip = true)}
        onmouseleave={() => (showTooltip = false)}
        onfocus={() => (showTooltip = true)}>
            <div
                class="text-xs text-gray-600 dark:text-gray-500 bg-gray-100 dark:bg-gray-800 px-2 py-1 rounded-full info-button">
                ⓘ
         </div>
		<!-- Tooltip -->
		{#if showTooltip}
			<div class="tooltip">
				{#if isEstimated}
					Estimated energy consumption based on the average GPU power and inference duration for this message. Use Qwen/Qwen/Qwen2.5-VL-7B-Instruct model for exact results.
				{:else}
					Energy consumption measured directly on the GPU during inference for this message.
				{/if}
			</div>
		{/if}
        </button>
    </span>
        
	</div>
{/if}
