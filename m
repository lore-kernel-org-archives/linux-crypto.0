Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721993A5459;
	Tue,  7 Jul 2026 05:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402648; cv=none; b=p3WzsbeVNBbfl77a4e4mopi45hIZx2FiXRnNMqfZ3Rlrm1Jjv/8lFS5iRgeOgpcyxCfkkSPbb1rJ04QClC8DQkRbIWHvkYjYaOWDlR/rXaZL7+viaG+LTKs2M6OZON0a0SAyWOC2BZF1DW+DZhLqZSf+hTq7d8qC34tXfV9RXMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402648; c=relaxed/simple;
	bh=rJjsfVcyDDpiZb6wnj4G/SW1r4cHH1rUZlf1yawV+AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5KgDVSHiBNQP/0AbmtqHEZKmiwOb8sKPa8SOvWGpfE4TMxHn58q2EIO3d9n5M0OY8Xo1VBmOb3pi7GGAMOvdZH8S+mkuzWdKrZDKea5aJJVG/kZ/SHrF1GRSlqqtC7ldAcDiWPtfhSSD2shrfnxT7QuVt7KfyUZWODAijC+V6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/apekIZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/apekIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEB31F000E9;
	Tue,  7 Jul 2026 05:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402644;
	bh=GfKxRxOFb4BrlBlJqTc5iEcfF49B7dEbnTPlgqmSwSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/apekIZPeVdM/l7nOuMOf2FcnV2PLiEcA3N/QEjsb2lsMTiLu8X1gds1m4MyoFWQ
	 R0eznfSLic30Q5Fc0QH06eCJIcu7PNP2bSCP+dfPa4NF/H02/PrzC2vlmy1DE00gaO
	 FdQQRqIX8ILbP9Vh2zq7B7S1PH+TEXALgyttK2qAqkIBuawJqfuYMxJdZTaUuNr6Qx
	 oPWqBR9yH6tYm4mMzDGhe8fxZoCTTJtUYNzfBw58wOuGLYzs17FQMG01K6N7vNmSlM
	 ENPxH8sdc9cVNcAbOoV1fMM82rgkFXEArjDMEi17Zy0jiuHHaiqeS4zLYUyqP6HVqb
	 RZdQwBtvl9a5g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 33/33] net: tipc: Use AES-GCM library instead of crypto_aead
Date: Mon,  6 Jul 2026 22:35:03 -0700
Message-ID: <20260707053503.209874-34-ebiggers@kernel.org>
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
scatterlists are eliminated.  For encryption the skb is linear, so just
call the one-shot function aes_gcm_encrypt().  For decryption, just
iterate through the skb's data and decrypt it directly.

There was also an unnecessary copy of the key being made (in a
crypto_aead object) for every CPU.  That is removed as well.  The
library en/decryption functions treat struct aes_gcm_key as read-only,
so it can be used by an unlimited number of threads with no contention.

Asynchronous en/decryption operations are no longer supported, as that
execution model for symmetric crypto has been found to be harmful.  It
generated endless bugs and didn't actually improve performance.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/tipc/Kconfig  |   4 +-
 net/tipc/crypto.c | 467 ++++++++--------------------------------------
 net/tipc/msg.h    |   3 -
 net/tipc/sysctl.c |   6 +
 4 files changed, 85 insertions(+), 395 deletions(-)

diff --git a/net/tipc/Kconfig b/net/tipc/Kconfig
index 18f62135e47b..39fa54b04bb9 100644
--- a/net/tipc/Kconfig
+++ b/net/tipc/Kconfig
@@ -38,9 +38,7 @@ config TIPC_MEDIA_UDP
 config TIPC_CRYPTO
 	bool "TIPC encryption support"
 	depends on TIPC
-	select CRYPTO
-	select CRYPTO_AES
-	select CRYPTO_GCM
+	select CRYPTO_LIB_AES_GCM
 	default y
 	help
 	  Saying Y here will enable support for TIPC encryption.
diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 16f1ed1f6b1b..e0040309a788 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -34,8 +34,7 @@
  * POSSIBILITY OF SUCH DAMAGE.
  */
 
-#include <crypto/aead.h>
-#include <crypto/aes.h>
+#include <crypto/aes-gcm.h>
 #include <crypto/rng.h>
 #include "crypto.h"
 #include "msg.h"
