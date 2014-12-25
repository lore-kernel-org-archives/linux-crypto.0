From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v6 4/4] crypto: AF_ALG: enable RNG interface compilation
Date: Thu, 25 Dec 2014 23:00:39 +0100
Message-ID: <1531939.gTKbxagG6Z@tachyon.chronox.de>
References: <5682082.ffPqvQlSqN@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Daniel Borkmann <dborkman@redhat.com>,
	'Quentin Gouchet' <quentin.gouchet@gmail.com>,
	'LKML' <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org
To: 'Herbert Xu' <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:51054 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbaLYWDN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Dec 2014 17:03:13 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SD995> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Thu, 25 Dec 2014 23:03:04 +0100
In-Reply-To: <5682082.ffPqvQlSqN@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Enable compilation of the RNG AF_ALG support and provide a Kconfig
option to compile the RNG AF_ALG support.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig  | 9 +++++++++
 crypto/Makefile | 1 +
 2 files changed, 10 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index cd3e6fd..f2d434b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1523,6 +1523,15 @@ config CRYPTO_USER_API_AEAD
 	  This option enables the user-spaces interface for AEAD
 	  cipher algorithms.
 
+config CRYPTO_USER_API_RNG
+	tristate "User-space interface for random number generator algorithms"
+	depends on NET
+	select CRYPTO_RNG
+	select CRYPTO_USER_API
+	help
+	  This option enables the user-spaces interface for random
+	  number generator algorithms.
+
 config CRYPTO_HASH_INFO
 	bool
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 593fd3c..c109df5 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -100,6 +100,7 @@ obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
 obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
 obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
+obj-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
 
 #
 # generic algorithms and the async_tx api
-- 
2.1.0
