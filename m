Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9503A2540;
	Tue,  7 Jul 2026 05:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402647; cv=none; b=VZ+wVQQbYzimtt6Ik2LIbWW13H7f9u5cWDpBbit3HwOW03QdTi0eiim6YR5OjAh8Cc5MK0F7VwqjZtmDBsCv0VsbCpP5n/zWVb9bdZMycZLogISpqeBlPj8wPegbd50FvBv9d44Bp1SwWgLJXIACE7alMREisJkPufZHxOOAjXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402647; c=relaxed/simple;
	bh=yESWFObPkZHQaJiDD/m6qAUsP3wdYzORMKTpmJ8CI/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7DhAe/jQGGmiNVBexfDfJLQAEuhGlCEpgJ/Oip18fdD+UzfHrLZ26P5DaxporVooexy75zJ0o5mz3EjsfgwI8pSpskol8Qn4ohI1isKrXBb4cm1fdWjck4RnEWYIBt5uH89WjgxZDE7jS2RIQQbSPtXh/9mQtAS8QlZMgAM9yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GMuJKn8k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GMuJKn8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CE71F01559;
	Tue,  7 Jul 2026 05:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402644;
	bh=Sdogjk949/oPnU0fvDtEEv8GpHJP8vERVq3ahlIBbHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GMuJKn8kyuPBxF5ochAMT0utXu/2MABrdC9vHyT1TVULTOl1AME5I0LLp/aICiTPA
	 hmpP03uqDOkMye3w+5psBlwAOfIVz1LAuMrJ04psgQQ2E6Hf0HWLy+TFRAPpbAd4rO
	 j+ZZC9j7Y/iND2w0001YwilN7XdezWulpA/vQEHhYL+rqtRuPf8XlWviP47Xusy7sU
	 0fObGd7HnmmeLOFh5CLW8r5N2iqlQ+2Mt4xODB7UZNenpZxJ3e+1s4oItg0aRMhCFV
	 EOWlvGWRWLcMzJ7bIcTDdVztzJRg6lPW3ZO4now2evwlrwvRhk55u2e8+MyF65Q31m
	 vFp/SybHJc4oQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 31/33] smb: client: Use AES-GCM and AES-CCM libraries
Date: Mon,  6 Jul 2026 22:35:01 -0700
Message-ID: <20260707053503.209874-32-ebiggers@kernel.org>
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

Now that there are library APIs for AES-GCM and AES-CCM, use them
instead of "gcm(aes)" and "ccm(aes)" crypto_aeads.  This significantly
simplifies the code, especially since the need to build scatterlists
goes away.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/client/Kconfig         |   7 +-
 fs/smb/client/cifsencrypt.c   |  14 --
 fs/smb/client/cifsfs.c        |   4 -
 fs/smb/client/cifsglob.h      |   8 -
 fs/smb/client/cifsproto.h     |  89 -----------
 fs/smb/client/connect.c       |  14 +-
 fs/smb/client/smb2ops.c       | 275 ++++++++++++++++------------------
 fs/smb/client/smb2pdu.c       |   2 -
 fs/smb/client/smb2proto.h     |   1 -
 fs/smb/client/smb2transport.c |  39 -----
 10 files changed, 135 insertions(+), 318 deletions(-)

diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
index 2b7db5fb0fd9..5d3e4024b6b5 100644
--- a/fs/smb/client/Kconfig
+++ b/fs/smb/client/Kconfig
@@ -4,12 +4,9 @@ config CIFS
 	depends on INET
 	select NLS
 	select NLS_UCS2_UTILS
-	select CRYPTO
-	select CRYPTO_AEAD2
-	select CRYPTO_CCM
-	select CRYPTO_GCM
-	select CRYPTO_AES
 	select CRYPTO_LIB_AES_CBC_MACS
