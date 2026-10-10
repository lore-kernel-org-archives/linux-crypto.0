Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011022.outbound.protection.outlook.com [52.101.70.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE02389E07;
	Sat, 10 Oct 2026 02:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791599390; cv=fail; b=N8kAB4r6D75LzBfpCiK7d0rfBTZjWQ/+41qDRBFkhTIc7jlJiIwB4jBJYIdIHJiKsMrbjU3as3/ln0xCpU02QgNf8vImApJgLtvVwTrJB6oPtR3VXw+mAWZJt1BtBE5zbUt2cTIA93bBn+WadntuQhPe9WbznQGUk2VkcPGhPxg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791599390; c=relaxed/simple;
	bh=Av/ljCf6+gZw4B09XOhynEAXaknOgHpOTZzeIhPGdUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OkOmUb1x0apnjifOAp9NRBQoeiPjtlHayN985cXwC+fYexqu6taDEK5G3NyifuFHEORx4coUGyN/rl7+3CmGah6oLII5XBS+ZDhBs91Dg4KEn/TpvD+vmnr31eAwsGU0kLKBFGBrv9VivS+zOLgJYRRoHUrVEPvrdZQE6PcCknE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=OdtNeows; arc=fail smtp.client-ip=52.101.70.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="OdtNeows"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T2BZhq8ZCAzAFUXEZw52/MLJZ7RnRESFSSDwS4kyNF4HALdhbreZfpn0d3oljBR8BWIQip5Si4pAhhoXmh0YCDC6Ixf1DeLN/e/1iDuqSpM0ADqsFNRuY6qDdX9DFsMEMZdLfxHeseNkFGGuq42RVz4T+ZX000/XsaxWOEoOryBAJVUmXvBS/9dS4rcM3635ecfYeoiU2LVjY/A4sOQH59reE3lLrxgCLaYRUyLwGFlxq7Zn8dL41KTkg1uOVoUkdNPq9l40QzR/B2iEhiKb6wXYOSXRH8oxjFFChi0N56RF1SAoIXncLNGtflNTVR6rZ/R5yWrsDcQQ8oSdfMwRLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ppcdTlOL5X+HTEvLEuUDJo8QLFic/cYVwjWg23L1P+8=;
 b=i10dyNAJIAd67jFCLkm00jJDi/vRvDWNlUqJApQh0Tw5gN/I9v7mSymiQdeDP+pdxGyO2bsP49yKzq9GLmbjC2GzMfmJAVq+y5WpBTsBdrQvtFl37lnWjsms5VF07R60rwM79PfnfT2d8r4lv3u6zEgNKm8anaOWAPRgA0rvF9lIP0K9H/onJIdsVlr4K2SXqYCLq1Y4/576yAT2wPNrc7nr35QvnPnBBq0yw0Jsrg1kGjAQp+mzzmJ/sORTnEFcQ3ba9NfDS0M4afcMj4ZhhgW1sF/XcYyivFSd/ugYoukcq/tkIqL0kMEN+DxUDjx7L+EgkKXJQdEqE0pRUbe+xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ppcdTlOL5X+HTEvLEuUDJo8QLFic/cYVwjWg23L1P+8=;
 b=OdtNeowsbnOnsadCaeE0yFUtenz22n//eZ/iCFvadVuBoMEVQJRX0TIsvL9l2hyFq3N+vb+6MnZm/yI64mb+u0ZDRR2BXenEjWnrUbjKRBYI8LTuComQtxOfA17sg0YXb3IS3b25aMV8UE+A9sy0U2xAMVx/qkG0BLxnqcwHoMgW/IWFTSuqzk5iQY3Z9N9THLqzbZZKMVE2F5w1ESgKLVqO6EczhvUd7sm4nKLkqBCoYr4KDEu6w4DI2zg3QcJ15o/kRiJKGR+5PvwbRhTO8iJKZPyLiZex5fbvZsa+3DPo7CyppRkrh2q0g4+81W0oUHnN2+3FuZEEOH3yKHObIw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DB9PR04MB8315.eurprd04.prod.outlook.com (2603:10a6:10:25c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Sat, 10 Oct
 2026 02:29:46 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0496.015; Sat, 10 Oct 2026
 02:29:46 +0000
Date: Fri, 9 Oct 2026 21:29:35 -0500
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
Message-ID: <asmjD9pR2qIzAzDz@SMW015318>
References: <20260922184527.2414043-1-Frank.Li@oss.nxp.com>
 <b40fa0d7-fbd0-4ee8-b99c-781d08c18838@intel.com>
 <asi3R24SY-Y2wJQx@parshuram>
 <67081b4f-56a8-4ead-a912-645d5f742fd8@intel.com>
 <ask6Ud7ps9A1Gkc1@SMW015318>
 <1c913faa-06da-4b02-bd47-c74da54df0de@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c913faa-06da-4b02-bd47-c74da54df0de@intel.com>
X-ClientProxiedBy: FR0P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::18) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DB9PR04MB8315:EE_
X-MS-Office365-Filtering-Correlation-Id: c91b74f1-f363-4cd8-ca4e-08df26765999
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|19092799006|7416014|23010399003|366016|10063799003|18002099003|10067099003|22082099003|261009223027099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	AB2HdHPgVqlC4gY3eoZoaW+oMSy8VLad0NZBg5zJoOuOEsqghvXuLX3mvZPQMwsNQGbbyKh/5KWWalDnaLHL5uPNyKB9zrLdGKZMtnxXG07A326UQGHJCOs/Yvk5L2mEagtKKGrpBBGhO2GYsPslkySglWZxvRzlndGEgaIR0xduynNmYNMeil/dkNvEDsPH9o14C+5ei7lNhASNKkpQeDUhmAtwR7hsIBguBqucs/sld0krweXPl9ermzcn3CWEp8sgdse6ipMasbrTWZbZFlr+N8BAX+4WsVY/3McovU4Rc8CkBnUp/NUCKK1s7vujErCY17mXPteCVjgwJNQX0uPkbrgb9HxyXkUT1xR57ziN5rAkvqKRWfFyPnzLzocTU5xoFiD3huaQk5IBd02CYEA+tRFBY66nzUJuCVbXkJCJMxw5K2pbutg9QhAvAw+nGpw9+41NalmpUIsY0ODTSC7FaGDcwwSDYa4SOIH0LBJEJsEFY5sdjEIi0tf6REYoQ8rhoeEnka56LFEDKjQVdp8/pfJ1KSMC66K/DoAv5s5xojI3kbqBrCkUaeN63ZMHv8rJbteEqwOvsLsQ+SECo4aUiSPLGIuS87m6x8Nrh5k0U1j/9ojy8+uPXRXqRg+WVi56JgWjc/09x3ZYRaHvBTjGvfnK5dr+Etd5460R+mc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(19092799006)(7416014)(23010399003)(366016)(10063799003)(18002099003)(10067099003)(22082099003)(261009223027099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V4+u6kx04Vq65iqHibUVg9vImaytuyLcciT9Jvo1pXUCiD62bct8zvZmATaA?=
 =?us-ascii?Q?ak+4Bx0ck6iAo3AW8Hofat0wxrtygIvJCbmyKq0p4727sQHV2NP5hJ27Uh84?=
 =?us-ascii?Q?/KV7paKbGKmt+SbuzmjZrKqzfIH3J2MXl0LtTgfj7AuOgIXZLsz7Twl7y7Vx?=
 =?us-ascii?Q?2h/Gzgstzz1+/8RAf5qwvZM4uxWbz75WBn5EKZN3mjRu9vhwRs8ICIab/Kkq?=
 =?us-ascii?Q?GNMDvWbt6cmLZem4P61Rm6zma1ysyJ6nYrd3eKgTJUiBBZNNlYPlmHCaajv0?=
 =?us-ascii?Q?7sO7WvIOXUzd15Hh5lF6wNcKIM0wPHUH5nqZXWKkypn6ZNTr60XIe1Ym5vDL?=
 =?us-ascii?Q?Ooz45G6rL7FaQvZ3r4eb74OakIlJd4/sQdsCjsoU/36Q32rS8RuEVrKrwBhI?=
 =?us-ascii?Q?Bdvr4CjF6tV8okxU4MpbLpXGq29PAeuVc+2vsTiN6f0Y1S55sU+x+JcVMfSW?=
 =?us-ascii?Q?Mr0m307Bc8CJwwhHgZNbYLLPpPRqaVfIFqQiBVXDV2T11jI12P6unVCRu9QA?=
 =?us-ascii?Q?57rrRthX+BdQJTvEZ8ahjQJPwxsLgY9v2S4kKHQzSeAzV8IGuFb4ItFlD4yN?=
 =?us-ascii?Q?yw9KeUwUHdX+HIoIcIQALkyvovhs/Ye/EzM4ov6Aw01dWeyjiR2M2+qtA/el?=
 =?us-ascii?Q?K55QA0GJODFngb26LKt+xe/ZddsHLUv3HJIetRHs4FIrduCbs/6LWDyJ37Jm?=
 =?us-ascii?Q?tTlt6yK6kdHinOg1tw3ChbWPeq0xWXgA5kcAG47l+nFlj4a5Zha6qNjp5k3v?=
 =?us-ascii?Q?HhtMtoVDUEUQirnP2Z10hDHT2WbnfDxXD42294jG4UqPby77+NhhGSlNMKT0?=
 =?us-ascii?Q?iOVZifjrOLiK4nzLI7CM+oFdXwAf3DP1ntCJC64w2lqehvHxIfHJSZejMOlV?=
 =?us-ascii?Q?hctDI6hsLyk46iuWzjLSzMNXxn3UQ4vAXtuZBSZuwjMIbTmGPUZTjZGJNQV4?=
 =?us-ascii?Q?TzLXpzr5cdKr94gQ8hKUBNcR4hM1odVfyD/cnv9DOjxeekd3BTR43Dh7G5KG?=
 =?us-ascii?Q?xRZeFu3kGLGHS/i6gp/jCX7OOh9RljmIAhVZKEPToGr3bsqFKA5DFS9gDB8Y?=
 =?us-ascii?Q?gaxm7LjrBzWl3WqVdr1iIHwra3K0P6xatieJQKN4FDjjfCebLArOHoE50Lds?=
 =?us-ascii?Q?fogMQfCFugH81EVLNgr+f3N12VPnqRpREQR6VMdJmpFKskTRbaDi2GzCGGLZ?=
 =?us-ascii?Q?PSf0hbP0phmlzd1/F/36VqfLg+0BwBltN5mNj8IkwNSuk0bDtklFqoQvzbec?=
 =?us-ascii?Q?fqudihm4uasCPerwjbq2KxBmpLRTaChf91dKp33WBGLlKfe7s7Gtx0tLTJxi?=
 =?us-ascii?Q?LwW5uGoXZBiNTC/vVfWDY7jMNEhSmTPACVXmMMlLxKCbIjfKpRiPLZog/xps?=
 =?us-ascii?Q?XxbQJq8F/Yyk3DXFdemxc3YZVVtReehTYwcGkZDlqPT5viWjtD0B2QQqyC1w?=
 =?us-ascii?Q?eojKFZMh4os43v+OdhQg9elWhxdTZNAbdkGNg3maDgyh2hYWuS7+B53n2ij0?=
 =?us-ascii?Q?nhiX9VNtEi451eNTSWVrRsZlIF962VfYUiyVTTz6J+B8F+90E+5xli0oizrp?=
 =?us-ascii?Q?I7Ja6V1sRMK7SR558BlMAEV2DP5WKXk2kPOD2RJ8GFKaGyxwCDb8EZsSOTCc?=
 =?us-ascii?Q?ZF2AjBSurAkzny4mfRsE2mjhcETz2xJt2iqsh0eXnyk6WNoD56QjNizeyzg7?=
 =?us-ascii?Q?oBSoRUTG9RxroA+5UhLNiL8auuvTw/QTd2o6ZHUWii0R8zML0nJshPxOFSVc?=
 =?us-ascii?Q?hzyiDA7L47K8VTikatO87bDPVolII60Hlgsj5Ag/gTKKpEPdfen1?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c91b74f1-f363-4cd8-ca4e-08df26765999
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 02:29:46.2888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: acvLh8P5Q7uPgB/5JXxfVq2BCwNy08yJ0n/uuJtpOuSctR61gcWuH1XMBgJh6YIE84aLFq4wfZMkARM6oufRwzZRSM33Rt1cLhZKT8MibQ9ydU/U6fCn/ypQHTszgaHv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8315

On Fri, Oct 09, 2026 at 04:06:37PM -0700, Dave Jiang wrote:
>
>
> On 10/9/26 12:02 PM, Frank Li wrote:
> > On Fri, Oct 09, 2026 at 09:19:43AM -0700, Dave Jiang wrote:
> >>
> >>
> >> On 10/9/26 2:43 AM, Vinod Koul wrote:
> >>> On 22-09-26, 16:09, Dave Jiang wrote:
> >>>>
> >>>>
> >>>> On 9/22/26 11:45 AM, Frank.Li@oss.nxp.com wrote:
> >>>>> From: Frank Li <Frank.Li@nxp.com>
> >>>>>
> >>>>> Replace the struct device *dev argument with struct dma_chan *chan so
> >>>>> callers do not need to reach into the dma_device internals to obtain
> >>>>> the device pointer.  The implementation now derives the device via
> >>>>> dmaengine_get_dma_device(chan), which correctly handles the per-channel
> >>>>> IOMMU mapping case.
> >>>>>
> >>>>> Prepare to make dma_device private and make dmaengine API consistent.
> >>>>>
> >>>>> Signed-off-by: Frank Li <Frank.Li@nxp.com>
> >>>>
> >>>> For the NTB bits:
> >>>> Acked-by: Dave Jiang <dave.jiang@intel.com>
> >>>>
> >>>>
> >>>>> ---
> >>>>>  crypto/async_tx/async_memcpy.c      | 4 ++--
> >>>>>  crypto/async_tx/async_pq.c          | 4 ++--
> >>>>>  crypto/async_tx/async_raid6_recov.c | 4 ++--
> >>>>>  crypto/async_tx/async_xor.c         | 8 ++++----
> >>>>
> >>>> Maybe one day Dan's wishes will become true and someone will finally deprecate async_tx....
> >>>
> >>> Does Intel still have use it. I am looking at fixing the names and we
> >>> can drop async_tx completely...?
> >>>
> >> I don't think so. Not since ioatdma days. Dan has talked about wanting to remove async_tx for quite a few years now. No idea if there are ARM dma devices that still use that or not.
> >
> > Maybe we can create patch to skip build it firstly, let's see if there are
> > really user.
>
> There is a way to mark something going towards deprecation in KCONFIG right?

Yes, we do it now. But it may not notiable for user if everything works.

Anyways, do you have some background knowledge why want to remove it?

Frank

>
> DJ
>
> >
> > Frank
>
