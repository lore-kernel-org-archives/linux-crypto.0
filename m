Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013053.outbound.protection.outlook.com [40.107.159.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B063EE1E0;
	Mon, 21 Sep 2026 23:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790032172; cv=fail; b=WIUl0XpVkvmqISNOL5cdIIZCu+QP3oqd2wPF/g07a1rQfII50KswokRZ40WhpbhJEqAEtk9dzSdiBtY3HuPolNil3gY+1e7ApDzm1n3oqEojvW5Hy0NoiqkjU7YKSNqaj5wVNWOFfb/F8G7Ottb7RcHqDr+uK5kKXcsIBohWbTc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790032172; c=relaxed/simple;
	bh=7LAk3tPZbOIkRtAtbfU/2l+Y5o6/y2LKs9tcIeGiv2I=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=uwcY/e393mP5Xkhx28uIL1aHm5UarJrkJ/AWA6FFKG7pl6R8YAxrRKlEirhhclndWs1ZnhX4AnQCctjeBUa0MCEXL9717WIOvhCW/1mAFnmz5mwmJ1YNZaBvbS5pR1qTtxNgUYkSWiS/BQLn5pKYtvTA0WrHYlxQylJ07i8zxu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=rqtb5Wvt; arc=fail smtp.client-ip=40.107.159.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="rqtb5Wvt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rfA/EtXAhgwgQDI7y1XMq9IJV7iuTCTVfH2b5Fm/PBQlRqg1z92msZFX77NQ+USgGxE/FebRYYsaSR1c+rpnjlL+EEhDmgwyWGc0mEYmMX6fcVqDfDt7HXZwEJmbE66w/zvlw9qRTpR7guf2u2Aov1pl296udb1SH8QTjfLtI+7J/82xwIxJrq/urJrg4uBxpEtcujVqPZ+iyIe1f6EUGfspXsc4VcYfDT/fGtrBKestBmCsIL0t9yiWsAYsmXbAE+jLi7+VhVmdFda0vtAqxekhiDnK2iiY9EXAZcU6uTMZVJlXS/xaCXG275rDX6OEpF/c2we+b278uX6ookbVog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JFrPM/c9ufbOZcQpI9EU950DSNGM0AtmXIE8OeN2E1I=;
 b=q3Ua2rWnymATU3IRHTah8nhrNkUJzj/P/iHoKc7itgHauq3x+YC1qi3Hn0AeReWGMhyepxjkOScch2aCDzqGgdLCHOEoCDgJrtjigo7hCTuNYlCyuDkoGGUIPhgi20PR7ecrE+tiFjdX2MzG6jkTtF28RDp+IQoO6YElHRTItpc4qEJsxSh/bPV9KtRi0u2ad3Hapq9Hy28GKSai0eTp4pfjkYEZRyIsn1tMHn9d9fQ+NZeC9zLSuzhb2FCXF7GTHqXlXRaBqoxfDpgEFo1upS/KC1h/+f9H+/hLvdjEm/k3WwO339paQET8J1m8RHKb6J0BByifN27BrNm/F7mtsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFrPM/c9ufbOZcQpI9EU950DSNGM0AtmXIE8OeN2E1I=;
 b=rqtb5Wvt3SDhKN7ap1rZXI8Z+pCX/Whm5viephpBxfXmV0uB1NAkiAGTWHJGt0YzYwp+AsmWsrdveIzGfSdEb4nTaeL9YI3VtviP6Donxn7ilJpV0pzzPX7eTG6aYRFUBLUZya2GtfUufxtOMVvOuldHLfLlvb3IXtmTczOdkls6+y/PelIhV1/NKHKG/X0oRDNZ2VJl1D/75VqRvJy1Itcx657yBfRJ551sSVPNlAVPY4P6nD4Cc+Pu3CFR/HpOpDuggmW5dUfTmHVxprwFtm4+u50nq5YzcXwc1IC1Jo7zzBTfVATnbyLdPU4QdCuLwgcT8EgNU9etcZh50EoEHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by DBAPR04MB7352.eurprd04.prod.outlook.com (2603:10a6:10:1a8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 23:09:27 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 23:09:27 +0000
From: Frank.Li@oss.nxp.com
Date: Mon, 21 Sep 2026 19:09:05 -0400
Subject: [PATCH 3/3] async_tx: use dma_async_issue_pending() instead of
 direct callback
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dmaengine_prep_dma_pq-v1-3-9563ed448260@nxp.com>
References: <20260921-dmaengine_prep_dma_pq-v1-0-9563ed448260@nxp.com>
In-Reply-To: <20260921-dmaengine_prep_dma_pq-v1-0-9563ed448260@nxp.com>
To: Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
 Dan Williams <djbw@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, imx@lists.linux.dev, 
 Frank Li <Frank.Li@nxp.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790032148; l=905;
 i=Frank.Li@nxp.com; s=20240130; h=from:subject:message-id;
 bh=L0NgCx9KkNVyVg59oSK+voJbtw8aeOZXkD1Sw5gQD1Q=;
 b=160I2kNg0SvfP1VEuTl94jLIAumxhryJIx0W9NNhgObZIrTRQ+nadoKaFme1JdgJbS5vO2ofD
 QBlGTQ7bUZVALEkOAamPnN3KrQV+qB4/XqtgLIJJ6bEIyRKlQRxRdXj
X-Developer-Key: i=Frank.Li@nxp.com; a=ed25519;
 pk=I0L1sDUfPxpAkRvPKy7MdauTuSENRq+DnA+G4qcS94Q=
X-ClientProxiedBy: PH7P220CA0111.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32d::35) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|DBAPR04MB7352:EE_
X-MS-Office365-Filtering-Correlation-Id: b8eeb21f-6eb1-45cb-adca-08df1835628e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|19092799006|23010399003|376014|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9qf2MUkVhDMJ8k2tGNZSdLZfBsWWLNBN5+1Zxf56HJSEYDn1m8GSV0NVLRXKhmuZ9znUJHSvkr3FWodzr7RkMQjL7YynURit2MfBOLJR+B0TTHImy0clIC8o9cHybMqHPhmoXJnvzBBF1O4U0EWrmrBgDG+ZVU/Bg/LEMJFhxrqFznhMizCyBXBk7EBc5jOhvMLLbh/CZ0K8N2SdrnONQYPObB+hTwM7zLYHu+3EzrOh1EJerLjZjs+zc1HC5Z1okIyhafYvo3b3DTceLb90x13xfYUp+QG6Hl+YM+1Nzm8DBXWzWsmxCB75TQI1GeEjQPyOq5h3NlYXE/f7byigQxRuHk9lBrq9ucB3mMIlmsYh1dkF/tJyObv5Jr+BsBsNmvSEFSEMZoI5MdC001Qx7U1UL3bvLlCkRhli3ZDzx1I8O3IIhrRP3wOw0xjii+Q2NGp1siTQ5pfqMII0CYEIz5Tkg5hy2QE5hz8Zk6ClDZMmzxJ0b38+VsSlbCtcjsg2W7Hwb+IBgAFiIYTSppf67lAR77w/CoJFl4a/Bfoq9tB8gKn7EpD598PEBiIxztZ109eB7WwA8IM4OWHLTV62jrOjFiDxntyo2a++wh50cegZ8vq26MBjMhruvYGRUsH0qKPUdU2iM6lM8NQgQTM/OJMrJFRSFOBqC7GQEjkOrlE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(23010399003)(376014)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGkwMlZtVUVXZThDWGc1aTNpd2craDA0Q0pIMjg0V2llWVRYTXdPRGpXbGhz?=
 =?utf-8?B?VkdwN3VBQmI4REo4YVByRUMwTE9hcldESHkzZmJkdi9HUkhiY2lpa0V0Ly8r?=
 =?utf-8?B?NDZhaDd3ZHVXZm9jUU9jRVN6WVF1MzF4VWhFTE1JMGsvWEJzRTVLMVp3MUt3?=
 =?utf-8?B?bnF3cmZpSWlHeVNlUzROMGRDOWk1L0I0T0hwYkJPR0hYQW1wenpsN2p5UU5w?=
 =?utf-8?B?VmQ5c3JkSmY3OVBSL2cwNGcrRmhsRUdwV2hoMUtaeHZpTWU1OFV5UW4wOVdZ?=
 =?utf-8?B?RVVFeHUxNGNNcEtsRXptNUo4bFVwaG0yTlBzcklxbG8zNTZ6SkVXU09HNnZw?=
 =?utf-8?B?ZUlNVFlmZzFONTZNdGhiOHY1RVBYMFhHMVcrR1FJbndMWWlDY3dPK2d6WC8r?=
 =?utf-8?B?SHNERkRQS2tiUHNQNjBwNFVUYVhUbTlYckZBcllpTWVCeEVzTm9HeHM5L3pG?=
 =?utf-8?B?R1N0bFBkVmplNmY4Mjg2TlRiQnpnUENUb3NkU2FRQllCWi9KaVRTZWRRU0Jo?=
 =?utf-8?B?dHNxVDArYXlWYWZKYzdhenkrLzEwRTVNbDh2V0J1d29lditmazA3TnZZRGhy?=
 =?utf-8?B?UVN6UnNYek05ZklsVWIzUFNuWTNQVGlTVTlLRlBXUXJVWnJlbXZBVWVRdnd0?=
 =?utf-8?B?N1hPdzE3dENEOXFWbkhpQm5lVGtkb3pCNUJKWUlQYWRZU3dQalNzajBJNk1H?=
 =?utf-8?B?a2xRdHNPclpqSVhxTklIN05GN2xFSGlHOS9yQ1VVNDJrUVl1bHVMV3RFbnpY?=
 =?utf-8?B?U2crajhGSGwwOFRSR1Z4NmxkRXhWNTQzeUJQTGFoM0k2Uk5JRU1vZUFEd3dh?=
 =?utf-8?B?MG5MZHptVUREWmhXYVdBTUdzVFE0V0VPOFIyMWZVcnBpY2lKRGlYV21ZdU5L?=
 =?utf-8?B?NTVsNXNoSlplSUdINnlxR0J0YkNHZ2lHY01KU3V4TXhFdnBWUU5odEJsTVhT?=
 =?utf-8?B?WTUzYVdMeG92QnNPMG9idFFtNjVhS250bVp0NWpxbFArWjFIc3A5V2R4ME15?=
 =?utf-8?B?ZjBOTW1VR3IyVmUvOFNZaldjWlhNN1RCSWxRSk9aY0lRRm1NdlJGRnZkeWw1?=
 =?utf-8?B?N0FKQ0NhSmNEVUVpd0JyUVBSR0tWVEMzS3JBOEI3ak90WDFYRjQySVFESEMw?=
 =?utf-8?B?L25Cd3BlMzNCZzBkZUVvamRGaTNoZzhhRUlsTEY1UWhRekZmc0pEVzRSZVdJ?=
 =?utf-8?B?UW5sU0xYMURhS2NvZ2JrQzNVT0ljNWFxK2ZucDllY29xQjR6Qm43WUl5WmRF?=
 =?utf-8?B?UTdTbGU5U3hiN2lnNGxMaStKalVBY1FPTHJ6RlFxejB6OUpHWVRYZ2ZhemxO?=
 =?utf-8?B?bUlvSFZYRUVIMFBiTG5xYmdQVllpcGlBSk1mUHNxTXdETXNlOThmWjJQYlJz?=
 =?utf-8?B?bmkyemZNMDZ4V3RoRmE2ZUZoMnNaNFdxNWdwWTQzQ3dyaWh6dWRwME9MdThu?=
 =?utf-8?B?M2xDVGtCVVlmTFhlekQ5V05qM0tKaWNObUlOdGVhMndlVlhzd1BLOEdWTlZY?=
 =?utf-8?B?TEFsaHhmZjlPNDcvaFVXdzZVdjh1dUpHMENzQW1ocFZmSWxCRTUrMWZPWEF5?=
 =?utf-8?B?dUw1ejJmZnpxdm5OY1VUVEltQVdKaUdldWREc1BEc3BORk83czhzZmlHRTFn?=
 =?utf-8?B?TTltekwxdDhyOEowL0ZTWUxaVFZBZjgreGJ0NFg5eHJqckpFNXVJMUJrRWpk?=
 =?utf-8?B?ZExDUTRmbEduREpoV0M2UXIwSDZCU2pIRCs0elhZRCtCQlZCc3dsSTZpMjd1?=
 =?utf-8?B?ZXAwcnh0ejVjVlgrdlZReTlVOGJjM25zc1d6U1RiRUVoQmdQMFJ2ZEdUQjll?=
 =?utf-8?B?RGw2S3NDcXZ0ZjVKNHI0cDljQitHVTJCeHE3ZUkwZU1zY0lDS01tWlBGZGpH?=
 =?utf-8?B?eFVnNVZKam9xTTEvRy9xU0xtbnpXMktxeUdrMXE5UDBWLzMrVjRLTXFuVG9M?=
 =?utf-8?B?eVpiNWJUOXd6RDlBOGlVNzEveFl4ajNtZTNlRjZJQ0N2UEZJcmk2YU92M1Rz?=
 =?utf-8?B?QlFWQk9vZGpaTGs3WXl0cTJKN1pmVDFGQU8zeVZKQnFZTUZpczRlamlMbDlX?=
 =?utf-8?B?UTV6VnVtU2NhMWwwTE5TOW9INVJuM1VqbXhmZnRtajlILzRFaHV4WU1ZaWts?=
 =?utf-8?B?RmthOW4rY1YxS0JobThkODJzK0hxcnFTRnVQWXlVVmx0TzV6RnJyZ3cxUmht?=
 =?utf-8?B?THpZVkkvTXhGU3lpdVVTWmVTTjlCcUlkdGErMGluV01UcXpSK2VsbUFPbjVj?=
 =?utf-8?B?TzZDeWpKSmswMkxnZElqWEp3bVlmckNLWUlhTkRIViswbGd3ZStZNWlhaFFC?=
 =?utf-8?B?MERXQVp3OG9xdE9oWnpOS3d6UCtJR3JmN3FKaXI0VlBuNW9acTVhWU9qNVpR?=
 =?utf-8?Q?iIl3kMg3kjXVK/f3FiBufNv+cp4XGsFSdMxx/?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8eeb21f-6eb1-45cb-adca-08df1835628e
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 23:09:27.7046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YJtGrGVTXVh2XLwby9WF1dO0g4WpfYB+OpGKorLHs/D/UPOnrovrhF7J1xhzMvAEX0aAK9scbCtD/noLgRvZOiAsJ7BGpGTs6kDv6jU4NKf3YSZ12d6wPpMkPUSIQwv3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7352

From: Frank Li <Frank.Li@nxp.com>

Replace direct device_issue_pending() callback invocation in
async_tx_issue_pending() with the dma_async_issue_pending() wrapper API.

Assisted-by: LLM
Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 include/linux/async_tx.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

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