+	select CRYPTO_LIB_AES_CCM
+	select CRYPTO_LIB_AES_GCM
 	select CRYPTO_LIB_ARC4
 	select CRYPTO_LIB_MD5
 	select CRYPTO_LIB_SHA256
diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index 34804e9842a8..5db6d26e933d 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -21,7 +21,6 @@
 #include <linux/highmem.h>
 #include <linux/fips.h>
 #include <linux/iov_iter.h>
-#include <crypto/aead.h>
 #include <crypto/aes-cbc-macs.h>
 #include <crypto/arc4.h>
 #include <crypto/md5.h>
@@ -499,16 +498,3 @@ calc_seckey(struct cifs_ses *ses)
 	kfree_sensitive(ctx_arc4);
 	return 0;
 }
-
-void
-cifs_crypto_secmech_release(struct TCP_Server_Info *server)
-{
-	if (server->secmech.enc) {
-		crypto_free_aead(server->secmech.enc);
-		server->secmech.enc = NULL;
-	}
-	if (server->secmech.dec) {
-		crypto_free_aead(server->secmech.dec);
-		server->secmech.dec = NULL;
-	}
-}
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index ea4fc0fa68ca..609fd0fb2285 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -2198,9 +2198,5 @@ MODULE_DESCRIPTION
 	"also older servers complying with the SNIA CIFS Specification)");
 MODULE_VERSION(CIFS_VERSION);
 MODULE_SOFTDEP("nls");
-MODULE_SOFTDEP("aes");
-MODULE_SOFTDEP("aead2");
-MODULE_SOFTDEP("ccm");
-MODULE_SOFTDEP("gcm");
 module_init(init_cifs)
 module_exit(exit_cifs)
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 99f9e6dca62b..c14b55365770 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -13,7 +13,6 @@
 #include <linux/in6.h>
 #include <linux/inet.h>
 #include <linux/slab.h>
-#include <linux/scatterlist.h>
 #include <linux/mm.h>
 #include <linux/mempool.h>
 #include <linux/workqueue.h>
@@ -220,12 +219,6 @@ struct session_key {
 	char *response;
 };
 
