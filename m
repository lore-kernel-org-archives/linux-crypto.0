From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/2] crypto: api - Add CRYPTO_MINALIGN_ATTR to struct crypto_alg
Date: Thu, 18 Jun 2015 14:00:48 +0800
Message-ID: <E1Z5Ssa-0007Ma-1u@gondolin.me.apana.org.au>
References: <20150618055959.GA28242@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33698 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbbFRGAv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 02:00:51 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Z5Ssa-0005Mg-Cf
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jun 2015 16:00:48 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The struct crypto_alg is embedded into various type-specific structs
such as aead_alg.  This is then used as part of instances such as
struct aead_instance.  It is also embedded into the generic struct
crypto_instance.  In order to ensure that struct aead_instance can
be converted to struct crypto_instance when necessary, we need to
ensure that crypto_alg is aligned properly.

This patch adds an alignment attribute to struct crypto_alg to
ensure this.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/linux/crypto.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 25a4b71..2d34901 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -512,7 +512,7 @@ struct crypto_alg {
 	void (*cra_destroy)(struct crypto_alg *alg);
 	
 	struct module *cra_module;
-};
+} CRYPTO_MINALIGN_ATTR;
 
 /*
  * Algorithm registration interface.
