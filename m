Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25832C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 15:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D8E661547
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 15:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhKRPNP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Nov 2021 10:13:15 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:42080 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231443AbhKRPNP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Nov 2021 10:13:15 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AIEtuHw011544;
        Thu, 18 Nov 2021 16:10:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=selector1;
 bh=BWmW5pq/zgV6f3eSDMj8654QBdWPwwPRztBffBxZYkQ=;
 b=VPPpR9uoKDdphLNJIPBMn7i+lG+XGxmPggE1zQa5JVOLZtNjKbupVQLFgwI1RXSnLOkt
 CPi2907BL2G66mglwncSTsRNTChnQGgb2I00GI7L4Pfo3/3j1kHKlNaocFIzQEZkWjIJ
 KmxZh8tz14+Zu9ghpDxPorbpncHd0YTTnqPZfh9OLlq3w05ZbUU0WtnV4bJbrctKG/M4
 x6lEjWyu5F+A3bLxrwuEC6U7G2mZuVEzCa/CADFso3hJEqdg9RPpNYAJStZ6G4h3W3HB
 Nk3nVQlqofbhYLdnMaRzDw68kupXdaLwmUnpG0aMaeB6D6waM2iIvMOW6j3dOeQyCuil CA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3cdcvuvk5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 16:10:00 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 125ED10002A;
        Thu, 18 Nov 2021 16:10:00 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 06651222C87;
        Thu, 18 Nov 2021 16:10:00 +0100 (CET)
Received: from localhost (10.75.127.51) by SFHDAG2NODE2.st.com (10.75.127.5)
 with Microsoft SMTP Server (TLS) id 15.0.1497.26; Thu, 18 Nov 2021 16:09:59
 +0100
From:   Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
CC:     Marek Vasut <marex@denx.de>,
        Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 9/9] crypto: stm32/cryp - reorder hw initialization
Date:   Thu, 18 Nov 2021 16:07:56 +0100
Message-ID: <20211118150756.6593-10-nicolas.toromanoff@foss.st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211118150756.6593-1-nicolas.toromanoff@foss.st.com>
References: <20211118150756.6593-1-nicolas.toromanoff@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.51]
X-ClientProxiedBy: SFHDAG1NODE2.st.com (10.75.127.2) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The CRYP IP checks the written key depending of the configuration, it's
safer to write the whole configuration to hardware then the key to avoid
unexpected key rejection.

Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 39 ++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 9607a06f1a04..5b3f57ed4699 100644
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

