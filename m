Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B7FC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 13:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 333F66115C
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 13:57:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhJ2OA0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 10:00:26 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:53862 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230495AbhJ2OAX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 10:00:23 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19TDDAoE031422;
        Fri, 29 Oct 2021 15:57:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=selector1;
 bh=3nPicLVOl2aSkfsU0TRSpPtChIqVQ03FJiPNFD12SEA=;
 b=uLCy2Fso+L/lpAIyvWP60lQm1sCCBg8FUKFKGEo5KOrU57BFprpWyoox3tQd6YheA2y8
 U4D918j8nqFWZg/npBgOlfMpdkE5ZyjRZHBB7SddEmz7Q4ybaJgh9kGaHWz2inwk0AED
 7fsKw/fyOacpmYmzlS5w6c2w+cgPcQI0cUQIspm2Ue6oKXdP1dslm/Lxq+DxZNsqw2HZ
 5wlRhnbMkXjVfwwVQneiHdnZy3A0j1QZGkMfIzlItMQLrQ9T19LTD6zcnLKveA51nFFl
 XP+UYrAVOkXN7/UwakZUiIz2ObthyZvG9EO/aKO0ZhoNUwdoAXLorsCrsW9Z2nCTJBxo iQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 3c0c4y2f7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Oct 2021 15:57:43 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 888E7100034;
        Fri, 29 Oct 2021 15:57:42 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 7FD3D24C745;
        Fri, 29 Oct 2021 15:57:42 +0200 (CEST)
Received: from localhost (10.75.127.49) by SFHDAG2NODE2.st.com (10.75.127.5)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 29 Oct 2021 15:57:41
 +0200
From:   Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
CC:     Marek Vasut <marex@denx.de>,
        Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/8] crypto: stm32/cryp - reorder hw initialization
Date:   Fri, 29 Oct 2021 15:54:54 +0200
Message-ID: <20211029135454.4383-9-nicolas.toromanoff@foss.st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211029135454.4383-1-nicolas.toromanoff@foss.st.com>
References: <20211029135454.4383-1-nicolas.toromanoff@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.49]
X-ClientProxiedBy: SFHDAG2NODE1.st.com (10.75.127.4) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_03,2021-10-29_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The CRYP IP checks the written key depending of the configuration, it's
safer to write the whole configuration then the key to avoid unexpected
behavior.

Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 39 ++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 54e19cbe35c9..25d0147012cb 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -232,6 +232,11 @@ static inline int stm32_cryp_wait_busy(struct stm32_cryp *cryp)
 			!(status & SR_BUSY), 10, 100000);
 }
 
+static inline void stm32_cryp_enable(struct stm32_cryp *cryp)
+{
+	writel_relaxed(readl_relaxed(cryp->regs + CRYP_CR) | CR_CRYPEN, cryp->regs + CRYP_CR);
+}
+
 static inline int stm32_cryp_wait_enable(struct stm32_cryp *cryp)
 {
 	u32 status;
@@ -534,9 +539,6 @@ static int stm32_cryp_hw_init(struct stm32_cryp *cryp)
 	/* Disable interrupt */
 	stm32_cryp_write(cryp, CRYP_IMSCR, 0);
 
-	/* Set key */
-	stm32_cryp_hw_write_key(cryp);
-
 	/* Set configuration */
 	cfg = CR_DATA8 | CR_FFLUSH;
 
@@ -562,23 +564,36 @@ static int stm32_cryp_hw_init(struct stm32_cryp *cryp)
 	/* AES ECB/CBC decrypt: run key preparation first */
 	if (is_decrypt(cryp) &&
 	    ((hw_mode == CR_AES_ECB) || (hw_mode == CR_AES_CBC))) {
-		stm32_cryp_write(cryp, CRYP_CR, cfg | CR_AES_KP | CR_CRYPEN);
+		/* Configure in key preparation mode */
+		stm32_cryp_write(cryp, CRYP_CR, cfg | CR_AES_KP);
 
+		/* Set key only after full configuration done */
+		stm32_cryp_hw_write_key(cryp);
+
+		/* Start prepare key */
+		stm32_cryp_enable(cryp);
 		/* Wait for end of processing */
 		ret = stm32_cryp_wait_busy(cryp);
 		if (ret) {
 			dev_err(cryp->dev, "Timeout (key preparation)\n");
 			return ret;
 		}
-	}
 
-	cfg |= hw_mode;
+		cfg |= hw_mode | CR_DEC_NOT_ENC;
 
-	if (is_decrypt(cryp))
-		cfg |= CR_DEC_NOT_ENC;
+		/* Apply updated config (Decrypt + algo) and flush */
+		stm32_cryp_write(cryp, CRYP_CR, cfg);
+	} else {
+		cfg |= hw_mode;
+		if (is_decrypt(cryp))
+			cfg |= CR_DEC_NOT_ENC;
 
-	/* Apply config and flush (valid when CRYPEN = 0) */
-	stm32_cryp_write(cryp, CRYP_CR, cfg);
+		/* Apply config and flush */
+		stm32_cryp_write(cryp, CRYP_CR, cfg);
+
+		/* Set key only after configuration done */
+		stm32_cryp_hw_write_key(cryp);
+	}
 
 	switch (hw_mode) {
 	case CR_AES_GCM:
@@ -606,9 +621,7 @@ static int stm32_cryp_hw_init(struct stm32_cryp *cryp)
 	}
 
 	/* Enable now */
-	cfg |= CR_CRYPEN;
-
-	stm32_cryp_write(cryp, CRYP_CR, cfg);
+	stm32_cryp_enable(cryp);
 
 	return 0;
 }
-- 
2.17.1

