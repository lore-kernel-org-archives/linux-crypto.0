From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH] crypto: pcrypt - call the complete function on error
Date: Mon, 1 Feb 2010 10:39:37 +0100
Message-ID: <20100201093937.GH6619@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:37357 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab0BAKE7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2010 05:04:59 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This fixes three forgotten calls to the complete function
in the error case.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/pcrypt.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index b9527d0..8020124 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -114,7 +114,7 @@ static void pcrypt_aead_enc(struct padata_priv *padata)
 
 	padata->info = crypto_aead_encrypt(req);
 
-	if (padata->info)
+	if (padata->info == -EINPROGRESS)
 		return;
 
 	padata_do_serial(padata);
@@ -158,7 +158,7 @@ static void pcrypt_aead_dec(struct padata_priv *padata)
 
 	padata->info = crypto_aead_decrypt(req);
 
-	if (padata->info)
+	if (padata->info == -EINPROGRESS)
 		return;
 
 	padata_do_serial(padata);
@@ -202,7 +202,7 @@ static void pcrypt_aead_givenc(struct padata_priv *padata)
 
 	padata->info = crypto_aead_givencrypt(req);
 
-	if (padata->info)
+	if (padata->info == -EINPROGRESS)
 		return;
 
 	padata_do_serial(padata);
-- 
1.5.4.2

