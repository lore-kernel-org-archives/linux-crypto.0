Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011043.outbound.protection.outlook.com [52.101.65.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56A8456E11;
	Mon,  5 Oct 2026 09:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791193091; cv=fail; b=AXYOAxfBQVleyKiNiZ9oBEPaNR00jNsUvJJKePyDqE3pHEcOOQj3B/M91t9/Rq/2eP4N+3T93lb8Or44VrDxAAVdoGdk1lGBDsX01AMvQ1SBpidxdL+rnDSTts6lEVMYe1SPe20Z+fdIA7ZW1UJcL0Xl61bM8d7rg7U3kMT/L68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791193091; c=relaxed/simple;
	bh=a0xue6OoCIO8/zIzQAMwwkWyuYPmfqtxyYqP25yquLQ=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=cPA9mJWvwUD5NOa3XjDDDAa3eU8ZNKBhw1FFPqF+m2dVeydTMnABezJlL9Ga8bx5H6IY8AEGoYqPum26g1/J+kbFx4g8ALMmvxjnHGj0l/Owgr4HeS/WTTpQKQyx53E4OO5Y5eKmXqRvy9CRcmegyzSS604rG8lbi5OhRpk1NeI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=fcHIrBCP; arc=fail smtp.client-ip=52.101.65.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="fcHIrBCP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tpgorz2fufIGntJmb+IyDWpRn71gEjfAVr5t3fX2GxwBTRcZPgMr7WB9A3Ym1R9yeHsDoQSiEWMiYlZTcNaYggzVaea+NT/3Ac7DdKag6FmDLk1Uyl4THGcgzp8IS7PvF8bRbOnNT+ZfSBKOcAbtgw0F3flwQ92bZxwTk/v1/Z71czyEGrBtHOFxkYvLZkHE0klrNI9xO9OYcu1habZKow4W/uwR5/S9E8bzC4ftDRFKrW2o3inS+ofJunVBVs7M+2L2amUuGVxIObztEqutXs4t/NTKoJ6KPJHAZZXo2IV6lYxLshsgyBCNrPx4ZTgspy5IWmsHtbMSmA4s6n/5YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qgQkaR7thcFRVfki6O6oLICs7w6DcVT8prsTtcWgnS0=;
 b=DYd/3W2WZg/tPMe0mIQbdxsSV5YlS5DOZtOj4Z5MDY2dyGkACUiDQBiD/v5G471puDQQIfjECDa4LA1b7chqi6JpMJFk7rah1ktg47HgrBLdDqcXhEF1wPFNjFWJFxDkIX1HBKRrcaAngjraeWvTZSuG7T0O0nPhA5dIfSw/B+N01dxABRwZeIxPpbYTcwDI8/CPErMNcSuPNs2fSnj5w7xIJzPyrohkiQE7LROIV+bF0FoDEQazbxXl18j9Di8ZshnoA4yDrQ96ES+8GZxTuiCDRXbcQqcbdFcZDLQX1ihYDQGZXZy8++QAzRjd+clPAjpUKaiNJPGTyvh3Jl1aRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgQkaR7thcFRVfki6O6oLICs7w6DcVT8prsTtcWgnS0=;
 b=fcHIrBCPsWlZMDe5hO/F3ach3+ypyfbq2d+qCItgKne7abh+5ez56t291BttMRLbPgCW47sp0Ho7nzbtmk3MUAKlw+zuQgalxpaxnykjjDNcLDjQEUfhHbMlaxBRiDG5w1sIlV3E/SieOhIz+0N2RPc0OWqNwCzrI7YJxRVn++bvStQrVo3kul1zHXMdfPxqBIZdIKONzoE1v4Ezm8NfsiE5t2BdBMYQ0XdSOBNobiINPRKFDhpgVRq8+8PhKfIBr/tB9tDvFPiwFOOKbuwWu6BywgRR8evMr0tvL0ECReB4McEOUY7ifxi912KvNcSXMqyVXNZNUHF2Wp6IQAxysA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DB8PR04MB6956.eurprd04.prod.outlook.com (2603:10a6:10:11b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 09:37:59 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 09:37:59 +0000
From: Frank.Li@oss.nxp.com
Date: Mon, 05 Oct 2026 05:37:17 -0400
Subject: [PATCH v3 4/5] dmaengine: add dmaengine_get_cap_mask() and
 dmaengine_has_cap() helpers
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261005-dmaengine_prep_dma_pq-v3-4-a4a241f26fa7@nxp.com>
References: <20261005-dmaengine_prep_dma_pq-v3-0-a4a241f26fa7@nxp.com>
In-Reply-To: <20261005-dmaengine_prep_dma_pq-v3-0-a4a241f26fa7@nxp.com>
To: Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, imx@lists.linux.dev, 
 Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791193046; l=1948;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=LbTWPRWs0wkYYm3bvRVBKMHG0+6GV/m6lMVJZtyllFY=;
 b=eJJAH0yAVD+ydAld9CxVQecBpdVFdh0fpmwzxRl4kLBWQhaDG9rPZgKlTNWnflgf8Ywwh2Ykw
 hpO21Dkd9UiAq9g0kFVEQ61oOxIQzIluLH+iFqetogyizH34QxOGLYt
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH5P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:34b::15) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DB8PR04MB6956:EE_
X-MS-Office365-Filtering-Correlation-Id: f846cc41-66e5-4c77-06e0-08df22c457ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|19092799006|1800799024|376014|22082099003|18002099003|6133799003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	1qg/MSTnLWCqPCTYxLkzwbEbeZpAsyLEq8zNd2BciafLBORfqN1RX0fTOa4xbkC8JLlu/O2UE/wtz6tCdiq4rExacAelDv2wBjFizd47g983DjmzlyMOZVpx3TRwclA3QueZm9ihWDnLZRej2YPN74z/1ha83KZnhJuGmjue/6xX+P37vwWCi4Mz7TylthpgJI+olV9jQyzS/BveDnqhfSm/RRZGLg+zS3iSY8Drtgo90rQ+nG0q/vNzTBPVHQYe0mhEe0t8d9u/neyQl6VaVNTPl46q+amX0KV+UxisOo1BhLbM5xupfp9W0KNS3lIAUBxVgaJ83ihTcxUwUlh/vnIBfvQ91EZ0E/URByVgRGmfTpQywXR4hW/uYh/MDxOzyZ1U75RCj8PYRF5scavjvfhsDoPHyRAfP2//YcHrXMTLtSVc5rzutuooHjBQTFnbZmvvFGpgf1sbnbNsXcDux3UqYEqqiC+B6B5b7ouTT9mJ/ncpTePQHEJEknnJXqQNcg3Lw9nmtjwZCIWiqZdp5yQ4nKQkh+m/GZLVyn4LG1bVsZOSlsEoc0786GJo8n5tVJv6cT0P2Pfum01C2YG/L7rIdQxOREDQ1g6Inmdc1cRVNlM5kgexGUB5AWd2elIqp24HnTW1DqTG/hgChUW9AzkyGBemh5S/CTfY0qGFf78=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(19092799006)(1800799024)(376014)(22082099003)(18002099003)(6133799003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RnBXWW56bXg0clNQWlphblNUeHI2TjE3ZTd2RVFzL2tpRld6eFd0Q1BzL3JO?=
 =?utf-8?B?bEdGUytmdnZXSmRyUGV3YmM4dVB2NGgvWlZKWXF3a0JkZGVueVhjcHZFNmV5?=
 =?utf-8?B?ZTFlMU9peUhpSGJiRFV0ak53WUFDWXc1Y3p5eFZJSm9NcFFWRzM3WnZVczdD?=
 =?utf-8?B?MnB4REJTRlZuS3c1bmpFNUo4cmxSSVc3b1VtWnVDczZITzVYMWhVVHE5RDRJ?=
 =?utf-8?B?SzRSS09XRzNDVUpMTEpRYVBTNlBnbDVUeVhkTEZzRzJiTldJWlVFYkxIRTN2?=
 =?utf-8?B?ZGFKWXN2eUNTZ0lmNTZsUTE4cVdkUmFLeXRLeGtwYkVRWXZSNzNZTGV4ajFN?=
 =?utf-8?B?RG1ReTArUlRzUWdjSk9sZGFTL1lMWE1IRll4WFFHc0cxK2lhajByeTlYbEdD?=
 =?utf-8?B?QUhnMWsydkgzQzFYY3ZQanlwdmVQZUZIY0pqNjFCK1dOdTRBc016R0lLRm1m?=
 =?utf-8?B?UktDK3BzY2d5dEdZM0lFVmQra0lkaXAwdW5BQlpjblc3MTZUTjBCbDRCWjdt?=
 =?utf-8?B?Nkg3enFxVjIyNXhIT3BZdGw5cXBFaTdVWVZ4YmorU0RVZWozaHRFdFFpcVJz?=
 =?utf-8?B?bFAvdU81UUNuMWY1ZXorZE9ybFJvcU83bTExUTI0Z0h3ZDR3c3Z4TnhXSmZq?=
 =?utf-8?B?QllqcDlWUlhTejBJSWY1QmNkSnIwQ053ZDg1eGpsblpmM0cyRlB5d2xkZFgw?=
 =?utf-8?B?N21hbTk3clNLWW80amF6TTRLcW05bjkzRkJJSU9YK0RMZ1VVeHNhQXFwdy9w?=
 =?utf-8?B?ZWN3OHk1WHdQM3dpZzhqcGZnZkI5eDBodEtvaVNoeXhKeDBYNWp2K3cyUXBn?=
 =?utf-8?B?TWJ1RWVKNXhKQW1SVHdnVlBrTGw1TG04VEovcjhPSUF2c2VJb2Q3NjlicVBs?=
 =?utf-8?B?WVNBNitNbW5KSTk2K3BCNzYxam1NMzJzS2F4bTFtUmJCbFkwWlY0ZzRVbFNk?=
 =?utf-8?B?aC9ibHVUb1lXWVVReGhBcDhmRXhtVUwzbGwyT1AvZzJlUS9HVDVEWnVLeUN6?=
 =?utf-8?B?Uit2RytwaDdUMzd6Tk1rZW5BTjBNbHBZbXlPWHl0V01tYmFFazgydHVVc3BT?=
 =?utf-8?B?aEg3a3NRTURybEh6Y1hXeGxBelJmSGRXdXl6L1NucHM1TjNJRGVQNnJnRFA4?=
 =?utf-8?B?UnMyQnI5WnBBZ3hRM21TWkhVanVRTS9BR05iQ3VieHcwaHBmeUZKaTlpNTYw?=
 =?utf-8?B?U0NMQzlHclJOMGd2Wjh3dTU0MlpZdVFXdUIyRWpEenBteS94RjdUK0REYno2?=
 =?utf-8?B?dEJSQ283SzQ4SjMxT0U1VFZmSzEyVkVzREl0cEJWdk55WVowZDdaenJqcSty?=
 =?utf-8?B?cC9NWG1pYzArdkZGVTNCTFhTSEJGcmRLZFJxNzE5Q3g2b2FMalZuTi91NUpJ?=
 =?utf-8?B?bFFDbTkzejAyT1A3aUpXeW5obWYyQkxpL01SdVkyaENqZzhDdXErNlkwTmdl?=
 =?utf-8?B?UlpWRnE4Z0Vpb1FjU1M1ZWw4djlOVmFUYTNiL2Z5USttK0hsYzMwRjN1TWVH?=
 =?utf-8?B?Vm44Zk5rOFZ3eVFQQ2VHSG5rWWFzaGhRNVVRYmFqMEFQZnFORC9XdzFJRWpE?=
 =?utf-8?B?UW9qOE9UREYrNFd3MC80Zm1RaVdIeTZoUnRMMThjZ3FWdnBXOHRyU2M0N0kw?=
 =?utf-8?B?QmtFL3djQjRqbHRGRkhHUkZSUWcwZmEwUmwyM2hNWkpyeEc5ZGlpckZBd1dw?=
 =?utf-8?B?bnk0ay9STGNTcGxXTUVSbTdSN1RuLys4ZGEyQ2pDZnZNYnRZTVZXbkRGdGNB?=
 =?utf-8?B?N2hoVWpmSmpjTnNMeHIxQkhPczdMYjFUSVVNekQxLzhDbXFWTlhZZk9CeTEr?=
 =?utf-8?B?WXNsaGx2Q2I1MkFlbGIwcld6Z0RHM3lTT3RPaUF5bDFJcnEyMTQ3TUFSRFNC?=
 =?utf-8?B?ajVTNmJidXpNNU9zOUhpSXBMZjRvR0lSOGZVa210ZTVNeWNXSkkrLzZ1VSs4?=
 =?utf-8?B?MGRxQnplU2wxUTg5cmJvcVJTbW9QOFFEQ0grbVcrTWxZZzl0TWZwN3NLajJS?=
 =?utf-8?B?V25DTzI4ZGFVdk9oRVNRVU1ReHU0ZSs1VFlzaEtkNGErd0RScm5qV28zaGFN?=
 =?utf-8?B?R09BYVRpT3pldzlQS082dTBLNjZjWEhwbjBSSjR3Y2d5ZmtGd1RkVDRpVU5i?=
 =?utf-8?B?NFNrSmd0OVQ3RU0wMUlzL3JDYVFTckN2b0hxYUtkNU1IRU1lME45bU5YbHpW?=
 =?utf-8?B?ZzVNVkJIM3R2ZjZTcGJKSWxIWFVkcUt0ZDNvenU4M1lGYzR3UU1tWnVMWGd4?=
 =?utf-8?B?WGxVais2eG9JWndBWjFsNEZkODBzSjN0VGVIL2V3aHJpLzZjMW8xV1p6a25S?=
 =?utf-8?B?WjlVbVoremovRUlycmZyK3JtcEdWUjhiZklBcS9aazFHTUFyV0YyNlpCTEZa?=
 =?utf-8?Q?tYQSTkktGme8QgIQ=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f846cc41-66e5-4c77-06e0-08df22c457ef
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 09:37:59.5602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FtGQT1o250sva/BRkI1tTV3uIS6PoF0JCQg6HYjgOxnkRiuVQUb+i16pKxLA+BrjytwmuJbsLnsK8sKqIqcQ25BUj/vLVWsqi6KcgFRMejfKjhoTM4alBxVrSNhiH4lA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6956

From: Frank Li <Frank.Li@nxp.com>

Add two new inline helpers to query DMA channel capabilities without
directly accessing the internal dma_device pointer:

  dmaengine_get_cap_mask(chan) - returns a const pointer to the
    capability mask of the DMA device backing the channel.

  dmaengine_has_cap(chan, tx_type) - returns true if the channel
    supports the given transaction type.

These complement the existing dma_has_cap() macro which operates on
a dma_cap_mask_t directly.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 include/linux/dmaengine.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 615eeb708dcda..7fce44bd7c049 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1585,6 +1585,18 @@ dmaengine_get_fill_align(struct dma_chan *chan)
 	return chan->device->fill_align;
 }
 
