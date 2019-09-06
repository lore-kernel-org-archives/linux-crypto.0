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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 071C6C43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 09:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D16B620854
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 09:10:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WExYa/yE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403832AbfIFJKL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 05:10:11 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42527 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403827AbfIFJKL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 05:10:11 -0400
Received: by mail-ed1-f65.google.com with SMTP id y91so5619234ede.9
        for <linux-crypto@vger.kernel.org>; Fri, 06 Sep 2019 02:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MGmeupxk6Bp7p14nHOmC1DWeMYM0J5Ar6vQEt8f6JL0=;
        b=WExYa/yEbmzqWBtyCPNeCVt+vlidLZDZQLQOqD6RUcmYnZO6za3KSO7pVCnlsjqRV2
         vpqXnygWVyC90B/HxH2bpN/5/7HhGFVMMHojQdnzXklCvP4Lga7z/WJgJ8l6B08afiuP
         eGPCiRp3JoGD468NLI3YorjGQkuj9PRkS1obB1l5tMw4VB8YDZkOqaphRzgFnGyIUN/n
         QrLvZLD0rsvzi9+XoG1y8MZIGWPmDC6ZihNkHdPDVi4ziV5HYkMfLp9vYGVVOEDPsVB9
         7xon2JGxlZYQufl1SJDdlGSOksK9+F+Z8C6HcPqLGhmyCH2aYywxj+/jGsAYqFgW1G2K
         L58A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MGmeupxk6Bp7p14nHOmC1DWeMYM0J5Ar6vQEt8f6JL0=;
        b=UdSOBIAbFjG5JpJDbVdn2hQ3mr0uVaAt/H7AC4rpH0WmXiBeyd8S0VMSU2SljYR6tn
         AOFhZyu1gJ2oNLgXQOlk0EIqYajg7hDTFOFguQDIJQpGsOzLjcgN+pjJ3akC6ZrWFkWL
         Rgy9HKFAP7S6j+KoqIy5i9Hs4CVDjYdiQroS9EHtyym3F0bCnRHFfHzWUTqCpbtOE+iP
         oB3YcJ0SSXN27gGkQbNd01o26C1rr0QlQAzi47MjRi+0gLSRoItszYMrc5gPRU7N0zmb
         D/ccMzwK8uBQ9GBy8vLPDsZoZlo+uAt0LJfcjshilDKxpvet0GEeNqj+/eLPVs4nsfM8
         7qZg==
X-Gm-Message-State: APjAAAWLe8We4OpsLOnCnHnLVL8V9UkTrkpyEYLe9EijW4HVu5mKNPDC
        ldxLjKv7g8JeJ3a5XlD0W1i7NCPQ
X-Google-Smtp-Source: APXvYqygprkBvI92+HdpKG85iHo/9VR2HTb0ehxjdUywsdI4365OfUAUhCkaT/6AtdiB0/aMPYVwlQ==
X-Received: by 2002:a17:906:4c81:: with SMTP id q1mr6424960eju.185.1567761009482;
        Fri, 06 Sep 2019 02:10:09 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id z26sm499672ejb.51.2019.09.06.02.10.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 02:10:08 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv2] crypto: inside-secure - Fix unused variable warning when CONFIG_PCI=n
Date:   Fri,  6 Sep 2019 10:07:23 +0200
Message-Id: <1567757243-16598-1-git-send-email-pvanleeuwen@verimatrix.com>
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

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index e12a2a3..2331b31 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1505,29 +1505,29 @@ static int __init safexcel_init(void)
 {
 	int rc;
 
-#if IS_ENABLED(CONFIG_OF)
-		/* Register platform driver */
-		platform_driver_register(&crypto_safexcel);
+#if IS_ENABLED(CONFIG_PCI)
+	/* Register PCI driver */
+	rc = pci_register_driver(&safexcel_pci_driver);
 #endif
 
-#if IS_ENABLED(CONFIG_PCI)
-		/* Register PCI driver */
-		rc = pci_register_driver(&safexcel_pci_driver);
+#if IS_ENABLED(CONFIG_OF)
+	/* Register platform driver */
+	rc = platform_driver_register(&crypto_safexcel);
 #endif
 
-	return 0;
+	return rc;
 }
 
 static void __exit safexcel_exit(void)
 {
 #if IS_ENABLED(CONFIG_OF)
-		/* Unregister platform driver */
-		platform_driver_unregister(&crypto_safexcel);
+	/* Unregister platform driver */
+	platform_driver_unregister(&crypto_safexcel);
 #endif
 
 #if IS_ENABLED(CONFIG_PCI)
-		/* Unregister PCI driver if successfully registered before */
-		pci_unregister_driver(&safexcel_pci_driver);
+	/* Unregister PCI driver if successfully registered before */
+	pci_unregister_driver(&safexcel_pci_driver);
 #endif
 }
 
-- 
1.8.3.1

