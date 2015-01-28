From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH] crypto: tcrypt: do not allocate iv on stack for aead speed tests
Date: Wed, 28 Jan 2015 13:07:32 +0200
Message-ID: <1422443252-6396-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <davem@davemloft.net>,
	Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0148.outbound.protection.outlook.com ([207.46.100.148]:47233
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753188AbbA1UkE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Jan 2015 15:40:04 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

See also: 9bac019dad8098a77cce555d929f678e22111783

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/tcrypt.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 2b2486a..4b9e23f 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -280,16 +280,20 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	struct scatterlist *sgout;
 	const char *e;
 	void *assoc;
-	char iv[MAX_IVLEN];
+	char *iv;
 	char *xbuf[XBUFSIZE];
 	char *xoutbuf[XBUFSIZE];
 	char *axbuf[XBUFSIZE];
 	unsigned int *b_size;
 	unsigned int iv_len;
 
+	iv = kzalloc(MAX_IVLEN, GFP_KERNEL);
+	if (!iv)
+		return;
+
 	if (aad_size >= PAGE_SIZE) {
 		pr_err("associate data length (%u) too big\n", aad_size);
-		return;
+		goto out_noxbuf;
 	}
 
 	if (enc == ENCRYPT)
@@ -355,7 +359,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 
 			iv_len = crypto_aead_ivsize(tfm);
 			if (iv_len)
-				memset(&iv, 0xff, iv_len);
+				memset(iv, 0xff, iv_len);
 
 			crypto_aead_clear_flags(tfm, ~0);
 			printk(KERN_INFO "test %u (%d bit key, %d byte blocks): ",
@@ -408,6 +412,7 @@ out_nooutbuf:
 out_noaxbuf:
 	testmgr_free_buf(xbuf);
 out_noxbuf:
+	kfree(iv);
 	return;
 }
 
-- 
2.2.0
