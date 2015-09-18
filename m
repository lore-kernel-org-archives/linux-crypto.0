From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 8/8] crypto: caam: replace __sg_count with sg_nents_len_chained
Date: Fri, 18 Sep 2015 14:57:16 +0200
Message-ID: <1442581036-23789-9-git-send-email-clabbe.montjoie@gmail.com>
References: <1442581036-23789-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	clabbe.montjoie@gmail.com, cristian.stoica@freescale.com,
	fabio.estevam@freescale.com, horia.geanta@freescale.com,
	steve.cornelius@freescale.com, vicki.milhoan@freescale.com,
	yanjiang.jin@windriver.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442581036-23789-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The caam driver use a modified version of sg_nents_for_len
called __sg_count.
This function is now availlable in lib/scatterlist.c

Replace __sg_count by sg_nents_len_chained

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/caam/caamhash.c   | 14 ++++++++------
 drivers/crypto/caam/sg_sw_sec4.h | 20 +-------------------
 2 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 94433b9..116af3e 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -797,8 +797,9 @@ static int ahash_update_ctx(struct ahash_request *req)
 	to_hash = in_len - *next_buflen;
 
 	if (to_hash) {
-		src_nents = __sg_count(req->src, req->nbytes - (*next_buflen),
-				       &chained);
+		src_nents = sg_nents_len_chained(req->src,
+						 req->nbytes - (*next_buflen),
+						 &chained);
 		sec4_sg_src_index = 1 + (*buflen ? 1 : 0);
 		sec4_sg_bytes = (sec4_sg_src_index + src_nents) *
 				 sizeof(struct sec4_sg_entry);
@@ -1000,7 +1001,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	int ret = 0;
 	int sh_len;
 
-	src_nents = __sg_count(req->src, req->nbytes, &chained);
+	src_nents = sg_nents_len_chained(req->src, req->nbytes, &chained);
 	sec4_sg_src_index = 1 + (buflen ? 1 : 0);
 	sec4_sg_bytes = (sec4_sg_src_index + src_nents) *
 			 sizeof(struct sec4_sg_entry);
@@ -1236,8 +1237,9 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	to_hash = in_len - *next_buflen;
 
 	if (to_hash) {
-		src_nents = __sg_count(req->src, req->nbytes - (*next_buflen),
-				       &chained);
+		src_nents = sg_nents_len_chained(req->src,
+						 req->nbytes - (*next_buflen),
+						 &chained);
 		sec4_sg_bytes = (1 + src_nents) *
 				sizeof(struct sec4_sg_entry);
 
@@ -1347,7 +1349,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	int sh_len;
 	int ret = 0;
 
-	src_nents = __sg_count(req->src, req->nbytes, &chained);
+	src_nents = sg_nents_len_chained(req->src, req->nbytes, &chained);
 	sec4_sg_src_index = 2;
 	sec4_sg_bytes = (sec4_sg_src_index + src_nents) *
 			 sizeof(struct sec4_sg_entry);
diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
index 18cd6d1..0575a8e 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -69,29 +69,11 @@ static inline struct sec4_sg_entry *sg_to_sec4_sg_len(
 	return sec4_sg_ptr - 1;
 }
 
-/* count number of elements in scatterlist */
-static inline int __sg_count(struct scatterlist *sg_list, int nbytes,
-			     bool *chained)
-{
-	struct scatterlist *sg = sg_list;
-	int sg_nents = 0;
-
-	while (nbytes > 0) {
-		sg_nents++;
-		nbytes -= sg->length;
-		if (!sg_is_last(sg) && (sg + 1)->length == 0)
-			*chained = true;
-		sg = sg_next(sg);
-	}
-
-	return sg_nents;
-}
-
 /* derive number of elements in scatterlist, but return 0 for 1 */
 static inline int sg_count(struct scatterlist *sg_list, int nbytes,
 			     bool *chained)
 {
-	int sg_nents = __sg_count(sg_list, nbytes, chained);
+	int sg_nents = sg_nents_len_chained(sg_list, nbytes, chained);
 
 	if (likely(sg_nents == 1))
 		return 0;
-- 
2.4.6
