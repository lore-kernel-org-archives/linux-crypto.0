Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.95
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793691195;
	b=JoOIEE9rd6ixX6fK42/LBJlBWHQKagWZKBSIo4mEteJhrNq+UTnkGXD13gJzGIV2bbzb
	 bhroP7rLyorPAkGY9OQUAY2zv+6l1UWSJnmntPNCanUQKNJpmi/slXTno4ZzQhFdrPUCg
	 HZVEVUMdY7PWwYmzbzqHdvcKwJ99MnDe7mIGYddVkXztpJZM1gl5W9DKgN0NDMCIZiZAX
	 CzW6Kv3ajoPShMDjotT6YIzlsbl6/OWDd5mlHWo9eYLWlP3ZiiPFw7g5AMNUgELfObNTd
	 FL1TEhznzEakC7pozD7hUZmlhjZ/i0nDGc3cI7m9oQFfQ1ahC/CfaSEmfuXfhtSwAZg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793691195;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=1T6siZhV6j4Hm4rADDFF2pxEwdUIGPoSsTAaLAGuBHY=;
	b=4iNYjZH9LXW3/M8t0+SAAXZMJ7vMl2URyuvWsjePrV1UQyPafTgYNvSHV12bsCIJwTcM
	 64Mkvb8AhLD3VOBAh1cCPfOBu2ftGJqFvJ2vuSeYiykm/vvGgTzth+E+PyXlWqTMfzPRD
	 z7+DDLiT8ULCwH1AW/CUjuP0k9hLeuxCA9d8vVnhDWXGuj79EGe9cHpN3jjCxuFNFAL0z
	 BwEhL5YqftTMC6Zo9mZShcA/4Yfc8EMADcVoauBD/NwKc+68zI7CpxSA7eX2hSVsUAS66
	 s0HefqVmi3N0xc8u+8FcWKN0aVPHb6S3EqYvwqwPjV+sj1qgeBXgPgfa5KaMTfca92A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.95
Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2095.outbound.protection.partner.outlook.cn [139.219.146.95])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAED6606A335;
	Tue,  3 Nov 2026 07:33:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAED6606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgiHCP+0cRxtfOMKL+FGxVxFVJcwfv4FrfmnrkootIjEUiEu10o6Bil0j5vBdnv+bSbTm0abo02Gk++TI2CHgvmBSbaFxwoCD8fd9bgsPCaIajwPoq7EqcF9ib+mmvxDg9PUkls+8Xd4dmZ9lqZOrCuS6doBrUOOULqWCRet4tZT8rjKCdHUILBJTP4kuRSv6lHDnUsbjqrIvrTzm2NyNGjYyIud5lFQKrZnqhNHX5Bu2zs7Wgy1SkgoFTQ7bgsvw3E9xfIsimzH2HhLCGaOXdpjHh4Af22zBD1o173UhR1/QdumDFg1+BEnPjG93xnu36IDSRB3Oy/e/ktkv70qBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1T6siZhV6j4Hm4rADDFF2pxEwdUIGPoSsTAaLAGuBHY=;
 b=bXjDXkEjxpQnZ9PdAb/iRo1M/IVbY5C3I/HODkI0z09UAdMqX4GzTtr3fqbueAzxnao+pUw8FuVVyX1fMXWEEG0f8Aqdky555HQsjspPEh1XXL65NBUASX5W5caE3vZZSsLU39f3/LQASqPbLLezotbP2/cbuMRUbAIJVKFyQVsJpR495g7h7YAwE6Mk0ZM4SIbGTkKt5UctOJQ1k146FKY8F3/siXNsUNCdmhYCNDfOaR3Vl7PLQYOApddPa+reZD10B9K3h2DzUQwGxXecb2mce9SjRoOTWuVwM3ChiD3jWt0wYGaYbXJgk0TikM9Xh/jjADJ5AFwCtW03RtLSuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB0999.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 07:33:01 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 07:33:01 +0000
