Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F14DC00454
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 19:28:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31EBD21556
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 19:28:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="StcCt920"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbfLKT2Q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 14:28:16 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:34444 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729512AbfLKT2Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 14:28:16 -0500
Received: by mail-pg1-f201.google.com with SMTP id w9so13216630pgl.1
        for <linux-crypto@vger.kernel.org>; Wed, 11 Dec 2019 11:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BQ5LiziZTeureblMPRNhovCXqRNggUJSXGHiPxM/c88=;
        b=StcCt920kwcBiRwjrKhZVZfcXqvWzoL3r1mwj2A85X1Yzs5qM8b3iyK84qRp1Xs7T8
         nonSRsmF7cm63RO7uct7RtsbWnUsWtpfdrSHZzQ5zS4F6ADqcm1oFinW9wAv5SasTErQ
         MbFuILnpIJvsikvuajGp2juGxrDNIc6Y9702aa9/ARewgVsP/aeyorCc5ciRsoVa+P+S
         jgzoQubZJPDR6o9WZ7klrN/MziCbEzYK3VfkZ6aZIz/KmnfZMnp48dBZHtQd4Io2p8H2
         A+irmwTtNlu7mnTiIFdtxGrws8OgfJF8cloRZedpWGR4jWGaDBnpNtYboiUcc2WnzzjQ
         fJ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BQ5LiziZTeureblMPRNhovCXqRNggUJSXGHiPxM/c88=;
        b=XuIbVdz9xCKiTE1bZJZ9xagG8BRHKPpIMROypBvAufyGX9gmJcHvVqNsOU19VuHNjp
         1B6ghJ+D5w7/QBHUocw1TN6QtXxlEYde/Y7do86VlWh8dy/DORvOQ+RLUc03crCsDiZV
         oa8I8JNmhUL2vWjpvAPVJlwhCoZNL6HNP6fGz/pfYZ+xMyrjV3+9fCnrbgcvnnfU25WZ
         SQzrzc59CEqCJXzvb8MNoEIqgNzhFCUKt1BRWL7o/xKCLtd4iVprVZojtDbULyyYOb/D
         LSMvIcuxmKIrLgf+sEwM41qvr4ZZRnJhxwnnjwh7bHic/bdDk5UZjcP2WHSWhWLIwfKP
         u/yA==
X-Gm-Message-State: APjAAAWToc5PZEuoRAbKgQcp66Bu1UXTf+Zz47ePx4dy8G+y01ijHeoS
        8jirag6u0+GekLgkxtLU7NuARgLoXHQrXRkbBegxZA==
X-Google-Smtp-Source: APXvYqwHq1wPbJfX1P3di6U0QGKesenIIwA8rNjsA9QoHqtRWhSBzb50nACoOAVrlh871zgnanIejWFROnewubWK71T6wg==
X-Received: by 2002:a63:1756:: with SMTP id 22mr6056384pgx.109.1576092495090;
 Wed, 11 Dec 2019 11:28:15 -0800 (PST)
Date:   Wed, 11 Dec 2019 11:27:39 -0800
In-Reply-To: <20191211192742.95699-1-brendanhiggins@google.com>
Message-Id: <20191211192742.95699-5-brendanhiggins@google.com>
Mime-Version: 1.0
References: <20191211192742.95699-1-brendanhiggins@google.com>
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH v1 4/7] crypto: inside-secure: add unspecified HAS_IOMEM dependency
From:   Brendan Higgins <brendanhiggins@google.com>
To:     jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     linux-um@lists.infradead.org, linux-kernel@vger.kernel.org,
        davidgow@google.com, Brendan Higgins <brendanhiggins@google.com>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently CONFIG_CRYPTO_DEV_SAFEXCEL=y implicitly depends on
CONFIG_HAS_IOMEM=y; consequently, on architectures without IOMEM we get
the following build error:

ld: drivers/crypto/inside-secure/safexcel.o: in function `safexcel_probe':
drivers/crypto/inside-secure/safexcel.c:1692: undefined reference to `devm_platform_ioremap_resource'

Fix the build error by adding the unspecified dependency.

Reported-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
---
 drivers/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 91eb768d4221a..0a73bebd04e5d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -716,7 +716,7 @@ source "drivers/crypto/stm32/Kconfig"
 
 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
-	depends on OF || PCI || COMPILE_TEST
+	depends on (OF || PCI || COMPILE_TEST) && HAS_IOMEM
 	select CRYPTO_LIB_AES
 	select CRYPTO_AUTHENC
 	select CRYPTO_SKCIPHER
-- 
2.24.0.525.g8f36a354ae-goog

