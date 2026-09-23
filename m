Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010033.outbound.protection.outlook.com [52.101.84.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1AD4CCDEB;
	Wed, 23 Sep 2026 16:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180391; cv=fail; b=jeKvxSULcV37kkqg7c/brjdAJLuZm6lk934uukSiAlx13wkERhH8WSJTDmufnyWzlVR2XrQaqJ5SZFZIKQ2PvbVcG0lYDp7H3AgVYKmLQz3Ir+bh2aQQxBmC9hOTB64b2dbSbCY+Ga/p31BwWOY9SDs3CV3mGj72eVqW1p3Alvw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180391; c=relaxed/simple;
	bh=sgx23NLzxLdKrRKfBDseFoji6Zfl7o/qGs0UQi+GwTA=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=Ep+JUO2HKdOtyNfOcpuggwkg1Q/rzQJgnqDblyep+1Ts4R+Puyz/t4+DTSsmlKndfqYLVdaF80rvxLE+k41QI+CCNOw4Rjlay8vzEGXjXdsfrdZR7t59ST13Ldf0kjgP4ZeNrnvSppBjlWP6KI1pNfEeOWtmR3HISGBbyFm/YEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=h0rBUg3r; arc=fail smtp.client-ip=52.101.84.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="h0rBUg3r"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HLtTfzE3BjIqmtWvqAwOLtsKSllWuamcsWW9tPvIDecp0j/XdxGGfW9vWdH/ZSVera/sYdCxc41eq1mL/BCy0V1xc6rQQH7XJ9LZhpuW1bOfK7DewDsxb3qu0FIbjchamGaTCyWHdRpVjgUEWHFddQqeFYXwk7xi2gtCDUInum0b7NZ24KZgtVBFd3oKAq10czyNrBv1YdkcXaC56vmXB8HbaivmZLeLTxB4jtLHbODuU1ijuyiEQAjGo64qpXyC25t90Ipe95Ewyin9CaUQp3oFiQvFHR8Foj+9EcXN7E1teZAyOXya5w62IH+1N3/6UBCsFbaelS3UaLcfhHOb6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5/lB/RyNPF7QjZj9yrtf5lhU0ZLLR9PHY3fvAO7Ypno=;
 b=uWjVzKn1BLRZrp7F55wTkqvVaTK8OiR9/IXTFSGDPppu5LWo6FjHHJ8kIM5pXSxneUKSliO6atDz8TMBtXy8mZJcFS7Sl4OerJRktuqdv2rzOREqmORk54r862YzeIwUQ72eP1puyPTEesU4vZX+AK3vALfLjDwl/iW+HCfkYe500dZSOzMMbZqAQYHZscvqoTwOBNzahfScKfPF8ntkzISBl7Akympzd4uxr4rgnpp6+Wnr8PNuW4zxBQf/TtIWn3Bt1UjkWCWGHmYM9HAi+W/R4wC0B0WqyVYKmju2r0mS+tv1+vXodw3slSHbG40bOe2nj28zqmQKmrsfOWwswg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5/lB/RyNPF7QjZj9yrtf5lhU0ZLLR9PHY3fvAO7Ypno=;
 b=h0rBUg3rVnBYNdwY0t53TSFmTTXsert4b2nPV6fuNKj9ff09dJW4lfVMqOvxkBg+6pNWole+LHJsvQjkIWqHcfaelErfi9bP5tQmS9LfJPPnITQVRudmiRSTpbNYfMr/0IqtK+WF8txEsDyvMUXkmMieHWU1P6jrEgWaJ4AfUvNc/jXCXQdmLr0sKGmebCBbg2xpOgeUXMVC+ru18T5KAdeZypauCRqaLHKTVp3rYp+M6aF1rVR+mra42lHtuRHwBh31bdsqjQH2G5gxJxjWh20siVOjmHwM7uN8IeBfAHsLngsmILl4eLzEo9YVwaCd2pdqY3hLiyVYOuRv/nzuoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by MIWPR04MB961718.eurprd04.prod.outlook.com (2603:10a6:290:e4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Wed, 23 Sep
 2026 16:19:46 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0428.015; Wed, 23 Sep 2026
 16:19:46 +0000
From: Frank.Li@oss.nxp.com
Date: Wed, 23 Sep 2026 12:19:30 -0400
Subject: [PATCH v2 01/12] async_tx: replace direct ->device_prep*() calls
 with standard DMA engine API
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-dmaengine_prep_dma_pq-v2-1-32ed65b8a9b4@nxp.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790180375; l=2415;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=WBG3/DpswlyQH0OnlhwZNMwqNHquMeYdzsgXwnCd/04=;
 b=0Oqwq8QpAsw0N0+yHB/ABHSxh3E7gCpW6WmFwdRSnlrKIf7MwBKjeNhBFlPvwCFJxYO2yq4rW
 JTUt3k2O+4mD9KI8nC0Dhs8Pu2Uxfcg42N3NRaSGHNwJgi8p43ysL1Z
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: CY5PR15CA0218.namprd15.prod.outlook.com
 (2603:10b6:930:88::21) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|MIWPR04MB961718:EE_
X-MS-Office365-Filtering-Correlation-Id: 26d6d9a8-34a7-45e0-6ab2-08df198e7bba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|19092799006|1800799024|6133799003|11063799006|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Vgzbnh5xBUibdrv8gfEmH091Q2llGuocvfr/S35nlhZv4BD5xHVQdAJHJKhjhOwUS4FSFL9YIEHjbtlFDgm6J5FPUyBE60b43XIL9B/cNDg3hflBtqaxMi+6xO5MJCnYHlacYCtBt8rP0pWFaMMpNwcMLuh8Yws0uGizx3+DNLGLpmY1qaCCeZDsAyF6CZzbqlnJDMPIWuWhv2jSlr1mV9YxQBu0DOlS0QRc1sCTwYhxuIb7xz78bS2uBzmL8Lcq8gpZQFXUTVvRES9PY8ztmk6x0HekcTWAAadBzpspChzts0PmqlMXKtD45xD1BQtqaPmnWotVm2cfXM52Du+YcGiw0ev8tWeaXB1+r8hTn1wmE7sLzL1SRLZJ6Fnsm4MQNTcSn4ZlQs0xv/ywQVWRU3BmcLAaox79ZKx6Ikko7hU17txnIw19NbEN0aockbAuGIue9pGPw+g2vD1ior5EmF+hdLNaTlJRPugaewytr3cXBguQuR4ApLDTZ0wP1Qvh78A0YspgGj7l4froP5v8iRmd27942snYadhqYKwo7EXEmSGVhAvim18tBbjPzvg6oM3xda9aKJzr5637ATjzIMCS+9z/Vz2Em6ZGqz1CXriNdnvHMG6+4SS/ysAAHww4C8Tfu8X24z25vFKK9OudMVxgRd/uu4ccTXuCT5Tow0Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(19092799006)(1800799024)(6133799003)(11063799006)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cU9VN0dmZERRMmpwdjZ0ZEY4RGd6SmJSckk5TElxWVczQWtoMWVnUVpoWlZi?=
 =?utf-8?B?VmxlUjlwV2lsV1Y2VDlrL3ZuVHlBT3ZNWW9zdHNRWEEyTVg2MWZONEp2cGE4?=
 =?utf-8?B?SE5NM2xPRzZkV1lReEZ4amtQYi9XYk9yQ0gxNnRtMkZlTTRDcVF6c3hIVzlE?=
 =?utf-8?B?NFVrVzExOElla0tmM21qRFhycUhTakhpT0IxdG94OUdYL2srbzVVSFIvWUE5?=
 =?utf-8?B?Uk9aSlBMbldydDlab3A0c1M5b0hVazRyQlB1TzhKTUR5U0pkZzJFZzhqZ25W?=
 =?utf-8?B?TVk1QzQyY1pDd1dVVDZkSm1qV0hiVGI1WWFxMnhoQTR6ZVBWNjRoOWFBcnFE?=
 =?utf-8?B?ZzBlSFE3alRDcml0dmJoZHNtc1ZDODFKWWlOQ2w4aEVZbUxZMlFNMGVFNEl3?=
 =?utf-8?B?dTI0THIzM2VJNmRlYy9TMGk0bGRxUS9neExOMXJqdmhCUWJOT3JHQzJiZWpU?=
 =?utf-8?B?ajJIMFRudkhzNENBQmNJeUpsVFpNbjUrSmFoOTRKc3g4WmZ3QXdUL0hYRXl3?=
 =?utf-8?B?cFlLdlNMZTBPYnQrR2tHelovYzVNMjBydWdLV3ZERkVZYW5OYmI4Y1IxNFFQ?=
 =?utf-8?B?T0FvOXUyY2Erc3JPM04weURKdTRaanpxVzZCTkEzWVBzTWpNc0JBenlTdzlJ?=
 =?utf-8?B?NW9uNXhCTzdUR1J4T1FGd2xlWEJ5cUJuck11OVdqRXkzQ0lSR1RURnh3V3B0?=
 =?utf-8?B?eXI0c2RDR1dTRGtQbXlCVUpkdmVxby9Dc0NUK0VQMnI0b0xpNm1mMXZGOFJP?=
 =?utf-8?B?Q2sxS1BKTFdJTEp6bnRRVllvT1hpZDdVTHBVa3RIWkxYNzE0VVF5dW4wZkxq?=
 =?utf-8?B?TkxBbzJialEvcWlCNURSTnYrcGVFSDIxcWlDdDRBSDZyL2o0Y1F4S0VHMHN3?=
 =?utf-8?B?bHQ1eW5GejVObFlSaU9GNDRHQ2p6bzRoakJHdVZMSGYxcldIaHd3VHpmSUtO?=
 =?utf-8?B?dFo3KzQwWmk5ZnFkT28yQTVrbUVFbnBFaDZGbXZYZW5HOExyWEt3R2pZZ0ZM?=
 =?utf-8?B?M1lOVW0wVnF6S0pNSjZ4emQ3Sjg5UE1SYkdsUE5PWVJDT2NTZUhWWjN0NmVu?=
 =?utf-8?B?M1NIMHdOWnNhUW1ROGhXT25WZE5KNmllUjV3Y0c5cE5CdVVabmlJUkRzemhp?=
 =?utf-8?B?OEV3VFBTNy9FUlBzUFk3YU1MR1Axd3lVZ24xWTQvZkxBTXBuUncrRzVRaEhL?=
 =?utf-8?B?UktpY2hPK0pOYjExa2pUQjIrU0VRWVVBbzJsZHk3YnZHV21IOWwvNFV5dHc3?=
 =?utf-8?B?NEFpM1IxNTB5TzBsU0ptNHNhTEFwZUxoZTlBV1NPWHJ4U29SNVZmaGp3c1BF?=
 =?utf-8?B?ZXkrLzZ2ek4zZFBVS1JHSHZlTlBXUXQyZkQ0bWxYVUlPUDNESVVRRFRKVGFa?=
 =?utf-8?B?YmFwQkk3YXZzQmNvTjhJOWZYckl3dTEwaFhMQXVTVFoxSktqYUQ4bUpOZzky?=
 =?utf-8?B?QVg2QUpYYW42dDBWREdPTlpSL2M0Q2I3cGNyYUZ2NDBqS05rdFdjVnY0Z2RK?=
 =?utf-8?B?THJFMkhVQUJ3Q3Q1S1kxd2xHZmNxYlVNTmx1OWx4eVJGMTFLbGNoSWNLUkhO?=
 =?utf-8?B?SCs5RVEybFBYaGtRMnI0WUJ3bmp6V0NSTFlMenNNanRhbG5yVURibE1WRDVH?=
 =?utf-8?B?NjVrT1o2eU1rT3N2Uk5oM285YnhPV1ZHWmZVN0Q5SGl5Z1BOUERYTFJURy9L?=
 =?utf-8?B?aFZzKzdSTzhTd1hoQi9IRVA1Rm9JY3dEaCtEeGswbUVEbzRWL2h5RVBUM0FJ?=
 =?utf-8?B?UDVDYzRnbktFd3VZdVVYcU5ERDhzZ05ueDlsNWg3Ym5jWDE1NnJKZi9IbkNw?=
 =?utf-8?B?a1NVVEgydE5kbjkzSjNENkhKZXliUzFDa1FhOWI1UURlUUxlbE9lNmlXZG02?=
 =?utf-8?B?TW1FeTJqL0xWZncyd1djYlVZWEVrOUQ2R3hyeFVrUnZFMTRDTWxlR3MvTXF5?=
 =?utf-8?B?cTVWQk14Y2drNm9pbE1TeE1VRjc4WXFnQkV3TkRBUjE3TFhHUFJBelNoOEN1?=
 =?utf-8?B?emhQcVJ3bDdwc0VwaXBmREVwckxaa0thd25IdFNDUTdjajNSOVVHdjVLT2to?=
 =?utf-8?B?T1ZpSC9qTmlVcmlGb1ZwSTdjNVcxREg3RjFpaGYzM1BwOXNHMk9hR2NrVyt2?=
 =?utf-8?B?bG81ekhVMm5QU3NOMmxJUFlibCtETXNJWU50QUZiUzVPNDlaVDBMMVlVRTBH?=
 =?utf-8?B?NzVZUEEwSWs3V2cxQit1S0o5VG9taE1Odm1KMjgydWZnU016OVBDeDJ1Rkxo?=
 =?utf-8?B?b1BycHZPTTNXZVpXbGQ0dDhDRTlzc21aUy9xbG05cFBLNkFDckpwN0tQUS9V?=
 =?utf-8?B?SjZIeFd6cjljazg2YnlYZFJyY2ZnS2o1WkFmTmxnYkdiMktqbWZpQkFxc0Rw?=
 =?utf-8?Q?hYc1dR5wA8KU5oyH0W1BXVkPpU/7nPqbwuufU?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26d6d9a8-34a7-45e0-6ab2-08df198e7bba
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 16:19:46.3605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +f+Zkq1d41Fb1gjASVTF22DQ+6afy5wNbLZxmsHOUKKHXEIEmkbzfFuJQJFPTzdjZZrrjWygkf9siAt1weRlT42+4wt2Dm5BCoTkE5Np4Yqm2UhZ6rALoXctHkksUSS1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MIWPR04MB961718

From: Frank Li <Frank.Li@nxp.com>

DMA engine consumers must not call the channel's device_prep_*() function
pointers directly. Use the standard dmaengine wrapper APIs instead.

Assisted-by: LLM
Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 crypto/async_tx/async_memcpy.c | 6 +++---
 crypto/async_tx/async_tx.c     | 4 ++--
 include/linux/async_tx.h       | 8 ++------
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index c538e30e99094..627b6ad9313e0 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -58,9 +58,9 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 					      DMA_FROM_DEVICE);
 		unmap->len = len;
 
-		tx = device->device_prep_dma_memcpy(chan, unmap->addr[1],
-						    unmap->addr[0], len,
-						    dma_prep_flags);
+		tx = dmaengine_prep_dma_memcpy(chan, unmap->addr[1],
+					       unmap->addr[0], len,
+					       dma_prep_flags);
 	}
 
 	if (tx) {
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index ad72057a5e0d7..01ef830675574 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -79,7 +79,7 @@ async_tx_channel_switch(struct dma_async_tx_descriptor *depend_tx,
 
 	/* attached dependency, flush the parent channel */
 	if (!intr_tx) {
-		device->device_issue_pending(chan);
+		dma_async_issue_pending(chan);
 		return;
 	}
 
@@ -113,7 +113,7 @@ async_tx_channel_switch(struct dma_async_tx_descriptor *depend_tx,
 			intr_tx->tx_submit(intr_tx);
 			async_tx_ack(intr_tx);
 		}
-		device->device_issue_pending(chan);
+		dma_async_issue_pending(chan);
 	} else {
 		if (dma_wait_for_async_tx(depend_tx) != DMA_COMPLETE)
 			panic("%s: DMA error waiting for depend_tx\n",
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index 1ca9f9e05f4f1..9f7fef19f2142 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -87,12 +87,8 @@ struct async_submit_ctl {
  */
 static inline void async_tx_issue_pending(struct dma_async_tx_descriptor *tx)
 {
-	if (likely(tx)) {
-		struct dma_chan *chan = tx->chan;
-		struct dma_device *dma = chan->device;
-
-		dma->device_issue_pending(chan);
-	}
+	if (likely(tx))
+		dma_async_issue_pending(tx->chan);
 }
 #ifdef CONFIG_ARCH_HAS_ASYNC_TX_FIND_CHANNEL
 #include <asm/async_tx.h>

-- 
2.43.0