From: "lianfeng.ouyang" <lianfeng.ouyang@starfivetech.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
Subject: [PATCH v11 3/6] hwrng: starfive - move the SEU reseed out of the interrupt handler
Date: Tue,  3 Nov 2026 15:32:49 +0800
Message-Id: <20261103073252.3028-4-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103073252.3028-1-lianfeng.ouyang@starfivetech.com>
References: <20261103073252.3028-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: NT0PR01CA0008.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510::13) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB0999:EE_
X-MS-Office365-Filtering-Correlation-Id: e876acd6-4c58-42fa-76b0-08df397cb0f0
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|1800799024|23010399003|366016|10067099003|18002099003|261102123227099003|22082099003|56012099006|5023799004|261022113327099003|261026121527099003|261022105027099003|261022115727099003|261026135527099003|261026130827099003|261026140227099003|261022075727099003|261009223027099003|261009221227099003|261021133027099003|261028144727099003|261021130227099003|38350700014|261021135927099003|261021121427099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	NbxBMAq/FxF8z0wF5SJWruj74rMN6L1OgNP+enKnPbX/Zsmv4bQHLdffsqTjmAkhIRT36h/e0vAGKL5HmkejFBAhUwWXwR8eVNPaYtBK6moAxRuI7nJ2GVSjx09WsFrPwFHJuGjeAAcM+Ugm2uAZg7lDIfvXgUxGheK62LB5vjaciaJjBsEAYqw+83IbDdiuvcGkHOt7G2flf5U+42cU/Kkf6WYvQLF6BnQ1C7k/w87wKQWkt9J9iQLy3wmtSCa/JNy7dks4lz7SnEi98o27uDVNP9WE89gpPt43mFsjO4OPs6B8cTdHv6VjPBlIPGQlYZzv+/geM6fk/VQQs86PTQv8xxn/SAux6rJLBbvIyqeUJr0HWEOfH5xzs+3BNy30/TZFkpGFGy0G87iWMuQvINK8vnun5sGXGUo5UYscjAar2Y5lWHcG2jTWxTiBj+3xIMLA0gM9hS6d3MsiWuYr8qHl79VtezwI6DcINPCIVNRzckYPdWDJToMUuQR8/rwRns2cQ1OnSgBLiGX7Mz07iaE+ChKcYeosffXzMGOOKC9mSqAkeCWB+y3081xnlk4c
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(1800799024)(23010399003)(366016)(10067099003)(18002099003)(261102123227099003)(22082099003)(56012099006)(5023799004)(261022113327099003)(261026121527099003)(261022105027099003)(261022115727099003)(261026135527099003)(261026130827099003)(261026140227099003)(261022075727099003)(261009223027099003)(261009221227099003)(261021133027099003)(261028144727099003)(261021130227099003)(38350700014)(261021135927099003)(261021121427099003)(261021123027099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?syGR53g2YixM6MpGVZ48F2Qr2Uj+4L1cyBRF8CUTBuEjVX4jbdV/oQW2vvMm?=
 =?us-ascii?Q?TgwkWHzkxmnf8U3lLe18fv7r6x4eSNxBW791v7zMhE9H+mu4qjpUxe1j63U3?=
 =?us-ascii?Q?BXH4un3fQgFCM/9SSNiYNDIEfWmRaXgdVxvPHyBQEBn+CEsdiq+JGFq4upg1?=
 =?us-ascii?Q?5r5eXkuLhomibv2SGyfXd7htdbY9Ph6JxDQ6iVNRMUXzLGOlBb/V2WYHY0sA?=
 =?us-ascii?Q?xeTvGDeiMsEHcfmys4ihtnXwqqXyNNJkLHmWAwZyUths8fGNTvr32hAUcyPP?=
 =?us-ascii?Q?nbD9MeOdNst1dO8WPz4gLUM0+iSM4nzA6+qnFusEbjMs/qOwwp72zJMSy5Pn?=
 =?us-ascii?Q?vediCjypFfKOZqOwwq9mb6U81fOUDDPHz7q0MXk3oMJ9VOHn24Lk+w9xU7Na?=
 =?us-ascii?Q?UbqoGCZkg4rJKd4Tt29nnSwk7ENIBBUTH4zB7kj6dimOH4AfgwXeZDLfXYwz?=
 =?us-ascii?Q?ap/RudP4bhuNim7vFon2FXIxnguxoDUOQ3dpkA/BLWd4jmo8sVYstKkzP0MU?=
 =?us-ascii?Q?tAv6bgSooGktFbvvJNGmtuF4iOjeC+1tqWdzslHjQH/SBDFCCAmFvJ3BKGE5?=
 =?us-ascii?Q?0XfHyw6O8UP2v6lBtAGhrqV7tJgsTEXYtgBv1misR6vNFG4bjfSUgMZWARca?=
 =?us-ascii?Q?49dvnR97SG/Y2FEAoVggSR/zmzBBQPQVZUVHylDibHS2O/artB/aKOoYZc4Z?=
 =?us-ascii?Q?s+YZme32ytWszGMzHUEyRQk0PR+02g2CuBfW12m6iKzGD4DTzMJnoHk8EDf0?=
 =?us-ascii?Q?ODBToqnP7K+2ej04rZAGaQy/rR9dr+18kfhnTkEKo9FqeWDkj2QQWGuE+3Nz?=
 =?us-ascii?Q?5y11Hvs0iiuVAetFYOyyjOCITY+e4J0LkO3AhEQ7bD7rkDYGD/+zYxmVl4cJ?=
 =?us-ascii?Q?Oa0T92Z3KkNlROl/Obq5q7gbmIF4lwiYDMu4HriiODtdTffKKklVowjJgW/2?=
 =?us-ascii?Q?wh7IuystjeNPv5xC5g4kuz/qydp7uEPWL88BINbO7CPoWCpgDkMNFOWzsF8H?=
 =?us-ascii?Q?rBzdJOHySqpKxTZdn9PGgwLiErkglbFaYTAMUBuuro+VXNhenLjOOkqhNuri?=
 =?us-ascii?Q?IEayEs46KJci9c2k/0NvJtzJi3ofekCilp3qM8jeD/qYAMFzH8sT3/Gg6FMe?=
 =?us-ascii?Q?zzNUAZq+R5lqpRIzvp9NdyGOEMJatMK8dDX0iI0lMIGD4NhrZa1ewNTOxMDF?=
 =?us-ascii?Q?pzfiq6cIonI8tnyv9FBBKb9uJkshFfzIOCHjSUjAzTsSQpi21bblrfgG3N/p?=
 =?us-ascii?Q?0AA8QHH2QZH+ktFUDPVTty5EEQrjMzDMH9kwIL3bLahtFRfDKNS+XWPZTwY5?=
 =?us-ascii?Q?vGYpIhZ1DMbB5uAmlFrcYl9ORPRNMDv8Tmdsava5KKPWefyRvtxOBBBSamKE?=
 =?us-ascii?Q?4yS6xPIgG8oNyMzvUORoyICJO5yl3mUebAaL/jnppSEwmC/x1EEN7zefogsv?=
 =?us-ascii?Q?sWAxuNKqyUeBHel8w75vRPAztfa1MGYPPKnr3+h/EUKswvwlWXOD7ZJqR/48?=
 =?us-ascii?Q?QBWCD4tjyOtr6yd3DJmxYaWwS7oEeF0a2WOXW8oaY6897egIiHMArXG47u3I?=
 =?us-ascii?Q?j/5HU07OdofeGadGUo+bFtHQNHbFy9IkcJ8dGMcLUCCgq4smLEQaWkntXoqF?=
 =?us-ascii?Q?lr/+cQdyp8WFtdWyS6lXvTfbM6XHZ2XvSPEN0DohNSbsvC9rsszsRCkRHdbg?=
 =?us-ascii?Q?YX2DaWWGhRymtl6tPWlEejIEVXT57zUFVK9AauJNk/izHr4p4wokYRnTWzXO?=
 =?us-ascii?Q?y1iGkkTK1wiHGlLVW+xaIvBvOPV0YGVDl0BGOuU1mMVYC56IkdUc?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e876acd6-4c58-42fa-76b0-08df397cb0f0
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 07:33:01.8304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: khiMef0nvcn1u8QxMgD6/P50sQN+TzY2BSSA55CUlFfq6YNW3IUPJ91e1UiNGf8nnT6hDdrUGDe2XIlgrW8QaqJPEMTpVt1BtdxaSjwOH/n1MqlhF2Pn+DxGONb+nTVT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB0999

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

When the hardware reports an LFSR lockup (a single event upset), the
interrupt handler writes the reseed command straight into the CTRL
register. The spinlock only serialises that register write: nothing
stops it from racing with a command ->read() has just issued, nothing
waits for the reseed to complete before the next command is issued, and
a sample taken from a locked up generator is handed out as random data.
The 40us timeout used for wait == 0 also rounds up to a jiffy and so is
not what it claims to be.

Rework the command handling around a mutex that serialises complete
command sequences instead:

 - starfive_trng_cmd() checks that the hardware is idle before issuing
   a command and takes an explicit timeout. A command that timed out
   may still raise its completion interrupt later, after the next
   command has been issued, so the next command acks RAND_RDY and
   SEED_DONE in ISTAT (write-1-to-clear) and synchronises with the
   interrupt handler before it re-arms its completion. A late interrupt
   then finds no status and cannot complete the wrong command. On
   timeout it synchronises with the handler once more, so that a
   completion that has already been signalled is not reported as a
   timeout. A SEED_DONE raised by a reseed that the hardware starts on
   its own (autoreq/autoage) still cannot be told apart from one for a
   host-issued reseed, but the next command waits for the reseed to
   finish either way.

 - The interrupt handler only records a lockup in trng->need_reseed and
   queues a work item which performs the reseed under the mutex.
   starfive_trng_irq_clear() does the same for a lockup it clears while
   the device is initialised, so that one observed across
   suspend/resume is not lost. Once the device is no longer
   initialised it leaves the work alone: ->init() reseeds anyway, and
   the suspend that runs from ->cleanup() and from the runtime PM
   teardown on unbind would otherwise queue the work after it has been
   cancelled, and it could then run after the driver data is freed.

 - ->read() reseeds before sampling when a lockup is pending, and
   retries once when the lockup is reported together with RAND_RDY.
   Non-blocking readers return no data instead and make sure the work
   is queued, so they cannot stall when the lockup was observed outside
   the interrupt handler or a previous reseed attempt failed.

 - The interrupt is requested with IRQF_NO_AUTOEN and is only enabled
   between ->init() and ->cleanup(). trng->initialized tracks that
   state: the hwrng core may call ->init() again without an intervening
   ->cleanup() when the device is deselected and quickly reselected,
   and it calls ->cleanup() after a failed ->init(), so neither may
   enable or disable the line a second time.

 - The suspend callback masks the interrupts, and asserts the reset
   while the device is not initialised; resume re-enables the
   interrupts when it is.

Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
---
 drivers/char/hw_random/jh7110-trng.c | 361 ++++++++++++++++++++-------
 1 file changed, 270 insertions(+), 91 deletions(-)

diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_random/jh7110-trng.c
index 17932cc6d7aa..e370a49bba83 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -8,18 +8,22 @@
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
+#include <linux/devm-helpers.h>
 #include <linux/err.h>
 #include <linux/hw_random.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
+#include <linux/lockdep.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/random.h>
 #include <linux/reset.h>
+#include <linux/workqueue.h>

 /* trng register offset */
 #define STARFIVE_CTRL			0x00
@@ -78,7 +82,14 @@
 #define STARFIVE_ISTAT_SEED_DONE	BIT(1)
 #define STARFIVE_ISTAT_LFSR_LOCKUP	BIT(4)

+#define STARFIVE_ISTAT_ALL		(STARFIVE_ISTAT_RAND_RDY | \
+					 STARFIVE_ISTAT_SEED_DONE | \
+					 STARFIVE_ISTAT_LFSR_LOCKUP)
+
 #define STARFIVE_RAND_LEN		sizeof(u32)
