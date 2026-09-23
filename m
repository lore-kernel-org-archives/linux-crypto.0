Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011002.outbound.protection.outlook.com [52.101.70.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F7B538D92;
	Wed, 23 Sep 2026 16:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180409; cv=fail; b=TcKDzaianNG9HdB1lp3Uekq1r/phrLG/lKAQSq8x31r+46/86UozsbcOc2wyC3bWotiarBGln8h1tQ/5g6EySwGdr8+ja6j1dWk++XKOhknJrsleQ1EgVOVgSwKEAloLRNDfw0siU39mXznGqUR6VkLNaAnGryqDeaep2AdCxKk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180409; c=relaxed/simple;
	bh=yPjcKmIAfAQsHIpprPTVTIFweOIkApZP0n/mTuTRRj4=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=nshejHhK4OnFqmnJMPGb0zgb2k2VIfoT18IFOrGpBvOyrQjQ2UdjAHr2/gIWfweo5YTxA5cEE8d3/kKDKUA7Nkkvx2N0Ti6h782auMdgeRGEXVIM9niOTFgmXDg8EBPGh7WsjbaY99BXEyvEl0nW+WsbB732hb0IL2WesOAgv+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=WB8MEOBz; arc=fail smtp.client-ip=52.101.70.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="WB8MEOBz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LU0IqF3MD7sMb7a6zPhrLQIiPTD8xPYoxR88jp+EpPJMtdOPRQj1OKBY/GCmUFfUvNXNADKDmATXuNrl5NUjVTF4l72c0hHjbMv4D8naE4Q444/4qpJgbB++fXrT6kWub00BnqDUE9mtIqQdA0acHmm7wHE4AI6dmWztkL1TGOIYLL0VUvJpkwyPTYgZoeQVegbqKtzdQIdejlSWCGLdFtzHPmE6m4wk9Y0jS/ZQ+Kxdbw7tDAB+nnxtKgl5+moOGX8py6pKrUGGmWNfBF9+UZHJyKerM1nRn3fSb1/bfEPLL95614K61ZF8jA1Edt0clZwilE2/y0XFtBrnhzwQPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qFcdyzJnZBjBVqjPmcCSwYmPD9G8DqgVLR/EWom7g8o=;
 b=xZbq8tzfMVF8BZi/BYBUEqr/34UHSBJ5zEJyE91tuDlEP14u/sKcb1h7ekauU/uEZMohuJs8hERn+h0008XEE1KQpaIrii4Vz7Xp+npg0KxwJ+0sh8mR27uT5gd013nPMl7X1UJHTVOkkcf9H53d2YrTc/2Xqm0pqut0CtXxu9sDw+nKkdYe7Bw1HQjKolXZjDnOAf8EaV/fPZ+wkNSJlMHTGdP6CEd2tEOVIap+v20WSii9g/tWWrCpyjpvm79sIBvtJjvJ+IpvNSNjSWABc/thf/V4OVe0XO+xslORg3TAyF5vrGiY2Gq5xAP6rYMg0a7BBuLNnMMYt5nZnsK1Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qFcdyzJnZBjBVqjPmcCSwYmPD9G8DqgVLR/EWom7g8o=;
 b=WB8MEOBzfpl0q2l2WGkrRAIdpvtSgv+eNUQkkCyGt2hV5zCTafBLU97OdpA9I6X1Svk9DbTSojaBnbzYetZLM4/Kd1O4BSFcCfGfCr78voTSA3T3MdLc5KaGWm0WeaFxCeJXB4qytQFdYTFC78jBArvrnx1V9crEbwQn5C2R4ssG6Dqa0nAmBPXZHzo3XEW4b+gBtFdovkffY2yR25sbg6VzFMn7/DU6HvvaanDjJr1ZVw2MrT77zZlEmuHozMu1Gh9y79hfGO5fdYmuuVSRMsTaSSayFKCKae2/+oI4e3lauvUN/5zICK05KNN1zr+HzyzEpB5ZlaYpqadLqDEwvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DU4PR04MB10433.eurprd04.prod.outlook.com (2603:10a6:10:55f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.17; Wed, 23 Sep
 2026 16:20:01 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0428.015; Wed, 23 Sep 2026
 16:20:01 +0000
From: Frank.Li@oss.nxp.com
Date: Wed, 23 Sep 2026 12:19:33 -0400
Subject: [PATCH v2 04/12] dmaengine: add dmaengine_is_*_aligned() helpers
 for DMA consumers
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-dmaengine_prep_dma_pq-v2-4-32ed65b8a9b4@nxp.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790180376; l=3167;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=KCTGjzRUC82WfCM01zzXaIcdRgIJEvbFP+94q9Ozdvk=;
 b=L715oChAPuPJw25fXrwJPDFqA15Y8t4v+H8MRrV6dPle8NlCYTL/6PZNlCCNPgx7xfWIMNIwf
 FC2BuZCkJ4VD7zBXtxUzLfr9FQNTlUZGhrFbDCEQazDQ96gAO78MMfh
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: CYXP220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:930:ee::12) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DU4PR04MB10433:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bde5f91-a665-4956-4161-08df198e846f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|19092799006|23010399003|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	Axj3ckWAsIyJ/VyuupTUWDSZL1//fDcnbAfaAOe/mPD/vJpwdzjUl60Yhjx+08oMBAm8uo9ko5gRRuvoIVDb2ctFmeZEtHs3VMFgVM0qfOhbz2/jP5SKtDwH4fF3kEq1UwhWWezdIQyyvcFMgCWLrnHXFvX/PPj+VFXZ/tJP4rx1ULvyjjbXmm12LmYmyIZlItLcDEeWv21PQhPMRKgdMhw14Sr2SiKdqi5zBQdba/lAsEgW+kkT1pe7CjF+Zh+kgmHrAE8wFq5cl5oPKtHzXU00yfojteVKYqDowxOOIARU5guUOjcm5vgKN1J7hqwf2CMUGgqMAqnhyaXVaG5RQuTIQnYF0bq2EJjv7VaoqBnIcWsCdAiQ01Lb6Ri1tI22rawuHmZzLQ8HkNomrjjtZg7pbW+HuysOAhtaOp60wYS+qYHAefHQEjICOUcGrcaEFLMSSwILgbYAOuvn9MZkYlcE2kHkWgRot/CXCzwnWb2IQx1VLUYFUskU2s3Mq2hDrMI2vuOrLHR2VQSG8UGo/JuDbW2zxC30FFvlxdmERKjP/ZyRrnZ7USmzvsGn7nZjVIGcOlQiEhOTBkVzQRPOamQdBnO8QezwuvWeMpe5oBZ6jTg+3VLeJGZT3XuWd5U7cWCLJjm91bSoUnSoTA0R/Oe0qQ3JcCpY7P/vmUQHs9Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(19092799006)(23010399003)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YU9IWENRSVNzY1BBZkdEblR0aS9NNElSVU5vbnh5RHAxc0RReW9EbTdVZ3lq?=
 =?utf-8?B?eENvcldXbjVuWXVDbUhMQ2tQcUxiQjdGS3hzMDZCOFQvQ3pGMXgwa0I0OUQx?=
 =?utf-8?B?U3ZKRGNhSHlUZUhrYlNUL0E3elNBZDVUU3BZcU9idTBIK0FyaHZGM2M5Q2xM?=
 =?utf-8?B?TW5ueXpUS1I5RW1iblphQVQwZGc1aC85V0JIRXNtNVBBSGptbVV0Y0pzMEt3?=
 =?utf-8?B?TUt2aGgyaXY5R3BXbjlQN3NreXRHQTJLUTZBdWtEN2U0b0JhWU45RU1ITU9x?=
 =?utf-8?B?UU5SeVVaNnZEZkkzOWl5Ky80TEZJRFVOeExZWU82dGFFNDRrS3Q1NUhuMzNt?=
 =?utf-8?B?cGFpcDBNalQvZGRzbDBHSElsYWZZaXgrTmhYRzNHZ1BxTHRjSGo1MnA5Um8v?=
 =?utf-8?B?ZE5LbmdSL0J3QXoyRWJMYVlrRnArcTQ5cjlrUzV0b0RWdTZEOFZFZjRlTURW?=
 =?utf-8?B?OGNZMzhzN1JlZGRkSGdOejh2VVRIT1YzTyt5akdvRUx5Mk5yYTFyNU9VVWZQ?=
 =?utf-8?B?aStiYkZlbUNrd1h3R1hpZWwvTzVoWmFJVGpJNVFMZ1BNTFZHWC8wQXhINndp?=
 =?utf-8?B?Y1BKQkdoZkh5YmdFa1ViTWU2NHFsTlF2Nlp6ZUJzMjdZVWVZMDU5YXR3M2Uz?=
 =?utf-8?B?VmFKMzE5RXVHMm9mZlRRbzYzazdJL0w5YXRScEo2UGZ4ZU1ZN21Tc2I1WnEw?=
 =?utf-8?B?ZXdRbHp6NUxSSzRTczZsVkt0SWlnb2ZzbEhGTWEvNjVrdmhINEVuOUhLREtr?=
 =?utf-8?B?WUJGdEdwdU4zZllwYUhla29HaFY5VTk2eXVoelcwYlNSa1ZIeEd6QkljZ3JD?=
 =?utf-8?B?djd6U3JETGZFU1A1UTRuWlQ4R0JxTlVVeEhqRE9mdDdvUzVVM2hBK3J2VVp0?=
 =?utf-8?B?OU0zRlR4aDRIZFVNN1pIMVJIenJuSnhMb3YveW90dEk5Sy80M1VHSVVJamJI?=
 =?utf-8?B?ZzA0QlloMktYNSsyYStUaXpOMjltNDY4N1J3cEpTVTNDSEFZNmNyM0RkWlR5?=
 =?utf-8?B?WlJvc01EemZvOTdXOUNzeHA4Q0JtSjdFNGsxelZRNE14dGJDN2laeE5ySnBs?=
 =?utf-8?B?NnN5R0Y3SC9nckQxU1lOcnJIcmdlZnRKYlpwTzdML1RCNGxxZEZkU29Lc0Ev?=
 =?utf-8?B?eDh3Z3FmdFVQb2hiN3pBUEFGSEZsdjdtd2JnMmgzdG42RHNraVY0MG14MDV5?=
 =?utf-8?B?K25paTl5dkM5SmRsU3BwbnJ0aHI0cm1BTmU3c29xdWNIdENIeGtMWHNIMlV2?=
 =?utf-8?B?YTZXZFU0S2ZQY2RYV0s4NHlFUUVMRWh3c0dSdkNBM2x1bkVSZXR5UFRoUEEw?=
 =?utf-8?B?aHcrc2xucC9Yakp1U01VK3U0Ync1bmwxV1R5NkRDakl6b2JJRDd4eDMrcDQ0?=
 =?utf-8?B?ZEZtSE1EeWY3N2FJU1FkQjZvQ0oxc2NGbXZ6aU84d3l2U2hxREFGeDlWRTRq?=
 =?utf-8?B?dmY1TjYxTVd4Vk9ENStyMGFjMzFOTkRsWnB0d09uWk5ZZFJNVmpwMi96clZ0?=
 =?utf-8?B?Mlk3MHZBUXhWUnFJQlo0T2g4eTlKL3V4TUUyZkVpaC8rV09ySW5lc2RXZGl1?=
 =?utf-8?B?MmxWekJBQkYra2VQRFJlbjB1dnlVcXZtSy8vV0dQdnB6VWxkbTQ3Mzl6RXl5?=
 =?utf-8?B?NXVWeVNndDM2c3U5ZE9xb0lsQkRRbzRTdEtvRHR1ekloa3VkYVlCbFNTQXIy?=
 =?utf-8?B?bWxWLzhITlE2RmRYcndpcmt4MERFVHNBMmhIZkZNekxrUDhCQ2toWi9aY3Z2?=
 =?utf-8?B?RFZ5RHZMUmwxaUVSc3pKaWY5YzBXRXRzUVQxcTdQV01POHRNTnZPU0ZDV2dv?=
 =?utf-8?B?Y0hjRGd4RnZwOFB6d1dVL0tNUmF6N2drcUJtUmpCVFhZTlQzeGJQWG43cE1S?=
 =?utf-8?B?emkvSXk5T3pqc0Z3OE5VTzNQbXo2L1JjdDNhMVhwNENSRWlMcG5vd0NpaUJv?=
 =?utf-8?B?eHFhVk5UT3EyRkV2N2JNM1pwUkVJVVRVOGd3OUdPK2kwZExkaW1mc25ySnJq?=
 =?utf-8?B?bEFUTEZNTEN2MWxPWVRMc2lERHBYeGZyR2dic1NmZ0wxRS9nbldTSE1hVjVi?=
 =?utf-8?B?a2c5UTV2aEdoRVcyMlZITE5nOWt4cjZmZHB2MjVtTXJJVG1KZDcyaUVLMWQx?=
 =?utf-8?B?dG90dnRtbDQ4b1hyMDRMa0NHYStLSFpqT08xalB6MytmL2YyNU5SMnowNjBP?=
 =?utf-8?B?WGxEdHB0bEJqL3BvL3hVSDlPR1FENGtQUDlUWmtBUTlxYmtVbG9uMUt0bXlP?=
 =?utf-8?B?a3JlVzMwOXc0M1A2bjFTSzlXTDBiRzJzME5Bd0hlMTBlalgrT2dXUm5wQWhC?=
 =?utf-8?B?MWxqZXdjWGRRM1dPSXBlOCsrb2pScHZ6ZXA2aXlrS1R5bGhnQTFqY0FtRzdz?=
 =?utf-8?Q?xQMibY0eECUTjdAWndswxMqTgcPtyS3DqtlYi?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bde5f91-a665-4956-4161-08df198e846f
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 16:20:00.9359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zwtQAFY/Ye4PF5M1ymKsfNg+owQPTKuMb/qCu6aRgnWc5bq3D3aTW0tNAVMRX+zA5NJOo+ERx8Bkmq3r4L+BgKcyjDi7hoVCpYCmKmRN8nMwg6HIq5mIBAN4a6h1juZm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR04MB10433

From: Frank Li <Frank.Li@nxp.com>

DMA engine consumers typically hold a struct dma_chan pointer and should
not need to reach into struct dma_device directly to check alignment
requirements.  Add dmaengine_is_copy_aligned(), dmaengine_is_xor_aligned(),
dmaengine_is_pq_aligned() and dmaengine_is_fill_aligned() as channel-based
counterparts to the existing is_dma_*_aligned() family.

Each wrapper calls dmaengine_check_align() directly with the alignment
value from chan->device, keeping struct dma_device opaque to consumers.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 include/linux/dmaengine.h | 64 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 6a187136f9493..1efb04e137673 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1537,6 +1537,70 @@ static inline bool is_dma_fill_aligned(struct dma_device *dev, size_t off1,
 	return dmaengine_check_align(dev->fill_align, off1, off2, len);
 }
 
+/**
+ * dmaengine_is_copy_aligned - test copy alignment
+ * @chan: DMA channel
+ * @off1: first buffer offset
+ * @off2: second buffer offset
+ * @len: transfer length
+ *
+ * Return true if off1, off2 and len satisfy the copy alignment requirement of
+ * the DMA channel, false otherwise.
+ */
+static inline bool dmaengine_is_copy_aligned(struct dma_chan *chan, size_t off1,
+					     size_t off2, size_t len)
+{
+	return dmaengine_check_align(chan->device->copy_align, off1, off2, len);
+}
+
+/**
+ * dmaengine_is_xor_aligned - test xor alignment
+ * @chan: DMA channel
+ * @off1: first buffer offset
+ * @off2: second buffer offset
+ * @len: transfer length
+ *
+ * Return true if off1, off2 and len satisfy the xor alignment requirement of
+ * the DMA channel, false otherwise.
+ */
+static inline bool dmaengine_is_xor_aligned(struct dma_chan *chan, size_t off1,
+					    size_t off2, size_t len)
+{
+	return dmaengine_check_align(chan->device->xor_align, off1, off2, len);
+}
+
+/**
+ * dmaengine_is_pq_aligned - test pq alignment
+ * @chan: DMA channel
+ * @off1: first buffer offset
+ * @off2: second buffer offset
+ * @len: transfer length
+ *
+ * Return true if off1, off2 and len satisfy the pq alignment requirement of
+ * the DMA channel, false otherwise.
+ */
+static inline bool dmaengine_is_pq_aligned(struct dma_chan *chan, size_t off1,
+					   size_t off2, size_t len)
+{
+	return dmaengine_check_align(chan->device->pq_align, off1, off2, len);
+}
+
+/**
+ * dmaengine_is_fill_aligned - test fill alignment
+ * @chan: DMA channel
+ * @off1: first buffer offset
+ * @off2: second buffer offset
+ * @len: transfer length
+ *
+ * Return true if off1, off2 and len satisfy the fill alignment requirement of
+ * the DMA channel, false otherwise.
+ */
+static inline bool dmaengine_is_fill_aligned(struct dma_chan *chan, size_t off1,
+					     size_t off2, size_t len)
+{
+	return dmaengine_check_align(chan->device->fill_align, off1, off2, len);
+}
+
 static inline void
 dma_set_maxpq(struct dma_device *dma, int maxpq, int has_pq_continue)
 {

-- 
2.43.0

