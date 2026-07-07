Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCED39EF1F;
	Tue,  7 Jul 2026 05:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402646; cv=none; b=I99iKVQX00e9kcmkTJ0nqxF00catA09h0XBl45Miuq//reQtTjknIkGAkr8WaaGmiD59IdRyQYJJfBvWGmsCmlrc9OXA9BN4nVsDLnHfr3de3UMWFwApvGDOqn0ru2/8YweGODVgLJ7yXl5W/vSfX0b4IuYgZnZzDcHaI23bEK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402646; c=relaxed/simple;
	bh=UvcBn62SD8vakqjWyUCHmVRephIHZGNOwd3mdLdw6Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+58UAfp8Dt5J+llhlqWaF36McUMoMG4Ve5GA+RhzWKzt3++dHDw0R3Xm9JS6ZHBR9UUvzV1LZH9JFUbkWiQrsLwOySXzaeRWYM8/nqdc36pjKmSEf84Zyvc/+VOca9lwtgonKfl0OkOPHA9dc21hWKAFnuCLzpzAojgHRLBm30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q4+EMJYg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q4+EMJYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDEE1F00ADE;
	Tue,  7 Jul 2026 05:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402643;
	bh=79FTno7cmzts1TIfmzvidsMNWTqpX8oOYqsqgisTO1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q4+EMJYgHHA8LLI7a9suDJc2BMIEutnzLomPwAkPUOpnb72GMgI0b6pTQ4ropgon4
	 kIQ4POflzH2dxKHnzeBD+JkSCTzGMwbgci+iuyAzXRTxZd+J5kEs8mxbQ/uXgUo+cg
	 438tHUY0YFz9PfXWVAvMbkw3JTakusTtLyKjL27vTdavGZPMwR4hnNr3KCDhI0xzM2
	 1jl0pRgVHyUxgzuoI9erOMUerM+fgjgARcas38NQM+rIxRkIC+Ls2bAwObWH42LRyC
	 jNbjwdAsX4Vv2vnTH8vBiw3OIjzcTmYMsTmQzvuokx172w8KpcjsslwUF+APkA8pVP
	 CQb3syu4tEFIg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 26/33] macsec: Use AES-GCM library instead of crypto_aead
Date: Mon,  6 Jul 2026 22:34:56 -0700
Message-ID: <20260707053503.209874-27-ebiggers@kernel.org>
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

Now that there's a library API for AES-GCM, use it instead of a
"gcm(aes)" crypto_aead.  This significantly simplifies the code.

Notably, per-skb dynamic memory allocations and conversions to
scatterlists are eliminated.  We now just iterate through the skb's data
and process it directly.

Asynchronous en/decryption operations are no longer supported, as that
execution model has been found to not be beneficial.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/net/Kconfig  |   4 +-
 drivers/net/macsec.c | 327 ++++++++++++++-----------------------------
 include/net/macsec.h |   5 +-
 3 files changed, 106 insertions(+), 230 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index ff79c466712d..e7322d5a1164 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -317,9 +317,7 @@ config AMT
 
 config MACSEC
 	tristate "IEEE 802.1AE MAC-level encryption (MACsec)"
-	select CRYPTO
-	select CRYPTO_AES
-	select CRYPTO_GCM
+	select CRYPTO_LIB_AES_GCM
 	select GRO_CELLS
 	help
 	   MACsec is an encryption standard for Ethernet.
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index fb009120a924..ce32dae77a60 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -9,7 +9,7 @@
 #include <linux/skbuff.h>
 #include <linux/socket.h>
 #include <linux/module.h>