+#define STARFIVE_RANDRESEED_TIMEOUT_MS	50
+#define STARFIVE_RANDGEN_TIMEOUT_MS	20
+#define STARFIVE_RANDGEN_NOWAIT_TIMEOUT	1

 #define to_trng(p)			container_of(p, struct starfive_trng, rng)

@@ -95,21 +106,29 @@ enum mode {
 struct starfive_trng {
 	struct device		*dev;
 	void __iomem		*base;
+	int			irq;
 	struct clk		*hclk;
 	struct clk		*ahb;
 	struct reset_control	*rst;
 	struct hwrng		rng;
 	struct completion	random_done;
 	struct completion	reseed_done;
+	struct work_struct	work;
 	u32			mode;
 	u32			mission;
 	u32			reseed;
+	bool			need_reseed;
+	bool			initialized;
 	bool			clk_on;
 	bool			rst_deassert;
-	/* protects against concurrent write to ctrl register */
-	spinlock_t		write_lock;
+	struct mutex		lock; /* protect trng cmd seq */
 };

+static inline struct starfive_trng *work_to_trng(struct work_struct *work)
+{
+	return container_of(work, struct starfive_trng, work);
+}
+
 static u16 autoreq;
 module_param(autoreq, ushort, 0);
 MODULE_PARM_DESC(autoreq, "Auto-reseeding after random number requests by host reaches specified counter:\n"
@@ -122,22 +141,38 @@ MODULE_PARM_DESC(autoage, "Auto-reseeding after specified timer countdowns to 0:
 				" 0 - disable timer\n"
 				" other - reload value for internal timer");

-static inline int starfive_trng_wait_idle(struct starfive_trng *trng)
+static bool starfive_trng_idle(struct starfive_trng *trng, bool wait)
 {
-	u32 stat;
+	u32 stat, busy = STARFIVE_STAT_RAND_GENERATING | STARFIVE_STAT_RAND_SEEDING;

-	return readl_relaxed_poll_timeout(trng->base + STARFIVE_STAT, stat,
-					  !(stat & (STARFIVE_STAT_RAND_GENERATING |
-						    STARFIVE_STAT_RAND_SEEDING)),
-					  10, 100000);
+	if (!wait)
+		return !(readl_relaxed(trng->base + STARFIVE_STAT) & busy);
+
+	return !readl_relaxed_poll_timeout(trng->base + STARFIVE_STAT, stat,
+					   !(stat & busy),
+					   10, 100000);
 }

-static inline void starfive_trng_irq_mask_clear(struct starfive_trng *trng)
+/*
+ * Record a pending LFSR lockup and make sure it gets serviced. queue_work()
+ * is a no-op while the work is already pending, so this is safe to call
+ * from any context that notices the lockup.
+ */
+static void starfive_trng_request_reseed(struct starfive_trng *trng)
 {
-	/* clear register: ISTAT */
-	u32 data = readl(trng->base + STARFIVE_ISTAT);
+	WRITE_ONCE(trng->need_reseed, true);
+	queue_work(system_freezable_wq, &trng->work);
+}
+
+static void starfive_trng_irq_clear(struct starfive_trng *trng)
+{
+	u32 istat = readl(trng->base + STARFIVE_ISTAT);
+
+	/* Do not lose an LFSR lockup that has not been serviced yet. */
+	if ((istat & STARFIVE_ISTAT_LFSR_LOCKUP) && trng->initialized)
+		starfive_trng_request_reseed(trng);

-	writel(data, trng->base + STARFIVE_ISTAT);
+	writel(istat, trng->base + STARFIVE_ISTAT);
 }

 static int starfive_trng_power_on(struct starfive_trng *trng)
@@ -194,42 +229,80 @@ static void starfive_trng_power_off_action(void *data)
 	starfive_trng_power_off(data, true);
 }

-static int starfive_trng_cmd(struct starfive_trng *trng, u32 cmd, bool wait)
+static int starfive_trng_cmd(struct starfive_trng *trng, u32 cmd, unsigned long timeout, bool wait)
 {
-	int wait_time = 1000;
+	struct completion *done;

-	/* allow up to 40 us for wait == 0 */
-	if (!wait)
-		wait_time = 40;
+	lockdep_assert_held(&trng->lock);
+
+	if (!starfive_trng_idle(trng, wait))
+		return wait ? -ETIMEDOUT : -EBUSY;

 	switch (cmd) {
 	case STARFIVE_CTRL_GENE_RANDNUM:
-		reinit_completion(&trng->random_done);
-		spin_lock_irq(&trng->write_lock);
-		writel(cmd, trng->base + STARFIVE_CTRL);
-		spin_unlock_irq(&trng->write_lock);
-		if (!wait_for_completion_timeout(&trng->random_done, usecs_to_jiffies(wait_time)))
-			return -ETIMEDOUT;
+		done = &trng->random_done;
 		break;
 	case STARFIVE_CTRL_EXEC_RANDRESEED:
-		reinit_completion(&trng->reseed_done);
-		spin_lock_irq(&trng->write_lock);
-		writel(cmd, trng->base + STARFIVE_CTRL);
-		spin_unlock_irq(&trng->write_lock);
-		if (!wait_for_completion_timeout(&trng->reseed_done, usecs_to_jiffies(wait_time)))
-			return -ETIMEDOUT;
+		done = &trng->reseed_done;
 		break;
 	default:
 		return -EINVAL;
 	}

+	/*
+	 * A command that timed out earlier may still have its completion
+	 * interrupt in flight. Ack the status bits and flush the handler so
+	 * a late RAND_RDY/SEED_DONE cannot complete this command.
+	 */
+	writel(STARFIVE_ISTAT_RAND_RDY | STARFIVE_ISTAT_SEED_DONE,
+	       trng->base + STARFIVE_ISTAT);
+	synchronize_irq(trng->irq);
+
+	reinit_completion(done);
+	writel(cmd, trng->base + STARFIVE_CTRL);
+	if (!wait_for_completion_timeout(done, timeout)) {
+		synchronize_irq(trng->irq);
+		if (!try_wait_for_completion(done))
+			return -ETIMEDOUT;
+	}
+
 	return 0;
 }

+static int starfive_trng_reseed(struct starfive_trng *trng)
+{
+	int ret;
+
+	lockdep_assert_held(&trng->lock);
+
+	WRITE_ONCE(trng->need_reseed, false);
+	ret = starfive_trng_cmd(trng, STARFIVE_CTRL_EXEC_RANDRESEED,
+				msecs_to_jiffies(STARFIVE_RANDRESEED_TIMEOUT_MS), true);
+	if (ret)
+		WRITE_ONCE(trng->need_reseed, true);
+
+	return ret;
+}
+
+static void starfive_trng_hw_setup(struct starfive_trng *trng)
+{
+	u32 mode;
+
+	/* setup Auto Request/Age register */
+	writel(autoage, trng->base + STARFIVE_AUTO_AGE);
+	writel(autoreq, trng->base + STARFIVE_AUTO_RQSTS);
+
+	mode = readl(trng->base + STARFIVE_MODE);
+	if (trng->mode == PRNG_128BIT)
+		mode &= ~STARFIVE_MODE_R256;
+	else
+		mode |= STARFIVE_MODE_R256;
+	writel(mode, trng->base + STARFIVE_MODE);
+}
+
 static int starfive_trng_init(struct hwrng *rng)
 {
 	struct starfive_trng *trng = to_trng(rng);
-	u32 mode, intr = 0;
 	int ret;

 	ret = pm_runtime_resume_and_get(trng->dev);
@@ -238,37 +311,62 @@ static int starfive_trng_init(struct hwrng *rng)
 		return ret;
 	}

-	/* setup Auto Request/Age register */
-	writel(autoage, trng->base + STARFIVE_AUTO_AGE);
-	writel(autoreq, trng->base + STARFIVE_AUTO_RQSTS);
+	mutex_lock(&trng->lock);
+
+	/*
+	 * The hwrng core can call init again without an intervening
+	 * cleanup: deselecting and quickly reselecting the device makes
+	 * cleanup_rng_work() skip ->cleanup() once the refcount is back up.
+	 * Only bring up the interrupt line once in that case.
+	 */
+	if (!trng->initialized) {
+		starfive_trng_irq_clear(trng);
+		starfive_trng_hw_setup(trng);
+
+		enable_irq(trng->irq);
+		writel(STARFIVE_IE_ALL, trng->base + STARFIVE_IE);
+		trng->initialized = true;
+	}
+
+	ret = starfive_trng_reseed(trng);
+	if (ret) {
+		trng->initialized = false;
+		writel(0, trng->base + STARFIVE_IE);
+		starfive_trng_irq_clear(trng);
+		disable_irq(trng->irq);
+	}

-	/* clear register: ISTAT */
-	starfive_trng_irq_mask_clear(trng);
+	mutex_unlock(&trng->lock);

-	intr |= STARFIVE_IE_ALL;
-	writel(intr, trng->base + STARFIVE_IE);
+	pm_runtime_put_autosuspend(trng->dev);

-	mode  = readl(trng->base + STARFIVE_MODE);
+	return ret;
+}