-/* encryption related structure/fields, not specific to a sec mech */
-struct cifs_secmech {
-	struct crypto_aead *enc; /* smb3 encryption AEAD TFM (AES-CCM and AES-GCM) */
-	struct crypto_aead *dec; /* smb3 decryption AEAD TFM (AES-CCM and AES-GCM) */
-};
-
 /* per smb session structure/fields */
 struct ntlmssp_auth {
 	bool sesskey_per_smbsess; /* whether session key is per smb session */
@@ -745,7 +738,6 @@ struct TCP_Server_Info {
 	unsigned long lstrp; /* when we got last response from this server */
 	unsigned long neg_start; /* when negotiate started (jiffies) */
 	unsigned long reconn_delay; /* when resched session and tcon reconnect */
-	struct cifs_secmech secmech; /* crypto sec mech functs, descriptors */
 #define	CIFS_NEGFLAVOR_UNENCAP	1	/* wct == 17, but no ext_sec */
 #define	CIFS_NEGFLAVOR_EXTENDED	2	/* wct == 17, ext_sec bit set */
 	char	negflavor;	/* NEGOTIATE response flavor */
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index c4ababcb51a3..637fe7d503cb 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -308,7 +308,6 @@ struct cifs_tcon *tcon_info_alloc(bool dir_leases_enabled,
 void tconInfoFree(struct cifs_tcon *tcon, enum smb3_tcon_ref_trace trace);
 
 int setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp);
-void cifs_crypto_secmech_release(struct TCP_Server_Info *server);
 int calc_seckey(struct cifs_ses *ses);
 int generate_smb30signingkey(struct cifs_ses *ses,
 			     struct TCP_Server_Info *server);
@@ -508,94 +507,6 @@ static inline int smb_EIO2(enum smb_eio_trace trace, unsigned long info, unsigne
 	return -EIO;
 }
 
-static inline int cifs_get_num_sgs(const struct smb_rqst *rqst,
-				   int num_rqst,
-				   const u8 *sig)
-{
-	unsigned int len, skip;
-	unsigned int nents = 0;
-	unsigned long addr;
-	size_t data_size;
-	int i, j;
-
-	/*
-	 * The first rqst has a transform header where the first 20 bytes are
-	 * not part of the encrypted blob.
-	 */
-	skip = 20;
-
-	/* Assumes the first rqst has a transform header as the first iov.
-	 * I.e.
-	 * rqst[0].rq_iov[0]  is transform header
-	 * rqst[0].rq_iov[1+] data to be encrypted/decrypted
-	 * rqst[1+].rq_iov[0+] data to be encrypted/decrypted
-	 */
-	for (i = 0; i < num_rqst; i++) {
-		data_size = iov_iter_count(&rqst[i].rq_iter);
-
-		/* We really don't want a mixture of pinned and unpinned pages
-		 * in the sglist.  It's hard to keep track of which is what.
-		 * Instead, we convert to a BVEC-type iterator higher up.
-		 */
-		if (data_size &&
-		    WARN_ON_ONCE(user_backed_iter(&rqst[i].rq_iter)))
-			return smb_EIO(smb_eio_trace_user_iter);
-
-		/* We also don't want to have any extra refs or pins to clean
-		 * up in the sglist.
-		 */
-		if (data_size &&
-		    WARN_ON_ONCE(iov_iter_extract_will_pin(&rqst[i].rq_iter)))
-			return smb_EIO(smb_eio_trace_extract_will_pin);
-
-		for (j = 0; j < rqst[i].rq_nvec; j++) {
-			struct kvec *iov = &rqst[i].rq_iov[j];
-
-			addr = (unsigned long)iov->iov_base + skip;
-			if (is_vmalloc_or_module_addr((void *)addr)) {
-				len = iov->iov_len - skip;
-				nents += DIV_ROUND_UP(offset_in_page(addr) + len,
-						      PAGE_SIZE);
-			} else {
-				nents++;
-			}
-			skip = 0;
-		}
-		if (data_size)
-			nents += iov_iter_npages(&rqst[i].rq_iter, INT_MAX);
-	}
-	nents += DIV_ROUND_UP(offset_in_page(sig) + SMB2_SIGNATURE_SIZE, PAGE_SIZE);
-	return nents;
-}
-
-/* We can not use the normal sg_set_buf() as we will sometimes pass a
- * stack object as buf.
- */
-static inline void cifs_sg_set_buf(struct sg_table *sgtable,
-				   const void *buf,
-				   unsigned int buflen)
-{
-	unsigned long addr = (unsigned long)buf;
-	unsigned int off = offset_in_page(addr);
-
-	addr &= PAGE_MASK;
-	if (is_vmalloc_or_module_addr((void *)addr)) {
-		do {
-			unsigned int len = min_t(unsigned int, buflen, PAGE_SIZE - off);
-
-			sg_set_page(&sgtable->sgl[sgtable->nents++],
-				    vmalloc_to_page((void *)addr), len, off);
-
-			off = 0;
-			addr += PAGE_SIZE;
-			buflen -= len;
-		} while (buflen);
-	} else {
-		sg_set_page(&sgtable->sgl[sgtable->nents++],
-			    virt_to_page((void *)addr), buflen, off);
-	}
-}
-
 static inline int cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 					 unsigned int find_flags,
 					 struct cifsFileInfo **ret_file)
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 85aec302c89e..77454380fe26 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1730,8 +1730,6 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	server->tcpStatus = CifsExiting;
 	spin_unlock(&server->srv_lock);
 
-	cifs_crypto_secmech_release(server);
-
 	kfree_sensitive(server->session_key.response);
 	server->session_key.response = NULL;
 	server->session_key.len = 0;
@@ -1848,7 +1846,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 #ifndef CONFIG_CIFS_SMB_DIRECT
 		cifs_dbg(VFS, "CONFIG_CIFS_SMB_DIRECT is not enabled\n");
 		rc = -ENOENT;
-		goto out_err_crypto_release;
+		goto out_err_put_net;
 #endif
 		tcp_ses->smbd_conn = smbd_get_connection(
 			tcp_ses, (struct sockaddr *)&ctx->dstaddr);
@@ -1858,13 +1856,13 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 			goto smbd_connected;
 		} else {
 			rc = -ENOENT;
-			goto out_err_crypto_release;
+			goto out_err_put_net;
 		}
 	}
 	rc = ip_connect(tcp_ses);
 	if (rc < 0) {
 		cifs_dbg(VFS, "Error connecting to socket. Aborting operation.\n");
-		goto out_err_crypto_release;
+		goto out_err_put_net;
 	}
 smbd_connected:
 	/*
@@ -1895,7 +1893,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 		rc = PTR_ERR(tcp_ses->tsk);
 		cifs_dbg(VFS, "error %d create cifsd thread\n", rc);
 		module_put(THIS_MODULE);
-		goto out_err_crypto_release;
+		goto out_err_put_net;
 	}
 	/* thread created, put it on the list */
 	spin_lock(&cifs_tcp_ses_lock);
