From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v6 12/18] drbd: Convert from ahash to shash
Date: Tue, 24 Jul 2018 09:49:30 -0700
Message-ID: <20180724164936.37477-13-keescook@chromium.org>
References: <20180724164936.37477-1-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Mike Snitzer <snitzer@redhat.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	linux-wireless@vger.kernel.org,
	Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
	David Howells <dhowells@redhat.com>, dm-devel@redhat.com,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-afs@lists.infradead.org,
	Alasdair Kergon <agk@redhat.com>,
	Kees Cook <keescook@chromium.org>, devel@driverdev.osuosl.org,
	x86@kernel.org, qat-linux@intel.com, Ingo Molnar <mingo@redhat.com>,
	Eric Biggers <ebiggers@google.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	drbd-dev@lists.linbit.com, Rabin Vincent <rabinv@axis.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
	linux-block@vger.kernel.org, Josh Poimboeuf
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180724164936.37477-1-keescook@chromium.org>
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

In preparing to remove all stack VLA usage from the kernel[1], this
removes the discouraged use of AHASH_REQUEST_ON_STACK in favor of
the smaller SHASH_DESC_ON_STACK by converting from ahash-wrapped-shash
to direct shash. By removing a layer of indirection this both improves
performance and reduces stack usage. The stack allocation will be made
a fixed size in a later patch to the crypto subsystem.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/block/drbd/drbd_int.h      | 13 +++----
 drivers/block/drbd/drbd_main.c     | 14 ++++----
 drivers/block/drbd/drbd_nl.c       | 39 +++++++--------------
 drivers/block/drbd/drbd_receiver.c | 35 ++++++++++---------
 drivers/block/drbd/drbd_worker.c   | 56 +++++++++++++-----------------
 5 files changed, 69 insertions(+), 88 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index bc4ed2ed40a2..97d8e290c2be 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -726,10 +726,10 @@ struct drbd_connection {
 	struct list_head transfer_log;	/* all requests not yet fully processed */
 
 	struct crypto_shash *cram_hmac_tfm;
-	struct crypto_ahash *integrity_tfm;  /* checksums we compute, updates protected by connection->data->mutex */
-	struct crypto_ahash *peer_integrity_tfm;  /* checksums we verify, only accessed from receiver thread  */
-	struct crypto_ahash *csums_tfm;
-	struct crypto_ahash *verify_tfm;
+	struct crypto_shash *integrity_tfm;  /* checksums we compute, updates protected by connection->data->mutex */
+	struct crypto_shash *peer_integrity_tfm;  /* checksums we verify, only accessed from receiver thread  */
+	struct crypto_shash *csums_tfm;
+	struct crypto_shash *verify_tfm;
 	void *int_dig_in;
 	void *int_dig_vv;
 
@@ -1533,8 +1533,9 @@ static inline void ov_out_of_sync_print(struct drbd_device *device)
 }
 
 
-extern void drbd_csum_bio(struct crypto_ahash *, struct bio *, void *);
-extern void drbd_csum_ee(struct crypto_ahash *, struct drbd_peer_request *, void *);
+extern void drbd_csum_bio(struct crypto_shash *, struct bio *, void *);
+extern void drbd_csum_ee(struct crypto_shash *, struct drbd_peer_request *,
+			 void *);
 /* worker callbacks */
 extern int w_e_end_data_req(struct drbd_work *, int);
 extern int w_e_end_rsdata_req(struct drbd_work *, int);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a80809bd3057..ccb54791d39c 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1377,7 +1377,7 @@ void drbd_send_ack_dp(struct drbd_peer_device *peer_device, enum drbd_packet cmd
 		      struct p_data *dp, int data_size)
 {
 	if (peer_device->connection->peer_integrity_tfm)
-		data_size -= crypto_ahash_digestsize(peer_device->connection->peer_integrity_tfm);
+		data_size -= crypto_shash_digestsize(peer_device->connection->peer_integrity_tfm);
 	_drbd_send_ack(peer_device, cmd, dp->sector, cpu_to_be32(data_size),
 		       dp->block_id);
 }
