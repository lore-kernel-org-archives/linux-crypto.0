Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013051.outbound.protection.outlook.com [40.107.162.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027DA47425C
	for <linux-crypto@vger.kernel.org>; Fri, 28 Aug 2026 19:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787946286; cv=fail; b=NWiyssu+WpGj1Sjl/wN5gDitxPEnKSPxI4oCYulsM4GDBJbORwQd7Abtxl98dkAtbUj8lGnBCNh9RefQvhHW4FavYrN9XsqOQn1Zx9KkxgxgY13mg3Moe/HhnL2fotwEcSTIPAQqWYk4xtd92Vp/s9/XKC2PmlkVOxsMz2xgU/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787946286; c=relaxed/simple;
	bh=sDyNB+HtvEMlLuiAJhm4TJolSQ40XyGoc0EkbuLdeyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=M1ebFK1pv6iFwp/Cj7exV0QVDz7O2s6HWp9hiBkUGe8Tx1hBpvKcp/ciiOAIHsNBsUHrpnroDRrAp1ErNp/XXDy0oJThbqj0Qu99rUiYOfS9Jnos42J/9JVRvMqLqAbBgzVfXNvdnGLJ66tWWc9KY1BofrK+IzWm1NuhEpxCgL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=OA7LBEEA; arc=fail smtp.client-ip=40.107.162.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="OA7LBEEA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hPRe3L4kZnBR0/0HM10inQj3vwz9kVvpQhm1HMNjafQf+ubCVgnynwyIc3WNY/3exsjdfHwNilwM+53OiuzpHFL5h7rvGAQsISQAQAvFxP796ydf6eGml58tyRH82yfj07PrEJc+Nk/o/GubDG4HPqK6+offiPGlRKfaOvw08PZXpdtVM7u1BaqiVXn0N+SXnwCALvNMItoqmD8+WmSq4pzzpYpuAvFk0PxiVtwJ/+ajQzdPy8tyy9Th1QveE9UGP2SM3r+UpaN8OV0bIwQagNGx/GFnyVRDrnafvj3BUGhFF/t8o3C3mK3XQrGKK/7PKWW/qv/MKr7fsbeuVRe6ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9825o/I6yia9mlNRuLhHSQ5T66nms9AmFKkTemw4XU4=;
 b=YJYc0ssFI+gwckqWq6i0kK2HjNZwwqOv+euXzxyMTu/1nOjYps9hzes/fSa4WHufwMmHCKzUjdB2lWFdDSNEPSvOkwY/nFBfv+HKtdbPPkw5s707/0F25NX1xkUi1nexWX8pOhtt9OqCnur86CAT0B2vbTtnunxPce8cGVkQqxECO95BSQUq2xAYODYI5VN99CMh7cLj+g4gV+mIf3ZG+WIri+T8iPlYmUaXFYlae6zZr+rqTgQkBttposy2UlstbpHb7QNA/7cr98Ztw2pjM/SxHwLOA7QnubHSBV+pUUQwD6TtwEKSpctyqAJpeX5jLaxoYuAI7e8Udb63iTDOog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9825o/I6yia9mlNRuLhHSQ5T66nms9AmFKkTemw4XU4=;
 b=OA7LBEEA6/v3mW9JU0dMf9T38ULBBlbjlrYbPHxjhhjKSvB5XXS54HRxe14wlPW/CpoeN7nUOYJz1g+tV2JufyHJ+l/l5eXH5r4QgddSCRQT3AdNRkumjOm0mUY8iZxC/45HwlsbgGuvIj8kREzg3zyFXkhk1wYOKFX14FcqUo08iQBQFKidOHWm7IeqG+OKELo4gF7B8Sic9w15IyqCkJXOB0+YcwSKSddi3uzQYNaLwE1eOq2FUfVrwZtm/H5QQxTP6WzcS0EvgzfyJuuIXVJ41ZCZwTwI+ZKP/R20G1osG8NhdRtwB7OPx5kxlYa0R4/jZUD0Qs5DkYMqyzAU/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by MI9PR04MB444628.eurprd04.prod.outlook.com (2603:10a6:290:85::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.11; Fri, 28 Aug
 2026 19:44:41 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0360.008; Fri, 28 Aug 2026
 19:44:41 +0000
Date: Fri, 28 Aug 2026 14:44:32 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: Li Youhong <dayou5941@163.com>
Cc: olivia@selenic.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, imx@lists.linux.dev,
	Li Youhong <liyouhong@kylinos.cn>
Subject: Re: [PATCH] hwrng: imx-rngc: check clk_prepare_enable() return value
Message-ID: <apHlIGM3_GHf86fK@SMW015318>
References: <20260828025423.2149304-1-dayou5941@163.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828025423.2149304-1-dayou5941@163.com>
X-ClientProxiedBy: PH0P220CA0015.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::26) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|MI9PR04MB444628:EE_
X-MS-Office365-Filtering-Correlation-Id: 714bcefe-8300-48e7-58c2-08df053ccd44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|19092799006|22082099003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	qvY7FWoG4Ku5XHhr29CGgxDZQnZ4Al+HTEeDYvoLZUP0qruJDzGTyM//0qRpLOtbP51jCQ6Hyakp8QO5XGcj5QwIxdxVp3o99gRWHsdWV9ry/wombw5v3AkG9Lzyq+OQNYuDUFImqjh6xLKy+atV+GWbIhrgV+Wa5GggGMU7nuUqiLu8qPfTaILqZy9Sqk9Y66IvcN2+a6PWRR6yDuTI7C8EiAVAeU+zatEZviXOS/anUFvVh3ZO0X0cETZs14v9JS0YCtx0lRZ+GVjZlPu7p/mj471fNS9Ie9UoyY/Mzr5HmdsY1F/zpJiLKYap36S9YngQL1wJtBQqfby+D74khFaKEQcldI2ENStXfAVJ7Dx5dGX93rfzQqpCQaFiebGKXU1Sp6sdY7ZGuFmk2az8VotTx82JfBxTNopQih0yWKEMPuIvXSg/i6JmOgXkmjbwzx/ueigt4H5nARcxutK57lqsgGqvUuzcvLJW/S463p24/pLEgFnF4CiEVffhh3gWzVwH7+dPr2+ypmlzbD0Ndj9HucNAC1LAM0tVRgmjO3SqZo4MV6B8fCi8NvcG00E3VcBRcyplhugc2nCwp+hyzvGqUqbXNTIV9r/DDmK+Gf7wiiJlBD4KsU3nxLFyseXFrT0Qek1MF1pccptywbNLrSrQuMpS9SXdJRkG+BvFfgw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(19092799006)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WEHDPGXp7YoTGUs774I9eOVwCyGO1L3E8BCWkwoddpfgQ6XSDURILvjAZHF7?=
 =?us-ascii?Q?8POVI+Dmb8hKElcOQFNgzaF7E9vCZS869S+moz30GNZMxySXZSL1ovOvkTDA?=
 =?us-ascii?Q?a3vj5Pgr+3VhrArJHjZ5gw/bNzn0efZOz2p9gBZ6lngtzqBCR81cxBpwriZV?=
 =?us-ascii?Q?Cqw4I1nzslm2IpbVZZIfbx/RlBoP3h2zhK8gWNCUzLAJAkCKolEfZnnTgv0V?=
 =?us-ascii?Q?0Zh72x/69127aipNr0jTbFVcYCWx8ou8XBgMcYt3GRu0tZUSSAp1zEmRE9sI?=
 =?us-ascii?Q?1bL+PW6TNnwNYgrRpL1bs7Wkr0aAbZMiQMCokjldJYH3K63KgPY6gR2+KS5/?=
 =?us-ascii?Q?ndNgvVRA7zIzMej97Ec6smOE9SkIatPX7FgVts1NXBYrrBJwOin9LFhUQ4Cu?=
 =?us-ascii?Q?Ls/D3QBihBrlNj/kn4zRc9wVK0H8q2Dyrz5Rw8umvVQ1C+/bEDRh96HvWKcA?=
 =?us-ascii?Q?Qjrnia/ztKbaDrwnr+OevkJhLDc8r9mCFGPCfF1pMDmFJ05KVXrKTm2UVM9I?=
 =?us-ascii?Q?zwyW8R0Ufu2Tz0G31mvKT/5beJNanXFCMJbA0jRRVXDhBFluEKTLYGtGIQEA?=
 =?us-ascii?Q?FSbbt0gDPxXhSPqgbIoWr6m+v+iLpdm4GfrntG0LlFv1G4Ee6enFtPQ+OOh2?=
 =?us-ascii?Q?2chZBO+2DxrgN7kqkA6ChfpGQ+SnfpP63B0N7Xb3hzROFBKekj5+jOAGQDc5?=
 =?us-ascii?Q?IjnvrMnFK7jFe4QiUbzoPRh7sTfBUjAyNAmX2ft+MpXnL4lQ9KEv7OT37Fj2?=
 =?us-ascii?Q?18X9UtdIn5FCGT6mpWWs8lrJENY+TA7I0gd4gGE7bj+qI9oMiJCRFmtc7nvQ?=
 =?us-ascii?Q?oCmKV2A0yB3YDq/cq4ffRaWujx0XSH5cxTF5QJa2Q8ZOZpwfWq5j38cAk0yr?=
 =?us-ascii?Q?pGhGdHBeOVHew8s/nQEIs7HwBERWkUkpXINdo82Xr/i0RwQiDwNpNwX5E2Kv?=
 =?us-ascii?Q?pjIBGpXGzqE3sE15uWl6kG5PMX+/jfQOF+tBG+i07u5FIH3MDv3ZBuDCE0zC?=
 =?us-ascii?Q?KtAc7P0CQOJZ0cQgqTiI372KRARSFWOhyNm3Sw0bRhHAUWkL+idO/ghCjokG?=
 =?us-ascii?Q?o5HAQuc+Cy2ZakaMlfL/oaRdCK49amlI2QNHGI3RPYMaAcCQkyV39IuRub7V?=
 =?us-ascii?Q?HNdhvbPv9M7nOlbVccOl5+K5no28i7O1jrCOvO2+bWntC+xYVSs/JR34tRID?=
 =?us-ascii?Q?YKDB+B/KyAEwcTJizNnKl5girLodQsZx1ad5zpxHZjokLQ6VmYtkaysDxIdq?=
 =?us-ascii?Q?+JPptMf9ZNrHjn/wtST8SIHiVLdII4EP19qitG0lybcm8jpO2er54sIXpa0C?=
 =?us-ascii?Q?SElX0aH2TyeMR/KunmE3eo90iCiLI57AeOo4oOG3ipSdv7JNl3daFWZF/iSp?=
 =?us-ascii?Q?EVMJ2o0JRRV+eQ42z0/CNGI2SynB62fa0X6iwNvoZzIciM10LOsVe8hh3vS1?=
 =?us-ascii?Q?5a0f0tQa2Eq5lBwKcDsKqjx314wo77I9OGs5X4UW5wgDUwylSx51Q+gKOM1v?=
 =?us-ascii?Q?tknKiBxUlOblW+kW3OG6prz7ujUe0m3sHR217hmU742VmD84CwI4FGMLoxeh?=
 =?us-ascii?Q?m7BThZKsnoKZP93zqthOLqbwZ4/xV2YgbLH2hpVl/dIE2tCVDvoWsFB621TC?=
 =?us-ascii?Q?GXGpg08YQVsRxjMhgtp2I9TEVBoa3kq7diLa6CHfQi8LceDWHKYRO5qBpG6h?=
 =?us-ascii?Q?3xMHMsmVMA56M65fl01HxORCmK4xNCrowElaV5S7YURWHQkXz7JxDAv2n9mD?=
 =?us-ascii?Q?OxSKSAoVWzYFz7kZb64b097MY1rJXcjg3zEjnzIAipbH9r0Iai2j?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 714bcefe-8300-48e7-58c2-08df053ccd44
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 19:44:41.2650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QJULQnuuXN9BbD+uQ8miSVH3Z1tBr6Px4KbmivwvMRGQA+Y/FAN7FfRHtjxlyqQDowNItSA4H22FDH5hTWXvqZ+xpKUF6ojMaYE/8odaamIMe+lCrwAzyw45jzr3UHtP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MI9PR04MB444628

On Fri, Aug 28, 2026 at 10:54:23AM +0800, Li Youhong wrote:
>
> From: Li Youhong <liyouhong@kylinos.cn>
>
> The driver ignored clk_prepare_enable() failures during probe and
> resume.  If enabling the RNG clock fails, subsequent register accesses
> or resume after system sleep may not work while the driver still reports
> success.
>
> Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
> ---

Reviewed-by: Frank Li <Frank.Li@nxp.com>

>  drivers/char/hw_random/imx-rngc.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
> index 7693328f1056..0545a1870146 100644
> --- a/drivers/char/hw_random/imx-rngc.c
> +++ b/drivers/char/hw_random/imx-rngc.c
> @@ -266,7 +266,9 @@ static int __init imx_rngc_probe(struct platform_device *pdev)
>         if (irq < 0)
>                 return irq;
>
> -       clk_prepare_enable(rngc->clk);
> +       ret = clk_prepare_enable(rngc->clk);
> +       if (ret)
> +               return dev_err_probe(&pdev->dev, ret, "Cannot enable rng_clk\n");
>
>         ver_id = readl(rngc->base + RNGC_VER_ID);
>         rng_type = FIELD_GET(RNG_TYPE, ver_id);
> @@ -338,9 +340,7 @@ static int imx_rngc_resume(struct device *dev)
>  {
>         struct imx_rngc *rngc = dev_get_drvdata(dev);
>
> -       clk_prepare_enable(rngc->clk);
> -
> -       return 0;
> +       return clk_prepare_enable(rngc->clk);
>  }
>
>  static const struct dev_pm_ops imx_rngc_pm_ops = {
> --
> 2.25.1
>
>
