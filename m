From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/6] crypto-caamhash: Use kmalloc_array() in ahash_setkey()
Date: Thu, 15 Sep 2016 16:40:04 +0200
Message-ID: <4e1bc780-fa00-cfc9-c058-240bb899d701@users.sourceforge.net>
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
Date: Thu, 15 Sep 2016 11:20:09 +0200

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus use the corresponding function "kmalloc_array".

  This issue was detected by using the Coccinelle software.

* Replace the specification of a data type by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/caam/caamhash.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 9d7fc9e..f19df8f 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -525,8 +525,9 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 #endif
 
 	if (keylen > blocksize) {
-		hashed_key = kmalloc(sizeof(u8) * digestsize, GFP_KERNEL |
-				     GFP_DMA);
+		hashed_key = kmalloc_array(digestsize,
+					   sizeof(*hashed_key),
+					   GFP_KERNEL | GFP_DMA);
 		if (!hashed_key)
 			return -ENOMEM;
 		ret = hash_digest_key(ctx, key, &keylen, hashed_key,
-- 
2.10.0
