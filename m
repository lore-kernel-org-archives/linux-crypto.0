From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/2] crypto-testmgr: Delete an unnecessary variable
 initialisation in drbg_cavs_test()
Date: Sat, 21 Oct 2017 19:55:09 +0200
Message-ID: <9bd0533e-1bf3-a1c1-d84c-34ab4c511b78@users.sourceforge.net>
References: <7c2b4df8-a04b-cacd-13ba-4d9afb346263@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7c2b4df8-a04b-cacd-13ba-4d9afb346263@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 21 Oct 2017 19:33:45 +0200

The variable "ret" will eventually be set to an error code a bit later.
Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 crypto/testmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 76c5128284f8..e46cf2c92497 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1901,7 +1901,7 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
 static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
 			  const char *driver, u32 type, u32 mask)
 {
-	int ret = -EAGAIN;
+	int ret;
 	struct crypto_rng *drng;
 	struct drbg_test_data test_data;
 	struct drbg_string addtl, pers, testentropy;
-- 
2.14.2
