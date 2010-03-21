From: Dan Carpenter <error27@gmail.com>
Subject: [patch] pcrypt: handle crypto_get_attr_type() errors
Date: Sun, 21 Mar 2010 12:28:47 +0300
Message-ID: <20100321092847.GJ5331@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f211.google.com ([209.85.218.211]:53744 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab0CUJ24 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Mar 2010 05:28:56 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_get_attr_type() can returns ERR_PTRs if there is a problem. 

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 8020124..41bd80f 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -322,6 +322,8 @@ static struct crypto_instance *pcrypt_alloc_aead(struct rtattr **tb)
 	struct crypto_attr_type *algt;
 
 	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return ERR_CAST(algt);
 
 	alg = crypto_get_attr_alg(tb, algt->type,
 				  (algt->mask & CRYPTO_ALG_TYPE_MASK));
