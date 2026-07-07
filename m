Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29328395AEC;
	Tue,  7 Jul 2026 05:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402647; cv=none; b=HsGmxknBkPVU4Zne8PotDdB3I6hC6M5x6pDmsa1yA5KL3XDI6OlETrWE2y3+PvyPZSSmfJfiLp3hbG5km/bWg1S1839ShGQjQ+vP2xMl8sR1orIB9eE1e2NTxqaQ3C2UimnfD+f14hYEAAq10GFno2OHt/Ad6LhQ5tBXvuHxf6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402647; c=relaxed/simple;
	bh=dqh3tN7tTDxdgajvzjqDzLLyMSZk8tMwGkeYGWXJKYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGv4h5FHOklHjb8iqnJ1NFPYJ+OiIIof072DmcAWHdVwh3IGmbPu/2nh3W8phRChViUmuN02ImlHvATerHjwII7kUmhYTzEGY/fhvR1G2HMHRhqhRyd0UtHotuLocs0He08yUMxe9hI+NLAeQszLzAp58pfGWpUO+LF34kjWkSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ChzuW36V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ChzuW36V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6E61F00A3A;
	Tue,  7 Jul 2026 05:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402642;
	bh=fuCtmizYVu2go/Sl0HaGjNLOqrmU8F87b4kiPExmqSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ChzuW36VntkFp0MO2N8HC02iMjnlhNucOy+oDpsm8h19vwZswPsitnnGtE1ZjvFTc
	 DO8afwpcFOmdbPgnEJjyz0dr+hgSUattpH+Tm1dvrGs53grfq2j6HAfVUehwtP9bic
	 Cg5jF4lUylweSmPy9OOCSz3r9G68ZihkusLyzOKE6YUVpIV2h56JP5wZgpllafhOu6
	 RAka917u1Skm5n1GF8n5vsXJ7Wghjl4PcC5ZIGmQZoOsNKXbQ4QpROpUSDm+o9I/xQ
	 PT9gLu0WXKi5KjO+pmZ5sMAjTOXOZyXiyqoV79mOY/0277M677H7CetH51Ac7IHFj5
	 ISUcOrUpzz6tA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 22/33] libceph: Reimplement messenger v2 encryption using AES-GCM library
Date: Mon,  6 Jul 2026 22:34:52 -0700
Message-ID: <20260707053503.209874-23-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260707053503.209874-1-ebiggers@kernel.org>
References: <20260707053503.209874-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Significantly rework the implementation of Ceph messenger v2 to use the
new AES-GCM library instead of a "gcm(aes)" crypto_aead.

This especially takes advantage of the library's support for virtual
addresses and incremental en/decryption.  crypto_aead only supports
scatterlists and has no support for incremental operations, which
created significant difficulties for the Ceph messenger v2 code.

- For decryption (receive), the new code receives and decrypts the data
  directly into its destination buffers, or into a bounce page when the
  existing rxbounce mount option is enabled.  This unifies the code
  significantly with the non-secure case.

  Previously, the entire received message tail (potentially tens of
  megabytes) was buffered in a list of bounce pages.  Then two
  scatterlists were generated: one for all the different destination
  buffers and one for the bounce pages.  Besides being very complex, the
  memory use was likely problematic as well.  All that is removed.

- For encryption (send), similar changes are made.  It differs slightly
  in that a bounce page is still needed unconditionally.  But the single
  page just keeps getting reused, which is much more efficient.

As a bonus, this conversion also eliminates the broken code that
intended to allocate crypto_aead objects from a GFP_NOIO context.  That
isn't actually supported: crypto_alloc_aead() takes crypto_alg_sem which
isn't GFP_NOIO safe, and it can also load kernel modules.

Note: incremental GCM decryption is sometimes perceived as dangerous, as
it invites users to consume data before the auth tag is verified.  It
does seem to be safe here though, as success isn't reported up the stack
until the very end.  (Also, the old code didn't verify the tag until the
data had already been written into the destination buffers either.)

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/linux/ceph/messenger.h |  22 +-
 net/ceph/Kconfig               |   2 +-
 net/ceph/messenger_v2.c        | 963 ++++++++++++---------------------
 3 files changed, 357 insertions(+), 630 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 6aa4c6478c9f..eda9729023ef 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -2,9 +2,9 @@
 #ifndef __FS_CEPH_MESSENGER_H
 #define __FS_CEPH_MESSENGER_H
 
+#include <crypto/aes-gcm.h>
 #include <crypto/sha2.h>
 #include <linux/bvec.h>
-#include <linux/crypto.h>
 #include <linux/kref.h>
 #include <linux/mutex.h>
 #include <linux/net.h>
