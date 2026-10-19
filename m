Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.83.57
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792444807;
	b=LaSKrMtoZsW7muCMk8LUhdQebS4LWL7vVJ8iTRn6EPpkjqA8VCyQ1cNwMoYkd4XL6ggP
	 aQqTwRTdGbLtv/yQrdxr7H4Q/XSz5e2SwguRfZ/r6wtX67JEBDjNJDxMhxnMI8nm6BDJY
	 JDxtNn9tGk9uBI2AN5yicvvJ78qQExIJtFJvZrdcRk4cBMrTywBMhtPlgB65bUAcQ5lt1
	 qh+kHg3k57fkgsX7jGE2/jfPRPs0PKHuFGE6nWWSMqQojtDWdGXOLc98IwY2p96NZU9zG
	 wLMig5LkE+N9hOxUxqIF7o2hJsbkDM3+3twb7WOAOUtZH9KM6gxx0YnR4GVOrEfd7Wg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792444807;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=ir8MIKcH2aebFO471IAYY6bugg7rhVETTYD4GwPBFGM=;
	b=yUS3MHvKZ3gRQz6JS+1CZ6t3dzV48L8pSWqxz4GjWM55vfk2/9urOL4o+qmIck8j1bak
	 2G7EyvlTQB4t382OtKDKlSsWp4Cc8tFJJEufEfG1AFta0MGiVW/NDTK33/n30MtcPm//S
	 LJVD+L+heOwHhfHTtfdAYRd48WSdOslCmBqy4AnSwxXbD/8iHBvBe5TJKMyhcnBAVtBIB
	 0wwY+JMgVox7YlQZc2vpq3rXwXOmS0eEfLcHtX0BDLAhttp3eHLEfa+PIh36hxpUjDJvg
	 +YsYHZqtoHSxwnm5fj8n8G1W6euCvBw3t0CSixmmc8qBGX5xk8vodPchBxJtmnpKUCA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=M3hMf4B7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.83.57
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013057.outbound.protection.outlook.com [52.101.83.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E576606A319;
	Mon, 19 Oct 2026 21:20:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E576606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=M3hMf4B7
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hHBRcGBDO8ujL2EEJbZ858D+fj/HMloLbJK3Ot6aU0HRsQvn0ss8VkDdpTm1Z+hqjQ3snBdDG2eT8fRLYrwJwxVKAwHi+ZWBs73hbj8HsC65C9OIrK/vpuzvEcLYgq6PI5JLZpC1lyBTSIptN3kxdhHa8jgy9Ck/TbinWDJ/w2lEvjQVXDpJBp0eeQtfp0+ri9NoejgkB2CrHy7rRhPo3kJVkIPd3PFqEj+2gF8WoogYsCNUIjmmD/I6/9dfv7nhW0OXkoOO5SMfZJn2ScklcBuvN73eqid/KVXdG1PeOnw3TGwwLh6uWneMRrAgSrI3V0n9GZjHKzaQnBI7agnWcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ir8MIKcH2aebFO471IAYY6bugg7rhVETTYD4GwPBFGM=;
 b=O6BcPLmO5BTgvDZiV/k8VBksJxdkuQBDytaPQ1jc/XPzNUkh5D0rHoEOTS7mNnlzi+MjAj9tl1DLk/WxCWsEOmyhO9TM/cu3l6eqznh5TdhkKltlEO27jAJdxgu3cu3vZVgphqfRD72LyWpG3ZeCjMG9sGWgPPbmtXIsBPpe/NxLTLleVi79tEBRzNZ1dAVbmX+Veq92Wu83sE1Za9vWijIjihgrLFz5pJi1Ag06Q0Km6uRtcpd45yGeCqxXR+eY5zhqev1LKarUEXLXiC1HE08nq4p6/+zCg7YonJg5MVqd18qLv7QOa1kSS2Jvf7wrJJsCdAsRN/UoicoFQOvGOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ir8MIKcH2aebFO471IAYY6bugg7rhVETTYD4GwPBFGM=;
 b=M3hMf4B7VjRlXns1gz429B1vy0Ymaf3gJvVYTibpE4h2Q62jxgmq7cqd93NyaomVTVITgoHx6nNXvkp2KKy+yeMAwLaUibtboy+N7QOchy2WW1sXgDp4IeGPa6FgGZWATatrHba9oXSyeX2vCMrmy1kbJaBhAY43foZ8v+JrNw4GgrjMGNYW697URqZXgGjIoQWkzCIIVyndy6vrgA5+7+TlVdf0qX4BDqVwSBdIeN6svt9or0gNCDk0mAzZkhQmE33TTVciaHa0YMPdwdCc4Oe6Q6v/aCjmJGDeVHr52KueENSFSVbCbMtDON2kKPXdG6ibqpZCTHhsQqLUFCsrlw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com (2603:10a6:290:76::14)
 by AM9PR04MB8779.eurprd04.prod.outlook.com (2603:10a6:20b:40a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 21:20:04 +0000
Received: from MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b]) by MI3PR04MB12438.eurprd04.prod.outlook.com
 ([fe80::c715:c32:8bb1:b70b%6]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 21:20:04 +0000
Date: Mon, 19 Oct 2026 16:19:54 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: Daniel Byrne <daniel1.byrne@intel.com>
Cc: Vinod Koul <vkoul@kernel.org>, Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>, Dan Williams <djbw@kernel.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Frank Li <Frank.Li@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	Kristen Accardi <kristen.c.accardi@intel.com>,
	dmaengine@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 03/17] dmaengine: idxd: refuse a memcpy longer than the
 WQ max transfer size
