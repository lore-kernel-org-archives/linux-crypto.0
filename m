Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.132
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793691200;
	b=TuCNVs71uHTnhkWv4XeM/7JTNIKmdGF74jnNlegxh9u10f+9D+DETpLRTbROweKyQLmG
	 MyWOX/OXGejK9nyoCkg7mwPVVLNGsOqrrn816ucasaawKdkYsx1GzJUJPqDID2EFa7UsM
	 qfz9COPAw2BWHhE6ZnyOS8rLKpjDxCjDyiUJsy+NuWinOabrrZ7n9i1LgLhmxSoq1dziD
	 Turr/Md3KKoYe+U1tLPxDtm1zwnP2ZU9ss1gaOZocFNOwWvwMF7nyWo2JG666++dG3/4p
	 If6bQvi6O1paNbYYXQmnGQxtYdbmzQVS3rLb9SmyowI52K+Ks1CjyOESy2ZJ869guAw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793691200;
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
	bh=bxq4JrryQS8aHwW1Jg/qFXmRCpuNXay95arpMOW9TA8=;
	b=5pDiggxec3KAv23o4iXdWwxivg1vhD3QGqMillU0m9Ap/Wd7+NUohWbG6nXXsjreCy1y
	 O34MQMBPBr7oQ/pFDYWiEhAhPyjZQ7kYkUHfjkMF3tR3BchtklQCeKwVxc5szivju/cDL
	 PyxCVCA3iwWTX+ijcKrSyDoATwKBYEt03Wh147ocYFZbc6n9cNwYqPRaiSIFsRHxMRFj/
	 oT31mMggNoCpJF7AwFOBMZeM76jO7w5honK4ozpIJVztTo7BBsUsVNdrkkwpPlgRVbYdX
	 wuV3W34v1AVsh7O9OA3lWoKChy+SdfuoPjtbb2yhkrg+kWMJ3iUmrnphJEd5Xyq0Gvw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.132
Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2132.outbound.protection.partner.outlook.cn [139.219.146.132])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70ABC606D806;
	Tue,  3 Nov 2026 07:33:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70ABC606D806
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIfwtpS0a7KfweziEb6mWs7ppDR3nvD4Wt57HgbsfoJNfj0/XydvhJMTQ6Be9TosaoY0vaAr5VNGvj2j4x0wcEJi8vLArAXpKhSZzYRK3FlUL+NYrDzWTY4aS1W1EINJL9s5Gx5LSh4Ry8qRNRo5mWbH+8mLb7GruH6mYkAjEzUx6JYh0H7S5I7BQ1+r9Cs1xzv1ZVC5auqe75e7gTOtHQxub7mWtEmJzOttsbyOHrm1FkKiT2+8glDffKZk0/XcZsYSusSdChxpuvvZJySEXSAsxTGKhCwqtHsO9re3CAhjhWO6acbTuSr0VrbRnJ6YqkbX48NyIR1D6jS03IZqJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bxq4JrryQS8aHwW1Jg/qFXmRCpuNXay95arpMOW9TA8=;
 b=PD1EUhDpGWMsozso2XkdWEmjAgbB1hPcRQsK8truLTfXtCZPJTQ9QaSJc05egXt69/mxL7ES06iK33uXh7/7kQCvqKCYs0Fg7McRN4qrZ5d2Z8FH/c7+2nzcXORpNLh3sHx9DAACh1wQPgRZr0YejrCEDHoGz6AhUnJnRSJ7SKolq3Zmf00hrZoSpmsdH40aUUlWPvEvMyAbWciUKAYLM+Hhqv3gz/N5Z5nm+Lwe5jV1EtifL8BFx1+S1/CX8rLSwvSFxHga4IzSvjj5A2Apfxx218AH0+pqMLhgdM2MCTtcPfC2ZGnHroJvaGLWqZU+a2xhCWJYJEuAuP52d0a9BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1032.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:c::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 07:33:02 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 07:33:02 +0000
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
Subject: [PATCH v11 4/6] hwrng: starfive - tidy up includes and drop unused code
Date: Tue,  3 Nov 2026 15:32:50 +0800
Message-Id: <20261103073252.3028-5-lianfeng.ouyang@starfivetech.com>
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
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1032:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b431a55-a4f8-472b-7da9-08df397cb17d
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|52116014|38350700014|261021123027099003|5023799004|261026130827099003|261021133027099003|56012099006|261021135927099003|261009223027099003|261009220027099003|261028144727099003|261009223327099003|261009221727099003|261009221227099003|261026135527099003|261022075727099003|261026121527099003|261022115727099003|261021121427099003|261026140227099003|261021130227099003|261022105027099003|261022113327099003|10067099003|18002099003|22082099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	prKQ+PMtJUgdtrJ1/u21nNx/Hno/ZKWL1B9PXd4OlT0AZFkrAVlEd8p2vLq8nqn/L4ufdDM4XAJuE5j4qwewK140zodkTiISEUZcUJhbuN0o+NjjkUsVvJtAw8G6JGPRYwNZmTmiGIQOGLJELNP5zSuD+SYewT4Wjh9MfXzSBuiRfmk8Az8p7tA6exXs/as6H1ZCj50VRXl0FZPueRviEyjyzcr4Rg/55SeBsXAt0FI8seTMZ6EqDwwdOVOFWNHTrJHv4LY2AgG3BikCB1ddsBIux0JtkL3Yl4SLy31fj6QXqSXdXtbps0YggVe0YsyL8MHZcJog+Ah2Uk26JgiLPAsGvSRH5uxSxugDdA55ERYhbtK0njWLVMrOKap5hHA4n3juaidExgmiCsqXekGyljKtHuGJl+VqbFzaOAHTKOErjAETs5T3Ss4PU36yHcSbnrYqXmVQqPzj9jury68y+kuGgFnjFDybtcJJSUrrTH/ZY9pJTpsHltV0+MmJ9dSeVdYQsFSRQdylumHADJfW0YtbTWLM8eiotKQclLY3YyXcpdNJvqQt8Bi+imB5eAlR
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(52116014)(38350700014)(261021123027099003)(5023799004)(261026130827099003)(261021133027099003)(56012099006)(261021135927099003)(261009223027099003)(261009220027099003)(261028144727099003)(261009223327099003)(261009221727099003)(261009221227099003)(261026135527099003)(261022075727099003)(261026121527099003)(261022115727099003)(261021121427099003)(261026140227099003)(261021130227099003)(261022105027099003)(261022113327099003)(10067099003)(18002099003)(22082099003)(261102123227099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wmXKGmApz7NcYL7feFdPpYDPFHn6jZgeCn86LYKzAX185nOCcf3raw5rwnDV?=
 =?us-ascii?Q?KI5lMes93zLksXHou9ELqotG37oCle39yCxs6gJBwhQLqK+GJdWdDYD1ONdH?=
 =?us-ascii?Q?et5dPxq4i/SFOPHdt8HLwsCQbJjlMZ3GKWaL7yMR0GkWMdy35JI225IWYYkz?=
 =?us-ascii?Q?se1Z8CiR/iyM4oE0+9IyGhAHLl+HeO6qcJ7rGU7XhBVLZx4IjrGV5jUp5KK8?=
 =?us-ascii?Q?M5WWAFXwGxXCBG1YfmdOWyp0lyxKgs5XuHCguoOJvBFgy3g784GSWqL9HQuX?=
 =?us-ascii?Q?do70/6DxppTO4w3BE5mQ1zIKGbdPdDUwvL+MOhvsKDOWQxbYuhzv6yTmV7ZK?=
 =?us-ascii?Q?aadtEULV+fzE0ghTwG3wKcEr8ycSI9irQV5OGIMY/+1DybucDF2UwDQ7tTJA?=
 =?us-ascii?Q?IzmmItDVEwxK7rgBCPVxR1V3OpIi3J8QvRoM98eEr0hhXuAurl/4pLT5f+Fk?=
 =?us-ascii?Q?fuONbJyhHwnX7eZTk2SQRAp7+JHZZ3x2uwa65X1yQmLgyPcl78WY0oVHjHvH?=
 =?us-ascii?Q?0V9EhFa/Q217oz5QCWqqwmn8keCq4AhkL4zTetxpezbABUjgOkm44zfN0j8X?=
 =?us-ascii?Q?0S5I7oHReKe+5jBJezebuVhiJH98qu02vImBfiR7gK7O6cr17tAo61QXTH50?=
 =?us-ascii?Q?oqGEpAmjEzWIE+qdqmuHbgIYqzURCV5nPM3d5Hlb5juRSbd6Jw2/GQzLaPEA?=
 =?us-ascii?Q?qPwd9Mw2q8oxQn3uZshMp/GTeXpGV2gK4YQVQexORuS3mmNDPUGJDGxXFhex?=
 =?us-ascii?Q?pXz54TnJZ26USGFjGQQciRupKi8Ww0uypKvY6JPVDnNFmF7LWBaLcOc6o7k1?=
 =?us-ascii?Q?iZjnoOoJCv+V4TyOg5gPZ04P0OqstJlXvMaDkGLUqNTsfeISJb6GzVNu9RCj?=
 =?us-ascii?Q?G9ommhRID/fU+jHNLZsLvTUpOrMvtSTzmw6NBTVSI6tFEMqqR3xoIQzueNK8?=
 =?us-ascii?Q?Dy3Lng3IsZJ6wg2A/xWK4lmkLMhaTIzGnIl3Uqq+hwtnt5IlfDEsBeHUNPtH?=
 =?us-ascii?Q?mqBtWDqtwTxt/Gafh6uCQ36AwoBQXBHc+0KtM+ojfHTRzbWdTGZSaIN7pjZN?=
 =?us-ascii?Q?8EpR6h+/JLuPmi4ro5kS9vqBwNgtJ9k9HkYCLp/Xna14aNIbVkrFk29BlmNB?=
 =?us-ascii?Q?Dgm5F1J5d9emEfz229euRvaiiRnrV41smg5MZFH+hhjasCJk6QO9OCqZRb1D?=
 =?us-ascii?Q?F3xOO4Yp81kNXInOgFuScOulsVj3HpDRwp5Zv1vi8Hq9OX6zl3Hw7ifjYBCR?=
 =?us-ascii?Q?qS9qy8XgkMrMDXTBb5EdDYMCHoT2VNdyP5sA+QxyeFAjP2UiBS2ygMEfnLq9?=
 =?us-ascii?Q?5VDaj8vnisM53TsA67gRbZDiN0c693lutOq9qBcgWDf3kuBAiy7zSwf97cpR?=
 =?us-ascii?Q?lr2M3qpEgmyubC0ahBNh0Xo4DW63gcyWsN9DOgF369LG6NFNLCpZp7Cm5w1m?=
 =?us-ascii?Q?v+rIsVTdxx/hTefUmhyUYKjs7PVBbuNqEhmj7EUYWrLF4Pg1/o3s3pB72GOr?=
 =?us-ascii?Q?2LLMblEmUPon/iZWLw02+R1mebEgb93m52rhiqSyRMEcmg0JFMJUM4UKdokG?=
 =?us-ascii?Q?B77f1bIn1TTkr8gBBy3eSq33LyIwZq+9pnKYik78AR6iIhAO2CNhUEiJ6K/Q?=
 =?us-ascii?Q?pIC+F0CbuusVE4oJ+nCsLxEmOODxL9vpuz6t3llmzNOZQETIdEjatAr7z3Ke?=
 =?us-ascii?Q?A01u2T12Nnrb50VeqHlMYdfS9QXy8eGCr5+dm1e0AgBM+xaXNaV9EQ97lYhW?=
 =?us-ascii?Q?EdeIx+Ssv8Pu7ozMEn5djdh4QkqT1vQ=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b431a55-a4f8-472b-7da9-08df397cb17d
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 07:33:02.7097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wBNb/bg8diMLbDQzca3DdPXA4Hs0PPPkbThqq+BhPUlpy6GZ0dSmuCeHS2/aXxFSP1cxoHGhQiiJeWytjGdrt6VIZjQuUkW2UTxWwsymNyHzQwlsIYC29oRHmEoz4P1s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1032

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

Make the driver include what it uses: add <linux/bits.h>,
<linux/container_of.h>, <linux/device.h>, <linux/errno.h>,
<linux/jiffies.h>, <linux/minmax.h> and <linux/types.h>, and drop
<linux/delay.h>, <linux/kernel.h>, <linux/of.h> and <linux/random.h>,
which nothing in the driver needs. struct of_device_id is already
provided through <linux/platform_device.h>, so <linux/mod_devicetable.h>
is not needed either.

With <linux/of.h> gone, stop wrapping the match table in of_match_ptr()
and drop its __maybe_unused annotation.

Also drop the unused reseed enum and struct member, name the mode enum
after the driver, use a local struct device pointer in probe, name the
interrupt after the device and replace min_t() with min().

Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
---
 drivers/char/hw_random/jh7110-trng.c | 81 ++++++++++++++--------------
 1 file changed, 39 insertions(+), 42 deletions(-)

diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_random/jh7110-trng.c
index e370a49bba83..82c5d1491912 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -5,24 +5,27 @@
  * Copyright (C) 2022 StarFive Technology Co.
  */
 
+#include <linux/bits.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
-#include <linux/delay.h>
+#include <linux/container_of.h>
+#include <linux/device.h>
 #include <linux/devm-helpers.h>
 #include <linux/err.h>
+#include <linux/errno.h>
 #include <linux/hw_random.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
-#include <linux/kernel.h>
+#include <linux/jiffies.h>
 #include <linux/lockdep.h>
+#include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
-#include <linux/random.h>
 #include <linux/reset.h>
+#include <linux/types.h>
 #include <linux/workqueue.h>
 
 /* trng register offset */
@@ -93,12 +96,7 @@
 
 #define to_trng(p)			container_of(p, struct starfive_trng, rng)
 
-enum reseed {
-	RANDOM_RESEED,
-	NONCE_RESEED,
-};
-
-enum mode {
+enum starfive_trng_mode {
 	PRNG_128BIT,
 	PRNG_256BIT,
 };
@@ -116,7 +114,6 @@ struct starfive_trng {
 	struct work_struct	work;
 	u32			mode;
 	u32			mission;
-	u32			reseed;
 	bool			need_reseed;
 	bool			initialized;
 	bool			clk_on;
@@ -372,7 +369,7 @@ static void starfive_trng_reseed_work(struct work_struct *work)
 static irqreturn_t starfive_trng_irq(int irq, void *priv)
 {
 	u32 status;
-	struct starfive_trng *trng = (struct starfive_trng *)priv;
+	struct starfive_trng *trng = priv;
 
 	status = readl(trng->base + STARFIVE_ISTAT) & STARFIVE_ISTAT_ALL;
 	if (!status)
@@ -491,9 +488,9 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
 	}
 
 	if (trng->mode == PRNG_256BIT)
-		max = min_t(size_t, max, (STARFIVE_RAND_LEN * 8));
+		max = min(max, STARFIVE_RAND_LEN * 8);
 	else
-		max = min_t(size_t, max, (STARFIVE_RAND_LEN * 4));
+		max = min(max, STARFIVE_RAND_LEN * 4);
 
 	memcpy_fromio(buf, trng->base + STARFIVE_RAND0, max);
 
@@ -510,20 +507,21 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
 
 static int starfive_trng_probe(struct platform_device *pdev)
 {
-	int ret;
+	struct device *dev = &pdev->dev;
 	struct starfive_trng *trng;
+	int ret;
 
-	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
+	trng = devm_kzalloc(dev, sizeof(*trng), GFP_KERNEL);
 	if (!trng)
 		return -ENOMEM;
 
 	platform_set_drvdata(pdev, trng);
-	trng->dev = &pdev->dev;
+	trng->dev = dev;
 
 	trng->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(trng->base))
-		return dev_err_probe(&pdev->dev, PTR_ERR(trng->base),
-				     "Error remapping memory for platform device.\n");
+		return dev_err_probe(dev, PTR_ERR(trng->base),
+				     "Error remapping memory for platform device\n");
 
 	trng->irq = platform_get_irq(pdev, 0);
 	if (trng->irq < 0)
@@ -532,63 +530,62 @@ static int starfive_trng_probe(struct platform_device *pdev)
 	init_completion(&trng->random_done);
 	init_completion(&trng->reseed_done);
 
-	ret = devm_mutex_init(&pdev->dev, &trng->lock);
+	ret = devm_mutex_init(dev, &trng->lock);
 	if (ret)
 		return ret;
 
-	trng->hclk = devm_clk_get(&pdev->dev, "hclk");
+	trng->hclk = devm_clk_get(dev, "hclk");
 	if (IS_ERR(trng->hclk))
-		return dev_err_probe(&pdev->dev, PTR_ERR(trng->hclk),
+		return dev_err_probe(dev, PTR_ERR(trng->hclk),
 				     "Error getting hardware reference clock\n");
 
-	trng->ahb = devm_clk_get(&pdev->dev, "ahb");
+	trng->ahb = devm_clk_get(dev, "ahb");
 	if (IS_ERR(trng->ahb))
-		return dev_err_probe(&pdev->dev, PTR_ERR(trng->ahb),
+		return dev_err_probe(dev, PTR_ERR(trng->ahb),
 				     "Error getting ahb reference clock\n");
 
-	trng->rst = devm_reset_control_get_shared(&pdev->dev, NULL);
+	trng->rst = devm_reset_control_get_shared(dev, NULL);
 	if (IS_ERR(trng->rst))
-		return dev_err_probe(&pdev->dev, PTR_ERR(trng->rst),
+		return dev_err_probe(dev, PTR_ERR(trng->rst),
 				     "Error getting hardware reset line\n");
 
 	ret = starfive_trng_power_on(trng);
 	if (ret)
-		return dev_err_probe(&pdev->dev, ret, "Failed to power on\n");
+		return dev_err_probe(dev, ret, "Failed to power on\n");
 
-	ret = devm_add_action_or_reset(&pdev->dev, starfive_trng_power_off_action, trng);
+	ret = devm_add_action_or_reset(dev, starfive_trng_power_off_action, trng);
 	if (ret)
 		return ret;
 
-	trng->rng.name = dev_driver_string(&pdev->dev);
+	trng->rng.name = dev_driver_string(dev);
 	trng->rng.init = starfive_trng_init;
 	trng->rng.cleanup = starfive_trng_cleanup;
 	trng->rng.read = starfive_trng_read;
 
 	trng->mode = PRNG_256BIT;
 	trng->mission = 1;
-	trng->reseed = RANDOM_RESEED;
 
-	pm_runtime_use_autosuspend(&pdev->dev);
-	pm_runtime_set_autosuspend_delay(&pdev->dev, 100);
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_set_autosuspend_delay(dev, 100);
 
-	ret = devm_pm_runtime_set_active_enabled(&pdev->dev);
+	ret = devm_pm_runtime_set_active_enabled(dev);
 	if (ret)
-		return dev_err_probe(&pdev->dev, ret, "Failed to enable runtime PM\n");
+		return dev_err_probe(dev, ret, "Failed to enable runtime PM\n");
 
-	ret = devm_work_autocancel(&pdev->dev, &trng->work, starfive_trng_reseed_work);
+	ret = devm_work_autocancel(dev, &trng->work, starfive_trng_reseed_work);
 	if (ret)
 		return ret;
 
-	ret = devm_request_irq(&pdev->dev, trng->irq, starfive_trng_irq, IRQF_NO_AUTOEN,
-			       pdev->name, (void *)trng);
+	ret = devm_request_irq(dev, trng->irq, starfive_trng_irq, IRQF_NO_AUTOEN,
+			       dev_name(dev), trng);
 	if (ret)
 		return ret;
 
-	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
+	ret = devm_hwrng_register(dev, &trng->rng);
 	if (ret)
-		return dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
+		return dev_err_probe(dev, ret, "Failed to register hwrng\n");
 
-	pm_runtime_idle(&pdev->dev);
+	pm_runtime_idle(dev);
 
 	return 0;
 }
@@ -629,7 +626,7 @@ static int starfive_trng_resume(struct device *dev)
 	return 0;
 }
 
-static const struct of_device_id trng_dt_ids[] __maybe_unused = {
+static const struct of_device_id trng_dt_ids[] = {
 	{ .compatible = "starfive,jh7110-trng" },
 	{ }
 };
@@ -643,7 +640,7 @@ static struct platform_driver starfive_trng_driver = {
 	.driver	= {
 		.name		= "jh7110-trng",
 		.pm		= pm_ptr(&starfive_trng_pm_ops),
-		.of_match_table	= of_match_ptr(trng_dt_ids),
+		.of_match_table	= trng_dt_ids,
 	},
 };
 
-- 
2.43.0

