Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012042.outbound.protection.outlook.com [52.101.66.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACD01D7E5C;
	Thu, 15 Oct 2026 03:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792033793; cv=fail; b=a7TSQS+q/cmSxlKTVMQtq36MfjxKmu15hngqsuBwlSLTsrg2yxHEfgXePwKG4Q5ly4ZpHeF9nf+LLVsR3s8cIGLE0x3Q+tMixRVbpzsnP58dvszspKgF74pQZ7IDWkZf3CHSFCFEkFuOScoOd1z1Qv6KOIwDEHpY0ndRN2XMIr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792033793; c=relaxed/simple;
	bh=RS/a31wP5fS/VSFE6rpbIx/LHUTPbcX2FZFDGFT5nnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=X97pk4RzK213dyMNwKH20tA1itwd3nJaiCj9Kyao/QpbAKSho/GHatlAIFirF4rBmkP6nB2fwL9Flzw/PTWR1bb5zxOsqb7MyxRtpmzY0MHUAOrqBIZoIETRIoLM1ZdDMMCfX7FXRsp6IovDm8Y+C1B7vdxlrmxGOjsaLYSANw0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=dIISTuAI; arc=fail smtp.client-ip=52.101.66.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="dIISTuAI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RlWQCr4CdB4+iO/chZrmBGrqKSJ2qoTmhHEIUVKQCjRYJFanYGR4mc7weLfS5LGrvc1hT1pVhoI0WBMeeDpSI3XJZ9CjjFNSrZdC5SPaXGW4xo2GdEQNNabPdC+jp4FukihjzY1PS8NHkVvMkJjp2anoXYcIsuU71F6s4ToKDZkFQHxFicKitJ71GkejilEDY43yTFsJNWhfFQOUsUDXvhIqnUfraruN84w7PlXzILFi2xcqEJyxV2tPEF0jGchwAbnGm6mwelIS/gMFjuYSx95ghIKxnitGzSS+eWppChUs3M3I4LZlde77gBFzSABvjQ00gbr9gEdBqMln+FRUQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RS/a31wP5fS/VSFE6rpbIx/LHUTPbcX2FZFDGFT5nnc=;
 b=ylF8cnUnnspBptXnQ6tNDZrEfu9VdM1IESURDntBTMinav1vohDKI82a5Jr1NqCaH7ed1zmRfPsjpQHsrCHR49UN4F95Rm7f1g9TvtO28uFUUkMNGK5r9fmb/8H05T9CZs9XuBmQIWvKyeJdX28KrlQ9QO4Lo0t1ukiuPb1fo1xcVxA2Y4e8kr3XU0kfuiTMstNPISLwgI2hXsqhEGWai4yLMAncdLLUXMigWt0Nwrsnr2y6irHmhedbHfdXTcN6lNa0QhMYgauqT0s/fhr7TQu5D1CIcPDyKWfDLa37EjZ6fOSGDKS6F0PP+4H9foUXkI3QKc1N8o8RwuEzY4PUSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RS/a31wP5fS/VSFE6rpbIx/LHUTPbcX2FZFDGFT5nnc=;
 b=dIISTuAIu4xXYLW9c0ft282fRVitO2mmkmVfa0RIloWOlCzWxDtKGZavhUUpXlnwBtqQ7OC14AMp4+Gqy3M8so/cgtqrpOJd8P0ouZKJsk14nABqmD0DXcubuiD+qmEJKuxioe3ARqM+GeJk5G4hvimMdnZ8XrdEfT+lV4rKKZBWJOJC4fTw1OQqwzYPbH3PwTfihywUuRLofnE+AenLAiYjQ+H/9GSMcqOP2OPCB3bGTBFpCqyjgr96G0U75iG0Xb2xGk+2hIw/n/Ilbb8pYSjY0oWo5NvE3JmZ2T0LA4xPZGGBe38WTUr5uPYV4b0n/t7Rnf7EhqlrYcDywzVL6w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by BESPR04MB296854.eurprd04.prod.outlook.com (2603:10a6:b10:131::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 03:09:48 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0522.012; Thu, 15 Oct 2026
 03:09:48 +0000
Date: Wed, 14 Oct 2026 22:09:36 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: Peng Fan <peng.fan@oss.nxp.com>
Cc: Dan Williams <djbw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>,
	Jon Mason <jdmason@kudzu.us>, Dave Jiang <dave.jiang@intel.com>,
	Allen Hubbe <allenbh@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	"open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:DMA GENERIC OFFLOAD ENGINE SUBSYSTEM" <dmaengine@vger.kernel.org>,
	"open list:NTB DRIVER CORE" <ntb@lists.linux.dev>,
	imx@lists.linux.dev, Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH v3 1/2] dmaengine: change dmaengine_get_unmap_data()
 first arg to dma_chan
Message-ID: <atBD8Afm9Z9XEzPb@SMW015318>
References: <20261014190337.1718622-1-Frank.Li@oss.nxp.com>
 <atBAnIzA3X6PgB+6@shlinux89>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atBAnIzA3X6PgB+6@shlinux89>
X-ClientProxiedBy: DSSP221CA0001.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:8:3d5::13) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|BESPR04MB296854:EE_
X-MS-Office365-Filtering-Correlation-Id: 9037b93c-58c8-4358-d560-08df2a69c51d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|366016|376014|7416014|1800799024|10067099003|11063799006|56012099006|18002099003|22082099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	kJbR68B6A0Oxg3wDG5m1MVkHwPC93tyeSixxzN3VDYv3JQiFNHzTCK7LtGNMj2Srqox6aWXVm4vXL9B6Yq5YwjlDa/pc0Xn9AFZP6vJEY0NxGcxJsfjwVspT/j6ydYOo1CK/trVI/4BQckp3Qt4p6P6mzxfXj6NWQag3OfNDQY29VkmVcfHXCsVRl81ROU9oZgWDmyM8GNtqlvAHF04tu6zSIZk8DZbzoKQxhvGqJZyCZ/PmRfavTwg7ap6EVvXVNgUy6Ydo88/AhEjH0JBWprGFZn56JgCV1/lIVW4xOy61m6LAxcSMPYeDyowxzIOQo9qkMJCuxeFcnQiaKv+IW5b1UZnjQa+Qu0w4cTptx7GCkUHHOuTzo5vUP0aNsieF//fD0lG8pCHDAENwwoV2bXUzb32OuNwN8wCq/Jz+2CMXU/bAnc/R/p0aEXcXkw2vHK0Mq7bq5WtJuQPgykqrifrxwbAMrIqkK0k0vdO6gd1tdKL8oxw3E2MHaWY0Fm+IpDYC3vRZLAYvU527NZkHOYQIsn8AAq9ssqaHbapddEVwaoRKd8GGkXiKH/VXZpQPGS3DrhJzzmdPuxBrriUH1V21e7WGWyo06/1YknVZjiMnGJ180MRu6o8rXgRSfUyAWbOEcxxH6OOjiQhIQK3c6YErhjWczSTUKi0EB8c7VnA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(366016)(376014)(7416014)(1800799024)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YifBnRwWisCa/ZeP30QpSux7gmFXEfv9ahfJpgbriPPl3SbXI4vp4k8+ipQE?=
 =?us-ascii?Q?OM6crOuJU0tBWQ3ULlnz7DaqXh0SqGCjDLIkvDYhAr4TLcKxuPCUMzSXcGep?=
 =?us-ascii?Q?4hbhPfIxoqRDf4b+4OPER0grC3rfUnH8V/VV6NS8t5rbDt3AQl5676UiRAQi?=
 =?us-ascii?Q?f/LoLkgTmG6acl/5Ia26JdDyk87zfOfK//S0gkZ09dds/vxDPVwD4Y5DqcB9?=
 =?us-ascii?Q?oW6zunGBjDfPHgLXGIA+THh4T6jFmyZ8ohs7JjYqqXv/MwlQlcF/OTXw80fB?=
 =?us-ascii?Q?WR2BKDaAhagvwscX2ut7JTd0I08oy5nAuioD7DK7cjLlLQ87lXtlEJA6Fmzu?=
 =?us-ascii?Q?sOkkoMbpUIo/SxD1Dq7BcH3V1PcYuaz4qLXB8fUj7zXdiX8KAx/x6pBdje48?=
 =?us-ascii?Q?GU9h9XUxAU3Iq+76xKzm2CycmR4mHrrop4nU3pRAco+qhD0W95snxOh1r05f?=
 =?us-ascii?Q?NVePTfH4jN93mu9wxndY0MHvTgp4I19w/QmuzhYVkMVQUyh2EiaNlIc3wc+j?=
 =?us-ascii?Q?B5r13+G+KTOIq+R2d3fYzuctXzbXJnJYWNUqZUZlCGnkLnQyfRCjZhRk6Qiw?=
 =?us-ascii?Q?MOQMU6L1bZKEHGP/nttEVgPk68dCH3jJsLukz0JtpTjb5eyZ1W1bypX/Cva2?=
 =?us-ascii?Q?DXz3PeHWVdEF0R4R2vNOTmZl/NvzvM3Fz47+/U9LSMD5SaOgrZzEtgTbmFvs?=
 =?us-ascii?Q?BhjmtZZaPP/odjR0G7IO3oMpOrdCxLWhEoSV3gxbp/whq4h5ykzMM+lOboQ3?=
 =?us-ascii?Q?8sHlndJiSlDqXHiK7eBRedu6BUrKQAdbDMQ9vrBXixwju5Me8BAZ2Sxlf8gO?=
 =?us-ascii?Q?8sRs/iWiJ26pexHkvaBHU7TCSk7U/efSZIS23nXkxJdOyWso50MpQWNJV10S?=
 =?us-ascii?Q?dsm7Y1xbqCEFwB6YERqgrhVzBxJXHvUw80vwjQebpUy+9gQ7gq8iita+5Hhj?=
 =?us-ascii?Q?tISRw+ZP41ZzHVrEbB59DuiNRdGkn5S79bd7FLHfFLbRq948SPOK+MbKhKUI?=
 =?us-ascii?Q?+QEo/WFz4LADKZUKg3tX1L7+4WJimTB3gurNmeyoTXTS+LN3j1llmp2ilTDY?=
 =?us-ascii?Q?KnUhuXGNuP9hLoJkrwbK0b8MVqjkG2//tQtwkgvd4srGNRycLcSjFMG18t0W?=
 =?us-ascii?Q?GvMHI/F3+BQLk+tOSqSgFcA0DlYr0zYw/WIo7lzFYRvyyojaTkkZD/rOJ4nZ?=
 =?us-ascii?Q?gVWJ9tHbvF8X9B9s16AorShDfYZ/l74Fsslb7/UjuHcBbs7RnvWEP/r7wigj?=
 =?us-ascii?Q?+BDJglQoADi9l2LrkPXFsWD60HKBi19UHoD86WKcZlKPLgaCkYbE2pBng1X1?=
 =?us-ascii?Q?5jCMlsBO7Afs9HPqmh9/uHPiJzQ8sij47lNblxZBpwO/EfxrD7zGtYsnyY0F?=
 =?us-ascii?Q?H9ANJRWlKOK/FNV3OWSlQLTV/obomJwOqSjTjrn5dxwRc2fBmM7Y2lfYxAHh?=
 =?us-ascii?Q?QMJnabkOCXmSz2ATtgOQi9Ic1dXTAlQS/D+Vp/rrpiLl+1hZtGsW3AdgsGIq?=
 =?us-ascii?Q?OfEC9nX/40TvQCpoO/vKpw8dfSBM3dmI6Wjo0eB0tP1s9usFjxBwH3tKNw9D?=
 =?us-ascii?Q?Gl/eoUQH018kePctCkrJDnf8CVDTxeqTN1m6hcVZmVUoYk0ZqFV0i2nl1sWw?=
 =?us-ascii?Q?wEHmOvWFNIz1AjEEuTQhcYWc9cNX6QmEBMt/i8ZzfjzGZpwrYobEjzwynVHN?=
 =?us-ascii?Q?nRS2/4HjTvGGgJpnGx3AR0PUXhcw1UncDeZ2ny1K64UpyNb9lbFSLO0DlEbu?=
 =?us-ascii?Q?nxwOgy0YaCzAQKbVsE8EUJhnOTroyVe5Foo5a4iETXvDe7hgI6Ng?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9037b93c-58c8-4358-d560-08df2a69c51d
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 03:09:47.8618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rbq1TYzTrsnS/p/PUUc1Qr/crhvogneE5yzL34B9O1NOQK5+j8UHGQllLnPJPUg/8MXWVpb14BcX32frdNCoI8PV+5oy1HfFl+AcGh1z14/ng2FffuZAColIS/7T4zOp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BESPR04MB296854

On Thu, Oct 15, 2026 at 10:55:24AM +0800, Peng Fan wrote:
> Hi Frank,
>
> Seems Patch 2/2 is not sent out?

Yes, I also found it. I will send out v4 tomorow.

Frank
