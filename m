From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH v2] crypto/testmgr: don't copy from source IV too much
Date: Thu, 10 Sep 2015 13:11:55 +0300
Message-ID: <1441879915-5362-1-git-send-email-aryabinin@virtuozzo.com>
References: <20150903132057.GA31317@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:59176 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbbIJKMG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Sep 2015 06:12:06 -0400
In-Reply-To: <20150903132057.GA31317@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

While the destination buffer 'iv' is MAX_IVLEN size,
the source 'template[i].iv' could be smaller, thus
memcpy may read read invalid memory.
Use crypto_skcipher_ivsize() to get real ivsize
and pass it to memcpy.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 crypto/testmgr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 35c2de1..fa18753 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -940,6 +940,7 @@ static int __test_skcipher(struct crypto_skcipher *tfm, int enc,
 	char *xbuf[XBUFSIZE];
 	char *xoutbuf[XBUFSIZE];
 	int ret = -ENOMEM;
+	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 
 	if (testmgr_alloc_buf(xbuf))
 		goto out_nobuf;
@@ -975,7 +976,7 @@ static int __test_skcipher(struct crypto_skcipher *tfm, int enc,
 			continue;
 
 		if (template[i].iv)
-			memcpy(iv, template[i].iv, MAX_IVLEN);
+			memcpy(iv, template[i].iv, ivsize);
 		else
 			memset(iv, 0, MAX_IVLEN);
 
@@ -1051,7 +1052,7 @@ static int __test_skcipher(struct crypto_skcipher *tfm, int enc,
 			continue;
 
 		if (template[i].iv)
-			memcpy(iv, template[i].iv, MAX_IVLEN);
+			memcpy(iv, template[i].iv, ivsize);
 		else
 			memset(iv, 0, MAX_IVLEN);
 
-- 
2.4.6
