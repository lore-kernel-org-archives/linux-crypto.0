Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011060.outbound.protection.outlook.com [52.101.70.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5691E456DF7;
	Mon,  5 Oct 2026 09:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791193068; cv=fail; b=KRAAWV7w0Tq26HjT7ThGB1fMf7Aoq5yTTrP1ab4Ag+a3nPp/T7lGH3ex5m7PVW93PbnL/f4+K3s1OoKSWDWJI4lQSvzWM+GpiCwQpqI4thY/NEl7IVAmZ4Jp8yBRn10+eFtz42kUSoSu6wHcZbQD5vsM6c/zSm7tsvRjIKhNZHc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791193068; c=relaxed/simple;
	bh=M6bv0M0AWYB1CAc2oVCilkKLf/Z9x79deCVPN8iBZO8=;
	h=From:Subject:Date:Message-Id:Content-Type:To:Cc:MIME-Version; b=IZY5TJzLuXcSXvNhHKO6V2102NgvtMSImRDlOSjFdXxhsTtcs/Fo5O1udrolSs/Wu6C0Sp6mfPuwaAPHXF/AWBcuMHXUJhpdZc+Y/0jolG9jRMi/TX/kDRi/onWFfsv6rdqlKKsfiGdZPmzXkOgiOxzTMlEZrd8x7nt65thnY0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=pd1O3j0x; arc=fail smtp.client-ip=52.101.70.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="pd1O3j0x"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jcTXxQC1i9SKeHvZr503n9JdfHMmWky2EfdaC0K/Awjk1/MIJ7VvFdOqxEdlxgZKqkiUjmTabvgM0B51eRPsTtT+hUoOOvyWl1+XwEVG6EVVN1LN8t6ZCEQG/blKUwAAfVOCueOrhUixaVPbFwj6MTZBIcgWOub4PXMdhFRAlzttRCs5MkcjRKlh4gDlKxakRuvuv88L9nFffDzNekeU/ScnRbvTHCMfadBmpVUMwtdj1MNoi6sY8IoG/IUdZ59R+KLKhk3ZGZejwFa2SBIrL8nMoIPvrvrkg0VrFnNRlXZKPLBL8EHwz/I/HVePYZDz4oI7iP6HWNM6USqtfLXePA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t5iFC8DUKTpl5DIoXrSAfidlOlT/HDCA3PYWoXwtjMI=;
 b=ERZ0b/02StZlgma0coo9tSpnuPJt3F5JptMCvUEeuUU5Ygv4AGtPHH6vpPyvPx7SGi6qN4oJX8c5SG9L/N5k950KZe5amsdAN3+pDgh8h1VPA3ThgNu29dnGthVtdFebYdy3j4Y8nBY6EYAOo/QpA/GTbUWgdxMdeL5QUkxnhalLgoTZseOaH8tCMJA7/Y33wf/4NJbpKd3+e/TxN95tZAR9ahnncJEl4kWVQRmPMJg2IswryZbJBYWhlx+Gk/TmsO6pMpsfPPSDWn9tHc7mle1uSUq8o4TmI+vhqB/nloudazpq1DQ49o8q56tvxT2QpOcyORC91kw0OMoNYyXunQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5iFC8DUKTpl5DIoXrSAfidlOlT/HDCA3PYWoXwtjMI=;
 b=pd1O3j0x9jh7cJTmoSTNd/c8euZX2t7UHsm8dDL6HmqSXwjnQX3MHQ8J6J9c04vCJp6I44uysorbwzQUd47EFBv5rWCQ3wvJMpgIGfqfEZiP8EvvpZFyQIP7g6i59vEnBSc24ZR15tkX9Z1sAImtuPps/D5lGmy3femxXUIBL7qVvfxRFq2jeH8r14XgyriW6y/7Wh8tOZk9IWaEVkPulhkbn1onv53CGgpv6icbxH7T4Z+maOLjxnRn6iQe+V8D19QWBtUZhpo2nYZnAUtMVPvTpO3tCsUN8vOYGtxCXFBQhAU001vPKDACxhJGFZzoNxFhnxwIKE+gMbTPECEE0A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DB9PR04MB9913.eurprd04.prod.outlook.com (2603:10a6:10:4c4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Mon, 5 Oct
 2026 09:37:32 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 09:37:32 +0000
From: Frank.Li@oss.nxp.com
Subject: [PATCH v3 0/5] dmaengine: Add dmaengine API to avoid call DMA
 Engine callback directly
Date: Mon, 05 Oct 2026 05:37:13 -0400
Message-Id: <20261005-dmaengine_prep_dma_pq-v3-0-a4a241f26fa7@nxp.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMpvw2oC/4WNUQ+CIBRG/4rjOZqAmvTU/2jNgdyUNpHAmM353
 wN7qJfW49k993wL8uA0eHTMFuQgaK9HE4HtMtT2wnSAtYqMaE6rnFOC1SDAdNpAYx3YJmJj7/g
 AUnAiogIKxd94u+p5654vb/YPeYN2SrFk9NpPo3tuw4Ek799GIDjHvKwYqKKoo3oys92344DSQ
 qDfDfarQWODUVBVKWvBZfFprOv6Aj5hmuIOAQAA
X-Change-ID: 20260921-dmaengine_prep_dma_pq-7eba91a609ed
To: Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, imx@lists.linux.dev, 
 Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791193046; l=1335;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=M6bv0M0AWYB1CAc2oVCilkKLf/Z9x79deCVPN8iBZO8=;
 b=rPWAfY+08LGhLW1CNCpZDlO1Ksofee6yAd5830BSglvVsVsTzaLbYE8tdyLEvB/z/eqYrSj86
 nIcNKupsPC8DmolZY+lPGO9bLhkJ0CgOzOqjiuw7ora6QNAbjbyHoA6
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH7P220CA0057.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32b::20) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DB9PR04MB9913:EE_
X-MS-Office365-Filtering-Correlation-Id: dd7d19ed-b44b-4706-d3ad-08df22c4477c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|19092799006|376014|23010399003|11063799006|56012099006|10067099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	h9sHHODR5VFfULMFZC2bxcFXFw0ZnTSBFpeO4yBk8w3OGzRt59+HPgF8VfTo8NJHNWYX9O7OhNxepX4i9AwmipaKY5Imm5x6TITHn1FfFuRduwQbhAl4xYOj0t7zoPTD8QdV1qk0Bvhbkwy7K3sBcEVssJDOUDPs5qaGTedtmjy/3iCg9Ef8qd9nWIvSAUw+vTe6EGAJEUiG9jUEL720uQajLxxf9C6AUaxgP/6d1X3CL/pXiBN/RusnlNAlvozvvc1AbA3u/1rmJaSqNwDehvEB3LbcKOCD2F2KDbI38x/Pke1Y172VTx93cVMjhpn4uMl5GtzlxOJGMdZsCPmJpkqDeXulK9zGZb0yptlMLEvZ5F0UlQdmekDwsOOpofWF2qggBvjflwdpJieTwgEEW0BVDzSFnZOkmk2JdT7BK53dcPETaAND6Xtr8CtnWLePUgvYu0QrEqBJMzR0FBLnoHJEqxkxMj4d/1FLGqv5RsSVJn4bRQKgikJ4a9wAWxyDcNvpOT3zECt/9pIdaUynGZaUOAckmQp6JZTbwkgf3UUWnWxAmZU7hq97xNdHidcVeXxzQFimqenDkqPQ4lupwVymU4LII+xm76ZXFgvBoudB/MiQST0KQ1byv9V6hNUJ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(376014)(23010399003)(11063799006)(56012099006)(10067099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YldheUdEN2VBbWZZZFBISDhjYXMwVk12R0tweUxwNmY4WGQvY2NuUFJTNFhI?=
 =?utf-8?B?TUtuUHBoODBKTWoyeERyZmg1VjdPSHVCbjBqOEVNcE5UcGUrdmQwWml5Ritx?=
 =?utf-8?B?UlVTWEEwUDY0cXc5b2NaSDVZRXBuTnpISjB4SlhqVHl6SmRNbUZhQUxyRkVD?=
 =?utf-8?B?cGV6MHZwSEdlaDIrZXhTcW1MMVcyc2FDSmVRak5QSXRsMHlPVDJwYkQ5djcy?=
 =?utf-8?B?RkZvc09QRU9BWTM1d01CU0FJa1RLZzRzSm9ubUEra3Z3QjJRRE9nOTlUbU1s?=
 =?utf-8?B?RTBkRU5KbEdmRG10VGNORHlTeG1ZaEhJL3hlT3R6SS9qRUhyWHVxUElHMnY0?=
 =?utf-8?B?QmtPd3l6Y1dHcFZPZ014TFJ0bDdwNG42UUJBUWgwdGtWTkpaNm93ckRDSUJq?=
 =?utf-8?B?U3ZVeW8zeWd5MTlKSnF2WFIrZTJDbUVsRjFpaVBsQ3lBdGVldFdvKzhYUzBw?=
 =?utf-8?B?V0svc0oxTUdWYUpHa3NFeHZSRUR4MEw5dXdmeXVmb0syZkNORUZFZjI2eHlI?=
 =?utf-8?B?ZktSckdtQVlLUlpKeUJsbVhrLzc1ZXIvdnJwMnZybGtqVGZNT3BXSVdQeXJk?=
 =?utf-8?B?T3g0WXQrSlZBd0RFclk3NEUzdkhaeDRpSVNLVU4rNktuazNCWG05SUtmb0h0?=
 =?utf-8?B?bFVTc0cyWUxiZkpNTldZM0NISU5sVEtOaE5QUWtJQ2wxVGlaYVlXcnRIVWxR?=
 =?utf-8?B?Z2o5K2djTVYxamVsSDNKUmtTcUw0dzNaUFBhbmFZeWlOMjB2eC9FQnA4dHFm?=
 =?utf-8?B?YzA3UTkvQ2lrYXVUcElUTmRWNmdnK2l1OWVqaytmdU9YTzlKbWhOa0c2dU91?=
 =?utf-8?B?VzJFaDdGMUcyKzhjWkl4dUpzOGZHbHUyTUF1YVBVQ2NVUjZQSkJvcEZqbEhs?=
 =?utf-8?B?bDlNdnZ3QUl2UFRhWnk5RkZ0dHlpdFZKS1hGZ0oxSEd3Q1Yyd3E5VTljaUNS?=
 =?utf-8?B?a3NKMDJuM1NVU0h4N2d0bTVwTnNzVEJRZmRKOXRLQ1Y4TUJsbU9ZK2VueGhB?=
 =?utf-8?B?eklxSSt6cmx4SS9vYmlpdEp1N3RFbUxoalJ3VWw2QkdhcUJtcW8xdXVFbERq?=
 =?utf-8?B?QlhyR3o0K085bFdFM2RtQ0hkK1BkSkxvdHZYNkFMaU1DdGxkSlYrNG9LbTlW?=
 =?utf-8?B?V0dlVzhnd3FuS0ZZSGJ5VXhXclQ0TFRpc2FLMEJvaUJnRE95ZVE5V3hzNGR0?=
 =?utf-8?B?UERrMkUyUm03cDRCdHZ4OFdabk4zejk2SkFKcE5PV3E3KzFiUjhXN3g4d1FJ?=
 =?utf-8?B?b3daY0RQMnNrdXRsR0RpVTFJdENxdTlJV0Z1NUNvbnkvVkR2OGdrMDdhN01R?=
 =?utf-8?B?Ni9WUkZOeU41NDVlWE0veXhDMTZzdkJSN3d0T3JyRE1OTG1OaHBkam8xRjZW?=
 =?utf-8?B?My93WEZJR2dFc1M5ZUJLQStTbUVHZzVZcUFmTERlRE80Y2lLK1FVYVY0bjIv?=
 =?utf-8?B?ekVxdElNNUxVdXVyS2RmaE01TVhkWFJuZGNhbE1pWW5YYWZJYWRJUnlOQTMv?=
 =?utf-8?B?dWZZQmc1YzdVamt6Qk01S1JBSVJMMFBPU0MrMytocXFZQ21qTzgvQWVFQ1pI?=
 =?utf-8?B?RG1vUWZiN0NxZms3Wi9LNVhFNFZ6OEpueUNYM2NDZEl5eHZQSnBLRjUxcXlO?=
 =?utf-8?B?OGlVaGZEYTRZTm14R1hYam00dUhJT3UvaEdXZFBkZVpQV3gyZnhOZ3l5ZXA0?=
 =?utf-8?B?ejFLQy9RcW9FMzZkaGJBYVR2aWFyV3BaQmpaR2FGNlR4Z01BeEVyTDNyeitG?=
 =?utf-8?B?Uy9NZ2JaQlJLZnVhV0hLcUtlVmFMVFBXVGM2a0xmcGZRcG9OZUFiVGxMaFJw?=
 =?utf-8?B?c2ZVYXBEYVdYNnhhUkRSVlo1SVJ4dGlsRDI3UGlFRGsvOXhGV3o5V3RJd0Nx?=
 =?utf-8?B?YTJVSjRCMDlkelp2MTFqbzF2NUE1NDlYbDJUSUVXbmRMV09Gc1ZyYTgzREFq?=
 =?utf-8?B?QksySXVEWUZ6WnN1OUpra1Zsa29jTm9pMitLVFhPdnJhUlR1RFFNS3lhM0Ju?=
 =?utf-8?B?RkdXc25kRE8yd0V4cXIrQjNFOEtrZWtqeWhDRnMxS3JqajlpYmpMaitVMWlF?=
 =?utf-8?B?U2tiMDQ1RzdIRmdDenJRVkRYL0hXa3dTTGkrWHhOVUFYM3AyU0F6ZHBxTXpk?=
 =?utf-8?B?SXNKR2NJcjM5T3NiVXZQVzQya2FnQkRIbjRvRXVwUXBVNm1vS0Nsa3l0SzdC?=
 =?utf-8?B?bjViNllwa1c1NzZkK3ZXVXp3TVhqdWZmVjk1WWluVEtBeDQ0S2NsNkNZMEt1?=
 =?utf-8?B?L1IrNVZHL3Z6aks2T1VNTSt1aDNaUTFIY0haczI2ZFpSeFYrdFVFNlZrVjVh?=
 =?utf-8?B?S2ZGNWUxa2QyY2pjWXFzeXZYUmRTdk1XejRQbU80aHpqRnBpaDdJSjRGbVhj?=
 =?utf-8?Q?LQnnjSk4JtdYwrLAueFHj9lm1SFTz4iG0Vx0P?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd7d19ed-b44b-4706-d3ad-08df22c4477c
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 09:37:32.0633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CDsZ9sA1Zhj2h2xrMLr79uEPV96QFeVdWWKH4dKx2VxkEue1hcm+urqqAftFihXbYFxmSx2TmAQ4hIW3WLIssKzHAHVESrYCngCKB3gzNCQPoAHIihkj9on2th5pGgzX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9913

Add dmaengine APIs to avoid call DMA Engine callback directly. Prepare to
make dmaengine provider private.

Assisted-by: LLM
Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
Changes in v3:
- Remove tx_async part. only keep DMA API added.
- Link to v2: https://patch.msgid.link/20260923-dmaengine_prep_dma_pq-v2-0-32ed65b8a9b4@nxp.com

Changes in v2:
- Add more patch to cleanup crypto/async_tx
- collect https://lore.kernel.org/imx/b40fa0d7-fbd0-4ee8-b99c-781d08c18838@intel.com/T/#t
- first two patches can be applied without added new dmaengine apis.
- Link to v1: https://patch.msgid.link/20260921-dmaengine_prep_dma_pq-v1-0-9563ed448260@nxp.com

---
Frank Li (5):
      dmaengine: add dmaengine_prep_dma_(pq|pq_val|interrupt|xor)() API
      dmaengine: add dmaengine_is_*_aligned() helpers for DMA consumers
      dmaengine: add dmaengine_get_copy_align() and related alignment getter helpers
      dmaengine: add dmaengine_get_cap_mask() and dmaengine_has_cap() helpers
      dmaengine: add dmaengine_get_max_xor() helper

 include/linux/dmaengine.h | 286 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 286 insertions(+)
---
base-commit: 5c4d4169604b335c38bbc79bc1fc03042981fc6f
change-id: 20260921-dmaengine_prep_dma_pq-7eba91a609ed

Best regards,
--  
Frank Li <Frank.Li@nxp.com>

