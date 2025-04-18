<script lang="ts">
	let { energyWh, energyWhSim, durationSeconds } = $props();

	let showJoules = $state(false);
	let showTooltip = $state(false);

    const isEstimated = $derived(!(typeof energyWh === 'number' && energyWh !== 0));
    const energyToDisplay = $derived(isEstimated ? energyWhSim : energyWh);

	function convertToJoules(wh: number): number {
		return wh * 3600;
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
		top: 100%;
		left: 0;
		z-index: 10;
		margin-top: 0.25rem;
		padding: 0.5rem;
		background-color: #f3f4f6;
		color: #1f2937;
		font-size: 0.75rem;
		border-radius: 0.25rem;
		box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
		width: max-content;
		max-width: 400px;
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

{#if durationSeconds || energyToDisplay}
	<div class="mt-2 flex gap-2 items-center relative">

        <!-- Info button -->
    <div
        class="relative"
        on:mouseover={() => (showTooltip = true)}
        on:mouseleave={() => (showTooltip = false)}>
        <button
            class="text-xs text-gray-500 dark:text-gray-500 bg-gray-100 dark:bg-gray-800 px-2 py-1 rounded-full info-button">
            ⓘ
        </button>
    </div>
        

		<!-- Energy Box -->
		{#if energyToDisplay}
			<div
				class="text-xs text-gray-500 dark:text-gray-500 bg-gray-100 dark:bg-gray-800 px-3 py-1 rounded w-fit energy-box"
				on:click={() => (showJoules = !showJoules)}
			>
				{#if showJoules}
					{convertToJoules(energyToDisplay).toFixed(2)} J {isEstimated ? "(estimated)" : ""}
				{:else}
					{energyToDisplay.toFixed(4)} Wh {isEstimated ? "(estimated)" : ""}
				{/if}
			</div>
		{/if}

		
        <!-- Duration -->
		{#if durationSeconds}
        <div
            class="text-xs text-gray-500 dark:text-gray-500 bg-gray-100 dark:bg-gray-800 px-3 py-1 rounded w-fit"
        >
            {durationSeconds} sec
        </div>
    {/if}
		

		<!-- Tooltip -->
		{#if showTooltip}
			<div class="tooltip">
				{#if isEstimated}
					Estimated energy consumption based on the average GPU power and inference duration. Use Qwen/Qwen/Qwen2.5-VL-7B-Instruct model for exact results.
				{:else}
					Energy consumption measured directly on the GPU during inference.
				{/if}
			</div>
		{/if}
	</div>
{/if}
