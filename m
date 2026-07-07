Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54BD3A2E39;
	Tue,  7 Jul 2026 05:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402648; cv=none; b=PTV0gsAgUwCDNZj/ggMmlpffpKxjjoxQ/DkqSPFDF1RlA+SzNXMmp+Uzc7wGbNhlMRi3LDB/YF8uVraNYFZDuUJQprSXDp8NIM0climtzVCVEd5h1jxhXLXxqRNPJgldHblQDs1DmenFnlc6xnmAq4+QA0h0SOvuBloZ4E+ZWQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402648; c=relaxed/simple;
	bh=sguCXYDuO+5fF5PvNhSHY906JLtngiO51ZZpqAH9y1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogZQuJzjA5hgF06qWes2JnzxBTq+oE3Zzu2l6qUqxXCIM7O96v/d3f/ekI9JqituIABhy1crtPZArQiAzETBB3S3XJlK9TSm/mJ8F6KATsMJMnVP2Lp3Kwx7f8HRYkdQspni/LqQkNtcVzjsy6eQjzsEPRNrPLMx+AIyWwUALRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QWk6t5qi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QWk6t5qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B9A1F00A3E;
	Tue,  7 Jul 2026 05:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402644;
	bh=5SoyvDlkOaTDJPFZkGtkCv4lIeETvdMUN1jTWm0VpCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWk6t5qi8QH+IxCKRcJC4MoCvPJ+QygCjHT92KAxN9Xayhm7btKlsvT3cyaF44u3K
	 MaZGPURa0R2giqXsLtdouCApVQaFHKdNHekfqDsTSO20tEiL21QDNIenjYLe+fSKvZ
	 KzS5jBINV8NQZtjzonlu2YdzPWl65kOlhdErct8WL3RfCc4cpiEx2st6CcaWzY9YZX
	 37tMdtw9vzV9/jyJHpa8S9BfvPthorChPacWzXHgx/jD7leP7pNoXWc6VVIbwF3OEW
	 ea4rD+ytllyfeQ1FotS35/cI/MAGYJIS1Hy2P2VAthxnUKshMVuUfb5v8N+pCrH0lN
	 Kn1Viqm7ylwOA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 32/33] ksmbd: Use AES-GCM and AES-CCM libraries
Date: Mon,  6 Jul 2026 22:35:02 -0700
Message-ID: <20260707053503.209874-33-ebiggers@kernel.org>
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
simplifies the code, especially since the pool of crypto_aead objects
and all the scatterlist building code go away.

Move the encryption and decryption code directly into smb3_decrypt_req()
and smb3_encrypt_resp() to take advantage of their respective data
layouts.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/server/Kconfig      |   6 +-
 fs/smb/server/Makefile     |   2 +-
 fs/smb/server/auth.c       | 227 -------------------------------------
 fs/smb/server/auth.h       |   2 -
 fs/smb/server/crypto_ctx.c | 176 ----------------------------
 fs/smb/server/crypto_ctx.h |  32 ------
 fs/smb/server/server.c     |  14 +--
 fs/smb/server/smb2pdu.c    | 133 +++++++++++++++++++---
 8 files changed, 124 insertions(+), 468 deletions(-)
 delete mode 100644 fs/smb/server/crypto_ctx.c
 delete mode 100644 fs/smb/server/crypto_ctx.h

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index 08d8b7a965a6..6b1a23d01acd 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -6,17 +6,15 @@ config SMB_SERVER
 	select NLS
 	select NLS_UTF8
 	select NLS_UCS2_UTILS
-	select CRYPTO
 	select CRYPTO_LIB_AES_CBC_MACS
+	select CRYPTO_LIB_AES_CCM
+	select CRYPTO_LIB_AES_GCM
 	select CRYPTO_LIB_ARC4
 	select CRYPTO_LIB_DES
 	select CRYPTO_LIB_MD5
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
 	select CRYPTO_LIB_UTILS
-	select CRYPTO_AEAD2
-	select CRYPTO_CCM
-	select CRYPTO_GCM
 	select ASN1
 	select OID_REGISTRY
 	select CRC32
