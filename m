Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011060.outbound.protection.outlook.com [52.101.65.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0686B53FD34;
	Wed, 23 Sep 2026 16:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180442; cv=fail; b=BVPV+18sAA7pglZx+81U12/t4moXPnZQqDzr4zFvmaHneQI7ufTEYF0cy8ETg6bPt0MqfSN7AdO26OEtrs8NJQTy94CACwjkyfInsdxsC1dvWHoCIVMrYox5hXuc46oEZzRBNe1fsLhl4X5icyTz+VYKe2ETLT0Q3EjVqVzn7I4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180442; c=relaxed/simple;
	bh=Sxo/fdjF891jqQbEI57+UsgGvPIJBm6727nKoyPqrJM=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=DBM+WdrZFgob2wuTuY/TMl6tb+KeDJsNTmnsGkX/Iru8fJnaCYWUAfXPXbCAfmM4MCZUBq4tIn1Uo/NloX3LvQyDvKrHwFAoiIjUBPVkKN7q2Yp1Y3fXryLLWkn6TOTICDNP0D/jxRFUkHD0JabYU0OSFDnzNo4uOum2sfUQd0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=QsV1KvpE; arc=fail smtp.client-ip=52.101.65.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="QsV1KvpE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wSs7QvGh//DaVUahiq3kTwjNfCMuunc3o7iVUX8GND0KaEEjbuQJr0znHpRxx0geyjbh2bvjjeW6Cz3xv7KTsCxmRnYEpdN6KbX7VSDib20hCPySCQ5/NLY3TrXWsGDBnEUmrQRLSfZ1Ub/atSuDv44qr7xdk4IYyfPaINAzaFmmvhO83KjmxJpyhtCN4Hg1LyaL69CF3BDqtso6AE7mQoMJzXR5uwhCm+yCItiU+1INHaXQyU7L10FU3/Vf7xBUAvK2/4I+WLCyRcv4pkxgqPLUgPxqGZ9aI+FJQA2Uh1m/rLPUEoic137gfo6Bn57Ib44uby+rJN6UcdV0xR2NEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MoMAFbeT/Kz/S+4Hy7QZwRRAMgc/ugp7DlWOAPG2GHI=;
 b=YZWdyO7LtLsvDbUOSDIiYE7BumkEaPWxn/f0qXpsx5gRfex/ktctiSeXGQhjb53YeFh0NoeMtaETgcg4JgNRN6INqQ0EhlwCRuUePyY6/66UvKQe+keuh8Y3zyuSsDFEW0GfZGAqu2VDsa+T2lll8NVzGH0NzJLvPPYMx7LhJgIOKuUm3biMonMf55pQ8HiAbY4N/DL1Uoe2x8Thb63BbAbiVON3clwyNlj62TkngvLULgPQ/u7BN8fWD62AQOHn4mUcGyZIm2a8IXZ+PImWofk1nlqoMkxaaOoVAFDzYQkN2aIFmzGo0U2cLbkunOij7xF2xMdeMwkftddPjG9JVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MoMAFbeT/Kz/S+4Hy7QZwRRAMgc/ugp7DlWOAPG2GHI=;
 b=QsV1KvpEHV80bfpdgKtB5mtQombKs5GD+AQLZiqFSEMFYHvE8FC9Pk276/s4KrzJQElY1zLC5nXL23WzucaWfFwgLi3tIMgOuyYPF26IgXVUzP6ikou3r+cGEUBTrcfaB4J95Khdd2gY1Mu+BeZtn4IBYbi8J8kFO3VeWP2efGGqIRugTki0gmb+/p1ms3OQ13bG263FvsMtn2+qc9XKKov3iCAyJUN/k5bB48veL+95fdbwtjHrU/qN0yW/t0OTJJXXDRmdwxvTfxm+54N91iFhxczKjwZkJR+Xr2nYdbxOJPUeoFlL5uuy/gyL51mr6Kgh72znGpY356HA1wUO2A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DU4PR04MB10433.eurprd04.prod.outlook.com (2603:10a6:10:55f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.17; Wed, 23 Sep
 2026 16:20:32 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0428.015; Wed, 23 Sep 2026
 16:20:31 +0000
From: Frank.Li@oss.nxp.com
Date: Wed, 23 Sep 2026 12:19:39 -0400
Subject: [PATCH v2 10/12] async_tx: use
 dmaengine_prep_dma_(pq|pq_val|interrupt|xor) instead of direct callback
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-dmaengine_prep_dma_pq-v2-10-32ed65b8a9b4@nxp.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790180376; l=7467;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=tVRcby2UAkXHgo/y4rmvmUCX6xWI5VeTjfvvjtYvYl0=;
 b=p82jo0RJgcE2y1d1I69YjykvqDrdSPTD4IkQFb5mgDTgigmFB2zqCzL1PTybu6+E/wVBuROPY
 C3dVJpHZJ6bA6uXZn9BVJLwzmMNQ/7SKftinyYJbUTNXnrxfynFGuDC
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: CY8PR12CA0037.namprd12.prod.outlook.com
 (2603:10b6:930:49::19) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DU4PR04MB10433:EE_
X-MS-Office365-Filtering-Correlation-Id: 78fd6c2e-f236-4d28-3d02-08df198e96e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|19092799006|23010399003|6133799003|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	r4XQi+L5QHEcXSGnUXJAX5nHpanBTlXHilEGghcQtforYly8QWXGUgjU7PQgX8Dbg53iv7axh/VN+MzktynJuKWYs9KlwojrqzkwkawdvPG3PiQTXLyrDxikUwYKSAC1jvVca7pOxGdSvoBAc89ZI+arJ3yYvdko+EL3O+Gzb8w/m2YCm9sZQ8tgYMrWZmUpy8OgCINzdwDuV/bQCVmxoAE9wGV6nnTnvqBCCQQoBXCPB43LL1b1SVwfAQATI3P11hMpwapy36hqTTAWj+5qt+Tn3zghKwrfGJMvDUG7ERL6r32x4safzv/wJ6emBe/9zZucb6TsN3G9A7hlAqq6WC82oTvBxAXYl1bvdTmLrTddFaSwMRl384om2YmmuUqf7H45hvUv/Bvv+E0Nv2hHQK1lsuccvGnS97JAfDZEkjXgylpggwfyGPduEwTbNt/Mrlj5FBImKjTtmyyMgorUImKklZWV7HLWQfr7XVMqajoPit2pIui1rKzz7lpkDHyBcbpi2/U6cElgK5K7C2RJvikLJGSp2F7hDZDLl1bWdZkgGC1zcjeDnhMSAK3Q53BNuGSI/p6JE/k/6XH99kKYf1osKtiXhMEGjZEOlPoFGGKiq6xfy2hHU9Pq4ynHm5s929DgepwynJBSTYFnAJIjAv/X6yUrRQNnBeVZKw8tW6A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(19092799006)(23010399003)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R05UMVlFdzh6ZmxyWnpVcG9NRmR6Qi9GL0hXM3Q5SThRbnBZaWVzZGluQk5M?=
 =?utf-8?B?MFVsdzkydjNudUNlRjhGYnZzQ2F4Mlh6MkNUTFVtS0xuL2t6bXYrWG4rKzV0?=
 =?utf-8?B?bmhhblVpSzIrWlhrY21uTnAvT1VtVDBybGFRYlF5TG9nQ0VlNFJDaklUNDI1?=
 =?utf-8?B?L0cvL042d0xtVmVOVGY2bmpMMUNJU1Z6ajczTUt1ajF3cWxtN3c5Wis3dlNk?=
 =?utf-8?B?QWc4czhHZDF4bzN3anBnUEV2ckVEZUhqWmc3VTRtMWZkTmpoM0hTVGZ2RnI5?=
 =?utf-8?B?bFdBUXZkWFpiRXRCaWtYUlgyK3pudWhqUHAxOUhFYzJ2Z3ZrN05GZG56V2ZI?=
 =?utf-8?B?WW9JalhCajhZMkk0YjFFUDdteFJtWERBS05nNHFseW5nSTN3M3NzMVh4QTBv?=
 =?utf-8?B?c1pEMm52VnJDSnA2NUZZYzZCTkwvRlljKzVZdUQ4SHp2V2ZvNkRBbjVHN2Jn?=
 =?utf-8?B?TnA0ZSthejkyclZsSnRUVEZOdjg5dVo4eHFwRGxQM2xWNkJ2R2ZXSjhkRGVR?=
 =?utf-8?B?cHlmRE5QeE9lTkVZS3I5MWRibVB0WWNpb2Z1ZkovT3djdmRhTERmd1ZSWFAr?=
 =?utf-8?B?UWhzbjhCRk1iVjVHOGZtTUV3b0xxbzdxckFUTFluam5yLzBOQlI2NU81bXNJ?=
 =?utf-8?B?Nmg3Zk1MbUY1TlJOZVRrZVh3aVN4TGZMVVZORFlQWUxzVHV4YXZDV0N5V1Bp?=
 =?utf-8?B?UFZ5ck9NQWd6TkJXMWdEMGsrMXJxWFgvK1ZFTnFGKzc1d3poeUF1OGVWajlp?=
 =?utf-8?B?ck1QZTBzeWthbWZ4Y1VoZnJUM0hNblpkVjNzaExwWjBiY2FXRGNkNFlGZXRM?=
 =?utf-8?B?cGV2SFV1L1FpZVMrQjFuVTRjWHlQbFBaN3B3ZU9ZRWR6Q1pNaWpCVWMxUms2?=
 =?utf-8?B?SUpiNjA4MStXaTdGK3lRbG1lV21HcktYTkFJdSttMG1HRGpjelRpcGM2Z0J3?=
 =?utf-8?B?R3BKbU81MG91OHlveVZzeC85YnJQNjdsRmplYzFyTXQ0RDN4TlZMU2JPK0c5?=
 =?utf-8?B?UkxLM2JzVjBIV3hESGFtSlQxTkxvYlkyM0hiNm9OcGdBcXZId2NXdWF0bktz?=
 =?utf-8?B?aVl6bHFiMVhBLzJZaXc0ZFFCNGNGNm5Wb3V6KzFzYVEvY3hLbjVVQit2di9n?=
 =?utf-8?B?ZHFpYnJUWXRvUVpnZTFubTdMT09ENGdHUTJUSTQxTGV6ZTRCTit6aVlya2Iw?=
 =?utf-8?B?K3FzN3Fzd3R6R09xZFArNUNpbitwR0V4TTE2cGpJMldGMnRtR0dzQlNuLzFS?=
 =?utf-8?B?ZjZMbzRzZUIxRzhyM2FRYkJJRExNYXhWY1VmN0dkOGxHWFUwZUNBZ0N3UC90?=
 =?utf-8?B?YjJDZ0QrZktGRkFDTW9IRTJHdnBaOGtRTnFTeHR3dnI0VVlMa3l0NGdiTVVD?=
 =?utf-8?B?eWhxekhJa1Fzd2hJZlB2T29yWUFDT0dVelZvcGZTVVpKSVhNVXVHVU5icFBT?=
 =?utf-8?B?dWk4RFZ2a2NsOE9WbytBeEV0Qy9mdDFjbVV0Y1BkczFOS2t2enZjS0NvTzJl?=
 =?utf-8?B?NmRQVFU4bTRHblZpOFIvUld0VVpleWJwUWV3Mlg0R2hKeE9Zem51a3lTajd6?=
 =?utf-8?B?TThDSDVoNENWZnMvaHVJclBlL1EwOThxTzk2VGQwanZXZjJSS1BReEhBdmZR?=
 =?utf-8?B?RzZsNnhjbFlyS1I5NEIzbDlSd0k0d0laamlwUDl3cGg5MXlXcThHTzhSWDVJ?=
 =?utf-8?B?eWViNm4wSWZaWTdQLytCVHF4eE80UHAyWU5EQWJWUWNUV29nMDE0cHBudldH?=
 =?utf-8?B?NTdnNmIrcWVlSkRETlBVb3EyT1ZHOWJaZ3BEK0F6MGpSRWF4QUVtcElBL0VZ?=
 =?utf-8?B?QVNUeGI0ekxyeVVaTTZvZTBsOTRIK0UxaTFlS1A1a2t5WEtCeU9JN2g2VEEv?=
 =?utf-8?B?aFd4dzJTS1VrbXJ0Z3VzUklIckJ1MlpRbFF5dGcydVdpUHI0R0FPZTFPcnZB?=
 =?utf-8?B?aWRSckNndWw5cHUzTm14UTdEUVcvY1ZsNFo2bHEyYjBvSFhTMmxxRExVV0J3?=
 =?utf-8?B?WHd5cVhPUithL0E0WXR0Sk5PMklDY2VkUzdJQmhQa0xBMzVianEwTWZOd1R6?=
 =?utf-8?B?ZzNBRk5tTzNWQVlhdEJQd1l4bTNGSTBUMFFjejNaTTlERUdOSEdLUWU3YzlS?=
 =?utf-8?B?cjVrM2hSb1NwZkE5MkRrMjRMeGF6S1ZyZ2dCZ3NYNklUMGIzM1pMTmx4RzVV?=
 =?utf-8?B?dnNBb1BFOUZEVTRDNU1IdzQ2RmpoTnA2RGVuM3RmSTk3bmVaY0hWbXBLLzNv?=
 =?utf-8?B?dTVLVFZ3MHd4elNpV2tHdHptTHluSmFOZUc5dHJXZEtQVW5LeVE4eTk2QTZ0?=
 =?utf-8?B?Y1JJeUljUFE5TlRTU2prQ3BYMmdycFJnMlU4aE9QeFBCSlEwb3lzWEw3N1pJ?=
 =?utf-8?Q?g0s+3f5ILupBwID09lalKoQ6IwrZIc0ppZ8kd?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78fd6c2e-f236-4d28-3d02-08df198e96e0
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 16:20:31.9141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Snx2hi+jvRt3D/vF21c9GfrNWO18g0g59wAzkVA5y6k8by21YA7OQeSPd6vFGVIwqqgYKR70krxzQL8FfzrbDkOHDTXkvfYn6BjdwFYek1swy4Zcp4JC0MnLeer2AeH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10433

From: Frank Li <Frank.Li@nxp.com>

Replace direct device_prep_dma_(pq|pq_val|interrupt|xor) callback
invocations with dmaengine_prep_dma_(pq|pq_val|interrupt|xor) API,
consistent with how other dmaengine operations use their API.

Assisted-by: LLM
Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 crypto/async_tx/async_pq.c          | 23 +++++++++++------------
 crypto/async_tx/async_raid6_recov.c | 10 ++++------
 crypto/async_tx/async_tx.c          | 13 ++-----------
 crypto/async_tx/async_xor.c         | 19 ++++++++-----------
 4 files changed, 25 insertions(+), 40 deletions(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 5f62f2edefe58..6ccc1073c5ace 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -40,7 +40,6 @@ do_async_gen_syndrome(struct dma_chan *chan,
 		      struct async_submit_ctl *submit)
 {
 	struct dma_async_tx_descriptor *tx = NULL;
-	struct dma_device *dma = chan->device;
 	enum async_tx_flags flags_orig = submit->flags;
 	dma_async_tx_callback cb_fn_orig = submit->cb_fn;
 	dma_async_tx_callback cb_param_orig = submit->cb_param;
@@ -76,11 +75,11 @@ do_async_gen_syndrome(struct dma_chan *chan,
 		for (;;) {
 			dma_dest[0] = unmap->addr[disks - 2];
 			dma_dest[1] = unmap->addr[disks - 1];
-			tx = dma->device_prep_dma_pq(chan, dma_dest,
-						     &unmap->addr[src_off],
-						     pq_src_cnt,
-						     &scfs[src_off], unmap->len,
-						     dma_flags);
+			tx = dmaengine_prep_dma_pq(chan, dma_dest,
+						   &unmap->addr[src_off],
+						   pq_src_cnt,
+						   &scfs[src_off], unmap->len,
+						   dma_flags);
 			if (likely(tx))
 				break;
 			async_tx_quiesce(&submit->depend_tx);
@@ -358,12 +357,12 @@ async_syndrome_val(struct page **blocks, unsigned int *offsets, int disks,
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
 		for (;;) {
-			tx = device->device_prep_dma_pq_val(chan, pq,
-							    unmap->addr,
-							    src_cnt,
-							    coefs,
-							    len, pqres,
-							    dma_flags);
+			tx = dmaengine_prep_dma_pq_val(chan, pq,
+						       unmap->addr,
+						       src_cnt,
+						       coefs,
+						       len, pqres,
+						       dma_flags);
 			if (likely(tx))
 				break;
 			async_tx_quiesce(&submit->depend_tx);
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index 4f223fa36c706..0e3ae945154fc 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -22,7 +22,6 @@ async_sum_product(struct page *dest, unsigned int d_off,
 {
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_PQ,
 						      &dest, 1, srcs, 2, len);
-	struct dma_device *dma = chan ? chan->device : NULL;
 	struct dmaengine_unmap_data *unmap = NULL;
 	const u8 *amul, *bmul;
 	u8 ax, bx;
@@ -52,8 +51,8 @@ async_sum_product(struct page *dest, unsigned int d_off,
 		pq[1] = unmap->addr[2];
 
 		unmap->len = len;
-		tx = dma->device_prep_dma_pq(chan, pq, unmap->addr, 2, coef,
-					     len, dma_flags);
+		tx = dmaengine_prep_dma_pq(chan, pq, unmap->addr, 2, coef,
+					   len, dma_flags);
 		if (tx) {
 			dma_set_unmap(tx, unmap);
 			async_tx_submit(chan, tx, submit);
@@ -91,7 +90,6 @@ async_mult(struct page *dest, unsigned int d_off, struct page *src,
 {
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_PQ,
 						      &dest, 1, &src, 1, len);
-	struct dma_device *dma = chan ? chan->device : NULL;
 	struct dmaengine_unmap_data *unmap = NULL;
 	const u8 *qmul; /* Q multiplier table */
 	u8 *d, *s;
@@ -120,8 +118,8 @@ async_mult(struct page *dest, unsigned int d_off, struct page *src,
 		 * dma_dest[1] and ignores dma_dest[0] as a dest
 		 * due to DMA_PREP_PQ_DISABLE_P
 		 */
-		tx = dma->device_prep_dma_pq(chan, dma_dest, unmap->addr,
-					     1, &coef, len, dma_flags);
+		tx = dmaengine_prep_dma_pq(chan, dma_dest, unmap->addr,
+					   1, &coef, len, dma_flags);
 
 		if (tx) {
 			dma_set_unmap(tx, unmap);
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 01ef830675574..7eba152ecb97b 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -66,7 +66,6 @@ async_tx_channel_switch(struct dma_async_tx_descriptor *depend_tx,
 			struct dma_async_tx_descriptor *tx)
 {
 	struct dma_chan *chan = depend_tx->chan;
-	struct dma_device *device = chan->device;
 	struct dma_async_tx_descriptor *intr_tx = (void *) ~0;
 
 	/* first check to see if we can still append to depend_tx */
@@ -86,10 +85,7 @@ async_tx_channel_switch(struct dma_async_tx_descriptor *depend_tx,
 	/* see if we can schedule an interrupt
 	 * otherwise poll for completion
 	 */
-	if (dma_has_cap(DMA_INTERRUPT, device->cap_mask))
-		intr_tx = device->device_prep_dma_interrupt(chan, 0);
-	else
-		intr_tx = NULL;
+	intr_tx = dmaengine_prep_dma_interrupt(chan, 0);
 
 	if (intr_tx) {
 		intr_tx->callback = NULL;
@@ -221,21 +217,16 @@ struct dma_async_tx_descriptor *
 async_trigger_callback(struct async_submit_ctl *submit)
 {
 	struct dma_chan *chan;
-	struct dma_device *device;
 	struct dma_async_tx_descriptor *tx;
 	struct dma_async_tx_descriptor *depend_tx = submit->depend_tx;
 
 	if (depend_tx) {
 		chan = depend_tx->chan;
-		device = chan->device;
 
 		/* see if we can schedule an interrupt
 		 * otherwise poll for completion
 		 */
-		if (device && !dma_has_cap(DMA_INTERRUPT, device->cap_mask))
-			device = NULL;
-
-		tx = device ? device->device_prep_dma_interrupt(chan, 0) : NULL;
+		tx = dmaengine_prep_dma_interrupt(chan, 0);
 	} else
 		tx = NULL;
 
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 0fb29da2235cd..3cbe08883085b 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -62,9 +62,8 @@ do_async_xor(struct dma_chan *chan, struct dmaengine_unmap_data *unmap,
 		tmp = src_list[0];
 		if (src_list > unmap->addr)
 			src_list[0] = dma_dest;
-		tx = dma->device_prep_dma_xor(chan, dma_dest, src_list,
-					      xor_src_cnt, unmap->len,
-					      dma_flags);
+		tx = dmaengine_prep_dma_xor(chan, dma_dest, src_list,
+					    xor_src_cnt, unmap->len, dma_flags);
 
 		if (unlikely(!tx))
 			async_tx_quiesce(&submit->depend_tx);
@@ -72,10 +71,9 @@ do_async_xor(struct dma_chan *chan, struct dmaengine_unmap_data *unmap,
 		/* spin wait for the preceding transactions to complete */
 		while (unlikely(!tx)) {
 			dma_async_issue_pending(chan);
-			tx = dma->device_prep_dma_xor(chan, dma_dest,
-						      src_list,
-						      xor_src_cnt, unmap->len,
-						      dma_flags);
+			tx = dmaengine_prep_dma_xor(chan, dma_dest, src_list,
+						    xor_src_cnt, unmap->len,
+						    dma_flags);
 		}
 		src_list[0] = tmp;
 
@@ -335,15 +333,14 @@ async_xor_val_offs(struct page *dest, unsigned int offset,
 		}
 		unmap->len = len;
 
-		tx = device->device_prep_dma_xor_val(chan, unmap->addr, src_cnt,
-						     len, result,
-						     dma_prep_flags);
+		tx = dmaengine_prep_dma_xor_val(chan, unmap->addr, src_cnt,
+						len, result, dma_prep_flags);
 		if (unlikely(!tx)) {
 			async_tx_quiesce(&submit->depend_tx);
 
 			while (!tx) {
 				dma_async_issue_pending(chan);
-				tx = device->device_prep_dma_xor_val(chan,
+				tx = dmaengine_prep_dma_xor_val(chan,
 					unmap->addr, src_cnt, len, result,
 					dma_prep_flags);
 			}

-- 
2.43.0

