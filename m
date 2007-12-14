From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/4] [CRYPTO] null: Allow setkey on digest_null
Date: Fri, 14 Dec 2007 16:39:44 +0800
Message-ID: <E1J365A-00046y-00@gondolin.me.apana.org.au>
References: <20071214083909.GA15726@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4700 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756416AbXLNIjq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Dec 2007 03:39:46 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J365A-000091-ON
	for <linux-crypto@vger.kernel.org>; Fri, 14 Dec 2007 19:39:44 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] null: Allow setkey on digest_null 

We need to allow setkey on digest_null if it is to be used directly by
authenc instead of through hmac.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/crypto_null.c |    1 +
 1 files changed, 1 insertion(+)

diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index fc2d2a4..ff7b3de 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -98,6 +98,7 @@ static struct crypto_alg digest_null = {
 	.cra_list		=       LIST_HEAD_INIT(digest_null.cra_list),	
 	.cra_u			=	{ .digest = {
 	.dia_digestsize		=	NULL_DIGEST_SIZE,
+	.dia_setkey   		=	null_setkey,
 	.dia_init   		=	null_init,
 	.dia_update 		=	null_update,
 	.dia_final  		=	null_final } }
