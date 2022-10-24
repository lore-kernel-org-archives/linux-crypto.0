Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA649C38A2D
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Oct 2022 06:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiJXGb1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Oct 2022 02:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiJXGbT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Oct 2022 02:31:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434CC5C379
        for <linux-crypto@vger.kernel.org>; Sun, 23 Oct 2022 23:31:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC8C76101C
        for <linux-crypto@vger.kernel.org>; Mon, 24 Oct 2022 06:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABADBC4347C;
        Mon, 24 Oct 2022 06:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666593076;
        bh=MVStoeot+9N481gE+IzlwIXraNYXd9DYcPzHHvi46mA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gd6Yx/4kbhEkQlM0qexWyxZULf1yKl1lygwlqcqPyREh7gL0Y97lp0Tv0Hta54iD3
         98DZunBYX8SaxU2XlmuV96zo+HRryjTcpuCnnbeZ6wzRpebQ7CpD/c1wd3FH7e1ypP
         7o2KFtrM3S6B+jrp/r/NUTEQEyFVG0qJ/Zer7ScWGhQmGd2S7x27I799SfSrrFxGA7
         Tr7go2cO2DxKUd8Z/t/7qHBGIXafyMaonjysjmBYDujhE2iyeeCKrdpEmq5GRe0HP/
         JxXA4mOEIoNKjKo5NNkimMCUHyJqRcYxjjTTS49KsRXNlbWehxR1B3OM69F2xhfZyN
         7MDgkWrlPjBSQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        keescook@chromium.org, jason@zx2c4.com, nikunj@amd.com,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v4 1/3] crypto: move gf128mul library into lib/crypto
Date:   Mon, 24 Oct 2022 08:30:50 +0200
Message-Id: <20221024063052.109148-2-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024063052.109148-1-ardb@kernel.org>
References: <20221024063052.109148-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2469; i=ardb@kernel.org; h=from:subject; bh=MVStoeot+9N481gE+IzlwIXraNYXd9DYcPzHHvi46mA=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjVjEY0vEsO+UUZuKB7qbu1LDJGNo0I6eQ1XIqe/mZ RwGA+96JAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY1YxGAAKCRDDTyI5ktmPJJeAC/ 9z+0991Mn0DyejV6p/22CERyF29J79JIjH2YyecFzITzRYmH/fIY/TeSRkZe0PO7T8WAwffkUV/NFp ihQ+rQIcgbGsKZxjK/zfppGoy73km80zTtBaK2pTHtT32POSI7b6TSc5B1xk1n6ZGcF7b7JcERvmwX BVqQXD1Yq5B1xqCpq/x1lqckWD2/5Xe9X9wPs4g6dXs+8UWxw6Oa7Yx+klKi7WW4yVb/UcPuSZ9M+Y l8ZhT+1YsUNfUd10PKjEqfoNSp1zj/kRj4WI1M22xD/R35nPbfejg4NA75nIxSaBzGqxrOqJES4KPB ZbBORcrYaYo6GNF4zaj2QoMycUDsQzRYcTG+34CMKLQKs4rSnBnjNK6KsB2scrSeEbj9z7oeAQJ3hO /oKhbEtYK4Drj2B3achEZ6tDnaT5NbjoVzqaVlivPe9fD/5+DRyc+zxyeU/UEb6nA1KmhbWNoiaC3O Mm6EEB1Pr3uRUpiOumr/e6Z1FTL0rJ6j+yd9Ku0t9Vdi4=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The gf128mul library does not depend on the crypto API at all, so it can
be moved into lib/crypto. This will allow us to use it in other library
code in a subsequent patch without having to depend on CONFIG_CRYPTO.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/Kconfig                    | 3 ---
 crypto/Makefile                   | 1 -
 lib/crypto/Kconfig                | 3 +++
 lib/crypto/Makefile               | 2 ++
 {crypto => lib/crypto}/gf128mul.c | 0
 5 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 2589ad5357df..a466beb64a69 100644
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
diff --git a/crypto/Makefile b/crypto/Makefile
index 303b21c43df0..d0126c915834 100644
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
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 7e9683e9f5c6..2a4b57779fd7 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -8,6 +8,9 @@ config CRYPTO_LIB_UTILS
 config CRYPTO_LIB_AES
 	tristate
 
+config CRYPTO_GF128MUL
+	tristate
+
 config CRYPTO_LIB_ARC4
 	tristate
 
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index c852f067ab06..60bb566eed78 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -10,6 +10,8 @@ obj-$(CONFIG_CRYPTO_LIB_CHACHA_GENERIC)		+= libchacha.o
 obj-$(CONFIG_CRYPTO_LIB_AES)			+= libaes.o
 libaes-y					:= aes.o
 
+obj-$(CONFIG_CRYPTO_GF128MUL)			+= gf128mul.o
+
 obj-$(CONFIG_CRYPTO_LIB_ARC4)			+= libarc4.o
 libarc4-y					:= arc4.o
 
diff --git a/crypto/gf128mul.c b/lib/crypto/gf128mul.c
similarity index 100%
rename from crypto/gf128mul.c
rename to lib/crypto/gf128mul.c
-- 
2.35.1

