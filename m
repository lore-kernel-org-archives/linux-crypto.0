From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 4/6] crypto: LRNG - enable compile
Date: Thu, 21 Apr 2016 11:14:05 +0200
Message-ID: <1686074.3HEQbqLQhD@positron.chronox.de>
References: <9192755.iDgo3Omyqe@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, sandyinchina@gmail.com
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9192755.iDgo3Omyqe@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