diff --git a/fs/smb/server/Makefile b/fs/smb/server/Makefile
index a3e9306055e8..da1c972b9042 100644
--- a/fs/smb/server/Makefile
+++ b/fs/smb/server/Makefile
@@ -5,7 +5,7 @@
 obj-$(CONFIG_SMB_SERVER) += ksmbd.o
 
 ksmbd-y :=	unicode.o auth.o vfs.o vfs_cache.o server.o ndr.o \
-		misc.o oplock.o connection.o ksmbd_work.o crypto_ctx.o \
+		misc.o oplock.o connection.o ksmbd_work.o \
 		mgmt/ksmbd_ida.o mgmt/user_config.o mgmt/share_config.o \
 		mgmt/tree_connect.o mgmt/user_session.o smb_common.o \
 		transport_tcp.o transport_ipc.o smbacl.o smb2pdu.o \
diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 86f521e849d5..07aaeb2fcd34 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -11,27 +11,23 @@
 #include <linux/writeback.h>
 #include <linux/uio.h>
 #include <linux/xattr.h>
-#include <crypto/aead.h>
 #include <crypto/aes-cbc-macs.h>
 #include <crypto/md5.h>
 #include <crypto/sha2.h>
 #include <crypto/utils.h>
 #include <linux/random.h>
-#include <linux/scatterlist.h>
 
 #include "auth.h"
 #include "glob.h"
 
 #include <linux/fips.h>
 #include <crypto/arc4.h>
-#include <crypto/des.h>
 
 #include "server.h"
 #include "smb_common.h"
 #include "connection.h"
 #include "mgmt/user_session.h"
 #include "mgmt/user_config.h"