@@ -1913,9 +1911,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 
 	return tcp_ses;
 
-out_err_crypto_release:
-	cifs_crypto_secmech_release(tcp_ses);
-
+out_err_put_net:
 	put_net(cifs_net_ns(tcp_ses));
 
 out_err:
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 06e9322a762a..7c92410c5461 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5,13 +5,14 @@
  *  Copyright (c) 2012, Jeff Layton <jlayton@redhat.com>
  */
 
+#include <crypto/aes-ccm.h>
+#include <crypto/aes-gcm.h>
+#include <linux/iov_iter.h>
 #include <linux/pagemap.h>
 #include <linux/vfs.h>
 #include <linux/falloc.h>
-#include <linux/scatterlist.h>
 #include <linux/uuid.h>
 #include <linux/sort.h>
-#include <crypto/aead.h>
 #include <linux/fiemap.h>
 #include <linux/folio_queue.h>
 #include <uapi/linux/magic.h>
@@ -4351,86 +4352,82 @@ fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
 	memcpy(&tr_hdr->SessionId, &shdr->SessionId, 8);
 }
 
-static void *smb2_aead_req_alloc(struct crypto_aead *tfm, const struct smb_rqst *rqst,
-				 int num_rqst, const u8 *sig, u8 **iv,
-				 struct aead_request **req, struct sg_table *sgt,
-				 unsigned int *num_sgs)
+struct smb3_crypt_ctx {
+	union {
+		struct aes_gcm_ctx gcm;
+		struct aes_ccm_ctx ccm;
+	};
+	__le16 cipher_type;
+	int enc;
+};
+
+static size_t smb3_crypt_step(void *data, size_t progress, size_t len,
+			      void *priv, void *priv2)
 {
-	unsigned int req_size = sizeof(**req) + crypto_aead_reqsize(tfm);
-	unsigned int iv_size = crypto_aead_ivsize(tfm);
-	unsigned int len;
-	int ret;
-	u8 *p;
-
-	ret = cifs_get_num_sgs(rqst, num_rqst, sig);
-	if (ret < 0)
-		return ERR_PTR(ret);
-	*num_sgs = ret;
-
-	len = iv_size;
-	len += crypto_aead_alignmask(tfm) & ~(crypto_tfm_ctx_alignment() - 1);
-	len = ALIGN(len, crypto_tfm_ctx_alignment());
-	len += req_size;
-	len = ALIGN(len, __alignof__(struct scatterlist));
-	len += array_size(*num_sgs, sizeof(struct scatterlist));
-
-	p = kzalloc(len, GFP_NOFS);
-	if (!p)
-		return ERR_PTR(-ENOMEM);
-
-	*iv = (u8 *)PTR_ALIGN(p, crypto_aead_alignmask(tfm) + 1);
-	*req = (struct aead_request *)PTR_ALIGN(*iv + iv_size,
-						crypto_tfm_ctx_alignment());
-	sgt->sgl = (struct scatterlist *)PTR_ALIGN((u8 *)*req + req_size,
-						   __alignof__(struct scatterlist));
-	return p;
+	struct smb3_crypt_ctx *ctx = priv;
+
+	switch (ctx->cipher_type) {
+	case SMB2_ENCRYPTION_AES128_GCM:
+	case SMB2_ENCRYPTION_AES256_GCM:
+		if (ctx->enc)
+			aes_gcm_encrypt_update(&ctx->gcm, data, data, len);
+		else
+			aes_gcm_decrypt_update(&ctx->gcm, data, data, len);
+		return 0;
+	case SMB2_ENCRYPTION_AES128_CCM:
+	case SMB2_ENCRYPTION_AES256_CCM:
+		if (ctx->enc)
+			aes_ccm_encrypt_update(&ctx->ccm, data, data, len);
+		else
+			aes_ccm_decrypt_update(&ctx->ccm, data, data, len);
+		return 0;
+	default:
+		WARN_ON_ONCE(1);
+		return len;
+	}
 }
 
