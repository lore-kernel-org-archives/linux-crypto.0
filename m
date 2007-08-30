From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/8] [CRYPTO] api: Move scatterwalk into algapi
Date: Thu, 30 Aug 2007 16:41:28 +0800
Message-ID: <E1IQfai-0004Be-00@gondolin.me.apana.org.au>
References: <20070830083900.GA15936@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbgert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1415 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756330AbXH3Ilb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Aug 2007 04:41:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] api: Move scatterwalk into algapi

The scatterwalk code is only used by algorithms that can be built as
a module.  Therefore we can move it into algapi.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index acb1942..5c015cc 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -2,10 +2,10 @@
 # Cryptographic API
 #
 
-obj-$(CONFIG_CRYPTO) += api.o scatterwalk.o cipher.o digest.o compress.o
+obj-$(CONFIG_CRYPTO) += api.o cipher.o digest.o compress.o
 
 crypto_algapi-$(CONFIG_PROC_FS) += proc.o
-crypto_algapi-objs := algapi.o $(crypto_algapi-y)
+crypto_algapi-objs := algapi.o scatterwalk.o $(crypto_algapi-y)
 obj-$(CONFIG_CRYPTO_ALGAPI) += crypto_algapi.o
 
 obj-$(CONFIG_CRYPTO_ABLKCIPHER) += ablkcipher.o