-	switch (trng->mode) {
-	case PRNG_128BIT:
-		mode &= ~STARFIVE_MODE_R256;
-		break;
-	case PRNG_256BIT:
-		mode |= STARFIVE_MODE_R256;
-		break;
-	default:
-		mode |= STARFIVE_MODE_R256;
-		break;
+static void starfive_trng_reseed_work(struct work_struct *work)
+{
+	struct starfive_trng *trng = work_to_trng(work);
+	int ret;
+
+	ret = pm_runtime_resume_and_get(trng->dev);
+	if (ret < 0) {
+		dev_err(trng->dev, "Failed to wake device for reseed: %d\n", ret);
+		return;
 	}

-	writel(mode, trng->base + STARFIVE_MODE);
+	mutex_lock(&trng->lock);

-	ret = starfive_trng_cmd(trng, STARFIVE_CTRL_EXEC_RANDRESEED, 1);
+	if (!READ_ONCE(trng->need_reseed) || !trng->initialized)
+		goto unlock;

-	pm_runtime_put_autosuspend(trng->dev);
+	ret = starfive_trng_reseed(trng);
+	if (ret)
+		dev_err(trng->dev, "Reseed after LFSR lockup failed: %d\n", ret);

-	return ret;
+unlock:
+	mutex_unlock(&trng->lock);
+
+	pm_runtime_put_autosuspend(trng->dev);
 }

 static irqreturn_t starfive_trng_irq(int irq, void *priv)
@@ -276,24 +374,21 @@ static irqreturn_t starfive_trng_irq(int irq, void *priv)
 	u32 status;
 	struct starfive_trng *trng = (struct starfive_trng *)priv;

-	status = readl(trng->base + STARFIVE_ISTAT);
-	if (status & STARFIVE_ISTAT_RAND_RDY) {
-		writel(STARFIVE_ISTAT_RAND_RDY, trng->base + STARFIVE_ISTAT);
+	status = readl(trng->base + STARFIVE_ISTAT) & STARFIVE_ISTAT_ALL;
+	if (!status)
+		return IRQ_NONE;
+
+	writel(status, trng->base + STARFIVE_ISTAT);
+
+	/* SEU occurred, reseeding required */
+	if (status & STARFIVE_ISTAT_LFSR_LOCKUP)
+		starfive_trng_request_reseed(trng);
+
+	if (status & STARFIVE_ISTAT_RAND_RDY)
 		complete(&trng->random_done);
-	}

-	if (status & STARFIVE_ISTAT_SEED_DONE) {
-		writel(STARFIVE_ISTAT_SEED_DONE, trng->base + STARFIVE_ISTAT);
+	if (status & STARFIVE_ISTAT_SEED_DONE)
 		complete(&trng->reseed_done);
-	}
-
-	if (status & STARFIVE_ISTAT_LFSR_LOCKUP) {
-		writel(STARFIVE_ISTAT_LFSR_LOCKUP, trng->base + STARFIVE_ISTAT);
-		/* SEU occurred, reseeding required*/
-		spin_lock(&trng->write_lock);
-		writel(STARFIVE_CTRL_EXEC_RANDRESEED, trng->base + STARFIVE_CTRL);
-		spin_unlock(&trng->write_lock);
-	}

 	return IRQ_HANDLED;
 }