-static void *smb2_get_aead_req(struct crypto_aead *tfm, struct smb_rqst *rqst,
-			       int num_rqst, const u8 *sig, u8 **iv,
-			       struct aead_request **req, struct scatterlist **sgl)
+static int smb3_crypt_rqst(struct smb_rqst *rqst, struct smb3_crypt_ctx *ctx,
+			   unsigned int start_vec, unsigned int *remaining)
 {
-	struct sg_table sgtable = {};
-	unsigned int skip, num_sgs, i, j;
-	ssize_t rc;
-	void *p;
+	for (unsigned int i = start_vec; i < rqst->rq_nvec; i++) {
+		size_t len = min(rqst->rq_iov[i].iov_len, *remaining);
 
-	p = smb2_aead_req_alloc(tfm, rqst, num_rqst, sig, iv, req, &sgtable, &num_sgs);
-	if (IS_ERR(p))
-		return ERR_CAST(p);
+		smb3_crypt_step(rqst->rq_iov[i].iov_base, 0, len, ctx, NULL);
+		*remaining -= len;
+	}
+	if (*remaining > 0 && iov_iter_count(&rqst->rq_iter) > 0) {
+		struct iov_iter tmp_iter = rqst->rq_iter;
+		size_t maxsize = min(iov_iter_count(&tmp_iter), *remaining);
+		size_t did;
 
-	sg_init_marker(sgtable.sgl, num_sgs);
+		did = iterate_and_advance_kernel(&tmp_iter, maxsize, ctx, NULL,
+						 smb3_crypt_step);
+		if (did != maxsize)
+			return -EIO;
+		*remaining -= did;
+	}
+	return 0;
+}
 
