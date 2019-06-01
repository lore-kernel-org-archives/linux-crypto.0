Return-Path: <SRS0=xfQ5=UA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B569CC28CC4
	for <linux-crypto@archiver.kernel.org>; Sat,  1 Jun 2019 13:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9961D27729
	for <linux-crypto@archiver.kernel.org>; Sat,  1 Jun 2019 13:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfFANxa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 1 Jun 2019 09:53:30 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:40515 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfFANx3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Jun 2019 09:53:29 -0400
Received: from orion.localdomain ([95.114.112.19]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MY5XR-1h5yn83lFt-00YPOK; Sat, 01 Jun 2019 15:53:08 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     vireshk@kernel.org, b.zolnierkie@samsung.com, axboe@kernel.dk,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH 4/4] drivers: ata: use MODULE_DECLARE_OF_TABLE()
Date:   Sat,  1 Jun 2019 15:52:59 +0200
Message-Id: <1559397179-5833-5-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1559397179-5833-1-git-send-email-info@metux.net>
References: <1559397179-5833-1-git-send-email-info@metux.net>
X-Provags-ID: V03:K1:zlZQLw/7X/h00DT4khIXd7jjS4solJe6AYqFAW61yXbLkxP/FKv
 2SIn8J4GncUnBymImySqQuvaZ6hc0os0iWfIgCYSLkrsfUdlrbRZOWW+Dl7RYMVd8VtAlXe
 VyYoxafCnE4KHfCkp85GNni5xN9+R3q29+pht6cYEC0WNM/q4+t9Ayqgq8oiA4+JHqz4sft
 Nv7++ZTKqDPO13S9DkX5Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:NL9r01+H0YU=:N9E0t5e+9MRvzhoQBaW1lK
 2gvx90Ty9dQwzFrFOja096OXdWC9vhoccvHP0T1R4HLpjjFAj+hHa4RG/4Z863q3jMBUuQ2W5
 +Fkbk4bjIaJPzGkhJdF4zRYwYXu/J28mKstKoTVXJ7aEsMt7C6mjiEZDTLZgVEsqIfl2IxZKT
 uqx9WH6/nF4LXEA0+Ck2EB8+nUWQd+oOxPxw9FvKEZ2CmNCkQckNZEDXUoz1JwWhnb0gcaRcU
 STNGY/HBIagnYyn8oZIls5tyGMOpwBovXMObz5AOfQb33Nj8yQLujlm6FS5B7E+kUoVnCkhnq
 qwiVfQO0VBim3JEienuGW7r+XIwoFSmGopFRY5yRYey6o5/y32LQIIokN5ZGa9nFPVIYlWd51
 xn67VKtNP3M0s2p8M/Oaq4cHMo/kz50dbY8KAnmZrtQYfNSuCxtpbmd2oJR2mk3nCIlAhZUrN
 VgUD6JhJ37Ar78pM7GBEQ3VOUaVf7kHv0pZAjdLmjLsiEH7SHzyRTtaOL6zpFLmzpfg2LTuyU
 DPFlrxpVztGS93UxY8MEWC8MJv6sq6xKklUEEQVUts0YtQ9FyOCqVZZDpjg+j/WryUVTJU0MU
 0ieMX09LWeQlnBuy4WEKgDmCkvokafurb7anxKTuHlxWoP0ms4DxAn9fjhWZnSrWP4nNSSkVJ
 l0ZipRPqvrF/t5hZ/9l0XLiL5kxLl8vFpAtiQUKELnhfN56e8pmJjcSCZsLQgPKaLsxh5i+jM
 XievQ5ggM51mt1gbSjWdKm1FclP3k5m0dDHWAQ==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Using MODULE_DECLARE_OF_TABLE() macro to get rid of some #ifdef CONFIG_OF
and make the code a bit slimmer.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 drivers/ata/pata_arasan_cf.c | 9 ++-------
 drivers/ata/sata_mv.c        | 9 ++-------
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index ebecab8..22de61f 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -943,13 +943,8 @@ static int arasan_cf_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(arasan_cf_pm_ops, arasan_cf_suspend, arasan_cf_resume);
 
-#ifdef CONFIG_OF
-static const struct of_device_id arasan_cf_id_table[] = {
-	{ .compatible = "arasan,cf-spear1340" },
-	{}
-};
-MODULE_DEVICE_TABLE(of, arasan_cf_id_table);
-#endif
+MODULE_DECLARE_OF_TABLE(arasan_cf_id_table,
+	{ .compatible = "arasan,cf-spear1340" });
 
 static struct platform_driver arasan_cf_driver = {
 	.probe		= arasan_cf_probe,
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index da585d2..bac48cd 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -4273,14 +4273,9 @@ static int mv_platform_resume(struct platform_device *pdev)
 #define mv_platform_resume NULL
 #endif
 
-#ifdef CONFIG_OF
-static const struct of_device_id mv_sata_dt_ids[] = {
+MODULE_DECLARE_OF_TABLE(mv_sata_dt_ids,
 	{ .compatible = "marvell,armada-370-sata", },
-	{ .compatible = "marvell,orion-sata", },
-	{},
-};
-MODULE_DEVICE_TABLE(of, mv_sata_dt_ids);
-#endif
+	{ .compatible = "marvell,orion-sata", });
 
 static struct platform_driver mv_platform_driver = {
 	.probe		= mv_platform_probe,
-- 
1.9.1