-#include "crypto_ctx.h"
 #include "transport_ipc.h"
 
 /*
@@ -700,226 +696,3 @@ int ksmbd_gen_preauth_integrity_hash(struct ksmbd_conn *conn, char *buf,
 	sha512_final(&sha_ctx, pi_hash);
 	return 0;
 }
-
-static int ksmbd_get_encryption_key(struct ksmbd_work *work, __u64 ses_id,
-				    int enc, u8 *key)
-{
-	struct ksmbd_session *sess;
-	u8 *ses_enc_key;
-
-	if (enc)
-		sess = work->sess;
-	else
-		sess = ksmbd_session_lookup_all(work->conn, ses_id);
-	if (!sess)
-		return -EINVAL;
-
-	ses_enc_key = enc ? sess->smb3encryptionkey :
-		sess->smb3decryptionkey;
-	memcpy(key, ses_enc_key, SMB3_ENC_DEC_KEY_SIZE);
-	if (!enc)
-		ksmbd_user_session_put(sess);
-
-	return 0;
-}
-
-static inline void smb2_sg_set_buf(struct scatterlist *sg, const void *buf,
-				   unsigned int buflen)
-{
-	void *addr;
-
-	if (is_vmalloc_addr(buf))
-		addr = vmalloc_to_page(buf);
-	else
-		addr = virt_to_page(buf);
-	sg_set_page(sg, addr, buflen, offset_in_page(buf));
-}
-
-static struct scatterlist *ksmbd_init_sg(struct kvec *iov, unsigned int nvec,
-					 u8 *sign)
-{
-	struct scatterlist *sg;
-	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
-	int i, *nr_entries, total_entries = 0, sg_idx = 0;
-
-	if (!nvec)
-		return NULL;
-
-	nr_entries = kzalloc_objs(int, nvec, KSMBD_DEFAULT_GFP);
-	if (!nr_entries)
-		return NULL;
-
-	for (i = 0; i < nvec - 1; i++) {
-		unsigned long kaddr = (unsigned long)iov[i + 1].iov_base;
-
-		if (is_vmalloc_addr(iov[i + 1].iov_base)) {
-			nr_entries[i] = ((kaddr + iov[i + 1].iov_len +
-					PAGE_SIZE - 1) >> PAGE_SHIFT) -
-				(kaddr >> PAGE_SHIFT);
-		} else {
-			nr_entries[i]++;
-		}
-		total_entries += nr_entries[i];
-	}
-
-	/* Add two entries for transform header and signature */
-	total_entries += 2;
-
-	sg = kmalloc_objs(struct scatterlist, total_entries, KSMBD_DEFAULT_GFP);
-	if (!sg) {
-		kfree(nr_entries);
-		return NULL;
-	}
-
-	sg_init_table(sg, total_entries);
-	smb2_sg_set_buf(&sg[sg_idx++], iov[0].iov_base + 24, assoc_data_len);
-	for (i = 0; i < nvec - 1; i++) {
-		void *data = iov[i + 1].iov_base;
-		int len = iov[i + 1].iov_len;
-
-		if (is_vmalloc_addr(data)) {
-			int j, offset = offset_in_page(data);
-
-			for (j = 0; j < nr_entries[i]; j++) {
-				unsigned int bytes = PAGE_SIZE - offset;
-
-				if (!len)
-					break;
-
-				if (bytes > len)
-					bytes = len;
-
-				sg_set_page(&sg[sg_idx++],
-					    vmalloc_to_page(data), bytes,
-					    offset_in_page(data));
-
-				data += bytes;
-				len -= bytes;
-				offset = 0;
-			}
-		} else {
-			sg_set_page(&sg[sg_idx++], virt_to_page(data), len,
-				    offset_in_page(data));
-		}
-	}
-	smb2_sg_set_buf(&sg[sg_idx], sign, SMB2_SIGNATURE_SIZE);
-	kfree(nr_entries);
-	return sg;
-}
-
-int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
-			unsigned int nvec, int enc)
-{
-	struct ksmbd_conn *conn = work->conn;
-	struct smb2_transform_hdr *tr_hdr = smb_get_msg(iov[0].iov_base);
-	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
-	int rc;
-	DECLARE_CRYPTO_WAIT(wait);
-	struct scatterlist *sg;
-	u8 sign[SMB2_SIGNATURE_SIZE] = {};
-	u8 key[SMB3_ENC_DEC_KEY_SIZE];
-	struct aead_request *req;
-	char *iv;
-	unsigned int iv_len;
-	struct crypto_aead *tfm;
-	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
-	struct ksmbd_crypto_ctx *ctx;
-
-	rc = ksmbd_get_encryption_key(work,
-				      le64_to_cpu(tr_hdr->SessionId),
-				      enc,
-				      key);
-	if (rc) {
-		pr_err("Could not get %scryption key\n", enc ? "en" : "de");
-		return rc;
-	}
-
-	if (conn->cipher_type == SMB2_ENCRYPTION_AES128_GCM ||
-	    conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM)
-		ctx = ksmbd_crypto_ctx_find_gcm();
-	else
-		ctx = ksmbd_crypto_ctx_find_ccm();
-	if (!ctx) {
-		pr_err("crypto alloc failed\n");
-		return -ENOMEM;
-	}
-
-	if (conn->cipher_type == SMB2_ENCRYPTION_AES128_GCM ||
-	    conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM)
-		tfm = CRYPTO_GCM(ctx);
-	else
-		tfm = CRYPTO_CCM(ctx);
-
-	if (conn->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
-	    conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM)
-		rc = crypto_aead_setkey(tfm, key, SMB3_GCM256_CRYPTKEY_SIZE);
-	else
-		rc = crypto_aead_setkey(tfm, key, SMB3_GCM128_CRYPTKEY_SIZE);
-	if (rc) {
-		pr_err("Failed to set aead key %d\n", rc);
-		goto free_ctx;
-	}
-
-	rc = crypto_aead_setauthsize(tfm, SMB2_SIGNATURE_SIZE);
-	if (rc) {
-		pr_err("Failed to set authsize %d\n", rc);
-		goto free_ctx;
-	}
-
-	req = aead_request_alloc(tfm, KSMBD_DEFAULT_GFP);
-	if (!req) {
-		rc = -ENOMEM;
-		goto free_ctx;
-	}
-
-	if (!enc) {
-		memcpy(sign, &tr_hdr->Signature, SMB2_SIGNATURE_SIZE);
-		crypt_len += SMB2_SIGNATURE_SIZE;
-	}
-
-	sg = ksmbd_init_sg(iov, nvec, sign);
-	if (!sg) {
-		pr_err("Failed to init sg\n");
-		rc = -ENOMEM;
-		goto free_req;
-	}
-
-	iv_len = crypto_aead_ivsize(tfm);
-	iv = kzalloc(iv_len, KSMBD_DEFAULT_GFP);
-	if (!iv) {
-		rc = -ENOMEM;
-		goto free_sg;
-	}
-
-	if (conn->cipher_type == SMB2_ENCRYPTION_AES128_GCM ||
-	    conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM) {
-		memcpy(iv, (char *)tr_hdr->Nonce, SMB3_AES_GCM_NONCE);
-	} else {
-		iv[0] = 3;
-		memcpy(iv + 1, (char *)tr_hdr->Nonce, SMB3_AES_CCM_NONCE);
-	}
-
-	aead_request_set_crypt(req, sg, sg, crypt_len, iv);
-	aead_request_set_ad(req, assoc_data_len);
-	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
-				  CRYPTO_TFM_REQ_MAY_SLEEP,
-				  crypto_req_done, &wait);
-
-	rc = crypto_wait_req(enc ? crypto_aead_encrypt(req) :
-			     crypto_aead_decrypt(req), &wait);
-	if (rc)
-		goto free_iv;
-
-	if (enc)
-		memcpy(&tr_hdr->Signature, sign, SMB2_SIGNATURE_SIZE);
-
-free_iv:
-	kfree(iv);
-free_sg:
-	kfree(sg);
-free_req:
-	aead_request_free(req);
-free_ctx:
-	ksmbd_release_crypto_ctx(ctx);
-	return rc;
-}
diff --git a/fs/smb/server/auth.h b/fs/smb/server/auth.h
index 5767aabc63c9..f438167e9cc2 100644
--- a/fs/smb/server/auth.h
+++ b/fs/smb/server/auth.h
@@ -36,8 +36,6 @@ struct ksmbd_conn;
 struct ksmbd_work;
 struct kvec;
 
