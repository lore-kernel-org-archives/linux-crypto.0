Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011006.outbound.protection.outlook.com [52.101.70.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDAB3BD65D;
	Thu, 17 Sep 2026 19:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671742; cv=fail; b=mocEhPWxkqEEkSuWlxHF/CyJtQT+fMD/6XltqLaUFIKinzaUvujtFiiL4H3OmB9s40UpaqRn87QHmZLgEinm56Eq7JqaZS9AcVOq7dfGlOBU0RizdNe0dPmrP89aTjN7Pmcb4HLaS9FXDP2F8ex/ayfqapAR85ONL4+SArMNF3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671742; c=relaxed/simple;
	bh=As73Vch8K93pewfxO/IHzVDuH31BgIobaCBbgwOdtrU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Z/XuZMqR7ufUMw/H+6SZPQLO/jzEflr6CDeXdD0WaKQfu4pd4+xRaC/Af0sIPqR797ZxJtnHhPw5FaBIAWcRoRmZrswbp3VCnAep8zIqmc93mvnJ5i+rnB77yD7h7zzwRcWddndntdPT6AsXFbzJ0izpKuzv1GMFfcUYLT5M+P4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=cpzAITNq; arc=fail smtp.client-ip=52.101.70.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="cpzAITNq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pOSrK1TtrcOcGhCEQbpgCjT+jc9sf4fl4m/EvZJXIk2Mt5355wNMWxsFIsHA/hkC9Mv6LKEpklxKCMJtA8S5aUOKvCKR9XUPthWGV2o4fBThFjY5scA/eAxayFwRpuCDV18SESwtBggHML+/jaTMdIuFo7MR1vldFVIsZxedY0LbBVNTELhZRWxbFrOq3YiqBLESKWY2C+UsgUd6QX3tuch0G0uBOxdNs4i/rmpI3MpG1xx59+Ig5kq7qZBttdKA186/EUKmvsqKa5X5BfigSsKrZ57qOFDucJnVj3TomE03EsAz8abvsHPti7ksKAgJLdFsFtXRtR0cWvmt/s8P8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n3oHMCD8hDoqEUo6GTw42JKIWlE9+aeqoh+RGMCzIkQ=;
 b=W2yzG07sui21Ln3WiPzHZnekaw/G+GMAd3j/JsRPYFIYz9/Mq071aW6uidv+pPkW8z7i6JBmmlbq1I3vFU70LtkRvpwwdkkLndy5IEWrjZfOG/TnTMa8TEqQ75CyVK/M690tnM5DBehTzONK5UoFFqkjQU7y/Ah3RHBPJqvLzEafRE/gKxTs7S3y7GkjUydoPRX6JHIbY5tik//0XtkanDGueDjXohUhe496vp0Z83jBbDK9gOOFQtzFlhsL59R4jYf2CVxESmO3S2EiJ78H+rYVGGSsXNNUHMm5RVqP78N4u0zqon4R/gi/fuFecMlNAOR5FBcVY+00LjDSiwEo8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3oHMCD8hDoqEUo6GTw42JKIWlE9+aeqoh+RGMCzIkQ=;
 b=cpzAITNqFej517kWrpWp42Gp3M4u9Q3BBKct8feghagBMVtahSfNbPWNJBB1uSZrCU7uu6Vg8SsAyHw9uHhdFr3Q54G8P/73LHybjqStdrzPnKIJtBFNdRrJSVeVGO+U98/HQhNt3hVAW3cfju43ACF1SqSEVYy9qngHlSpUTfkd4eiwiY46uKV1zZ4UFiSwtRCsUYkp+H+Yy8aG4JdIIMFN6wnpmP/sIDABpfFSuO5TnW3CY3LBFFFPcUXlD6hAWEv/0YNVIzXwW2xRPFRta8By/TOMA71eBeX8ij6CdrWoeZ2I9FeiuPw51JNZghQL/Dp9ihh8ixi1dgcmod1Dzg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by AS1PR04MB9698.eurprd04.prod.outlook.com (2603:10a6:20b:481::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.16; Thu, 17 Sep
 2026 19:02:17 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0406.012; Thu, 17 Sep 2026
 19:02:17 +0000
From: Frank.Li@oss.nxp.com
To: Dan Williams <djbw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Frank Li <Frank.Li@nxp.com>,
	linux-crypto@vger.kernel.org (open list:CRYPTO API),
	linux-kernel@vger.kernel.org (open list)
Cc: imx@lists.linux.dev,
	vkoul@kernel.org
Subject: [PATCH 1/1] async_tx: replace direct ->device_prep*() calls with standard DMA engine API
Date: Thu, 17 Sep 2026 15:02:00 -0400
Message-ID: <20260917190204.1187377-1-Frank.Li@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0047.namprd07.prod.outlook.com
 (2603:10b6:510:e::22) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|AS1PR04MB9698:EE_
X-MS-Office365-Filtering-Correlation-Id: 17bc04c7-819a-4fcf-df98-08df14ee3184
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|366016|376014|23010399003|1800799024|10067099003|56012099006|11063799006|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	nvpmrQ0YziqIdjSIE1RsM0jEai0m96EumeVENWEhjq7wT1ZHUJlYWzuSJcnPUcXjyjYG8GRA71DKsz6PrGJ8GT64fahsjXed5NMv9AMkd0KT0KpDhCD138kQVJlw1diTxH2SgMXSLaTuTuyHon/rJdQr5coqqXyTMUT72/vkWHSSTQZuz3N67l2aGv1QV6UlBdi9RrdwAbjRkj1tL8kybF23p2cY0N6SlwgK+gOtiXDKvNns6jJmSmHTy+H/sbE13lEb66hzZs690E7/NU6LUE0Mi4mF411fWnxFnEUfzZKGfOu80LyKSVzWhMcm71g4IrA/MuNuxOqgkdk4njMUs8NMhHd9HMNjSTb20sVwd+FgOvyeKMs76xIzMscCPPqmYDcwKmPYHXCtBPn2QVtWIyWSZwdR/+Qo8PjYNKw9KqscXeSa0EFDB9PT1ITdWYQO/9YV0r0Ol2x+mWummvXbrYYbr9X9TLZqxvN85VTqS3Vusjc02Zr0//kNBovPeClrS59ldmHvwd25rguyYDIh/hNFPiZi7LovhYzkUdRFFPxvbz66EK2N+HsRvlq1evL94ln+UZETkBOqb/IzOLOuxGv3nU3+B8r3K2iVoYRL+2yOAuiCl0HWS5HEGfhLHy6HP7EQ09lVc+5idmYHevp2xG6wWq3LMxRHdYmeniYQ3PM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(376014)(23010399003)(1800799024)(10067099003)(56012099006)(11063799006)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oT8aKZdU0b3cK3iY4Nl8o8bOlJ/CYxiyPWRPadHJJcJKLGxlk1K0lyAsDBce?=
 =?us-ascii?Q?fGV9SZY1cej3+9/jcZOHR1MCRImvckrl7NoIg4n/4EgTWuqwSOt68I3wbVKq?=
 =?us-ascii?Q?NVYTBKaPx30fqcAXh1XtxbratfJjorBbtGV1f+qclm5PBMQzS8W7s9nYSLvW?=
 =?us-ascii?Q?XX9eqzVteMgQMBfC00hvQQpQz1Fm3WjT3CKY6ZrDvzCLy0OqudwNPCKHJIhG?=
 =?us-ascii?Q?+MGEoWry39xChwFz5/7PSNCcQmQpxOUX9b0UFhDXjFSxJi1CLtpi5GOtvCQ9?=
 =?us-ascii?Q?b4vsppQMoODeX7ii568ae1ppcdZM110tFIQfs0DxchouPtSse8ZKLq7O1zYH?=
 =?us-ascii?Q?TMWVm4R1ariPCBfQXv+c34rAW47X4IJVtEU/mmooF1/dfM/hlqn70W8HMqXf?=
 =?us-ascii?Q?yYHsE2EhADup1otxLEWxS4lBjcnWeoIVWb8njshIlV1eYyhxITz+OOANZoMN?=
 =?us-ascii?Q?tYnpdStSwElFo61L+6fjr1p8rmuU3IeCk32pIJu3Cgibh0TDMh22757l3tSo?=
 =?us-ascii?Q?Btydnn+rinB6NVjBTmc4tFk6KXyL0USFeS8TUo25BmT85odPaGUSF4aKwOyW?=
 =?us-ascii?Q?k/E75l41kdaZKAHEX1lHiELls+JzMZINX73/Gd62Eo0Oj+F+9VOnZCLs2awt?=
 =?us-ascii?Q?lwityvR0nD2+Te/XqiTRvIlbpma3QP8nT3EmPTrkAiqrW6MqW1Kn3EIFTu16?=
 =?us-ascii?Q?hjQWqtCa+td8wyEXAMbyXzQDGDlQrKpdLe9YnhRfO/H6xtDOqhsBlHpO/tb3?=
 =?us-ascii?Q?q1dpATX8CEJRZyWwfDxhFW8el//+UHjzm9f9fvU+S/cgQ6ncF3GyJVrMKrik?=
 =?us-ascii?Q?lqLd26Aud/YDLaDNYOzGezlTYXFRQhh+wtv2gvFh8uLK+7MaT4hlzRjVrWgj?=
 =?us-ascii?Q?8hWecq7SaV6NZTabpPKrIwRzBLYblONkatLg2pMjDiduvLSDaP0pyQxQoJyt?=
 =?us-ascii?Q?7SzbVNIG9Z1EYgsJZ0um3e8WQ1pqpX2Yn0WT6pryJJ0aFWtfQeSuNIqZdZ3R?=
 =?us-ascii?Q?tHk3hMZomj/vhYP35vwxIqiXIqCl54i1nRbUkLwHurmZn6eha+OAcMWzECKa?=
 =?us-ascii?Q?oQoLn7gK0alMj8XFPGHbNTwJqKRyHv6GBmJ49YnzL0hCV+OPxnucmJUnCJe4?=
 =?us-ascii?Q?2whzyXgwKkiracAbjR5lLzohtMPBlrvrznPmKlS6mktE1w5cTSDOqLNaU/l7?=
 =?us-ascii?Q?VNNjYUE56NhPC7quHUtdeU3v4eobzCyRNibK453yjq3Ye573eMT1ritRzb44?=
 =?us-ascii?Q?EtB1DtcEZCtUVz+wSa1FG26VsL/IiSqztkt0OJHNEbVZLUtwJEaPDj5Tde4C?=
 =?us-ascii?Q?lQktwLqJPvzT+NGaWkbzWIIPYYRdqpCKVeSyUShz+2UzKGVDhLZqEljvvB1c?=
 =?us-ascii?Q?d80k1P9W0+rt3w0yD4uwzmsnku8GFszC2MKxk1/bKIPCfhuHBho1zirNtf3D?=
 =?us-ascii?Q?FB0d5sL6HwyC+Vlcy28mT+WTra4r8y0L/UKD9eQk7/fZ+OZevPyIYop0p6Yg?=
 =?us-ascii?Q?hJeFbeF3ahy4jLhjjaM4fqLURYqSzXAc3aXWwK6tlf7T5iYmvODbgVDEvBir?=
 =?us-ascii?Q?6Ny7W+9Z8uERx/rrji8K4HiPc/TFy0dFIdDJ2K62W/J7zvb5tT+GarvC6LcK?=
 =?us-ascii?Q?9RkPMX/RwB/3J9FOuXwIF9/Sto8BAQVvgXjDRIJwQXnKEdWQd9/xSYV8OnsE?=
 =?us-ascii?Q?GCPsarCubY8HqFkeOlgGuWdD4G6xNSii8Un0ZFGRu/E3aOQAKaC/jEUqIG/i?=
 =?us-ascii?Q?r2n/3O7h9EC0qvEU6j++aykx5qfgoTGeISfRzpGiafcLkUIGm3q/?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17bc04c7-819a-4fcf-df98-08df14ee3184
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 19:02:17.7244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5PnnQdkgOO7HqMXM4Eodt01YSmYWHp17VdgsG09gUEVAzm4Y4n2r/hel9zAKxZ9lsGgclelhqwR8lmTpmTPPNTgJx5glIkeEtVoCytfvVP6hfascA9CioKKHC6OYExv1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9698

From: Frank Li <Frank.Li@nxp.com>

DMA engine consumers must not call the channel's device_prep_*() function
pointers directly. Use the standard dmaengine wrapper APIs instead.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
---
 crypto/async_tx/async_memcpy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
-- 
2.43.0

