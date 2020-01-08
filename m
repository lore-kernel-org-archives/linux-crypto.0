Return-Path: <SRS0=xmdE=25=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D81D1C00523
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 04:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA1742070E
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 04:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgAHEhy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jan 2020 23:37:54 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:54054 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbgAHEhy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jan 2020 23:37:54 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ip36B-0008Iw-MG; Wed, 08 Jan 2020 12:37:39 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ip367-00081d-Ms; Wed, 08 Jan 2020 12:37:35 +0800
Date:   Wed, 8 Jan 2020 12:37:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        David Miller <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [v2 PATCH] crypto: curve25519 - Fix selftest build error
Message-ID: <20200108043735.hkhkyq47neatatt4@gondor.apana.org.au>
References: <20200107133547.44000-1-yuehaibing@huawei.com>
 <CAHmME9pg4KWw1zNVybxn1WLGusyGCjqeAHLQXY=Dr4zznUM82g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9pg4KWw1zNVybxn1WLGusyGCjqeAHLQXY=Dr4zznUM82g@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 07, 2020 at 10:46:49AM -0500, Jason A. Donenfeld wrote:
> Thanks for catching this. While the pattern of adding the test here
> followed the already-working pattern used by the blake2s
> implementation, curve25519's wiring differs in one way: the arch code
> is not related to any of the generic machinery. So this seems like an
> okay way of fixing this for the time being.

There is one problem with this patch, it causes the self-test to be
enabled even when CONFIG_CRYPTO_LIB_CURVE25519 is off.  So I think
what we should do is simply copy the blake2s paradigm more fully
by adding a dummy module for curve25519 that hosts just the
self-test.  Something like this:

---8<---
If CRYPTO_CURVE25519 is y, CRYPTO_LIB_CURVE25519_GENERIC will be
y, but CRYPTO_LIB_CURVE25519 may be set to m, this causes build
errors:

lib/crypto/curve25519-selftest.o: In function `curve25519':
curve25519-selftest.c:(.text.unlikely+0xc): undefined reference to `curve25519_arch'
lib/crypto/curve25519-selftest.o: In function `curve25519_selftest':
curve25519-selftest.c:(.init.text+0x17e): undefined reference to `curve25519_base_arch'

This is because the curve25519 self-test code is being controlled
by the GENERIC option rather than the overall CURVE25519 option,
as is the case with blake2s.  To recap, the GENERIC and ARCH options
for CURVE25519 are internal only and selected by users such as
the Crypto API, or the externally visible CURVE25519 option which
in turn is selected by wireguard.  The self-test is specific to the
the external CURVE25519 option and should not be enabled by the
Crypto API.

This patch fixes this by splitting the GENERIC module from the
CURVE25519 module with the latter now containing just the self-test.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: aa127963f1ca ("crypto: lib/curve25519 - re-add selftests")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index f97f9b941110..5241e140a7ae 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -19,9 +19,12 @@ libblake2s-y					+= blake2s.o
 obj-$(CONFIG_CRYPTO_LIB_CHACHA20POLY1305)	+= libchacha20poly1305.o
 libchacha20poly1305-y				+= chacha20poly1305.o
 
-obj-$(CONFIG_CRYPTO_LIB_CURVE25519_GENERIC)	+= libcurve25519.o
-libcurve25519-y					:= curve25519-fiat32.o
-libcurve25519-$(CONFIG_ARCH_SUPPORTS_INT128)	:= curve25519-hacl64.o
+obj-$(CONFIG_CRYPTO_LIB_CURVE25519_GENERIC)	+= libcurve25519-generic.o
+libcurve25519-generic-y				:= curve25519-fiat32.o
+libcurve25519-generic-$(CONFIG_ARCH_SUPPORTS_INT128)	:= curve25519-hacl64.o
+libcurve25519-generic-y				+= curve25519-generic.o
+
+obj-$(CONFIG_CRYPTO_LIB_CURVE25519)		+= libcurve25519.o
 libcurve25519-y					+= curve25519.o
 
 obj-$(CONFIG_CRYPTO_LIB_DES)			+= libdes.o
diff --git a/lib/crypto/curve25519.c b/lib/crypto/curve25519.c
index c03ccdb99434..288a62cd29b2 100644
--- a/lib/crypto/curve25519.c
+++ b/lib/crypto/curve25519.c
@@ -15,13 +15,6 @@
 
 bool curve25519_selftest(void);
 
-const u8 curve25519_null_point[CURVE25519_KEY_SIZE] __aligned(32) = { 0 };
-const u8 curve25519_base_point[CURVE25519_KEY_SIZE] __aligned(32) = { 9 };
-
-EXPORT_SYMBOL(curve25519_null_point);
-EXPORT_SYMBOL(curve25519_base_point);
-EXPORT_SYMBOL(curve25519_generic);
-
 static int __init mod_init(void)
 {
 	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&
diff --git a/lib/crypto/curve25519-generic.c b/lib/crypto/curve25519-generic.c
new file mode 100644
index 000000000000..de7c99172fa2
--- /dev/null
+++ b/lib/crypto/curve25519-generic.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0 OR MIT
+/*
+ * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ *
+ * This is an implementation of the Curve25519 ECDH algorithm, using either
+ * a 32-bit implementation or a 64-bit implementation with 128-bit integers,
+ * depending on what is supported by the target compiler.
+ *
+ * Information: https://cr.yp.to/ecdh.html
+ */
+
+#include <crypto/curve25519.h>
+#include <linux/module.h>
+
+const u8 curve25519_null_point[CURVE25519_KEY_SIZE] __aligned(32) = { 0 };
+const u8 curve25519_base_point[CURVE25519_KEY_SIZE] __aligned(32) = { 9 };
+
+EXPORT_SYMBOL(curve25519_null_point);
+EXPORT_SYMBOL(curve25519_base_point);
+EXPORT_SYMBOL(curve25519_generic);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Curve25519 scalar multiplication");
+MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