@@ -301,15 +396,36 @@ static irqreturn_t starfive_trng_irq(int irq, void *priv)
 static void starfive_trng_cleanup(struct hwrng *rng)
 {
 	struct starfive_trng *trng = to_trng(rng);
+	bool initialized;
 	int ret;

 	ret = pm_runtime_resume_and_get(trng->dev);
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(trng->dev, "Failed to wake device for cleanup: %d\n", ret);
-		return;
+
+	mutex_lock(&trng->lock);
+	initialized = trng->initialized;
+	trng->initialized = false;
+	if (ret >= 0 && initialized) {
+		writel(0, trng->base + STARFIVE_IE);
+		starfive_trng_irq_clear(trng);
 	}
+	mutex_unlock(&trng->lock);
+
+	/*
+	 * cleanup also runs after a failed init, which has already undone
+	 * its enable_irq(). Only disable the line if init left it enabled.
+	 */
+	if (initialized)
+		disable_irq(trng->irq);
+	cancel_work_sync(&trng->work);

+	if (ret < 0)
+		return;
+
+	mutex_lock(&trng->lock);
 	writel(STARFIVE_CTRL_EXEC_NOP, trng->base + STARFIVE_CTRL);
+	mutex_unlock(&trng->lock);

 	pm_runtime_put_sync_suspend(trng->dev);
 }
