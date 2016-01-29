From: "Jerome Marchand" <jmarchan@redhat.com>
Subject: [PATCH] fix out of bound read in __test_aead()
Date: Fri, 29 Jan 2016 14:10:09 +0100
Message-ID: <1454073009-13665-1-git-send-email-jmarchan@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

__test_aead() reads MAX_IVLEN bytes from template[i].iv, but the
actual length of the initialisation vector can be shorter.
The length of the IV is already calculated earlier in the
function. Let's just reuses that.
This fix an out-of-bound error detected by KASan.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 crypto/testmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ae8c57fd..d3587d5 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -617,7 +617,7 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 		j++;
 
 		if (template[i].iv)
-			memcpy(iv, template[i].iv, MAX_IVLEN);
+			memcpy(iv, template[i].iv, iv_len);
 		else
 			memset(iv, 0, MAX_IVLEN);
 
-- 
2.5.0
