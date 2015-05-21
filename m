From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/16] crypto: caam - Use old_aead_alg
Date: Thu, 21 May 2015 15:11:03 +0800
Message-ID: <E1YvKdD-0005eC-Uo@gondolin.me.apana.org.au>
References: <20150521070915.GA20997@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54605 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbbEUHLH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 03:11:07 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YvKdE-0002xo-NF
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 17:11:04 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch replaces references to aead_alg with old_aead_alg.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/caam/caamalg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index a34fc95..3d850ab 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -3379,7 +3379,7 @@ struct caam_alg_template {
 	u32 type;
 	union {
 		struct ablkcipher_alg ablkcipher;
-		struct aead_alg aead;
+		struct old_aead_alg aead;
 	} template_u;
 	u32 class1_alg_type;
 	u32 class2_alg_type;
