From: Andrey Ryabinin <aryabinin@odin.com>
Subject: [PATCH] crypto/testmgr: don't copy from source IV too much
Date: Thu, 3 Sep 2015 14:32:00 +0300
Message-ID: <1441279921-26838-1-git-send-email-aryabinin@odin.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Andrey Ryabinin <aryabinin@odin.com>,
	<linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:55785 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbbICLcc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Sep 2015 07:32:32 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

While the destination buffer 'iv' is MAX_IVLEN size,
the source 'template[i].iv' could be smaller. Thus
copying it via memcpy() leads to invalid memory access.
Use strlcpy() instead.

Signed-off-by: Andrey Ryabinin <aryabinin@odin.com>
---
 crypto/testmgr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index d0a42bd..d85221c 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -974,7 +974,7 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 			continue;
 
 		if (template[i].iv)
-			memcpy(iv, template[i].iv, MAX_IVLEN);
+			strlcpy(iv, template[i].iv, MAX_IVLEN);
 		else
 			memset(iv, 0, MAX_IVLEN);
 
@@ -1049,7 +1049,7 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 			continue;
 
 		if (template[i].iv)
-			memcpy(iv, template[i].iv, MAX_IVLEN);
+			strlcpy(iv, template[i].iv, MAX_IVLEN);
 		else
 			memset(iv, 0, MAX_IVLEN);
 
-- 
2.4.6
