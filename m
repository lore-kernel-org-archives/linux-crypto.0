From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 4/5] crypto: LRNG - enable compile
Date: Fri, 29 Apr 2016 08:24:11 +0200
Message-ID: <34811117.P0biqIN9jg@positron.chronox.de>
References: <2346517.m8UHYeMDSf@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Ted Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	sandyinchina@gmail.com, Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>,
	joe@perches.com, Pavel Machek <pavel@ucw.cz>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54098 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbcD2GZt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 02:25:49 -0400
In-Reply-To: <2346517.m8UHYeMDSf@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add LRNG compilation support.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig  | 10 ++++++++++
 crypto/Makefile |  1 +
 2 files changed, 11 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 93a1fdc..938f2dc 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1587,6 +1587,16 @@ config CRYPTO_JITTERENTROPY
 	  random numbers. This Jitterentropy RNG registers with
 	  the kernel crypto API and can be used by any caller.
 
+config CRYPTO_LRNG
+	bool "Linux Random Number Generator"
+	select CRYPTO_DRBG_MENU
+	help
+	  The Linux Random Number Generator (LRNG) is the replacement
+	  of the legacy /dev/random provided with drivers/char/random.c.
+	  It generates entropy from different noise sources and
+	  delivers significant entropy during boot. The LRNG only
+	  works with the presence of a high-resolution timer.
+
 config CRYPTO_USER_API
 	tristate
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 4f4ef7e..7f91c8e 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -114,6 +114,7 @@ obj-$(CONFIG_CRYPTO_DRBG) += drbg.o
 obj-$(CONFIG_CRYPTO_JITTERENTROPY) += jitterentropy_rng.o
 CFLAGS_jitterentropy.o = -O0
 jitterentropy_rng-y := jitterentropy.o jitterentropy-kcapi.o
+obj-$(CONFIG_CRYPTO_LRNG) += lrng.o
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
 obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
-- 
2.5.5