-int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
-			unsigned int nvec, int enc);
 void ksmbd_copy_gss_neg_header(void *buf);
 int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 		      struct ntlmv2_resp *ntlmv2, int blen, char *domain_name,
diff --git a/fs/smb/server/crypto_ctx.c b/fs/smb/server/crypto_ctx.c
deleted file mode 100644
index 2fe7d3300480..000000000000
--- a/fs/smb/server/crypto_ctx.c
+++ /dev/null
@@ -1,176 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- *   Copyright (C) 2019 Samsung Electronics Co., Ltd.
- */
-
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/err.h>
-#include <linux/slab.h>
-#include <linux/wait.h>
-#include <linux/sched.h>
-
-#include "glob.h"
-#include "crypto_ctx.h"
-
-struct crypto_ctx_list {
-	spinlock_t		ctx_lock;
-	int			avail_ctx;
-	struct list_head	idle_ctx;
-	wait_queue_head_t	ctx_wait;
-};
-
-static struct crypto_ctx_list ctx_list;
-
-static inline void free_aead(struct crypto_aead *aead)
-{
-	if (aead)
-		crypto_free_aead(aead);
-}
-
-static struct crypto_aead *alloc_aead(int id)
-{
-	struct crypto_aead *tfm = NULL;
-
-	switch (id) {
-	case CRYPTO_AEAD_AES_GCM:
-		tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
-		break;
-	case CRYPTO_AEAD_AES_CCM:
-		tfm = crypto_alloc_aead("ccm(aes)", 0, 0);
-		break;
-	default:
-		pr_err("Does not support encrypt ahead(id : %d)\n", id);
-		return NULL;
-	}
-
-	if (IS_ERR(tfm)) {
-		pr_err("Failed to alloc encrypt aead : %ld\n", PTR_ERR(tfm));
-		return NULL;
-	}
-
-	return tfm;
-}
-
-static void ctx_free(struct ksmbd_crypto_ctx *ctx)
-{
-	int i;
-
-	for (i = 0; i < CRYPTO_AEAD_MAX; i++)
-		free_aead(ctx->ccmaes[i]);
-	kfree(ctx);
-}
-
-static struct ksmbd_crypto_ctx *ksmbd_find_crypto_ctx(void)
-{
-	struct ksmbd_crypto_ctx *ctx;
-
-	while (1) {
-		spin_lock(&ctx_list.ctx_lock);
-		if (!list_empty(&ctx_list.idle_ctx)) {
-			ctx = list_entry(ctx_list.idle_ctx.next,
-					 struct ksmbd_crypto_ctx,
-					 list);
-			list_del(&ctx->list);
-			spin_unlock(&ctx_list.ctx_lock);
-			return ctx;
-		}
-
-		if (ctx_list.avail_ctx > num_online_cpus()) {
-			spin_unlock(&ctx_list.ctx_lock);
-			wait_event(ctx_list.ctx_wait,
-				   !list_empty(&ctx_list.idle_ctx));
-			continue;
-		}
-
-		ctx_list.avail_ctx++;
-		spin_unlock(&ctx_list.ctx_lock);
-
-		ctx = kzalloc_obj(struct ksmbd_crypto_ctx, KSMBD_DEFAULT_GFP);
-		if (!ctx) {
-			spin_lock(&ctx_list.ctx_lock);
-			ctx_list.avail_ctx--;
-			spin_unlock(&ctx_list.ctx_lock);
-			wait_event(ctx_list.ctx_wait,
-				   !list_empty(&ctx_list.idle_ctx));
-			continue;
-		}
-		break;
-	}
-	return ctx;
-}
-
-void ksmbd_release_crypto_ctx(struct ksmbd_crypto_ctx *ctx)
-{
-	if (!ctx)
-		return;
-
-	spin_lock(&ctx_list.ctx_lock);
-	if (ctx_list.avail_ctx <= num_online_cpus()) {
-		list_add(&ctx->list, &ctx_list.idle_ctx);
-		spin_unlock(&ctx_list.ctx_lock);
-		wake_up(&ctx_list.ctx_wait);
-		return;
-	}
-
-	ctx_list.avail_ctx--;
-	spin_unlock(&ctx_list.ctx_lock);
-	ctx_free(ctx);
-}
-
-static struct ksmbd_crypto_ctx *____crypto_aead_ctx_find(int id)
-{
-	struct ksmbd_crypto_ctx *ctx;
-
-	if (id >= CRYPTO_AEAD_MAX)
-		return NULL;
-
-	ctx = ksmbd_find_crypto_ctx();
-	if (ctx->ccmaes[id])
-		return ctx;
-
-	ctx->ccmaes[id] = alloc_aead(id);
-	if (ctx->ccmaes[id])
-		return ctx;
-	ksmbd_release_crypto_ctx(ctx);
-	return NULL;
-}
-
-struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_gcm(void)
-{
-	return ____crypto_aead_ctx_find(CRYPTO_AEAD_AES_GCM);
-}
-
-struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_ccm(void)
-{
-	return ____crypto_aead_ctx_find(CRYPTO_AEAD_AES_CCM);
-}
-
-void ksmbd_crypto_destroy(void)
-{
-	struct ksmbd_crypto_ctx *ctx;
-
-	while (!list_empty(&ctx_list.idle_ctx)) {
-		ctx = list_entry(ctx_list.idle_ctx.next,
-				 struct ksmbd_crypto_ctx,
-				 list);
-		list_del(&ctx->list);
-		ctx_free(ctx);
-	}
-}
-
-int ksmbd_crypto_create(void)
-{
-	struct ksmbd_crypto_ctx *ctx;
-
-	spin_lock_init(&ctx_list.ctx_lock);
-	INIT_LIST_HEAD(&ctx_list.idle_ctx);
-	init_waitqueue_head(&ctx_list.ctx_wait);
-	ctx_list.avail_ctx = 1;
-
-	ctx = kzalloc_obj(struct ksmbd_crypto_ctx, KSMBD_DEFAULT_GFP);
-	if (!ctx)
-		return -ENOMEM;
-	list_add(&ctx->list, &ctx_list.idle_ctx);
-	return 0;
-}
diff --git a/fs/smb/server/crypto_ctx.h b/fs/smb/server/crypto_ctx.h
deleted file mode 100644
index b22c6e086f03..000000000000
--- a/fs/smb/server/crypto_ctx.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- *   Copyright (C) 2019 Samsung Electronics Co., Ltd.
- */
-
-#ifndef __CRYPTO_CTX_H__
-#define __CRYPTO_CTX_H__
-
-#include <crypto/aead.h>
-
-enum {
-	CRYPTO_AEAD_AES_GCM = 16,
-	CRYPTO_AEAD_AES_CCM,
-	CRYPTO_AEAD_MAX,
-};
-
-struct ksmbd_crypto_ctx {
-	struct list_head		list;
-
-	struct crypto_aead		*ccmaes[CRYPTO_AEAD_MAX];
-};
-
-#define CRYPTO_GCM(c)		((c)->ccmaes[CRYPTO_AEAD_AES_GCM])
-#define CRYPTO_CCM(c)		((c)->ccmaes[CRYPTO_AEAD_AES_CCM])
-
-void ksmbd_release_crypto_ctx(struct ksmbd_crypto_ctx *ctx);
-struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_gcm(void);
-struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_ccm(void);
-void ksmbd_crypto_destroy(void);
-int ksmbd_crypto_create(void);
-
-#endif /* __CRYPTO_CTX_H__ */
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 36a5ea4828ad..dece42e58d66 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -19,7 +19,6 @@
 #include "connection.h"
 #include "transport_ipc.h"
 #include "mgmt/user_session.h"
