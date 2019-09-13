Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D4AC49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 10:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2451E2084F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 10:07:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uXotKb6M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbfIMKHa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 06:07:30 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37762 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfIMKHa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 06:07:30 -0400
Received: by mail-ed1-f68.google.com with SMTP id i1so26588276edv.4
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2019 03:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tU5cL9TavpPs/k5dGVuheOnzB9rD9U2NJsZT+9lbT9Q=;
        b=uXotKb6MUMXYEOJtJssU06XYONreyLQgBHjw/TAKfuaNG9yaRYGeSlYFAhWRS4hwxr
         fRx9NFGVwd41lmyPJ1E1b1Jc4gg6VMrHMg3jZqtpGpuOj9FsgMPwLEmkWZP8ku1lXyDQ
         0ZyPsyYrOXrBVTafH1UtAJSZi7O967uoCUruB+nqTm8Lw7Ag7eanHY2HXcOZ1yZBRddY
         yflniyoTVVsL01cp+EymQCI0zI2346WloM6csRQTWNPGZDiTQZqKPnxszAhakTKp//xR
         Sjl3pyjl5LLKkzg7HGg1OYuXzgm7H33i2Ecba2Cp9X5pkJZtqqmwcXbMZHb9vE6jyScK
         6MlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tU5cL9TavpPs/k5dGVuheOnzB9rD9U2NJsZT+9lbT9Q=;
        b=r6dElQ5wOv5F280Bv/2LdqaYa2hhrCm/uBRr3vyvgu1EwxA/2O+ntn2mIXmCxw35ZQ
         GrR/m7cF5q+9VGzaaXpw3i6PAgTD5R9oiitbk1einNWQGQ2/H0nk+fFvdTJzpxxLJGDl
         +Y46i4l4WdSvXyIBfk03ImfuPxd4t5YVK3RWNHW0jEbdqIyiEWmgo+F4LfLQQmesdBeq
         rlSnITdxxH1anaSf6Wvn8fUej60eCpbHuhU+jLR6vOdDhj3OeCoS9Iq8DG/Zzk8zfD0C
         3RzwcojS6SgXx3ahLOmNytu7tD0vnFSjFENEh5EPvBfqhXCbf2/a+U7YaMgIXLul6X9P
         sx1g==
X-Gm-Message-State: APjAAAWGvg5X+kAFEJLGrK8Ke7ZAW0CfP41j0/e5NS2vFG6IZnRYGMwE
        ENaBDzJYA4QwAjUj7CdaVsnNKRS/
X-Google-Smtp-Source: APXvYqybdvYtb8BsCjxctopghvR8CRpzlCthIuzIt8QpDR8VZ/Z/seXpjMxtru+T+1jiP9s9bjXEnA==
X-Received: by 2002:a17:906:7e44:: with SMTP id z4mr38181134ejr.290.1568369247596;
        Fri, 13 Sep 2019 03:07:27 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id bm1sm5264766edb.29.2019.09.13.03.07.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 03:07:26 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv4] crypto: inside-secure - Fix unused variable warning when CONFIG_PCI=n
Date:   Fri, 13 Sep 2019 11:04:40 +0200
Message-Id: <1568365480-7700-1-git-send-email-pvanleeuwen@verimatrix.com>
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

changes since v3:
- if *both* PCI and OF are configured, then return success if *either*
  registration was OK, also ensuring exit is called and PCI unregister
  occurs (eventually) if only OF registration fails

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c | 40 ++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index e12a2a3..5abe8b6 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1501,32 +1501,50 @@ void safexcel_pci_remove(struct pci_dev *pdev)
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
+ #if IS_ENABLED(CONFIG_PCI)
+	/* Return success if either PCI or OF registered OK */
+	return pcireg_rc ? ofreg_rc : 0;
+ #else
+	return ofreg_rc;
+ #endif
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

