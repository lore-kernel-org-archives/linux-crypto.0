From: "Jerome Marchand" <jmarchan@redhat.com>
Subject: [PATCH v2] fix out of bound read in __test_aead()
Date: Wed,  3 Feb 2016 13:58:12 +0100
Message-ID: <1454504292-17882-1-git-send-email-jmarchan@redhat.com>
References: <1454073009-13665-1-git-send-email-jmarchan@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683AbcBCM6V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Feb 2016 07:58:21 -0500
In-Reply-To: <1454073009-13665-1-git-send-email-jmarchan@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

__test_aead() reads MAX_IVLEN bytes from template[i].iv, but the
actual length of the initialisation vector can be shorter.
The length of the IV is already calculated earlier in the
function. Let's just reuses that. Also the IV length is currently
calculated several time for no reason. Let's fix that too.
This fix an out-of-bound error detected by KASan.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 crypto/testmgr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ae8c57fd..6691756 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -488,6 +488,8 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				  tcrypt_complete, &result);
 
+	iv_len = crypto_aead_ivsize(tfm);
+
 	for (i = 0, j = 0; i < tcount; i++) {
 		if (template[i].np)
 			continue;
@@ -508,7 +510,6 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 
 		memcpy(input, template[i].input, template[i].ilen);
 		memcpy(assoc, template[i].assoc, template[i].alen);
-		iv_len = crypto_aead_ivsize(tfm);
 		if (template[i].iv)
 			memcpy(iv, template[i].iv, iv_len);
 		else
@@ -617,7 +618,7 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 		j++;
 
 		if (template[i].iv)
-			memcpy(iv, template[i].iv, MAX_IVLEN);
+			memcpy(iv, template[i].iv, iv_len);
 		else
 			memset(iv, 0, MAX_IVLEN);
 
-- 
2.5.0
