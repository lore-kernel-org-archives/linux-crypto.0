Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011060.outbound.protection.outlook.com [52.101.65.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C244E5519AA;
	Wed, 23 Sep 2026 16:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180436; cv=fail; b=D+/+3del/AZ8HW8NV55iMvd1+7P6YqnpBAw3GaCAmLUpt38Rke+S3nWMxgXvsAcGukgZnBUJEwFthKw5wdxCNe691VyDMHTG2l6Ec6KWxhzU07DAYUB2EQv5SW64XcehrbC8ja+vKALQf1CpTjdWzO5S1+Jhk5PWnxjzE6yWk1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180436; c=relaxed/simple;
	bh=dW5G7JLnP8MSPRjMRmILRvlC6OEYUNLhFv/RNFRR9l0=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=jy77zS3aFbTaoaaghvY9YgSZbcU250SxHgw7I66F3kJ50p8fBgxZb1Fvhqnwb9BMPsOyvTENGUAwuoLJVF7vVecYC+pS7t9FI5BFBYPZ1HHhosUR6wXNDGp0MXdBqPfxtpW/fLmgzxMFukluYXQ+gKSrQnnaK+OLn6r9oOOEgn4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=ftT4WKsf; arc=fail smtp.client-ip=52.101.65.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="ftT4WKsf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VtCRFfbmj418EqUYP9StwLaTjlHushLyoGtPSMMptcEVzoUexWKU0kdBa3eiupCMo2n+fn07LZbpoBmktOqkYm9J+uQI6M8Pbv9yfrb12Y0ZsLy7/pXMq40zBNaMXvVJy4EHudXYarMaYHsorAGiCTNGoQiz6I055rlFEX6oIQp9ZZ4+ehWtxUQPOOFBNXTWFPzsi1vJDllvCZjT77Wkk//f4Oem2Kc+i5bUrsKHDysgUNTWV4pMhJNkNRirHFT13W1OQ6z053WeFLmZcl+Ai2H076js0AyikETgB20ve9VS7f98xgzh1otQsCBkGvR4rkikCSdLWtVZJLfvfUz28Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bN61GqsN8eQsc5ClI3D7DCETdJGRuIO+uATScPR7rZw=;
 b=HaAWG0tOMKxrnhovGnw5A95i+0ngP3Bjx15C4EQYaOnxYB2qeMktfnuTzSDWMye4mm4O8/pfi2gkVziH5NaPyjYQ53aCai9UUqDsD/sNwCk6CiOznbA+e91PJI08sfAVBSepq0GHfD9iy1KZH7hCjlmerUFDDH+x/fDThj7U4uFlgww2B9ZF6GUmlour2Dy9AwT6Qs1BFXQn0djCE9V9J4TxqapaG56KhX29A/v6ag+AexNZyAEATtHy+DehwVVqdHX3lECcyYTYMQ9Q1aig5CEnejIiMoAXYwL8QwV4H0/awTFbK0s0QME6E5kWGMc+tein6IxGmtJK7jOimoUXEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bN61GqsN8eQsc5ClI3D7DCETdJGRuIO+uATScPR7rZw=;
 b=ftT4WKsfzuLlIR8eMxPcLnXZHj22GBkrEfLX79APeGSpExgIf0bkYi8Br0+rGpmM3un+2hA2o8N/fDZCTfDSF+9oR5dkTw9q/kj6YqFmJZDyjZGpwzoNbvzckOaPrTm6LWtLg9GbWZa55n6H134qqC2BX3CNfHfuVmbFNrss+Kn8bprUE6qA2/Ngk2o5PacHSK83hxzJlqxWb66kNaBdq8AletVBC/ZRe9wm22AzGx6QGEwEdMWEXV5BAUHsMeF3qMX07NiIrVKPZJ+9sBgVvaI5GdE/DfDG1ebN0lBFdZKrHPnJ4PtL8k/pRTT47pYPSKmldR2FFlzPfefhmZh01g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DU4PR04MB10433.eurprd04.prod.outlook.com (2603:10a6:10:55f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.17; Wed, 23 Sep
 2026 16:20:27 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0428.015; Wed, 23 Sep 2026
 16:20:27 +0000
From: Frank.Li@oss.nxp.com
Date: Wed, 23 Sep 2026 12:19:38 -0400
Subject: [PATCH v2 09/12] dmaengine: replace dma_maxqp() with
 dmaengine_maxpq() taking struct dma_chan *
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-dmaengine_prep_dma_pq-v2-9-32ed65b8a9b4@nxp.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790180376; l=3731;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=cI5h8Begg6H36N7sShE+QWEKUwgV9+nHvjiiqBgXLWU=;
 b=w/gsQLsZ1423vq4fhv9o/LhhmPVpDNTLvfUCT8g2zaOAKY1uh6f1hp311y9Zf85UTszURmppd
 X/u+Lx0ZyL/BuPXx7H2cwEThDZPKzjW+GaCGOxPamkeS6o0gJJ8G3CW
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: CY5PR15CA0248.namprd15.prod.outlook.com
 (2603:10b6:930:66::15) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DU4PR04MB10433:EE_
X-MS-Office365-Filtering-Correlation-Id: 0622f8aa-a810-40b6-0ef0-08df198e93fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|19092799006|23010399003|18002099003|22082099003|3023799007|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	do6GGM23in+pidfsbBv9RJ5UrINidBjIIS1UoH9xkmvbzD5RehIB1csh789kSGY8DSsWD2gmrMdmmZi5LuNR+hJpI+eQPOK51jIlx5lNhbQSyDYxKxHqF4V5h7b2/Lz2pNMMKe4MV0uhk/yVSgrT+hW8X0Zsg5AjXeYoBYbMhjtCxBxkNA5v44bqZxJDDD/RpYplecyxMVKfVplf/R4qDAoFj1IXX9zQgW+RhEOEVbDnb9Fy5K4tDh/i5XlWGfXCrllaKAyiC/WvvefXcf1dT4nHhEQH2j1x7dAv2+8pyDh84j4GaKYrfkwnYCthk0k1UIK8p28LlCOqVYtMGKH/TpcK0fg8rzbnrhRlVZmpOsYsBW2H1pJlhM/XysZCCyjDUvXxOW8J7AIB1rmdP2hP7c+WQIEwLdHnKR5R6KPzWKkc5UztYXmusA7tPydrVwBKXXa9rzMk+78ZiAImTzBP/Kk9bkmuGvps1QWfCaLpoVikT2/PoBFLhZKP44pogXx+7hT+P2ZwukQ+EBjqYVQya5w2aHFtygJ07V2k195VLpbWKEA4q5o/z2oofm4EBop0st8RkP3PLs3Va4AbYYxzWhwoBwmeNr2cWUi7s3JPQ5yxbf3Yj5RfZL5qyBGm2cosPu5JXv/I9gOK7mrRmFj9B6TWa0hBsutKg47OTYI6v8s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(19092799006)(23010399003)(18002099003)(22082099003)(3023799007)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YkR3UEc5UXF2ZEs2QUNXYzZ0c05DSnpJYlNISVFxaFh2Y1BrZkhuYi82K0R3?=
 =?utf-8?B?TWhjRWJoc2Z2RmtRTkM5SkQxTWtQRzZzMnROMmppZElLZjNlQkFpTk1aRGVm?=
 =?utf-8?B?NjRBR1ZIV1hiWGJxV3BmQ05kTVRBa3p4NTVTVTVXOVI5cC9mbVZLZWpvTEww?=
 =?utf-8?B?VnVhNWlFZzVoUHZsMkFYemg0Y3JSSnJPQ0NaLzVVdGtZWnpTbS96WHVpVS9Y?=
 =?utf-8?B?bWhqUXBJcTlQaCtRSEJaMmhRUkJiOFFmc1VSSmVUenZTTnJhUzhuV3JGaDNZ?=
 =?utf-8?B?R0ZjNEJJL1RGMXZLLzhVQ2xaeG5xdVZIZWc4eWwwT0F2bUxHeW8zVUxGSmo0?=
 =?utf-8?B?V1E4WVZkd09OMWdHN3BrUHpuZ3dRdnNDSnpaK3RkRW0yVkM0TWp4S1A5SWto?=
 =?utf-8?B?bFpvWkEzUms0YitUY2drMG9rUlhHaDBXenQ1Z3NUMlVXblUybXd3NWRMb2hz?=
 =?utf-8?B?d2pNdXlVWUpucStRYlYyVmNmZEZseEt4M3g1V0N3dm1NYitScDJzcmNTSlhi?=
 =?utf-8?B?QUpJbTRFM0pYSWdpc1F1ak1ZY2oxb1VoRTZMSDE2aTlxKzZlaGtCNk1NbUpk?=
 =?utf-8?B?SUsxVE94dlZGR2hmUjFqME8wK2RMV09uVWwrUEp4WC9Lc0lYSWoxSXZDL2d6?=
 =?utf-8?B?OHA2bTN3eHhHUFBCV1VRWXcwMUJ6RkI1Z1NjcVF3OW5mS2hqdTBBQWl1M1k4?=
 =?utf-8?B?a0s5Yk5xdWVuSy9TdmhVOUFZVkxKRW5OaWhEdGFRampMTHVBYWNGekladHVY?=
 =?utf-8?B?ZkFndytBQzlkQUFZM0ZpZXg0NkpxWTVYQnhpRC9kNngxcUt3U01aMmRzNzZT?=
 =?utf-8?B?VnZQS3NOaVVBM09pa3ZVL3N2YkxDRU45S3p3SjcyRzd6UThUR29TNXpwNWFY?=
 =?utf-8?B?cEh3NUFLVzlwc1NkeUpaRnNHZ2ZPSTJtT2FjYmEyalZiZk51TGl2dDBYYzN1?=
 =?utf-8?B?YmlSRmh6d0xYU0JKdkNUR2liQWNQS3U1TEpqK0lqUnBscXNaMExUZkVIYWFw?=
 =?utf-8?B?MmNpR2NnY1lEa2gxL1ZIL0hwZjZXcTVHOXFUeEZsYThNRVpFZm1xakRzUDdW?=
 =?utf-8?B?N3pudTFWbC9UYXJEeFZaL1JJME5LdUJKWkNpTHBrKzY0Q3RZd0RlZTRlOWRW?=
 =?utf-8?B?WGVKZkxUMmIzZWFDMXJaRDh3VTRPaHNUWC9oRkJOY2l0a0FpVExFa2gwQjFC?=
 =?utf-8?B?MTNpZndFKy9QL0dleFJtN1dLcTJ5eURCa0lWajcrVHpBUzErV2tYdFVmN1Fo?=
 =?utf-8?B?UEJwbk9zUkJEVmR6V254ZFBaejF5OUpXNzlBR3RuVlgzRVl4RWJ4NTF3RnQ2?=
 =?utf-8?B?ZTFnYmpINm1RZkxqSENlVDJyMFZLNUdKRU90TlkyRndZWlIxcHNieWcvcVVD?=
 =?utf-8?B?Zjl5NEtkZmg1WTVKUU9YWVduSDRmSXpDOEZ4RWhmcVprSDJPbDR5UkZCT2Jp?=
 =?utf-8?B?WUZhbGhTUUpheFpWNEZLZGVXdk5WZDlRRHNmaEdJbWI0WHEwOGJlRFJDYnpw?=
 =?utf-8?B?RGpwdmJOenNOL2dQUTVTWFpKTkRKUnUwbGJaTFltYWltZ3VDVjJBU3BCRHdL?=
 =?utf-8?B?TysxaFpWa3c0M2I3dWdrZUtBNkkwUjZ5d0pWTUVsTnozTUpwbTBnRi93YlBL?=
 =?utf-8?B?bWc3SndQM1g4d0hsYjVPUk1wQ2pXZU1UYVpLZThLaDJxVks4K2x6Wnl4azhx?=
 =?utf-8?B?Vi9jNEdjbE5BMDN2Mkh3Z3BKaDJJaVZXRGRFSDlBdTZlcW1iSHJIcUg4SGhP?=
 =?utf-8?B?VE9LVHpFTGFleFlsd3F0RFNHZXpYbU1SMUJlN3FnLzhPWDkyaFpGRnNtOWtO?=
 =?utf-8?B?Q25LRDBqbGJBeDRiZ0hONlp2c1lTdXpUWndWRG4vQ0VXek1JNDRyZ2pMSHhp?=
 =?utf-8?B?dTYyeW9kVWtJbGJvcHc1L00xZi9jUDA2MkZkeTgxV1gyR0hkTG5ORnhoeVlP?=
 =?utf-8?B?WUw4SHZ5LzZMV2k0SXRTR1lJc21tRWIwVnFJQWhHdSs1azUwS1VjM3FPSndk?=
 =?utf-8?B?TFdRUlh4dm5ZUHl3VjhwSWt5bWE3M2M0VTdLbDBOQmN3ODFXNHc0Z3pHQUw1?=
 =?utf-8?B?OWpQVFBxeGhoNVdpdE5ISk1hSFl5QkJCaWN3NzdGRk85bUxKQTNDSTRPUmg2?=
 =?utf-8?B?VTl6c0p6dHdQN1Y5Lzg3ejcrZitxMnUrbEd1d1RnQkFhVzNrYWt2ZVY4ZCsr?=
 =?utf-8?B?bXBlZEtXSU9nM0Q1VHczOGFjaFZ1Sy8xbUh1cTg4a3JnaW9rSTVucDJzNnpB?=
 =?utf-8?B?VmtoUk9OTXFzVEVjNndRU0dDRm1IQVU0MmtQLzd5MFpQZmpET2JYMXduaklS?=
 =?utf-8?B?RjU4WTZ3RFlOVUhmTWc0NkU3WkhsaXlRVWp5T1V5Q013eFRPYjBrWkNKOXVa?=
 =?utf-8?Q?KsRIBap1gVttNkLS01cdu8pBqGWNq5j2Lb4la?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0622f8aa-a810-40b6-0ef0-08df198e93fa
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 16:20:27.1623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oWDX9kSQ1hvr5bSKVy/THaDKmK2A9KAuTDJcsHKoOhtYkxtW9TRI5/0t25+EA9L1o+5GNNHKsYvVwYTO3acHiXUA5FbCniwsJ3ay0JRST3d+NsaJ+jQODW4c6mG7OcED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10433

From: Frank Li <Frank.Li@nxp.com>

Replace dma_maxpq() with  dmaengine_maxpq(chan, flags) as a channel-based
API, consistent with the convention of other dmaengine_*() helpers that
take struct dma_chan * rather than struct dma_device *.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 crypto/async_tx/async_pq.c | 8 ++++----
 drivers/dma/dmatest.c      | 2 +-
 include/linux/dmaengine.h  | 6 ++++--
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 580936eecba1b..5f62f2edefe58 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -51,7 +51,7 @@ do_async_gen_syndrome(struct dma_chan *chan,
 
 	while (src_cnt > 0) {
 		submit->flags = flags_orig;
-		pq_src_cnt = min(src_cnt, dma_maxpq(dma, dma_flags));
+		pq_src_cnt = min(src_cnt, dmaengine_maxpq(chan, dma_flags));
 		/* if we are submitting additional pqs, leave the chain open,
 		 * clear the callback parameters, and leave the destination
 		 * buffers mapped
@@ -192,8 +192,8 @@ async_gen_syndrome(struct page **blocks, unsigned int *offsets, int disks,
 
 	/* XORing P/Q is only implemented in software */
 	if (unmap && !(submit->flags & ASYNC_TX_PQ_XOR_DST) &&
-	    (src_cnt <= dma_maxpq(device, 0) ||
-	     dma_maxpq(device, DMA_PREP_CONTINUE) > 0) &&
+	    (src_cnt <= dmaengine_maxpq(chan, 0) ||
+	     dmaengine_maxpq(chan, DMA_PREP_CONTINUE) > 0) &&
 	    is_dma_pq_aligned_offs(device, offsets, disks, len)) {
 		struct dma_async_tx_descriptor *tx;
 		struct device *dma_dev = dmaengine_get_dma_device(chan);
@@ -313,7 +313,7 @@ async_syndrome_val(struct page **blocks, unsigned int *offsets, int disks,
 	if (chan)
 		unmap = dmaengine_get_unmap_data(chan, disks, GFP_NOWAIT);
 
-	if (unmap && disks <= dma_maxpq(device, 0) &&
+	if (unmap && disks <= dmaengine_maxpq(chan, 0) &&
 	    is_dma_pq_aligned_offs(device, offsets, disks, len)) {
 		struct device *dev = dmaengine_get_dma_device(chan);
 		dma_addr_t pq[2];
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 043bb065dd68a..01ab33580da81 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -636,7 +636,7 @@ static int dmatest_func(void *data)
 						params->alignment;
 	} else if (thread->type == DMA_PQ) {
 		/* force odd to ensure dst = src */
-		src->cnt = min_odd(params->pq_sources | 1, dma_maxpq(dev, 0));
+		src->cnt = min_odd(params->pq_sources | 1, dmaengine_maxpq(chan, 0));
 		dst->cnt = 2;
 		align = params->alignment < 0 ? dev->pq_align :
 						params->alignment;
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 63f40b8fd3009..34fd3bb32f86e 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1706,7 +1706,7 @@ static inline unsigned short dma_dev_to_maxpq(struct dma_device *dma)
 	return dma->max_pq & ~DMA_HAS_PQ_CONTINUE;
 }
 
-/* dma_maxpq - reduce maxpq in the face of continued operations
+/* dmaengine_maxpq - reduce maxpq in the face of continued operations
  * @dma - dma device with PQ capability
  * @flags - to check if DMA_PREP_CONTINUE and DMA_PREP_PQ_DISABLE_P are set
  *
@@ -1719,8 +1719,10 @@ static inline unsigned short dma_dev_to_maxpq(struct dma_device *dma)
  * In the case where P is disabled we only need 1 extra source:
  * 1/ {01} * Q : use Q to continue Q' calculation
  */
-static inline int dma_maxpq(struct dma_device *dma, enum dma_ctrl_flags flags)
+static inline int dmaengine_maxpq(struct dma_chan *chan, enum dma_ctrl_flags flags)
 {
+	struct dma_device *dma = chan->device;
+
 	if (dma_dev_has_pq_continue(dma) || !dmaf_continue(flags))
 		return dma_dev_to_maxpq(dma);
 	if (dmaf_p_disabled_continue(flags))

-- 
2.43.0

