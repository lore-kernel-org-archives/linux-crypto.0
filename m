Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011037.outbound.protection.outlook.com [52.101.65.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49464734D0;
	Mon, 31 Aug 2026 15:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788191364; cv=fail; b=mN6wjReE409XjsMz6A/QXK+tHMGHxwBILychUOr7/GXhd8rmu5ieSA2L/eoDmZuxUSGgVsdumEbyLLG7X/kNVp5DF86N4E58295ldgI5g/JXWZkGPRRknAd7LSbgYj6kpN7+lv7t4FITHZhmi7e8NsWLZ8TcI8gQwKhhrwdNnWs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788191364; c=relaxed/simple;
	bh=6RoKtfBGaVl+f87oBDolsQGAfHEF5F4MsW3sYf6ni/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=R1BssK2k2NIW7wgc4/acluTFwTFeh1uK47p0zYbm/Z7LvhOMEhBDcm54ci0RsGS7mQjAyyKNEVydMl/Dvq6CmcEqGytH/LQsHUT2hdY918WwdCAu6boxZu/Wz3hzoBBccB+EW0K0PbRZQPiM63x17xMLthP7PNXW6u/REhe57Fs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=G6fLBkiq; arc=fail smtp.client-ip=52.101.65.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="G6fLBkiq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rMkQkNGHVzqYfu0hiOdcjtx4Qmbez03xRBA+DMS0BNAvd39sK2S3SCrJ+3wy8qKE79ynvrE8x5EAajBbpvf/SgqqHm7Dx5PNe/CqdTDJvlXWnErVfrvn7/8vzb3ntfwar9mBJAkgKLofwbECu/wXt5Cxof8rAzyUUjufGE1cm1bNm3qBwCMIxCWge5e37X9Ewd2YNHNA5SLHHYnD4XvUS0HMScxT6/fZk5fBFJHCwXcw9lj7kVLFCOu/BxkFZofi58GLwOQgXiQh00nXBLJV8BQqG/upG8eL6fQW2OJ4fxKHaZSejSFaxrU6JurU5VOSLGFYXxgt1bu7YHyhid4Wnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nd07ulLUhXNQUEAZCk3IRhxY2fK4nWO5Mv3sqOlEzls=;
 b=iMeVdcMLLEy/unrWpBnOA8YWNzvJvlIFydLSqrsYsh2DhKK//vUV37GF8++ep+QgE8hyKhMFPAUDLOnPp0mnNqYselSel2gJCWPsbihJWJ2YxX110YxxBjPJAAcC0wScMTAElOPeuVVKK7ZHC4XHSys3lUs9F/e6q4ej/o8UQaB25Y9MfgVuNaKUj5HRZ2WNxmcn/eEmzTD4l7QETJvlvZxQhbYw7B8MLDTe5uOcN0KIDNCbt6zKA0Z6fZkgWqRJ4WCSxg2U7gbBtY7YssSRtXjdzDpCYPZaaXLq9pa5CbyNPn40Kqo3pVLlVEjmkJQnbycRTnfx28lBae7lqe73/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nd07ulLUhXNQUEAZCk3IRhxY2fK4nWO5Mv3sqOlEzls=;
 b=G6fLBkiqRt/pwqGMneImJQDARYSiLOEq1qlD8TiModlunpfH2Xm0DRDW8Jy7Z3In7xSL1gE7dEtZ4FyxtxtC1mergjS8paNDJdaorjX7MeMmnIm/XuT0sD7LdBmHXB+DOhQDXvBlfrzRoHJdyqMk+BGLcr65wqBFCjy4eh7JtqsB4l8Lpck26zdrnQ2CJfKrnP5f9UWlXuu07LNY2o6e4473GRv/vL/+lOQ6kIxBKdMxSLvJzW26c/MMA4Rsm2V1xHMq/e1JgBkHtfeBqd5Jd8Nmm6FWiTzpSfQt4WBktVwTJ3+OIoRuUVbndENxSZidXndJtkPnydPFAAKX88SNgw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by AM8PR04MB7284.eurprd04.prod.outlook.com (2603:10a6:20b:1dc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 15:49:18 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 15:49:18 +0000
Date: Mon, 31 Aug 2026 10:49:09 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Frank Li <Frank.Li@nxp.com>, Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>, linux-crypto@vger.kernel.org,
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: imx-rngc: propagate clock enable errors
Message-ID: <apWidZ2gLboed5Ug@SMW015318>
References: <20260830131253.2718-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830131253.2718-1-pengpeng@iscas.ac.cn>
X-ClientProxiedBy: CY5PR15CA0097.namprd15.prod.outlook.com
 (2603:10b6:930:7::19) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|AM8PR04MB7284:EE_
X-MS-Office365-Filtering-Correlation-Id: 07511bc8-7082-49a6-ab7d-08df07776a6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|19092799006|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	rjxADxEKfEwXBZ6Ue5+BWgSIyjQz3ZFSCkcQ7/SDntWVLem5BqRVUFeva5R6V7KLU46ofEKsP7boMqeXaV5Yj2j/ymEHLR8jLLaFCXB3/LdTBjlUrVITdKcGUsok84QB9uyUMmHi6pf7P6Be73WNSGYuWoZxkt+EpTvnpPhkBokEeKCTohikIeIQ0CCUfXimonLNQZcsdiT1v2WZxrIZpPyOfKgkV8T6HQNwrEbycEPuEIHTHZC6ajJWjKSTlvSbBqmTKkDD4UyzueuY0+LcSA0NfMt5iMrHAD4E8ncGN9jYf8HiGRbJHxbzvoCM1kpnAbhdexymNUDLNaq6AgaGe36s8FHEsjVCW7KO+Eb06wOFC4oHqaX0Lo8Gch8xBTVFILuLfN7Gmq/Ycq5ExigZP6HVTYenYv4nK0WXJ1Hd/0ha3VQhDyjAD1dAXc8sLeO0LdCbIyuIOeR7cM3cfq+Sqc/MwozLSS/pREiSggeHRFTQJqMiA+qsuttoYnvwuJInnJVVDCmkp11VTetDtcfcvAR8HfvRdsZuonVYQY20HqcFyb3uqhaT7bCHux1PRVgOFuh08sIauETafNW4pRHpxe+hN2SIvL6nAq48HwCzZuAMO/zmnPBzay3x728ZOnP7n6RSx3au9+uQa6+rFtZh7Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(19092799006)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RNwMkhc6tPZXKtG1eNMPctDHmq1Rg8qZtKNvgy66bn2vQfvsffBP3nc9W8/Z?=
 =?us-ascii?Q?qPCXorEqgiy5OWG+YgE4rMTV/m4jUm5M1goamBB2omNB1ZQGc0dmDUKacuRG?=
 =?us-ascii?Q?Rbei+mtYf512tbe6wLs6VfaqWNXd8F5HYzdQkVH+tMgY1kQZ/lFcvh5fDgl4?=
 =?us-ascii?Q?9M4oObYNGVqo6dGoufoMBYAGUg4PfBJrjF9YTzIuzUHXoHDh/aji+UJJxDQz?=
 =?us-ascii?Q?rd43pQ9/TrL5AXnXkhMgfc23JmWbiPl7mYAVuDQ1RL7tsr3bfe6H++Av5TTy?=
 =?us-ascii?Q?eP6neuaZwc1iVfddJXQBIkc9CBx4DuIHAdrQzkHszkflckpPwd3u8NTAemfz?=
 =?us-ascii?Q?uEE9YyRouiG8i+S68YlZsTjOL4QC4nAj5XY41le8mpZ+mayoSGjq0wYW+4na?=
 =?us-ascii?Q?A0vKvfq4VLLN9QzVkPgZabzsIubMQzb8CiNr0wZJA+8P8/oHbFPC7k+9+LeN?=
 =?us-ascii?Q?hHzygHJ76laab14I5vvV7hPYwdmXemB86w1OAWdeaWutXDsQj3TxUotYAhyz?=
 =?us-ascii?Q?4EAMfuvkGUJ55Jr3Q2L6e+AoX4gPJQgKP9tFwV+l9YP+ThPSCC9GfWt6/EQF?=
 =?us-ascii?Q?JOYSBVvPtyZDOyIoE/E1klE27rNmnWkin3sMvgeDSgtm4p9Bs+GTgXLJiQ8M?=
 =?us-ascii?Q?+QAHlzCOo5D7I2I4Dc4iMz1ZjIwOjOmYI77B+D7UtIqDv+l2UuK0pkR8v1dJ?=
 =?us-ascii?Q?Px/EMI6SSYVRFVxkCcapoCLiyoWevciaY9W0L3Fvl9xDi/MW6ouTVSGLCWeu?=
 =?us-ascii?Q?MH3Iz+asOStaCTHzgaoQwU3Dybbp9+W+QtHv6r85+MVcw1hN9oFVTgbfJ+nd?=
 =?us-ascii?Q?WJtRVaSEAcBRSNEfR4SexCllzd9HlMwIJ4X447rtMJs4/rbvd1o30XxWTyM+?=
 =?us-ascii?Q?CDc+s6HZ23bG37zpB7dGIWfOxi/5Twnd0HGOgWfG2TNVQIXJDtD6tAj+OlTq?=
 =?us-ascii?Q?4gP6QVJFzIW5BUfFvs6WxWHOLHxXXK5MevOfZpcuIzk8L/yCBF/5UC90y0io?=
 =?us-ascii?Q?WD7l1xe74DLoJEwROn8I6QavB/xES4TA1qkjIx6DbBBHpMM7FIIK3Y3tJQhD?=
 =?us-ascii?Q?Gk/05ZiR4JAOEjLfRgza0CW9avY1X6Cfo3MkN5btqjeZxHOvW0D3T2HY7GY2?=
 =?us-ascii?Q?lDYgtWLImEAqu6cHONXeic8kUlr7Y2Z4+dChaXXCC7r/AsSVzbmAJcKfrUN5?=
 =?us-ascii?Q?GcGzvnCI3SmTu+l4LA0BNTI1Kkla6FY1DBCOm3KcnIct3nfnpfGnOWG1Z1/f?=
 =?us-ascii?Q?wMlKGhbbOWnMWOy4MSE87a3Krh0oLZDCn+KvHUViv86yx93mPT2/AxZY3lN9?=
 =?us-ascii?Q?9XsXldDoXszWo3uRP0DxjA7wdIxVICKtHJavpxvB8X7YNURkzzjyinPf1mFe?=
 =?us-ascii?Q?WhOYhfQFY47RtsxgkQ8ltuu7Gy82IVPhmYqVgoZevtpKZcEWf+MyaHDhEzt1?=
 =?us-ascii?Q?PL/yt2Z22nV0TSmrKo3q7SPxZgP2OcvnpEcM7ZOKb21/0mj95ldjaa4+ytmO?=
 =?us-ascii?Q?dnfINAMBfVYAxmbO6O4U1sx82tKMrAhktTY9P8655NjCxoOb8EV0YJFb5BLe?=
 =?us-ascii?Q?wWX17vIoOwF0dScmIbNNsfLKGXoyC0uTX+fSSOfewQsqR9ageCHdld4XKJCv?=
 =?us-ascii?Q?fMoWrCKv2JiKtVHzBCD7dxAEf0X64B90x/YYFn+PiDeiFie3XrJY1Srempc3?=
 =?us-ascii?Q?S8bNprY84HJ80Pupr85akPUozy48zfg+b00gbB0JWitRbDs91TkuSyVyhEW9?=
 =?us-ascii?Q?sI7KhKi2/QOyt/Gbi1qC8Jejhg1qXaclWN7IX1+I387igyez8y6A?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07511bc8-7082-49a6-ab7d-08df07776a6d
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 15:49:18.0928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fRexBhWv8SHLiT2PnqRB74Zi93XjZKQ8ScSx1JDogMCeoR17ohfmRG5PS8WSbhCba60XyB7AhTwzLgBG4Qa99OCsVSOxET/PRgBbv1PHyhubGu7+LK4F85v8SbcQQwat
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7284

On Sun, Aug 30, 2026 at 09:12:53PM +0800, Pengpeng Hou wrote:
> imx_rngc_probe() reads hardware registers after enabling its clock without
> checking the result, and the runtime resume callback always reports success
> after the same unchecked operation.
>
> Propagate clock-enable errors before accessing the RNG and to the
> runtime-PM
> core on resume.

Nit: wrap to first line

Reviewed-by: Frank Li <Frank.Li@nxp.com>

>
> Fixes: 1d5449445bd0 ("hwrng: mx-rngc - add a driver for Freescale RNGC")
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---
>  drivers/char/hw_random/imx-rngc.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
> index 7693328f10564..00a21d62c79c3 100644
> --- a/drivers/char/hw_random/imx-rngc.c
> +++ b/drivers/char/hw_random/imx-rngc.c
> @@ -266,7 +266,9 @@ static int __init imx_rngc_probe(struct platform_device *pdev)
>  	if (irq < 0)
>  		return irq;
>
> -	clk_prepare_enable(rngc->clk);
> +	ret = clk_prepare_enable(rngc->clk);
> +	if (ret)
> +		return ret;
>
>  	ver_id = readl(rngc->base + RNGC_VER_ID);
>  	rng_type = FIELD_GET(RNG_TYPE, ver_id);
> @@ -338,9 +340,7 @@ static int imx_rngc_resume(struct device *dev)
>  {
>  	struct imx_rngc *rngc = dev_get_drvdata(dev);
>
> -	clk_prepare_enable(rngc->clk);
> -
> -	return 0;
> +	return clk_prepare_enable(rngc->clk);
>  }
>
>  static const struct dev_pm_ops imx_rngc_pm_ops = {
>
> base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
> --
> 2.50.1
>
>
