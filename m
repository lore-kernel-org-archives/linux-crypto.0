Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013043.outbound.protection.outlook.com [52.101.72.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FF9248896;
	Fri,  9 Oct 2026 19:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791572571; cv=fail; b=jWpQRozI9lCZh0ULwWuynAuPVx7PZjIuANcKm+H1TJLCOtHW3dGf9KDYU+T5naR9v/pxEL68f0u7sjR06BMUGJlCcAd+F7q54541CDfNMTA7m7csNPPg/RfhiDN+O4F0Hu6mKoiQ+0QhJ5R6rKeoFtOtzNz1+y0eURLnA3hhMuQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791572571; c=relaxed/simple;
	bh=tnTwpeeQsQHxaioB44uJXFRJU5a2mOnKIEVpFvysZSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gCEQDEx+JTISaz19uBpG40Hf9wiRe7PxQAt7RDpA0z3ZWw/pO8L9AAA2Z0Kpov2vO+zPPWlYfZutSB6UxeUUAensYAgv/CM4vgql7dNVhd/wJMntB+UlEGOhMR4BgCywcaudgmkUEEE4KldCqZD78DQOTHmD++m2XtCF4p29kx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=Ch4derQo; arc=fail smtp.client-ip=52.101.72.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Ch4derQo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z6rmr9nbIJ2jfkIu2/V5Ru52ZoYxGkeHB4ZxSOBeaT1uNCqat3uogHuRb//98ZjO49ZIKdgp4Vn4B3ttFWedPWEatWJ2TCKIDkSyJX0ybe8EenoDFDkPOWbNAL2KV07QD6mlzE3sk298Z0MwRYxUr28zCBr+tzccm6Su3pEuaNhzTuCYIx5yMHt+9AcgPxG12v6dkuwO9g5kp2L2fkHQrCb01bxW0/gctIT+ovqEsmFsGeuaF6ragAC3CZZQzO+/wPZ9uIC63b5upm6g4prV8VMI+PechM6zJ5YtHfGN1J6Zd2aVXOWlRwHF31Ce6saOLetwHcSLbTmDoECAOfBgtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6pwBkqL121ELtmHAAZ6JNmWnzriQMi9EzzcY5eKTA48=;
 b=zOtSlMO5mrj0QJM952Q+COCWQYGpQoWbhyDgWjJmKIRrRqtSHURPPFlrVFzxU3RpmMxuSrWa0+eOfcdFyhFGATyy1uxAXObwqTYeEFypr3XqtvgRe6ag4OaFj5vbxGl0Ng97XZnBhOGae8e9+j0zsL1iRyE9rlk/DzN7A4fUTxtniHaoFfxt5pcGg+L49hwcPnlvgJ9tSgTCqy+pW/hi8QcA7R9SW1i5uCbckWhjNrt5ysou3nVWJci0L/3e5o9B+ZIBuYCMwdpAUxmpyoib3lcmUY9/wquQK32RGpMNdEPI4TagZi2eleyGFFVXBt8aXoNs8tz9Bo873SREPLYOPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6pwBkqL121ELtmHAAZ6JNmWnzriQMi9EzzcY5eKTA48=;
 b=Ch4derQo2/BSvEpNMqeXnYMG/gevWOpiMqASNBAvN42OGIb+Wrr5pD46S0uYRNLjMbWE2gu5VqCk8flUVB/HOAn36hG8IM0u1Bnr+L9qJ88hyf8yF5Fcqt2hZaqmoIFdor7hoGyEVxqloIR6L2bbjNM6fmvYVZvfcIF+hHbNikU+OQ5uRcTYzTWajYrTR4kaHhZBGAndnER6GropP44bYFIJcIYuR7fqDvUQeyEnp7nt+ykExoz0vi+lNeOK9+cxm3a0hwUDQ3OXC+g7B2UNONU4/LIxgd0YnjMCMr7DLPxfPQ++qXjJHQPgZHSNk85RFO7X8j4g59QiSBOCy9CZag==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by GVXPR04MB9734.eurprd04.prod.outlook.com (2603:10a6:150:112::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.16; Fri, 9 Oct
 2026 19:02:46 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0496.015; Fri, 9 Oct 2026
 19:02:46 +0000
Date: Fri, 9 Oct 2026 14:02:41 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: Vinod Koul <vkoul@kernel.org>, Dan Williams <djbw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Frank Li <Frank.Li@kernel.org>, Jon Mason <jdmason@kudzu.us>,
	Allen Hubbe <allenbh@gmail.com>, Ard Biesheuvel <ardb@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	"open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:DMA GENERIC OFFLOAD ENGINE SUBSYSTEM" <dmaengine@vger.kernel.org>,
	"open list:NTB DRIVER CORE" <ntb@lists.linux.dev>,
	imx@lists.linux.dev, Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH 1/1] dmaengine: change dmaengine_get_unmap_data() first
 arg to dma_chan
Message-ID: <ask6Ud7ps9A1Gkc1@SMW015318>
References: <20260922184527.2414043-1-Frank.Li@oss.nxp.com>
 <b40fa0d7-fbd0-4ee8-b99c-781d08c18838@intel.com>
 <asi3R24SY-Y2wJQx@parshuram>
 <67081b4f-56a8-4ead-a912-645d5f742fd8@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67081b4f-56a8-4ead-a912-645d5f742fd8@intel.com>
X-ClientProxiedBy: AM8P189CA0001.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::6) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|GVXPR04MB9734:EE_
X-MS-Office365-Filtering-Correlation-Id: b8a5f95b-d734-4e8a-153c-08df2637e79d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|23010399003|7416014|1800799024|366016|18002099003|22082099003|11063799006|4143699003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	8qY1RUqLw3j61IbsClxyKdJt5AahMMkl+uMrXd18gN2ySjvKJ0ZVr+KKBOmQjS8iAzGQ3U/zJ+m26ABX5Gk/6EmWGvpfgDoj9GPLCUExpFEWFxxnnEPzWz+XwVODENZP+tf+Lnq2gizfSzsbIRSiCHLnJp6up/w1Gnk7Q/KLKmNmtd3SPcie0Nd/eq26hj1Ls7ZUkvk6rdI3qAs0HA3Q6RV8mbnwpyZiPBQpknu+7gxD7F5Scm6eDqNVSuQPNpXkzRBeWNiZRCjSTFUX8G2cBk+PGqhFemsEVeQqxYpj98RX+nUqRcHfnlEafNNzWw9H2xo3vCaWWvEVp8iZwE41U9hI0mYkPUhA/VJIg4N1XDRiv5y3d964pFBBVtwNfqF9a2sHVQK/Whd6xIfMKOVNBNkhuIwRkBodVsT+2HXA2NT3iGTj4LDsbZltHd8IQFkavSqT8G4GgimFUp5298i6fCcUivU11TTeMFquAn+qkJRiOOeWNG1RaxbxLIsXiyM/UPMLpq4CRrql1nKqEyscIsuiD3km9cpNdHhBBFHmNDEXZh4Vx4PwRmsrgWhVZUW2xuEIysvqmbKh7uNgiR4wIjJ1Q62udSM/OX7K2wiK0KEEzjNNpYORCGjV3pZHW9T+MK8J0xMPEsGmQKZ7xpxTs2kpA6u3/a7ALAqzPILabMs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(23010399003)(7416014)(1800799024)(366016)(18002099003)(22082099003)(11063799006)(4143699003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wx85GDS8ce9anhrQ+sbHWGjgvnuMBjhHGvoRYmR6GYzy+aS7wabmRN5pS85H?=
 =?us-ascii?Q?Mkrv0TW5/ZcLMR4jSUXTKdmi1v8lLBUzs14dgskLcm1htw3RWn3Kap5t3AsJ?=
 =?us-ascii?Q?lQOlS2drVa1UTpI1Yzvhs4lMNUPEc1TZ/Dh/Eqb9ihJvKxLMV79zhhIfahDy?=
 =?us-ascii?Q?7IfLbNpE0moT8fY9TD1fvEI6YZn63KPurfQr2bRhFyJ1wFZnnW9gTJ0DiAKg?=
 =?us-ascii?Q?uKS2yLmGRHaYp7GQeFQUuEKH1IidoPLcsPMGP0ED0qTxXNNdOuuTeK2jhtTL?=
 =?us-ascii?Q?A929G2rpHbXmN3fh41kcd/yzjT32CMxC6tO08Rm7tf96U4C+PNzsWgT41eZ7?=
 =?us-ascii?Q?KGNx+PBiBypUNLnv+JoLGV6HUb02fw9czJzYdtsg3i5kr4e7+Hl6C8podKRw?=
 =?us-ascii?Q?0Ls6b65QJG+DAAkhrvpOwTKguLZAbU0dQvTSrpmxYSRgpFDj1xSrIC1bqPl7?=
 =?us-ascii?Q?DEF/4YHIvzMk0kjELKJEZ141IJb3o+FC7kER4/AVtW5COjRGt2wYK21ZezLu?=
 =?us-ascii?Q?3QESpEGHQMvZCaLYM00GRfcUt/G5ACyzdupRNLbEBgxXIbb/ZDEpyC+OemIl?=
 =?us-ascii?Q?iYgZ01jAcxmBu3myCfNrGkef8anYLEdC+eSTQWFGo9E5QPSkKUoMQtau6jl7?=
 =?us-ascii?Q?HnroiBXry3ZIIwpywSDWw18GZzloqVJcsHJNLUoTlRTWtiqGDDtA8ggEVofg?=
 =?us-ascii?Q?/i4cI+0bLY7lYXYRjD1LpUHtdkNgIeZWxc3mneCgaoxpXCoV7vFs12jCp7k7?=
 =?us-ascii?Q?0dxBj/OmuWB34hgEpeYyHBcvpPbFhT2ZUOOfr+3BpAk6UTP4yteaLjOZ8z0u?=
 =?us-ascii?Q?gKAYujIHI0sAHJKOX5H1rWCmv5xTWk6giV8mHAr4b7szvbEjSgp5fWhpfoQr?=
 =?us-ascii?Q?HtbD7whbFOoH3yCzR/adeqnXz5BL8B9TnYIqYGVDjNTX//26rt3r4wI2T0NY?=
 =?us-ascii?Q?e0sABXiH9ZaT4eQ0zz4clTqBanZB1Wh9YoJZZeymYOtdTZ05LKTupVNs9P9O?=
 =?us-ascii?Q?vHXYBT7Nis829BA+pXRMGuxr4AEqwJQQYRC/gYc3Z0kl/uVQWrllRfMGIuKi?=
 =?us-ascii?Q?C5xLxpzGigzzyFZsoXQzGodspzPXnO65a815Uh7NUCg27mOuAQrvfoKIS70/?=
 =?us-ascii?Q?ebOqUEVSf4QcANtdHb4rbwXhjzB9ZUm3v1jb3t0TbLpvsA7NHlK2LHfCvVz0?=
 =?us-ascii?Q?ldtWLd0G4dfqGcloOMZ1ign7SHEe23kAyESjplKyOGr0LpqNAqQE9pWbTmQ4?=
 =?us-ascii?Q?upN8xVO6N7jR5SMyZ2AwPjwrfaSL0ei4stUS4xrW09FKhzBEiaYrnb8HcObq?=
 =?us-ascii?Q?0A0+fOfmTWYekHBxN5uYyxHLvmWKtKlsJAf+8W+lTIP3MEhk/gwlRbWO9kEN?=
 =?us-ascii?Q?shX9lzAXGwb5r5JeQxg0bOBbeB9XrtFoDyIqP9grdT8fkJL1JfWUMQbpM/Bs?=
 =?us-ascii?Q?Ul7a44oTscBauJiYEz5/Z7D5tuLaEWq5rfDCsvIVDRSw1SfJL/PbduuFPjJf?=
 =?us-ascii?Q?yM2IaqvY0jbUSYC42p86B1ivtbv4Ay4S9mNCWdTLVjy/u7U+PsctUbHXWjaa?=
 =?us-ascii?Q?xy67hkF355Ml/QeoSQLSD4414Loj5iAErxWScKbaarofBxi8KJvDB4eIhW9d?=
 =?us-ascii?Q?AQ+eUaY/8eJ5Onpv0NCHK6ZvgQMHYC4s8hVuWhWN41oQQBQtrjg/B021tSfp?=
 =?us-ascii?Q?cb1dz2L98WA8sA/RsvVRDbamnTQOofa0rw2mbGFf+XNT5tjhuE8albt0HqtC?=
 =?us-ascii?Q?T5sCbkIGRSqXidJs951vH/sX+zqxrIHnN8jL79GO3klrdwt5xPse?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8a5f95b-d734-4e8a-153c-08df2637e79d
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2026 19:02:46.2604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bbs6fxbz7zTUaiO0CRdgQcuasrlfPVFW8k7Y8aBOHyzM/79jKew0O637yFHT5fLFz9BVeQfox+OPsJgYC24Gf8B/721PzC13oFd2Z35wvp+NxKb5UL5hxuQhHVOlVnC+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR04MB9734

On Fri, Oct 09, 2026 at 09:19:43AM -0700, Dave Jiang wrote:
>
>
> On 10/9/26 2:43 AM, Vinod Koul wrote:
> > On 22-09-26, 16:09, Dave Jiang wrote:
> >>
> >>
> >> On 9/22/26 11:45 AM, Frank.Li@oss.nxp.com wrote:
> >>> From: Frank Li <Frank.Li@nxp.com>
> >>>
> >>> Replace the struct device *dev argument with struct dma_chan *chan so
> >>> callers do not need to reach into the dma_device internals to obtain
> >>> the device pointer.  The implementation now derives the device via
> >>> dmaengine_get_dma_device(chan), which correctly handles the per-channel
> >>> IOMMU mapping case.
> >>>
> >>> Prepare to make dma_device private and make dmaengine API consistent.
> >>>
> >>> Signed-off-by: Frank Li <Frank.Li@nxp.com>
> >>
> >> For the NTB bits:
> >> Acked-by: Dave Jiang <dave.jiang@intel.com>
> >>
> >>
> >>> ---
> >>>  crypto/async_tx/async_memcpy.c      | 4 ++--
> >>>  crypto/async_tx/async_pq.c          | 4 ++--
> >>>  crypto/async_tx/async_raid6_recov.c | 4 ++--
> >>>  crypto/async_tx/async_xor.c         | 8 ++++----
> >>
> >> Maybe one day Dan's wishes will become true and someone will finally deprecate async_tx....
> >
> > Does Intel still have use it. I am looking at fixing the names and we
> > can drop async_tx completely...?
> >
> I don't think so. Not since ioatdma days. Dan has talked about wanting to remove async_tx for quite a few years now. No idea if there are ARM dma devices that still use that or not.

Maybe we can create patch to skip build it firstly, let's see if there are
really user.

Frank
