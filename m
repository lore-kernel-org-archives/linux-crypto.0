From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 6/8] crypto: akcipher: the key parameter must be const u8 *
Date: Tue, 20 Oct 2015 09:34:02 +0200
Message-ID: <1445326444-11019-7-git-send-email-clabbe.montjoie@gmail.com>
References: <1445326444-11019-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445326444-11019-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

All cryptoAPI setkey function set the key parameter as const u8 *.
This patch make the crypto_akcipher_setkey parameters like others.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 include/crypto/akcipher.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 0c9fa68..ade053b 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -330,7 +330,8 @@ static inline int crypto_akcipher_verify(struct akcipher_request *req)
  *
  * Return: zero on success; error code in case of error
  */
-static inline int crypto_akcipher_setkey(struct crypto_akcipher *tfm, void *key,
+static inline int crypto_akcipher_setkey(struct crypto_akcipher *tfm,
+					 const u8 *key,
 					 unsigned int keylen)
 {
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
-- 
2.4.10