-#include <crypto/aead.h>
+#include <crypto/aes-gcm.h>
 #include <linux/etherdevice.h>
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
@@ -134,7 +134,6 @@ static struct macsec_rxh_data *macsec_data_rtnl(const struct net_device *dev)
 }
 
 struct macsec_cb {
-	struct aead_request *req;
 	union {
 		struct macsec_tx_sa *tx_sa;
 		struct macsec_rx_sa *rx_sa;
@@ -181,9 +180,8 @@ static void free_rxsa_work(struct work_struct *work)
 	struct macsec_rx_sa *sa =
 		container_of(to_rcu_work(work), struct macsec_rx_sa, destroy_work);
 
-	crypto_free_aead(sa->key.tfm);
 	free_percpu(sa->stats);
-	kfree(sa);
+	kfree_sensitive(sa);
 }
 
 static void macsec_rxsa_put(struct macsec_rx_sa *sa)
@@ -210,9 +208,8 @@ static void free_txsa_work(struct work_struct *work)
 	struct macsec_tx_sa *sa =
 		container_of(to_rcu_work(work), struct macsec_tx_sa, destroy_work);
 
-	crypto_free_aead(sa->key.tfm);
 	free_percpu(sa->stats);
-	kfree(sa);
+	kfree_sensitive(sa);
 }
 
 static void macsec_txsa_put(struct macsec_tx_sa *sa)
@@ -541,70 +538,72 @@ static void count_tx(struct net_device *dev, int ret, int len)
 		dev_sw_netstats_tx_add(dev, 1, len);
 }
 
-static void macsec_encrypt_done(void *data, int err)
+static void macsec_crypt_chunk(struct aes_gcm_ctx *ctx, u8 *data, size_t avail,
+			       size_t *assoc_len, size_t *crypt_len,
+			       bool encrypt)
 {
-	struct sk_buff *skb = data;
-	struct net_device *dev = skb->dev;
-	struct macsec_dev *macsec = macsec_priv(dev);
-	struct macsec_tx_sa *sa = macsec_skb_cb(skb)->tx_sa;
-	int len, ret;
+	size_t n;
 
-	aead_request_free(macsec_skb_cb(skb)->req);
-
-	rcu_read_lock_bh();
-	macsec_count_tx(skb, &macsec->secy.tx_sc, macsec_skb_cb(skb)->tx_sa);
-	/* packet is encrypted/protected so tx_bytes must be calculated */
-	len = macsec_msdu_len(skb) + 2 * ETH_ALEN;
-	macsec_encrypt_finish(skb, dev);
-	ret = dev_queue_xmit(skb);
-	count_tx(dev, ret, len);
-	rcu_read_unlock_bh();
+	if (*assoc_len && avail) {
+		/* Associated data */
+		n = min(avail, *assoc_len);
+		aes_gcm_auth_update(ctx, data, n);
+		data += n;
+		avail -= n;
+		*assoc_len -= n;
+	}
 
-	macsec_txsa_put(sa);
-	dev_put(dev);
+	if (*crypt_len && avail) {
+		/* En/decrypted data */
+		n = min(avail, *crypt_len);
+		if (encrypt)
+			aes_gcm_encrypt_update(ctx, data, data, n);
+		else
+			aes_gcm_decrypt_update(ctx, data, data, n);
+		*crypt_len -= n;
+	}
 }
 
