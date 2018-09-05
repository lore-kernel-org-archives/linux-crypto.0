From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-crypt and dm-integrity: disable
 CRYPTO_TFM_REQ_MAY_SLEEP to fix a deadlock
Date: Wed, 5 Sep 2018 09:17:45 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1809050914050.28658@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: david@fromorbit.com, dm-devel@redhat.com, peter.klotz99@gmail.com,
	linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
To: Mike Snitzer <msnitzer@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

There's a deadlock reported here:
https://bugzilla.kernel.org/show_bug.cgi?id=200835

* dm-crypt calls crypt_convert in xts mode
* init_crypt from xts.c calls kmalloc(GFP_KERNEL)
* kmalloc(GFP_KERNEL) recurses into the XFS filesystem, the filesystem
	tries to submit some bios and wait for them, causing a deadlock

This patch drops the flag CRYPTO_TFM_REQ_MAY_SLEEP, which will change the
allocation from GFP_KERNEL to GFP_ATOMIC, therefore it can't recurse into
a filesystem. The GFP_ATOMIC allocation can fail, but the function
init_crypt in xts.c handles the allocation failure gracefully - it will
fall back to preallocated buffer in the allocation fails.

The crypto API maintainer says that the crypto API only needs to allocate
memory when dealing with unaligned buffers and therefore turning
CRYPTO_TFM_REQ_MAY_SLEEP off is safe (see this discussion:
https://www.redhat.com/archives/dm-devel/2018-August/msg00195.html )

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-crypt.c     |   10 +++++-----
 drivers/md/dm-integrity.c |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c	2018-09-03 18:17:44.190000000 +0200
+++ linux-2.6/drivers/md/dm-crypt.c	2018-09-04 21:36:58.460000000 +0200
@@ -332,7 +332,7 @@ static int crypt_iv_essiv_init(struct cr
 	int err;
 
 	desc->tfm = essiv->hash_tfm;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	desc->flags = 0;
 
 	err = crypto_shash_digest(desc, cc->key, cc->key_size, essiv->salt);
 	shash_desc_zero(desc);
@@ -606,7 +606,7 @@ static int crypt_iv_lmk_one(struct crypt
 	int i, r;
 
 	desc->tfm = lmk->hash_tfm;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	desc->flags = 0;
 
 	r = crypto_shash_init(desc);
 	if (r)
@@ -768,7 +768,7 @@ static int crypt_iv_tcw_whitening(struct
 
 	/* calculate crc32 for every 32bit part and xor it */
 	desc->tfm = tcw->crc32_tfm;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	desc->flags = 0;
 	for (i = 0; i < 4; i++) {
 		r = crypto_shash_init(desc);
 		if (r)
@@ -1251,7 +1251,7 @@ static void crypt_alloc_req_skcipher(str
 	 * requests if driver request queue is full.
 	 */
 	skcipher_request_set_callback(ctx->r.req,
-	    CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
+	    CRYPTO_TFM_REQ_MAY_BACKLOG,
 	    kcryptd_async_done, dmreq_of_req(cc, ctx->r.req));
 }
 
@@ -1268,7 +1268,7 @@ static void crypt_alloc_req_aead(struct
 	 * requests if driver request queue is full.
 	 */
 	aead_request_set_callback(ctx->r.req_aead,
-	    CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
+	    CRYPTO_TFM_REQ_MAY_BACKLOG,
 	    kcryptd_async_done, dmreq_of_req(cc, ctx->r.req_aead));
 }
 
Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2018-09-03 18:17:44.180000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2018-09-04 21:37:41.230000000 +0200
@@ -532,7 +532,7 @@ static void section_mac(struct dm_integr
 	unsigned j, size;
 
 	desc->tfm = ic->journal_mac;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	desc->flags = 0;
 
 	r = crypto_shash_init(desc);
 	if (unlikely(r)) {
@@ -676,7 +676,7 @@ static void complete_journal_encrypt(str
 static bool do_crypt(bool encrypt, struct skcipher_request *req, struct journal_completion *comp)
 {
 	int r;
-	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				      complete_journal_encrypt, comp);
 	if (likely(encrypt))
 		r = crypto_skcipher_encrypt(req);
