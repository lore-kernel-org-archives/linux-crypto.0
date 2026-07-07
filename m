Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01C2387374;
	Tue,  7 Jul 2026 05:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402644; cv=none; b=AoQMYNmFI/tmdkJ6gVG7So1M0oIjL+aiSQ8igcN/F3OUrarMiSCczhxJ+fHeqyagAvIQLYZDtddmNvHMwV90xNhASnrnEn8GxyG+FXXZGkIxJsMGHU1D5iMi53Htjlik9LzHRBgSGhimSraqI2+vyZHhpiW6YN24sa5ujmIFw4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402644; c=relaxed/simple;
	bh=gIvow1kNjUgx+7Alwmp6JXsJwe2CGRssXMhnO8CPY2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AiZV3kRULSaEsbeYryLW2lNuelp+P5lFUCRXVr0X1qUr4cz5okE5Cg8hxJ4K/xmf/XcbVWBhqkAhEECgUHUo26CkjbJGSC2zx/HJvbccL9HctIOq1DwPc/HijJY8qYP+dEqgOh7joCnMiRjXzj6eFNEQVesWn+R2rgYyFzFptjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PtXVMpI/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PtXVMpI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD541F00A3E;
	Tue,  7 Jul 2026 05:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402641;
	bh=X5vHrn7bKTqvNsJPYPSM5LCbI2NmT7uhHtgspE6rsp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PtXVMpI/V0g2zp7SEOmxCmmPBZO/WV+5GvT2UiJ1AxhX1kiFMScQmPiXkWuPRQ1MS
	 JP5JUYzpag6lO9wI+J7VG/ETbf+Azt2hsSL7Kjey9mAutHB93wcCFizLu83lR3ogml
	 7VjMFz6iTldIL6Ssp5MqmIcBBKnaoB440nxc4NyCSietFHLQskRJ0Rh7GncMwwAZXL
	 8zuyCjCDTS3tHILhwLYaDJccX11XnjV3hGC9Gg9q1fvoWBOpqGTu3k8KS9mIwqgt5A
	 3gP2ZEzeroKsz38PFT1J/zepVJs7DAdosvQdomlw5olgc7rFVq9K0PYYVuwFseY3jL
	 Ojm06gxWNMwqg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 21/33] libceph: Use AES-CBC library in ceph_aes_crypt()
Date: Mon,  6 Jul 2026 22:34:51 -0700
Message-ID: <20260707053503.209874-22-ebiggers@kernel.org>
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

Now that there's a library API for AES-CBC, use it instead of a
"cbc(aes)" crypto_skcipher.  This significantly simplifies the code.

Notably, the new ceph_aes_crypt() just operates on the actual buffer
directly.  It no longer needs to be converted into a scatterlist.

This conversion also eliminates the broken code that intended to
allocate crypto_skcipher objects from a GFP_NOIO context.  That isn't
actually supported: crypto_alloc_skcipher() takes crypto_alg_sem which
isn't GFP_NOIO safe, and it can also load kernel modules.

Note that ceph_aes_crypt() verifies only a single padding byte rather
than all of them.  That's probably a bug.  But I've left it unchanged,
as fixing it is outside the scope of this commit.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/ceph/Kconfig  |  3 +--
 net/ceph/crypto.c | 66 ++++++++++-------------------------------------
 net/ceph/crypto.h |  3 ++-
 3 files changed, 16 insertions(+), 56 deletions(-)

diff --git a/net/ceph/Kconfig b/net/ceph/Kconfig
index 7e2528cde4b9..74aa2817253b 100644
--- a/net/ceph/Kconfig
+++ b/net/ceph/Kconfig
@@ -3,10 +3,9 @@ config CEPH_LIB
 	tristate "Ceph core library"
 	depends on INET
 	select CRC32
-	select CRYPTO_AES
-	select CRYPTO_CBC
 	select CRYPTO_GCM
 	select CRYPTO_KRB5
+	select CRYPTO_LIB_AES_CBC
 	select CRYPTO_LIB_SHA256
 	select CRYPTO
 	select KEYS
diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index de7496791c91..83bbef71bfaf 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -6,9 +6,8 @@
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <crypto/aes.h>
+#include <crypto/aes-cbc.h>
 #include <crypto/krb5.h>
-#include <crypto/skcipher.h>
 #include <linux/key-type.h>
 #include <linux/sched/mm.h>
 
@@ -17,27 +16,6 @@
 #include <linux/ceph/decode.h>
 #include "crypto.h"
 