Message-ID: <ataJeqa4jhxeKpym@SMW015318>
References: <20261019150630.4026341-1-daniel1.byrne@intel.com>
 <20261019150630.4026341-4-daniel1.byrne@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019150630.4026341-4-daniel1.byrne@intel.com>
X-ClientProxiedBy: DSSP220CA0009.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:3d3::17) To MI3PR04MB12438.eurprd04.prod.outlook.com
 (2603:10a6:290:76::14)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MI3PR04MB12438:EE_|AM9PR04MB8779:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e71b8c0-ec13-46b8-3a25-08df2e26be07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|19092799006|56012099006|4143699003|11063799006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Oi9q9V2plZ5G+h/6y9OVpetvCHqfB0YsYmJerZilQRXkCwz1DYtsKmtN3N3tbJchSnMn0AaGsvP02FjMJ5xw834YUT42FhTLuyfBABluQihSGu/OJ6z0FD1OuMAfuNnLr+5bX+dIbrCrc7AEGoqo0pElyC9+b2Rv9KxAMPyGuTCrpFMr6GfDVWcv3yNeTHb+/azJF5VA/mTiB/ePqm/CZ67R0B8iJlvaw9DLVyXyg0YjGhuVDqVLO3eMB0uGRnwDAO160sajckubfdG+gRGiKeo+1cuU3gTUTE8JOXVpAYOZcEnFFB0bydHHohD7+Q06Gx3cMzF2IY3sizoKTLTOR0NlG/5Kc5WumrRNMPOleFd0x+Q1QsRovvYJTlYhADlgCuY6z3lp8OjxNDhqk2vOLyPSsU5+HM1oa6Q+3kbz6aXpWYYFz8VzfBMpZuBFMXVFzUsJHNUwDLH8SK3H55b7op6y24Z+56TruTsbB5CbKOdAHc8Dc9ojq0Gi5COlXTKm8eeKzNh0d9QgSWQc4XQpWD4iRG/FDFRYSPWXqIl5ZJ7H392Ak9XJrqXxEM/KTB+bhDy2ohDZXY3hhW6HOw9qPU/o71BWr6tkYlpyl7NeG4ULPz3BFfsoxgukyMe41ddqE/FwqeKNrPcbFc65JXa8y8cpWj8EMQAxbIHAKHfYIm0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MI3PR04MB12438.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(19092799006)(56012099006)(4143699003)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HXjAxiWIOScUQ0oYwHVLB66u/ZRuwMYomUXCxyMs6+u5t3xoSg3nuNCyNpLe?=
 =?us-ascii?Q?duM+yDv5d7G6XAKG5Vviht/XoC75N3oaQSS895UkUjwgBPQnSY0es+ydrLYR?=
 =?us-ascii?Q?H8tfTUUkF8j5Qg5iyiCSk8B5TuAnuO4pB9s3ihbsHY09pVOTDIol13v7pEiJ?=
 =?us-ascii?Q?suz0XNmuqDSCzBsHnLLObLCSJrW8G/o3PT/S/9LbnOZ+Q/S21z1OQ5949q3G?=
 =?us-ascii?Q?bFY+Nhbd+6wN3/SbjOoOj2ifyln0wStVoK137TFBS9+sgpnt3crEvCxscaOe?=
 =?us-ascii?Q?te8Y2Mw60plr4UVJIcWVqABGL9t+H3sRvEWARSRtpQbzFgo7D+cDQout1k82?=
 =?us-ascii?Q?tDaz7wej5QBWLNMfAVZQjiVDkTcshXHy+ymUKv7Hs2Xos4V2tgdPDcPYUV3I?=
 =?us-ascii?Q?zt7rMimeDEYfkZuM25YTibixH7RjtHzD7298dG1/3bev/GjrgDcB7oc6tvOd?=
 =?us-ascii?Q?rNdanBW/lD7CVDL2c22L02HtNAvsYnnK8XXIpJo3RfGnFGfLTwmSrZS7xxS7?=
 =?us-ascii?Q?+myfHSK21Z5Vf8NjO6suviZFs/YbzmmnVXcckJcd7C3zKwMIV3N1+PjWl493?=
 =?us-ascii?Q?mQI+ziovHOekwbWiVDKBwU/1Ji8kGTg0LajlvNNjQu5Sh0+iK3flVmrUUV0D?=
 =?us-ascii?Q?hKM4XsUzkVZXFk3IrxATpyD9haP4Gh6G1orkQcyoDp86JZafbz7AH+8Z1q5a?=
 =?us-ascii?Q?02eD5PS5K1P10ZHQqxwAQZHMd2wnoW32ea/bBTRmMxvBqrKGqzYfKQZsoroF?=
 =?us-ascii?Q?eg6XFTec8VdhjxBE96FoY5oQgD7toiuPoO4wv0ZvUd0G5cgUP5YCqvUYiHFU?=
 =?us-ascii?Q?TYuMqT4igUlvtGaG3eNEcroOBjrN7pg5Xp9fB+PI9aodDOpSTrFTmrLutOTD?=
 =?us-ascii?Q?YaLYbhaGKAMYpfKT5a+59lp2gGNh1r2GLgbOjZLQMg6V1uQxfwl8sZ3TV7Dg?=
 =?us-ascii?Q?izfDcyvD1NEW9BUvlY4Zmyw8E8NMZyoBO8XDdg/4kqZM+xc9sRClsUAF+531?=
 =?us-ascii?Q?mithN5YRJUEbXoqojSs9WyUYD0q2he2FzWetYvQtRwVHBKlr5k1SAm/JKlDR?=
 =?us-ascii?Q?1DlCQYm7uLM6BqaFKNOcQ1f58dJfDBL1rsXQhW3AYHQyvI+qC6yGS8ClIkXP?=
 =?us-ascii?Q?SqL7bqA0WGg4zX8c3bXhIjUNocxyiWJTdZAXYIcN29t3nSpbiCmgm5qBlH48?=
 =?us-ascii?Q?hJYh8AJJIk2jXelw2TPsLbSH6DuDS63NwhyR0kEQiKA4fipQwfWVdQDsWTkY?=
 =?us-ascii?Q?rr0S0uDyfN7Ak3Fin3QEd+IGxoJ25JmInXNZBbJshm7tpZkiF22wHS5iah+R?=
 =?us-ascii?Q?DdzZy1Z6yAXmsqLsnYxFnbr2UpKDMxsguuCus3sZXejDI/Hny8AYnUfCwD2V?=
 =?us-ascii?Q?ER8i+xWWUP+2TkMkjGfRQbljIPFeXDHYFbwGolaEaJkX6Rn6PDKXF9AlY5Rg?=
 =?us-ascii?Q?oGY4sW8TnPIiNOlq+2H9EpSoHGO9TJltpQj94kHMZDGvvXBN24KTkqzg+QIc?=
 =?us-ascii?Q?2SKaatvML7Sw95XKXUbnms13NiyHlEnN3+KmSvaIDtXGXOeV9ITCPLQllYKJ?=
 =?us-ascii?Q?/bvPNLD+xAGfOWfM4F1G9S/kDtCpRviP0uCFaDmF65mi32hOxRO444ocYKdd?=
 =?us-ascii?Q?/ShAGyziRRfZ40ppIehSIxc6hN8Se72ldZch4WmFH3hfeuwCBgF8zc9xbYG8?=
 =?us-ascii?Q?a6f/etTfPMoR+jZQK8cAJ8HhC+IXu1OmsDqpYMfPKZRnV3QhjeIrvtRX+bed?=
 =?us-ascii?Q?Fa//ODLCSp7QhNpMaAkCVAOetcd3XxzyFxssJTYqzpzGWRFfAbfb?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e71b8c0-ec13-46b8-3a25-08df2e26be07
