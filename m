Return-Path: <SRS0=LpGJ=WP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F3F7C3A5A2
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 15:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D867422CE2
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 15:43:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mn7vmHka"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfHSPnH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Aug 2019 11:43:07 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39648 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfHSPnH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Aug 2019 11:43:07 -0400
Received: by mail-ed1-f66.google.com with SMTP id g8so2077498edm.6
        for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2019 08:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=r5UtL9bMxtbO0TzrusY/CMHauNafZ//1SU8oYtrr2eQ=;
        b=Mn7vmHkaz1ADfl/pNMEihs+/AO1sqPNehK7OzyabXt+2crUL55ggouKZyqXKZ6LsBq
         1MioPV0lZwCOothmSlYT5UVEYMT8yEL9DDAVq6CkzSAuac1adfbbdGMg7eStKj1hqUfK
         ANkCYTL8zrBnioxnKbwyq0az+KHh1Nfw8J358IuqnsHdAFdrNq4FXOkDZUCYez7YaLnI
         6IQkipp6Z69F04icNM8tJiXl5GU/3aezI7GNaommM24Nv+uHlQDeD5e4WnIuhOgswI6r
         YTO8RG0vtldwp0hS+vO8gvp42rSqkOngHHdigXlbWDPHT1Qp7v48BoMMBb4mIQBoSHrK
         MXDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=r5UtL9bMxtbO0TzrusY/CMHauNafZ//1SU8oYtrr2eQ=;
        b=VtWOEn3LIzBRKZJ2kfUuC4k34Rtvq7aacd3kKys4zzyEzhl9NMFk8KAXFCLQiryly/
         rerhM72+LA3QmB0m/+9LlS7zYE+ynGW/ZiobZA2W0g0W3hm1bncitWmKikg6x5Fykg+b
         egixkq0iaVyzKAb+Mvwr0mmp+mcU5yX4OBZeyeuikwMZmdxKCEj30Y1t8xzEHReXowUF
         s9opt2bEXqvg3Yy0VDQnRipJY6hhQcDbsjgqnFdU5hYhTblQUmu/eXf+CGOSvzu4Ds22
         kno9T6gJnq6qFjZon56xCaBfCvfESX3MULcT08XEaHrim5ONX9+YQTSvTGmKuO2Bvyjy
         FQYA==
X-Gm-Message-State: APjAAAVN2XjnL0qi0Kvs2KbArJ4MULLXxWGj40jlFe/ojCr7SBdr/0uM
        mk1hXmB+Y09waun5hkornNpl3u0o
X-Google-Smtp-Source: APXvYqy5vaKacjZ3Mhxak3NE0yIHlk4XA5MOxg1OaZORDwN85r/lT9Ecaov3cBdjs1yGxSGDXyMOzw==
X-Received: by 2002:aa7:c64c:: with SMTP id z12mr25943784edr.146.1566229385961;
        Mon, 19 Aug 2019 08:43:05 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id h10sm2891095edh.64.2019.08.19.08.43.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 08:43:05 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@insidesecure.com>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv5 1/4] crypto: inside-secure - make driver selectable for non-Marvell hardware
Date:   Mon, 19 Aug 2019 16:40:23 +0200
Message-Id: <1566225626-10091-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566225626-10091-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1566225626-10091-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>

While being a generic EIP97/EIP197 driver, the driver was only selectable
for Marvell Armada hardware. This fix makes the driver selectable for any
Device Tree supporting kernel configuration, allowing it to be used for
other compatible hardware by just adding the correct device tree entry.

It also allows the driver to be selected for PCI(E) supporting kernel con-
figurations, to be able to use it with PCIE based FPGA development boards
for pre-silicon driver development by both Inside Secure and its IP custo-
mers.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Acked-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/Kconfig | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index b8c5087..7bc0cdf 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -717,8 +717,7 @@ source "drivers/crypto/stm32/Kconfig"

 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
-	depends on OF
-	depends on (ARM64 && ARCH_MVEBU) || (COMPILE_TEST && 64BIT)
+	depends on OF || PCI || COMPILE_TEST
 	select CRYPTO_LIB_AES
 	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
@@ -730,10 +729,11 @@ config CRYPTO_DEV_SAFEXCEL
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
 	help
-	  This driver interfaces with the SafeXcel EIP-197 cryptographic engine
-	  designed by Inside Secure. Select this if you want to use CBC/ECB
-	  chain mode, AES cipher mode and SHA1/SHA224/SHA256/SHA512 hash
-	  algorithms.
+	  This driver interfaces with the SafeXcel EIP-97 and EIP-197 cryptographic
+	  engines designed by Inside Secure. It currently accelerates DES, 3DES and
+	  AES block ciphers in ECB and CBC mode, as well as SHA1, SHA224, SHA256,
+	  SHA384 and SHA512 hash algorithms for both basic hash and HMAC.
+	  Additionally, it accelerates combined AES-CBC/HMAC-SHA AEAD operations.

 config CRYPTO_DEV_ARTPEC6
 	tristate "Support for Axis ARTPEC-6/7 hardware crypto acceleration."
--
1.8.3.1
