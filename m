Return-Path: <SRS0=Ahx1=BA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDE7C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 04:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7B002068F
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 04:40:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="lKYc7+0/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbgGUEkd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jul 2020 00:40:33 -0400
Received: from mail-eopbgr10118.outbound.protection.outlook.com ([40.107.1.118]:50496
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725954AbgGUEkc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jul 2020 00:40:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJi5SAevEwyL2qxg1lTv1jKh147lQsSAB8LF2nzm0IuPbSpjMnzJyn3Z8O25fNoVbixYJryXCCVgkjV5f1QQlTNggQqBQkoAqEDWXqkq03NO8aa4UXDON/DKCOCFNTgv7jIpTxDKSi/z5UGZai9VNvEHpkR4rQBaGD0UGgx7XFhJxouu30Kv5KyoryuO/cAahAE7XjWqu3XB5AJFYv9aBJeuAClT6msLJIZZbTJXbDcYMOQoopI6dJ09t7jtKEPFSPiwl3McqdvBr6CNhhQulm+7RsNJCC0+15RaDKZDvcaYGyWVDBIo4EzrEqIOE6BSBPUq6fVCY/6zbyCGe8EAYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YhnrFRgYsT5I+NZZv5bNSEu5iqdw2Fn4xEkl097IK6U=;
 b=frufU9dJWAql2+UDOxvrM1fyg2HbbC5wy+Xh8jdju98vh3XSj0jCBYOYwIX9P5DUpP8DQpZqsf6y2rmtSW4oQHSllQCfbZBK+SZmHTsa/XjAzu87YeTvRwrZ/irSB/tkXk4hdNnoBdKierD1CXMyKycjClqjvjxPubCKZtZIJfLTMwQ06NOfpElyCOllOPz4wkRB5p6TwnbZpp3SK0Kqxrr+sz1mKlFVmXgUmZkboYNAbvBE1pPc/f2WkV8Gw02xMxJgMgaVADheoDNvLrr0PPXhVdGC/OFXtren9AhH3HMBe/KS4KO8igyABI+/Iw8FsYFe20XDIe6qMIZ5a02qDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YhnrFRgYsT5I+NZZv5bNSEu5iqdw2Fn4xEkl097IK6U=;
 b=lKYc7+0//TwgKLHPI4++X1wWJqwW7T3XYwt+GGpHCwkCd++W6+wenLux2+TTY6Dj1Dyd9xXhSzsckjIZhL7Pxu+iu1vsyrWCqadHfhcLcz6Oz7jToa2tFxMBMhGsCAIJvGiW/ScOvcQYpnBA/IqYuy7P6LDSvSFj8TIclXK4AOM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM4PR05MB3284.eurprd05.prod.outlook.com
 (2603:10a6:205:4::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.24; Tue, 21 Jul
 2020 04:40:29 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39%11]) with mapi id 15.20.3195.026; Tue, 21 Jul
 2020 04:40:29 +0000
Date:   Tue, 21 Jul 2020 06:40:27 +0200
From:   Sven Auhagen <Sven.Auhagen@voleatech.de>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ardb@kernel.org,
        bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com
Subject: [PATCH 1/1 v3] marvell cesa irq balance
Message-ID: <20200721044027.6r3l6ef23fqyg3qn@SvensMacBookAir.sven.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: AM0PR04CA0055.eurprd04.prod.outlook.com
 (2603:10a6:208:1::32) To AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.sven.lan (109.193.235.168) by AM0PR04CA0055.eurprd04.prod.outlook.com (2603:10a6:208:1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Tue, 21 Jul 2020 04:40:28 +0000
X-Originating-IP: [109.193.235.168]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a191972d-e72f-4412-33a6-08d82d3031a7
X-MS-TrafficTypeDiagnostic: AM4PR05MB3284:
X-Microsoft-Antispam-PRVS: <AM4PR05MB3284A2C415EE565EE57364CCEF780@AM4PR05MB3284.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:556;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hQ6B2jya+090jazr7uAMxL6d8Xz3Dm1spcLpWLiE3R3jAMNOSh/g81FfUNDEaBRUS/lWEDMA8/WuOr/z4xiS7hYzZUr0H21jpQBS/SUiMiaLIXPmPXECth0oI8+Xqpnwgm1VV+Ad9n243RYo8utf2aqImESif1OF9JJMhXDOnnyrVTlYD9Izd7+vPSbp585isq5rHzT0HaiCu+sWDac62jRoqO2vK90iyX+ZamStx0euPHxAFObcSItjEkB4R/BkyT6SxEajmXW9tNPhUd+aIdA4xDCrk2Tp6L5a+9FwH2NSQ7c3LY9JRHI28RDtd+xNvC7TIGuUU5quzY+9g1x40A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39830400003)(366004)(396003)(346002)(376002)(136003)(66476007)(6506007)(66556008)(8676002)(2906002)(186003)(4326008)(508600001)(8936002)(16526019)(26005)(9686003)(52116002)(7696005)(66946007)(5660300002)(6916009)(1076003)(83380400001)(316002)(956004)(86362001)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 5posJyUHhdas4LWtdaAuatBhJ2XqJDu35yeQmsZAyjUe3vp8MvdCaQQt883MHZqcYHRvTL/snKw7k5iuEVdOGcWvfEdFFarqjmDHfsphq8mEM74nbrdzzb19mOcJaW5pFRfjviiDORjA/m8JGwDT3WDw3X8BgFKs8KZddecKC6tV9kS1vYvNQKRMhqkB9MeCXJlrOlbWypeimjMtMLmeEzBnXKSs4GYxAUALnRJR+Jjklljj24ZwC/quooQZtH3JR/P70TN1L142bJ0dHqrh8km5yzt/RdVhRIFjSr4QoS7By4QiXyfPIGKxHrFd8QFIDPqBKMuz9gxR0maGd5V7tmlFh14qF8pLHInXdY9tvNrfJGCStTSsVE1Y2GXoVSQNtJnrY9byIgDL/xnI9s5xkMeGrHHe6tiBcj7ovXpZpT7eCYEzdwACT6wELOR4gXLScGQAR0q1fEhDP42mlOk9/3Prm7Q4wZBLLZs2DayDqTSFlrrkgAmp9uyZjQLrifGQ
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: a191972d-e72f-4412-33a6-08d82d3031a7
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0501MB2785.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2020 04:40:29.0095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: imTc1kZDcCx4cWPAnDiRbbEWrp7OiqKSAyarG0fBrh9OXFZz3xGkkV15D/QtsUIHHt144/mSdiUvMLPU31di3ZHih5+1v6TbwGMib8N8hkM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3284
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Balance the irqs of the marvell cesa driver over all
available cpus.
Currently all interrupts are handled by the first CPU.

