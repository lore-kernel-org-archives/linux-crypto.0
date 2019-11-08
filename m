Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78588C5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DA6D218AE
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573215785;
	bh=yaOc1cHYxbFoRQOzSBjVeoqMkfvyVlhaVaw8XkycsFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=uRVgGCyJ8XeDmG+YT3mQcAqlGpWpi89IzhXEASVnrN8AmwkeE5RliY/wnD/nacsLm
	 74u5NPzkfOz5s9JQvwToIzA1mn1jCOwnm9TH2hk4ADXsHCA4kNEyG+JpKASpbWb4ou
	 bp+Ss8mjbyOmtUbvKbN8HoB6m0QU3e9p1R7B3xuw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732085AbfKHMXE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:23:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:37550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727598AbfKHMXE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 07:23:04 -0500
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 442BD21924;
        Fri,  8 Nov 2019 12:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573215783;
        bh=yaOc1cHYxbFoRQOzSBjVeoqMkfvyVlhaVaw8XkycsFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qwq6NCI5M3B/pWJK3q5JuXu7SSaas/sG/59Sw7IHpxxnW7MzGRojc9/MeWK2/X9xG
         2xpxTmafKMWr+/J2Ad7//LNLlXm+VAVeA1HHFxgNL8G4pvwphk0l+aJpfE6PblLuSm
         A0RhIoRs0QdT6L+FjZyyJvJGIgB3sZ5wM22gdBXs=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v5 01/34] crypto: tidy up lib/crypto Kconfig and Makefile
Date:   Fri,  8 Nov 2019 13:22:07 +0100
Message-Id: <20191108122240.28479-2-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108122240.28479-1-ardb@kernel.org>
References: <20191108122240.28479-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In preparation of introducing a set of crypto library interfaces, tidy
up the Makefile and split off the Kconfig symbols into a separate file.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/Kconfig      | 13 +------------
 lib/crypto/Kconfig  | 15 +++++++++++++++
 lib/crypto/Makefile | 16 ++++++++--------
 3 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index b021b6374d9e..9def945e9549 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -895,9 +895,6 @@ config CRYPTO_SHA1_PPC_SPE
 	  SHA-1 secure hash standard (DFIPS 180-4) implemented
 	  using powerpc SPE SIMD instruction set.
 
-config CRYPTO_LIB_SHA256
-	tristate
-
 config CRYPTO_SHA256
 	tristate "SHA224 and SHA256 digest algorithm"
 	select CRYPTO_HASH
@@ -1036,9 +1033,6 @@ config CRYPTO_GHASH_CLMUL_NI_INTEL
 
 comment "Ciphers"
 
-config CRYPTO_LIB_AES
-	tristate
-
 config CRYPTO_AES
 	tristate "AES cipher algorithms"
 	select CRYPTO_ALGAPI
@@ -1167,9 +1161,6 @@ config CRYPTO_ANUBIS
 	  <https://www.cosic.esat.kuleuven.be/nessie/reports/>
 	  <http://www.larc.usp.br/~pbarreto/AnubisPage.html>
 
-config CRYPTO_LIB_ARC4
-	tristate
-
 config CRYPTO_ARC4
 	tristate "ARC4 cipher algorithm"
 	select CRYPTO_SKCIPHER
@@ -1357,9 +1348,6 @@ config CRYPTO_CAST6_AVX_X86_64
 	  This module provides the Cast6 cipher algorithm that processes
 	  eight blocks parallel using the AVX instruction set.
 
-config CRYPTO_LIB_DES
-	tristate
-
 config CRYPTO_DES
 	tristate "DES and Triple DES EDE cipher algorithms"
 	select CRYPTO_ALGAPI
@@ -1864,6 +1852,7 @@ config CRYPTO_STATS
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

