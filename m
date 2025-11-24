Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011064.outbound.protection.outlook.com [52.101.65.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B76C314A7B;
	Mon, 24 Nov 2025 15:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763998104; cv=fail; b=VKDQqby4mu/xDlAuQ9mbCsLZ7VSVXxKwv/wOmygu3VVb3PysOBBCYmXiq8dSpfVBEkahE4azEkCObZTMNe2DbomQLYJyKX+oG5SqAQdrQHBDMQ8dxUXdGerE6C3Gg9Z5z6SkVVZWH1pRGmErTcnvBbk0oUitvCK4y6uHMskWgWQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763998104; c=relaxed/simple;
	bh=NHdsb2uMbw8K8G9gpxsyllkOKgqzecaKXtRus4mHpVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fBsnOhKgpCVR3Sc0RJiowN6bAu4ojgn0Oxk0byC/tw8jOZnE5alXJ6OsblQge4R8BX4iqI2HExce5gHKzsXcZEkFjuIVl22PdX3kbEjWlfwcc7zS1WQtSzn5TFcQC9N5vlElMv5o6GfDF5izRTsSPzFokB6XIzoO0mHlMym+X5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=PDMWsszR; arc=fail smtp.client-ip=52.101.65.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="PDMWsszR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D34MqUU0L20LtTlg8GSxG28LfoYFZJNXJ3xALazoIZ6qD3sHbyeXHXaQXkUFpzRiIopjptWdEZuowA/QHRQdmXqJlupo/XPChCYX0kq0iCjJrzpdy0F+5WCD4SDhRO+hlyREGGbcP6V6z0bnPO+T/mBjHqBPR4l51a6xYeJnDqM0cAdR0MWETMuwgZMFRxNJF4SctiSGzlFfqXm/JPiymfoIkLQ91NW332ruvcT/X3C5lqW5oEDQfDmQB9ndnrOu6Gmozpn60p4zVCsoYUeTEKZZ5fbPPdrKcS9DGZa9hdRKlcBgUJImDRL8H7FHJMe2Ah/spc8WVV4zSGdyUsJecQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8okQT4j/nUrcE4w8ta/1ombqUkljeXvIinqVSug4ckE=;
 b=OSV1RXssnr64PuyAYX60xypBJ7i+lxW78KvwhcKI2t9W6CFm3Rd4VbrB+MxptWg2bipR4IrwMyB+p/BGmqleezXnsUExfJOxRIwdPo6rqO9Tw458E42rwB0IskAibLJWbJcGpxbP1/ZuVaJotwn5M2xuEEe1d5mc3t9nmJkFYF9z2d+892LuyLtevHqKujtPwOY92AkCORR9keMMOHCLRtAye2QEaafl69Dg9ENNwv8SzPJOLdfMCsnmvX2tNhg3/ui0BqytL66Gn2Em0+vG5mXf10IA7+DHro1ebISWT5jHe3oY2WPOIKen6Idv+kgy4pruRPrAaLRkg7OSoTaPSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8okQT4j/nUrcE4w8ta/1ombqUkljeXvIinqVSug4ckE=;
 b=PDMWsszR3h44ZbfT9FqsHQ5ODUy90ckXZ6Gym4vMHNZDw4TgEPP+P1iP/XL+172RmO8zbKRecCXXLgb7wt1eAnAf8tb8RNsugwSYynH6M8zRYK+ezes03ys+LrrtJMKhX+OnUrPU4QNgajN9H52c3LlUvEZGGjraw+Hc5jorbOJDMzDeHMdSiOI/gzmlIFc3dCoED8fHMz/tv6gzchtpirlTN31F53s7nMv9tiTBFpUcvXSHSBoUvSuz+IkYHUMJtQzpMmUNz9Jlh3gs2DqHXaHBXilhzuXctipsV1FgFtkBebLke28Xnv2KnCEgGW3w+rKs0i0VNW7TNQ9OBsY5QA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DU2PR04MB8951.eurprd04.prod.outlook.com (2603:10a6:10:2e2::22)
 by DU4PR04MB10718.eurprd04.prod.outlook.com (2603:10a6:10:58f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 15:28:19 +0000
Received: from DU2PR04MB8951.eurprd04.prod.outlook.com
 ([fe80::753c:468d:266:196]) by DU2PR04MB8951.eurprd04.prod.outlook.com
 ([fe80::753c:468d:266:196%4]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 15:28:19 +0000
Date: Mon, 24 Nov 2025 10:28:08 -0500
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
Subject: Re: [PATCH v3 2/3] hwrng: imx-rngc: Use optional clock
Message-ID: <aSR5iI8ZgmJZ08Ep@lizhi-Precision-Tower-5810>
References: <20251124-b4-m5441x-add-rng-support-v3-0-f447251dad27@yoseli.org>
 <20251124-b4-m5441x-add-rng-support-v3-2-f447251dad27@yoseli.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124-b4-m5441x-add-rng-support-v3-2-f447251dad27@yoseli.org>
X-ClientProxiedBy: BY1P220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::6) To DU2PR04MB8951.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU2PR04MB8951:EE_|DU4PR04MB10718:EE_
X-MS-Office365-Filtering-Correlation-Id: c4483eb2-ed5f-40f3-7a33-08de2b6e18bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|1800799024|52116014|376014|7416014|366016|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Iu3aYZekrOWYqKT1jYAdbXxP+p5xrPnB/q09hwCphwed7y/QmUNFCl9KIa59?=
 =?us-ascii?Q?CkV/AsfyKLuUh6QIp5e/WuPZPKsDzprQz4Zgz3hyBIEG8O7IWnu21bhNxH98?=
 =?us-ascii?Q?8hJSE7vsUlGwgK1TgM1e3wOcAseogwFFolSL80/66+66cPGrvw7UEkszxDh4?=
 =?us-ascii?Q?Bfzfcpq7WvpXiMq2dabv1mN1+9KXdJWRg/urkGcExDdj8KGNVmP6Muwy+Z76?=
 =?us-ascii?Q?4rf+yKGykzysE7UI1GW7UBkSLj8zVI5YguWXQad5Pxg/4tyIKj9cfjPKVp6w?=
 =?us-ascii?Q?cdFBL5CR16XF1BbQ0gvb4D6Vr+mQr18OmVBH6LCSTdNHKzZmzcbchfPDoY/P?=
 =?us-ascii?Q?9c3ltcmUL7anREnXxarMwmVc5PR53TSq8uGf3qleSYevq040u090Bh1EtL3g?=
 =?us-ascii?Q?FrRMObOCES3r7NTTMnkTlAjugqXHxAnP4DwQTVtPbioy2oMhD0UXU2i8apU8?=
 =?us-ascii?Q?otqxm+vych2zKl2W22UrfBd1KU/p0u9j0OxMEWQB4IOHvERNUjRDQjK8S0hQ?=
 =?us-ascii?Q?63LkSAvppcEXr9XhhEgRgREspNZHHWx1SPNQt7WimC+EDpXtGLGv9p0XfPZP?=
 =?us-ascii?Q?nGCg0ecxqQuxUiiFLPkmrZUQqSjDYg1M1fXL/OGJzb3VZYw60oaca2ZLbtE9?=
 =?us-ascii?Q?gliRZNOAUJj5NTr62LLgdEOZxRnn5z5tapD0xWvf1ffBbPckWU/H7LSuF5LW?=
 =?us-ascii?Q?rH3CKwA0D9E6KjDuPKSCdMlhYlBTMHF40X7FMr2ruIz4QAT2cSDb09Lnur4Y?=
 =?us-ascii?Q?rKzGm/fOIvT0aanJmKNNwl91e3Cq/4X2KW0gTu6wvCTy/0q4cyUxZ4S2lN5j?=
 =?us-ascii?Q?PEmrZ5DWRXZbNeAxUG7SBQByQMItvxgt7/ITG4UsAVA+JZHenoySQhXir7ol?=
 =?us-ascii?Q?7yxsJT2q/4ILlHl6ebVNFiJUPDoZVnLEkUXCQK52YDKR334ebXhnk1qinvwZ?=
 =?us-ascii?Q?trz7pUtpnFR/LvAKDKoVBF/T7caUfEiRhuLYr0qdXZdM2avl3Wn1za2KxRQo?=
 =?us-ascii?Q?p0wOpXH+DqOEBX6NYCMFDoFpzl+83oJ+8gXalkL2V/xVJIB+DHDOX0hFoubF?=
 =?us-ascii?Q?W8dCOQxWU7qx6TrCk/jUBLIigDlV6A6+eCiahlTz6iiKojipMai+6pJMHGr2?=
 =?us-ascii?Q?4qNkThhOMInfTmXLl/XcCRcfxR+gu1R/VQgybY7E88HK/9l4jYmNPPkMNDmS?=
 =?us-ascii?Q?p4ic9Yshk2PKqQxxWhnFbdcnsgtApRymAxuLXF/Erg49uBP1uaM824Qb9nDa?=
 =?us-ascii?Q?gzeBDhDEvSVlYbBvoFPj3GUOvz9ellpL3ZE3dSrxNbR0XN0ZbNeA0Hlqa+Ko?=
 =?us-ascii?Q?hG68Awn9wkQqh30dhGLDVsieaa582VgWrFkf0k2m5fow14iJxsc5vjtZpaJ2?=
 =?us-ascii?Q?pG4SCjv5YIJQWaPjRpydqI/pIeRr38mannFNepIgDZFfb9AmIhHghrGzAcD9?=
 =?us-ascii?Q?4yOYTXJ5yiHJPpKWKZijEyPw0EtOl8Zxt27n8fpUqG1C2Mfyss5exTvCbst+?=
 =?us-ascii?Q?uG80mcF786lyBVQybQpvYpSyzkB6FMmJWv6I?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8951.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(52116014)(376014)(7416014)(366016)(38350700014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JJCJ8lTMA/OfgNXW3wky+RjtW7ipvQBhPFCMo7CNK/T3jw9CSwGWALCBppNc?=
 =?us-ascii?Q?rZOeP7aYVhx83pZT6vwiDDS/NOO31wp77UUrHGzPydLgVgHROYg4v4ksm/df?=
 =?us-ascii?Q?hWUKGOEp16YHWapLQDn/9eE4RsQoQzxVuoV4CkW1RQTzYGnkzsfrgJb8a2Av?=
 =?us-ascii?Q?afTOXY9dzSgD8+25U3f6JrXh3pex20a/Y8J/2wUVayC3auRPf56Ak8qFI8JX?=
 =?us-ascii?Q?GpHdBCTfto7KF/3l8zpL8X9WvSNqkWh4daeJrySj0k/NBNj1ynfzSHk/Q87g?=
 =?us-ascii?Q?FCHDhMyOtGIKAtRMOBdQhT6GO+Yf2mOXyyJHD8dYi1xsnAPNDY3BJql8thaN?=
 =?us-ascii?Q?qIDG4kmrrm1bxIUnf4Xm39BRCWM1kNL2eL+d01Jwc+EAyN2TZh/wYz/7K5Pj?=
 =?us-ascii?Q?XsdmoXpxvNwwPHbuppRBM38EmWoWk6TjkBJIoQkf4O+6Z8P2lMHxpzz8QkJq?=
 =?us-ascii?Q?WGu2QSBLv9gTRmJogkqjrxabSyY5NyGtWgGam1RFrwJz5WGGxGO5Us6IgOQa?=
 =?us-ascii?Q?K5nC4C1Kw5LFAvAh7fRYNVPsPDCVkYQXWyds2axHPbmVKxp71JSyvR3UKTxE?=
 =?us-ascii?Q?BEEoZuirGHbwXC1DP6U6NCM/EYz47JMXRpIpVZgMkTD/URQuHkGUkcdSpf1K?=
 =?us-ascii?Q?O6nFZE5uoXCqP3uikSOY7L9ie+lysNPJ2zxtzXrC52vQWWaXerCcxlh3ylL1?=
 =?us-ascii?Q?LReMfs3qR1uP4+Jf8zOgi6xrlej8nz99qjwYCPU4D8F93FOEsynoLcKgkDHW?=
 =?us-ascii?Q?7K+rfnXiImsEufyCKpeMVr4H6/ht55EzuGwaFES3en4Y9pvTpaFzTTY3u2HF?=
 =?us-ascii?Q?6gPPz0ilk6p3Tzla0wrqJXKWjkentqpHW5h+/T74c3wk9LN14eGhaJSLfCEd?=
 =?us-ascii?Q?WObqaRtkmMnB3qn/ognS3XL/Ou6gbv8AiN0/WH+A7xmjxNhxFNRFlQRjN+0y?=
 =?us-ascii?Q?giM0Kbt99IK9utFLNo0NJbvptbHvTfo3qbSpF+eWkM+/LIcUKLtBvGTyfcJp?=
 =?us-ascii?Q?2VoEIAMXQ5YXo1i55lFq9SlFV0TOshf//FojpQ/08ZKsRIPll2A2pjJMCdMZ?=
 =?us-ascii?Q?55ZSf6mR++BfzdD6o3lA7UOW03IbnUMU6Ks6VHEOEGY8u1/TgTDcmjKn12p1?=
 =?us-ascii?Q?+7aAlDpn0DQjxBU6owL7x9NXiSSBCJeqHpievZkSOsVKSHCqYhP8Y58vvTl6?=
 =?us-ascii?Q?8hAZxQN2F+YVsQCrhRKZz/+q1RWn6Y5pCn27MWieT2k61xAUN90d+OaoX1ZK?=
 =?us-ascii?Q?uojXR4yk577IQBuXW/VBs8LvDBR1bgw5wxi+IGKx1tkqya6HprYC30FBMKw0?=
 =?us-ascii?Q?EtBCNy5sg5OqWkVX8IIgpCr6Ub+ijrpu7EO4afN8xN3f/KZQCNuBH6mKn/XK?=
 =?us-ascii?Q?H2fAfa+I4dT4TUhPKmSm8SzUgEdPmekDjn8POeWV46h4tbCLcdKFJNmoR4wf?=
 =?us-ascii?Q?iAVFt/FEjlmznKCzbOdzmXJSNnkziPPMgzy9Y/M+Z2WdeR38e12u7V0wlt39?=
 =?us-ascii?Q?6sc5Hc2tLsRnPRTXeP6w+9le/LPxR3lwKcMfRJ1gnM5X/BMW7/BQyYrq57tN?=
 =?us-ascii?Q?XiCUeVPxcTkjnv2ugRw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4483eb2-ed5f-40f3-7a33-08de2b6e18bb
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8951.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 15:28:19.6780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n3TVeTm3aAeiqzJJaZwvRRzFV4TGv//F4P2ybeLURjkoJbR855BRqWQiJfW0hej+8fmJwm9jFr8FCz8IBKScCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10718

On Mon, Nov 24, 2025 at 02:04:07PM +0100, Jean-Michel Hautbois wrote:
> Change devm_clk_get() to devm_clk_get_optional() to support platforms
> where the RNG clock is always enabled and not exposed via the clock
> framework (such as ColdFire MCF54418).
>
> Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
> ---


Reviewed-by: Frank Li <Frank.Li@nxp.com>

>  drivers/char/hw_random/imx-rngc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
> index 241664a9b5d9ac7244f15cbe5d5302ca3787ebea..d6a847e48339b2758c73c95d57a7aa48eb4875e0 100644
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
>
> --
> 2.39.5
>
