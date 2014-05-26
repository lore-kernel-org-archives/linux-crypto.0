From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v8 4/7] compile the DRBG code
Date: Mon, 26 May 2014 13:28:26 +0200
Message-ID: <11486874.3CAeEZTMMV@myon.chronox.de>
References: <1672386.pGc00MSMM2@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, aquini@redhat.com,
	jeremy.wayne.powell@gmail.com, clemens@ladisch.de,
	pwalten@au1.ibm.com, joe@perches.com
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1672386.pGc00MSMM2@myon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/Makefile b/crypto/Makefile
index 38e64231..bfa94fa 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -92,6 +92,7 @@ obj-$(CONFIG_CRYPTO_842) += 842.o
 obj-$(CONFIG_CRYPTO_RNG2) += rng.o
 obj-$(CONFIG_CRYPTO_RNG2) += krng.o
 obj-$(CONFIG_CRYPTO_ANSI_CPRNG) += ansi_cprng.o
+obj-$(CONFIG_CRYTPO_DRBG) += drbg.o
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
 obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
-- 
1.9.3