-static int set_aes_tfm(struct ceph_crypto_key *key)
-{
-	unsigned int noio_flag;
-	int ret;
-
-	noio_flag = memalloc_noio_save();
-	key->aes_tfm = crypto_alloc_sync_skcipher("cbc(aes)", 0, 0);
-	memalloc_noio_restore(noio_flag);
-	if (IS_ERR(key->aes_tfm)) {
-		ret = PTR_ERR(key->aes_tfm);
-		key->aes_tfm = NULL;
-		return ret;
-	}
-
-	ret = crypto_sync_skcipher_setkey(key->aes_tfm, key->key, key->len);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
 static int set_krb5_tfms(struct ceph_crypto_key *key, const u32 *key_usages,
 			 int key_usage_cnt)
 {
@@ -82,7 +60,7 @@ int ceph_crypto_key_prepare(struct ceph_crypto_key *key,
 	case CEPH_CRYPTO_NONE:
 		return 0; /* nothing to do */
 	case CEPH_CRYPTO_AES:
-		return set_aes_tfm(key);
+		return aes_preparekey(&key->aes_key, key->key, key->len);
 	case CEPH_CRYPTO_AES256KRB5:
 		hmac_sha256_preparekey(&key->hmac_key, key->key, key->len);
 		return set_krb5_tfms(key, key_usages, key_usage_cnt);
@@ -174,10 +152,7 @@ void ceph_crypto_key_destroy(struct ceph_crypto_key *key)
 	key->key = NULL;
 
 	if (key->type == CEPH_CRYPTO_AES) {
-		if (key->aes_tfm) {
-			crypto_free_sync_skcipher(key->aes_tfm);
-			key->aes_tfm = NULL;
-		}
+		memzero_explicit(&key->aes_key, sizeof(key->aes_key));
 	} else if (key->type == CEPH_CRYPTO_AES256KRB5) {
 		memzero_explicit(&key->hmac_key, sizeof(key->hmac_key));
 		for (i = 0; i < ARRAY_SIZE(key->krb5_tfms); i++) {
@@ -264,26 +239,20 @@ static void teardown_sgtable(struct sg_table *sgt)
 static int ceph_aes_crypt(const struct ceph_crypto_key *key, bool encrypt,
 			  void *buf, int buf_len, int in_len, int *pout_len)
 {
-	SYNC_SKCIPHER_REQUEST_ON_STACK(req, key->aes_tfm);
-	struct sg_table sgt;
-	struct scatterlist prealloc_sg;
 	char iv[AES_BLOCK_SIZE] __aligned(8);
 	int pad_byte = AES_BLOCK_SIZE - (in_len & (AES_BLOCK_SIZE - 1));
 	int crypt_len = encrypt ? in_len + pad_byte : in_len;
-	int ret;
 
 	WARN_ON(crypt_len > buf_len);
+	if (crypt_len <= 0 || crypt_len % AES_BLOCK_SIZE != 0) {
+		pr_err("%s: got bad crypt_len %d for %scrypt\n", __func__,
+		       crypt_len, encrypt ? "en" : "de");
+		return -EINVAL;
+	}
 	if (encrypt)
 		memset(buf + in_len, pad_byte, pad_byte);
-	ret = setup_sgtable(&sgt, &prealloc_sg, buf, crypt_len);
-	if (ret)
-		return ret;
 
 	memcpy(iv, aes_iv, AES_BLOCK_SIZE);
-	skcipher_request_set_sync_tfm(req, key->aes_tfm);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, sgt.sgl, sgt.sgl, crypt_len, iv);
-
 	/*
 	print_hex_dump(KERN_ERR, "key: ", DUMP_PREFIX_NONE, 16, 1,
 		       key->key, key->len, 1);
@@ -291,15 +260,10 @@ static int ceph_aes_crypt(const struct ceph_crypto_key *key, bool encrypt,
 		       buf, crypt_len, 1);
 	*/
 	if (encrypt)
-		ret = crypto_skcipher_encrypt(req);
+		aes_cbc_encrypt(buf, buf, crypt_len, iv, &key->aes_key);
 	else
-		ret = crypto_skcipher_decrypt(req);
-	skcipher_request_zero(req);
-	if (ret) {
-		pr_err("%s %scrypt failed: %d\n", __func__,
-		       encrypt ? "en" : "de", ret);
-		goto out_sgt;
-	}
+		aes_cbc_decrypt(buf, buf, crypt_len, iv, &key->aes_key);
+
 	/*
 	print_hex_dump(KERN_ERR, "out: ", DUMP_PREFIX_NONE, 16, 1,
 		       buf, crypt_len, 1);
@@ -315,14 +279,10 @@ static int ceph_aes_crypt(const struct ceph_crypto_key *key, bool encrypt,
 		} else {
 			pr_err("%s got bad padding %d on in_len %d\n",
 			       __func__, pad_byte, in_len);
-			ret = -EPERM;
-			goto out_sgt;
+			return -EPERM;
 		}
 	}
-
-out_sgt:
-	teardown_sgtable(&sgt);
-	return ret;
+	return 0;
 }
 
 static int ceph_krb5_encrypt(const struct ceph_crypto_key *key, int usage_slot,
diff --git a/net/ceph/crypto.h b/net/ceph/crypto.h
index 3a2ade15abbc..d4d97565ebfb 100644
--- a/net/ceph/crypto.h
+++ b/net/ceph/crypto.h
@@ -2,6 +2,7 @@
 #ifndef _FS_CEPH_CRYPTO_H
 #define _FS_CEPH_CRYPTO_H
 
+#include <crypto/aes.h>
 #include <crypto/sha2.h>
 #include <linux/ceph/types.h>
 #include <linux/ceph/buffer.h>
@@ -19,7 +20,7 @@ struct ceph_crypto_key {
 	void *key;
 
 	union {
-		struct crypto_sync_skcipher *aes_tfm;
+		struct aes_key aes_key;
 		struct {
 			struct hmac_sha256_key hmac_key;
 			const struct krb5_enctype *krb5_type;
-- 
2.54.0