From my testing with IPSec AES 256 SHA256
on my clearfog base with 2 Cores I get a 2x speed increase:

Before the patch: 26.74 Kpps
With the patch: 56.11 Kpps

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
v3:
* use NUMA_NO_NODE constant

v2:
* use cpumask_local_spread and remove affinity on
  module remove

 drivers/crypto/marvell/cesa/cesa.c | 11 ++++++++++-
 drivers/crypto/marvell/cesa/cesa.h |  1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 8a5f0b0bdf77..c098587044a1 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -438,7 +438,7 @@ static int mv_cesa_probe(struct platform_device *pdev)
 	struct mv_cesa_dev *cesa;
 	struct mv_cesa_engine *engines;
 	struct resource *res;
-	int irq, ret, i;
+	int irq, ret, i, cpu;
 	u32 sram_size;
 
 	if (cesa_dev) {
@@ -505,6 +505,8 @@ static int mv_cesa_probe(struct platform_device *pdev)
 			goto err_cleanup;
 		}
 
+		engine->irq = irq;
+
 		/*
 		 * Not all platforms can gate the CESA clocks: do not complain
 		 * if the clock does not exist.
@@ -548,6 +550,10 @@ static int mv_cesa_probe(struct platform_device *pdev)
 		if (ret)
 			goto err_cleanup;
 
+		/* Set affinity */
+		cpu = cpumask_local_spread(engine->id, NUMA_NO_NODE);
+		irq_set_affinity_hint(irq, get_cpu_mask(cpu));
+
 		crypto_init_queue(&engine->queue, CESA_CRYPTO_DEFAULT_MAX_QLEN);
 		atomic_set(&engine->load, 0);
 		INIT_LIST_HEAD(&engine->complete_queue);
@@ -570,6 +576,8 @@ static int mv_cesa_probe(struct platform_device *pdev)
 		clk_disable_unprepare(cesa->engines[i].zclk);
 		clk_disable_unprepare(cesa->engines[i].clk);
 		mv_cesa_put_sram(pdev, i);
+		if (cesa->engines[i].irq > 0)
+			irq_set_affinity_hint(cesa->engines[i].irq, NULL);
 	}
 
 	return ret;
@@ -586,6 +594,7 @@ static int mv_cesa_remove(struct platform_device *pdev)
 		clk_disable_unprepare(cesa->engines[i].zclk);
 		clk_disable_unprepare(cesa->engines[i].clk);
 		mv_cesa_put_sram(pdev, i);
+		irq_set_affinity_hint(cesa->engines[i].irq, NULL);
 	}
 
 	return 0;
diff --git a/drivers/crypto/marvell/cesa/cesa.h b/drivers/crypto/marvell/cesa/cesa.h
index e8632d5f343f..0c9cbb681e49 100644
--- a/drivers/crypto/marvell/cesa/cesa.h
+++ b/drivers/crypto/marvell/cesa/cesa.h
@@ -457,6 +457,7 @@ struct mv_cesa_engine {
 	atomic_t load;
 	struct mv_cesa_tdma_chain chain;
 	struct list_head complete_queue;
+	int irq;
 };
 
 /**
-- 
2.20.1

