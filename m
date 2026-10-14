Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011021.outbound.protection.outlook.com [52.101.70.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E855568FAF;
	Wed, 14 Oct 2026 19:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792007061; cv=fail; b=F0eTO78yOqONHfTG1oVAwYQEJ38B0t+sPhIIyj0TCHJNklPNVpNkh+COfJnGuHU5LfaA0Q5n+Nowqen1rUbHenFZoKOK6WYsJ0iUt23lYrENrh3dmYuMoc/QhIVAaVtwEhGZibaNGlFiuTAnPpzF9vwLH3JR2krMVbPDV8Wd2jw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792007061; c=relaxed/simple;
	bh=Sxo/fdjF891jqQbEI57+UsgGvPIJBm6727nKoyPqrJM=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=gSyJitn5P1MgF2zfbvRIIc2vCpxqXzofA/6YU71shqfo0odpEA4+S/cGuyM6YEC1VTBqPkZd3zZWGnO2ZUeujSrHWUtPO81xJl5cssSLuTfTzZuqnHMRulg2cpypKKvhP4J+MSiu129X2fkVbqXSXM50H+8o8HbS6npU2F2UKVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=XjVkrOuP; arc=fail smtp.client-ip=52.101.70.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="XjVkrOuP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tdP6LL4+pw+6hsxeapVxpnh77rIHkurQyrDUH8JNOCYpFeJrpMkq0xW7y9czgUxfJMCbRoVCEtdSbVMkWpoWbK37cCTBuSa3F+sVcqi+Hf4LTAn73yMy466Y2gca9HQONxI3GVsAF5zAjUa+CQaBaF9NbZ1V9HxgRGD2fyS85sevf7hho41md8tdfaENI7zP+7p36+iUnes6hj9J3H4m80rlLRPuGZnCKF7Q1VG+A1xJv6VIi78RmPuwTdPWkPIm67YOrrZJH39SJKHigNZuv0BOE8zlnHlV8rKYTtAx04co1V/ItGhy9JOv1Ui3F7YosOyUemfyyUcuwMNwmv6RMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MoMAFbeT/Kz/S+4Hy7QZwRRAMgc/ugp7DlWOAPG2GHI=;
 b=xpsCW+nX5r7jP17D+9edCwEwCMLf6XeiAYSQ1E80gZDsDruDlD8XHImkBzcg6BvFrxRQ3muIcRrLycf1NqaPuzLQUHmXfVOlXD5SZ1ciJGvBx6xFVR4EfDuleCl9oHFBq0YL2Crt7rLB8Cv32FsR9Xv8RaMpQr4FeGHtBci7u93vV/6wsRmUvZWEP6f0loYsDyk6WMWJNqYt3F7pdB1VuCozs7dN9cL4zKPyZCnO3DQHKaQ+PRWW5CPkOcrtCKpX6hEj4y90Uc11ux4GsA1Bid5A1uDE3+5KApeXqrJIAFTO25Vkx4Xfwpm6xmjYMe0z4kFnm3CufSqKprISGwXU2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MoMAFbeT/Kz/S+4Hy7QZwRRAMgc/ugp7DlWOAPG2GHI=;
 b=XjVkrOuPvFmbVhL5o8Y+bESreqw/kiG9IMnSDpUcbZzgfG0nG1BViwdiqy7D/4mzrTfX2Vnu3Zvyv8vf0MTJHNcwZyxEwjXve6UOGb9OD/VSEo3maT5L63ABA3phIq16xQOmM48Gv+hsEHoYHlA2F4XXHDE3Tq9RCTb5omwhEPlnAdVYxjB6wz2oLFy0ZVVrUc/iytxoeaFv7h1hSo9tg4uSMIGYZmGax7Zx3ljZbBVq9GZ4wasTTvAvvthvkeJXnkBxxmvLJFy+8eQVXRvT4Qetl4FSa7sYHfoKdYKFOQp1I3uRk+Wj0NTqGlUoPbOKwB1RVDWdx8sLxzfKQhQCHQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DB9PR04MB8361.eurprd04.prod.outlook.com (2603:10a6:10:24d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Wed, 14 Oct
 2026 19:44:16 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 19:44:16 +0000
From: Frank.Li@oss.nxp.com
Date: Wed, 14 Oct 2026 15:43:47 -0400
Subject: [PATCH 3/6] async_tx: use
 dmaengine_prep_dma_(pq|pq_val|interrupt|xor) instead of direct callback
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-async_tx_dma-v1-3-35790d01e190@nxp.com>
References: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
In-Reply-To: <20261014-async_tx_dma-v1-0-35790d01e190@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dmaengine@vger.kernel.org, imx@lists.linux.dev, vkoul@kernel.org, 
 Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792007035; l=7467;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=tVRcby2UAkXHgo/y4rmvmUCX6xWI5VeTjfvvjtYvYl0=;
 b=TEPG3oZu84TKaFiaI5kwzsN5G/0SY0bvvYsAOOawuSFuGdLyvoOBMYhod6wiwwjOV3qS1E1v7
 RMQqcE/b1lQD5RPG4fyV6ExWqn4w+hWqp7DUj++kMporttz1WbzuE3Y
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH7P221CA0073.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:328::30) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DB9PR04MB8361:EE_
X-MS-Office365-Filtering-Correlation-Id: 18a7b26a-7131-43ef-8857-08df2a2b87e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|19092799006|56012099006|10067099003|11063799006|6133799003|22082099003|18002099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	DRbq8dFDAIifIuG3DvlJoXjUQ51OOZ6YVDr0h1z+9pxrD06osXytXOTEUptKwpmFKV90MtZSKqlVZs0McNcisjDIRKNMNkHkdZmLyRr8rYwxsAAjbi16Ak73WdGRctDY7mDe2XXotlTJ4glQ+Dp2gDGu3jrSfHdSYs0seQ4B30vP1vBsmJ2/QhGtBoRGD/e2hGcoA8ZVvC5dbdkepzpHHCXxKU2iF5N28f6TAJiFiVQLnnlFlKBVz/lJDM2KNWXcLUjtM3BmDhydIycNW+DQHpsYxwNBYysSiMgmcRyVzA4zH5IxnzYPJ72Tv588tzLvMXm8ZvSXD6/CGuX6Fn4G2bwrpL3SQlxnXIAdAPquXL57ZqHN/xnPId9Hw0UKxOTOsg1WcrFzd9OX5G6FVYY2bL/WuHnQP3ivI28ogtiARLP4SPJKeznqZOWJrJKk0NJXjCGmy8vbSLeCjIvU08EN54e8pqlmgvavDg/4KoF42ttBCvS+HnScwqDscW3rid5MBCUfgsGKmH1QHrAiPyIG8xizVsMfOPxAQrYZtTqdW7w8d5B1BEbRw/+kT2SejxIWidOQXM/dYQYrUnR+zWQHVwvL4a1+IYhmD7kefZwxKRz6qMQkXe3dZ7eq2unY6w2Nq7oh+ymRFbVSZk3tJr7kqag6vINEwQ9MYGdojaYrano=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(19092799006)(56012099006)(10067099003)(11063799006)(6133799003)(22082099003)(18002099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U3hGY0tXeE02QVZxNjJvSzk0ZFNIdEZvYjc3WmZ0ZmtaVzViOERraE9XTHpM?=
 =?utf-8?B?S1pUNEwrKzl5UDRwN2NHcEUwSzVCcVJybHZyRXFrWTZYTENuWTZvMU5xQ0ha?=
 =?utf-8?B?NXRva2w2VXFxcmFVby9jcTNvRnd5b3RkWHVrVjNJWGpnQmZTbVozVThJRGQ1?=
 =?utf-8?B?WDIxUEN4MXhSenc0M1JabkxXc29ESGtkOG02TWxTQ1Q0SWRNREtXcUJPN0pq?=
 =?utf-8?B?UTJWektJYzR6ZmF1VFhGbElPNGZVNEdkOWJTaXB5aDZVSCs1NmhCQkZrS2Rj?=
 =?utf-8?B?MWJyK0ptMW9ITDJKZ3JTaXNTVVZEa0ZLOGwxYnZFdk5paThDNXBDSzFBemQy?=
 =?utf-8?B?UmlReVdsTE9VMVlSTng0Wnczamc5dmVDcW56eTY2ZDZqTFhsVW5GdDVydS9i?=
 =?utf-8?B?bE9kSU9lZEdTOFVYaWR6R25HUy80cjlESHZLbiswVXJvQ29Zblg3U0FhbmlP?=
 =?utf-8?B?K0tIM3YwdFJBRi9XaHBqNzlsK1laUXI0RkZUQTBxZ24xVG9VWG5QZXg0cTUv?=
 =?utf-8?B?REFIOVJHQlcwa2ViNG5nV3FWTUFiS1JteXBlblU1QkVPNlFheEk1dVBnVHd0?=
 =?utf-8?B?TDdZNVlicysyKzVZdzk5MHRvRmRtOWViRW1Ueml6OWQwTmE5ZVRwK1BsejlN?=
 =?utf-8?B?QmFBeUZ1WG5OQVd1Wi9QWE05cXc5Z0JvVnJLVVFEc2hlQWlqZEJ2bWtSNTBX?=
 =?utf-8?B?dzRDMGhXU2hNRlIrMTVNenBiYWx4d01WakdJaWtCUDN4azFyZFc2OEZHSjRp?=
 =?utf-8?B?NW1SOHgwcmVUc24xVXlwWVJaRjI5OTRKRjdpdEdWb2ROY3pzUnRvS3V2T3dm?=
 =?utf-8?B?UXJ4cGJ5bnB2M2Fhb2JES3p4Vkd0OXlZdTRPY01Pb1ZHWXkrRmUwZGc2bUNY?=
 =?utf-8?B?blo3U1p4MzIwZ1JRNmZyaXpZaEJTdk9xcEFuWUJZbGVRTFFDMnZKZW8xUjNp?=
 =?utf-8?B?bXJaN0ZNVTd4QjgwQ0xlTlZldHNjSWN0OTdvTE9tYUtoZTdTbmNRWEw3U2dO?=
 =?utf-8?B?WlJrT1RCak1JN0ltbzUyTmx4ckt3QVRlRlU0V0tXdng4RUpLdzNQaldGOGNP?=
 =?utf-8?B?emI3R09pam5lK1k3WHVGNVBJaG1EN2lJc3EvaEsyZzc3dzBycFltQ2c1ajZY?=
 =?utf-8?B?djBtZWYzTnNkQk4wV0NuRHZOSUR0VjBkckY5MWhNMHB4bjlhMkw3SjMybUlH?=
 =?utf-8?B?V2YvYVZhRHc3N214Yk1zTSt5eWpuNktCbVNlV09EQkxZUFE2TE0yYkFqNnhF?=
 =?utf-8?B?UllaZjB6T3E3MmRKTnA4dDYyd21IZDNKNUhwTStEaFBDWE1oWTJNQkxWbWlL?=
 =?utf-8?B?ajFJTGRqRnA3OTh0aS9mOVd6dDZXQmtZSDRkd2hqWitGTUl5NVRPUk5nVU9J?=
 =?utf-8?B?aGQ2V3hId3VpbU13WjhKYUdOT2l4cU9mY1VXR1Zva091VjkyVEVWU1NETEJB?=
 =?utf-8?B?OW5qUVM2TXRYWDNZalZCclM2THJyNUJXNkFaN3lBaFJIY1NDNUhaNTBKNDhM?=
 =?utf-8?B?R1IwazNiS1Jpc3JGcDZvMVRaYnd0amVCVll0WndIN3JIRk44aUo5amhDOHps?=
 =?utf-8?B?dTlGU3NFR2toWWM4amlGRG1WcEdudjZyV2hHMjRkL01yMGFuYzh4b3ZjNElM?=
 =?utf-8?B?dkJDRzlEcGhHeDdoU3A5Zm95V0srLzYzcjV5ZVVwOEMydGFWbDloNDdNdzJz?=
 =?utf-8?B?STcvSTE4V1FxMUp2TkZ4V2g1MEUrbURjL0pnQlFhQVhnK1lMWWxIQmNjTXZZ?=
 =?utf-8?B?S09scHB6TDdKUWNFRDhCNGZSN0tNLzlzaEFkajdxTE9sUWJVaUdvMVFJcmVD?=
 =?utf-8?B?ajI2czlyUi9SVTdDSjRyVjNwTHlyMjNhUlQwSlhpNzArMFc2ZnU5WUxjblhP?=
 =?utf-8?B?T2RGN0EzVGpFRHNvWlpsdTBQZWJ6N0FCZzB5Zm5mSHdRUlFjWEIvS1JnUUtr?=
 =?utf-8?B?L2VKSmxZb2hWeFlDRnk2SG56T0s0WnUyVkMrdFlLTDdOU21Ed1Z6U09mVmsv?=
 =?utf-8?B?K2t3V3l3dXRDeUFMR1VIazlKcGQvckhCRmxnM2VSQWZLWWVGaXV6VGYybnhl?=
 =?utf-8?B?RUlMVjVuZ0xLSisrZFlvTXdTc3A5UlMxWmNxZGRndmgyMXl1bUVqNlcydElB?=
 =?utf-8?B?dzNVUktwMzZ5QzVNeTdTdUhkNUtYWGVvNUZkU1VQSXVFK1QzbG1kMTBDV281?=
 =?utf-8?B?TW1xMTRabTkzaE9TLzA4RUpuQ0hBc1ZDWDRPMEhHQ2g1VUJjNDh2RjdNdHIv?=
 =?utf-8?B?NnltQ0kxOXB3cWZqSnZEU2x6Y3ZKbU5YS1pOcDhsTExvSWdaZW4vU2tWMGE3?=
 =?utf-8?B?aHJXbzZPampGT3UwcGtJYUZQSk9sSUcwbEJuSTZYMDI4RE5CWkhJSFNLWFdy?=
 =?utf-8?Q?BPYcl3O6RVgqlsatYOhnfwHjlQ6kK+LLh2SaH?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18a7b26a-7131-43ef-8857-08df2a2b87e6
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 19:44:16.4441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jgy5BTOWvvW/YsMbrQez/WCREr+fbC74m3y29Hf3fIFFKdZEEmmLpzC6ikDiFDnITyi2jFw4Ms7GYfwjZoO/1lKH4iVP5+MfRxEAf6uJzMtJJWqrTF8sXDetcZ86u4wF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8361

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

