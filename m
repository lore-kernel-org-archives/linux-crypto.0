From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/8] crypto: skcipher - Use tmpl->create
Date: Sat, 23 May 2015 15:41:48 +0800
Message-ID: <E1Yw444-0003rc-Jq@gondolin.me.apana.org.au>
References: <20150523074058.GA14781@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48675 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbbEWHlv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 23 May 2015 03:41:51 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Yw444-00032T-Se
	for <linux-crypto@vger.kernel.org>; Sat, 23 May 2015 17:41:49 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Newer templates use tmpl->create and have a NULL tmpl->alloc.  So
we must use tmpl->create if it is set.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ablkcipher.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index b3dded4..b15d797 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -586,6 +586,13 @@ static int crypto_givcipher_default(struct crypto_alg *alg, u32 type, u32 mask)
 	if (!tmpl)
 		goto kill_larval;
 
+	if (tmpl->create) {
+		err = tmpl->create(tmpl, tb);
+		if (err)
+			goto put_tmpl;
+		goto ok;
+	}
+
 	inst = tmpl->alloc(tb);
 	err = PTR_ERR(inst);
 	if (IS_ERR(inst))
@@ -597,6 +604,7 @@ static int crypto_givcipher_default(struct crypto_alg *alg, u32 type, u32 mask)
 		goto put_tmpl;
 	}
 
+ok:
 	/* Redo the lookup to use the instance we just registered. */
 	err = -EAGAIN;
 