-static struct aead_request *macsec_alloc_req(struct crypto_aead *tfm,
-					     unsigned char **iv,
-					     struct scatterlist **sg,
-					     int num_frags)
+/**
+ * macsec_crypt_skb() - Encrypt or decrypt an skb in-place using AES-GCM
+ * @ctx: An AES-GCM context
+ * @skb: The socket buffer to process
+ * @assoc_len: Length of associated data
+ * @crypt_len: Length of payload data to encrypt or decrypt
+ * @encrypt: True for encryption, false for decryption
+ *
+ * Updates the given AES-GCM context with @assoc_len bytes of associated data
+ * from the skb, then encrypts or decrypts @crypt_len bytes in-place.  Context
+ * initialization and finalization are handled by the caller.
+ *
+ * The data (both associated and en/decrypted) is taken from the linear head and
+ * frag_list.  It is assumed that the @skb was processed by skb_cow_data(),
+ * meaning it has no page fragments (nr_frags == 0) and is writable.
+ */
+static void macsec_crypt_skb(struct aes_gcm_ctx *ctx, struct sk_buff *skb,
+			     size_t assoc_len, size_t crypt_len, bool encrypt)
 {
-	size_t size, iv_offset, sg_offset;
-	struct aead_request *req;
-	void *tmp;
+	struct sk_buff *frag_iter;
 
-	size = sizeof(struct aead_request) + crypto_aead_reqsize(tfm);
-	iv_offset = size;
-	size += GCM_AES_IV_LEN;
-
-	size = ALIGN(size, __alignof__(struct scatterlist));
-	sg_offset = size;
-	size += sizeof(struct scatterlist) * num_frags;
-
-	tmp = kmalloc(size, GFP_ATOMIC);
-	if (!tmp)
-		return NULL;
-
-	*iv = (unsigned char *)(tmp + iv_offset);
-	*sg = (struct scatterlist *)(tmp + sg_offset);
-	req = tmp;
-
-	aead_request_set_tfm(req, tfm);
-
-	return req;
+	WARN_ON_ONCE(skb_shinfo(skb)->nr_frags);
+	macsec_crypt_chunk(ctx, skb->data, skb_headlen(skb), &assoc_len,
+			   &crypt_len, encrypt);
+	skb_walk_frags(skb, frag_iter)
+		macsec_crypt_chunk(ctx, frag_iter->data, frag_iter->len,
+				   &assoc_len, &crypt_len, encrypt);
 }
 
 static struct sk_buff *macsec_encrypt(struct sk_buff *skb,
 				      struct net_device *dev)
 {
 	int ret;
-	struct scatterlist *sg;
 	struct sk_buff *trailer;
-	unsigned char *iv;
+	u8 iv[GCM_AES_IV_LEN];
 	struct ethhdr *eth;
 	struct macsec_eth_header *hh;
-	size_t unprotected_len;
-	struct aead_request *req;
+	size_t unprotected_len, assoc_len, crypt_len;
+	struct aes_gcm_ctx ctx;
+	u8 icv[MACSEC_DEFAULT_ICV_LEN];
 	struct macsec_secy *secy;
 	struct macsec_tx_sc *tx_sc;
 	struct macsec_tx_sa *tx_sa;
@@ -681,56 +680,32 @@ static struct sk_buff *macsec_encrypt(struct sk_buff *skb,
 		return ERR_PTR(ret);
 	}
 
-	req = macsec_alloc_req(tx_sa->key.tfm, &iv, &sg, ret);
-	if (!req) {
-		macsec_txsa_put(tx_sa);
-		kfree_skb(skb);
-		return ERR_PTR(-ENOMEM);
-	}
-
 	if (secy->xpn)
 		macsec_fill_iv_xpn(iv, tx_sa->ssci, pn.full64, tx_sa->key.salt);
 	else
 		macsec_fill_iv(iv, secy->sci, pn.lower);
 
-	sg_init_table(sg, ret);
-	ret = skb_to_sgvec(skb, sg, 0, skb->len);
-	if (unlikely(ret < 0)) {
-		aead_request_free(req);
-		macsec_txsa_put(tx_sa);
-		kfree_skb(skb);
-		return ERR_PTR(ret);
-	}
-
 	if (tx_sc->encrypt) {
-		int len = skb->len - macsec_hdr_len(sci_present) -
-			  secy->icv_len;
-		aead_request_set_crypt(req, sg, sg, len, iv);
-		aead_request_set_ad(req, macsec_hdr_len(sci_present));
+		assoc_len = macsec_hdr_len(sci_present);
+		crypt_len = skb->len - assoc_len - secy->icv_len;
 	} else {
-		aead_request_set_crypt(req, sg, sg, 0, iv);
-		aead_request_set_ad(req, skb->len - secy->icv_len);
+		assoc_len = skb->len - secy->icv_len;
+		crypt_len = 0;
 	}
 
-	macsec_skb_cb(skb)->req = req;
-	macsec_skb_cb(skb)->tx_sa = tx_sa;
-	macsec_skb_cb(skb)->has_sci = sci_present;
-	aead_request_set_callback(req, 0, macsec_encrypt_done, skb);
+	aes_gcm_init(&ctx, iv, &tx_sa->key.gcm_key);
+	macsec_crypt_skb(&ctx, skb, assoc_len, crypt_len, true);
+	aes_gcm_encrypt_final(&ctx, icv);
 
-	dev_hold(skb->dev);
-	ret = crypto_aead_encrypt(req);
-	if (ret == -EINPROGRESS) {
-		return ERR_PTR(ret);
-	} else if (ret != 0) {
-		dev_put(skb->dev);
-		kfree_skb(skb);
-		aead_request_free(req);
+	ret = skb_store_bits(skb, skb->len - secy->icv_len, icv, secy->icv_len);
+	if (unlikely(ret < 0)) {
 		macsec_txsa_put(tx_sa);
-		return ERR_PTR(-EINVAL);
+		kfree_skb(skb);
+		return ERR_PTR(ret);
 	}
 
-	dev_put(skb->dev);
-	aead_request_free(req);
+	macsec_skb_cb(skb)->tx_sa = tx_sa;
+	macsec_skb_cb(skb)->has_sci = sci_present;
 	macsec_txsa_put(tx_sa);
 
 	return skb;
@@ -844,45 +819,6 @@ static void count_rx(struct net_device *dev, int len)
 	dev_sw_netstats_rx_add(dev, len);
 }
 
-static void macsec_decrypt_done(void *data, int err)
-{
-	struct sk_buff *skb = data;
-	struct net_device *dev = skb->dev;
-	struct macsec_dev *macsec = macsec_priv(dev);
-	struct macsec_rx_sa *rx_sa = macsec_skb_cb(skb)->rx_sa;
-	struct macsec_rx_sc *rx_sc = rx_sa->sc;
-	int len;
-	u32 pn;
-
-	aead_request_free(macsec_skb_cb(skb)->req);
-
-	if (!err)
-		macsec_skb_cb(skb)->valid = true;
-
-	rcu_read_lock_bh();
-	pn = ntohl(macsec_ethhdr(skb)->packet_number);
-	if (!macsec_post_decrypt(skb, &macsec->secy, pn)) {
-		rcu_read_unlock_bh();
-		kfree_skb(skb);
-		goto out;
-	}
-
-	macsec_finalize_skb(skb, macsec->secy.icv_len,
-			    macsec_extra_len(macsec_skb_cb(skb)->has_sci));
-	len = skb->len;
-	macsec_reset_skb(skb, macsec->secy.netdev);
-
-	if (gro_cells_receive(&macsec->gro_cells, skb) == NET_RX_SUCCESS)
-		count_rx(dev, len);
-
-	rcu_read_unlock_bh();
-
-out:
-	macsec_rxsa_put(rx_sa);
-	macsec_rxsc_put(rx_sc);
-	dev_put(dev);
-}
-
 static struct sk_buff *macsec_decrypt(struct sk_buff *skb,
 				      struct net_device *dev,
 				      struct macsec_rx_sa *rx_sa,
@@ -890,12 +826,13 @@ static struct sk_buff *macsec_decrypt(struct sk_buff *skb,
 				      struct macsec_secy *secy)
 {
 	int ret;
-	struct scatterlist *sg;
 	struct sk_buff *trailer;
-	unsigned char *iv;
-	struct aead_request *req;
+	u8 iv[GCM_AES_IV_LEN];
+	size_t assoc_len, crypt_len;
+	struct aes_gcm_ctx ctx;
 	struct macsec_eth_header *hdr;
 	u32 hdr_pn;
+	u8 icv[MACSEC_DEFAULT_ICV_LEN];
 	u16 icv_len = secy->icv_len;
 
 	macsec_skb_cb(skb)->valid = false;
@@ -908,11 +845,6 @@ static struct sk_buff *macsec_decrypt(struct sk_buff *skb,
 		kfree_skb(skb);
 		return ERR_PTR(ret);
 	}
-	req = macsec_alloc_req(rx_sa->key.tfm, &iv, &sg, ret);
-	if (!req) {
-		kfree_skb(skb);
-		return ERR_PTR(-ENOMEM);
-	}
 
 	hdr = (struct macsec_eth_header *)skb->data;
 	hdr_pn = ntohl(hdr->packet_number);
@@ -931,55 +863,33 @@ static struct sk_buff *macsec_decrypt(struct sk_buff *skb,
 		macsec_fill_iv(iv, sci, hdr_pn);
 	}
 
-	sg_init_table(sg, ret);
-	ret = skb_to_sgvec(skb, sg, 0, skb->len);
-	if (unlikely(ret < 0)) {
-		aead_request_free(req);
-		kfree_skb(skb);
-		return ERR_PTR(ret);
-	}
-
 	if (hdr->tci_an & MACSEC_TCI_E) {
 		/* confidentiality: ethernet + macsec header
 		 * authenticated, encrypted payload
 		 */
-		int len = skb->len - macsec_hdr_len(macsec_skb_cb(skb)->has_sci);
-
-		aead_request_set_crypt(req, sg, sg, len, iv);
-		aead_request_set_ad(req, macsec_hdr_len(macsec_skb_cb(skb)->has_sci));
-		skb = skb_unshare(skb, GFP_ATOMIC);
-		if (!skb) {
-			aead_request_free(req);
-			return ERR_PTR(-ENOMEM);
-		}
+		assoc_len = macsec_hdr_len(macsec_skb_cb(skb)->has_sci);
+		crypt_len = skb->len - assoc_len - icv_len;
 	} else {
 		/* integrity only: all headers + data authenticated */
-		aead_request_set_crypt(req, sg, sg, icv_len, iv);
-		aead_request_set_ad(req, skb->len - icv_len);
+		assoc_len = skb->len - icv_len;
+		crypt_len = 0;
 	}
 
-	macsec_skb_cb(skb)->req = req;
-	skb->dev = dev;
-	aead_request_set_callback(req, 0, macsec_decrypt_done, skb);
+	aes_gcm_init(&ctx, iv, &rx_sa->key.gcm_key);
+	macsec_crypt_skb(&ctx, skb, assoc_len, crypt_len, false);
 
-	dev_hold(dev);
-	ret = crypto_aead_decrypt(req);
-	if (ret == -EINPROGRESS) {
+	ret = skb_copy_bits(skb, skb->len - icv_len, icv, icv_len);
+	if (unlikely(ret < 0)) {
+		memzero_explicit(&ctx, sizeof(ctx));
+		kfree_skb(skb);
 		return ERR_PTR(ret);
-	} else if (ret != 0) {
-		/* decryption/authentication failed
-		 * 10.6 if validateFrames is disabled, deliver anyway
-		 */
-		if (ret != -EBADMSG) {
-			kfree_skb(skb);
-			skb = ERR_PTR(ret);
-		}
-	} else {
-		macsec_skb_cb(skb)->valid = true;
 	}
-	dev_put(dev);
 
-	aead_request_free(req);
+	if (aes_gcm_decrypt_final(&ctx, icv) == 0)
+		macsec_skb_cb(skb)->valid = true;
+	/* else, decryption/authentication failed
+	 * 10.6 if validateFrames is disabled, deliver anyway
+	 */
 
 	return skb;
 }
@@ -1276,11 +1186,8 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 		skb = macsec_decrypt(skb, dev, rx_sa, sci, secy);
 
 	if (IS_ERR(skb)) {
-		/* the decrypt callback needs the reference */
-		if (PTR_ERR(skb) != -EINPROGRESS) {
-			macsec_rxsa_put(rx_sa);
-			macsec_rxsc_put(rx_sc);
-		}
+		macsec_rxsa_put(rx_sa);
+		macsec_rxsc_put(rx_sc);
 		rcu_read_unlock();
 		*pskb = NULL;
 		return RX_HANDLER_CONSUMED;
@@ -1370,41 +1277,19 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 	return RX_HANDLER_PASS;
 }
 
-static struct crypto_aead *macsec_alloc_tfm(char *key, int key_len, int icv_len)
-{
-	struct crypto_aead *tfm;
-	int ret;
-
-	tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
-
-	if (IS_ERR(tfm))
-		return tfm;
-
-	ret = crypto_aead_setkey(tfm, key, key_len);
-	if (ret < 0)
-		goto fail;
-
-	ret = crypto_aead_setauthsize(tfm, icv_len);
-	if (ret < 0)
-		goto fail;
-
-	return tfm;
-fail:
-	crypto_free_aead(tfm);
-	return ERR_PTR(ret);
-}
-
 static int init_rx_sa(struct macsec_rx_sa *rx_sa, char *sak, int key_len,
 		      int icv_len)
 {
+	int err;
+
 	rx_sa->stats = alloc_percpu(struct macsec_rx_sa_stats);
 	if (!rx_sa->stats)
 		return -ENOMEM;
 
-	rx_sa->key.tfm = macsec_alloc_tfm(sak, key_len, icv_len);
-	if (IS_ERR(rx_sa->key.tfm)) {
+	err = aes_gcm_preparekey(&rx_sa->key.gcm_key, sak, key_len, icv_len);
+	if (err) {
 		free_percpu(rx_sa->stats);
-		return PTR_ERR(rx_sa->key.tfm);
+		return err;
 	}
 
 	rx_sa->ssci = MACSEC_UNDEF_SSCI;
@@ -1498,14 +1383,16 @@ static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci,
 static int init_tx_sa(struct macsec_tx_sa *tx_sa, char *sak, int key_len,
 		      int icv_len)
 {
+	int err;
+
 	tx_sa->stats = alloc_percpu(struct macsec_tx_sa_stats);
 	if (!tx_sa->stats)
 		return -ENOMEM;
 
-	tx_sa->key.tfm = macsec_alloc_tfm(sak, key_len, icv_len);
-	if (IS_ERR(tx_sa->key.tfm)) {
+	err = aes_gcm_preparekey(&tx_sa->key.gcm_key, sak, key_len, icv_len);
+	if (err) {
 		free_percpu(tx_sa->stats);
-		return PTR_ERR(tx_sa->key.tfm);
+		return err;
 	}
 
 	tx_sa->ssci = MACSEC_UNDEF_SSCI;
@@ -1813,7 +1700,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 	err = init_rx_sa(rx_sa, nla_data(tb_sa[MACSEC_SA_ATTR_KEY]),
 			 secy->key_len, secy->icv_len);
 	if (err < 0) {
-		kfree(rx_sa);
+		kfree_sensitive(rx_sa);
 		rtnl_unlock();
 		return err;
 	}
@@ -2021,7 +1908,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 	err = init_tx_sa(tx_sa, nla_data(tb_sa[MACSEC_SA_ATTR_KEY]),
 			 secy->key_len, secy->icv_len);
 	if (err < 0) {
-		kfree(tx_sa);
+		kfree_sensitive(tx_sa);
 		rtnl_unlock();
 		return err;
 	}
@@ -3508,8 +3395,7 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 	len = skb->len;
 	skb = macsec_encrypt(skb, dev);
 	if (IS_ERR(skb)) {
-		if (PTR_ERR(skb) != -EINPROGRESS)
-			DEV_STATS_INC(dev, tx_dropped);
+		DEV_STATS_INC(dev, tx_dropped);
 		return NETDEV_TX_OK;
 	}
 
@@ -4316,17 +4202,8 @@ static int macsec_validate_attr(struct nlattr *tb[], struct nlattr *data[],
 
 	if (data[IFLA_MACSEC_ICV_LEN]) {
 		icv_len = nla_get_u8(data[IFLA_MACSEC_ICV_LEN]);
-		if (icv_len != MACSEC_DEFAULT_ICV_LEN) {
-			char dummy_key[DEFAULT_SAK_LEN] = { 0 };
-			struct crypto_aead *dummy_tfm;
-
-			dummy_tfm = macsec_alloc_tfm(dummy_key,
-						     DEFAULT_SAK_LEN,
-						     icv_len);
-			if (IS_ERR(dummy_tfm))
-				return PTR_ERR(dummy_tfm);
-			crypto_free_aead(dummy_tfm);
-		}
+		if (crypto_gcm_check_authsize(icv_len) != 0)
+			return -EINVAL;
 	}
 
 	es  = nla_get_u8_default(data[IFLA_MACSEC_ES], false);
diff --git a/include/net/macsec.h b/include/net/macsec.h
index d962093ee923..a315a33b3ac3 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -7,6 +7,7 @@
 #ifndef _NET_MACSEC_H_
 #define _NET_MACSEC_H_
 
+#include <crypto/aes-gcm.h>
 #include <linux/u64_stats_sync.h>
 #include <linux/if_vlan.h>
 #include <linux/workqueue.h>
@@ -63,12 +64,12 @@ typedef union pn {
 /**
  * struct macsec_key - SA key
  * @id: user-provided key identifier
- * @tfm: crypto struct, key storage
+ * @gcm_key: the AES-GCM key
  * @salt: salt used to generate IV in XPN cipher suites
  */
 struct macsec_key {
 	u8 id[MACSEC_KEYID_LEN];
-	struct crypto_aead *tfm;
+	struct aes_gcm_key gcm_key;
 	salt_t salt;
 };
 
-- 
2.54.0

