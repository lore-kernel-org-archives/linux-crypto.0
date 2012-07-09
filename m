From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH] crypto: testmgr - make the assoc data and iv contiguous for aead tests
Date: Mon, 9 Jul 2012 11:17:43 +0300
Message-ID: <1341821863-16074-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:12077
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783Ab2GIISD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Jul 2012 04:18:03 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In case of AEAD, some crypto engines expect assoc data and iv to be contiguous.
This is how native IPsec works; make testmgr's behaviour the same.
(Alternative would be to fix this in the crypto engine drivers, but this is
pricy since it would involve memory allocation and copy in the hot path.)

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 crypto/testmgr.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ee62d5c..af2a1a3 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -374,7 +374,7 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 	unsigned int authsize;
 	void *input;
 	void *assoc;
-	char iv[MAX_IVLEN];
+	char *iv;
 	char *xbuf[XBUFSIZE];
 	char *axbuf[XBUFSIZE];
 
@@ -412,11 +412,12 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 
 			ret = -EINVAL;
 			if (WARN_ON(template[i].ilen > PAGE_SIZE ||
-				    template[i].alen > PAGE_SIZE))
+				    template[i].alen + MAX_IVLEN > PAGE_SIZE))
 				goto out;
 
 			memcpy(input, template[i].input, template[i].ilen);
 			memcpy(assoc, template[i].assoc, template[i].alen);
+			iv = (char*)assoc + template[i].alen;
 			if (template[i].iv)
 				memcpy(iv, template[i].iv, MAX_IVLEN);
 			else
-- 
1.7.3.4