-#include "crypto_ctx.h"
 #include "auth.h"
 #include "stats.h"
 #include "compress.h"
@@ -564,7 +563,6 @@ static int ksmbd_server_shutdown(void)
 	ksmbd_workqueue_destroy();
 	ksmbd_ipc_release();
 	ksmbd_conn_transport_destroy();
-	ksmbd_crypto_destroy();
 	ksmbd_free_global_file_table();
 	destroy_lease_table(NULL);
 	ksmbd_work_pool_destroy();
@@ -612,13 +610,9 @@ static int __init ksmbd_server_init(void)
 	if (ret)
 		goto err_destroy_file_table;
 
-	ret = ksmbd_crypto_create();
-	if (ret)
-		goto err_release_inode_hash;
-
 	ret = ksmbd_workqueue_init();
 	if (ret)
-		goto err_crypto_destroy;
+		goto err_release_inode_hash;
 
 	ret = ksmbd_conn_wq_init();
 	if (ret)
@@ -628,8 +622,6 @@ static int __init ksmbd_server_init(void)
 
 err_workqueue_destroy:
 	ksmbd_workqueue_destroy();
-err_crypto_destroy:
-	ksmbd_crypto_destroy();
 err_release_inode_hash:
 	ksmbd_release_inode_hash();
 err_destroy_file_table:
