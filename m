From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 14/16] crypto: api - Fix crypto_drop_spawn crash on blank spawns
Date: Thu, 09 Jul 2009 12:54:00 +0800
Message-ID: <E1MOldw-0005XR-M9@gondolin.me.apana.org.au>
References: <20090709045052.GA21092@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44872 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758103AbZGIEyC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2009 00:54:02 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MOldw-0006Eu-UI
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2009 14:54:01 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: api - Fix crypto_drop_spawn crash on blank spawns

This patch allows crypto_drop_spawn to be called on spawns that
have not been initialised or have failed initialisation.  This
fixes potential crashes during initialisation without adding
special case code.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 2154815..6a98076 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -507,6 +507,9 @@ EXPORT_SYMBOL_GPL(crypto_init_spawn2);
 
 void crypto_drop_spawn(struct crypto_spawn *spawn)
 {
+	if (!spawn->alg)
+		return;
+
 	down_write(&crypto_alg_sem);
 	list_del(&spawn->list);
 	up_write(&crypto_alg_sem);