@@ -317,7 +433,8 @@ static void starfive_trng_cleanup(struct hwrng *rng)
 static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 {
 	struct starfive_trng *trng = to_trng(rng);
-	int ret;
+	unsigned long timeout;
+	int ret, retry = 1;

 	ret = pm_runtime_resume_and_get(trng->dev);
 	if (ret < 0) {
@@ -325,35 +442,75 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
 		return ret;
 	}

-	if (trng->mode == PRNG_256BIT)
-		max = min_t(size_t, max, (STARFIVE_RAND_LEN * 8));
-	else
-		max = min_t(size_t, max, (STARFIVE_RAND_LEN * 4));
-
 	if (wait) {
-		ret = starfive_trng_wait_idle(trng);
-		if (ret) {
-			ret = -ETIMEDOUT;
+		mutex_lock(&trng->lock);
+		timeout = msecs_to_jiffies(STARFIVE_RANDGEN_TIMEOUT_MS);
+	} else {
+		/* allow up to 1 jiffy for wait == 0 */
+		if (!mutex_trylock(&trng->lock)) {
+			ret = 0;
 			goto out_put;
 		}
+		timeout = STARFIVE_RANDGEN_NOWAIT_TIMEOUT;
 	}

-	ret = starfive_trng_cmd(trng, STARFIVE_CTRL_GENE_RANDNUM, wait);
-	if (ret)
-		goto out_put;
+	for (;;) {
+		/*
+		 * A pending LFSR lockup taints the next sample. Blocking
+		 * callers reseed here; non-blocking callers return no data
+		 * and leave it to the reseed work. Re-queue it explicitly:
+		 * the lockup may have been seen by starfive_trng_irq_clear()
+		 * or a previous reseed attempt may have failed.
+		 */
+		if (READ_ONCE(trng->need_reseed)) {
+			if (!wait) {
+				starfive_trng_request_reseed(trng);
+				ret = 0;
+				goto out_unlock;
+			}
+			ret = starfive_trng_reseed(trng);
+			if (ret)
+				goto out_unlock;
+		}
+
+		ret = starfive_trng_cmd(trng, STARFIVE_CTRL_GENE_RANDNUM, timeout, wait);
+		if (ret) {
+			if (!wait && (ret == -EBUSY || ret == -ETIMEDOUT))
+				ret = 0;
+			goto out_unlock;
+		}
+
+		/* Lockup reported together with RAND_RDY: reseed and retry once */
+		if (!READ_ONCE(trng->need_reseed))
+			break;
+
+		if (!wait || !retry--) {
+			ret = 0;
+			goto out_unlock;
+		}
+	}
+
+	if (trng->mode == PRNG_256BIT)
+		max = min_t(size_t, max, (STARFIVE_RAND_LEN * 8));
+	else
+		max = min_t(size_t, max, (STARFIVE_RAND_LEN * 4));

 	memcpy_fromio(buf, trng->base + STARFIVE_RAND0, max);
+
 	ret = max;

+out_unlock:
+	mutex_unlock(&trng->lock);
+
 out_put:
 	pm_runtime_put_autosuspend(trng->dev);
+
 	return ret;
 }

 static int starfive_trng_probe(struct platform_device *pdev)
 {
 	int ret;
-	int irq;
 	struct starfive_trng *trng;

 	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
@@ -368,16 +525,14 @@ static int starfive_trng_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(trng->base),
 				     "Error remapping memory for platform device.\n");

-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
+	trng->irq = platform_get_irq(pdev, 0);
+	if (trng->irq < 0)
+		return trng->irq;

 	init_completion(&trng->random_done);
 	init_completion(&trng->reseed_done);
-	spin_lock_init(&trng->write_lock);

-	ret = devm_request_irq(&pdev->dev, irq, starfive_trng_irq, 0, pdev->name,
-			       (void *)trng);
+	ret = devm_mutex_init(&pdev->dev, &trng->lock);
 	if (ret)
 		return ret;

@@ -420,6 +575,15 @@ static int starfive_trng_probe(struct platform_device *pdev)
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret, "Failed to enable runtime PM\n");

