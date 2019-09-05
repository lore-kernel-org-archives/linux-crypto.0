Return-Path: <SRS0=9BFZ=XA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA0EEC3A5A5
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Sep 2019 07:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 736DD2145D
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Sep 2019 07:04:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qdtQE5nJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730232AbfIEHED (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Sep 2019 03:04:03 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33574 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfIEHED (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Sep 2019 03:04:03 -0400
Received: by mail-ed1-f68.google.com with SMTP id o9so1634331edq.0
        for <linux-crypto@vger.kernel.org>; Thu, 05 Sep 2019 00:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Jdhap2icUziaajE2ldWSGxYhka3RvNnmGxB0DDef5z8=;
        b=qdtQE5nJnXPieIVfswRiAcMkHnFYXZ5SuDdYHZJJEg7JByR0AKhzR4AgK6c89ale92
         NsEsYSFp0lpxTMsjugkR0bbWRuhRL98NGonH0aYfhUHDVLZBOgJHF65x/I4r1kSr0HsI
         ayWY9TeG3/c1KpfykZlK7HCq6v1bjaJXo6skQZyl9WqUEhZ+Z4ILjpzzbb2hZBVeD/Z5
         8uGW+nAJUKQx4apoiv0WvMMpvX9ezcMbks36GVLnMHrb000vO189liwsMxrkAtY/nEhw
         UtfIlvqP1gAJGhoEjUSCdG+5y1Qfh/pYCyImUq+u8XBWCzWgA2M41c5iJ8Br9wTecGa2
         mgSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Jdhap2icUziaajE2ldWSGxYhka3RvNnmGxB0DDef5z8=;
        b=heQuToLlYD4rNoBEN6lmXVv7eGv47dRXs27tLdTc8y8lrHivj16FwJRjxWblppVfmr
         66ID2qrtIXE+QscCcGFt6vHFa6Ks3mQAYuxVqolNkZBK27cTqM8iX6GdMcDRf7eNdZhF
         A5Z59t9vFAzpsUAu/mb/aCgElCSCqWlDRGaGhXjIfUiCbsUzAlVAAIKD3mSbDjX4qsXi
         WGN4bg9fu0uYD6p0npabHZciNnosBPs/B4TcL52NEHMX1mMRqnN4l94Hz599opQrOSU/
         ZHEFUzJ2ikPFPQe75zdZ1jY4ES5JWe1rbCitSvacFoybY33mJHKWaerPAsTOs5yjNSjz
         9agQ==
X-Gm-Message-State: APjAAAUTEdkbGMCXvhQ+Bk9tp89pEO770AYjC7932eWusDUzmOrbjT4N
        /sC/1IZGb0aMJcZPB8/1wnSQyWc8
X-Google-Smtp-Source: APXvYqzfE7tg1iE8nxlZtdLJ0kexX3STgj5yEYWn5kJKxhFUkspDw+PPhZ643nKiVj91aTSuJQYB2w==
X-Received: by 2002:a05:6402:1450:: with SMTP id d16mr2078819edx.198.1567667041447;
        Thu, 05 Sep 2019 00:04:01 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id c97sm233998edf.31.2019.09.05.00.04.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 00:04:00 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH] crypto: inside-secure - Fix unused variable warning when CONFIG_PCI=n
Date:   Thu,  5 Sep 2019 08:01:13 +0200
Message-Id: <1567663273-6652-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes an unused variable warning from the compiler when the
driver is being compiled without PCI support in the kernel.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index e12a2a3..0f1a9dc 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1503,7 +1503,9 @@ void safexcel_pci_remove(struct pci_dev *pdev)
 
 static int __init safexcel_init(void)
 {
+#if IS_ENABLED(CONFIG_PCI)
 	int rc;
+#endif
 
 #if IS_ENABLED(CONFIG_OF)
 		/* Register platform driver */
-- 
1.8.3.1

