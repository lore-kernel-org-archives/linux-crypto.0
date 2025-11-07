Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010049.outbound.protection.outlook.com [52.101.84.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC0E2C08BA;
	Fri,  7 Nov 2025 16:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762531643; cv=fail; b=bZ8aoqu1mQfjcpCVx/IIfJ5j3Ep3oek6AEB5DzDyEh5RwgUltC9IY+IhLAzvTNYvhlCG8eLAwDsWDcA342vFwtVmPZ5AlKYzHGgkO5j6rm+I+KNkRyw61N5VUPviaRGyTWuYNIPc5Tf8O7piEHiZfgUS2tZNZ3kVw05/hHXdQjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762531643; c=relaxed/simple;
	bh=aX4lZzAeMmLhy3/paUSOTrH6yWWzSnCN6eiDPbe5Shs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m7GPzIRBgbmyHIQGcMidSwN5LNxCull5StPwzM2JqK3LIWPMsx20O7AkMRwWrHGYCkkD3Vmg2Bgx8uc0iOUnm8n8aYhFo0NxKDuQx8mHRTSatqYrHotJ/vgSoWxyM+OufVpY0WuDqYSJbyCL3hLoIW9a0f67CtaQRZPiiIxpO6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=lsTi7U6C; arc=fail smtp.client-ip=52.101.84.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="lsTi7U6C"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vWMuu87uPJt71J6bAdN5jn81C7uUuxjT9wAY/1OK7qkVFqMqOYMtytZFo1I6EkfbaEioX1nQq/9Zst4h8iiheapSFv3s23cmuQ0TJt2nAUZWj4xHitrEPeIf+W1ZXEBxpQ7q8j21Qal+HmDAYEv+inIi5jkuAQZ7zQ7plC4H5CXEl/dPZZG0x0bfNJRqFYQfzaxvXXHlTL4rkwz+ZUDQxJSa6Ow+qbL3jfIDLnpXs1fWaZg6zwmC3jSPnIP9/qBKkAJbxkec00DqdG4KrKxoYkNd+TxGxp1NmZSVO7xSrRRUt5z5q63H6YuLQxnPLQrWeD6yf9ffb75CBjOdgXgcrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ignJJ/zs0uCbDy3q0POoF2zk9UX7LXrHcFu2an2F6pM=;
 b=nAB8NHOqKJ81+hGv0waudy4ewrMRT2djZ6g4iCF/E6Eh2lANyTXRwT7JyISAHztnuHM9sxhzyVWmyzwqQ4iDleCQgF/BL+0cUZXjexRLFaTkQbJ/DDe5vDzlnTcPm9+l1rk2yulYxAUYW0GRM2h6yeGWXB1bxFyXFSJE+lHEva4/S1lT+xTMgKVfcW2Hz6Sc9Pf2KdE7eN7p3XvBGVfFMqWQFXMLTIvG1KWGGFO2omfHhuhjuBqKbHQ4HwniwMJ66Yr7JLiV1p/wbM9ufmB5rgmb+xorc45TljG6MA9w3bLu2YE8fz+p0xm2CUvdoGUhk++0nbWzp30r2s3D5jzjZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ignJJ/zs0uCbDy3q0POoF2zk9UX7LXrHcFu2an2F6pM=;
 b=lsTi7U6CP1AgmOgCghcypqAP6v8BaUjjJDsGYEDIPLOhxTJsLTuGxn6ZY6SnA3EEVkVxcE1akoFdfld3wKpzrjf7+PrPcMAfQ95OjIgn6MgTUl3iWqZW0P2RK5ifRuaqzMZ2QVuwFF23B54VtR2jiL63LxfLV3GnUCH5F3d+gcU0SbOLWa/bX/RmTIm2I5q8WFEHOO5i7GxyYBV0unlESWfjnbGgcd4wHqsI2WWrBzIgWDsmQ3RhlA7ePL/AujAWcT91880AyAqD495WlXqIBWrESryt4IgcN9DmxLmyJ5VKzRE5yW5haktuirfjsySzrtQyKEstTUbF557H+sPoeg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXSPRMB0053.eurprd04.prod.outlook.com (2603:10a6:102:23f::21)
 by GVXPR04MB10110.eurprd04.prod.outlook.com (2603:10a6:150:1b2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Fri, 7 Nov
 2025 16:07:18 +0000
Received: from PAXSPRMB0053.eurprd04.prod.outlook.com
 ([fe80::504f:2a06:4579:5f15]) by PAXSPRMB0053.eurprd04.prod.outlook.com
 ([fe80::504f:2a06:4579:5f15%6]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 16:07:17 +0000
Date: Fri, 7 Nov 2025 11:07:10 -0500
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
Subject: Re: [PATCH v2 2/2] m68k: coldfire: Add RNG support for MCF54418
Message-ID: <aQ4ZLl5ssB/4uq2f@lizhi-Precision-Tower-5810>
References: <20251107-b4-m5441x-add-rng-support-v2-0-f91d685832b9@yoseli.org>
 <20251107-b4-m5441x-add-rng-support-v2-2-f91d685832b9@yoseli.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107-b4-m5441x-add-rng-support-v2-2-f91d685832b9@yoseli.org>
X-ClientProxiedBy: PH7PR13CA0016.namprd13.prod.outlook.com
 (2603:10b6:510:174::9) To PAXSPRMB0053.eurprd04.prod.outlook.com
 (2603:10a6:102:23f::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXSPRMB0053:EE_|GVXPR04MB10110:EE_
X-MS-Office365-Filtering-Correlation-Id: c958bbd4-d4ec-4f72-d199-08de1e17b971
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|7416014|376014|19092799006|1800799024|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nbAqEQApJfpzTmIs4zfqb3aUodaogG8LwfVnV5Rfg6IRCRZuN1jehLkuEYsg?=
 =?us-ascii?Q?dy0tjbuB8uZqF67CUvpC/TdL4Vw3ul9CS4ahMIOCHK04ZUiIlEA0T1DivPym?=
 =?us-ascii?Q?uSvUNQQqU83B13YHubJnXW9n5RmIO/Ag+If1E7pqmZ3MZhkqfzzLWEmq3fnz?=
 =?us-ascii?Q?11G48Mxdo8UpAFfoLUXQLnrrJwFMh9xvENBCFaIuFOQN9hWjnwj5omkwUyj3?=
 =?us-ascii?Q?tjqs4Cv9XV2oeUtWUUZ5VGMLwts+CjkF4XkvBcSuY5KX3h6+cbjvbMrBsoEq?=
 =?us-ascii?Q?OSL59OEF/peBecm2pFV6cUwl85u+weKCKR23c4unDzXoOk2ujNdS531KzoAI?=
 =?us-ascii?Q?kUPp7Ryt/Hjuyi1JNrqq11s294S10xKaSykIvjgDCDZZjfOY8wm62dOJsIQ0?=
 =?us-ascii?Q?QKJDVf2fYd2Hr3ZnDhmNSwfyQwTLLBYVAeOdDSOTZ0aXWug7q5gYKQOfrBRQ?=
 =?us-ascii?Q?zor64eOUs1llAPMH4rxR81kf3prIw4/LG8ssMoVtFA4T2Eztqmlssh4fqsAp?=
 =?us-ascii?Q?eDZPbDvKVtpSzl/jHJzg7U0fqyxwz3kLOax7gW6L5H2uQgLDseEfLegvmwoW?=
 =?us-ascii?Q?9cgE8OPMyGQ/vOYsptwBYpnPxspNN/rWRLDorgr25S1FxyUbCyTklYVRLUiX?=
 =?us-ascii?Q?+jx4qAXRODw1gaIsbGf+zyX12eHEDcVWbuUpJnUq129kIVsBfR5zqhVdatNM?=
 =?us-ascii?Q?eZV1RCr3XoCFdCgLEn1kVj+HJ5KHuSSifDo9sZ+atN03NcrcmmYQ3dRlwpQe?=
 =?us-ascii?Q?lU7W6EximC9V5a6yWHJT5A3J1s/3TF2YAybCQKuok6dTHrnwYayMxEKMBStT?=
 =?us-ascii?Q?1bEUJvNl1itEzcZSyoBWm7cfI++9l6x81uliNBrMUcaznQlhS5slHoT3MrtO?=
 =?us-ascii?Q?3fkiqub3qRoqWzsRf/d/Wy0IbU6w3am/hwQEeReL1D5oA9Gs0r/VVuJVdbzF?=
 =?us-ascii?Q?k0YJhQCHb4j2rtDv/q5mo0WC3bBsjDYpXdG/3tufVCZCQ05qGunpkcBGjHO3?=
 =?us-ascii?Q?XDrWgEkENegjy5heqFB4nGkkHyfaLDI2k0ZR3u3AZ6txtoF+DUT+4fQ7dCjw?=
 =?us-ascii?Q?ve7u3afVILGU2s06dsHHzAUz3jdx+7QfhO+7OPuUw5Ob6j8kTcyi3rOLZKea?=
 =?us-ascii?Q?3K0H1LykhFZOvfYq8+kjYNBupZQKeIHIapRnXU+BUTJyGgwjXBdmNG3AVruP?=
 =?us-ascii?Q?+2RFGyJOFRTlm+7gKpdSBI9ipE+nVmEMH7uvkJCVVeBL2+CHGJFBwvHnEfGT?=
 =?us-ascii?Q?x7Y8m7evxea8csw5vYNq/aT/H2ksVaHax9fc2MTO/1yIj7y6z5f1oKDb3VSN?=
 =?us-ascii?Q?oixAFQ3LWZhQOsWzqBkYELK9Zuj3yUPJTQkeKjhMP2Hi7KQHFgIxgId57P//?=
 =?us-ascii?Q?shhYlaVuE94vvUjJWsnhGegX7VJzcEDV9MjGsQayEYM9ZdmS5kkc39XaIhMB?=
 =?us-ascii?Q?5zJyRCJtA9RqVL1Fo49NIY+34hImCsTeeyLYVETYv2a6MDfO4YEWKeFzCIkO?=
 =?us-ascii?Q?tCiy6tM61AT+RWdvMYuOtiyltcf3DDbX8Mpu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXSPRMB0053.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(7416014)(376014)(19092799006)(1800799024)(38350700014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qTBS51/RpLT8aYQfAniUhwdNJFkVpA+i5doVn/PCe0wszCyjs8jOHFL6NEVo?=
 =?us-ascii?Q?frLym+ILBvekGm23TaPb7/sxaz16nKWJYwnvgQ1kxXIilWArNuCYmgcoBMYq?=
 =?us-ascii?Q?yIIRO+IfWKXZwMoNBpvEXfnnFtXsrcuQ/hyF/96waFnX8u2elBZLK9BDNQ8w?=
 =?us-ascii?Q?bE5ylADAdF5DtyAwOWmV8jQyBAVp+OJa9YYqOMmNyJI14F4ZzrtsY6jmPKv5?=
 =?us-ascii?Q?xNWpgIpCcoWnRBlu1Po6s0q/CoVaI+sLFtsjrtAFTbOoGvw2QLzc3rMXPj8K?=
 =?us-ascii?Q?Ex+uZMzEqnUvz3TD9mTHcWLrmUdG0MEkqZl+i4rD9ejqxIJ8Bh7eG3A295Zc?=
 =?us-ascii?Q?h7HOzkT7kYsWb0iXqLysm8+k87IC6gRVcQctUAMZdWR4bJlgXd1AyIrVhJtd?=
 =?us-ascii?Q?MvsYikGE+px41egpDgxn/vidlRGZ5NlIecfEOhwe3Nc8Yuqm1EEHrwnzK9z5?=
 =?us-ascii?Q?n4qjNBuYFNSc1swaDP1eHK0KUzzYpg7bAEEEmkxrFZM44uAdlaRB4Flwo5Q5?=
 =?us-ascii?Q?Kqw/AwvlGcj7+ghQY7O0nInfkzZjucKYSlqNNtpp8I8wftAugtJNOuvkuP+O?=
 =?us-ascii?Q?AtL1MhX5LvmV0ygQPXnuQt/rKs7x8CBBoLJZoTvcRdPJae1emMuAVb0Kl21r?=
 =?us-ascii?Q?jIkGYP8ouMhSkoVCxDdGM1Ab1C8dVaJ+B24U7WmBSAGyZe8iVUuSVTU9JlLW?=
 =?us-ascii?Q?SkLxfC4PkWTIHidpZM1WtxjabWMt+LfuhmOqJgHX/CWX1WLi1FAXlpqjkfw/?=
 =?us-ascii?Q?PGj6J5kfU54DfcUxPPgd2SHIWYRhOGwBcne0zuCirZTjUPEjiM4SPnvqiPDq?=
 =?us-ascii?Q?gL44o+qICO65fHNLL5CMtofQiye/25aBwoCXS1uX+yrSkDbYbRDAIKPLtmbG?=
 =?us-ascii?Q?RbsYSPkLyMivhWiW08V3E1sKip26pkWjPenp5AWDuAPHAmepn72T7KqZdLJg?=
 =?us-ascii?Q?jBQgnSxw80AtOs4GAPiuSLIRFzs4Nx/fLfHLU3TnISuXDgnVRlMCW8W+Vx/w?=
 =?us-ascii?Q?bqbyTNt61joCAqDNCnGYPT/T4wWKBMKsRXmGL/q3tktrd+V/f1E5TFUIWcbg?=
 =?us-ascii?Q?O1/5Gb8Pk9WAMGhmJVJIyQYUZ5FgXPmB1mI4IGqoqdPiDrHuym9ojmcbXlJy?=
 =?us-ascii?Q?0GBOJdr2+1oZAxkwYzdPMBu45gf4nFcA6kwItz8oS/DEzrqZvDZwHe/l13lL?=
 =?us-ascii?Q?1Le3fE7W/6PahiwXVwqQFeYX0P14LSZ4G4oQgYAWKOfX8V884vFUFONUvx3A?=
 =?us-ascii?Q?1m26hnVDzqgJo5Os6hDXUrXxVBU7i/lUrU68Q5cEqUGe2V22vuPAxkw0I/JA?=
 =?us-ascii?Q?EZ9xw2k2YrV//wsUQaODIEhCUThQiIkUd2zsXyRygrdjmrSnpMapsTZi240F?=
 =?us-ascii?Q?MALIE9x+WnvQC0ed0iYz2Jldl+9cnrmgnckKseqcY/qI8i/hrvMSfx+/aCxt?=
 =?us-ascii?Q?D3PsNS1uwKrB6s0XYUeeDpEplL+yuRqv4JBv8Rwdr6bEIJRZsOQqai4s5+QK?=
 =?us-ascii?Q?BHeqDyUCuUA5vBztVYCQsCW4zyKp0xosksx3AX4ZPjexPOnNtA7B526Re/Jx?=
 =?us-ascii?Q?Yae9BAIuCpfTiszRTu4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c958bbd4-d4ec-4f72-d199-08de1e17b971
X-MS-Exchange-CrossTenant-AuthSource: PAXSPRMB0053.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 16:07:17.9571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w/cA4urNFENOKdbSk5aAfEMwy4ajd78Ywqt0DPbbbdDmJLD5CrvWkuhE+3GMz8yOiEgyKqvnMXV9ZlYoz5Qd6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR04MB10110

On Fri, Nov 07, 2025 at 11:29:44AM +0100, Jean-Michel Hautbois wrote:
> Add platform device support for the MCF54418 RNGB hardware with clock
> enabled at platform initialization.
>
> The imx-rngc driver now uses devm_clk_get_optional() to support both
> Coldfire (always-on clock) and i.MX platforms (managed clock).
>
> Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
> ---
>  arch/m68k/coldfire/device.c       | 28 ++++++++++++++++++++++++++++
>  arch/m68k/coldfire/m5441x.c       |  2 +-
>  arch/m68k/include/asm/m5441xsim.h |  9 +++++++++
>  drivers/char/hw_random/Kconfig    |  3 ++-
>  drivers/char/hw_random/imx-rngc.c |  9 ++++++++-
>  5 files changed, 48 insertions(+), 3 deletions(-)

Most likely need two patches, one patch change rngc use devm_clk_get_optional().
one patch update arch/m68k/coldfire.

so difference mantainer can pick up easily.

Frank

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
> index 492a2a61a65be8bd9e46b0a70f3e43703973512e..e046eabaac2d9053a5a4a98c6e3733bb19258e54 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -270,12 +270,13 @@ config HW_RANDOM_MXC_RNGA
>  config HW_RANDOM_IMX_RNGC
>  	tristate "Freescale i.MX RNGC Random Number Generator"
>  	depends on HAS_IOMEM
> -	depends on SOC_IMX25 || SOC_IMX6SL || SOC_IMX6SLL || SOC_IMX6UL || COMPILE_TEST
> +	depends on SOC_IMX25 || SOC_IMX6SL || SOC_IMX6SLL || SOC_IMX6UL || M5441x || COMPILE_TEST
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
> index 241664a9b5d9ac7244f15cbe5d5302ca3787ebea..44f20a05de0a425cb6ff7b2a347b111750ac3702 100644
> --- a/drivers/char/hw_random/imx-rngc.c
> +++ b/drivers/char/hw_random/imx-rngc.c
> @@ -259,7 +259,7 @@ static int __init imx_rngc_probe(struct platform_device *pdev)
>  	if (IS_ERR(rngc->base))
>  		return PTR_ERR(rngc->base);
>
> -	rngc->clk = devm_clk_get(&pdev->dev, NULL);
> +	rngc->clk = devm_clk_get_optional(&pdev->dev, NULL);
>  	if (IS_ERR(rngc->clk))
>  		return dev_err_probe(&pdev->dev, PTR_ERR(rngc->clk), "Cannot get rng_clk\n");
>
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
