From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/2] crypto: bcm: One function call less in do_shash() after
 error detection
Date: Wed, 14 Feb 2018 22:40:26 +0100
Message-ID: <55bdcf76-f1c9-180d-6798-959e617b10ac@users.sourceforge.net>
References: <68946b12-83d6-ab74-fd54-71b23cf9b7ef@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Rice <rob.rice@broadcom.com>,
        Steve Lin <steven.lin1@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <68946b12-83d6-ab74-fd54-71b23cf9b7ef@users.sourceforge.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 14 Feb 2018 22:22:20 +0100

The kfree() function was called in one case by the do_shash() function
during error handling even if the passed variable contained a null pointer.

* Reorder two function calls at the end.

* Add a jump target.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/bcm/util.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/bcm/util.c b/drivers/crypto/bcm/util.c
index a912c6ad3e85..c141a0242223 100644
--- a/drivers/crypto/bcm/util.c
+++ b/drivers/crypto/bcm/util.c
@@ -279,7 +279,7 @@ int do_shash(unsigned char *name, unsigned char *result,
 	sdesc = kmalloc(size, GFP_KERNEL);
 	if (!sdesc) {
 		rc = -ENOMEM;
-		goto do_shash_err;
+		goto free_shash;
 	}
 	sdesc->shash.tfm = hash;
 	sdesc->shash.flags = 0x0;
@@ -314,9 +314,9 @@ int do_shash(unsigned char *name, unsigned char *result,
 		pr_err("%s: Could not generate %s hash\n", __func__, name);
 
 do_shash_err:
-	crypto_free_shash(hash);
 	kfree(sdesc);
-
+free_shash:
+	crypto_free_shash(hash);
 	return rc;
 }
 
-- 
2.16.1
