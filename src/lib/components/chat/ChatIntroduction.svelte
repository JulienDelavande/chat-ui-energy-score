<script lang="ts">
	import { env as envPublic } from "$env/dynamic/public";
	import Logo from "$lib/components/icons/Logo.svelte";
	import { createEventDispatcher } from "svelte";
	import IconGear from "~icons/bi/gear-fill";
	import AnnouncementBanner from "../AnnouncementBanner.svelte";
	import type { Model } from "$lib/types/Model";
	import ModelCardMetadata from "../ModelCardMetadata.svelte";
	import { base } from "$app/paths";
	import JSON5 from "json5";

	interface Props {
		currentModel: Model;
	}

	let { currentModel }: Props = $props();

	const announcementBanners = envPublic.PUBLIC_ANNOUNCEMENT_BANNERS
		? JSON5.parse(envPublic.PUBLIC_ANNOUNCEMENT_BANNERS)
		: [];

	const dispatch = createEventDispatcher<{ message: string }>();
</script>

<div class="my-auto grid gap-8 lg:grid-cols-3">
	<div class="lg:col-span-1">
		<div>
			<div class="mb-3 flex items-center text-2xl font-semibold">
				<Logo classNames="mr-1 flex-none" />
				{envPublic.PUBLIC_APP_NAME}
				<div
					class="ml-3 flex h-6 items-center rounded-lg border border-gray-100 bg-gray-50 px-2 text-base text-gray-400 dark:border-gray-700/60 dark:bg-gray-800"
				>
					v{envPublic.PUBLIC_VERSION}
				</div>
			</div>
			<p class="text-base text-gray-600 dark:text-gray-400">
				{envPublic.PUBLIC_APP_DESCRIPTION ||
					"Making the community's best AI chat models available to everyone."}
			</p>
		</div>
	</div>
	<div class="lg:col-span-2">
		{#each announcementBanners as banner}
			<AnnouncementBanner classNames="mb-4" title={banner.title}>
				<a
					target={banner.external ? "_blank" : "_self"}
					href={banner.linkHref}
					class="mr-2 flex items-center underline hover:no-underline">{banner.linkTitle}</a
				>
			</AnnouncementBanner>
		{/each}
		<div class="overflow-hidden rounded-xl border dark:border-gray-800">
			<div class="flex p-3">
				<div>
					<div class="text-sm text-gray-600 dark:text-gray-400">Current Model</div>
					<div class="flex items-center gap-1.5 font-semibold max-sm:text-smd">
						{#if currentModel.logoUrl}
							<img
								class=" overflown aspect-square size-4 rounded border dark:border-gray-700"
								src={currentModel.logoUrl}
								alt=""
							/>
						{:else}
							<div
								class="size-4 rounded border border-transparent bg-gray-300 dark:bg-gray-800"
							></div>
						{/if}
						{currentModel.displayName}
					</div>
				</div>
				<a
					href="{base}/settings/{currentModel.id}"
					aria-label="Settings"
					class="btn ml-auto flex h-7 w-7 self-start rounded-full bg-gray-100 p-1 text-xs hover:bg-gray-100 dark:border-gray-600 dark:bg-gray-800 dark:hover:bg-gray-600"
					><IconGear /></a
				>
			</div>
			<ModelCardMetadata variant="dark" model={currentModel} />
		</div>
	</div>
	<div class="lg:col-span-3">
		<div class="mb-8 rounded-xl border border-gray-100 bg-gray-50 p-6 dark:border-gray-800 dark:bg-gray-800">
			<h2 class="mb-4 text-xl font-semibold">Tracking Energy Use in ChatUI 🤗 </h2>
			 <p class="mb-4"> How much energy do your chatbot conversations consume? The first AI chat interface with real-time energy estimates! </p> <p class="mb-4"> This tool helps users compare models, tasks, and strategies (like reasoning), empowering informed decisions. Even small energy savings can scale up across millions of queries — model choice or output length can lead to major environmental impact. </p> <p class="mb-4"> To make these costs more relatable, we compare them to everyday activities (like phone charging or driving) using EPA-based equivalents. </p> <p> With projects like the AI Energy Score and broader research on AI’s energy footprint, we're pushing for transparency in the open-source community. One day, energy usage could be as visible as nutrition labels on food! </p>
		</div>
		{#if currentModel.promptExamples}
			<p class="mb-3 text-gray-600 dark:text-gray-300">Examples</p>
			<div class="grid gap-3 lg:grid-cols-3 lg:gap-5">
				{#each currentModel.promptExamples as example}
					<button
						type="button"
						class="rounded-xl border bg-gray-50 p-3 text-gray-600 hover:bg-gray-100 dark:border-gray-800 dark:bg-gray-800 dark:text-gray-300 dark:hover:bg-gray-700 max-xl:text-sm xl:p-3.5"
						onclick={() => dispatch("message", example.prompt)}
					>
						{example.title}
					</button>
				{/each}
			</div>
		{/if}
	</div>
	<div class="h-40 sm:h-24"></div>
</div>