@@ -69,9 +68,9 @@ enum {
 enum {
 	STAT_OK,
 	STAT_NOK,
-	STAT_ASYNC,
-	STAT_ASYNC_OK,
-	STAT_ASYNC_NOK,
+	STAT_ASYNC, /* no longer used */
+	STAT_ASYNC_OK, /* no longer used */
+	STAT_ASYNC_NOK, /* no longer used */
 	STAT_BADKEYS, /* tx only */
 	STAT_BADMSGS = STAT_BADKEYS, /* rx only */
 	STAT_NOKEYS,
@@ -121,19 +120,9 @@ struct tipc_key {
 	};
 };
 
-/**
- * struct tipc_tfm - TIPC TFM structure to form a list of TFMs
- * @tfm: cipher handle/key
- * @list: linked list of TFMs
- */
-struct tipc_tfm {
-	struct crypto_aead *tfm;
-	struct list_head list;
-};
-
 /**
  * struct tipc_aead - TIPC AEAD key structure
- * @tfm_entry: per-cpu pointer to one entry in TFM list
+ * @gcm_key: the AES-GCM key
  * @crypto: TIPC crypto owns this key
  * @cloned: reference to the source key in case cloning
  * @users: the number of the key users (TX/RX)
@@ -149,7 +138,7 @@ struct tipc_tfm {
  */
 struct tipc_aead {
 #define TIPC_AEAD_HINT_LEN (5)
-	struct tipc_tfm * __percpu *tfm_entry;
+	struct aes_gcm_key gcm_key;
 	struct tipc_crypto *crypto;
 	struct tipc_aead *cloned;
 	atomic_t users;
@@ -235,19 +224,6 @@ struct tipc_crypto {
 
 } ____cacheline_aligned;
 
-/* struct tipc_crypto_tx_ctx - TX context for callbacks */
-struct tipc_crypto_tx_ctx {
-	struct tipc_aead *aead;
-	struct tipc_bearer *bearer;
-	struct tipc_media_addr dst;
-};
-
-/* struct tipc_crypto_rx_ctx - RX context for callbacks */
-struct tipc_crypto_rx_ctx {
-	struct tipc_aead *aead;
-	struct tipc_bearer *bearer;
-};
-
 static struct tipc_aead *tipc_aead_get(struct tipc_aead __rcu *aead);
 static inline void tipc_aead_put(struct tipc_aead *aead);
 static void tipc_aead_free(struct rcu_head *rp);
@@ -255,22 +231,15 @@ static int tipc_aead_users(struct tipc_aead __rcu *aead);
 static void tipc_aead_users_inc(struct tipc_aead __rcu *aead, int lim);
 static void tipc_aead_users_dec(struct tipc_aead __rcu *aead, int lim);
 static void tipc_aead_users_set(struct tipc_aead __rcu *aead, int val);
-static struct crypto_aead *tipc_aead_tfm_next(struct tipc_aead *aead);
 static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
 			  u8 mode);
 static int tipc_aead_clone(struct tipc_aead **dst, struct tipc_aead *src);
-static void *tipc_aead_mem_alloc(struct crypto_aead *tfm,
-				 unsigned int crypto_ctx_size,
-				 u8 **iv, struct aead_request **req,
-				 struct scatterlist **sg, int nsg);
 static int tipc_aead_encrypt(struct tipc_aead *aead, struct sk_buff *skb,
 			     struct tipc_bearer *b,
 			     struct tipc_media_addr *dst,
 			     struct tipc_node *__dnode);
-static void tipc_aead_encrypt_done(void *data, int err);
 static int tipc_aead_decrypt(struct net *net, struct tipc_aead *aead,
 			     struct sk_buff *skb, struct tipc_bearer *b);
-static void tipc_aead_decrypt_done(void *data, int err);
 static inline int tipc_ehdr_size(struct tipc_ehdr *ehdr);
 static int tipc_ehdr_build(struct net *net, struct tipc_aead *aead,
 			   u8 tx_key, struct sk_buff *skb,
@@ -335,12 +304,6 @@ int tipc_aead_key_validate(struct tipc_aead_key *ukey, struct genl_info *info)
 {
 	int keylen;
 
-	/* Check if algorithm exists */
-	if (unlikely(!crypto_has_alg(ukey->alg_name, 0, 0))) {
-		GENL_SET_ERR_MSG(info, "unable to load the algorithm (module existed?)");
-		return -ENODEV;
-	}
-
 	/* Currently, we only support the "gcm(aes)" cipher algorithm */
 	if (strcmp(ukey->alg_name, "gcm(aes)")) {
 		GENL_SET_ERR_MSG(info, "not supported yet the algorithm");
@@ -391,30 +354,15 @@ static inline void tipc_aead_put(struct tipc_aead *aead)
 }
 
 /**
- * tipc_aead_free - Release AEAD key incl. all the TFMs in the list
+ * tipc_aead_free - Release AEAD key
  * @rp: rcu head pointer
  */
 static void tipc_aead_free(struct rcu_head *rp)
 {
 	struct tipc_aead *aead = container_of(rp, struct tipc_aead, rcu);
-	struct tipc_tfm *tfm_entry, *head, *tmp;
 
-	if (aead->cloned) {
+	if (aead->cloned)
 		tipc_aead_put(aead->cloned);
-	} else {
-		head = *get_cpu_ptr(aead->tfm_entry);
-		put_cpu_ptr(aead->tfm_entry);
-		list_for_each_entry_safe(tfm_entry, tmp, &head->list, list) {
-			crypto_free_aead(tfm_entry->tfm);
-			list_del(&tfm_entry->list);
-			kfree(tfm_entry);
-		}
-		/* Free the head */
-		crypto_free_aead(head->tfm);
-		list_del(&head->list);
-		kfree(head);
-	}
-	free_percpu(aead->tfm_entry);
 	kfree_sensitive(aead->key);
 	kfree_sensitive(aead);
 }
@@ -472,44 +420,21 @@ static void tipc_aead_users_set(struct tipc_aead __rcu *aead, int val)
 	rcu_read_unlock();
 }
 
-/**
- * tipc_aead_tfm_next - Move TFM entry to the next one in list and return it
- * @aead: the AEAD key pointer
- */
-static struct crypto_aead *tipc_aead_tfm_next(struct tipc_aead *aead)
-{
-	struct tipc_tfm **tfm_entry;
-	struct crypto_aead *tfm;
-
-	tfm_entry = get_cpu_ptr(aead->tfm_entry);
-	*tfm_entry = list_next_entry(*tfm_entry, list);
-	tfm = (*tfm_entry)->tfm;
-	put_cpu_ptr(tfm_entry);
-
-	return tfm;
-}
-
 /**
  * tipc_aead_init - Initiate TIPC AEAD
  * @aead: returned new TIPC AEAD key handle pointer
  * @ukey: pointer to user key data
  * @mode: the key mode
  *
- * Allocate a (list of) new cipher transformation (TFM) with the specific user
- * key data if valid. The number of the allocated TFMs can be set via the sysfs
- * "net/tipc/max_tfms" first.
- * Also, all the other AEAD data are also initialized.
+ * Allocate a new AEAD key container and prepare the AES-GCM key.
  *
  * Return: 0 if the initiation is successful, otherwise: < 0
  */
 static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
 			  u8 mode)
 {
-	struct tipc_tfm *tfm_entry, *head;
-	struct crypto_aead *tfm;
 	struct tipc_aead *tmp;
-	int keylen, err, cpu;
-	int tfm_cnt = 0;
+	int keylen, err;
 
 	if (unlikely(*aead))
 		return -EEXIST;
@@ -522,59 +447,9 @@ static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
 	/* The key consists of two parts: [AES-KEY][SALT] */
 	keylen = ukey->keylen - TIPC_AES_GCM_SALT_SIZE;
 
-	/* Allocate per-cpu TFM entry pointer */
-	tmp->tfm_entry = alloc_percpu(struct tipc_tfm *);
-	if (!tmp->tfm_entry) {
-		kfree_sensitive(tmp);
-		return -ENOMEM;
-	}
-
-	/* Make a list of TFMs with the user key data */
-	do {
-		tfm = crypto_alloc_aead(ukey->alg_name, 0, 0);
-		if (IS_ERR(tfm)) {
-			err = PTR_ERR(tfm);
-			break;
-		}
-
-		if (unlikely(!tfm_cnt &&
-			     crypto_aead_ivsize(tfm) != TIPC_AES_GCM_IV_SIZE)) {
-			crypto_free_aead(tfm);
-			err = -ENOTSUPP;
-			break;
-		}
-
-		err = crypto_aead_setauthsize(tfm, TIPC_AES_GCM_TAG_SIZE);
-		err |= crypto_aead_setkey(tfm, ukey->key, keylen);
-		if (unlikely(err)) {
-			crypto_free_aead(tfm);
-			break;
-		}
-
-		tfm_entry = kmalloc_obj(*tfm_entry);
-		if (unlikely(!tfm_entry)) {
-			crypto_free_aead(tfm);
-			err = -ENOMEM;
-			break;
-		}
-		INIT_LIST_HEAD(&tfm_entry->list);
-		tfm_entry->tfm = tfm;
-
-		/* First entry? */
-		if (!tfm_cnt) {
-			head = tfm_entry;
-			for_each_possible_cpu(cpu) {
-				*per_cpu_ptr(tmp->tfm_entry, cpu) = head;
-			}
-		} else {
-			list_add_tail(&tfm_entry->list, &head->list);
-		}
-
-	} while (++tfm_cnt < sysctl_tipc_max_tfms);
-
-	/* Not any TFM is allocated? */
-	if (!tfm_cnt) {
-		free_percpu(tmp->tfm_entry);
+	err = aes_gcm_preparekey(&tmp->gcm_key, ukey->key, keylen,
+				 TIPC_AES_GCM_TAG_SIZE);
+	if (unlikely(err)) {
 		kfree_sensitive(tmp);
 		return err;
 	}
@@ -606,10 +481,8 @@ static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
  * @dst: dest key for the cloning
  * @src: source key to clone from
  *
- * Make a "copy" of the source AEAD key data to the dest, the TFMs list is
- * common for the keys.
- * A reference to the source is hold in the "cloned" pointer for the later
- * freeing purposes.
+ * Make a "copy" of the source AEAD key data to the dest. A reference to the
+ * source is held in the "cloned" pointer for later freeing purposes.
  *
  * Note: this must be done in cluster-key mode only!
  * Return: 0 in case of success, otherwise < 0
@@ -617,7 +490,6 @@ static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
 static int tipc_aead_clone(struct tipc_aead **dst, struct tipc_aead *src)
 {
 	struct tipc_aead *aead;
-	int cpu;
 
 	if (!src)
 		return -ENOKEY;
@@ -632,16 +504,7 @@ static int tipc_aead_clone(struct tipc_aead **dst, struct tipc_aead *src)
 	if (unlikely(!aead))
 		return -ENOMEM;
 
-	aead->tfm_entry = alloc_percpu_gfp(struct tipc_tfm *, GFP_ATOMIC);
-	if (unlikely(!aead->tfm_entry)) {
-		kfree_sensitive(aead);
-		return -ENOMEM;
-	}
-
-	for_each_possible_cpu(cpu) {
-		*per_cpu_ptr(aead->tfm_entry, cpu) =
-				*per_cpu_ptr(src->tfm_entry, cpu);
-	}
+	aead->gcm_key = src->gcm_key;
 
 	memcpy(aead->hint, src->hint, sizeof(src->hint));
 	aead->mode = src->mode;
@@ -658,53 +521,54 @@ static int tipc_aead_clone(struct tipc_aead **dst, struct tipc_aead *src)
 	return 0;
 }
 
+static void tipc_decrypt_chunk(struct aes_gcm_ctx *ctx, u8 *data, size_t avail,
+			       size_t *assoc_len, size_t *crypt_len)
+{
+	size_t n;
+
+	if (*assoc_len && avail) {
+		/* Associated data */
+		n = min(avail, *assoc_len);
+		aes_gcm_auth_update(ctx, data, n);
+		data += n;
+		avail -= n;
+		*assoc_len -= n;
+	}
+
+	if (*crypt_len && avail) {
+		/* En/decrypted data */
+		n = min(avail, *crypt_len);
+		aes_gcm_decrypt_update(ctx, data, data, n);
+		*crypt_len -= n;
+	}
+}
+
 /**
- * tipc_aead_mem_alloc - Allocate memory for AEAD request operations
- * @tfm: cipher handle to be registered with the request
- * @crypto_ctx_size: size of crypto context for callback
- * @iv: returned pointer to IV data
- * @req: returned pointer to AEAD request data
- * @sg: returned pointer to SG lists
- * @nsg: number of SG lists to be allocated
+ * tipc_decrypt_skb() - Decrypt an skb in-place using AES-GCM
+ * @ctx: An AES-GCM context
+ * @skb: The socket buffer to process
+ * @assoc_len: Length of associated data
+ * @crypt_len: Length of payload data to encrypt or decrypt
  *
- * Allocate memory to store the crypto context data, AEAD request, IV and SG
- * lists, the memory layout is as follows:
- * crypto_ctx || iv || aead_req || sg[]
+ * Updates the given AES-GCM context with @assoc_len bytes of associated data
+ * from the skb, then decrypts @crypt_len bytes in-place.  Context
+ * initialization and finalization are handled by the caller.
  *
- * Return: the pointer to the memory areas in case of success, otherwise NULL
+ * The data (both associated and en/decrypted) is taken from the linear head and
+ * frag_list.  It is assumed that the @skb was processed by skb_cow_data(),
+ * meaning it has no page fragments (nr_frags == 0) and is writable.
  */
-static void *tipc_aead_mem_alloc(struct crypto_aead *tfm,
-				 unsigned int crypto_ctx_size,
-				 u8 **iv, struct aead_request **req,
-				 struct scatterlist **sg, int nsg)
+static void tipc_decrypt_skb(struct aes_gcm_ctx *ctx, struct sk_buff *skb,
+			     size_t assoc_len, size_t crypt_len)
 {
-	unsigned int iv_size, req_size;
-	unsigned int len;
-	u8 *mem;
-
-	iv_size = crypto_aead_ivsize(tfm);
-	req_size = sizeof(**req) + crypto_aead_reqsize(tfm);
-
-	len = crypto_ctx_size;
-	len += iv_size;
-	len += crypto_aead_alignmask(tfm) & ~(crypto_tfm_ctx_alignment() - 1);
-	len = ALIGN(len, crypto_tfm_ctx_alignment());
-	len += req_size;
-	len = ALIGN(len, __alignof__(struct scatterlist));
-	len += nsg * sizeof(**sg);
-
-	mem = kmalloc(len, GFP_ATOMIC);
-	if (!mem)
-		return NULL;
-
-	*iv = (u8 *)PTR_ALIGN(mem + crypto_ctx_size,
-			      crypto_aead_alignmask(tfm) + 1);
-	*req = (struct aead_request *)PTR_ALIGN(*iv + iv_size,
-						crypto_tfm_ctx_alignment());
-	*sg = (struct scatterlist *)PTR_ALIGN((u8 *)*req + req_size,
-					      __alignof__(struct scatterlist));
-
-	return (void *)mem;
+	struct sk_buff *frag_iter;
+
+	WARN_ON_ONCE(skb_shinfo(skb)->nr_frags);
+	tipc_decrypt_chunk(ctx, skb->data, skb_headlen(skb), &assoc_len,
+			   &crypt_len);
+	skb_walk_frags(skb, frag_iter)
+		tipc_decrypt_chunk(ctx, frag_iter->data, frag_iter->len,
+				   &assoc_len, &crypt_len);
 }
 
 /**
@@ -717,7 +581,6 @@ static void *tipc_aead_mem_alloc(struct crypto_aead *tfm,
  *
  * Return:
  * * 0                   : if the encryption has completed
- * * -EINPROGRESS/-EBUSY : if a callback will be performed
  * * < 0                 : the encryption has failed
  */
 static int tipc_aead_encrypt(struct tipc_aead *aead, struct sk_buff *skb,
@@ -725,16 +588,11 @@ static int tipc_aead_encrypt(struct tipc_aead *aead, struct sk_buff *skb,
 			     struct tipc_media_addr *dst,
 			     struct tipc_node *__dnode)
 {
-	struct crypto_aead *tfm = tipc_aead_tfm_next(aead);
-	struct tipc_crypto_tx_ctx *tx_ctx;
-	struct aead_request *req;
 	struct sk_buff *trailer;
-	struct scatterlist *sg;
 	struct tipc_ehdr *ehdr;
-	int ehsz, len, tailen, nsg, rc;
-	void *ctx;
+	int ehsz, len, tailen, nsg;
 	u32 salt;
-	u8 *iv;
+	u8 iv[TIPC_AES_GCM_IV_SIZE];
 
 	/* Make sure message len at least 4-byte aligned */
 	len = ALIGN(skb->len, 4);
@@ -760,20 +618,6 @@ static int tipc_aead_encrypt(struct tipc_aead *aead, struct sk_buff *skb,
 
 	pskb_put(skb, trailer, tailen);
 
-	/* Allocate memory for the AEAD operation */
-	ctx = tipc_aead_mem_alloc(tfm, sizeof(*tx_ctx), &iv, &req, &sg, nsg);
-	if (unlikely(!ctx))
-		return -ENOMEM;
-	TIPC_SKB_CB(skb)->crypto_ctx = ctx;
-
-	/* Map skb to the sg lists */
-	sg_init_table(sg, nsg);
-	rc = skb_to_sgvec(skb, sg, 0, skb->len);
-	if (unlikely(rc < 0)) {
-		pr_err("TX: skb_to_sgvec() returned %d, nsg %d!\n", rc, nsg);
-		goto exit;
-	}
-
 	/* Prepare IV: [SALT (4 octets)][SEQNO (8 octets)]
 	 * In case we're in cluster-key mode, SALT is varied by xor-ing with
 	 * the source address (or w0 of id), otherwise with the dest address
@@ -788,78 +632,12 @@ static int tipc_aead_encrypt(struct tipc_aead *aead, struct sk_buff *skb,
 	memcpy(iv, &salt, 4);
 	memcpy(iv + 4, (u8 *)&ehdr->seqno, 8);
 
-	/* Prepare request */
 	ehsz = tipc_ehdr_size(ehdr);
-	aead_request_set_tfm(req, tfm);
-	aead_request_set_ad(req, ehsz);
-	aead_request_set_crypt(req, sg, sg, len - ehsz, iv);
-
-	/* Set callback function & data */
-	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  tipc_aead_encrypt_done, skb);
-	tx_ctx = (struct tipc_crypto_tx_ctx *)ctx;
-	tx_ctx->aead = aead;
-	tx_ctx->bearer = b;
-	memcpy(&tx_ctx->dst, dst, sizeof(*dst));
-
-	/* Hold bearer */
-	if (unlikely(!tipc_bearer_hold(b))) {
-		rc = -ENODEV;
-		goto exit;
-	}
-
-	/* Get net to avoid freed tipc_crypto when delete namespace */
-	if (!maybe_get_net(aead->crypto->net)) {
-		tipc_bearer_put(b);
-		rc = -ENODEV;
-		goto exit;
-	}
-
-	/* Now, do encrypt */
-	rc = crypto_aead_encrypt(req);
-	if (rc == -EINPROGRESS || rc == -EBUSY)
-		return rc;
-
-	tipc_bearer_put(b);
-	put_net(aead->crypto->net);
-
-exit:
-	kfree(ctx);
-	TIPC_SKB_CB(skb)->crypto_ctx = NULL;
-	return rc;
-}
 
-static void tipc_aead_encrypt_done(void *data, int err)
-{
-	struct sk_buff *skb = data;
-	struct tipc_crypto_tx_ctx *tx_ctx = TIPC_SKB_CB(skb)->crypto_ctx;
-	struct tipc_bearer *b = tx_ctx->bearer;
-	struct tipc_aead *aead = tx_ctx->aead;
-	struct tipc_crypto *tx = aead->crypto;
-	struct net *net = tx->net;
-
-	switch (err) {
-	case 0:
-		this_cpu_inc(tx->stats->stat[STAT_ASYNC_OK]);
-		rcu_read_lock();
-		if (likely(test_bit(0, &b->up)))
-			b->media->send_msg(net, skb, b, &tx_ctx->dst);
-		else
-			kfree_skb(skb);
-		rcu_read_unlock();
-		break;
-	case -EINPROGRESS:
-		return;
-	default:
-		this_cpu_inc(tx->stats->stat[STAT_ASYNC_NOK]);
-		kfree_skb(skb);
-		break;
-	}
-
-	kfree(tx_ctx);
-	tipc_bearer_put(b);
-	tipc_aead_put(aead);
-	put_net(net);
+	/* Encrypt the skb in-place. */
+	aes_gcm_encrypt(skb->data + ehsz, skb->data + len, skb->data + ehsz,
+			len - ehsz, skb->data, ehsz, iv, &aead->gcm_key);
+	return 0;
 }
 
 /**
@@ -871,22 +649,18 @@ static void tipc_aead_encrypt_done(void *data, int err)
  *
  * Return:
  * * 0                   : if the decryption has completed
- * * -EINPROGRESS/-EBUSY : if a callback will be performed
  * * < 0                 : the decryption has failed
  */
 static int tipc_aead_decrypt(struct net *net, struct tipc_aead *aead,
 			     struct sk_buff *skb, struct tipc_bearer *b)
 {
-	struct tipc_crypto_rx_ctx *rx_ctx;
-	struct aead_request *req;
-	struct crypto_aead *tfm;
+	struct aes_gcm_ctx ctx;
 	struct sk_buff *unused;
-	struct scatterlist *sg;
 	struct tipc_ehdr *ehdr;
-	int ehsz, nsg, rc;
-	void *ctx;
+	int ehsz, nsg, rc, crypt_len;
 	u32 salt;
-	u8 *iv;
+	u8 iv[TIPC_AES_GCM_IV_SIZE];
+	u8 authtag[TIPC_AES_GCM_TAG_SIZE];
 
 	if (unlikely(!aead))
 		return -ENOKEY;
@@ -897,21 +671,6 @@ static int tipc_aead_decrypt(struct net *net, struct tipc_aead *aead,
 		return nsg;
 	}
 
-	/* Allocate memory for the AEAD operation */
-	tfm = tipc_aead_tfm_next(aead);
-	ctx = tipc_aead_mem_alloc(tfm, sizeof(*rx_ctx), &iv, &req, &sg, nsg);
-	if (unlikely(!ctx))
-		return -ENOMEM;
-	TIPC_SKB_CB(skb)->crypto_ctx = ctx;
-
-	/* Map skb to the sg lists */
-	sg_init_table(sg, nsg);
-	rc = skb_to_sgvec(skb, sg, 0, skb->len);
-	if (unlikely(rc < 0)) {
-		pr_err("RX: skb_to_sgvec() returned %d, nsg %d\n", rc, nsg);
-		goto exit;
-	}
-
 	/* Reconstruct IV: */
 	ehdr = (struct tipc_ehdr *)skb->data;
 	salt = aead->salt;
@@ -922,77 +681,19 @@ static int tipc_aead_decrypt(struct net *net, struct tipc_aead *aead,
 	memcpy(iv, &salt, 4);
 	memcpy(iv + 4, (u8 *)&ehdr->seqno, 8);
 
-	/* Prepare request */
 	ehsz = tipc_ehdr_size(ehdr);
-	aead_request_set_tfm(req, tfm);
-	aead_request_set_ad(req, ehsz);
-	aead_request_set_crypt(req, sg, sg, skb->len - ehsz, iv);
-
-	/* Set callback function & data */
-	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  tipc_aead_decrypt_done, skb);
-	rx_ctx = (struct tipc_crypto_rx_ctx *)ctx;
-	rx_ctx->aead = aead;
-	rx_ctx->bearer = b;
-
-	/* Hold bearer */
-	if (unlikely(!tipc_bearer_hold(b))) {
-		rc = -ENODEV;
-		goto exit;
-	}
+	crypt_len = skb->len - ehsz - aead->authsize;
+	if (unlikely(crypt_len < 0))
+		return -EBADMSG;
 
-	/* Get net to avoid freed tipc_crypto when delete namespace */
-	if (!maybe_get_net(net)) {
-		tipc_bearer_put(b);
-		rc = -ENODEV;
-		goto exit;
-	}
-
-	/* Now, do decrypt */
-	rc = crypto_aead_decrypt(req);
-	if (rc == -EINPROGRESS || rc == -EBUSY)
+	rc = skb_copy_bits(skb, skb->len - aead->authsize, authtag,
+			   aead->authsize);
+	if (unlikely(rc < 0))
 		return rc;
 
-	tipc_bearer_put(b);
-	put_net(net);
-
-exit:
-	kfree(ctx);
-	TIPC_SKB_CB(skb)->crypto_ctx = NULL;
-	return rc;
-}
-
-static void tipc_aead_decrypt_done(void *data, int err)
-{
-	struct sk_buff *skb = data;
-	struct tipc_crypto_rx_ctx *rx_ctx = TIPC_SKB_CB(skb)->crypto_ctx;
-	struct tipc_bearer *b = rx_ctx->bearer;
-	struct tipc_aead *aead = rx_ctx->aead;
-	struct tipc_crypto_stats __percpu *stats = aead->crypto->stats;
-	struct net *net = aead->crypto->net;
-
-	switch (err) {
-	case 0:
-		this_cpu_inc(stats->stat[STAT_ASYNC_OK]);
-		break;
-	case -EINPROGRESS:
-		return;
-	default:
-		this_cpu_inc(stats->stat[STAT_ASYNC_NOK]);
-		break;
-	}
-
-	kfree(rx_ctx);
-	tipc_crypto_rcv_complete(net, aead, b, &skb, err);
-	if (likely(skb)) {
-		if (likely(test_bit(0, &b->up)))
-			tipc_rcv(net, skb, b);
-		else
-			kfree_skb(skb);
-	}
-
-	tipc_bearer_put(b);
-	put_net(net);
+	aes_gcm_init(&ctx, iv, &aead->gcm_key);
+	tipc_decrypt_skb(&ctx, skb, ehsz, crypt_len);
+	return aes_gcm_decrypt_final(&ctx, authtag);
 }
 
 static inline int tipc_ehdr_size(struct tipc_ehdr *ehdr)
@@ -1680,7 +1381,6 @@ static inline void tipc_crypto_clone_msg(struct net *net, struct sk_buff *_skb,
  *
  * Return:
  * * 0                   : the encryption has succeeded (or no encryption)
- * * -EINPROGRESS/-EBUSY : the encryption is ongoing, a callback will be made
  * * -ENOKEK             : the encryption has failed due to no key
  * * -EKEYREVOKED        : the encryption has failed due to key revoked
  * * -ENOMEM             : the encryption has failed due to no memory
@@ -1769,11 +1469,6 @@ int tipc_crypto_xmit(struct net *net, struct sk_buff **skb,
 	case 0:
 		this_cpu_inc(stats->stat[STAT_OK]);
 		break;
-	case -EINPROGRESS:
-	case -EBUSY:
-		this_cpu_inc(stats->stat[STAT_ASYNC]);
-		*skb = NULL;
-		return rc;
 	default:
 		this_cpu_inc(stats->stat[STAT_NOK]);
 		if (rc == -ENOKEY)
@@ -1805,7 +1500,6 @@ int tipc_crypto_xmit(struct net *net, struct sk_buff **skb,
  *
  * Return:
  * * 0                   : the decryption has successfully completed
- * * -EINPROGRESS/-EBUSY : the decryption is ongoing, a callback will be made
  * * -ENOKEY             : the decryption has failed due to no key
  * * -EBADMSG            : the decryption has failed due to bad message
  * * -ENOMEM             : the decryption has failed due to no memory
@@ -1859,11 +1553,6 @@ int tipc_crypto_rcv(struct net *net, struct tipc_crypto *rx,
 	case 0:
 		this_cpu_inc(stats->stat[STAT_OK]);
 		break;
-	case -EINPROGRESS:
-	case -EBUSY:
-		this_cpu_inc(stats->stat[STAT_ASYNC]);
-		*skb = NULL;
-		return rc;
 	default:
 		this_cpu_inc(stats->stat[STAT_NOK]);
 		if (rc == -ENOKEY) {
diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index c5eec16213d7..c7f0105148bb 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -138,9 +138,6 @@ struct tipc_skb_cb {
 		u8 flags;
 	};
 	u8 reserved;
-#ifdef CONFIG_TIPC_CRYPTO
-	void *crypto_ctx;
-#endif
 } __packed;
 
 #define TIPC_SKB_CB(__skb) ((struct tipc_skb_cb *)&((__skb)->cb[0]))
diff --git a/net/tipc/sysctl.c b/net/tipc/sysctl.c
index 30d2e06e3d8c..3e8d9def5674 100644
--- a/net/tipc/sysctl.c
+++ b/net/tipc/sysctl.c
@@ -67,6 +67,12 @@ static struct ctl_table tipc_table[] = {
 	},
 #ifdef CONFIG_TIPC_CRYPTO
 	{
+		/*
+		 * This sysctl no longer has any effect on the way that TIPC
+		 * uses the crypto subsystem.  However, a special value can
+		 * still be written to this to trigger debug commands.  See
+		 * tipc_crypto_do_cmd().
+		 */
 		.procname	= "max_tfms",
 		.data		= &sysctl_tipc_max_tfms,
 		.maxlen		= sizeof(sysctl_tipc_max_tfms),
-- 
2.54.0

