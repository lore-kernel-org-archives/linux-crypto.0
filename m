From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v6 4/5] crypto: LRNG - enable compile
Date: Thu, 11 Aug 2016 14:26:13 +0200
Message-ID: <1719085.BFjRV9CsT2@positron.chronox.de>
References: <4723196.TTQvcXsLCG@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Ted Tso <tytso@mit.edu>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4723196.TTQvcXsLCG@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add LRNG compilation support.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig  | 11 +++++++++++
 crypto/Makefile |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 84d7148..71df7fc 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1665,6 +1665,17 @@ config CRYPTO_JITTERENTROPY
 	  random numbers. This Jitterentropy RNG registers with
 	  the kernel crypto API and can be used by any caller.
 
+config CRYPTO_LRNG
+	bool "Linux Random Number Generator"
+	select CRYPTO_DRBG_MENU
+	select CRYPTO_CMAC if CRYPTO_DRBG_CTR
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
index 99cc64a..12d4249 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -122,6 +122,8 @@ obj-$(CONFIG_CRYPTO_DRBG) += drbg.o
 obj-$(CONFIG_CRYPTO_JITTERENTROPY) += jitterentropy_rng.o
 CFLAGS_jitterentropy.o = -O0
 jitterentropy_rng-y := jitterentropy.o jitterentropy-kcapi.o
+obj-$(CONFIG_CRYPTO_LRNG) += lrng.o
+lrng-y += lrng_base.o lrng_kcapi.o
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
 obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
-- 
2.7.4
