From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 08/18] crypto: talitos - declare local functions static
Date: Fri,  6 Oct 2017 15:04:47 +0200 (CEST)
Message-ID: <81d917dcadc7548cc0f615a5dccd5a3ea75a9dfa.1507284818.git.christophe.leroy@c-s.fr>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1507284818.git.christophe.leroy@c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

talitos_handle_buggy_hash() and talitos_sg_map() are only used
locally, make them static

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 266e7e626e12..dd6b1fc90020 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1113,7 +1113,7 @@ static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
 	return count;
 }
 
-int talitos_sg_map(struct device *dev, struct scatterlist *src,
+static int talitos_sg_map(struct device *dev, struct scatterlist *src,
 		   unsigned int len, struct talitos_edesc *edesc,
 		   struct talitos_ptr *ptr,
 		   int sg_count, unsigned int offset, int tbl_off)
@@ -1721,7 +1721,7 @@ static void ahash_done(struct device *dev,
  * SEC1 doesn't like hashing of 0 sized message, so we do the padding
  * ourself and submit a padded block
  */
-void talitos_handle_buggy_hash(struct talitos_ctx *ctx,
+static void talitos_handle_buggy_hash(struct talitos_ctx *ctx,
 			       struct talitos_edesc *edesc,
 			       struct talitos_ptr *ptr)
 {
-- 
2.13.3