+/**
+ * dmaengine_get_cap_mask - get capability mask of a DMA channel
+ * @chan: DMA channel
+ *
+ * Return a pointer to the capability mask of the DMA device backing @chan.
+ */
+static inline const dma_cap_mask_t *
+dmaengine_get_cap_mask(struct dma_chan *chan)
+{
+	return &chan->device->cap_mask;
+}
+
 /**
  * dmaengine_is_copy_aligned - test copy alignment
  * @chan: DMA channel
@@ -1810,6 +1822,19 @@ __dma_has_cap(enum dma_transaction_type tx_type, dma_cap_mask_t *srcp)
 	return test_bit(tx_type, srcp->bits);
 }
 
+/**
+ * dmaengine_has_cap - test whether a DMA channel supports a transaction type
+ * @chan: DMA channel
+ * @tx_type: transaction type to test
+ *
+ * Return true if @chan supports @tx_type, false otherwise.
+ */
+static inline bool
+dmaengine_has_cap(struct dma_chan *chan, enum dma_transaction_type tx_type)
+{
+	return dma_has_cap(tx_type, chan->device->cap_mask);
+}
+
 #define for_each_dma_cap_mask(cap, mask) \
 	for_each_set_bit(cap, mask.bits, DMA_TX_TYPE_END)
 

-- 
2.43.0

