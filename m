From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH] crypto: testmgr: don't allocate IV on stack
Date: Tue, 31 Oct 2017 07:56:26 +0000
Message-ID: <1509436586-17500-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60228 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751229AbdJaH4f (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Oct 2017 03:56:35 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The IV was allocated on the stack in testmgr skcipher tests.
Since HW based tfm providers need to DMA the IV to the HW,
this leads to problems and is detected by the DMA-API debug
code.

Fix it by allocating the IV using kmalloc instead.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 crypto/testmgr.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 7125ba3..88d0c57 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1085,12 +1085,16 @@ static int __test_skcipher(struct crypto_skcipher *tfm, int enc,
 	const char *e, *d;
 	struct tcrypt_result result;
 	void *data;
-	char iv[MAX_IVLEN];
+	char *iv;
 	char *xbuf[XBUFSIZE];
 	char *xoutbuf[XBUFSIZE];
 	int ret = -ENOMEM;
 	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 
+	iv = kmalloc(MAX_IVLEN, GFP_KERNEL);
+	if (!iv)
+		goto out_nobuf;
+
 	if (testmgr_alloc_buf(xbuf))
 		goto out_nobuf;
 
@@ -1331,6 +1335,7 @@ static int __test_skcipher(struct crypto_skcipher *tfm, int enc,
 		testmgr_free_buf(xoutbuf);
 out_nooutbuf:
 	testmgr_free_buf(xbuf);
+	kfree(iv);
 out_nobuf:
 	return ret;
 }
-- 
2.7.4
