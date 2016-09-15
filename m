From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 4/6] crypto-caamhash: Return a value directly in
 caam_hash_cra_init()
Date: Thu, 15 Sep 2016 16:43:21 +0200
Message-ID: <6f8877c6-873b-ee9d-596e-2567eed44962@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <970e9e1b-c1dc-eb28-b380-92c15e9b1961@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Labbe Corentin <clabbe.montjoie@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <970e9e1b-c1dc-eb28-b380-92c15e9b1961@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 15 Sep 2016 14:56:12 +0200

* Return a value at the end without storing it in an intermediate variable.

* Delete the local variable "ret" which became unnecessary with
  this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/caam/caamhash.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 933252f..b1dbc53 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1846,7 +1846,6 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 					 HASH_MSG_LEN + SHA256_DIGEST_SIZE,
 					 HASH_MSG_LEN + 64,
 					 HASH_MSG_LEN + SHA512_DIGEST_SIZE };
-	int ret = 0;
 
 	/*
 	 * Get a Job ring from Job Ring driver to ensure in-order
@@ -1866,10 +1865,7 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct caam_hash_state));
-
-	ret = ahash_set_sh_desc(ahash);
-
-	return ret;
+	return ahash_set_sh_desc(ahash);
 }
 
 static void caam_hash_cra_exit(struct crypto_tfm *tfm)
-- 
2.10.0
