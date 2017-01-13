From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH] crypto: testmgr - don't DMA map IV from stack in test_skcipher()
Date: Fri, 13 Jan 2017 08:59:16 +0200
Message-ID: <1484290756-20868-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0063.outbound.protection.outlook.com ([104.47.32.63]:30208
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751066AbdAMG70 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 01:59:26 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix the "DMA-API: device driver maps memory from stack" warning
generated when crypto accelerators map the IV.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 crypto/testmgr.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 500a5277cc22..64245aeef634 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1081,12 +1081,16 @@ static int __test_skcipher(struct crypto_skcipher *tfm, int enc,
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
+		return ret;
+
 	if (testmgr_alloc_buf(xbuf))
 		goto out_nobuf;
 
@@ -1328,6 +1332,7 @@ static int __test_skcipher(struct crypto_skcipher *tfm, int enc,
 out_nooutbuf:
 	testmgr_free_buf(xbuf);
 out_nobuf:
+	kfree(iv);
 	return ret;
 }
 
-- 
2.4.4