@@ -401,8 +401,7 @@ struct ceph_connection_v2_info {
 
 	struct iov_iter out_iter;
 	struct kvec out_kvecs[8];  /* sendmsg */
-	struct bio_vec out_bvec;  /* sendpage (out_cursor, out_zero),
-				     sendmsg (out_enc_pages) */
+	struct bio_vec out_bvec; /* sendpage (out_cursor, out_zero) */
 	int out_kvec_cnt;
 	int out_state;  /* OUT_S_* */
 
@@ -415,20 +414,15 @@ struct ceph_connection_v2_info {
 
 	struct hmac_sha256_key hmac_key;  /* post-auth signature */
 	bool hmac_key_set;
-	struct crypto_aead *gcm_tfm;  /* on-wire encryption */
-	struct aead_request *gcm_req;
-	struct crypto_wait gcm_wait;
+	struct aes_gcm_key gcm_key; /* on-wire encryption */
+	bool gcm_key_set;
 	struct ceph_gcm_nonce in_gcm_nonce;
 	struct ceph_gcm_nonce out_gcm_nonce;
 
-	struct page **in_enc_pages;
-	int in_enc_page_cnt;
-	int in_enc_resid;
-	int in_enc_i;
-	struct page **out_enc_pages;
-	int out_enc_page_cnt;
-	int out_enc_resid;
-	int out_enc_i;
+	struct aes_gcm_ctx in_gcm_ctx;
+	struct aes_gcm_ctx out_gcm_ctx;
+	u8 *out_ciphertext;
+	u8 *out_front_middle_ciphertext;
 
 	int con_mode;  /* CEPH_CON_MODE_* */
 
diff --git a/net/ceph/Kconfig b/net/ceph/Kconfig
index 74aa2817253b..de9170c44ebb 100644
--- a/net/ceph/Kconfig
+++ b/net/ceph/Kconfig
@@ -3,9 +3,9 @@ config CEPH_LIB
 	tristate "Ceph core library"
 	depends on INET
 	select CRC32
-	select CRYPTO_GCM
 	select CRYPTO_KRB5
 	select CRYPTO_LIB_AES_CBC
+	select CRYPTO_LIB_AES_GCM
 	select CRYPTO_LIB_SHA256
 	select CRYPTO
 	select KEYS
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index 05f6eea299fc..7d7a99b6c008 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -7,15 +7,13 @@
 
 #include <linux/ceph/ceph_debug.h>
 
-#include <crypto/aead.h>
+#include <crypto/aes-gcm.h>
 #include <crypto/sha2.h>
 #include <crypto/utils.h>
 #include <linux/bvec.h>
 #include <linux/crc32c.h>
 #include <linux/net.h>
-#include <linux/scatterlist.h>
 #include <linux/socket.h>
-#include <linux/sched/mm.h>
 #include <net/sock.h>
 #include <net/tcp.h>
 
@@ -54,9 +52,9 @@
 #define IN_S_HANDLE_PREAMBLE			1
 #define IN_S_HANDLE_CONTROL			2
 #define IN_S_HANDLE_CONTROL_REMAINDER		3
-#define IN_S_PREPARE_READ_DATA			4
-#define IN_S_PREPARE_READ_DATA_CONT		5
-#define IN_S_PREPARE_READ_ENC_PAGE		6
+#define IN_S_DECRYPT_FRONT_AND_MIDDLE		4
+#define IN_S_PREPARE_READ_DATA			5
+#define IN_S_PREPARE_READ_DATA_CONT		6
 #define IN_S_PREPARE_SPARSE_DATA		7
 #define IN_S_PREPARE_SPARSE_DATA_CONT		8
 #define IN_S_HANDLE_EPILOGUE			9
@@ -64,18 +62,18 @@
 
 #define OUT_S_QUEUE_DATA		1
 #define OUT_S_QUEUE_DATA_CONT		2
-#define OUT_S_QUEUE_ENC_PAGE		3
-#define OUT_S_QUEUE_ZEROS		4
-#define OUT_S_FINISH_MESSAGE		5
-#define OUT_S_GET_NEXT			6
+#define OUT_S_QUEUE_ENC_DATA		3
+#define OUT_S_QUEUE_ENC_EPILOGUE	4
+#define OUT_S_QUEUE_ZEROS		5
+#define OUT_S_FINISH_MESSAGE		6
+#define OUT_S_GET_NEXT			7
 
 #define CTRL_BODY(p)	((void *)(p) + CEPH_PREAMBLE_LEN)
-#define FRONT_PAD(p)	((void *)(p) + CEPH_EPILOGUE_SECURE_LEN)
-#define MIDDLE_PAD(p)	(FRONT_PAD(p) + CEPH_GCM_BLOCK_LEN)
-#define DATA_PAD(p)	(MIDDLE_PAD(p) + CEPH_GCM_BLOCK_LEN)
 
 #define CEPH_MSG_FLAGS (MSG_DONTWAIT | MSG_NOSIGNAL)
 
+#define OUT_CIPHERTEXT_BUFFER_SIZE	PAGE_SIZE
+
 static int do_recvmsg(struct socket *sock, struct iov_iter *it)
 {
 	struct msghdr msg = { .msg_flags = CEPH_MSG_FLAGS };
@@ -424,10 +422,12 @@ static int __tail_onwire_len(int front_len, int middle_len, int data_len,
 	       padded_len(data_len) + CEPH_EPILOGUE_SECURE_LEN;
 }
 
-static int tail_onwire_len(const struct ceph_msg *msg, bool secure)
+static int data_padding_and_epilogue_onwire_len(struct ceph_connection *con,
+						int data_len)
 {
-	return __tail_onwire_len(front_len(msg), middle_len(msg),
-				 data_len(msg), secure);
+	if (con_secure(con))
+		return padding_len(data_len) + CEPH_EPILOGUE_SECURE_LEN;
+	return CEPH_EPILOGUE_PLAIN_LEN;
 }
 
 /* head_onwire_len(sizeof(struct ceph_msg_header2), false) */
@@ -702,12 +702,11 @@ static int setup_crypto(struct ceph_connection *con,
 			const u8 *session_key, int session_key_len,
 			const u8 *con_secret, int con_secret_len)
 {
-	unsigned int noio_flag;
 	int ret;
 
 	dout("%s con %p con_mode %d session_key_len %d con_secret_len %d\n",
 	     __func__, con, con->v2.con_mode, session_key_len, con_secret_len);
-	WARN_ON(con->v2.hmac_key_set || con->v2.gcm_tfm || con->v2.gcm_req);
+	WARN_ON(con->v2.hmac_key_set || con->v2.gcm_key_set);
 
 	if (con->v2.con_mode != CEPH_CON_MODE_CRC &&
 	    con->v2.con_mode != CEPH_CON_MODE_SECURE) {
@@ -734,46 +733,26 @@ static int setup_crypto(struct ceph_connection *con,
 		return -EINVAL;
 	}
 
-	noio_flag = memalloc_noio_save();
-	con->v2.gcm_tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
-	memalloc_noio_restore(noio_flag);
-	if (IS_ERR(con->v2.gcm_tfm)) {
-		ret = PTR_ERR(con->v2.gcm_tfm);
-		con->v2.gcm_tfm = NULL;
-		pr_err("failed to allocate gcm tfm context: %d\n", ret);
-		return ret;
-	}
-
-	WARN_ON((unsigned long)con_secret &
-		crypto_aead_alignmask(con->v2.gcm_tfm));
-	ret = crypto_aead_setkey(con->v2.gcm_tfm, con_secret, CEPH_GCM_KEY_LEN);
+	ret = aes_gcm_preparekey(&con->v2.gcm_key, con_secret, CEPH_GCM_KEY_LEN,
+				 CEPH_GCM_TAG_LEN);
 	if (ret) {
-		pr_err("failed to set gcm key: %d\n", ret);
+		/* This should never happen, since valid lengths were used. */
+		pr_err("failed to prepare gcm key: %d\n", ret);
 		return ret;
 	}
 
-	WARN_ON(crypto_aead_ivsize(con->v2.gcm_tfm) != CEPH_GCM_IV_LEN);
-	ret = crypto_aead_setauthsize(con->v2.gcm_tfm, CEPH_GCM_TAG_LEN);
-	if (ret) {
-		pr_err("failed to set gcm tag size: %d\n", ret);
-		return ret;
-	}
-
-	con->v2.gcm_req = aead_request_alloc(con->v2.gcm_tfm, GFP_NOIO);
-	if (!con->v2.gcm_req) {
-		pr_err("failed to allocate gcm request\n");
-		return -ENOMEM;
-	}
-
-	crypto_init_wait(&con->v2.gcm_wait);
-	aead_request_set_callback(con->v2.gcm_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  crypto_req_done, &con->v2.gcm_wait);
-
 	memcpy(&con->v2.in_gcm_nonce, con_secret + CEPH_GCM_KEY_LEN,
 	       CEPH_GCM_IV_LEN);
 	memcpy(&con->v2.out_gcm_nonce,
 	       con_secret + CEPH_GCM_KEY_LEN + CEPH_GCM_IV_LEN,
 	       CEPH_GCM_IV_LEN);
+	if (!con->v2.out_ciphertext) {
+		con->v2.out_ciphertext =
+			kmalloc(OUT_CIPHERTEXT_BUFFER_SIZE, GFP_NOIO);
+		if (!con->v2.out_ciphertext)
+			return -ENOMEM;
+	}
+	con->v2.gcm_key_set = true;
 	return 0;  /* auth_x, secure mode */
 }
 
@@ -807,27 +786,6 @@ static void gcm_inc_nonce(struct ceph_gcm_nonce *nonce)
 	nonce->counter = cpu_to_le64(counter + 1);
 }
 
-static int gcm_crypt(struct ceph_connection *con, bool encrypt,
-		     struct scatterlist *src, struct scatterlist *dst,
-		     int src_len)
-{
-	struct ceph_gcm_nonce *nonce;
-	int ret;
-
-	nonce = encrypt ? &con->v2.out_gcm_nonce : &con->v2.in_gcm_nonce;
-
-	aead_request_set_ad(con->v2.gcm_req, 0);  /* no AAD */
-	aead_request_set_crypt(con->v2.gcm_req, src, dst, src_len, (u8 *)nonce);
-	ret = crypto_wait_req(encrypt ? crypto_aead_encrypt(con->v2.gcm_req) :
-					crypto_aead_decrypt(con->v2.gcm_req),
-			      &con->v2.gcm_wait);
-	if (ret)
-		return ret;
-
-	gcm_inc_nonce(nonce);
-	return 0;
-}
-
 static void get_bvec_at(struct ceph_msg_data_cursor *cursor,
 			struct bio_vec *bv)
 {
@@ -845,309 +803,55 @@ static void get_bvec_at(struct ceph_msg_data_cursor *cursor,
 	bvec_set_page(bv, page, len, off);
 }
 
-static int calc_sg_cnt(void *buf, int buf_len)
-{
-	int sg_cnt;
-
-	if (!buf_len)
-		return 0;
-
-	sg_cnt = need_padding(buf_len) ? 1 : 0;
-	if (is_vmalloc_addr(buf)) {
-		WARN_ON(offset_in_page(buf));
-		sg_cnt += PAGE_ALIGN(buf_len) >> PAGE_SHIFT;
-	} else {
-		sg_cnt++;
-	}
-
-	return sg_cnt;
-}
-
-static int calc_sg_cnt_cursor(struct ceph_msg_data_cursor *cursor)
+static void ceph_aes_gcm_encrypt(u8 *data, u8 *authtag, size_t data_len,
+				 struct ceph_connection *con)
 {
-	int data_len = cursor->total_resid;
-	struct bio_vec bv;
-	int sg_cnt;
-
-	if (!data_len)
-		return 0;
-
-	sg_cnt = need_padding(data_len) ? 1 : 0;
-	do {
-		get_bvec_at(cursor, &bv);
-		sg_cnt++;
-
-		ceph_msg_data_advance(cursor, bv.bv_len);
-	} while (cursor->total_resid);
-
-	return sg_cnt;
+	aes_gcm_encrypt(data, authtag, data, data_len, NULL, 0,
+			(const u8 *)&con->v2.out_gcm_nonce, &con->v2.gcm_key);
+	gcm_inc_nonce(&con->v2.out_gcm_nonce);
 }
 
-static void init_sgs(struct scatterlist **sg, void *buf, int buf_len, u8 *pad)
+static int ceph_aes_gcm_decrypt(u8 *data, const u8 *authtag, size_t data_len,
+				struct ceph_connection *con)
 {
-	void *end = buf + buf_len;
-	struct page *page;
-	int len;
-	void *p;
-
-	if (!buf_len)
-		return;
-
-	if (is_vmalloc_addr(buf)) {
-		p = buf;
-		do {
-			page = vmalloc_to_page(p);
-			len = min_t(int, end - p, PAGE_SIZE);
-			WARN_ON(!page || !len || offset_in_page(p));
-			sg_set_page(*sg, page, len, 0);
-			*sg = sg_next(*sg);
-			p += len;
-		} while (p != end);
-	} else {
-		sg_set_buf(*sg, buf, buf_len);
-		*sg = sg_next(*sg);
-	}
-
-	if (need_padding(buf_len)) {
-		sg_set_buf(*sg, pad, padding_len(buf_len));
-		*sg = sg_next(*sg);
-	}
+	int err = aes_gcm_decrypt(data, data, authtag, data_len, NULL, 0,
+				  (const u8 *)&con->v2.in_gcm_nonce,
+				  &con->v2.gcm_key);
+	gcm_inc_nonce(&con->v2.in_gcm_nonce);
+	return err;
 }
 
-static void init_sgs_cursor(struct scatterlist **sg,
-			    struct ceph_msg_data_cursor *cursor, u8 *pad)
+static void ceph_aes_gcm_encrypt_init(struct ceph_connection *con)
 {
-	int data_len = cursor->total_resid;
-	struct bio_vec bv;
-
-	if (!data_len)
-		return;
-
-	do {
-		get_bvec_at(cursor, &bv);
-		sg_set_page(*sg, bv.bv_page, bv.bv_len, bv.bv_offset);
-		*sg = sg_next(*sg);
-
-		ceph_msg_data_advance(cursor, bv.bv_len);
-	} while (cursor->total_resid);
-
-	if (need_padding(data_len)) {
-		sg_set_buf(*sg, pad, padding_len(data_len));
-		*sg = sg_next(*sg);
-	}
+	aes_gcm_init(&con->v2.out_gcm_ctx, (const u8 *)&con->v2.out_gcm_nonce,
+		     &con->v2.gcm_key);
+	gcm_inc_nonce(&con->v2.out_gcm_nonce);
 }
 
-/**
- * init_sgs_pages: set up scatterlist on an array of page pointers
- * @sg:		scatterlist to populate
- * @pages:	pointer to page array
- * @dpos:	position in the array to start (bytes)
- * @dlen:	len to add to sg (bytes)
- * @pad:	pointer to pad destination (if any)
- *
- * Populate the scatterlist from the page array, starting at an arbitrary
- * byte in the array and running for a specified length.
- */
-static void init_sgs_pages(struct scatterlist **sg, struct page **pages,
-			   int dpos, int dlen, u8 *pad)
+static void ceph_aes_gcm_decrypt_init(struct ceph_connection *con)
 {
-	int idx = dpos >> PAGE_SHIFT;
-	int off = offset_in_page(dpos);
-	int resid = dlen;
-
-	do {
-		int len = min(resid, (int)PAGE_SIZE - off);
-
-		sg_set_page(*sg, pages[idx], len, off);
-		*sg = sg_next(*sg);
-		off = 0;
-		++idx;
-		resid -= len;
-	} while (resid);
-
-	if (need_padding(dlen)) {
-		sg_set_buf(*sg, pad, padding_len(dlen));
-		*sg = sg_next(*sg);
-	}
-}
-
-static int setup_message_sgs(struct sg_table *sgt, struct ceph_msg *msg,
-			     u8 *front_pad, u8 *middle_pad, u8 *data_pad,
-			     void *epilogue, struct page **pages, int dpos,
-			     bool add_tag)
-{
-	struct ceph_msg_data_cursor cursor;
-	struct scatterlist *cur_sg;
-	int dlen = data_len(msg);
-	int sg_cnt;
-	int ret;
-
-	if (!front_len(msg) && !middle_len(msg) && !data_len(msg))
-		return 0;
-
-	sg_cnt = 1;  /* epilogue + [auth tag] */
-	if (front_len(msg))
-		sg_cnt += calc_sg_cnt(msg->front.iov_base,
-				      front_len(msg));
-	if (middle_len(msg))
-		sg_cnt += calc_sg_cnt(msg->middle->vec.iov_base,
-				      middle_len(msg));
-	if (dlen) {
-		if (pages) {
-			sg_cnt += calc_pages_for(dpos, dlen);
-			if (need_padding(dlen))
-				sg_cnt++;
-		} else {
-			ceph_msg_data_cursor_init(&cursor, msg, dlen);
-			sg_cnt += calc_sg_cnt_cursor(&cursor);
-		}
-	}
-
-	ret = sg_alloc_table(sgt, sg_cnt, GFP_NOIO);
-	if (ret)
-		return ret;
-
-	cur_sg = sgt->sgl;
-	if (front_len(msg))
-		init_sgs(&cur_sg, msg->front.iov_base, front_len(msg),
-			 front_pad);
-	if (middle_len(msg))
-		init_sgs(&cur_sg, msg->middle->vec.iov_base, middle_len(msg),
-			 middle_pad);
-	if (dlen) {
-		if (pages) {
-			init_sgs_pages(&cur_sg, pages, dpos, dlen, data_pad);
-		} else {
-			ceph_msg_data_cursor_init(&cursor, msg, dlen);
-			init_sgs_cursor(&cur_sg, &cursor, data_pad);
-		}
-	}
-
-	WARN_ON(!sg_is_last(cur_sg));
-	sg_set_buf(cur_sg, epilogue,
-		   CEPH_GCM_BLOCK_LEN + (add_tag ? CEPH_GCM_TAG_LEN : 0));
-	return 0;
-}
-
-static int decrypt_preamble(struct ceph_connection *con)
-{
-	struct scatterlist sg;
-
-	sg_init_one(&sg, con->v2.in_buf, CEPH_PREAMBLE_SECURE_LEN);
-	return gcm_crypt(con, false, &sg, &sg, CEPH_PREAMBLE_SECURE_LEN);
+	aes_gcm_init(&con->v2.in_gcm_ctx, (const u8 *)&con->v2.in_gcm_nonce,
+		     &con->v2.gcm_key);
+	gcm_inc_nonce(&con->v2.in_gcm_nonce);
 }
 
 static int decrypt_control_remainder(struct ceph_connection *con)
 {
 	int ctrl_len = con->v2.in_desc.fd_lens[0];
 	int rem_len = ctrl_len - CEPH_PREAMBLE_INLINE_LEN;
-	int pt_len = padding_len(rem_len) + CEPH_GCM_TAG_LEN;
-	struct scatterlist sgs[2];
+	int pad_len = padding_len(rem_len);
 
 	WARN_ON(con->v2.in_kvecs[0].iov_len != rem_len);
-	WARN_ON(con->v2.in_kvecs[1].iov_len != pt_len);
+	WARN_ON(con->v2.in_kvecs[1].iov_len != pad_len + CEPH_GCM_TAG_LEN);
 
-	sg_init_table(sgs, 2);
-	sg_set_buf(&sgs[0], con->v2.in_kvecs[0].iov_base, rem_len);
-	sg_set_buf(&sgs[1], con->v2.in_buf, pt_len);
-
-	return gcm_crypt(con, false, sgs, sgs,
-			 padded_len(rem_len) + CEPH_GCM_TAG_LEN);
-}
-
-/* Process sparse read data that lives in a buffer */
-static int process_v2_sparse_read(struct ceph_connection *con,
-				  struct page **pages, int spos)
-{
-	struct ceph_msg_data_cursor cursor;
-	int ret;
-
-	ceph_msg_data_cursor_init(&cursor, con->in_msg,
-				  con->in_msg->sparse_read_total);
-
-	for (;;) {
-		char *buf = NULL;
-
-		ret = con->ops->sparse_read(con, &cursor, &buf);
-		if (ret <= 0)
-			return ret;
-
-		dout("%s: sparse_read return %x buf %p\n", __func__, ret, buf);
-
-		do {
-			int idx = spos >> PAGE_SHIFT;
-			int soff = offset_in_page(spos);
-			struct page *spage = con->v2.in_enc_pages[idx];
-			int len = min_t(int, ret, PAGE_SIZE - soff);
-
-			if (buf) {
-				memcpy_from_page(buf, spage, soff, len);
-				buf += len;
-			} else {
-				struct bio_vec bv;
-
-				get_bvec_at(&cursor, &bv);
-				len = min_t(int, len, bv.bv_len);
-				memcpy_page(bv.bv_page, bv.bv_offset,
-					    spage, soff, len);
-				ceph_msg_data_advance(&cursor, len);
-			}
-			spos += len;
-			ret -= len;
-		} while (ret);
-	}
-}
-
-static int decrypt_tail(struct ceph_connection *con)
-{
-	struct sg_table enc_sgt = {};
-	struct sg_table sgt = {};
-	struct page **pages = NULL;
-	bool sparse = !!con->in_msg->sparse_read_total;
-	int dpos = 0;
-	int tail_len;
-	int ret;
-
-	tail_len = tail_onwire_len(con->in_msg, true);
-	ret = sg_alloc_table_from_pages(&enc_sgt, con->v2.in_enc_pages,
-					con->v2.in_enc_page_cnt, 0, tail_len,
-					GFP_NOIO);
-	if (ret)
-		goto out;
-
-	if (sparse) {
-		dpos = padded_len(front_len(con->in_msg) + padded_len(middle_len(con->in_msg)));
-		pages = con->v2.in_enc_pages;
-	}
-
-	ret = setup_message_sgs(&sgt, con->in_msg, FRONT_PAD(con->v2.in_buf),
-				MIDDLE_PAD(con->v2.in_buf), DATA_PAD(con->v2.in_buf),
-				con->v2.in_buf, pages, dpos, true);
-	if (ret)
-		goto out;
-
-	dout("%s con %p msg %p enc_page_cnt %d sg_cnt %d\n", __func__, con,
-	     con->in_msg, con->v2.in_enc_page_cnt, sgt.orig_nents);
-	ret = gcm_crypt(con, false, enc_sgt.sgl, sgt.sgl, tail_len);
-	if (ret)
-		goto out;
-
-	if (sparse && data_len(con->in_msg)) {
-		ret = process_v2_sparse_read(con, con->v2.in_enc_pages, dpos);
-		if (ret)
-			goto out;
-	}
-
-	WARN_ON(!con->v2.in_enc_page_cnt);
-	ceph_release_page_vector(con->v2.in_enc_pages,
-				 con->v2.in_enc_page_cnt);
-	con->v2.in_enc_pages = NULL;
-	con->v2.in_enc_page_cnt = 0;
-
-out:
-	sg_free_table(&sgt);
-	sg_free_table(&enc_sgt);
-	return ret;
+	ceph_aes_gcm_decrypt_init(con);
+	aes_gcm_decrypt_update(&con->v2.in_gcm_ctx,
+			       con->v2.in_kvecs[0].iov_base,
+			       con->v2.in_kvecs[0].iov_base, rem_len);
+	aes_gcm_decrypt_update(&con->v2.in_gcm_ctx, con->v2.in_buf,
+			       con->v2.in_buf, pad_len);
+	return aes_gcm_decrypt_final(&con->v2.in_gcm_ctx,
+				     con->v2.in_buf + pad_len);
 }
 
 static int prepare_banner(struct ceph_connection *con)
@@ -1219,25 +923,18 @@ static void prepare_head_plain(struct ceph_connection *con, void *base,
 	}
 }
 
-static int prepare_head_secure_small(struct ceph_connection *con,
-				     void *base, int ctrl_len)
+static void prepare_head_secure_small(struct ceph_connection *con, void *base,
+				      int ctrl_len)
 {
-	struct scatterlist sg;
-	int ret;
-
 	/* inline buffer padding? */
 	if (ctrl_len < CEPH_PREAMBLE_INLINE_LEN)
 		memset(CTRL_BODY(base) + ctrl_len, 0,
 		       CEPH_PREAMBLE_INLINE_LEN - ctrl_len);
 
-	sg_init_one(&sg, base, CEPH_PREAMBLE_SECURE_LEN);
-	ret = gcm_crypt(con, true, &sg, &sg,
-			CEPH_PREAMBLE_SECURE_LEN - CEPH_GCM_TAG_LEN);
-	if (ret)
-		return ret;
-
+	ceph_aes_gcm_encrypt(base,
+			     base + CEPH_PREAMBLE_SECURE_LEN - CEPH_GCM_TAG_LEN,
+			     CEPH_PREAMBLE_SECURE_LEN - CEPH_GCM_TAG_LEN, con);
 	add_out_kvec(con, base, CEPH_PREAMBLE_SECURE_LEN);
-	return 0;
 }
 
 /*
@@ -1260,36 +957,25 @@ static int prepare_head_secure_small(struct ceph_connection *con,
  *
  * Preamble should already be encoded at the start of base.
  */
-static int prepare_head_secure_big(struct ceph_connection *con,
-				   void *base, int ctrl_len)
+static void prepare_head_secure_big(struct ceph_connection *con, void *base,
+				    int ctrl_len)
 {
 	int rem_len = ctrl_len - CEPH_PREAMBLE_INLINE_LEN;
 	void *rem = CTRL_BODY(base) + CEPH_PREAMBLE_INLINE_LEN;
 	void *rem_tag = rem + padded_len(rem_len);
 	void *pmbl_tag = rem_tag + CEPH_GCM_TAG_LEN;
-	struct scatterlist sgs[2];
-	int ret;
 
-	sg_init_table(sgs, 2);
-	sg_set_buf(&sgs[0], base, rem - base);
-	sg_set_buf(&sgs[1], pmbl_tag, CEPH_GCM_TAG_LEN);
-	ret = gcm_crypt(con, true, sgs, sgs, rem - base);
-	if (ret)
-		return ret;
+	ceph_aes_gcm_encrypt(base, pmbl_tag, rem - base, con);
 
 	/* control remainder padding? */
 	if (need_padding(rem_len))
 		memset(rem + rem_len, 0, padding_len(rem_len));
 
-	sg_init_one(&sgs[0], rem, pmbl_tag - rem);
-	ret = gcm_crypt(con, true, sgs, sgs, rem_tag - rem);
-	if (ret)
-		return ret;
+	ceph_aes_gcm_encrypt(rem, rem_tag, rem_tag - rem, con);
 
 	add_out_kvec(con, base, rem - base);
 	add_out_kvec(con, pmbl_tag, CEPH_GCM_TAG_LEN);
 	add_out_kvec(con, rem, pmbl_tag - rem);
-	return 0;
 }
 
 static int __prepare_control(struct ceph_connection *con, int tag,
@@ -1298,7 +984,6 @@ static int __prepare_control(struct ceph_connection *con, int tag,
 {
 	int total_len = ctrl_len + extdata_len;
 	struct ceph_frame_desc desc;
-	int ret;
 
 	dout("%s con %p tag %d len %d (%d+%d)\n", __func__, con, tag,
 	     total_len, ctrl_len, extdata_len);
@@ -1316,12 +1001,10 @@ static int __prepare_control(struct ceph_connection *con, int tag,
 
 		if (ctrl_len <= CEPH_PREAMBLE_INLINE_LEN)
 			/* fully inlined, inline buffer may need padding */
-			ret = prepare_head_secure_small(con, base, ctrl_len);
+			prepare_head_secure_small(con, base, ctrl_len);
 		else
 			/* partially inlined, inline buffer is full */
-			ret = prepare_head_secure_big(con, base, ctrl_len);
-		if (ret)
-			return ret;
+			prepare_head_secure_big(con, base, ctrl_len);
 	} else {
 		prepare_head_plain(con, base, ctrl_len, extdata, extdata_len,
 				   to_be_signed);
@@ -1623,31 +1306,17 @@ static void prepare_message_plain(struct ceph_connection *con,
 	}
 }
 
-/*
- * Unfortunately the kernel crypto API doesn't support streaming
- * (piecewise) operation for AEAD algorithms, so we can't get away
- * with a fixed size buffer and a couple sgs.  Instead, we have to
- * allocate pages for the entire tail of the message (currently up
- * to ~32M) and two sgs arrays (up to ~256K each)...
- */
 static int prepare_message_secure(struct ceph_connection *con,
 				  struct ceph_msg *msg)
 {
-	void *zerop = page_address(ceph_zero_page);
-	struct sg_table enc_sgt = {};
-	struct sg_table sgt = {};
-	struct page **enc_pages;
-	int enc_page_cnt;
-	int tail_len;
-	int ret;
+	int front = front_len(msg);
+	int middle = middle_len(msg);
+	int data = data_len(msg);
 
-	ret = prepare_head_secure_small(con, con->v2.out_buf,
-					sizeof(struct ceph_msg_header2));
-	if (ret)
-		return ret;
+	prepare_head_secure_small(con, con->v2.out_buf,
+				  sizeof(struct ceph_msg_header2));
 
-	tail_len = tail_onwire_len(msg, true);
-	if (!tail_len) {
+	if (!front && !middle && !data) {
 		/*
 		 * Empty message: once the head is written,
 		 * we are done -- there is no epilogue.
@@ -1657,42 +1326,43 @@ static int prepare_message_secure(struct ceph_connection *con,
 	}
 
 	encode_epilogue_secure(con, false);
-	ret = setup_message_sgs(&sgt, msg, zerop, zerop, zerop,
-				&con->v2.out_epil, NULL, 0, false);
-	if (ret)
-		goto out;
 
-	enc_page_cnt = calc_pages_for(0, tail_len);
-	enc_pages = ceph_alloc_page_vector(enc_page_cnt, GFP_NOIO);
-	if (IS_ERR(enc_pages)) {
-		ret = PTR_ERR(enc_pages);
-		goto out;
-	}
+	ceph_aes_gcm_encrypt_init(con);
 
-	WARN_ON(con->v2.out_enc_pages || con->v2.out_enc_page_cnt);
-	con->v2.out_enc_pages = enc_pages;
-	con->v2.out_enc_page_cnt = enc_page_cnt;
-	con->v2.out_enc_resid = tail_len;
-	con->v2.out_enc_i = 0;
+	if (front || middle) {
+		u8 *bounce = con->v2.out_ciphertext;
+		int front_pad = padding_len(front);
+		int middle_pad = padding_len(middle);
+		int front_middle_len = padded_len(front) + padded_len(middle);
 
-	ret = sg_alloc_table_from_pages(&enc_sgt, enc_pages, enc_page_cnt,
-					0, tail_len, GFP_NOIO);
-	if (ret)
-		goto out;
+		if (front_middle_len > OUT_CIPHERTEXT_BUFFER_SIZE) {
+			bounce = kvmalloc(front_middle_len, GFP_NOIO);
+			if (!bounce)
+				return -ENOMEM;
+			con->v2.out_front_middle_ciphertext = bounce;
+		}
 
-	ret = gcm_crypt(con, true, sgt.sgl, enc_sgt.sgl,
-			tail_len - CEPH_GCM_TAG_LEN);
-	if (ret)
-		goto out;
+		/* Copy front and middle to bounce, and zero-pad them. */
+		memcpy(bounce, msg->front.iov_base, front);
+		memset(&bounce[front], 0, front_pad);
+		memcpy(&bounce[front + front_pad], msg->middle->vec.iov_base,
+		       middle);
+		memset(&bounce[front + front_pad + middle], 0, middle_pad);
 
-	dout("%s con %p msg %p sg_cnt %d enc_page_cnt %d\n", __func__, con,
-	     msg, sgt.orig_nents, enc_page_cnt);
-	con->v2.out_state = OUT_S_QUEUE_ENC_PAGE;
+		/* Encrypt and send the padded front and middle. */
+		aes_gcm_encrypt_update(&con->v2.out_gcm_ctx, bounce, bounce,
+				       front_middle_len);
+		add_out_kvec(con, bounce, front_middle_len);
+	}
 
-out:
-	sg_free_table(&sgt);
-	sg_free_table(&enc_sgt);
-	return ret;
+	if (data) {
+		ceph_msg_data_cursor_init(&con->v2.out_cursor, msg,
+					  data_len(msg));
+		con->v2.out_state = OUT_S_QUEUE_ENC_DATA;
+	} else {
+		con->v2.out_state = OUT_S_QUEUE_ENC_EPILOGUE;
+	}
+	return 0;
 }
 
 static int prepare_message(struct ceph_connection *con, struct ceph_msg *msg)
@@ -1833,7 +1503,8 @@ static int prepare_read_data(struct ceph_connection *con)
 {
 	struct bio_vec bv;
 
-	con->in_data_crc = -1;
+	if (!con_secure(con))
+		con->in_data_crc = -1;
 	ceph_msg_data_cursor_init(&con->v2.in_cursor, con->in_msg,
 				  data_len(con->in_msg));
 
@@ -1855,28 +1526,65 @@ static int prepare_read_data(struct ceph_connection *con)
 	return 0;
 }
 
-static void prepare_read_data_cont(struct ceph_connection *con)
+static void finalize_one_data_read_bvec(struct ceph_connection *con)
 {
-	struct bio_vec bv;
+	int len = con->v2.in_bvec.bv_len;
 
 	if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE)) {
-		con->in_data_crc = crc32c(con->in_data_crc,
-					  page_address(con->bounce_page),
-					  con->v2.in_bvec.bv_len);
+		struct bio_vec bv;
+		void *bounce_buf = page_address(con->bounce_page);
+		void *dst_addr;
 
 		get_bvec_at(&con->v2.in_cursor, &bv);
-		memcpy_to_page(bv.bv_page, bv.bv_offset,
-			       page_address(con->bounce_page),
-			       con->v2.in_bvec.bv_len);
+		dst_addr = bvec_kmap_local(&bv);
+
+		if (con_secure(con)) {
+			aes_gcm_decrypt_update(&con->v2.in_gcm_ctx, dst_addr,
+					       bounce_buf, len);
+		} else {
+			con->in_data_crc =
+				crc32c(con->in_data_crc, bounce_buf, len);
+			memcpy(dst_addr, bounce_buf, len);
+		}
+		flush_dcache_page(bv.bv_page);
+		kunmap_local(dst_addr);
 	} else {
-		con->in_data_crc = ceph_crc32c_page(con->in_data_crc,
-						    con->v2.in_bvec.bv_page,
-						    con->v2.in_bvec.bv_offset,
-						    con->v2.in_bvec.bv_len);
+		void *dst_addr = bvec_kmap_local(&con->v2.in_bvec);
+
+		if (con_secure(con)) {
+			aes_gcm_decrypt_update(&con->v2.in_gcm_ctx, dst_addr,
+					       dst_addr, len);
+			flush_dcache_page(con->v2.in_bvec.bv_page);
+		} else {
+			con->in_data_crc =
+				crc32c(con->in_data_crc, dst_addr, len);
+		}
+		kunmap_local(dst_addr);
 	}
+	ceph_msg_data_advance(&con->v2.in_cursor, len);
+}
+
+static void prepare_read_epilogue(struct ceph_connection *con)
+{
+	struct ceph_msg *msg = con->in_msg;
+	int len;
+
+	static_assert(sizeof(con->v2.in_buf) >= CEPH_EPILOGUE_PLAIN_LEN);
+	static_assert(sizeof(con->v2.in_buf) >=
+		      CEPH_GCM_BLOCK_LEN + CEPH_EPILOGUE_SECURE_LEN);
+	len = data_padding_and_epilogue_onwire_len(con, data_len(msg));
+	reset_in_kvecs(con);
+	add_in_kvec(con, con->v2.in_buf, len);
+	con->v2.in_state = IN_S_HANDLE_EPILOGUE;
+}
+
+static void prepare_read_data_cont(struct ceph_connection *con)
+{
+	finalize_one_data_read_bvec(con);
 
-	ceph_msg_data_advance(&con->v2.in_cursor, con->v2.in_bvec.bv_len);
 	if (con->v2.in_cursor.total_resid) {
+		struct bio_vec bv;
+
 		get_bvec_at(&con->v2.in_cursor, &bv);
 		if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE)) {
 			bv.bv_page = con->bounce_page;
@@ -1890,9 +1598,7 @@ static void prepare_read_data_cont(struct ceph_connection *con)
 	/*
 	 * We've read all data.  Prepare to read epilogue.
 	 */
-	reset_in_kvecs(con);
-	add_in_kvec(con, con->v2.in_buf, CEPH_EPILOGUE_PLAIN_LEN);
-	con->v2.in_state = IN_S_HANDLE_EPILOGUE;
+	prepare_read_epilogue(con);
 }
 
 static int prepare_sparse_read_cont(struct ceph_connection *con)
@@ -1905,22 +1611,7 @@ static int prepare_sparse_read_cont(struct ceph_connection *con)
 	WARN_ON(con->v2.in_state != IN_S_PREPARE_SPARSE_DATA_CONT);
 
 	if (iov_iter_is_bvec(&con->v2.in_iter)) {
-		if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE)) {
-			con->in_data_crc = crc32c(con->in_data_crc,
-						  page_address(con->bounce_page),
-						  con->v2.in_bvec.bv_len);
-			get_bvec_at(cursor, &bv);
-			memcpy_to_page(bv.bv_page, bv.bv_offset,
-				       page_address(con->bounce_page),
-				       con->v2.in_bvec.bv_len);
-		} else {
-			con->in_data_crc = ceph_crc32c_page(con->in_data_crc,
-							    con->v2.in_bvec.bv_page,
-							    con->v2.in_bvec.bv_offset,
-							    con->v2.in_bvec.bv_len);
-		}
-
-		ceph_msg_data_advance(cursor, con->v2.in_bvec.bv_len);
+		finalize_one_data_read_bvec(con);
 		cursor->sr_resid -= con->v2.in_bvec.bv_len;
 		dout("%s: advance by 0x%x sr_resid 0x%x\n", __func__,
 		     con->v2.in_bvec.bv_len, cursor->sr_resid);
@@ -1938,12 +1629,20 @@ static int prepare_sparse_read_cont(struct ceph_connection *con)
 			return 0;
 		}
 	} else if (iov_iter_is_kvec(&con->v2.in_iter)) {
-		/* On first call, we have no kvec so don't compute crc */
+		/* On first call, we have no kvec */
 		if (con->v2.in_kvec_cnt) {
 			WARN_ON_ONCE(con->v2.in_kvec_cnt > 1);
-			con->in_data_crc = crc32c(con->in_data_crc,
-						  con->v2.in_kvecs[0].iov_base,
-						  con->v2.in_kvecs[0].iov_len);
+			if (con_secure(con))
+				aes_gcm_decrypt_update(
+					&con->v2.in_gcm_ctx,
+					con->v2.in_kvecs[0].iov_base,
+					con->v2.in_kvecs[0].iov_base,
+					con->v2.in_kvecs[0].iov_len);
+			else
+				con->in_data_crc =
+					crc32c(con->in_data_crc,
+					       con->v2.in_kvecs[0].iov_base,
+					       con->v2.in_kvecs[0].iov_len);
 		}
 	} else {
 		return -EIO;
@@ -1955,9 +1654,7 @@ static int prepare_sparse_read_cont(struct ceph_connection *con)
 		if (ret < 0)
 			return ret;
 
-		reset_in_kvecs(con);
-		add_in_kvec(con, con->v2.in_buf, CEPH_EPILOGUE_PLAIN_LEN);
-		con->v2.in_state = IN_S_HANDLE_EPILOGUE;
+		prepare_read_epilogue(con);
 		return 0;
 	}
 
@@ -2046,55 +1743,72 @@ static int prepare_read_tail_plain(struct ceph_connection *con)
 	return 0;
 }
 
-static void prepare_read_enc_page(struct ceph_connection *con)
+static int decrypt_front_and_middle(struct ceph_connection *con)
 {
-	struct bio_vec bv;
-
-	dout("%s con %p i %d resid %d\n", __func__, con, con->v2.in_enc_i,
-	     con->v2.in_enc_resid);
-	WARN_ON(!con->v2.in_enc_resid);
-
-	bvec_set_page(&bv, con->v2.in_enc_pages[con->v2.in_enc_i],
-		      min(con->v2.in_enc_resid, (int)PAGE_SIZE), 0);
-
-	set_in_bvec(con, &bv);
-	con->v2.in_enc_i++;
-	con->v2.in_enc_resid -= bv.bv_len;
-
-	if (con->v2.in_enc_resid) {
-		con->v2.in_state = IN_S_PREPARE_READ_ENC_PAGE;
-		return;
+	struct ceph_msg *msg = con->in_msg;
+	int front = front_len(msg);
+	int middle = middle_len(msg);
+
+	if (front) {
+		aes_gcm_decrypt_update(&con->v2.in_gcm_ctx, msg->front.iov_base,
+				       msg->front.iov_base, front);
+		if (padding_len(front))
+			aes_gcm_decrypt_update(&con->v2.in_gcm_ctx,
+					       con->v2.in_buf, con->v2.in_buf,
+					       padding_len(front));
+	}
+	if (middle) {
+		aes_gcm_decrypt_update(&con->v2.in_gcm_ctx,
+				       msg->middle->vec.iov_base,
+				       msg->middle->vec.iov_base, middle);
+		if (padding_len(middle))
+			aes_gcm_decrypt_update(
+				&con->v2.in_gcm_ctx,
+				&con->v2.in_buf[CEPH_GCM_BLOCK_LEN],
+				&con->v2.in_buf[CEPH_GCM_BLOCK_LEN],
+				padding_len(middle));
 	}
 
-	/*
-	 * We are set to read the last piece of ciphertext (ending
-	 * with epilogue) + auth tag.
-	 */
-	WARN_ON(con->v2.in_enc_i != con->v2.in_enc_page_cnt);
-	con->v2.in_state = IN_S_HANDLE_EPILOGUE;
+	if (data_len(msg)) {
+		if (msg->sparse_read_total)
+			return prepare_sparse_read_data(con);
+		else
+			return prepare_read_data(con);
+	}
+	prepare_read_epilogue(con);
+	return 0;
 }
 
 static int prepare_read_tail_secure(struct ceph_connection *con)
 {
-	struct page **enc_pages;
-	int enc_page_cnt;
-	int tail_len;
+	struct ceph_msg *msg = con->in_msg;
+	int front = front_len(msg);
+	int middle = middle_len(msg);
+	int data = data_len(msg);
 
-	tail_len = tail_onwire_len(con->in_msg, true);
-	WARN_ON(!tail_len);
+	ceph_aes_gcm_decrypt_init(con);
 
-	enc_page_cnt = calc_pages_for(0, tail_len);
-	enc_pages = ceph_alloc_page_vector(enc_page_cnt, GFP_NOIO);
-	if (IS_ERR(enc_pages))
-		return PTR_ERR(enc_pages);
+	if (!front && !middle) {
+		WARN_ON(!data);
+		return prepare_read_data(con);
+	}
 
-	WARN_ON(con->v2.in_enc_pages || con->v2.in_enc_page_cnt);
-	con->v2.in_enc_pages = enc_pages;
-	con->v2.in_enc_page_cnt = enc_page_cnt;
-	con->v2.in_enc_resid = tail_len;
-	con->v2.in_enc_i = 0;
+	reset_in_kvecs(con);
+	if (front) {
+		add_in_kvec(con, msg->front.iov_base, front);
+		WARN_ON(msg->front.iov_len != front);
+		if (padding_len(front))
+			add_in_kvec(con, con->v2.in_buf, padding_len(front));
+	}
+	if (middle) {
+		add_in_kvec(con, msg->middle->vec.iov_base, middle);
+		WARN_ON(msg->middle->vec.iov_len != middle);
+		if (padding_len(middle))
+			add_in_kvec(con, &con->v2.in_buf[CEPH_GCM_BLOCK_LEN],
+				    padding_len(middle));
+	}
 
-	prepare_read_enc_page(con);
+	con->v2.in_state = IN_S_DECRYPT_FRONT_AND_MIDDLE;
 	return 0;
 }
 
@@ -2117,6 +1831,13 @@ static void prepare_skip_message(struct ceph_connection *con)
 	if (!tail_len) {
 		__finish_skip(con);
 	} else {
+		if (con_secure(con)) {
+			/*
+			 * In this case the tail decryption was never started,
+			 * so the nonce needs to incremented explicitly.
+			 */
+			gcm_inc_nonce(&con->v2.in_gcm_nonce);
+		}
 		set_in_skip(con, tail_len);
 		con->v2.in_state = IN_S_FINISH_SKIP;
 	}
@@ -2350,16 +2071,10 @@ static int process_auth_reply_more(struct ceph_connection *con,
 	return -EINVAL;
 }
 
-/*
- * Align con_secret to avoid GFP_ATOMIC allocation inside
- * crypto_aead_setkey() called from setup_crypto().  __aligned(16)
- * isn't guaranteed to work for stack objects, so do it by hand.
- */
 static int process_auth_done(struct ceph_connection *con, void *p, void *end)
 {
 	u8 session_key[CEPH_MAX_KEY_LEN];
-	u8 con_secret_buf[CEPH_MAX_CON_SECRET_LEN + 16];
-	u8 *con_secret = PTR_ALIGN(&con_secret_buf[0], 16);
+	u8 con_secret[CEPH_MAX_CON_SECRET_LEN];
 	int session_key_len, con_secret_len;
 	int payload_len;
 	u64 global_id;
@@ -2413,7 +2128,7 @@ static int process_auth_done(struct ceph_connection *con, void *p, void *end)
 
 out:
 	memzero_explicit(session_key, sizeof(session_key));
-	memzero_explicit(con_secret_buf, sizeof(con_secret_buf));
+	memzero_explicit(con_secret, sizeof(con_secret));
 	return ret;
 
 bad:
@@ -2940,15 +2655,14 @@ static int __handle_control(struct ceph_connection *con, void *p)
 static int handle_preamble(struct ceph_connection *con)
 {
 	struct ceph_frame_desc *desc = &con->v2.in_desc;
+	int tag_offset = CEPH_PREAMBLE_SECURE_LEN - CEPH_GCM_TAG_LEN;
 	int ret;
 
-	if (con_secure(con)) {
-		ret = decrypt_preamble(con);
-		if (ret) {
-			if (ret == -EBADMSG)
-				con->error_msg = "integrity error, bad preamble auth tag";
-			return ret;
-		}
+	if (con_secure(con) &&
+	    ceph_aes_gcm_decrypt(con->v2.in_buf, &con->v2.in_buf[tag_offset],
+				 tag_offset, con) != 0) {
+		con->error_msg = "integrity error, bad preamble auth tag";
+		return -EBADMSG;
 	}
 
 	ret = decode_preamble(con->v2.in_buf, desc);
@@ -3018,19 +2732,28 @@ static int handle_control_remainder(struct ceph_connection *con)
 
 static int handle_epilogue(struct ceph_connection *con)
 {
+	struct ceph_msg *msg = con->in_msg;
 	u32 front_crc, middle_crc, data_crc;
 	int ret;
 
 	if (con_secure(con)) {
-		ret = decrypt_tail(con);
-		if (ret) {
-			if (ret == -EBADMSG)
-				con->error_msg = "integrity error, bad epilogue auth tag";
-			return ret;
+		int pad = padding_len(data_len(msg));
+		int tag_offset =
+			pad + CEPH_EPILOGUE_SECURE_LEN - CEPH_GCM_TAG_LEN;
+
+		/* Decrypt the data padding and epilogue */
+		aes_gcm_decrypt_update(&con->v2.in_gcm_ctx, con->v2.in_buf,
+				       con->v2.in_buf, tag_offset);
+
+		/* Verify the tail's auth tag */
+		if (aes_gcm_decrypt_final(&con->v2.in_gcm_ctx,
+					  &con->v2.in_buf[tag_offset]) != 0) {
+			con->error_msg = "integrity error, bad tail auth tag";
+			return -EBADMSG;
 		}
 
 		/* just late_status */
-		ret = decode_epilogue(con->v2.in_buf, NULL, NULL, NULL);
+		ret = decode_epilogue(&con->v2.in_buf[pad], NULL, NULL, NULL);
 		if (ret) {
 			con->error_msg = "protocol error, bad epilogue";
 			return ret;
@@ -3058,9 +2781,6 @@ static void finish_skip(struct ceph_connection *con)
 {
 	dout("%s con %p\n", __func__, con);
 
-	if (con_secure(con))
-		gcm_inc_nonce(&con->v2.in_gcm_nonce);
-
 	__finish_skip(con);
 }
 
@@ -3089,6 +2809,9 @@ static int populate_in_iter(struct ceph_connection *con)
 		case IN_S_HANDLE_CONTROL_REMAINDER:
 			ret = handle_control_remainder(con);
 			break;
+		case IN_S_DECRYPT_FRONT_AND_MIDDLE:
+			ret = decrypt_front_and_middle(con);
+			break;
 		case IN_S_PREPARE_READ_DATA:
 			ret = prepare_read_data(con);
 			break;
@@ -3096,10 +2819,6 @@ static int populate_in_iter(struct ceph_connection *con)
 			prepare_read_data_cont(con);
 			ret = 0;
 			break;
-		case IN_S_PREPARE_READ_ENC_PAGE:
-			prepare_read_enc_page(con);
-			ret = 0;
-			break;
 		case IN_S_PREPARE_SPARSE_DATA:
 			ret = prepare_sparse_read_data(con);
 			break;
@@ -3203,31 +2922,54 @@ static void queue_data_cont(struct ceph_connection *con, struct ceph_msg *msg)
 	con->v2.out_state = OUT_S_FINISH_MESSAGE;
 }
 
-static void queue_enc_page(struct ceph_connection *con)
+/*
+ * Continue encrypting and sending the data.  The original data can't be
+ * modified, so use a bounce buffer.  Also copy the original data into the
+ * bounce buffer before encryption, so that the authentication tag is computed
+ * over a stable copy.
+ */
+static void queue_enc_data(struct ceph_connection *con)
 {
+	struct ceph_msg_data_cursor *cursor = &con->v2.out_cursor;
 	struct bio_vec bv;
+	u8 *bounce = con->v2.out_ciphertext;
+	int len = min(cursor->total_resid, OUT_CIPHERTEXT_BUFFER_SIZE);
+	int i = 0;
+	int n;
 
-	dout("%s con %p i %d resid %d\n", __func__, con, con->v2.out_enc_i,
-	     con->v2.out_enc_resid);
-	WARN_ON(!con->v2.out_enc_resid);
+	dout("%s con %p resid %zu\n", __func__, con, cursor->total_resid);
+
+	do {
+		get_bvec_at(cursor, &bv);
+		n = min(len - i, (int)bv.bv_len);
+		memcpy_from_page(&bounce[i], bv.bv_page, bv.bv_offset, n);
+		ceph_msg_data_advance(cursor, n);
+		i += n;
+	} while (i < len);
+	aes_gcm_encrypt_update(&con->v2.out_gcm_ctx, bounce, bounce, len);
+	reset_out_kvecs(con);
+	add_out_kvec(con, bounce, len);
 
-	bvec_set_page(&bv, con->v2.out_enc_pages[con->v2.out_enc_i],
-		      min(con->v2.out_enc_resid, (int)PAGE_SIZE), 0);
+	if (cursor->total_resid == 0)
+		con->v2.out_state = OUT_S_QUEUE_ENC_EPILOGUE;
+}
 
-	set_out_bvec(con, &bv, false);
-	con->v2.out_enc_i++;
-	con->v2.out_enc_resid -= bv.bv_len;
+/* Enqueue the data padding (0-15 encrypted zeroes) and secure epilogue. */
+static void queue_enc_epilogue(struct ceph_connection *con)
+{
+	int pad = padding_len(data_len(con->out_msg));
+	int tag_offset = pad + CEPH_EPILOGUE_SECURE_LEN - CEPH_GCM_TAG_LEN;
+	u8 *bounce = con->v2.out_ciphertext;
 
-	if (con->v2.out_enc_resid) {
-		WARN_ON(con->v2.out_state != OUT_S_QUEUE_ENC_PAGE);
-		return;
-	}
+	memset(bounce, 0, pad);
+	memcpy(&bounce[pad], (u8 *)&con->v2.out_epil,
+	       CEPH_EPILOGUE_SECURE_LEN - CEPH_GCM_TAG_LEN);
+	aes_gcm_encrypt_update(&con->v2.out_gcm_ctx, bounce, bounce,
+			       tag_offset);
+	aes_gcm_encrypt_final(&con->v2.out_gcm_ctx, &bounce[tag_offset]);
 
-	/*
-	 * We've queued the last piece of ciphertext (ending with
-	 * epilogue) + auth tag.  Once it's written, we are done.
-	 */
-	WARN_ON(con->v2.out_enc_i != con->v2.out_enc_page_cnt);
+	reset_out_kvecs(con);
+	add_out_kvec(con, bounce, tag_offset + CEPH_GCM_TAG_LEN);
 	con->v2.out_state = OUT_S_FINISH_MESSAGE;
 }
 
@@ -3256,14 +2998,11 @@ static void finish_message(struct ceph_connection *con)
 {
 	dout("%s con %p msg %p\n", __func__, con, con->out_msg);
 
-	/* we end up here both plain and secure modes */
-	if (con->v2.out_enc_pages) {
-		WARN_ON(!con->v2.out_enc_page_cnt);
-		ceph_release_page_vector(con->v2.out_enc_pages,
-					 con->v2.out_enc_page_cnt);
-		con->v2.out_enc_pages = NULL;
-		con->v2.out_enc_page_cnt = 0;
+	if (con->v2.out_front_middle_ciphertext) {
+		kvfree(con->v2.out_front_middle_ciphertext);
+		con->v2.out_front_middle_ciphertext = NULL;
 	}
+
 	/* message may have been revoked */
 	if (con->out_msg) {
 		ceph_msg_put(con->out_msg);
@@ -3297,8 +3036,11 @@ static int populate_out_iter(struct ceph_connection *con)
 		WARN_ON(!con->out_msg);
 		queue_data_cont(con, con->out_msg);
 		goto populated;
-	case OUT_S_QUEUE_ENC_PAGE:
-		queue_enc_page(con);
+	case OUT_S_QUEUE_ENC_DATA:
+		queue_enc_data(con);
+		goto populated;
+	case OUT_S_QUEUE_ENC_EPILOGUE:
+		queue_enc_epilogue(con);
 		goto populated;
 	case OUT_S_QUEUE_ZEROS:
 		WARN_ON(con->out_msg);  /* revoked */
@@ -3621,7 +3363,8 @@ void ceph_con_v2_revoke(struct ceph_connection *con, struct ceph_msg *msg)
 	WARN_ON(con->v2.out_zero);
 
 	if (con_secure(con)) {
-		WARN_ON(con->v2.out_state != OUT_S_QUEUE_ENC_PAGE &&
+		WARN_ON(con->v2.out_state != OUT_S_QUEUE_ENC_DATA &&
+			con->v2.out_state != OUT_S_QUEUE_ENC_EPILOGUE &&
 			con->v2.out_state != OUT_S_FINISH_MESSAGE);
 		dout("%s con %p secure - noop\n", __func__, con);
 		return;
@@ -3643,6 +3386,25 @@ void ceph_con_v2_revoke(struct ceph_connection *con, struct ceph_msg *msg)
 	}
 }
 
+static void revoke_at_decrypt_front_and_middle(struct ceph_connection *con)
+{
+	struct ceph_msg *msg = con->in_msg;
+	int resid, remaining;
+
+	WARN_ON(!con_secure(con));
+	WARN_ON(!iov_iter_is_kvec(&con->v2.in_iter));
+	resid = iov_iter_count(&con->v2.in_iter);
+	WARN_ON(!resid);
+
+	remaining = data_len(msg) +
+		    data_padding_and_epilogue_onwire_len(con, data_len(msg));
+	dout("%s con %p resid %d remaining %d\n", __func__, con, resid,
+	     remaining);
+	con->v2.in_iter.count -= resid;
+	set_in_skip(con, resid + remaining);
+	con->v2.in_state = IN_S_FINISH_SKIP;
+}
+
 static void revoke_at_prepare_read_data(struct ceph_connection *con)
 {
 	int remaining;
@@ -3667,7 +3429,6 @@ static void revoke_at_prepare_read_data_cont(struct ceph_connection *con)
 	int recved, resid;  /* current piece of data */
 	int remaining;
 
-	WARN_ON(con_secure(con));
 	WARN_ON(!data_len(con->in_msg));
 	WARN_ON(!iov_iter_is_bvec(&con->v2.in_iter));
 	resid = iov_iter_count(&con->v2.in_iter);
@@ -3679,7 +3440,8 @@ static void revoke_at_prepare_read_data_cont(struct ceph_connection *con)
 		ceph_msg_data_advance(&con->v2.in_cursor, recved);
 	WARN_ON(resid > con->v2.in_cursor.total_resid);
 
-	remaining = CEPH_EPILOGUE_PLAIN_LEN;
+	remaining = data_padding_and_epilogue_onwire_len(con,
+							 data_len(con->in_msg));
 	dout("%s con %p total_resid %zu remaining %d\n", __func__, con,
 	     con->v2.in_cursor.total_resid, remaining);
 	con->v2.in_iter.count -= resid;
@@ -3687,34 +3449,19 @@ static void revoke_at_prepare_read_data_cont(struct ceph_connection *con)
 	con->v2.in_state = IN_S_FINISH_SKIP;
 }
 
-static void revoke_at_prepare_read_enc_page(struct ceph_connection *con)
-{
-	int resid;  /* current enc page (not necessarily data) */
-
-	WARN_ON(!con_secure(con));
-	WARN_ON(!iov_iter_is_bvec(&con->v2.in_iter));
-	resid = iov_iter_count(&con->v2.in_iter);
-	WARN_ON(!resid || resid > con->v2.in_bvec.bv_len);
-
-	dout("%s con %p resid %d enc_resid %d\n", __func__, con, resid,
-	     con->v2.in_enc_resid);
-	con->v2.in_iter.count -= resid;
-	set_in_skip(con, resid + con->v2.in_enc_resid);
-	con->v2.in_state = IN_S_FINISH_SKIP;
-}
-
 static void revoke_at_prepare_sparse_data(struct ceph_connection *con)
 {
 	int resid;  /* current piece of data */
 	int remaining;
 
-	WARN_ON(con_secure(con));
 	WARN_ON(!data_len(con->in_msg));
 	WARN_ON(!iov_iter_is_bvec(&con->v2.in_iter));
 	resid = iov_iter_count(&con->v2.in_iter);
 	dout("%s con %p resid %d\n", __func__, con, resid);
 
-	remaining = CEPH_EPILOGUE_PLAIN_LEN + con->v2.data_len_remain;
+	remaining = con->v2.data_len_remain +
+		    data_padding_and_epilogue_onwire_len(con,
+							 data_len(con->in_msg));
 	con->v2.in_iter.count -= resid;
 	set_in_skip(con, resid + remaining);
 	con->v2.in_state = IN_S_FINISH_SKIP;
@@ -3736,6 +3483,9 @@ static void revoke_at_handle_epilogue(struct ceph_connection *con)
 void ceph_con_v2_revoke_incoming(struct ceph_connection *con)
 {
 	switch (con->v2.in_state) {
+	case IN_S_DECRYPT_FRONT_AND_MIDDLE:
+		revoke_at_decrypt_front_and_middle(con);
+		break;
 	case IN_S_PREPARE_SPARSE_DATA:
 	case IN_S_PREPARE_READ_DATA:
 		revoke_at_prepare_read_data(con);
@@ -3743,9 +3493,6 @@ void ceph_con_v2_revoke_incoming(struct ceph_connection *con)
 	case IN_S_PREPARE_READ_DATA_CONT:
 		revoke_at_prepare_read_data_cont(con);
 		break;
-	case IN_S_PREPARE_READ_ENC_PAGE:
-		revoke_at_prepare_read_enc_page(con);
-		break;
 	case IN_S_PREPARE_SPARSE_DATA_CONT:
 		revoke_at_prepare_sparse_data(con);
 		break;
@@ -3782,33 +3529,19 @@ void ceph_con_v2_reset_protocol(struct ceph_connection *con)
 	clear_out_sign_kvecs(con);
 	free_conn_bufs(con);
 
-	if (con->v2.in_enc_pages) {
-		WARN_ON(!con->v2.in_enc_page_cnt);
-		ceph_release_page_vector(con->v2.in_enc_pages,
-					 con->v2.in_enc_page_cnt);
-		con->v2.in_enc_pages = NULL;
-		con->v2.in_enc_page_cnt = 0;
-	}
-	if (con->v2.out_enc_pages) {
-		WARN_ON(!con->v2.out_enc_page_cnt);
-		ceph_release_page_vector(con->v2.out_enc_pages,
-					 con->v2.out_enc_page_cnt);
-		con->v2.out_enc_pages = NULL;
-		con->v2.out_enc_page_cnt = 0;
-	}
+	kfree(con->v2.out_ciphertext);
+	con->v2.out_ciphertext = NULL;
+	kvfree(con->v2.out_front_middle_ciphertext);
+	con->v2.out_front_middle_ciphertext = NULL;
 
 	con->v2.con_mode = CEPH_CON_MODE_UNKNOWN;
 	memzero_explicit(&con->v2.in_gcm_nonce, CEPH_GCM_IV_LEN);
 	memzero_explicit(&con->v2.out_gcm_nonce, CEPH_GCM_IV_LEN);
+	memzero_explicit(&con->v2.in_gcm_ctx, sizeof(con->v2.in_gcm_ctx));
+	memzero_explicit(&con->v2.out_gcm_ctx, sizeof(con->v2.out_gcm_ctx));
 
 	memzero_explicit(&con->v2.hmac_key, sizeof(con->v2.hmac_key));
 	con->v2.hmac_key_set = false;
-	if (con->v2.gcm_req) {
-		aead_request_free(con->v2.gcm_req);
-		con->v2.gcm_req = NULL;
-	}
-	if (con->v2.gcm_tfm) {
-		crypto_free_aead(con->v2.gcm_tfm);
-		con->v2.gcm_tfm = NULL;
-	}
+	memzero_explicit(&con->v2.gcm_key, sizeof(con->v2.gcm_key));
+	con->v2.gcm_key_set = false;
 }
-- 
2.54.0