@@ -1690,7 +1690,7 @@ int drbd_send_dblock(struct drbd_peer_device *peer_device, struct drbd_request *
 	sock = &peer_device->connection->data;
 	p = drbd_prepare_command(peer_device, sock);
 	digest_size = peer_device->connection->integrity_tfm ?
-		      crypto_ahash_digestsize(peer_device->connection->integrity_tfm) : 0;
+		      crypto_shash_digestsize(peer_device->connection->integrity_tfm) : 0;
 
 	if (!p)
 		return -EIO;
@@ -1796,7 +1796,7 @@ int drbd_send_block(struct drbd_peer_device *peer_device, enum drbd_packet cmd,
 	p = drbd_prepare_command(peer_device, sock);
 
 	digest_size = peer_device->connection->integrity_tfm ?
-		      crypto_ahash_digestsize(peer_device->connection->integrity_tfm) : 0;
+		      crypto_shash_digestsize(peer_device->connection->integrity_tfm) : 0;
 
 	if (!p)
 		return -EIO;
@@ -2561,11 +2561,11 @@ void conn_free_crypto(struct drbd_connection *connection)
 {
 	drbd_free_sock(connection);
 
-	crypto_free_ahash(connection->csums_tfm);
-	crypto_free_ahash(connection->verify_tfm);
+	crypto_free_shash(connection->csums_tfm);
+	crypto_free_shash(connection->verify_tfm);
 	crypto_free_shash(connection->cram_hmac_tfm);
-	crypto_free_ahash(connection->integrity_tfm);
-	crypto_free_ahash(connection->peer_integrity_tfm);
+	crypto_free_shash(connection->integrity_tfm);
+	crypto_free_shash(connection->peer_integrity_tfm);
 	kfree(connection->int_dig_in);
 	kfree(connection->int_dig_vv);
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index b4f02768ba47..d15703b1ffe8 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2303,10 +2303,10 @@ check_net_options(struct drbd_connection *connection, struct net_conf *new_net_c
 }
 
 struct crypto {
-	struct crypto_ahash *verify_tfm;
-	struct crypto_ahash *csums_tfm;
+	struct crypto_shash *verify_tfm;
+	struct crypto_shash *csums_tfm;
 	struct crypto_shash *cram_hmac_tfm;
-	struct crypto_ahash *integrity_tfm;
+	struct crypto_shash *integrity_tfm;
 };
 
 static int
@@ -2324,36 +2324,21 @@ alloc_shash(struct crypto_shash **tfm, char *tfm_name, int err_alg)
 	return NO_ERROR;
 }
 
-static int
-alloc_ahash(struct crypto_ahash **tfm, char *tfm_name, int err_alg)
-{
-	if (!tfm_name[0])
-		return NO_ERROR;
-
-	*tfm = crypto_alloc_ahash(tfm_name, 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(*tfm)) {
-		*tfm = NULL;
-		return err_alg;
-	}
-
-	return NO_ERROR;
-}
-
 static enum drbd_ret_code
 alloc_crypto(struct crypto *crypto, struct net_conf *new_net_conf)
 {
 	char hmac_name[CRYPTO_MAX_ALG_NAME];
 	enum drbd_ret_code rv;
 
-	rv = alloc_ahash(&crypto->csums_tfm, new_net_conf->csums_alg,
+	rv = alloc_shash(&crypto->csums_tfm, new_net_conf->csums_alg,
 			 ERR_CSUMS_ALG);
 	if (rv != NO_ERROR)
 		return rv;
-	rv = alloc_ahash(&crypto->verify_tfm, new_net_conf->verify_alg,
+	rv = alloc_shash(&crypto->verify_tfm, new_net_conf->verify_alg,
 			 ERR_VERIFY_ALG);
 	if (rv != NO_ERROR)
 		return rv;
-	rv = alloc_ahash(&crypto->integrity_tfm, new_net_conf->integrity_alg,
+	rv = alloc_shash(&crypto->integrity_tfm, new_net_conf->integrity_alg,
 			 ERR_INTEGRITY_ALG);
 	if (rv != NO_ERROR)
 		return rv;
@@ -2371,9 +2356,9 @@ alloc_crypto(struct crypto *crypto, struct net_conf *new_net_conf)
 static void free_crypto(struct crypto *crypto)
 {
 	crypto_free_shash(crypto->cram_hmac_tfm);
-	crypto_free_ahash(crypto->integrity_tfm);
-	crypto_free_ahash(crypto->csums_tfm);
-	crypto_free_ahash(crypto->verify_tfm);
+	crypto_free_shash(crypto->integrity_tfm);
+	crypto_free_shash(crypto->csums_tfm);
+	crypto_free_shash(crypto->verify_tfm);
 }
 
 int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
@@ -2450,17 +2435,17 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	rcu_assign_pointer(connection->net_conf, new_net_conf);
 
 	if (!rsr) {
-		crypto_free_ahash(connection->csums_tfm);
+		crypto_free_shash(connection->csums_tfm);
 		connection->csums_tfm = crypto.csums_tfm;
 		crypto.csums_tfm = NULL;
 	}
 	if (!ovr) {
-		crypto_free_ahash(connection->verify_tfm);
+		crypto_free_shash(connection->verify_tfm);
 		connection->verify_tfm = crypto.verify_tfm;
 		crypto.verify_tfm = NULL;
 	}
 
-	crypto_free_ahash(connection->integrity_tfm);
+	crypto_free_shash(connection->integrity_tfm);
 	connection->integrity_tfm = crypto.integrity_tfm;
 	if (connection->cstate >= C_WF_REPORT_PARAMS && connection->agreed_pro_version >= 100)
 		/* Do this without trying to take connection->data.mutex again.  */
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index be9450f5ad1c..76243e9ef277 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1732,7 +1732,7 @@ static int receive_Barrier(struct drbd_connection *connection, struct packet_inf
 }
 
 /* quick wrapper in case payload size != request_size (write same) */
-static void drbd_csum_ee_size(struct crypto_ahash *h,
+static void drbd_csum_ee_size(struct crypto_shash *h,
 			      struct drbd_peer_request *r, void *d,
 			      unsigned int payload_size)
 {
@@ -1769,7 +1769,7 @@ read_in_block(struct drbd_peer_device *peer_device, u64 id, sector_t sector,
 
 	digest_size = 0;
 	if (!trim && peer_device->connection->peer_integrity_tfm) {
-		digest_size = crypto_ahash_digestsize(peer_device->connection->peer_integrity_tfm);
+		digest_size = crypto_shash_digestsize(peer_device->connection->peer_integrity_tfm);
 		/*
 		 * FIXME: Receive the incoming digest into the receive buffer
 		 *	  here, together with its struct p_data?
@@ -1905,7 +1905,7 @@ static int recv_dless_read(struct drbd_peer_device *peer_device, struct drbd_req
 
 	digest_size = 0;
 	if (peer_device->connection->peer_integrity_tfm) {
-		digest_size = crypto_ahash_digestsize(peer_device->connection->peer_integrity_tfm);
+		digest_size = crypto_shash_digestsize(peer_device->connection->peer_integrity_tfm);
 		err = drbd_recv_all_warn(peer_device->connection, dig_in, digest_size);
 		if (err)
 			return err;
@@ -3540,7 +3540,7 @@ static int receive_protocol(struct drbd_connection *connection, struct packet_in
 	int p_proto, p_discard_my_data, p_two_primaries, cf;
 	struct net_conf *nc, *old_net_conf, *new_net_conf = NULL;
 	char integrity_alg[SHARED_SECRET_MAX] = "";
-	struct crypto_ahash *peer_integrity_tfm = NULL;
+	struct crypto_shash *peer_integrity_tfm = NULL;
 	void *int_dig_in = NULL, *int_dig_vv = NULL;
 
 	p_proto		= be32_to_cpu(p->protocol);
@@ -3621,7 +3621,7 @@ static int receive_protocol(struct drbd_connection *connection, struct packet_in
 		 * change.
 		 */
 
-		peer_integrity_tfm = crypto_alloc_ahash(integrity_alg, 0, CRYPTO_ALG_ASYNC);
+		peer_integrity_tfm = crypto_alloc_shash(integrity_alg, 0, CRYPTO_ALG_ASYNC);
 		if (IS_ERR(peer_integrity_tfm)) {
 			peer_integrity_tfm = NULL;
 			drbd_err(connection, "peer data-integrity-alg %s not supported\n",
@@ -3629,7 +3629,7 @@ static int receive_protocol(struct drbd_connection *connection, struct packet_in
 			goto disconnect;
 		}
 
-		hash_size = crypto_ahash_digestsize(peer_integrity_tfm);
+		hash_size = crypto_shash_digestsize(peer_integrity_tfm);
 		int_dig_in = kmalloc(hash_size, GFP_KERNEL);
 		int_dig_vv = kmalloc(hash_size, GFP_KERNEL);
 		if (!(int_dig_in && int_dig_vv)) {
@@ -3659,7 +3659,7 @@ static int receive_protocol(struct drbd_connection *connection, struct packet_in
 	mutex_unlock(&connection->resource->conf_update);
 	mutex_unlock(&connection->data.mutex);
 
-	crypto_free_ahash(connection->peer_integrity_tfm);
+	crypto_free_shash(connection->peer_integrity_tfm);
 	kfree(connection->int_dig_in);
 	kfree(connection->int_dig_vv);
 	connection->peer_integrity_tfm = peer_integrity_tfm;
@@ -3677,7 +3677,7 @@ static int receive_protocol(struct drbd_connection *connection, struct packet_in
 disconnect_rcu_unlock:
 	rcu_read_unlock();
 disconnect:
-	crypto_free_ahash(peer_integrity_tfm);
+	crypto_free_shash(peer_integrity_tfm);
 	kfree(int_dig_in);
 	kfree(int_dig_vv);
 	conn_request_state(connection, NS(conn, C_DISCONNECTING), CS_HARD);
@@ -3689,15 +3689,16 @@ static int receive_protocol(struct drbd_connection *connection, struct packet_in
  * return: NULL (alg name was "")
  *         ERR_PTR(error) if something goes wrong
  *         or the crypto hash ptr, if it worked out ok. */
-static struct crypto_ahash *drbd_crypto_alloc_digest_safe(const struct drbd_device *device,
+static struct crypto_shash *drbd_crypto_alloc_digest_safe(
+		const struct drbd_device *device,
 		const char *alg, const char *name)
 {
-	struct crypto_ahash *tfm;
+	struct crypto_shash *tfm;
 
 	if (!alg[0])
 		return NULL;
 
-	tfm = crypto_alloc_ahash(alg, 0, CRYPTO_ALG_ASYNC);
+	tfm = crypto_alloc_shash(alg, 0, 0);
 	if (IS_ERR(tfm)) {
 		drbd_err(device, "Can not allocate \"%s\" as %s (reason: %ld)\n",
 			alg, name, PTR_ERR(tfm));
@@ -3750,8 +3751,8 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 	struct drbd_device *device;
 	struct p_rs_param_95 *p;
 	unsigned int header_size, data_size, exp_max_sz;
-	struct crypto_ahash *verify_tfm = NULL;
-	struct crypto_ahash *csums_tfm = NULL;
+	struct crypto_shash *verify_tfm = NULL;
+	struct crypto_shash *csums_tfm = NULL;
 	struct net_conf *old_net_conf, *new_net_conf = NULL;
 	struct disk_conf *old_disk_conf = NULL, *new_disk_conf = NULL;
 	const int apv = connection->agreed_pro_version;
@@ -3898,14 +3899,14 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 			if (verify_tfm) {
 				strcpy(new_net_conf->verify_alg, p->verify_alg);
 				new_net_conf->verify_alg_len = strlen(p->verify_alg) + 1;
-				crypto_free_ahash(peer_device->connection->verify_tfm);
+				crypto_free_shash(peer_device->connection->verify_tfm);
 				peer_device->connection->verify_tfm = verify_tfm;
 				drbd_info(device, "using verify-alg: \"%s\"\n", p->verify_alg);
 			}
 			if (csums_tfm) {
 				strcpy(new_net_conf->csums_alg, p->csums_alg);
 				new_net_conf->csums_alg_len = strlen(p->csums_alg) + 1;
-				crypto_free_ahash(peer_device->connection->csums_tfm);
+				crypto_free_shash(peer_device->connection->csums_tfm);
 				peer_device->connection->csums_tfm = csums_tfm;
 				drbd_info(device, "using csums-alg: \"%s\"\n", p->csums_alg);
 			}
@@ -3949,9 +3950,9 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 	mutex_unlock(&connection->resource->conf_update);
 	/* just for completeness: actually not needed,
 	 * as this is not reached if csums_tfm was ok. */
-	crypto_free_ahash(csums_tfm);
+	crypto_free_shash(csums_tfm);
 	/* but free the verify_tfm again, if csums_tfm did not work out */
-	crypto_free_ahash(verify_tfm);
+	crypto_free_shash(verify_tfm);
 	conn_request_state(peer_device->connection, NS(conn, C_DISCONNECTING), CS_HARD);
 	return -EIO;
 }
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 1476cb3439f4..62dd3700dd84 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -295,60 +295,54 @@ void drbd_request_endio(struct bio *bio)
 		complete_master_bio(device, &m);
 }
 
-void drbd_csum_ee(struct crypto_ahash *tfm, struct drbd_peer_request *peer_req, void *digest)
+void drbd_csum_ee(struct crypto_shash *tfm, struct drbd_peer_request *peer_req, void *digest)
 {
-	AHASH_REQUEST_ON_STACK(req, tfm);
-	struct scatterlist sg;
+	SHASH_DESC_ON_STACK(desc, tfm);
 	struct page *page = peer_req->pages;
 	struct page *tmp;
 	unsigned len;
 
-	ahash_request_set_tfm(req, tfm);
-	ahash_request_set_callback(req, 0, NULL, NULL);
+	desc->tfm = tfm;
+	desc->flags = 0;
 
-	sg_init_table(&sg, 1);
-	crypto_ahash_init(req);
+	crypto_shash_init(desc);
 
 	while ((tmp = page_chain_next(page))) {
 		/* all but the last page will be fully used */
-		sg_set_page(&sg, page, PAGE_SIZE, 0);
-		ahash_request_set_crypt(req, &sg, NULL, sg.length);
-		crypto_ahash_update(req);
+		crypto_shash_update(desc, page_to_virt(page), PAGE_SIZE);
 		page = tmp;
 	}
 	/* and now the last, possibly only partially used page */
 	len = peer_req->i.size & (PAGE_SIZE - 1);
-	sg_set_page(&sg, page, len ?: PAGE_SIZE, 0);
-	ahash_request_set_crypt(req, &sg, digest, sg.length);
-	crypto_ahash_finup(req);
-	ahash_request_zero(req);
+	crypto_shash_update(desc, page_to_virt(page), len ?: PAGE_SIZE);
+
+	crypto_shash_final(desc, digest);
+	shash_desc_zero(desc);
 }
 
-void drbd_csum_bio(struct crypto_ahash *tfm, struct bio *bio, void *digest)
+void drbd_csum_bio(struct crypto_shash *tfm, struct bio *bio, void *digest)
 {
-	AHASH_REQUEST_ON_STACK(req, tfm);
-	struct scatterlist sg;
+	SHASH_DESC_ON_STACK(desc, tfm);
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 
-	ahash_request_set_tfm(req, tfm);
-	ahash_request_set_callback(req, 0, NULL, NULL);
+	desc->tfm = tfm;
+	desc->flags = 0;
 
-	sg_init_table(&sg, 1);
-	crypto_ahash_init(req);
+	crypto_shash_init(desc);
 
 	bio_for_each_segment(bvec, bio, iter) {
-		sg_set_page(&sg, bvec.bv_page, bvec.bv_len, bvec.bv_offset);
-		ahash_request_set_crypt(req, &sg, NULL, sg.length);
-		crypto_ahash_update(req);
+		crypto_shash_update(desc, (u8 *)page_to_virt(bvec.bv_page) +
+					  bvec.bv_offset,
+				    bvec.bv_len);
+
 		/* REQ_OP_WRITE_SAME has only one segment,
 		 * checksum the payload only once. */
 		if (bio_op(bio) == REQ_OP_WRITE_SAME)
 			break;
 	}
-	ahash_request_set_crypt(req, NULL, digest, 0);
-	crypto_ahash_final(req);
-	ahash_request_zero(req);
+	crypto_shash_final(desc, digest);
+	shash_desc_zero(desc);
 }
 
 /* MAYBE merge common code with w_e_end_ov_req */
@@ -367,7 +361,7 @@ static int w_e_send_csum(struct drbd_work *w, int cancel)
 	if (unlikely((peer_req->flags & EE_WAS_ERROR) != 0))
 		goto out;
 
-	digest_size = crypto_ahash_digestsize(peer_device->connection->csums_tfm);
+	digest_size = crypto_shash_digestsize(peer_device->connection->csums_tfm);
 	digest = kmalloc(digest_size, GFP_NOIO);
 	if (digest) {
 		sector_t sector = peer_req->i.sector;
@@ -1205,7 +1199,7 @@ int w_e_end_csum_rs_req(struct drbd_work *w, int cancel)
 		 * a real fix would be much more involved,
 		 * introducing more locking mechanisms */
 		if (peer_device->connection->csums_tfm) {
-			digest_size = crypto_ahash_digestsize(peer_device->connection->csums_tfm);
+			digest_size = crypto_shash_digestsize(peer_device->connection->csums_tfm);
 			D_ASSERT(device, digest_size == di->digest_size);
 			digest = kmalloc(digest_size, GFP_NOIO);
 		}
@@ -1255,7 +1249,7 @@ int w_e_end_ov_req(struct drbd_work *w, int cancel)
 	if (unlikely(cancel))
 		goto out;
 
-	digest_size = crypto_ahash_digestsize(peer_device->connection->verify_tfm);
+	digest_size = crypto_shash_digestsize(peer_device->connection->verify_tfm);
 	digest = kmalloc(digest_size, GFP_NOIO);
 	if (!digest) {
 		err = 1;	/* terminate the connection in case the allocation failed */
@@ -1327,7 +1321,7 @@ int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 	di = peer_req->digest;
 
 	if (likely((peer_req->flags & EE_WAS_ERROR) == 0)) {
-		digest_size = crypto_ahash_digestsize(peer_device->connection->verify_tfm);
+		digest_size = crypto_shash_digestsize(peer_device->connection->verify_tfm);
 		digest = kmalloc(digest_size, GFP_NOIO);
 		if (digest) {
 			drbd_csum_ee(peer_device->connection->verify_tfm, peer_req, digest);
-- 
2.17.1
