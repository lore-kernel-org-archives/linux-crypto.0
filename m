Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33F24C43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 16:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 094FA2082C
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 16:28:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pFDK4PBq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388884AbfIFQ2B (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 12:28:01 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:38831 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388816AbfIFQ2B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 12:28:01 -0400
Received: by mail-ed1-f68.google.com with SMTP id a23so4584564edv.5
        for <linux-crypto@vger.kernel.org>; Fri, 06 Sep 2019 09:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GBxQqdGqKQQmnBVaQ/8MSrLomaJm+EXicm2DY/hNEiA=;
        b=pFDK4PBqeluMYAXSImVSgI7m5mLBy0bZ7FPHaepL4Kfvsq+k1HZAaFFNyiTIXJ4Qd+
         6tMCLS7qN57PTwYX06IzwM06CqV/Sw5zSFh1V1y94TLmC3MCSNvgwqmVbLKLm3aqQzur
         JiX9sRAPiLVO3K/DajBwKdoobJFXchshluSBjopZv9g2t7YhKXoHTwHXBICheHf3BhuY
         cILL1gJLP7KTzDIY7gkKYXoE8zAK61Wv0ROEEB++PwmoPyKJkcei8ll4rGWBlCQBSjQT
         GJixBwOX0hmyxqXOZXyvtVIXUAFbazFla9T0fjqivmoT2mE0trkcu/tAf9ZQ5NT2ZcMJ
         Xykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GBxQqdGqKQQmnBVaQ/8MSrLomaJm+EXicm2DY/hNEiA=;
        b=XpoS0/Ov+Kn0v2W7zY2LmdxBXUVKByvASknf804X7WCvxoSn8I/zMZhMBtG2S7wH0+
         QsSmDOCeAVNT7wi6l7kcaLFk2u3mJ2/IFU5UnR9y2QGrJy5WCJMV3VViO/oeHKmR5QkM
         M3zhhnjAG7E8lJoh7JKJL4YMjfoUZ4vPYE1bKYoSAvQDXojuWOT3DfSoT24ur80GX7a8
         kcVPVTFb2RKnCffA9c0pUasL3rWoDwVxXBJoQ1Rz8Lfl7hneJbH3Bsv+JhxnXySHQOz6
         2JxvJXtetH2xwDeRaZKT2YHJc1QZO881LxXwdKTWRaZ9HsmPLtME9LpjKUGdk8Brlz1l
         zhxw==
X-Gm-Message-State: APjAAAXSAO+lmqidMt22zpr3kH+YndXRvejP73VyQOFp2ph2iKsXUpoO
        c5jg5on5rPH46AGgMgDSqb+s8h72
X-Google-Smtp-Source: APXvYqy0zYOgU91cwDD858q3UvqB8cMbm/fQ4wIBS03NGesRLO4LmDviVIokc0iq3wRrHL/DF4LXeQ==
X-Received: by 2002:aa7:da90:: with SMTP id q16mr3691040eds.123.1567787279308;
        Fri, 06 Sep 2019 09:27:59 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id a17sm1029902edv.66.2019.09.06.09.27.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 09:27:58 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv3] crypto: inside-secure - Fix unused variable warning when CONFIG_PCI=n
Date:   Fri,  6 Sep 2019 17:25:14 +0200
Message-Id: <1567783514-24947-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes an unused variable warning from the compiler when the
driver is being compiled without PCI support in the kernel.

changes since v1:
- capture the platform_register_driver error code as well
- actually return the (last) error code
- swapped registration to do PCI first as that's just for development
  boards anyway, so in case both are done we want the platform error
  or no error at all if that passes
- also fixes some indentation issue in the affected code

changes since v2:
- handle the situation where both CONFIG_PCI and CONFIG_OF are undefined
  by always returning a -EINVAL error
- only unregister PCI or OF if it was previously successfully registered

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c | 35 ++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index e12a2a3..925c90f 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1501,32 +1501,45 @@ void safexcel_pci_remove(struct pci_dev *pdev)
 };
 #endif
 
-static int __init safexcel_init(void)
-{
-	int rc;
-
+/* Unfortunately, we have to resort to global variables here */
+#if IS_ENABLED(CONFIG_PCI)
+int pcireg_rc = -EINVAL; /* Default safe value */
+#endif
 #if IS_ENABLED(CONFIG_OF)
-		/* Register platform driver */
-		platform_driver_register(&crypto_safexcel);
+int ofreg_rc = -EINVAL; /* Default safe value */
 #endif
 
+static int __init safexcel_init(void)
+{
 #if IS_ENABLED(CONFIG_PCI)
-		/* Register PCI driver */
-		rc = pci_register_driver(&safexcel_pci_driver);
+	/* Register PCI driver */
+	pcireg_rc = pci_register_driver(&safexcel_pci_driver);
 #endif
 
-	return 0;
+#if IS_ENABLED(CONFIG_OF)
+	/* Register platform driver */
+	ofreg_rc = platform_driver_register(&crypto_safexcel);
+	return ofreg_rc;
+#else
+ #if IS_ENABLED(CONFIG_PCI)
+	return pcireg_rc;
+ #else
+	return -EINVAL;
+ #endif
+#endif
 }
 
 static void __exit safexcel_exit(void)
 {
 #if IS_ENABLED(CONFIG_OF)
-		/* Unregister platform driver */
+	/* Unregister platform driver */
+	if (!ofreg_rc)
 		platform_driver_unregister(&crypto_safexcel);
 #endif
 
 #if IS_ENABLED(CONFIG_PCI)
-		/* Unregister PCI driver if successfully registered before */
+	/* Unregister PCI driver if successfully registered before */
+	if (!pcireg_rc)
 		pci_unregister_driver(&safexcel_pci_driver);
 #endif
 }
-- 
1.8.3.1

