Return-Path: <SRS0=y31I=WC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B08C41514
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 08:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C849208C3
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 08:48:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CUmRP+iQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732197AbfHFIs7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Aug 2019 04:48:59 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39510 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730068AbfHFIs6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Aug 2019 04:48:58 -0400
Received: by mail-ed1-f66.google.com with SMTP id m10so81562291edv.6
        for <linux-crypto@vger.kernel.org>; Tue, 06 Aug 2019 01:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=62m5UUmZDXEKny7dNaeClSz/HMOjGJwsnVchvvDoSqc=;
        b=CUmRP+iQKqoERC4MOKh6WNNjIZ4ExaCQ5zHlbu0lyz+eH06E//UiY+YTtsDYhFFCAY
         aefN3seA8FQqMxSiZXI91/TJa1z3OulK7fBAisqdD167AQnjrJOem1PF4cD9Kko3jlSJ
         kSye1rQTDB27XY9F/iD9NWTjA3Oa90V4IfRbehpWJTGEx4dtjIjVxVbDtWJMS6x8NaZQ
         trCRbqOVLJewtzZmXdo8VWjBsC7okREyKHCMyUi78bbFPpDuu3Y7k8ZljlgZhEjU9EU3
         48yXmEMFcXexD3HjIKRdApFvfn2ARFoCh0AV6jhqYosmeAueQw1JVVNNiE4xzcSohIwJ
         iJ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=62m5UUmZDXEKny7dNaeClSz/HMOjGJwsnVchvvDoSqc=;
        b=bTnUbqNuDYtogMaihpeGLHOdL3s833t9Nc+YXv2oeJYKzYc2k2tFtTxvNIJfDndx1A
         mDRJG+Y4kcVWA0az9zSqtYqnMIjczcCDNKgS4iTuV5yFVuLkDBWQi0DOcOHh4a8WAQ7v
         ooJfgFEbIS4ACSysLCB3LQPq8BPweQVBk82pAt3KDm6GG0XNsFAskMzKVLzCULF/taTZ
         MgVNCvuobtwwDjppSs8RbwGFHESMIIFT+nwxH7qMZ62hDFmDFixWo7bZCqezJy+XOAR3
         v9zux7NO320Kf05rH2roIIGnCZIACSg8+3Q4NSEvyryxHNdEg12nELzt+aNhj3k5FVWY
         rADw==
X-Gm-Message-State: APjAAAW9zryrykeOawv+iMGSGKX7zEgk66ixe7yF7kxVs3g0VI+aIy2E
        3hcueCEE5U6kQuwPF9FTmrmtdJzz
X-Google-Smtp-Source: APXvYqwh4Z6AgmDiF8z1niHNUN/9sx0v4mHgbvL6ox5aZiSaUbM7iPr6RXxR4gQndsUPFOqPAqMYbA==
X-Received: by 2002:a17:906:6a54:: with SMTP id n20mr2101280ejs.232.1565081336938;
        Tue, 06 Aug 2019 01:48:56 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id f21sm19980304edj.36.2019.08.06.01.48.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 01:48:56 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv4 1/4] crypto: inside-secure - make driver selectable for non-Marvell hardware
Date:   Tue,  6 Aug 2019 09:46:23 +0200
Message-Id: <1565077586-27814-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1565077586-27814-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1565077586-27814-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

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