@@ -666,9 +658,5 @@ MODULE_AUTHOR("Namjae Jeon <linkinjeon@kernel.org>");
 MODULE_DESCRIPTION("Linux kernel CIFS/SMB SERVER");
 MODULE_LICENSE("GPL");
 MODULE_SOFTDEP("pre: nls");
-MODULE_SOFTDEP("pre: aes");
-MODULE_SOFTDEP("pre: aead2");
-MODULE_SOFTDEP("pre: ccm");
-MODULE_SOFTDEP("pre: gcm");
 module_init(ksmbd_server_init)
 module_exit(ksmbd_server_exit)
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 097f51fc7ed6..6668d63157c7 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4,6 +4,8 @@
  *   Copyright (C) 2018 Samsung Electronics Co., Ltd.
  */
 
+#include <crypto/aes-ccm.h>
+#include <crypto/aes-gcm.h>
 #include <crypto/utils.h>
 #include <linux/inetdevice.h>
 #include <net/addrconf.h>
@@ -9731,9 +9733,28 @@ static void fill_transform_hdr(void *tr_buf, char *old_buf, __le16 cipher_type)
 
 int smb3_encrypt_resp(struct ksmbd_work *work)
 {
+	struct ksmbd_session *sess = work->sess;
+	__le16 cipher_type = work->conn->cipher_type;
 	struct kvec *iov = work->iov;
+	unsigned int nvec = work->iov_idx + 1;
 	int rc = -ENOMEM;
 	void *tr_buf;
+	struct smb2_transform_hdr *tr_hdr;
+	union {
+		struct {
+			struct aes_gcm_key key;
+			struct aes_gcm_ctx ctx;
+		} gcm;
+		struct {
+			struct aes_ccm_key key;
+			struct aes_ccm_ctx ctx;
+		} ccm;
+	} u;
+	u8 *assoc_data;
+	size_t orig_size, assoc_data_size;
+
+	if (!sess)
+		return -EINVAL;
 
 	tr_buf = kzalloc(sizeof(struct smb2_transform_hdr) + 4, KSMBD_DEFAULT_GFP);
 	if (!tr_buf)
@@ -9742,11 +9763,60 @@ int smb3_encrypt_resp(struct ksmbd_work *work)
 	/* fill transform header */
 	fill_transform_hdr(tr_buf, work->response_buf, work->conn->cipher_type);
 
+	work->tr_buf = tr_buf;
+
+	tr_hdr = smb_get_msg(tr_buf);
+	orig_size = le32_to_cpu(tr_hdr->OriginalMessageSize);
+	assoc_data = tr_buf + 24;
+	assoc_data_size = sizeof(struct smb2_transform_hdr) - 20;
+
 	iov[0].iov_base = tr_buf;
 	iov[0].iov_len = sizeof(struct smb2_transform_hdr) + 4;
-	work->tr_buf = tr_buf;
 
-	return ksmbd_crypt_message(work, iov, work->iov_idx + 1, 1);
+	if (cipher_type == SMB2_ENCRYPTION_AES128_GCM ||
+	    cipher_type == SMB2_ENCRYPTION_AES256_GCM) {
+		size_t key_size = (cipher_type == SMB2_ENCRYPTION_AES128_GCM) ?
+					  AES_KEYSIZE_128 :
+					  AES_KEYSIZE_256;
+
+		rc = aes_gcm_preparekey(&u.gcm.key, sess->smb3encryptionkey,
+					key_size, SMB2_SIGNATURE_SIZE);
+		if (rc)
+			goto out;
+		aes_gcm_init(&u.gcm.ctx, tr_hdr->Nonce, &u.gcm.key);
+		aes_gcm_auth_update(&u.gcm.ctx, assoc_data, assoc_data_size);
+		for (unsigned int i = 1; i < nvec; i++)
+			aes_gcm_encrypt_update(&u.gcm.ctx, iov[i].iov_base,
+					       iov[i].iov_base, iov[i].iov_len);
+		aes_gcm_encrypt_final(&u.gcm.ctx, tr_hdr->Signature);
+		rc = 0;
+	} else if (cipher_type == SMB2_ENCRYPTION_AES128_CCM ||
+		   cipher_type == SMB2_ENCRYPTION_AES256_CCM) {
+		size_t key_size = (cipher_type == SMB2_ENCRYPTION_AES128_CCM) ?
+					  AES_KEYSIZE_128 :
+					  AES_KEYSIZE_256;
+
+		rc = aes_ccm_preparekey(&u.ccm.key, sess->smb3encryptionkey,
+					key_size, SMB2_SIGNATURE_SIZE);
+		if (rc)
+			goto out;
+		rc = aes_ccm_init(&u.ccm.ctx, tr_hdr->Nonce, SMB3_AES_CCM_NONCE,
+				  assoc_data_size, orig_size, &u.ccm.key);
+		if (rc)
+			goto out;
+		aes_ccm_auth_update(&u.ccm.ctx, assoc_data, assoc_data_size);
+		for (unsigned int i = 1; i < nvec; i++)
+			aes_ccm_encrypt_update(&u.ccm.ctx, iov[i].iov_base,
+					       iov[i].iov_base, iov[i].iov_len);
+		aes_ccm_encrypt_final(&u.ccm.ctx, tr_hdr->Signature);
+		rc = 0;
+	} else {
+		WARN_ON_ONCE(1);
+		rc = -EOPNOTSUPP;
+	}
+out:
+	memzero_explicit(&u, sizeof(u));
+	return rc;
 }
 
 bool smb3_is_transform_hdr(void *buf)