+	ret = devm_work_autocancel(&pdev->dev, &trng->work, starfive_trng_reseed_work);
+	if (ret)
+		return ret;
+
+	ret = devm_request_irq(&pdev->dev, trng->irq, starfive_trng_irq, IRQF_NO_AUTOEN,
+			       pdev->name, (void *)trng);
+	if (ret)
+		return ret;
+
 	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
@@ -432,8 +596,16 @@ static int starfive_trng_probe(struct platform_device *pdev)
 static int starfive_trng_suspend(struct device *dev)
 {
 	struct starfive_trng *trng = dev_get_drvdata(dev);
+	bool assert_rst;
+
+	mutex_lock(&trng->lock);
+	assert_rst = !trng->initialized;
+	writel(0, trng->base + STARFIVE_IE);
+	starfive_trng_irq_clear(trng);
+	mutex_unlock(&trng->lock);

-	starfive_trng_power_off(trng, false);
+	synchronize_irq(trng->irq);
+	starfive_trng_power_off(trng, assert_rst);

 	return 0;
 }
@@ -444,10 +616,17 @@ static int starfive_trng_resume(struct device *dev)
 	int ret;

 	ret = starfive_trng_power_on(trng);
-	if (ret)
+	if (ret) {
 		dev_err(dev, "Failed to power on: %d\n", ret);
+		return ret;
+	}

-	return ret;
+	if (trng->initialized) {
+		starfive_trng_irq_clear(trng);
+		writel(STARFIVE_IE_ALL, trng->base + STARFIVE_IE);
+	}
+
+	return 0;
 }

 static const struct of_device_id trng_dt_ids[] __maybe_unused = {
--
2.43.0

