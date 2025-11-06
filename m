Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011043.outbound.protection.outlook.com [52.101.70.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882B52E0934;
	Thu,  6 Nov 2025 16:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762445128; cv=fail; b=PHpybSRVxQbpW4xClGLlPsZCPzmjIr1ITm3gQ1QajT9DsKofWSfOALZhLNCc4/T+DCpI4XxSXx/nmwBXQAh84bZS+TXW7D+UvY+P+FB6TNFg5gLXHXTSYc2de2u3fVfhlzB7oMG5aykCJi6TT8G2n2cZ7vldPwayANzCmisocdE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762445128; c=relaxed/simple;
	bh=UvuwgolgzFH7tKTynkLWFPk2EvR3KuO1LEafyE96Ty4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kcZwhk7XoLN8O3kkKAv6FwY29pmjxDjluEMi007tq3jWeB/dGPX089iGnih1GbASpCJzWsK9HGmTfmx59trkdhfvO8ARF4zTLRIG8m96jGA0EtSd8BqmNk2jI4n3aNAX5EeuuL8HcgTIX2gDLU6GuhkmlUDFW07s/V7xxepuyX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=fRW6hIT9; arc=fail smtp.client-ip=52.101.70.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="fRW6hIT9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tkfr7TQhZ16tm4EnwiTWI30G6CJ5vThTES26Xkp1eqfYdfR0HT2xV1Y3Rm8HnQp4OS9BTOtwKy8X8vzRn5cjh3+ocEmsbh0FnMFPrTLIYJQAZ9aUZIYvVUg4llTZHEV1g3C1mTPU3Eqr94qihU9qHa8Rfjlpd3upcV5hd/jjwYh4Q64A0y+H4xk0ZEGY4arbyJY29RA6Si249PIE7aey8eGHH3Mhid5aJ64fuC60mKKZvM11MZwVSKYYM8wj5bF1v3l7Tw2m/6MaqUyKeLhonUXqy0Z/Yb9ANY5ovmBZxhGJeTkE3djQLCXiZ/s67KNG9NmCpXiXA+aB5LpiOoqnVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=amCLv1hvaR2F0nU/BqvfI9e0H3aeVVgyuQQjWCzJ8d4=;
 b=QXCbhZnGTHn06z3IT1IbcItzJo4rujQvREaz2NRX6pKrdNGE3A4WFXZIlCTU4rCJ4f7EfidF94aV0S1evb3/ZMbdLpNiYEWIntEnlM5N6eKZwkdaXBOqLAp6XqIhVxVfVFUG3gzeGeazckV42Ao+CYtmywZAmAmP//kmMuLVxWy73jVFt4lOB7CA1A9PuqGrJqiNzCif/xqsIlnsid2flSiuN1ymMC5D5X0kS1aDQUtQPTI8gU1Sp48+kiybfEmsF81oPpge006LJYiQz9XxHJsk4SPQrJ5spL7TpD708fnr0ay7dU+jmqtCr536/QKx/ebz0I1g1+DkmTV/GmW7ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amCLv1hvaR2F0nU/BqvfI9e0H3aeVVgyuQQjWCzJ8d4=;
 b=fRW6hIT9jbGEy0iI6l8k7A1i7MzZZaWZkvSO/JWlKQxGWoMDph8UJnwi2PUjNXdom2GTYqZGxAsRd9m3N6VFhA5lcoq8C+gPMSzuHTl4B8AMEeGmCGffMr/IRwzm5sarVY5Hp3Li/lIJcHclKdJlrTSRaVGm5Bq1HtkB0YHP8PVlOMB8TEkEJEeXd/b1jnqMFitAW+rW3VMvxXw9NbwkXRY5RQx9gFglnh62VH6yifizkMynsU9Vms2tzMlcvAeXGtgGwXHdWYNPYYcbpCxP1r6WeDursjE5rS2dNld6QrwRHXTw7ociRKyaslF7byPClhT5AA0EDrYXcQ0Ys5OdFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXSPRMB0053.eurprd04.prod.outlook.com (2603:10a6:102:23f::21)
 by GV2PR04MB11304.eurprd04.prod.outlook.com (2603:10a6:150:2a8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Thu, 6 Nov
 2025 16:05:23 +0000
Received: from PAXSPRMB0053.eurprd04.prod.outlook.com
 ([fe80::504f:2a06:4579:5f15]) by PAXSPRMB0053.eurprd04.prod.outlook.com
 ([fe80::504f:2a06:4579:5f15%6]) with mapi id 15.20.9298.006; Thu, 6 Nov 2025
 16:05:23 +0000
Date: Thu, 6 Nov 2025 11:05:15 -0500
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
Subject: Re: [PATCH] m68k: coldfire: Add RNG support for MCF54418
Message-ID: <aQzHO6Ty+l1Bwt6N@lizhi-Precision-Tower-5810>
References: <20251106-m5441x-add-rng-support-v1-1-ee8230910d17@yoseli.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106-m5441x-add-rng-support-v1-1-ee8230910d17@yoseli.org>
X-ClientProxiedBy: PH7P221CA0081.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:328::33) To PAXSPRMB0053.eurprd04.prod.outlook.com
 (2603:10a6:102:23f::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXSPRMB0053:EE_|GV2PR04MB11304:EE_
X-MS-Office365-Filtering-Correlation-Id: be1b0263-b610-4a7e-a5cd-08de1d4e4ac7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|7416014|19092799006|1800799024|366016|376014|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IA5Ntnuekd7Cp+hfs0TVFyBE5C5iRhhfHEZnyitpDGej46/UN6lkBkCN6Z/d?=
 =?us-ascii?Q?H7POcJxitELU/kdiGywGqXwI7i4XmZAzjMCNGFyRBfHC2WADPqo5PG4Sb0fx?=
 =?us-ascii?Q?qPPnZ/mhvBxvkJa09AcpblTXhAfsa1wxq+7lC6G9AfDpm+MPNPKt2Ew+vk9C?=
 =?us-ascii?Q?/aHqwBJoj1DCav3uw+GZf/XVxHCMWELgU0u63cVc/mtuV9s4U5AY03fdK/1Z?=
 =?us-ascii?Q?m5KDurQ1tvb3vRJ+BMZ/XRq8HChOeboyqQ5R/JXFWqMWQTviZTflmoZf1eGz?=
 =?us-ascii?Q?d+aFLy6EUsfVdoatwrE/7igykLkNiP3T5lP17zFgn+7vuUcK/UUgnzMen9n4?=
 =?us-ascii?Q?mX6Job+R1PNafP/goe01+NDvKuQoOqht4FT3Pxg/40Dogq/PI3xjzaXqZMmZ?=
 =?us-ascii?Q?1gnvmaftrUkpy2kw3ocrAkK9VbuuYaTlxlnlYsqL2sbiRaCCHdsEQxHLDdST?=
 =?us-ascii?Q?pkSoIsMityqnRydAVTUMHz6WDDgcSOWaBb2Wmg0tlHhaGFRSuRPequme4AdK?=
 =?us-ascii?Q?AwUHkT/z/EMe0xOKDxZVPO9e3jXQXpE039/7pvsev5O98GeLk/iELxv8ZXKP?=
 =?us-ascii?Q?wyNGyhVxMHo5obXGXBAjfkidvDp0I+vJ3OxSiNKSWisWmy8Ux5gK52jAVCwH?=
 =?us-ascii?Q?OCue0vc92B6RigJgix7lttujmgRMn+H0+9oZXuGNLtzMYbhEs6qgxXy5jNhL?=
 =?us-ascii?Q?mbMl71Qy/eMo6KIpMxitdgAoxztBW6JSWRsVzkGqN6qSl90Mfa7cvvkdEwQi?=
 =?us-ascii?Q?zBCtMdx7TeXIGAy4Hz6ZWZB6ikyzAmeCbDc4U4gQ8DoyFpjcCdvS4lNI54qq?=
 =?us-ascii?Q?YsIyJZ0425D3L9P9r+dqnNV6nYvjB4ZK79vvVcjIjW8x16M29+Aq5tHmbMA4?=
 =?us-ascii?Q?v5QvwQ9yp+K1oLLCW2vOaHdkczH0GWrVwLE/ovGM994lzFF6q+euY9b+aj6d?=
 =?us-ascii?Q?SerB5+1HhovVJQKt7GK5wcTjqJVk3Ij6QNrT99mlInuXHjQiPHfhzVUCfKk7?=
 =?us-ascii?Q?jCqi4FLIXGV0GGm59Mmnlrybtko/lHZKQoW0zABEtAL4RmdhkybWsnOuJrBV?=
 =?us-ascii?Q?mQagvIUg7adwIUVNfvumHYYcZYr5hB60D5netT6gJVbspOMoky9Bc8PnBb1k?=
 =?us-ascii?Q?+e2x+zeBpn7Hq1d2seDvGnfd2Qhodzr4vRdr3bYEQ62wphYVVL/BtiyQELfN?=
 =?us-ascii?Q?pf8mxwtxMP5tZyxNi4a5fSEJw2f7kgfkCz6Pk3YtOZ4XlJ7U3g8DFP+vI9Y9?=
 =?us-ascii?Q?4gptxRxmPKVUUygD8vG4/Kq2gPUO8q2BEwd9wAgmZm/nNKVFC+n51CuGZNkO?=
 =?us-ascii?Q?h4mEoDM2AeWMzO8+gkk/nZenLwCR8I75dAPvXXf6Mv6P3XMWCbO6KRqSFCEr?=
 =?us-ascii?Q?Od4VIOry0tsH8JVIQodKSZn8IYVspB7N0HFC3r0YO66HIDrWzroNFjKFBFio?=
 =?us-ascii?Q?6QEK8AkLT1bh+ZCvhOTtof4ssvKuXuCzXm4e6BkHdMfldH6fOetSeZXaU6RT?=
 =?us-ascii?Q?vTLE8xXshEbVqLa29Gwapk1dTt9BfehXSf1y?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXSPRMB0053.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(7416014)(19092799006)(1800799024)(366016)(376014)(38350700014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3seNkpDVZux0Xj5WskwMkoNOLyW/oCqlEYdcj55xYvh1+kPwtOQexN4piKTB?=
 =?us-ascii?Q?sEQlx2DxFvsliO9omhkhM1OHCHKjM8xdKWV3qbRIBLKFNoIeSBwwnv/sN+CJ?=
 =?us-ascii?Q?BY+jYBMkZVEtf5PZ95i1PxgzjJIlh5+/kf3M4koGubvflnJQoGQ0MK3zFwqp?=
 =?us-ascii?Q?4pumXXQT/8sKvKhRlYEW+sW4XTRvCO952vCMimBHSwlaZfyJSw1dPzp9yBOz?=
 =?us-ascii?Q?b90zs+9jEiZews2uvkzxGdg+2mzGy0LYKIgfQ27taZypDnBBA2GRvvdfjWcy?=
 =?us-ascii?Q?7P3iOAEVaih1FJh0Ce06BQXTtEfkHxwMh4a/dhl9S5Xr7mXtifRvxD5JK+CE?=
 =?us-ascii?Q?EqNnwU7O9EN35SuolJWqh4nbfZ4yhmHThahnhyLa0NjZlbpdfVonixVhB/hW?=
 =?us-ascii?Q?ogs0VAliKzu/ZCCPlCyoGyrsQDPZVw9GJVZbFFCpYvW0FxrJ2eUNJhDKjr1W?=
 =?us-ascii?Q?VQE16Eoj1hV+YzIOsTlMNhTiD6tNghEHPVBv0+MMyDRP1olugGXo35NFI+q6?=
 =?us-ascii?Q?VdU8ae2pSocTohRJTRjiwlwaX9IJNpiA48zIQDG22B6mo2aiybAP++dwxlEl?=
 =?us-ascii?Q?a215akZZnotptz8mlEVWapz2h0NxdDaI62yFYdqff9TL1Krf7i32b/AMqnGm?=
 =?us-ascii?Q?1XpIsgbUojNu1fb2Slh3vJFomq55wFyRDtVtMxvJ/rC2zM/mZ7hdLk9OXzf8?=
 =?us-ascii?Q?uP90a7ZDIAWO7MiXYU0jgKkzYqzZ8mu4J8KyQoE1hFbmsck5VSJVAWxVRLOU?=
 =?us-ascii?Q?sJrJQu8xuuZaydDXWChzCol7icJLusC3OiaIIwj76nh3ywdliYlSblsaL7zO?=
 =?us-ascii?Q?BXs7uEHgWyQyJ/j+hvVAluA4CY4zJR61y2j9bhCRpd76C1tEkzSvNR2VAn22?=
 =?us-ascii?Q?RnFTVa48fRyj5d9qaYXgi2zqqJbUyORO00smsr7pZxaHpKxBQAzwSNlmiBeA?=
 =?us-ascii?Q?3bVy5qCVvmpPN0kBmJg3NwdpohABCtoN5DeUuG7CLM35XeommrkT2jmbamGT?=
 =?us-ascii?Q?MhqMRJHchVnsrENGcZ4YWPCeqIDTkP/hG1+eOngeDjS+1MtuvPTPGJ0mr7FW?=
 =?us-ascii?Q?nvfUFBO61f0KIxGP98AvDJztp/hpwQWylmF/iRnKWQFsBgyVsAgAWERSLGLg?=
 =?us-ascii?Q?iIyO5eNsyWP1at9Ih9omxeSKzyqBzGUCDGo5UVVzFyTvLc1KO+8uasrQ+sRs?=
 =?us-ascii?Q?GR5DrgPzlgyQ4MTUAzSVIoDq2Um7m6DazQh1Kx+o1jEKgheGY228wIaKjv/8?=
 =?us-ascii?Q?zA+ARr5YWXjNBCInHMIhIyzDJ1NZcobW8jIAcK4+bAH7pUAiqihN5Runuxdw?=
 =?us-ascii?Q?E0RwuCPB7UYC5bue12zphKkQXlt4rb92D10eqNaCixxF6xDnQddusKiG6jPe?=
 =?us-ascii?Q?QatFz1EWoOm/cbtQ2HMTwIKuHmIX6Rawvr82Jjvk4Z3uCTnFUTEU+V+FRASg?=
 =?us-ascii?Q?Zk2CXbo0hVlQCTPbzBeANjqNwa5ywWjod7eFloBTFmOjn2K9XCcLPcjdlcRh?=
 =?us-ascii?Q?9UiqySjhlUTDKLDBcRAMvonBvGGsQof5XjX3r8bAwLfqStbJiB4lO8BAl92g?=
 =?us-ascii?Q?MypBnz8hNxWdxWvKcoVQLQLMTjAUQaFxDODQH+pT?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be1b0263-b610-4a7e-a5cd-08de1d4e4ac7
X-MS-Exchange-CrossTenant-AuthSource: PAXSPRMB0053.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 16:05:23.4376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B250hx6ZeyGerc3RHuERpt61mvJGAcvwjQXFdE2BUqKnNBaCgSaSt1yPW02PKYEnWJsHKuniYH2QvDljZHWyog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR04MB11304

On Thu, Nov 06, 2025 at 08:10:08AM +0100, Jean-Michel Hautbois wrote:
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
>
> diff --git a/arch/m68k/coldfire/device.c b/arch/m68k/coldfire/device.c
> index b6958ec2a220cf91a78a14fc7fa18749451412f7..9d8f844e319a98f0afb79cceb544c2d3029482a4 100644
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
> +static struct resource mcf_rng_resource[] = {

const?

Frank
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
...
