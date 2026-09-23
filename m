Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011060.outbound.protection.outlook.com [52.101.65.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D80149E5D4;
	Wed, 23 Sep 2026 16:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180445; cv=fail; b=TDrid1/2L6safNKrisuNaXqgi+0yjNZDf/2nruaKr3oZLAS7yOEFlsPScYHsrFd2etvbdNVYre8XtJ21f8NQAdS3Y/JfnMhq+00dLHHSeqAnMqJCpXauE0/4y3+HkrCYLuQ3GB6ncLc3JHM4aT81Q2+tWEnmo+DwSaVGjGMI/9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180445; c=relaxed/simple;
	bh=zOIb8BHkONWGwWwC4aGSk7IdY/jgKjD9GG8v6PPQqYU=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=YC0+ESyx8XsOZ7gFvAdVoAanuF4hDYN37zEfuLR1XHNs/AkFeAlpgW6WSXdrU5yqoErj/sU+nXNZEBhe5u6hnIlSGMvey3CiwVIAe9uF3WURufZZgDtgF7uktBj7R7DbdMsfqrmNZKHtV9X+hCbTS7iejhahSF7QCaFwpN7JMwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=QqJKdZjJ; arc=fail smtp.client-ip=52.101.65.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="QqJKdZjJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Iv0xILTJK3GmOTAxTUqnYHL94LIHIF2G6H60fFuTwsxLG3eQlgA2JbfV2lfxqf2xJLrJ6EKryMsLWT6QP0T5PtVV/VoFZd67yhvoTnzu6ntFeWfHvTdETPKqa32mN07/fnXPTSreqaSKXi32VTa7iEqI3Phg+o3LMLTIXjKvb5ENqCJxasJVDKsluhuOiHFsIxwJOiX+ZnePIFhes2dfYsaUn8QoYyrpd2ewCjQo4YoT2GCmPatC9BZDcAnpgE8YsfIVBQSyKHudL+VOLk9J9BiWhl6SWOp7vQE7w1+Q5Q68VriyJ3O7X3gUHHI5remhWKP9YSlwwNalw9Xx4osAmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hpcZvQ+JgKZgxrQd9r1XdRhxKWPG015w59O7RJ/3LiA=;
 b=xFd5gpI6g6PlwL6akB2XSJJSd48FdBtK5movr48t3EqgbFqXYDmWdU4NYWFFGcSRMPfLTDIU5Asnm+KTuY4nZ+KeZQJFhLH7j/ISGGwa8iYNqvPP0gB4akGskz36yk6IOMVRAzL0Ssq2o0iNPyPGv0dl3OwQ9ZmRfDZsMOOFcP2ouu0XPAKJFc0TQIb4FxftasrINIY15fS6je/TYFEUhWEko3IjwQdjK0eClfarEOVl7DIf+kzzida7VrjwhS6ZI+C19dtEsNsUEJzu4V/u9uum9g32SIABi7rzdfcFW9VGZzaHS4hrLAoL1NnN/OFzHJbCsxGEL9ufYjLLFtx0eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hpcZvQ+JgKZgxrQd9r1XdRhxKWPG015w59O7RJ/3LiA=;
 b=QqJKdZjJmf7ymgRFdJFj3UWNWvFWnU7U+4PXJpD0BCiaSnjiaVKfXONsVODvTA37C7QPZbiCpNP97NfkrLbvzxFgRqa0RM4SZlQ7dCZgU2U/1ykI0HT+WOBuFAKIikHYwOtrNZSw6xZFw52E10+MJaEq7m9A3UsEsxjjEoguZMIW6T8ZhgzBmYD+ITFnJr4AQ4X8dKzYXff8+BEn2OXL2/GvKVUhZs2wnAUZJFr8ZuQ0NfYXFuwt42xnDUROkY8VsVIedwgh48Wim8imOiTXMi1NduqfxuSQsruuPd6BFacjKOLqdQr+45xlZBGKDNEi8wx0L1U+/s985VBsY+Qmiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DU4PR04MB10433.eurprd04.prod.outlook.com (2603:10a6:10:55f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.17; Wed, 23 Sep
 2026 16:20:37 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0428.015; Wed, 23 Sep 2026
 16:20:37 +0000
From: Frank.Li@oss.nxp.com
Date: Wed, 23 Sep 2026 12:19:40 -0400
Subject: [PATCH v2 11/12] async_tx: convert to dmaengine_is_*_aligned()
 helpers
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-dmaengine_prep_dma_pq-v2-11-32ed65b8a9b4@nxp.com>
References: <20260923-dmaengine_prep_dma_pq-v2-0-32ed65b8a9b4@nxp.com>
In-Reply-To: <20260923-dmaengine_prep_dma_pq-v2-0-32ed65b8a9b4@nxp.com>
To: Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
 Dan Williams <djbw@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Jon Mason <jdmason@kudzu.us>, 
 Dave Jiang <dave.jiang@intel.com>, Allen Hubbe <allenbh@gmail.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, imx@lists.linux.dev, 
 Frank Li <Frank.Li@nxp.com>, ntb@lists.linux.dev
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790180376; l=7777;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=MXXspFpNMQHnCFDkxgXQK55LyGvBoycOAUNpk+mGK+w=;
 b=dtVwBkkjAar1kvmi4oBHf7oIV4PUAMO21FdpEfkucu7LVyeerCofd6XvJeKpjog2Q85u6oIM4
 N1gXm17+IcTCQ6HcgRPAMDFpdlGw8z+aefM+lmK4uKEfYuoP/NX/BVv
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH8P223CA0018.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:2db::28) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DU4PR04MB10433:EE_
X-MS-Office365-Filtering-Correlation-Id: 75e20f1e-0d3d-4de1-50a7-08df198e9a27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|19092799006|23010399003|18002099003|22082099003|3023799007|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	8q8Utj7D1RhgThEGYMK6tX4s5oD0MttErrtVh949s9QlTXQegmEumPlTg8+z/ee40+jrKfQcSlNcg1NMkp3ctYD9dh4NGSW64BLoUST9137oHmMMng6pl6w6g4QoQyzlGgJ9FQGfwuDUJV2EftqKYXPjLd/vnQyDfzZ99Ddd4Ae8kHzS47MBybycOLy8MF6iICXwjGLLJuWAg0cXHe6KVU9Aq8rKqNPE4WYK42+Kfi1WVTASnnYws9Sg5czox1QS2YiNckXHhz4ZhaRp0AKWMaTDse92scqtqTEMUUw9/p1Dgz04E8gvFQg9Zz+i+tHGpnrFLkI0irFesj4rXaeTsFQp173Y7ENzZLSB4QKMzRWdVSITIwlRIWo6BFtSB2i/ouE7SKzyPsSsoDZA6LisE6g4I16fZPAery8tqcig4vu+XuIm8TfQ7igeQBeiFTXKbyx/w3L9K3zGbc4EYO6tMoKSAhnaSuf4rpRkcE9D+q+z4xAzlc6mt2igYx7N1q1vjxPF2QGo0D/Pss4fii2SNcGagPQHPx9kBuSfLGGanW4raheix067ny4JHz2U7y/nN+RsHAvd9d3asckjnGv4uHLOAvmFjaZfGHJmHD9erZYJVctlvsWfzVBu1D3dH+DZQqDYdhGEl1bXWYjsmDrt0WTRPpkZTvZa/4BLB9m/1rY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(19092799006)(23010399003)(18002099003)(22082099003)(3023799007)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NStRZUM5RnJDN2d4QnN1eTJzZm1iNFFMUVp4a3pnYmZ2QjZybTVkNS92RzJH?=
 =?utf-8?B?eFlDNVNCNE4rbkNWVlY0WmJuWlI3blJhMTlxNEJsQXRWeUNhV3g5S3BPYWN2?=
 =?utf-8?B?VENLU0xmdXRHcnBKeVNxUm5QdTdWWEw4TlFOamNleDNPTlVSdkVDZzBlcGFZ?=
 =?utf-8?B?M2c1YkJ6aER0aVdUS05uSzVjRFpEMmhpaEppdFNlZnlucWVTTUcramlGRWFy?=
 =?utf-8?B?Ym0xOEk2eGNVM0NlaHlhQ2RCTVdtTmNBRmw2MXdRUE1QakxhcmwwVU5selZJ?=
 =?utf-8?B?T1dUb0cwQXUrK09ieG15Um9nM1g4WTAyYjUwVVFGbHkxSm04bW9hRERJQ01Q?=
 =?utf-8?B?SXcrdE85NlRnaUptK3l6TzUxTUw0cTY2eUx4N0U3czgxTzV3M0w0Mzk1SjBX?=
 =?utf-8?B?ZWJ5WENmZ21OWXFjeDRucDBLZEwwSFNNTk5LZUR5MVBmYXNVUWFIaW1MZWVl?=
 =?utf-8?B?cmFTY2llbTRzbEQ4bXNYSnF0VVdOZHdoaXVIcDM5Mit4ejVlc1N5T0UzbVZX?=
 =?utf-8?B?ZlRTelozVzV2U3JLT2NINEFnRGhSYVJwQklYNWRqY2F6SmRTUGpLbU0yMEF1?=
 =?utf-8?B?dU4vVThMeEJEQkhMYUJlMFVTUjV6V2JQSGFGQjdSMXFDdWVJSzF4L2JCVEZa?=
 =?utf-8?B?SGxwaHUzY1J5QXg0V21LZm1BZWpzNU0vWm5EbFJVZStSamx5bnFwVVgySHUy?=
 =?utf-8?B?V29SUDZnUStPaGlaeVpnTmFhLzFyeEdDM04wcVdjUE9FOG05ZTF5Z3JTT29B?=
 =?utf-8?B?bG5COXlNb0kzUERmT3NjaTJjdWhQRm1CU09jMzhScVNrT0lMTHNKd0pGa2tY?=
 =?utf-8?B?OFZWdUZlNHkwcG9jQ1htVXltczJCNEtCV3ptTkZiNTBPTG5vaHpBUzBTUjJZ?=
 =?utf-8?B?VFVRQ1NtZTFCSGZKN0ZvYlZHcGJkT0pwM3c4OGZRSmk4aU5BK281S2JRUjNB?=
 =?utf-8?B?d0hrdDljc0UzRjVHaHMxbTJxa2hGb1cvQnp1eFBsaDVVNjdWRnN2NW40TWJY?=
 =?utf-8?B?K0Zic3pnR2tUcFQ4cWhXY21Fa2EvdWRsT2xETk5pTGkzbGc4U2s3SXVwMFRL?=
 =?utf-8?B?MnFITWhrNVpyRWtVcUcrbGc1bWJ5cGIzbkFzNllaRkhXYjJ5UEFPUFNSVFJq?=
 =?utf-8?B?ZzltTURPZ3I3LzRlZ3JmSURyZ2tQTGxtcDVJay80NmNVV3RzSXdHa2p6NVAx?=
 =?utf-8?B?bndGSHlFQnBsMm9BZkE5NXFiZVNNSGN2cFFGOUVtd3kyTC9pSTFhcEpKMWlT?=
 =?utf-8?B?QkI1d08yT1FQOHdwcndDZmthV2YvZmNtYWMzdHRZV2FDRzFhQmg3RDRBZ3pr?=
 =?utf-8?B?a1d1UGRxUFNBWTNiZ0hLY3ZZY2NCOVJxbWg3bmlVdy8zMVZYZGhKNlZ3a05J?=
 =?utf-8?B?dlRuWHFQQjBQVStzd0FIOXBMbzVMb1F5cjdiZ2lCNFUzSzNVczIwbXdLclR0?=
 =?utf-8?B?WVJzQVZ6bUZCZUVLRnlMRG94WGM2dWt6OG9qTXpVVEw0NmlJbS9uSjhhVXpR?=
 =?utf-8?B?VDc4Wjl6M1lhbFVBdk56NHlxcURqSWk2ODVjejBvTzZVR3k5anI2T1oreFdj?=
 =?utf-8?B?Ujg1Zy85VVBhbWcrZUh3ZWdyTDlNdytzaUhVN1RhWmdHaUUxRGlWc3h5UzBo?=
 =?utf-8?B?WlRxL1hHeXJ5T1FRbFpnendGcWg5M1VvaXJOcGJEU0wrZzZrSm9QUHM1N2pQ?=
 =?utf-8?B?ZnlPQVpnWkgvbEIxWjlOTW9lYXJnVWtSK29hT1N6cXBqdVFrNFI5YmZKVmg1?=
 =?utf-8?B?K1BZY2hydTVmak9LdjR5YVZ2TzJVNVIycE9IYjJGYnEwOHNIVnhZaTFEMzg3?=
 =?utf-8?B?bExFNkVwRFNkMUE5NXFtcWk4TTNUU25pMy94WlEzaHZuemxXNnJIb2o5UVh3?=
 =?utf-8?B?MUt3dTkyc3Z5UGFaeHJwZ0gvamQyUzh3c0dlMVJIZU1BOFZ6eUV3ZXloWVVW?=
 =?utf-8?B?RFcyQ1ZSRWFpRGU1K3ZBYndYdTdoMURRbmpKOXptQmg5Y2VtOG5BMjlxZHE2?=
 =?utf-8?B?RUxYQXQ2SVpmSjVPRTNheXd5WkxmRER0OUQwb1V6NXZ4MkxjYVdRN0FLdmlI?=
 =?utf-8?B?T0FKclJjM0xJRFl5WHIvUEwzNHlXaEh5a29yV0tQL243RlBWeWE0cjVGS2dS?=
 =?utf-8?B?Q0owSEhFOWNHbXIwZkk3akgrOTdNWWMrTnhaNWNqVlBRNWJiMG00ME9CRjhW?=
 =?utf-8?B?VjMvSjRBTXdPWkxkU3J1S1BIU09tTGtOVUlLeVFaY2w0SnppU2Y5bE1RV2pG?=
 =?utf-8?B?dTMvK3drOWladXdGQnNYU2M2NUVPcXQwb3RLZU9nVkE3QVFnR2JLcURyT21t?=
 =?utf-8?B?TVVrejY5Y1JuVjE4enZvdk9kNzU5cUNPa0NINVBrdEZyRjNEVFFKWllPUXVL?=
 =?utf-8?Q?3B0q9+Tps1fPGoM4r99UtgjzH0z4XwljdzmxO?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75e20f1e-0d3d-4de1-50a7-08df198e9a27
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 16:20:37.3664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HsWGz6DY4i6sbd9ZWgLkwyrnwVQ62qHMopPgBVlExLBHGvybxpJUqvRaqST2z/Sy2BzH0yzQM3UChZ3arnXzDr7513TxSp8ACXYmg/0QBtTwpkWVVohG1fSDRmi9sh5W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10433

From: Frank Li <Frank.Li@nxp.com>

Replace is_dma_{copy,xor,pq}_aligned() calls with the new
dmaengine_is_{copy,xor,pq}_aligned() helpers that take a struct
dma_chan * instead of struct dma_device *. Also update the internal
helpers dma_xor_aligned_offsets() and is_dma_pq_aligned_offs() to
take struct dma_chan * accordingly.

Also use dmaengine_get_max_xor() to get max_xor.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 crypto/async_tx/async_memcpy.c |  3 +--
 crypto/async_tx/async_pq.c     | 12 +++++-------
 crypto/async_tx/async_xor.c    | 23 ++++++++++-------------
 3 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 49ee66759c7e9..972670094be0a 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -35,14 +35,13 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 {
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_MEMCPY,
 						      &dest, 1, &src, 1, len);
-	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
 	struct dmaengine_unmap_data *unmap = NULL;
 
 	if (chan)
 		unmap = dmaengine_get_unmap_data(chan, 2, GFP_NOWAIT);
 
-	if (unmap && is_dma_copy_aligned(device, src_offset, dest_offset, len)) {
+	if (unmap && dmaengine_is_copy_aligned(chan, src_offset, dest_offset, len)) {
 		unsigned long dma_prep_flags = 0;
 		struct device *dma_dev =  dmaengine_get_dma_device(chan);
 
diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 6ccc1073c5ace..30d6ee676dd44 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -140,13 +140,13 @@ do_sync_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 }
 
 static inline bool
-is_dma_pq_aligned_offs(struct dma_device *dev, unsigned int *offs,
-				     int src_cnt, size_t len)
+is_dma_pq_aligned_offs(struct dma_chan *chan, unsigned int *offs,
+		       int src_cnt, size_t len)
 {
 	int i;
 
 	for (i = 0; i < src_cnt; i++) {
-		if (!is_dma_pq_aligned(dev, offs[i], 0, len))
+		if (!dmaengine_is_pq_aligned(chan, offs[i], 0, len))
 			return false;
 	}
 	return true;
@@ -181,7 +181,6 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_PQ,
 						      &P(blocks, disks), 2,
 						      blocks, src_cnt, len);
-	struct dma_device *device = chan ? chan->device : NULL;
 	struct dmaengine_unmap_data *unmap = NULL;
 
 	BUG_ON(disks > MAX_DISKS || !(P(blocks, disks) || Q(blocks, disks)));
@@ -193,7 +192,7 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 	if (unmap && !(submit->flags & ASYNC_TX_PQ_XOR_DST) &&
 	    (src_cnt <= dmaengine_maxpq(chan, 0) ||
 	     dmaengine_maxpq(chan, DMA_PREP_CONTINUE) > 0) &&
-	    is_dma_pq_aligned_offs(device, offsets, disks, len)) {
+	    is_dma_pq_aligned_offs(chan, offsets, disks, len)) {
 		struct dma_async_tx_descriptor *tx;
 		struct device *dma_dev = dmaengine_get_dma_device(chan);
 		enum dma_ctrl_flags dma_flags = 0;
@@ -301,7 +300,6 @@ async_syndrome_val(struct page **blocks, unsigned int *offsets, int disks,
 		   unsigned int s_off, struct async_submit_ctl *submit)
 {
 	struct dma_chan *chan = pq_val_chan(submit, blocks, disks, len);
-	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx;
 	unsigned char coefs[MAX_DISKS];
 	enum dma_ctrl_flags dma_flags = submit->cb_fn ? DMA_PREP_INTERRUPT : 0;
@@ -313,7 +311,7 @@ async_syndrome_val(struct page **blocks, unsigned int *offsets, int disks,
 		unmap = dmaengine_get_unmap_data(chan, disks, GFP_NOWAIT);
 
 	if (unmap && disks <= dmaengine_maxpq(chan, 0) &&
-	    is_dma_pq_aligned_offs(device, offsets, disks, len)) {
+	    is_dma_pq_aligned_offs(chan, offsets, disks, len)) {
 		struct device *dev = dmaengine_get_dma_device(chan);
 		dma_addr_t pq[2];
 		int i, j = 0, src_cnt = 0;
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 3cbe08883085b..cf3eedaf2a75b 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -23,7 +23,6 @@ static __async_inline struct dma_async_tx_descriptor *
 do_async_xor(struct dma_chan *chan, struct dmaengine_unmap_data *unmap,
 	     struct async_submit_ctl *submit)
 {
-	struct dma_device *dma = chan->device;
 	struct dma_async_tx_descriptor *tx = NULL;
 	dma_async_tx_callback cb_fn_orig = submit->cb_fn;
 	void *cb_param_orig = submit->cb_param;
@@ -38,7 +37,7 @@ do_async_xor(struct dma_chan *chan, struct dmaengine_unmap_data *unmap,
 		dma_addr_t tmp;
 
 		submit->flags = flags_orig;
-		xor_src_cnt = min(src_cnt, (int)dma->max_xor);
+		xor_src_cnt = min_t(int, src_cnt, dmaengine_get_max_xor(chan));
 		/* if we are submitting additional xors, leave the chain open
 		 * and clear the callback parameters
 		 */
@@ -124,19 +123,19 @@ do_sync_xor_offs(struct page *dest, unsigned int offset,
 }
 
 static inline bool
-dma_xor_aligned_offsets(struct dma_device *device, unsigned int offset,
-		unsigned int *src_offs, int src_cnt, int len)
+dma_xor_aligned_offsets(struct dma_chan *chan, unsigned int offset,
+			unsigned int *src_offs, int src_cnt, int len)
 {
 	int i;
 
-	if (!is_dma_xor_aligned(device, offset, 0, len))
+	if (!dmaengine_is_xor_aligned(chan, offset, 0, len))
 		return false;
 
 	if (!src_offs)
 		return true;
 
 	for (i = 0; i < src_cnt; i++) {
-		if (!is_dma_xor_aligned(device, src_offs[i], 0, len))
+		if (!dmaengine_is_xor_aligned(chan, src_offs[i], 0, len))
 			return false;
 	}
 	return true;
@@ -171,7 +170,6 @@ async_xor_offs(struct page *dest, unsigned int offset,
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_XOR,
 						      &dest, 1, src_list,
 						      src_cnt, len);
-	struct dma_device *device = chan ? chan->device : NULL;
 	struct dmaengine_unmap_data *unmap = NULL;
 
 	BUG_ON(src_cnt <= 1);
@@ -179,8 +177,8 @@ async_xor_offs(struct page *dest, unsigned int offset,
 	if (chan)
 		unmap = dmaengine_get_unmap_data(chan, src_cnt + 1, GFP_NOWAIT);
 
-	if (unmap && dma_xor_aligned_offsets(device, offset,
-				src_offs, src_cnt, len)) {
+	if (unmap && dma_xor_aligned_offsets(chan, offset, src_offs,
+					     src_cnt, len)) {
 		struct device *dma_dev = dmaengine_get_dma_device(chan);
 		struct dma_async_tx_descriptor *tx;
 		int i, j;
@@ -303,7 +301,6 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 		struct async_submit_ctl *submit)
 {
 	struct dma_chan *chan = xor_val_chan(submit, dest, src_list, src_cnt, len);
-	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
 	struct dmaengine_unmap_data *unmap = NULL;
 
@@ -312,8 +309,8 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 	if (chan)
 		unmap = dmaengine_get_unmap_data(chan, src_cnt, GFP_NOWAIT);
 
-	if (unmap && src_cnt <= device->max_xor &&
-	    dma_xor_aligned_offsets(device, offset, src_offs, src_cnt, len)) {
+	if (unmap && src_cnt <= dmaengine_get_max_xor(chan) &&
+	    dma_xor_aligned_offsets(chan, offset, src_offs, src_cnt, len)) {
 		unsigned long dma_prep_flags = 0;
 		struct device *dma_dev = dmaengine_get_dma_device(chan);
 		int i;
@@ -351,7 +348,7 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 		enum async_tx_flags flags_orig = submit->flags;
 
 		pr_debug("%s: (sync) len: %zu\n", __func__, len);
-		WARN_ONCE(device && src_cnt <= device->max_xor,
+		WARN_ONCE(chan && src_cnt <= dmaengine_get_max_xor(chan),
 			  "%s: no space for dma address conversion\n",
 			  __func__);
 

-- 
2.43.0

