From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v4 4/5] crypto: LRNG - enable compile
Date: Tue, 31 May 2016 20:39:23 +0200
Message-ID: <3200381.4OGOeXfrff@positron.chronox.de>
References: <1668650.acZVSyjHlL@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Ted Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	sandyinchina@gmail.com, Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1668650.acZVSyjHlL@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add LRNG compilation support.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig  | 10 ++++++++++
 crypto/Makefile |  1 +
 2 files changed, 11 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1d33beb..9aaf96c 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1588,6 +1588,16 @@ config CRYPTO_JITTERENTROPY
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
2.7.2
