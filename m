From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/6] [CRYPTO] tcrypt: Removed vestigial crypto_alloc_tfm call
Date: Wed, 24 Jan 2007 21:29:16 +1100
Message-ID: <E1H9fNU-0005my-00@gondolin.me.apana.org.au>
References: <20070124102736.GA21977@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2897 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750999AbXAXK3S (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Jan 2007 05:29:18 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1H9fNU-0005wX-Qh
	for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2007 21:29:16 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1H9fNU-0005my-00
	for <linux-crypto@vger.kernel.org>; Wed, 24 Jan 2007 21:29:16 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] tcrypt: Removed vestigial crypto_alloc_tfm call

The crypto_comp conversion missed the last remaining crypto_alloc_tfm
call.  This patch replaces it with crypto_alloc_comp.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/tcrypt.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -767,7 +767,7 @@ static void test_deflate(void)
 	memcpy(tvmem, deflate_comp_tv_template, tsize);
 	tv = (void *)tvmem;
 
-	tfm = crypto_alloc_tfm("deflate", 0);
+	tfm = crypto_alloc_comp("deflate", 0, CRYPTO_ALG_ASYNC);
 	if (tfm == NULL) {
 		printk("failed to load transform for deflate\n");
 		return;
