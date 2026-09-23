Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011002.outbound.protection.outlook.com [52.101.70.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9DF46C85E;
	Wed, 23 Sep 2026 16:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180406; cv=fail; b=Sg9ANzcigxVDAL53NOSPnIMz/UY3rZ23h0Q8ZcksXc6J2L+q9jVIzf6LVpp5HwmnwPmsP+c5IygF5ZwfkNxgUWhJc0eU0AHKefyj9FxVECvP+Lqc9d26BWxScZls1SQ5zBKHAFSIzmZKYJ1C3DPYO/A0r+P2cVtzghWe6q2mxME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180406; c=relaxed/simple;
	bh=XXDZa0fldTMEp8iAUiTVQReaO9dGN2dBP5eLRD3rdTY=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=nIr7RQ75lEuzbukubwsVCndn94gmDWo4vsyQvCvEljVXHdvB6sS0/0WRqUg8MXyc7taiWDE90E+u7XzNrAZIpg2ZwmDemfjuhxX15MpmcGA1YGc9wwMozilFyncvU+fZPfBOVj1njTWIrbUmCH7+oMl0JoC4CX5oJJcZ6bgnMCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=SWcDBPV6; arc=fail smtp.client-ip=52.101.70.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="SWcDBPV6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A/MoU2z9r3+YwzLg7DpGAE4svGiVeZ/deuAfa2E71mYsFE7QRoYELXc3NMAZg4AmLZML1sD3hhqiHohY45q61JHZAGdP+yPlIo8qEkX712SYGIFIDhpYZpDBNgo2WJbqUltuGdqzlCGA7+yyfk9ArRcYf1ANhkfQZ2zqF5+NWG4xOc8R7UEDXSSxhHSEkjmGCfm2OD3pQgrDzAUff7WYoiV3PhjDVheahYjgz9XJfUlef4J3IACgDnJ3qQm1aMDFcsueVyKyWU4Oaub7+i997gN4bwWE9IWXt8bnWOx37l5D04V1Mm5PklTZeS6dx4Lkt7Gdb6428yhs+3TGeg9ehg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BR469c5W90ajpdexETWSfN2htmkBoa6khGx4l5kN+D8=;
 b=PXF+tCvD7hFlTK3Zo5qO9zgwAvbTTWCuRq56BPLWkR3kH/UKyh7OOP8DEMtM+i7lFs1PAJ0wv5B8EQvDjjMZ4HrsT+WFtaxACQIHbR7HvSUFFbtFyHZJkOGD2+X3maOrrlXwoVGaiVWp8E78Yzd2jaZMeyxoh9T84eJQT7U9N4cFHHBZEzNwpfXLO8tKWMDhXO00ZQg4lU32X334hrU79H2U0g7pFlVpK9/dFTAy7XvENCtLNybD8vuxm4pHKXzUSeUajhYrl2Pg36bUEXNaNw/EpFYX9rySyx1tC0/ykiPlIfypcKQr3axndI91pPUzRpFPIigvFkg/WtYDSpCD0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BR469c5W90ajpdexETWSfN2htmkBoa6khGx4l5kN+D8=;
 b=SWcDBPV6jkcPSHnjaGihLrh2hIu3kAJ/zgvaSUGenrXdl9h4fj+WeeEv6npk9CvjhXADXfReBPFdsW2yGCM/qnFdYLa4HqxBcCEemSys2NoIQzmxjEqTXQ4Mkrs3BCk61YBCVysc8FzSIcUyeu0UGWEFF9H4mCSN8oHp9MNICacXvuxTnzI+1mfvSd7Mt8zx1VYiPEKyPo7t3qvwm3Orson5dXXVo2mKgs+0NyqOoutwd9PDZO9ah2PDyRA27DAhw1/wnYgCtGmk4EQvIfEjSvGhSWjvEC1/Lkxj58gllPXHvp7QEDtS48R3CgqVDQS+lRo9xNTKqj2QpTWsWjr23A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DU4PR04MB10433.eurprd04.prod.outlook.com (2603:10a6:10:55f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.17; Wed, 23 Sep
 2026 16:19:56 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0428.015; Wed, 23 Sep 2026
 16:19:56 +0000
From: Frank.Li@oss.nxp.com
Date: Wed, 23 Sep 2026 12:19:32 -0400
Subject: [PATCH v2 03/12] dmaengine: add
 dmaengine_prep_dma_(pq|pq_val|interrupt|xor)() API
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-dmaengine_prep_dma_pq-v2-3-32ed65b8a9b4@nxp.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790180375; l=6855;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=prNdM7OARrJ6YMH29f3XHgl7NJH+49TuwBrbB5M3cLs=;
 b=HOxfwVi37xqDrVDQ4pKbEJAlxVv9KkynCcGLpbTZpKnCAXpVcugSVEki+TN+GLBCM+17QfedJ
 yAdIOiuGfrABDlXvFtBHM7U8D121+tbVA8YSQWkr+O7EecP1V9NS4a0
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: CY5PR15CA0104.namprd15.prod.outlook.com
 (2603:10b6:930:7::27) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DU4PR04MB10433:EE_
X-MS-Office365-Filtering-Correlation-Id: abaef52f-ca9f-4a73-d7c4-08df198e816a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|19092799006|23010399003|18002099003|22082099003|3023799007|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	AJqzXyQeAbrb7VI5XgFPdrxYC56F4Ky3vMAns8XYcSx73lOPpihEteoshN2nQtKKe0bzXgh/otJf+y85vUEUov5zpLGAvJepFCz9EX+EjvPvRMKqy/kqGGU2VyDxY3ZSuUsQHT7aTQp9I8amrXLIYYGc+u0Izs3XXXLRtoVZR9NS752DWiAgUuhxOS1bqVTSGF96XolHzS/OFHx2woEcl5hUmiwn79a8r6VuAPBtWOUPA15eyzWrJEjNY9McAfCLemMbE59Y788/hZHV89SnHO+Q6cXdbRqORFjFiUq2fdJornlTPjwap4CopQCsID9MDI4+WVHcimJWnpNgoSdkQLd0ytCe/2AiRTdjcYs1Qfhe1p+2Mf3r3zrLKbdq7Sk37PYxmLN+NQRIk6fqgsBMjMzDKuI2hg/lzyQMtUKyXkCqbqwd3sSwv1t7iy/s3QYj3tBRN7wjX3Lbm7QQMvSvw/9nUFxPK6slWI6rruUCSULKRc3PKVus/7Pz4R3qe6kDQIppTfSSzO5Ik/kc6RDpMqLgTJ5DMA2zb7azL8+V24KUxOcM3QfYDKzW2ad7jfz4j0ZEyaKjbPnWtugkbccFL9KXaFHfBp+nSUhGprASx/0WAKJ4krVhRiYlVWLtxv3BHciw9FcvkXh+yjky8ukSdIUUyocGAdx4Js+5ESSxRA8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(19092799006)(23010399003)(18002099003)(22082099003)(3023799007)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WXdhaXdwb0RVSUQ0TFkvSnhoWXRBMWxTUUozcS9YRkFhcEdnOWZnVEJUb2lQ?=
 =?utf-8?B?MTRCZmpuVDBpMm1jUVlmbUpPQ0NHU29VL3JnVjlTYzhtZ0dYL2JhUGxQODVk?=
 =?utf-8?B?Z1RXQTJrbk5POHkwZ2VJSmd2N09IZ1BIeVB2Mys0N3dmSml5VW9oTkFGc2V6?=
 =?utf-8?B?bHdNMFkxZ05Xa2JicWcwTGxBNmd6bXlWLzVXQmZUUGVxU1EyOU4xTVFqY0F1?=
 =?utf-8?B?T1BDaDlRcGlBajU4cHNjZVdqMVFHcVV3Uys2UW9oZEFuY2dlRjBuL3BFNDU5?=
 =?utf-8?B?SjdRck9pOVhXaEZTVVhNSjhNTkJXWmY5ZURFdzIyMnpDQlZVbTJBdUVlV2o1?=
 =?utf-8?B?REMxdFQwU1pFMFN1SWN0N2ZpWHNIREdqb2w1d2VLYjU2UDlnODJFVnZnN05l?=
 =?utf-8?B?Q2dFbDM0emNWSDAwMGc0cFg5dWZSNHNtUUFEVWtoTVpwb0JMV0E3azZYbUlx?=
 =?utf-8?B?ZFRsQW0zZHZ5eVQzS2QrSEdnRWxqN2dDb05HUFhnTGZLenBxZG4xWFlOSElI?=
 =?utf-8?B?L2Z4Qnk1bnZtcldrODZlVDVVOVRoaFNQa08xem1aQWNmRVFpcEZIendrd25N?=
 =?utf-8?B?ZFVWZ2EwRUdYd0VBZFBvZTk2SVVMMHlUdVVGSG1wWVZCYkdJLzJDME1FdjdD?=
 =?utf-8?B?U04rM05qVHJJNXVTV1pyQ2tZN0tSYTRjTzZKcHJuOGRiaVp6Qk5zTTZHVHVN?=
 =?utf-8?B?N3lhcFVtQjdjc1p6TmFNZXZKc3lWSTFZT21IZ0dYR3JjK1Z3cGNSWWYrcWo3?=
 =?utf-8?B?TGx3OVBiV3ZObWlVTE0zb1ZxZ2RmV0kwUm5ScWFIMDd4UWhDMzRQV0R3TStp?=
 =?utf-8?B?Sld0UU5UeWV3Y3MrV1NkZC9jN1ltcDlDYjFTRVBMYVhwTWwwdHNuL1prM0o3?=
 =?utf-8?B?Tm5ZejZsRnZUMFJWUGtPZGpmSEl2ZVFWL0lFSHphRlpuVExXVHljWUNWWjhx?=
 =?utf-8?B?TFF0TzkyQllsbVdsbW9BTHZYWUY2MmF5RnRhdmRncWc2OWwrQWt0UlhMeTZh?=
 =?utf-8?B?emNkaHhmcGt6L01mN3ozK3lhUkoyZmhOWTZIcmlvTGw1OEc1c1djb2FvMy9s?=
 =?utf-8?B?YkV0RVpmK1pqWEpJbnlDaEF1eXJ4SkZnRUVreDlRSmthNDRYa1VqK3FUZjlp?=
 =?utf-8?B?b2VqYW1zeG9tSTk0MVVmVjg1d0JxbkUzSEpnTmJWZFpGTy9VTlU3MHBudHIy?=
 =?utf-8?B?bjQrNElSODNQUmswcFR0Rld3OWJYTFRaRldqZ3hVY3FsQldnVDk4NDV3MlhT?=
 =?utf-8?B?OUVhWVNJalRsK1ZpUWpONkhXYm9RcERQWVVJQTc3OEVjMG81eU1rTml3aVQz?=
 =?utf-8?B?REtOZWpmQmEzdkxRL2tzeG8vd2xwTXNXdzlFbTY3YVJPNmVKUFdnMzZGVmRD?=
 =?utf-8?B?YWVoZUNZemZ3M1ExSTVCVXNJOEF4MTlJVlNzeGlBQlFxTmIyVm9PT1pCZUtp?=
 =?utf-8?B?Q3dwL1pIdm4yNXBndUkwSzduTE1vSkF6WHZLZkh2VGdpTDlCVTVQU1Z1ak83?=
 =?utf-8?B?UUxwZ0d5aU9hUXQzcXZMbDhlK1hiVzFHSlQ4ZWVlOVpGT0FvWlhYQXl5dytV?=
 =?utf-8?B?RjIzTDB6SGNNajRFTjN5TS9JL1FNeUMzOTljR2U1YVo1NUs0bGFzN2NLMUVo?=
 =?utf-8?B?L0l3WnlheVVYc0RZeWtTRStVVjVGS2dmUjlhbnVUcFFjZFhCKzloUjlVQzRu?=
 =?utf-8?B?MkEvbnJCZ2xZeXFVZWRzaVR2SFZib21RY3l3bzZqemUxbHJKTVg4eDh4Qk10?=
 =?utf-8?B?M3JVS25KYlRJSTFQQ3FFK2hYUHJGOWVaSlVxYW5hQUUyUGxqcWNaK1dKTG16?=
 =?utf-8?B?VUVZcXR4eFFWM1hheGxZaERoUElxeFcwNzU2cHREdTRiZTZzeml4RU50Tldh?=
 =?utf-8?B?aEhpTWUvM0pNMmZGbGprVEhqRnFtVHU1MlptYVowWU1Fb2dESDEyaE5MWXRm?=
 =?utf-8?B?ZVpKanlpVWdNenZNdmdNZWIzeVlrcmN2cGZFbjVqRFYrUzVOT1FTWS9HckF6?=
 =?utf-8?B?TlR4bCtDQmlLWkF6dzZBcnpwYzNMajIwQlo3djJuMTRFWFV1ZVoxNHBvMjEz?=
 =?utf-8?B?K2ErV09DaW1tVm9CUlBORXlKbDk1MDJDM29KVWdHR1gvRm45d3NuekpHVSti?=
 =?utf-8?B?YThxQ0d0YWJYV3crTkVBVUgyVHd4cW1xL2J3VmF4cWo1enE1WHRFdEl5Qmh6?=
 =?utf-8?B?MEhMUTBZQkxNeUF5YnU2RExqWVVsOTBPNDA5ZVJKVnlxcnVxUFFEa3hhK1BG?=
 =?utf-8?B?K3RlVDk1eXdiRGhNWWJJVWViUkhIdEJMaktxWWZ1RVZ5Y0ZxQVBxQ1JxQkx0?=
 =?utf-8?B?Qm80RDhBS2h1U2swMFR6UUZTZ1JSb0JHTjBuVVlhcWRsc0orZHN5RklydEhH?=
 =?utf-8?Q?82ENVa5EnwjoqBh3SKdk/mz8xm4WTc0UatNfj?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abaef52f-ca9f-4a73-d7c4-08df198e816a
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 16:19:55.9185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kQv3PSWopCSy2dBSrKcj/j2wrhzIqrrKdUZNqDcHjlPkhoPWj3WsOXckK7TaV6U7q8RaHZ5gbdzAVPGkEBMyqJYSIvPHdQQ21trqX1WDG7mInq70NRP/RvsPNxBxx5FR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10433

From: Frank Li <Frank.Li@nxp.com>

Add dmaengine_prep_dma_(pq|pq_val|interrupt|xor)() as an inline
wrapper around the device_prep_dma_(pq|pq_val|interrupt|xor)() callback,
consistent with how other dmaengine prep helpers like
dmaengine_prep_dma_memcpy() are structured.

Provide a clean public API that hides the direct callback access and add
proper NULL-checks on chan, chan->device, and the callback pointer.

Assisted-by: LLM
Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 include/linux/dmaengine.h | 134 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 134 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index c3a49a33307c6..6a187136f9493 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1232,6 +1232,122 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_memcpy(
 						    len, flags);
 }
 
+/**
+ * dmaengine_prep_dma_xor - prepare a DMA XOR operation
+ * @chan: the channel to use for this operation
+ * @dst: destination buffer address
+ * @src: array of source buffer addresses
+ * @src_cnt: number of source buffers
+ * @len: length in bytes of each source and destination buffer
+ * @flags: DMA engine flags (e.g. DMA_PREP_INTERRUPT)
+ *
+ * Prepare an XOR parity generation transaction.  The engine computes:
+ *   dst = src[0] XOR src[1] XOR ... XOR src[src_cnt - 1]
+ *
+ * Returns a descriptor on success, or NULL if the channel does not support
+ * this operation or the request could not be queued.
+ */
+static inline struct dma_async_tx_descriptor *
+dmaengine_prep_dma_xor(struct dma_chan *chan, dma_addr_t dst, dma_addr_t *src,
+		       unsigned int src_cnt, size_t len, unsigned long flags)
+{
+	if (!chan || !chan->device || !chan->device->device_prep_dma_xor)
+		return NULL;
+
+	return chan->device->device_prep_dma_xor(chan, dst, src,
+						 src_cnt, len, flags);
+}
+
+/**
+ * dmaengine_prep_dma_xor_val - prepare a DMA XOR zero-sum validation operation
+ * @chan: the channel to use for this operation
+ * @src: array of source buffer addresses
+ * @src_cnt: number of source buffers
+ * @len: length in bytes of each source buffer
+ * @result: output flag set to SUM_CHECK_P_RESULT if the XOR of all sources
+ *          is non-zero (i.e. parity error), cleared otherwise
+ * @flags: DMA engine flags (e.g. DMA_PREP_INTERRUPT)
+ *
+ * Prepare an XOR zero-sum validation transaction.  The engine XORs all
+ * source buffers and checks whether the result is zero.  The outcome is
+ * written to @result on completion.
+ *
+ * Returns a descriptor on success, or NULL if the channel does not support
+ * this operation or the request could not be queued.
+ */
+static inline struct dma_async_tx_descriptor *
+dmaengine_prep_dma_xor_val(struct dma_chan *chan, dma_addr_t *src,
+			   unsigned int src_cnt, size_t len,
+			   enum sum_check_flags *result, unsigned long flags)
+{
+	if (!chan || !chan->device || !chan->device->device_prep_dma_xor_val)
+		return NULL;
+
+	return chan->device->device_prep_dma_xor_val(chan, src, src_cnt,
+						     len, result, flags);
+}
+
+/**
+ * dmaengine_prep_dma_pq - prepare a DMA PQ (RAID-6 P+Q) operation
+ * @chan: the channel to use for this operation
+ * @dst: array of two destination addresses: dst[0] for P, dst[1] for Q
+ * @src: array of source buffer addresses
+ * @src_cnt: number of source buffers
+ * @scf: array of scaling coefficients, one per source buffer
+ * @len: length in bytes of each source and destination buffer
+ * @flags: DMA engine flags (e.g. DMA_PREP_INTERRUPT)
+ *
+ * Prepare a P+Q parity generation transaction.  The engine computes:
+ *   P = XOR of all source buffers
+ *   Q = Galois field sum of (scf[i] * src[i]) over all sources
+ *
+ * Returns a descriptor on success, or NULL if the channel does not support
+ * this operation or the request could not be queued.
+ */
+static inline struct dma_async_tx_descriptor *
+dmaengine_prep_dma_pq(struct dma_chan *chan, dma_addr_t *dst, dma_addr_t *src,
+		      unsigned int src_cnt, const unsigned char *scf,
+		      size_t len, unsigned long flags)
+{
+	if (!chan || !chan->device || !chan->device->device_prep_dma_pq)
+		return NULL;
+
+	return chan->device->device_prep_dma_pq(chan, dst, src,
+						src_cnt, scf, len, flags);
+}
+
+/**
+ * dmaengine_prep_dma_pq_val - prepare a DMA PQ validation operation
+ * @chan: the channel to use for this operation
+ * @pq: array of two addresses holding existing P and Q parity buffers
+ * @src: array of source buffer addresses
+ * @src_cnt: number of source buffers
+ * @scf: array of scaling coefficients, one per source buffer
+ * @len: length in bytes of each buffer
+ * @pqres: output flags indicating P and/or Q check results (SUM_CHECK_P_VALID,
+ *         SUM_CHECK_Q_VALID)
+ * @flags: DMA engine flags (e.g. DMA_PREP_INTERRUPT)
+ *
+ * Prepare a PQ validation transaction.  The engine recomputes P and Q from the
+ * source buffers and compares them against the existing parity stored at @pq.
+ * The result of each comparison is reported through @pqres.
+ *
+ * Returns a descriptor on success, or NULL if the channel does not support
+ * this operation or the request could not be queued.
+ */
+static inline struct dma_async_tx_descriptor *
+dmaengine_prep_dma_pq_val(struct dma_chan *chan, dma_addr_t *pq, dma_addr_t *src,
+			  unsigned int src_cnt, const unsigned char *scf,
+			  size_t len, enum sum_check_flags *pqres, unsigned long flags)
+{
+	if (!chan || !chan->device || !chan->device->device_prep_dma_pq_val)
+		return NULL;
+
+	return chan->device->device_prep_dma_pq_val(chan, pq, src,
+						    src_cnt, scf, len,
+						    pqres, flags);
+}
+
 static inline bool dmaengine_is_metadata_mode_supported(struct dma_chan *chan,
 		enum dma_desc_metadata_mode mode)
 {
@@ -1585,6 +1701,24 @@ __dma_has_cap(enum dma_transaction_type tx_type, dma_cap_mask_t *srcp)
 #define for_each_dma_cap_mask(cap, mask) \
 	for_each_set_bit(cap, mask.bits, DMA_TX_TYPE_END)
 
+/**
+ * dmaengine_prep_dma_interrupt() - Prepare a DMA interrupt descriptor.
+ * @chan: The channel to be used for this descriptor
+ * @flags: DMA engine flags
+ *
+ * Returns a descriptor for an interrupt transaction, or NULL if the
+ * channel does not support DMA_INTERRUPT.
+ */
+static inline struct dma_async_tx_descriptor *
+dmaengine_prep_dma_interrupt(struct dma_chan *chan, unsigned long flags)
+{
+	if (!chan || !chan->device || !chan->device->device_prep_dma_interrupt ||
+	    !dma_has_cap(DMA_INTERRUPT, chan->device->cap_mask))
+		return NULL;
+
+	return chan->device->device_prep_dma_interrupt(chan, flags);
+}
+
 /**
  * dma_async_issue_pending - flush pending transactions to HW
  * @chan: target DMA channel

-- 
2.43.0