+static int smb3_crypt_rqsts(struct smb_rqst *rqst, int num_rqst,
+			    unsigned int crypt_len, struct smb3_crypt_ctx *ctx)
+{
 	/*
-	 * The first rqst has a transform header where the
-	 * first 20 bytes are not part of the encrypted blob.
+	 * Encrypt or decrypt the payload data.
+	 * Skip the transform header rqst[0].rq_iov[0].
 	 */
-	skip = 20;
+	for (int i = 0; i < num_rqst; i++) {
+		int rc = smb3_crypt_rqst(&rqst[i], ctx, i == 0 ? 1 : 0,
+					 &crypt_len);
 
-	for (i = 0; i < num_rqst; i++) {
-		struct iov_iter *iter = &rqst[i].rq_iter;
-		size_t count = iov_iter_count(iter);
-
-		for (j = 0; j < rqst[i].rq_nvec; j++) {
-			cifs_sg_set_buf(&sgtable,
-					rqst[i].rq_iov[j].iov_base + skip,
-					rqst[i].rq_iov[j].iov_len - skip);
-
-			/* See the above comment on the 'skip' assignment */
-			skip = 0;
-		}
-		sgtable.orig_nents = sgtable.nents;
-
-		rc = extract_iter_to_sg(iter, count, &sgtable,
-					num_sgs - sgtable.nents, 0);
-		iov_iter_revert(iter, rc);
-		sgtable.orig_nents = sgtable.nents;
+		if (rc)
+			return rc;
 	}
-
-	cifs_sg_set_buf(&sgtable, sig, SMB2_SIGNATURE_SIZE);
-	sg_mark_end(&sgtable.sgl[sgtable.nents - 1]);
-	*sgl = sgtable.sgl;
-	return p;
+	if (crypt_len != 0)
+		/* Processed less data than expected. */
+		return -EOVERFLOW;
+	return 0;
 }
 
 static int
@@ -4468,22 +4465,22 @@ smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
  * On success return encrypted data in iov[1-N] and pages, leave iov[0]
  * untouched.
  */
-static int
-crypt_message(struct TCP_Server_Info *server, int num_rqst,
-	      struct smb_rqst *rqst, int enc, struct crypto_aead *tfm)
+static int crypt_message(struct TCP_Server_Info *server, int num_rqst,
+			 struct smb_rqst *rqst, int enc)
 {
 	struct smb2_transform_hdr *tr_hdr =
 		(struct smb2_transform_hdr *)rqst[0].rq_iov[0].iov_base;
+	__le16 cipher_type = server->cipher_type;
+	const u8 *assoc_data = (const u8 *)tr_hdr + 20;
 	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
 	int rc = 0;
-	struct scatterlist *sg;
-	u8 sign[SMB2_SIGNATURE_SIZE] = {};
 	u8 key[SMB3_ENC_DEC_KEY_SIZE];
-	struct aead_request *req;
-	u8 *iv;
-	DECLARE_CRYPTO_WAIT(wait);
+	union {
+		struct aes_gcm_key gcm;
+		struct aes_ccm_key ccm;
+	} crypt_key;
+	struct smb3_crypt_ctx ctx;
 	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
-	void *creq;
 
 	rc = smb2_get_enc_key(server, le64_to_cpu(tr_hdr->SessionId), enc, key);
 	if (rc) {
@@ -4492,54 +4489,61 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 		return rc;
 	}
 
-	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||
-		(server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
-		rc = crypto_aead_setkey(tfm, key, SMB3_GCM256_CRYPTKEY_SIZE);
-	else
-		rc = crypto_aead_setkey(tfm, key, SMB3_GCM128_CRYPTKEY_SIZE);
-
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Failed to set aead key %d\n", __func__, rc);
-		return rc;
-	}
+	ctx.cipher_type = cipher_type;
+	ctx.enc = enc;
 
-	rc = crypto_aead_setauthsize(tfm, SMB2_SIGNATURE_SIZE);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Failed to set authsize %d\n", __func__, rc);
-		return rc;
-	}
+	if (cipher_type == SMB2_ENCRYPTION_AES128_GCM ||
+	    cipher_type == SMB2_ENCRYPTION_AES256_GCM) {
+		size_t key_size = (cipher_type == SMB2_ENCRYPTION_AES128_GCM) ?
+					  AES_KEYSIZE_128 :
+					  AES_KEYSIZE_256;
 
-	creq = smb2_get_aead_req(tfm, rqst, num_rqst, sign, &iv, &req, &sg);
-	if (IS_ERR(creq))
-		return PTR_ERR(creq);
+		rc = aes_gcm_preparekey(&crypt_key.gcm, key, key_size,
+					SMB2_SIGNATURE_SIZE);
+		if (rc)
+			goto out;
 
-	if (!enc) {
-		memcpy(sign, &tr_hdr->Signature, SMB2_SIGNATURE_SIZE);
-		crypt_len += SMB2_SIGNATURE_SIZE;
-	}
+		aes_gcm_init(&ctx.gcm, tr_hdr->Nonce, &crypt_key.gcm);
+		aes_gcm_auth_update(&ctx.gcm, assoc_data, assoc_data_len);
+		rc = smb3_crypt_rqsts(rqst, num_rqst, crypt_len, &ctx);
+		if (rc)
+			goto out;
+		if (enc)
+			aes_gcm_encrypt_final(&ctx.gcm, tr_hdr->Signature);
+		else
+			rc = aes_gcm_decrypt_final(&ctx.gcm, tr_hdr->Signature);
+	} else if (cipher_type == SMB2_ENCRYPTION_AES128_CCM ||
+		   cipher_type == SMB2_ENCRYPTION_AES256_CCM) {
+		size_t key_size = (cipher_type == SMB2_ENCRYPTION_AES128_CCM) ?
+					  AES_KEYSIZE_128 :
+					  AES_KEYSIZE_256;
+
+		rc = aes_ccm_preparekey(&crypt_key.ccm, key, key_size,
+					SMB2_SIGNATURE_SIZE);
+		if (rc)
+			goto out;
 
-	if ((server->cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
-	    (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
-		memcpy(iv, (char *)tr_hdr->Nonce, SMB3_AES_GCM_NONCE);
-	else {
-		iv[0] = 3;
-		memcpy(iv + 1, (char *)tr_hdr->Nonce, SMB3_AES_CCM_NONCE);
+		rc = aes_ccm_init(&ctx.ccm, tr_hdr->Nonce, SMB3_AES_CCM_NONCE,
+				  assoc_data_len, crypt_len, &crypt_key.ccm);
+		if (rc)
+			goto out;
+		aes_ccm_auth_update(&ctx.ccm, assoc_data, assoc_data_len);
+		rc = smb3_crypt_rqsts(rqst, num_rqst, crypt_len, &ctx);
+		if (rc)
+			goto out;
+		if (enc)
+			aes_ccm_encrypt_final(&ctx.ccm, tr_hdr->Signature);
+		else
+			rc = aes_ccm_decrypt_final(&ctx.ccm, tr_hdr->Signature);
+	} else {
+		WARN_ON_ONCE(1);
+		rc = -EINVAL;
 	}
 
-	aead_request_set_tfm(req, tfm);
-	aead_request_set_crypt(req, sg, sg, crypt_len, iv);
-	aead_request_set_ad(req, assoc_data_len);
-
-	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  crypto_req_done, &wait);
-
-	rc = crypto_wait_req(enc ? crypto_aead_encrypt(req)
-				: crypto_aead_decrypt(req), &wait);
-
-	if (!rc && enc)
-		memcpy(&tr_hdr->Signature, sign, SMB2_SIGNATURE_SIZE);
-
-	kfree_sensitive(creq);
+out:
+	memzero_explicit(&ctx, sizeof(ctx));
+	memzero_explicit(&crypt_key, sizeof(crypt_key));
+	memzero_explicit(key, sizeof(key));
 	return rc;
 }
 
@@ -4623,7 +4627,7 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
 	/* fill the 1st iov with a transform header */
 	fill_transform_hdr(tr_hdr, orig_len, old_rq, server->cipher_type);
 
-	rc = crypt_message(server, num_rqst, new_rq, 1, server->secmech.enc);
+	rc = crypt_message(server, num_rqst, new_rq, 1);
 	cifs_dbg(FYI, "Encrypt message returned %d\n", rc);
 	if (rc)
 		goto err_free;
@@ -4648,7 +4652,6 @@ decrypt_raw_data(struct TCP_Server_Info *server, char *buf,
 		 unsigned int buf_data_size, struct iov_iter *iter,
 		 bool is_offloaded)
 {
-	struct crypto_aead *tfm;
 	struct smb_rqst rqst = {NULL};
 	struct kvec iov[2];
 	size_t iter_size = 0;
@@ -4666,31 +4669,9 @@ decrypt_raw_data(struct TCP_Server_Info *server, char *buf,
 		iter_size = iov_iter_count(iter);
 	}
 
-	if (is_offloaded) {
-		if ((server->cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
-		    (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
-			tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
-		else
-			tfm = crypto_alloc_aead("ccm(aes)", 0, 0);
-		if (IS_ERR(tfm)) {
-			rc = PTR_ERR(tfm);
-			cifs_server_dbg(VFS, "%s: Failed alloc decrypt TFM, rc=%d\n", __func__, rc);
-
-			return rc;
-		}
-	} else {
-		rc = smb3_crypto_aead_allocate(server);
-		if (unlikely(rc))
-			return rc;
-		tfm = server->secmech.dec;
-	}
-
-	rc = crypt_message(server, 1, &rqst, 0, tfm);
+	rc = crypt_message(server, 1, &rqst, 0);
 	cifs_dbg(FYI, "Decrypt message returned %d\n", rc);
 
-	if (is_offloaded)
-		crypto_free_aead(tfm);
-
 	if (rc)
 		return rc;
 
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 95c0efe9d43b..3eb8bd1e7a6b 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1343,8 +1343,6 @@ SMB2_negotiate(const unsigned int xid,
 			cifs_server_dbg(VFS, "Missing expected negotiate contexts\n");
 	}
 
-	if (server->cipher_type && !rc)
-		rc = smb3_crypto_aead_allocate(server);
 neg_exit:
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 78a4e1c340f9..141d8d1336a5 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -113,7 +113,6 @@ int smb2_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 		      const unsigned int xid);
 int smb2_push_mandatory_locks(struct cifsFileInfo *cfile);
 void smb2_reconnect_server(struct work_struct *work);
-int smb3_crypto_aead_allocate(struct TCP_Server_Info *server);
 unsigned long smb_rqst_len(struct TCP_Server_Info *server,
 			   struct smb_rqst *rqst);
 void smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst);
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 1143ee52470a..23884e311939 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -18,7 +18,6 @@
 #include <asm/processor.h>
 #include <linux/mempool.h>
 #include <linux/highmem.h>
-#include <crypto/aead.h>
 #include <crypto/aes-cbc-macs.h>
 #include <crypto/sha2.h>
 #include <crypto/utils.h>
@@ -776,41 +775,3 @@ smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 
 	return mid;
 }
-
-int
-smb3_crypto_aead_allocate(struct TCP_Server_Info *server)
-{
-	struct crypto_aead *tfm;
-
-	if (!server->secmech.enc) {
-		if ((server->cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
-		    (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
-			tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
-		else
-			tfm = crypto_alloc_aead("ccm(aes)", 0, 0);
-		if (IS_ERR(tfm)) {
-			cifs_server_dbg(VFS, "%s: Failed alloc encrypt aead\n",
-				 __func__);
-			return PTR_ERR(tfm);
-		}
-		server->secmech.enc = tfm;
-	}
-
-	if (!server->secmech.dec) {
-		if ((server->cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
-		    (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
-			tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
-		else
-			tfm = crypto_alloc_aead("ccm(aes)", 0, 0);
-		if (IS_ERR(tfm)) {
-			crypto_free_aead(server->secmech.enc);
-			server->secmech.enc = NULL;
-			cifs_server_dbg(VFS, "%s: Failed to alloc decrypt aead\n",
-				 __func__);
-			return PTR_ERR(tfm);
-		}
-		server->secmech.dec = tfm;
-	}
-
-	return 0;
-}
-- 
2.54.0

