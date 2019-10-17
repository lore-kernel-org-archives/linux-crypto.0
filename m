Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F6FECE58D
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5724A21835
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 19:09:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TSKdUI0M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441359AbfJQTJy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:09:54 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36630 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439259AbfJQTJx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 15:09:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id m18so3689515wmc.1
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 12:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fj7GaQEHFwPReN2e0aPWrIe6zr5UF/KrFtareX92kMM=;
        b=TSKdUI0MuWjqMwXgG8gASCaSHEboRkLURjeiaGdz4+eFKtdh9t8RGtRlsGYv6gTSaF
         BEvSjHI8/sC+Vlg2Ut4Up9UZ4RZSx31Ni17Ck88VyB/8yUY4fv4pl6KRdyGHtqDNdMAm
         DEZzbjpkHDqayq59nTy0H7YM93fX5KaZTU1JsyoVUpYBgetIZp+b1SCIBuWedLIJLPYN
         f3NtHLz7KaEsMaLuyKpREV6Z875N8PzkTXw3H2avAW7e4WAU9LvHZgMUW0op0clhsMvH
         Fa2Df4fdHTAcdCOfCg5k//jk/eTnk5bHGD5QXfuvtdmlBb51tNsqHsc83TSUWHpeDmya
         LgDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fj7GaQEHFwPReN2e0aPWrIe6zr5UF/KrFtareX92kMM=;
        b=NqxSmIM5xHkMKaIWSWjbC7RU5upzWgTYEwc2+xRd1MCvKDNZ1f/AmDb9g5+sp4OHT+
         gSFOLty8L9/JHCVLZd1QFdO9vsDsqO3l7AK8tMZoTI+Hs6YSm8q/bvGYxRl9ePR6lDGA
         BZqAl4zO+3kY72vEKLqfJG1L4f5gXAQWu/1i7otEpWJzjIpS3kdadJ6VKOE9arw0H5LN
         QXwOB7E8bQ6sm1pDSGZcsNLvmRTM9eAtLS3cQsN+Wcno15mpqjvhuCUojCuxQP0iWsar
         rUTIDJMBsz1B/mJvZnt7Yw+0EX+v6v70HFz3NTMYMypW2W7dWuK280twdH72Kbdq6sss
         g+hg==
X-Gm-Message-State: APjAAAU8XnWNP5QwL65g6+4ZtPS6jPYAie1Gmzg7lqpEukRY2RCxkv/M
        BfQc8mbdwWDmx0wqemIx4bSsPpKEBDGjlqYw
X-Google-Smtp-Source: APXvYqypyFBYqyJiM4gA5tD98hw2YFpzBT0zorQx2/vMSraAgguXR+wpZ2gjEGMXL6EaBYPioUJ/AA==
X-Received: by 2002:a1c:a608:: with SMTP id p8mr4083979wme.25.1571339391328;
        Thu, 17 Oct 2019 12:09:51 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:ccb6:e9d4:c1bc:d107])
        by smtp.gmail.com with ESMTPSA id y3sm5124528wro.36.2019.10.17.12.09.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 12:09:50 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v4 01/35] crypto: tidy up lib/crypto Kconfig and Makefile
Date:   Thu, 17 Oct 2019 21:08:58 +0200
Message-Id: <20191017190932.1947-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In preparation of introducing a set of crypto library interfaces, tidy
up the Makefile and split off the Kconfig symbols into a separate file.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/Kconfig      | 13 +------------
 lib/crypto/Kconfig  | 15 +++++++++++++++
 lib/crypto/Makefile | 16 ++++++++--------
 3 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 29472fb795f3..70b4f7b238fc 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -878,9 +878,6 @@ config CRYPTO_SHA1_PPC_SPE
 	  SHA-1 secure hash standard (DFIPS 180-4) implemented
 	  using powerpc SPE SIMD instruction set.
 
-config CRYPTO_LIB_SHA256
-	tristate
-
 config CRYPTO_SHA256
 	tristate "SHA224 and SHA256 digest algorithm"
 	select CRYPTO_HASH
@@ -1019,9 +1016,6 @@ config CRYPTO_GHASH_CLMUL_NI_INTEL
 
 comment "Ciphers"
 
-config CRYPTO_LIB_AES
-	tristate
-
 config CRYPTO_AES
 	tristate "AES cipher algorithms"
 	select CRYPTO_ALGAPI
@@ -1150,9 +1144,6 @@ config CRYPTO_ANUBIS
 	  <https://www.cosic.esat.kuleuven.be/nessie/reports/>
 	  <http://www.larc.usp.br/~pbarreto/AnubisPage.html>
 
-config CRYPTO_LIB_ARC4
-	tristate
-
 config CRYPTO_ARC4
 	tristate "ARC4 cipher algorithm"
 	select CRYPTO_BLKCIPHER
@@ -1339,9 +1330,6 @@ config CRYPTO_CAST6_AVX_X86_64
 	  This module provides the Cast6 cipher algorithm that processes
 	  eight blocks parallel using the AVX instruction set.
 
-config CRYPTO_LIB_DES
-	tristate
-
 config CRYPTO_DES
 	tristate "DES and Triple DES EDE cipher algorithms"
 	select CRYPTO_ALGAPI
@@ -1845,6 +1833,7 @@ config CRYPTO_STATS
 config CRYPTO_HASH_INFO
 	bool
 
+source "lib/crypto/Kconfig"
 source "drivers/crypto/Kconfig"
 source "crypto/asymmetric_keys/Kconfig"
 source "certs/Kconfig"
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
new file mode 100644
index 000000000000..261430051595
--- /dev/null
+++ b/lib/crypto/Kconfig
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0
+
+comment "Crypto library routines"
+
+config CRYPTO_LIB_AES
+	tristate
+
+config CRYPTO_LIB_ARC4
+	tristate
+
+config CRYPTO_LIB_DES
+	tristate
+
+config CRYPTO_LIB_SHA256
+	tristate
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index cbe0b6a6450d..63de4cb3fcf8 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -1,13 +1,13 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-$(CONFIG_CRYPTO_LIB_AES) += libaes.o
-libaes-y := aes.o
+obj-$(CONFIG_CRYPTO_LIB_AES)			+= libaes.o
+libaes-y					:= aes.o
 
-obj-$(CONFIG_CRYPTO_LIB_ARC4) += libarc4.o
-libarc4-y := arc4.o
+obj-$(CONFIG_CRYPTO_LIB_ARC4)			+= libarc4.o
+libarc4-y					:= arc4.o
 
-obj-$(CONFIG_CRYPTO_LIB_DES) += libdes.o
-libdes-y := des.o
+obj-$(CONFIG_CRYPTO_LIB_DES)			+= libdes.o
+libdes-y					:= des.o
 
-obj-$(CONFIG_CRYPTO_LIB_SHA256) += libsha256.o
-libsha256-y := sha256.o
+obj-$(CONFIG_CRYPTO_LIB_SHA256)			+= libsha256.o
+libsha256-y					:= sha256.o
-- 
2.20.1

