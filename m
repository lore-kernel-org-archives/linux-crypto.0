Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B01BDC32751
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 16:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 887AC208E3
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 16:28:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RftsDc4a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfGaQ2G (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 12:28:06 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37039 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727276AbfGaQ2G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 12:28:06 -0400
Received: by mail-ed1-f67.google.com with SMTP id w13so66288418eds.4
        for <linux-crypto@vger.kernel.org>; Wed, 31 Jul 2019 09:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GZzETjCzVKfk0dZv0dMENfsE8Hc9LWkRxjer/Y0hixk=;
        b=RftsDc4ao6I+BZOa/Mw9+wlPhEi3UGX1rvS5t9nf71GOPWQhsS3ScoELVne0983kqP
         DbTwIZq3byFOkLf7wjL2v/KMQEfy/DcIGTWP1mZ+3Do9JHPUaD0zl0Cm9Z7KNwqBSnuY
         Gjmrh2Vrpbivj1kC3tZemm3HZrL45H0ljuxlC38w5fZ6G8+VBKNY1OFEAmRLq+UudM4E
         GKzHCjwQDhkQo2nbM+4JYUW3C1KNZW9X2joLEqZj61doHcTG/z0UyJeY/IYuC5Li9POv
         XeoY1vurz1p4al75F3KyYiwc/LU/x0X1oq4Kv/xDf1r9UTE3pxCFXmI7KaAKQjQ5Aqgn
         iPNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GZzETjCzVKfk0dZv0dMENfsE8Hc9LWkRxjer/Y0hixk=;
        b=RNK1pJzDOtQ0X1uRh9m8mBj+wQJUTs1dKhSLY7xfvm3e+pnQjpVQ70EUem3WtHAbPx
         YK8wnE6BMQEZDlEYg6rkDhl8EcKNFVzyhGSboFXZFuvcgOxAPVAq86ewqmf9KV6B3vxm
         lgKSwI5c2Gpgg1y8nHaQ8r3nLHFu+qxPYaHezqTZFXleG162V8n5qw7VT3vrXVIGA1Fb
         GfYQre6MTlDc1RGI40sbSl3JHr1clGbJI4smOnNobOSlNMO/7HA1/FMx5B54puch59mN
         AIfp4PPZucUL1iaz2EUSlccNbbYPiEp8zbgx8VavkmXjT0Yi1YdXsfMfJofoSTve5asO
         1xGg==
X-Gm-Message-State: APjAAAUDBvZrxKwBILvB2GFWpFVw2BkzanBJ3F5qHzDmE9J+L1HnVwZQ
        rTpESVlmQeJt04ZE7TueDZLf225y
X-Google-Smtp-Source: APXvYqzgQmd0Q33OF917TGtmxD8P/re1RCZnxPBkw8qa0WA1be0fXv6NKBQ6+KRZ3dvd7gx8CAc1Aw==
X-Received: by 2002:a50:ad2c:: with SMTP id y41mr105824356edc.300.1564590484177;
        Wed, 31 Jul 2019 09:28:04 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id w35sm17418264edd.32.2019.07.31.09.28.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 09:28:03 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@insidesecure.com>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 1/4] crypto: inside-secure - make driver selectable for non-Marvell hardware
Date:   Wed, 31 Jul 2019 17:25:27 +0200
Message-Id: <1564586730-9629-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564586730-9629-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1564586730-9629-1-git-send-email-pvanleeuwen@verimatrix.com>
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
---
 drivers/crypto/Kconfig | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 67af688..0d9f67d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -716,8 +716,7 @@ source "drivers/crypto/stm32/Kconfig"
 
 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
-	depends on OF
-	depends on (ARM64 && ARCH_MVEBU) || (COMPILE_TEST && 64BIT)
+	depends on OF || PCI || COMPILE_TEST
 	select CRYPTO_AES
 	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
@@ -729,10 +728,11 @@ config CRYPTO_DEV_SAFEXCEL
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

