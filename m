Return-Path: <SRS0=GLFy=62=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 450FAC54E8E
	for <linux-crypto@archiver.kernel.org>; Tue, 12 May 2020 14:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D5AD20746
	for <linux-crypto@archiver.kernel.org>; Tue, 12 May 2020 14:13:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="GtlFKoXj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730294AbgELONZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 May 2020 10:13:25 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:26774 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730183AbgELONY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 May 2020 10:13:24 -0400
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04CE2CvQ020028;
        Tue, 12 May 2020 16:11:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=de8DH4LiaffmmWtTVyqpc6yqQovYM+Xegj25cuzjLL4=;
 b=GtlFKoXjBkm/nAmGEUgN68TD4K3F0/REqiBwzS9nz8Bq0F50L9+RuHhHktaANFJinOxr
 zgl0Vrz1kOM4ccadNonFYbvcybuLG0XfkRYwHWk3FXk+j9KaRvUnXnVfJ6m4AaaHYtPD
 cKqQKX9iWQCyWa9Q5qTReV2OgmTLzhGSer2PcGwchp9578VkkszFEmkJFoqyy0x1EFlO
 Tugx4VEU+q4A0b9s8omTP0HKRkATtTIMkiMv5iTjyQGlifbd1c0OmQaqZls4rDPxC/tU
 KpBYtK8ftj2PLLxDU0SWNDOjAghSCJEvnZD3n0xPc9tQSowY0YqqegDYSrEyAgcWJqx3 MA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 30wj9wh0k7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 May 2020 16:11:59 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id D93C1100034;
        Tue, 12 May 2020 16:11:58 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag6node1.st.com [10.75.127.16])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id CD2D52BAE54;
        Tue, 12 May 2020 16:11:58 +0200 (CEST)
Received: from localhost (10.75.127.44) by SFHDAG6NODE1.st.com (10.75.127.16)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 May 2020 16:11:58
 +0200
From:   Nicolas Toromanoff <nicolas.toromanoff@st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
CC:     Nicolas Toromanoff <nicolas.toromanoff@st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] crypto: stm32/crc: don't sleep in runtime pm
Date:   Tue, 12 May 2020 16:11:12 +0200
Message-ID: <20200512141113.18972-5-nicolas.toromanoff@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512141113.18972-1-nicolas.toromanoff@st.com>
References: <20200512141113.18972-1-nicolas.toromanoff@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.44]
X-ClientProxiedBy: SFHDAG3NODE1.st.com (10.75.127.7) To SFHDAG6NODE1.st.com
 (10.75.127.16)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_03:2020-05-11,2020-05-12 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Ensure stm32_crc_update() and stm32_crc_init() can be called
in atomic context and can't sleep.

Add pm_runtime_irq_safe() to make pm_runtime_get_sync() atomic.
Change runtime pm to call clk_enable()/clk_disable() and change
system pm to unprepare/prepare the clock and force runtime pm
suspend/resume.

Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@st.com>
---
 drivers/crypto/stm32/stm32-crc32.c | 45 ++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index 10304511f9b4..413415c216ef 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -297,6 +297,7 @@ static int stm32_crc_probe(struct platform_device *pdev)
 
 	pm_runtime_get_noresume(dev);
 	pm_runtime_set_active(dev);
+	pm_runtime_irq_safe(dev);
 	pm_runtime_enable(dev);
 
 	platform_set_drvdata(pdev, crc);
@@ -350,34 +351,60 @@ static int stm32_crc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int stm32_crc_runtime_suspend(struct device *dev)
+static int __maybe_unused stm32_crc_suspend(struct device *dev)
 {
 	struct stm32_crc *crc = dev_get_drvdata(dev);
+	int ret;
 
-	clk_disable_unprepare(crc->clk);
+	ret = pm_runtime_force_suspend(dev);
+	if (ret)
+		return ret;
+
+	clk_unprepare(crc->clk);
 
 	return 0;
 }
 
-static int stm32_crc_runtime_resume(struct device *dev)
+static int __maybe_unused stm32_crc_resume(struct device *dev)
 {
 	struct stm32_crc *crc = dev_get_drvdata(dev);
 	int ret;
 
-	ret = clk_prepare_enable(crc->clk);
+	ret = clk_prepare(crc->clk);
 	if (ret) {
-		dev_err(crc->dev, "Failed to prepare_enable clock\n");
+		dev_err(crc->dev, "Failed to prepare clock\n");
+		return ret;
+	}
+
+	return pm_runtime_force_resume(dev);
+}
+
+static int __maybe_unused stm32_crc_runtime_suspend(struct device *dev)
+{
+	struct stm32_crc *crc = dev_get_drvdata(dev);
+
+	clk_disable(crc->clk);
+
+	return 0;
+}
+
+static int __maybe_unused stm32_crc_runtime_resume(struct device *dev)
+{
+	struct stm32_crc *crc = dev_get_drvdata(dev);
+	int ret;
+
+	ret = clk_enable(crc->clk);
+	if (ret) {
+		dev_err(crc->dev, "Failed to enable clock\n");
 		return ret;
 	}
 
 	return 0;
 }
-#endif
 
 static const struct dev_pm_ops stm32_crc_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
-				pm_runtime_force_resume)
+	SET_SYSTEM_SLEEP_PM_OPS(stm32_crc_suspend,
+				stm32_crc_resume)
 	SET_RUNTIME_PM_OPS(stm32_crc_runtime_suspend,
 			   stm32_crc_runtime_resume, NULL)
 };
-- 
2.17.1

