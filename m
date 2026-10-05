Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011043.outbound.protection.outlook.com [52.101.65.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A650453A36;
	Mon,  5 Oct 2026 09:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791193085; cv=fail; b=LN5DDT7KXgrHL6oSzsmFnOcBY2znnDPjktztcuyIp8mKZKGRO4QhabyFALYRG8ylDHjxVVcfhEXyQjRX5KensBq5gvpJ/tG/T97YCAhANpugyspo/ZMFlJjpn0b3d7v9xE0ZA0ejM3j+6EeAU9x7jrKuXWEIQIQAV2masO4qCOs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791193085; c=relaxed/simple;
	bh=SQLNuFHw/zpAETUGpHSpY6G3pmWUvsgc4Uzlxk0XO0U=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=RZROZtzOFF5Cscmzgcac8AJLI/8HBnE2zvmxngzFdN0cbQZvyCJk2HfdkLGPNZCVsm0vzuUms9COZ0pY4pSE4MUZMmdYktYvUxitSlHPQZgxafwQt8t6nKI772/Sbt1m2hnWRoBWUyoHZ8NvGU4D7AmPj8uTEfaQe28ICv0STMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=Yufz3Aw7; arc=fail smtp.client-ip=52.101.65.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="Yufz3Aw7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZDQTMJfqUrjf0iWMm9L+xAAvmBNztH5A9IYVm2ZQW+rWb9HLU88y4eW23kQT9Vzj5oOCTKwli3yC/drGeecgTMsb0hEp8/pn7zi+s2DtCuy2fP4FT6fXmWFkflVa4l8u8+hKeMkuSF5Vc3c/paFCQJ+XunibTT4OQ56a9F9Q8t8gOZILkvH+mftTRVmmjPo6adCMPNviYH/uEwcCkHyJoliPcxmNS7+Ji8lz22H7FZlRFAvbxDTZcF7asOfTokx2tUI/3hFYVydfCoj4sQBbU3fGlSDNfgeNRGdD6X4iKew9QwTeHm2mDyh3JCQZkSUYkx277dOFkopZ8g3QjsCd9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Zs+A3N+H4OIvo1dDhBdyyEbjtuWQj/VrfEajEwtm1k=;
 b=xjIIbUQOo6sFgCnmS8bOIt77JwTN1OgVRYkiQ5j2bwPtFKkYxZ80DVHhoIcWX+Psm/lgNYwH7Rf+kLPAQwyP6befGINgkW7T8yoYYogkXFx3Q/gyIzUyOu2ZmGufeW2NnkAoSZKnDQUJUVrpXhJUtdkC/edkJdLMJJtNHH+aEhBtc9b5jJWCaVVOpS4V0mW2hjtU6oJBPDW+Az2RIEl1kzHyT6oTSAG6yGU68wGjX6PgmHQ8FchIOJiZAmeAGfCuP3meRsl2Sr+gUgfW869lrOSAUns9B1gBwrnvBMkv2HKrVb11K+ka3AE5P1PnHo7S29924vyaufMiiVN27M0PNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Zs+A3N+H4OIvo1dDhBdyyEbjtuWQj/VrfEajEwtm1k=;
 b=Yufz3Aw7IurvIio33r5jBcRZnjfAElz3qqEae0UmdlMs/EY6FLhe1yxP2OzZeEyn9Fq6OrXY9PkQthAKGEtHG2d86g41lUgvt1p4G8bJc3Zup82uoLXMeGKlS3OlkF1xhEinGSXJgMCRIna7TVaebt35iizru3jaWU5Lms7Szb7Fqba6vwHHGMuAfSRcgxGDkRagIm4BTUPtEL8nCkjfiYVu41J+vhVmJJmebhSi9oydhWxXoVaKLFc/36oBZO5wKugtfai7/HrePfJQvFefKS1yZFlKN7/rqK9QLmKUhWkYhcaE2yRmxAk7+5HChUUJWI/C/fR48vGrbv8XIOeS7Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DB8PR04MB6956.eurprd04.prod.outlook.com (2603:10a6:10:11b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 09:37:48 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 09:37:48 +0000
From: Frank.Li@oss.nxp.com
Date: Mon, 05 Oct 2026 05:37:16 -0400
Subject: [PATCH v3 3/5] dmaengine: add dmaengine_get_copy_align() and
 related alignment getter helpers
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261005-dmaengine_prep_dma_pq-v3-3-a4a241f26fa7@nxp.com>
References: <20261005-dmaengine_prep_dma_pq-v3-0-a4a241f26fa7@nxp.com>
In-Reply-To: <20261005-dmaengine_prep_dma_pq-v3-0-a4a241f26fa7@nxp.com>
To: Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, imx@lists.linux.dev, 
 Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791193046; l=2372;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=lXp5Ebsxc0CGIQcgDZ0XzZpIYG7TQxy9TOdVgUs//Ko=;
 b=lPVulMUwfRpus80dF3tl2NZMUgZqjzQGe3+QDv5yJRqPSwd2KRkfzvPURSlgqAo65NMWbHU/T
 DZhs4yky/xgBrPPwVMSPQD5+sM4P68W7qfmjZ9wszIxSc1PhmKAFEH1
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH7PR13CA0011.namprd13.prod.outlook.com
 (2603:10b6:510:174::26) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DB8PR04MB6956:EE_
X-MS-Office365-Filtering-Correlation-Id: b49fb165-d7ae-4635-8ded-08df22c4510b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|19092799006|1800799024|376014|22082099003|18002099003|3023799007|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	cBiNg7QfAmcQ6LFqWyDgFyXHSqY5i2I8dtVyjV37yLesnT6LlstmG8hRgwTMVybnMD15GJXLdoaeUcvekZxp3BpH78xf/dBeuHeCNE4mU/YiKMQhn8QidvHUmk//DzobOkYyznt2A+R2GWWLHzwV5YBBr4z/7exxa8YtbINPlNWqlQu2hYJmWdIZh0YMludu6Z/LTNzF+Hx4/9Ds5QZRzQzZDRun5Pizwr193WKMuhBe0es4untHg7WSda/l8p+Nq5SiHXe4GNCqPGYtDjtQVTgcB39eekStyBaMdDqvST0Lw+LJeNV4Lkbu6BRQQ/KZrOPZEA+wXi/NJbyQLwEK82Zl09TNJTDwJnS/DiIEZKTVXaRMrlJ7Ch3eADv5HF5cNwdoob/YbnlpD5FNhEvfvPmJWXVZ2qfCax/34gGLbYjoyMLaKQ3Ujr26cpNfSXQqxRkg+ROdk++SsAXrY97m7/3lgKL25c4iqLoq+SeH/3HlGxnTY+pc5j8KCyOmKdfgnd3ys4iG7fhL8ObsyNi3eAq3WrNUU//hSNoV2afSpGCZhya1t9mW+aITH+MWdXejvZViR1EWYvvxVhyBIJol3UlgI2NHH/1fhmiJvWNRjp3tmS/Cm5MBz1z1DNIgOrHHYsSi8wF+U35+t2MfttyBYZ06nHgv2IsW0y0C6NDYusQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(19092799006)(1800799024)(376014)(22082099003)(18002099003)(3023799007)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDR6RVBOUzF2VlgwU0pJZ0lFeHNlYW1BdUV5amo3V0hOR01qVFNTZU5UUkI0?=
 =?utf-8?B?YmQ5S1JIancvNmZDREZsblpSOGFuQjFnR3g0SkJvUzl4dFg4Ry8zQlM1dkdn?=
 =?utf-8?B?T0I2SVdBUTg4alk3UU5MS29Eb2NhajB2TUlJTjJxSUJseGY3ZXZROEVFY3Vh?=
 =?utf-8?B?V0lvMHp4SzBOWWJ3M1VycFBVaVN1U1ZRam1yTWhtV0ZTWWVtWC9WaVNxZHRR?=
 =?utf-8?B?WmpOaVZwQnRsdkV5RkprN0pYaWtzd2NVSVFCdU1hQVZ5TmljeTRFemgxNE9m?=
 =?utf-8?B?dlNOczFyM1dUcnVHNkRwMkJ5b3pXSkV5d2tHcTRUdWlBSkdKOVpIemErYk40?=
 =?utf-8?B?eW1yV3pTZkREMm1JeGxiWFNLUXRqeisyV2hUVmtJbVA2ZDhFZlR3NmZoV2NT?=
 =?utf-8?B?SGNiZm5FZk5penFDbjc5cEdHcmVRNng0VEg4aVBuNEM2eWtYZVRBR2tub2FJ?=
 =?utf-8?B?MlpadS9sbEFNWU80OFZpMm5lUTlWWWhEYjBDcm9BaHpQSHpjTG93WFBBb0xr?=
 =?utf-8?B?b09rSkd4SVhYYUMwbXFxbkw5ZEhHT0dtcC93RUl4bDJ6R2VER012VHBFSm5J?=
 =?utf-8?B?dHNmeVppK2pCRWJXTHYxb3R6M2h0RHVDempEQWJObC90NEtCU0JtQnNNdW80?=
 =?utf-8?B?TG4raTJ3NGpSS1lHbG5pSmxGV3Z4b2p1L2RIRjZKVFgxeWt1YlFmU0NEL092?=
 =?utf-8?B?VGlYRUFMeG51VXl6MGZEWjZocXdFdFZmRWU0TTF3ZmJyYm03OFUzcDMrV2ds?=
 =?utf-8?B?YXdBR21mQ1ltZDNpOHJiZ04vUjNUM09NdEVTejhTOURKV0lnQklCaE5zMHg3?=
 =?utf-8?B?cGdEbE14Y0lpdDRaOHBoME00WkRVTVBZTStSb1RXN1ZySVJDeWRDNU1SUUxu?=
 =?utf-8?B?TWFyQmVSR2VLTWtjMUFsU3JCU3EyMjJEVXVKeklvZG5KejJCRlFyOWxlK1ZI?=
 =?utf-8?B?SnB3a2lXY2lhRUhtVVIyOTRWSk9HSkQ0OW5KRlc3SEUvcThJS09MbUFTelU4?=
 =?utf-8?B?dUFCUVFLQytSY2hXdjhoK3NkL0VPRGRVOGt6RzhCM083L2RHM2xCYnM0Qllj?=
 =?utf-8?B?ODNkVW5TUHB3SEYwbnFaeEJhaDlJMHdDSlJWU01KLzlxRjgveFUyKzF0WmFv?=
 =?utf-8?B?OVJyM25Mbm5waFlTL1JGWHBnTmxBYjVlbndLTzFFSzdHZzBMNURZdFhiOHhY?=
 =?utf-8?B?M24velI4c0Mza2NORVhGcHd3ZEdmNTBnZURGTWZKUkRXOW5wRFk1amhjSGtk?=
 =?utf-8?B?MVBUZ1F0bTRjcjBuLzdDdnZLKzRJQmYrczR3UDRtQ3R1bGJBVU82bE9FMXNG?=
 =?utf-8?B?RDlNVWZSMjAzQlJzUE1hdnVScG5ocXQvaXhOdWIwNitFU2tVdTBXZlNSQXVy?=
 =?utf-8?B?YnNPcHZuVTFnMGpvb0NZdTdadzFGU0FyaVlJTkpwakpQek1UVnB5bUI3L2NW?=
 =?utf-8?B?SGp5aDljUExVRWFPeEgweXhKY1krQXVVOHR4T0prWTcyWlZiTEt4K0xVM0RT?=
 =?utf-8?B?RmcrQWQzQ1NndExSbDhnb0RzV2JVd3g3bHBXczNaZXZuNkFOaXQ0VXJBc21M?=
 =?utf-8?B?dFZ2TGhlTmdIUjBQVFQvUnR6dE82Ym9scDBsOXFmTmtQMFF1ZnVSeHNIZVBB?=
 =?utf-8?B?MndOVUZTNUtPWHRkYkZuQ2pLRnIwSERyZkE2TUhPd1ovTS82WjNlRnlQTDZ6?=
 =?utf-8?B?K0pUaHRxTzM5bEd3OE1qaUY0cnRkQkxTbXlEWXBFUmNQTU5qWkh5cExXS2J4?=
 =?utf-8?B?R0h1Nk9WaFBOSGE3d1ZGTDJBRThRa2haanN4OEJ0Ti9OM3l1TWppcnZFSlJh?=
 =?utf-8?B?dWcwZWVwZHVSakxzNnBaNVJKa2cvQkJDWU1YTVRqeWJMYlJ5dmhoU0JIMEg2?=
 =?utf-8?B?dkxPRUt6NUlUbVJOV29oS0RLN1NHaGlIUVlvaTJzNm10eWRGL3hod0UvVXNV?=
 =?utf-8?B?K1FBMHgzV3lyUFVxVWZaUURCYlcvNG94Y1AwYlF6MTB2VUtNcXVxNW14VzRk?=
 =?utf-8?B?UUZ4ekFiRTFBV0VtaEdBeTlHWE95Qnh3ZUpTU0hJTmt3eTJmcGlBTjBmamg1?=
 =?utf-8?B?T25Dc3dGMDRyZzFQWENHeTdMajFmUHNycmRoZ3p4YUtYaGdqTFF6aTRoTENy?=
 =?utf-8?B?ZFFQWXR3a2tyaXk2dXpjc2d4TkNKN05VUkNYb2xuSjZyR1FHelB1c0ozYXJ2?=
 =?utf-8?B?UmFnb1JBN1duSUZVd3AvMXFTL3dHbXNJSmhGcXJDaW5DOFgrNFpUcTNzZW1C?=
 =?utf-8?B?WVhaWS82WThrbmNQejNVbmtGZkhsMXQ0SlYxU28xQlppOE5rNm1yMG1uYXFI?=
 =?utf-8?B?bXhWcTQvM1FEd2xQY3VLTk4yMnk0ZjRtTGhoZ2VOckxONTJraFNFblhUWmR6?=
 =?utf-8?Q?SmqHUYZEBhwa/Nn1IrXKPhFzRuTSPvR0AU0yR?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b49fb165-d7ae-4635-8ded-08df22c4510b
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 09:37:48.0113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TEOm8h5VisQzwYkqpFdhGW7uwPHuODvXps2F2TGXPBWJudLTIhusr2gC5qygEcA9Uui4qALw3wFHNNGM4B9GEyzRBxe30Qy8To3LegZ7NoiAX00d3EefjhtmP2xALJh3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6956

From: Frank Li <Frank.Li@nxp.com>

Add dmaengine_get_copy_align(), dmaengine_get_xor_align(),
dmaengine_get_pq_align(), and dmaengine_get_fill_align() inline
helpers to retrieve the alignment requirement of a DMA channel as
a power-of-2 exponent.

These complement the existing dmaengine_is_*_aligned() test helpers
by providing direct access to the alignment value, which is useful
when callers need to propagate or compare alignment constraints.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 include/linux/dmaengine.h | 48 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 1efb04e137673..615eeb708dcda 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1537,6 +1537,54 @@ static inline bool is_dma_fill_aligned(struct dma_device *dev, size_t off1,
 	return dmaengine_check_align(dev->fill_align, off1, off2, len);
 }
 
+/**
+ * dmaengine_get_copy_align - get copy alignment requirement of a DMA channel
+ * @chan: DMA channel
+ *
+ * Return the copy alignment requirement of @chan as a power-of-2 exponent.
+ */
+static inline enum dmaengine_alignment
+dmaengine_get_copy_align(struct dma_chan *chan)
+{
+	return chan->device->copy_align;
+}
+
+/**
+ * dmaengine_get_xor_align - get xor alignment requirement of a DMA channel
+ * @chan: DMA channel
+ *
+ * Return the xor alignment requirement of @chan as a power-of-2 exponent.
+ */
+static inline enum dmaengine_alignment
+dmaengine_get_xor_align(struct dma_chan *chan)
+{
+	return chan->device->xor_align;
+}
+
+/**
+ * dmaengine_get_pq_align - get pq alignment requirement of a DMA channel
+ * @chan: DMA channel
+ *
+ * Return the pq alignment requirement of @chan as a power-of-2 exponent.
+ */
+static inline enum dmaengine_alignment
+dmaengine_get_pq_align(struct dma_chan *chan)
+{
+	return chan->device->pq_align;
+}
+
+/**
+ * dmaengine_get_fill_align - get fill alignment requirement of a DMA channel
+ * @chan: DMA channel
+ *
+ * Return the fill alignment requirement of @chan as a power-of-2 exponent.
+ */
+static inline enum dmaengine_alignment
+dmaengine_get_fill_align(struct dma_chan *chan)
+{
+	return chan->device->fill_align;
+}
+
 /**
  * dmaengine_is_copy_aligned - test copy alignment
  * @chan: DMA channel

-- 
2.43.0