@@ -9759,11 +9829,17 @@ bool smb3_is_transform_hdr(void *buf)
 int smb3_decrypt_req(struct ksmbd_work *work)
 {
 	struct ksmbd_session *sess;
+	__le16 cipher_type = work->conn->cipher_type;
 	char *buf = work->request_buf;
 	unsigned int pdu_length = get_rfc1002_len(buf);
-	struct kvec iov[2];
 	int buf_data_size = pdu_length - sizeof(struct smb2_transform_hdr);
 	struct smb2_transform_hdr *tr_hdr = smb_get_msg(buf);
+	union {
+		struct aes_gcm_key gcm;
+		struct aes_ccm_key ccm;
+	} key;
+	u8 *data, *assoc_data;
+	size_t orig_size, assoc_data_size;
 	int rc = 0;
 
 	if (pdu_length < sizeof(struct smb2_transform_hdr) ||
@@ -9773,10 +9849,14 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 		return -ECONNABORTED;
 	}
 
-	if (buf_data_size < le32_to_cpu(tr_hdr->OriginalMessageSize)) {
+	orig_size = le32_to_cpu(tr_hdr->OriginalMessageSize);
+	if (buf_data_size < orig_size) {
 		pr_err("Transform message is broken\n");
 		return -ECONNABORTED;
 	}
+	data = buf + sizeof(struct smb2_transform_hdr) + 4;
+	assoc_data = buf + 24;
+	assoc_data_size = sizeof(struct smb2_transform_hdr) - 20;
 
 	sess = ksmbd_session_lookup_all(work->conn, le64_to_cpu(tr_hdr->SessionId));
 	if (!sess) {
@@ -9784,19 +9864,46 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 		       le64_to_cpu(tr_hdr->SessionId));
 		return -ECONNABORTED;
 	}
-	ksmbd_user_session_put(sess);
 
-	iov[0].iov_base = buf;
-	iov[0].iov_len = sizeof(struct smb2_transform_hdr) + 4;
-	iov[1].iov_base = buf + sizeof(struct smb2_transform_hdr) + 4;
-	iov[1].iov_len = buf_data_size;
-	rc = ksmbd_crypt_message(work, iov, 2, 0);
+	if (cipher_type == SMB2_ENCRYPTION_AES128_GCM ||
+	    cipher_type == SMB2_ENCRYPTION_AES256_GCM) {
+		size_t key_size = (cipher_type == SMB2_ENCRYPTION_AES128_GCM) ?
+					  AES_KEYSIZE_128 :
+					  AES_KEYSIZE_256;
+
+		rc = aes_gcm_preparekey(&key.gcm, sess->smb3decryptionkey,
+					key_size, SMB2_SIGNATURE_SIZE);
+		if (rc)
+			goto put_session;
+		rc = aes_gcm_decrypt(data, data, tr_hdr->Signature, orig_size,
+				     assoc_data, assoc_data_size, tr_hdr->Nonce,
+				     &key.gcm);
+	} else if (cipher_type == SMB2_ENCRYPTION_AES128_CCM ||
+		   cipher_type == SMB2_ENCRYPTION_AES256_CCM) {
+		size_t key_size = (cipher_type == SMB2_ENCRYPTION_AES128_CCM) ?
+					  AES_KEYSIZE_128 :
+					  AES_KEYSIZE_256;
+
+		rc = aes_ccm_preparekey(&key.ccm, sess->smb3decryptionkey,
+					key_size, SMB2_SIGNATURE_SIZE);
+		if (rc)
+			goto put_session;
+		rc = aes_ccm_decrypt(data, data, tr_hdr->Signature, orig_size,
+				     assoc_data, assoc_data_size, tr_hdr->Nonce,
+				     SMB3_AES_CCM_NONCE, &key.ccm);
+	} else {
+		WARN_ON_ONCE(1);
+		rc = -EOPNOTSUPP;
+	}
+put_session:
+	ksmbd_user_session_put(sess);
 	if (rc)
-		return rc;
+		goto out;
 
-	memmove(buf + 4, iov[1].iov_base, buf_data_size);
+	memmove(buf + 4, data, buf_data_size);
 	*(__be32 *)buf = cpu_to_be32(buf_data_size);
-
+out:
+	memzero_explicit(&key, sizeof(key));
 	return rc;
 }
 
-- 
2.54.0

