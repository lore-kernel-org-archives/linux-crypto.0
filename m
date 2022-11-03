Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 046EDC4332F
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Nov 2022 19:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbiKCTZI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Nov 2022 15:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiKCTYr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Nov 2022 15:24:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E0020373
        for <linux-crypto@vger.kernel.org>; Thu,  3 Nov 2022 12:23:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE50961FC4
        for <linux-crypto@vger.kernel.org>; Thu,  3 Nov 2022 19:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6271FC43470;
        Thu,  3 Nov 2022 19:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667503397;
        bh=IXkcUfbC7RDRUWB9OZetlUsyGCzL03fGD5QHJhYEqAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOSA1ZzalwKG9NROS0zg1dt3RPOn/aOvNZH9LvxNBj2WZvSTCSc9gJx10JhtQhm/M
         RJIix1xUCwxn7hcASQV3lxsncUsPnSGk0bsk7saICOyMSe45H+1E4gVbbiLAr3gZ/6
         iGzItVYpsfJM4EBvohgUvEe1XJtdy7LVzkB6iaZ1ENvwJjB7INEcyVbk9dGW3ImvnR
         HzSWtOd9e5RfgcLd+cw8AP8ef0IOml5OBvV2trXGxEDUFTMBRLEv7XhGxLj5d8xKGD
         yyP/ORYDjz7Yrj8j+x2R1RgSgSFHx9f6Bbj2GTmkdJqIpO3z/sMBIcXp1jn/BzD7jN
         7X+MkprpeGabQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, keescook@chromium.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Robert Elliott <elliott@hpe.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH v5 1/3] crypto: move gf128mul library into lib/crypto
Date:   Thu,  3 Nov 2022 20:22:57 +0100
Message-Id: <20221103192259.2229-2-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221103192259.2229-1-ardb@kernel.org>
References: <20221103192259.2229-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5104; i=ardb@kernel.org; h=from:subject; bh=IXkcUfbC7RDRUWB9OZetlUsyGCzL03fGD5QHJhYEqAQ=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjZBUO/6izRWT0qejXyAZMW5YfKIKuLXsxj61GYP3B AbZfkmCJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY2QVDgAKCRDDTyI5ktmPJApUDA CbNjvGUj9s/GvN3TLDvrKTwg6MnKZc124U8H4I+YoTOdsoQx97MhUyQMtR97/Wc1cEb4pvRaigmg0W ZUyY62T5NnqY5lQZpT7QsfHZ0VUops5rYjWYK7A0ZFwUo3tnOTBCJES0ILsjBY48NciwAgqTNOmxkD RRa/OTSfU2QmLnZE8TIs/Vy4nG+vaj6x5+SixRubYkfs8U+x1DSpFS1kkrd2DQmnjOfHWmLG4GYedM 4CnOpYDeu6dvBDXIG6a+tAJ4j7Wzs4yblaAYEnNlBNsJ6HDi6BBU1HdJz8rvRu6Tm6Q308fT3C66OJ BnDLb1DBIXeDAx3MxUJTqGap70Z8D9AVWznKMMz3Hj6DvLJAFf40ZyqahRAXy3hXdGklw/3GAAKE2K S7nrS/q2uoY8h0gZSU5IdVO2m9MQSBvZJHEWE4vUtB8nbdB9gSSy17z4YWWNHzdZ+93+Iw6oU+ufDq oZDDwwsxIvXk+DmZcd/GPtUidsGPqbOqzlbq95zG7i1XQ=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The gf128mul library does not depend on the crypto API at all, so it can
be moved into lib/crypto. This will allow us to use it in other library
code in a subsequent patch without having to depend on CONFIG_CRYPTO.

While at it, change the Kconfig symbol name to align with other crypto
library implementations. However, the source file name is retained, as
it is reflected in the module .ko filename, and changing this might
break things for users.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/crypto/Kconfig           | 2 +-
 arch/arm64/crypto/Kconfig         | 2 +-
 crypto/Kconfig                    | 9 +++------
 crypto/Makefile                   | 1 -
 drivers/crypto/chelsio/Kconfig    | 2 +-
 lib/crypto/Kconfig                | 3 +++
 lib/crypto/Makefile               | 2 ++
 {crypto => lib/crypto}/gf128mul.c | 0
 8 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 3858c4d4cb98854d..7b2b7d043d9be9e6 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -18,7 +18,7 @@ config CRYPTO_GHASH_ARM_CE
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_HASH
 	select CRYPTO_CRYPTD
-	select CRYPTO_GF128MUL
+	select CRYPTO_LIB_GF128MUL
 	help
 	  GCM GHASH function (NIST SP800-38D)
 
diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 8bd80508a710d112..8542edaf592dc491 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -6,8 +6,8 @@ config CRYPTO_GHASH_ARM64_CE
 	tristate "Hash functions: GHASH (ARMv8 Crypto Extensions)"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_HASH
-	select CRYPTO_GF128MUL
 	select CRYPTO_LIB_AES
+	select CRYPTO_LIB_GF128MUL
 	select CRYPTO_AEAD
 	help
 	  GCM GHASH function (NIST SP800-38D)
diff --git a/crypto/Kconfig b/crypto/Kconfig
index d779667671b23f03..9c86f704515761c4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -175,9 +175,6 @@ config CRYPTO_MANAGER_EXTRA_TESTS
 	  This is intended for developer use only, as these tests take much
 	  longer to run than the normal self tests.
 
-config CRYPTO_GF128MUL
-	tristate
-
 config CRYPTO_NULL
 	tristate "Null algorithms"
 	select CRYPTO_NULL2
@@ -714,9 +711,9 @@ config CRYPTO_KEYWRAP
 
 config CRYPTO_LRW
 	tristate "LRW (Liskov Rivest Wagner)"
+	select CRYPTO_LIB_GF128MUL
 	select CRYPTO_SKCIPHER
 	select CRYPTO_MANAGER
-	select CRYPTO_GF128MUL
 	select CRYPTO_ECB
 	help
 	  LRW (Liskov Rivest Wagner) mode
@@ -926,8 +923,8 @@ config CRYPTO_CMAC
 
 config CRYPTO_GHASH
 	tristate "GHASH"
-	select CRYPTO_GF128MUL
 	select CRYPTO_HASH
+	select CRYPTO_LIB_GF128MUL
 	help
 	  GCM GHASH function (NIST SP800-38D)
 
@@ -967,8 +964,8 @@ config CRYPTO_MICHAEL_MIC
 
 config CRYPTO_POLYVAL
 	tristate
-	select CRYPTO_GF128MUL
 	select CRYPTO_HASH
+	select CRYPTO_LIB_GF128MUL
 	help
 	  POLYVAL hash function for HCTR2
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 303b21c43df05a5e..d0126c915834b2f0 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -85,7 +85,6 @@ obj-$(CONFIG_CRYPTO_WP512) += wp512.o
 CFLAGS_wp512.o := $(call cc-option,-fno-schedule-insns)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
 obj-$(CONFIG_CRYPTO_BLAKE2B) += blake2b_generic.o
 CFLAGS_blake2b_generic.o := -Wframe-larger-than=4096 #  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105930
-obj-$(CONFIG_CRYPTO_GF128MUL) += gf128mul.o
 obj-$(CONFIG_CRYPTO_ECB) += ecb.o
 obj-$(CONFIG_CRYPTO_CBC) += cbc.o
 obj-$(CONFIG_CRYPTO_CFB) += cfb.o
diff --git a/drivers/crypto/chelsio/Kconfig b/drivers/crypto/chelsio/Kconfig
index f886401af13e7b27..5dd3f6a4781a2c96 100644
--- a/drivers/crypto/chelsio/Kconfig
+++ b/drivers/crypto/chelsio/Kconfig
@@ -3,11 +3,11 @@ config CRYPTO_DEV_CHELSIO
 	tristate "Chelsio Crypto Co-processor Driver"
 	depends on CHELSIO_T4
 	select CRYPTO_LIB_AES
+	select CRYPTO_LIB_GF128MUL
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
 	select CRYPTO_AUTHENC
-	select CRYPTO_GF128MUL
 	help
 	  The Chelsio Crypto Co-processor driver for T6 adapters.
 
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 7e9683e9f5c63645..6767d86959de8f9c 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -11,6 +11,9 @@ config CRYPTO_LIB_AES
 config CRYPTO_LIB_ARC4
 	tristate
 
+config CRYPTO_LIB_GF128MUL
+	tristate
+
 config CRYPTO_ARCH_HAVE_LIB_BLAKE2S
 	bool
 	help
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index c852f067ab06019e..7000eeb72286e253 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -13,6 +13,8 @@ libaes-y					:= aes.o
 obj-$(CONFIG_CRYPTO_LIB_ARC4)			+= libarc4.o
 libarc4-y					:= arc4.o
 
+obj-$(CONFIG_CRYPTO_LIB_GF128MUL)		+= gf128mul.o
+
 # blake2s is used by the /dev/random driver which is always builtin
 obj-y						+= libblake2s.o
 libblake2s-y					:= blake2s.o
diff --git a/crypto/gf128mul.c b/lib/crypto/gf128mul.c
similarity index 100%
rename from crypto/gf128mul.c
rename to lib/crypto/gf128mul.c
-- 
2.35.1