X-MS-Exchange-CrossTenant-AuthSource: MI3PR04MB12438.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 21:20:04.3491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 78wsOrYIJO0LdY0RNDWPCIaWmyqdMeKsdTEc6V9GlvSR/7a5fJ5lCOCeLFt4V5YOEhN3sBbx+YFW/YRl8CM/kA9PF+SvihxXCS+xqvQme+nxq1nE5w3QlovNpJGOlBZc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8779

On Mon, Oct 19, 2026 at 08:06:16AM -0700, Daniel Byrne wrote:
> [You don't often get email from daniel1.byrne@intel.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>
> idxd_dma_submit_memcpy() checks the length only against the device
> limit from GENCAP. Since commit d7aad5550eca ("dmaengine: idxd: add
> support for configurable max wq xfer size"), WQCFG is programmed with
> the work queue's own max_transfer_size instead, and that is the limit
> the hardware enforces. Since commit 92452a72ebdf ("dmaengine: idxd: set
> defaults for wq configs"), that limit defaults to 2 MiB.
>
> A copy longer than the work queue's limit is therefore accepted at prep
> time and then fails in hardware with DSA_COMP_XFER_ERANGE. A client that
> sets only tx->callback cannot see that error, so the copy looks
> complete. Also check the work queue's limit, so that prep returns NULL
> and the caller can fall back.
>
> On a Granite Rapids DSA with the default 2 MiB work queue limit and a
> device limit of 2 GiB, dmatest with norandom=1 and test_buf_size=4194304
> reports a data error for every copy on v7.2: the destination is never
> written, yet each copy completes. With this change the same test fails
> at prep, and copies of 1 MiB and 2 MiB pass as before.
>
> Fixes: d7aad5550eca ("dmaengine: idxd: add support for configurable max wq xfer size")
> Cc: stable@vger.kernel.org # 5.10+
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Daniel Byrne <daniel1.byrne@intel.com>
> ---

Reviewed-by: Frank Li <Frank.Li@nxp.com>

>  drivers/dma/idxd/dma.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/dma/idxd/dma.c b/drivers/dma/idxd/dma.c
> index 9937b671f637..c116416e10e5 100644
> --- a/drivers/dma/idxd/dma.c
> +++ b/drivers/dma/idxd/dma.c
> @@ -115,7 +115,8 @@ idxd_dma_submit_memcpy(struct dma_chan *c, dma_addr_t dma_dest,
>         if (wq->state != IDXD_WQ_ENABLED)
>                 return NULL;
>
> -       if (len > idxd->max_xfer_bytes)
> +       /* The work queue's configured limit is what the hardware enforces. */
> +       if (len > idxd->max_xfer_bytes || len > wq->max_xfer_bytes)
>                 return NULL;
>
>         op_flag_setup(flags, &desc_flags);
> --
> 2.43.0
>
