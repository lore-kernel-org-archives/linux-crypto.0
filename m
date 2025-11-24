Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013060.outbound.protection.outlook.com [52.101.83.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A680313E14;
	Mon, 24 Nov 2025 15:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763998172; cv=fail; b=uOyWBsrVzalp3jb1aL0fg62ZVfWDENoCiwA5YkUDqhTRAeP2arS4SxiNylOg+ezZMp3U3L8ocEdmkK2qa++0YTDrgx5QJQph4Rm2HfK9HSbLc8d5i8rOcYfQ15pn8q615uk9El/crOFGkExWCt76uVS/6x9BybN9aodL/EE4WBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763998172; c=relaxed/simple;
	bh=smG86+7AMfkze3vf+hwM3ZX2jRffPZb5LFXc++ZvaMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=k9l3/tuujDyPHq4NYxoaOKo6/TJsWg5xhNCILAobb2IS3KRFg+PMtNlDpSdzF4Sh4oE+UnR5lzqOf4j1c/xbTQuGJLVjy3JMKZBMBC0dE8k53On6e1Td2AUHRmM9YDodVOHZ++El4lgo2lIIIuPUl9z1Xk5qzhb9w2mW48zSFY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=CD6Yrhiu; arc=fail smtp.client-ip=52.101.83.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="CD6Yrhiu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VYllsk+aVQPtBjikCK0C/mqbO7+XVYHbAL9lr+1EOFhP/t3QUQUAX0sK8q7SujGuIw/S/Jm810+IDoW54SjNYNIL16dcleEcFn0kKGcXOTCZDXuCle7CMoYwXUb4Kyf0zFxDSolgtngCDXrxkbLlue3elU/amp3vZhTCeODNqENYViu3Xo57ccDZebjz19HeMH6LWbsvUbcWojOufblOVpYdDwMJftc1FXwcRultbFxwqWpqe9FFPHc5fE+Ly9xlEnH8QwZS95kw0LIE4ETYTF5bdA9d/zTEgvzFl6XPIQdNOj6WUXvVl6VjvKl1Kz6orNWVxP9tDGM08gnhiU3DIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XSdiAzf7hH+3uyR8qUpcX0FBcfFeJk/ty2N1mjMWmqg=;
 b=BvXW4OAYBN4EcIMJ7kKqiMw1OTVOth8VvT0mPHLnwyN4qGUKmGqsh4DBW3AOLhN5Gqodm+fnxjGd4sIvBopLsDL212s1xYAXsFu7bXw003pi0j6RcoIlu10zzviiZ1kSWFe92TReUJBg3qPTaUHoD64yTUQ0fEJSLxo8+5DtiWp64vspzHuU5gbYt1maEMbKmFcGuLR3jWWvJz9RlBz0us+aiTRQQsBGr+VsKPVezl9+6imhglsyH58XQibwl03GOyQXF/yTIZPbgTVMVGb4SMoNntx6QQWAHQFi6hdAD5+72ZlFId4cxgMBWFBuIpdgpRu0058gU8xBHCCsrSDqXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSdiAzf7hH+3uyR8qUpcX0FBcfFeJk/ty2N1mjMWmqg=;
 b=CD6YrhiuH/KZnjNZCVCg7ndQKUhjjjElLdBNfJ4mu0GQ+My0/4deGzDHHb7tgzjlvI707oA2eAnZcPRAA/XtExwAwcIXUtldYIM9NyCjKCOXkQi/R/7HCVkVAgvSjyq0+AAr52HZV+i83cRvDmQaFx1WWzYohwejwCXFw47+tzdi+jQPk3QMihT4MT2YcRbgjmpl2aFX0BsnIw47pfpf1ywDm0nqRvMNU9uHke3+/QHVn7tPiWKhu4K8vkFtvg/mc+1dslOiw7jG7BkkXRUAPm1eK/Ug/sOvhrECUe9kp684dTQlKhKS5QWf9wrmZ9lWCjNmZAdM5usfvlBYXlUcWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DU2PR04MB8951.eurprd04.prod.outlook.com (2603:10a6:10:2e2::22)
 by PAWPR04MB9910.eurprd04.prod.outlook.com (2603:10a6:102:380::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 15:29:26 +0000
Received: from DU2PR04MB8951.eurprd04.prod.outlook.com
 ([fe80::753c:468d:266:196]) by DU2PR04MB8951.eurprd04.prod.outlook.com
 ([fe80::753c:468d:266:196%4]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 15:29:25 +0000
Date: Mon, 24 Nov 2025 10:29:18 -0500
From: Frank Li <Frank.li@nxp.com>
To: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>, linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 3/3] m68k: coldfire: Add RNG support for MCF54418
Message-ID: <aSR5zu07XOTzuf+n@lizhi-Precision-Tower-5810>
References: <20251124-b4-m5441x-add-rng-support-v3-0-f447251dad27@yoseli.org>
 <20251124-b4-m5441x-add-rng-support-v3-3-f447251dad27@yoseli.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124-b4-m5441x-add-rng-support-v3-3-f447251dad27@yoseli.org>
X-ClientProxiedBy: PH7PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:510:23d::7) To DU2PR04MB8951.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU2PR04MB8951:EE_|PAWPR04MB9910:EE_
X-MS-Office365-Filtering-Correlation-Id: f449601e-2104-467f-a110-08de2b6e403d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|52116014|19092799006|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Tr2uJclCF75QuptwUEbkhCxOgtgtyc3H1DBRQHOSbwsszIbscMY0XlFouAMh?=
 =?us-ascii?Q?i0br+KBaL7JtOc6X3c+TVfKLQKsSWigqAu39uvnQlJ6qgVyFwF3wogb+PXQ3?=
 =?us-ascii?Q?k0FUl9i7w2cvyWz7Lv3j/CTgwmpHCXhw1+TokeU2ht6WjBlESRNuiXBz2Kyg?=
 =?us-ascii?Q?+AbjJ+VI1ShDEnv1Wj+Lv0vDPv06tLRpj0KaHH4OmrqjyVI6bQrc6Mz3RAp6?=
 =?us-ascii?Q?cN2hH//fp7Xy1/sP18uFzIPXRJPBFW5m7iX8O9MN7+hndg821eDwv+LjdsO8?=
 =?us-ascii?Q?99/aURG3Bd4QYAu8sJe4Dlgj+zYlHr0i7VN2g5lYfWrWYQrWR5AQMa4wgjzQ?=
 =?us-ascii?Q?QSU23LXa84c+oxJ88gXxyPspADZS3qbOgOF96EyrFSouGU9FUXKXS+kZnOcx?=
 =?us-ascii?Q?AwfagfjuR95ugOYwQzATIwvsppkI9U/UIQE3oEdWxwk8uCqtywVsEe+jNiQR?=
 =?us-ascii?Q?hGQEisVEp3seynAvafhjH6bCItfHQ9cfZQqZzvZN1ddP2KkjBs6CtV2yRGC1?=
 =?us-ascii?Q?fT7yCEptOxIQ4TOwTkZTE2AN3E60v9Fnk5Jo+rOVmazKtqpl+R/VN3zmALUn?=
 =?us-ascii?Q?Z1686x/ehpIvA3faip5EyZi/sj3V0ws3nU3i7GJPPnA8DjGIUGt6safL3z1r?=
 =?us-ascii?Q?xbv+2FInw72rsFs053Ay2h5Wjfa4sQsEHo8Z+AXSSvJKeJrx2VwSRRDCWRUV?=
 =?us-ascii?Q?zzyZXxSSCBMVtiBdb29X2MTvGe94P8NAYIhxs2p2j1LUWlxd4saeHTSKgdBQ?=
 =?us-ascii?Q?bU1Rb+C+zYCkpO1lolDLJPDggjeQIHjiDBt79bBNoQGBc5xLGSlo/y4oBn5X?=
 =?us-ascii?Q?Li4GsUu7m6Ew003u253ikl2qXlJ4yPJukrjpF5pCHVReA+YWF4RxgtcStgIP?=
 =?us-ascii?Q?eXsgMC+qVPX0L+HtlWIbVFXqUegTf11LCdjq8G0+aeIv7HP59fL6mdbysGPE?=
 =?us-ascii?Q?ac4hE3qCH4LjuGfEBCSCEidhLoFiIzZ0A4Eeb8OpraAfSFewaZQ2gEl1dog8?=
 =?us-ascii?Q?menYnAq6UhcpT8BJQwPe+Juza6ejVTuzItJjM+HzKBx6zw2Ymf8wtdE/SLV5?=
 =?us-ascii?Q?LKMpHzExbqnxOwnIEe2hFiwIl4ciHEN0d6kxnQOHYLIfmTovrTuftCUZo86b?=
 =?us-ascii?Q?1qduG5mntzpgU3b5UJMfMnIw5MC3hGxolW8MBTM1WTHQliGCtCoOenM3Jcfq?=
 =?us-ascii?Q?hFB/pLWXr8/WDRlDwihbo2RJsojdB1fkV8hOUTWYO9Dza4VkLWkNv9YR6V9X?=
 =?us-ascii?Q?zAoVJ3mIRbHTrRQ98c13fJleqN4nSBya5ZC2gne5WkOQvmXzlaeuAd7E2VFR?=
 =?us-ascii?Q?2Ulv73h0GhYCDb4AJTPlzVJ997Avu+W7wNzh8IA2tLuJosqpeQrnVSeLGX86?=
 =?us-ascii?Q?lNILukTioi2Middn3ELHq0TDGVzvO2tS937eDLAzk8KusAwD7+IctiEIRJob?=
 =?us-ascii?Q?UDDdwE6izlgSajjfS61UsxB4cGllGlRhSOzw1eYKZ9Jo/cG6iPk7aku4CZlF?=
 =?us-ascii?Q?0m/W7wbdHiQCJznpMOqMJZMWD149UZ3kRa2g?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8951.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(52116014)(19092799006)(38350700014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jv+94A3obUxBv09PnGucuP/Eo/MZXylhGG6WOylTQWVP95Lh2hlg1K2tOg/M?=
 =?us-ascii?Q?cZaSVSyu6Ygsq7fsYimARvMm7Tnj3un0rISBZwE/g9I1C45GgNC/twbdTfyQ?=
 =?us-ascii?Q?5q6tc+KHx9xCa4loIeIgJ1y1mMMppSAaUAfakCCjQsGMpPNDFPlWxbiFEzFI?=
 =?us-ascii?Q?4TscYa1yUztfFLaNqhvesygOydviNPMIgkudf05h51OV2YKSVw0MblS4BBpy?=
 =?us-ascii?Q?bmPd0SAUkc6sPd0ZzUnkAMMEe1KXwiUPkXag2Y4WW3qC0mirOYhp4nAnQK5m?=
 =?us-ascii?Q?APZ37jZj0cdZZLgX6u6SD3byWJ/PjdPtmkxnxeKXHOyrj+fVh4ek8b5Ex6Zb?=
 =?us-ascii?Q?LJg95Mn3iJYWO68gBaIGKx1WCEk7BGmr3wYo9uO8mDwcF3+4CPVjWreHLd+/?=
 =?us-ascii?Q?ui8xkfEYyCAa4JTkzceqZLuqQhQiHFZEed3EkfTbwBG5rqWk5DukQBS5z1Kl?=
 =?us-ascii?Q?F7xCzW8JqlVJOwcjzUu//1kAMZGXxdLFdUw3K8fDUh/OsWN6Ms4k5MAIRERs?=
 =?us-ascii?Q?ujoeyoWCKoRB4B7ODXfMaq3sP1YT0SomxLj3LWctQHid5uGwJt1saIJuLrdW?=
 =?us-ascii?Q?Pnr1zvXxJYZFuIHa/rLXHyeJrPpgsgDLtkrDbi+ZxNVIUP9VyGuMgFC3MmgA?=
 =?us-ascii?Q?hfBsR5YaA84L7mctwtj+46IiyhqNVHV6REBDP3Att6zIbO16Ch/7Lyhs7QQ+?=
 =?us-ascii?Q?vluvb5KuBhaINa4Qkne4JtQ9peDVZJiEX17hX0H/PWLupwqpeEcnkdeY0rqf?=
 =?us-ascii?Q?6RaPA98p40tA+hzycGcuZJIerKfbUCCtRbgv84a/Z9DsE1YXrQz3mkZgn90C?=
 =?us-ascii?Q?ONyCX5YySiF229R5chTwnOACFyCMny+oNsrT3Iv3JXHmYdzmhQ11JN+qDEj3?=
 =?us-ascii?Q?hhsZIGBfZG3Buy6QeXYTmVCQfgzp/rBQPeBfIzNYyfD5aXAGZwekWjFDLpcn?=
 =?us-ascii?Q?2lCNrhpOIOrYcJrn1DwGWJcRFqFHw70WakUFKmO8PYoTi3ibZouzpb2QNAYt?=
 =?us-ascii?Q?CLNac+YE13pP4hoCF49KRPqs8LPfe/3py5wTyPaBZnAz+zod9gayY7SQEP05?=
 =?us-ascii?Q?pCCHX58UGp1GlWyzd5uZ4G2cpehOnf8Ps6oaIE87ZW1pgAUJXEobhrXPp/CZ?=
 =?us-ascii?Q?5j0AlKQ9V5LIBlr/by96UOVz8bS4O4FAFQPMjpuJhoaSBPm9nHQ+PIL3nU37?=
 =?us-ascii?Q?6VedBc37ZzeoytzdpbKhUEjw6b+UprTxsIW+7VnAHxr6y6lmqsP/4Ox78Q2J?=
 =?us-ascii?Q?56qg1p+mJ3f7RQvINaKt0LOx1qpb0+Hr1mtdiskRYg3p1XpYDWe+wFQ5rT4W?=
 =?us-ascii?Q?1L1vxhFXphiMsHj4IeDJ9lznsLbHgRDRMZzXMQFfqrV1TIKnqkzCsJ25eZk2?=
 =?us-ascii?Q?WAlbbxrkiFxpvbtJzOJGVPMPwYnFNKOAyc6xBz4jEn83QZ7zqEbP0YgSkFqU?=
 =?us-ascii?Q?HM61pLTquJlTAx/s9bLTOgh6C5cB46NFh1xFuFSvUeELfHjC2pUBlnFk+WWX?=
 =?us-ascii?Q?EMULFtab5PpIdicCdp76/lWvFPzCORVaq1G2opeHoaeCMEkpKhB+zUP2fNVx?=
 =?us-ascii?Q?B1EpIwNhZLSCqGttrq0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f449601e-2104-467f-a110-08de2b6e403d
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8951.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 15:29:25.8593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: utMF74rycXip6hpiBFO5dlH7Ys1Jc57oMmR4A9D5gvvRwrg/0RhPz1n0YGU9UxiKALwDHFL3m3YsJcp19Bz6cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR04MB9910

On Mon, Nov 24, 2025 at 02:04:08PM +0100, Jean-Michel Hautbois wrote:
> Add support for the hardware Random Number Generator (RNGB) found on
> MCF54418 ColdFire processors with clock enabled at platform
> initialization.
>
> The RNGB block is compatible with the imx-rngc driver.
>
> Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
> ---

Reviewed-by: Frank Li <Frank.Li@nxp.com>

> arch/m68k/coldfire/device.c       | 28 ++++++++++++++++++++++++++++
>  arch/m68k/coldfire/m5441x.c       |  2 +-
>  arch/m68k/include/asm/m5441xsim.h |  9 +++++++++
>  drivers/char/hw_random/Kconfig    |  3 ++-
>  drivers/char/hw_random/imx-rngc.c |  7 +++++++
>  5 files changed, 47 insertions(+), 2 deletions(-)
>
> diff --git a/arch/m68k/coldfire/device.c b/arch/m68k/coldfire/device.c
> index 20adba27a687029ef53249bad71b342d563d612b..4183929b0b501459da25d1b4cde7d77f19c3dc16 100644
> --- a/arch/m68k/coldfire/device.c
> +++ b/arch/m68k/coldfire/device.c
> @@ -622,6 +622,31 @@ static struct platform_device mcf_flexcan0 = {
>  };
>  #endif /* MCFFLEXCAN_SIZE */
>
> +#ifdef MCF_RNG_BASE
> +/*
> + * Random Number Generator (RNG) - only on MCF54418
> + */
> +static const struct resource mcf_rng_resource[] = {
> +	{
> +		.start = MCF_RNG_BASE,
> +		.end   = MCF_RNG_BASE + MCF_RNG_SIZE - 1,
> +		.flags = IORESOURCE_MEM,
> +	},
> +	{
> +		.start = MCF_IRQ_RNG,
> +		.end   = MCF_IRQ_RNG,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct platform_device mcf_rng = {
> +	.name           = "imx-rngc",
> +	.id             = -1,
> +	.num_resources  = ARRAY_SIZE(mcf_rng_resource),
> +	.resource       = mcf_rng_resource,
> +};
> +#endif /* MCF_RNG_BASE */
> +
>  static struct platform_device *mcf_devices[] __initdata = {
>  	&mcf_uart,
>  #ifdef MCFFEC_BASE0
> @@ -660,6 +685,9 @@ static struct platform_device *mcf_devices[] __initdata = {
>  #ifdef MCFFLEXCAN_SIZE
>  	&mcf_flexcan0,
>  #endif
> +#ifdef MCF_RNG_BASE
> +	&mcf_rng,
> +#endif
>  };
>
>  /*
> diff --git a/arch/m68k/coldfire/m5441x.c b/arch/m68k/coldfire/m5441x.c
> index 7a25cfc7ac07570ff15da3c55d080a717cf93a06..ab5b006372379294db3b522820de88137bfb7e78 100644
> --- a/arch/m68k/coldfire/m5441x.c
> +++ b/arch/m68k/coldfire/m5441x.c
> @@ -158,6 +158,7 @@ static struct clk * const enable_clks[] __initconst = {
>  	&__clk_0_33, /* pit.1 */
>  	&__clk_0_37, /* eport */
>  	&__clk_0_48, /* pll */
> +	&__clk_0_49, /* rng */
>  	&__clk_0_51, /* esdhc */
>
>  	&__clk_1_36, /* CCM/reset module/Power management */
> @@ -179,7 +180,6 @@ static struct clk * const disable_clks[] __initconst = {
>  	&__clk_0_44, /* usb otg */
>  	&__clk_0_45, /* usb host */
>  	&__clk_0_47, /* ssi.0 */
> -	&__clk_0_49, /* rng */
>  	&__clk_0_50, /* ssi.1 */
>  	&__clk_0_53, /* enet-fec */
>  	&__clk_0_54, /* enet-fec */
> diff --git a/arch/m68k/include/asm/m5441xsim.h b/arch/m68k/include/asm/m5441xsim.h
> index f48cf63bd7822fd53c33788128f984585c0c421a..dd64cdfcad3e810254c6854b9de5b6bbeb67b950 100644
> --- a/arch/m68k/include/asm/m5441xsim.h
> +++ b/arch/m68k/include/asm/m5441xsim.h
> @@ -198,6 +198,15 @@
>  #define MCFRTC_SIZE		(0xfc0a8840 - 0xfc0a8000)
>  #define MCF_IRQ_RTC		(MCFINT2_VECBASE + MCFINT2_RTC)
>
> +/*
> + *  Random Number Generator (RNG) Module.
> + *  Note: Only present in MCF54418, not in MCF54410/54415/54417
> + */
> +#define MCF_RNG_BASE		0xfc0c4000
> +#define MCF_RNG_SIZE		0x1c
> +#define MCFINT2_RNG		28
> +#define MCF_IRQ_RNG		(MCFINT2_VECBASE + MCFINT2_RNG)
> +
>  /*
>   *  GPIO Module.
>   */
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 492a2a61a65be8bd9e46b0a70f3e43703973512e..2f301e43db846c687a38377a164429818137ece2 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -270,12 +270,13 @@ config HW_RANDOM_MXC_RNGA
>  config HW_RANDOM_IMX_RNGC
>  	tristate "Freescale i.MX RNGC Random Number Generator"
>  	depends on HAS_IOMEM
> -	depends on SOC_IMX25 || SOC_IMX6SL || SOC_IMX6SLL || SOC_IMX6UL || COMPILE_TEST
> +	depends on SOC_IMX25 || SOC_IMX6SL || SOC_IMX6SLL || SOC_IMX6UL || COLDFIRE || COMPILE_TEST
>  	default HW_RANDOM
>  	help
>  	  This driver provides kernel-side support for the Random Number
>  	  Generator Version C hardware found on some Freescale i.MX
>  	  processors. Version B is also supported by this driver.
> +	  Also supports RNGB on Freescale MCF54418 (Coldfire V4e).
>
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called imx-rngc.
> diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
> index d6a847e48339b2758c73c95d57a7aa48eb4875e0..44f20a05de0a425cb6ff7b2a347b111750ac3702 100644
> --- a/drivers/char/hw_random/imx-rngc.c
> +++ b/drivers/char/hw_random/imx-rngc.c
> @@ -353,12 +353,19 @@ static const struct of_device_id imx_rngc_dt_ids[] = {
>  };
>  MODULE_DEVICE_TABLE(of, imx_rngc_dt_ids);
>
> +static const struct platform_device_id imx_rngc_devtype[] = {
> +	{ .name = "imx-rngc" },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(platform, imx_rngc_devtype);
> +
>  static struct platform_driver imx_rngc_driver = {
>  	.driver = {
>  		.name = KBUILD_MODNAME,
>  		.pm = pm_ptr(&imx_rngc_pm_ops),
>  		.of_match_table = imx_rngc_dt_ids,
>  	},
> +	.id_table = imx_rngc_devtype,
>  };
>
>  module_platform_driver_probe(imx_rngc_driver, imx_rngc_probe);
>
> --
> 2.39.5
>
