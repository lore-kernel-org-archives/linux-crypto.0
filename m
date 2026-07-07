Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB493876BB;
	Tue,  7 Jul 2026 05:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402647; cv=none; b=ID5Yb53lmoLTFwltuaQvDQegipGKYM/E4UiUs+lAUWVIkYnZAktAzIvbCdWJJiXrQxV2PfvAWzTOPALNRJomixa5GacOFGKnaHhtB104VorJTOv58q8mMAQsHOoSWva7uLNaeRaXKIlqQAcPSanOVV1wHciac3yfD8/70bnLn/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402647; c=relaxed/simple;
	bh=fmr7jgQXLig8paBqa79c4lk0hv37KjSzHLZdN+Dh48I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDRgMfBPK5HSAV4V/rNg2pLYftG66K1kxJ5dhZJrJuiqgrm8YgF9kdrfFhJSFvFRExMIIqh9OnzGoDm/Pz1mGw4Qyx/3O3fwHqUUCRrjhp7royxRzFR6TuS0A62oPCFwvHIo9K9pjVYEvGwu/kHI9HY058xjhk4N4eMmWnzPaaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kl8w0jX3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kl8w0jX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3EC1F01558;
	Tue,  7 Jul 2026 05:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402644;
	bh=r8rghw4jRM5UuUV1cGHIhAmdtHR/krfgJFBKYD/8epY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kl8w0jX3AbgDipbMiJjlDh1Rcp30aatKVs0xtrSh2Ig7EH6d79wSwC46REnBlb8ro
	 qnlg6kYbMMWaMbJHsCx93a/TKAciivqkUfiN66fOsOhUrvewqFwCT90YL/tD5DQYf7
	 4mvqppxZvMOve9oKgEvl9M07AZlnw2PDqYGpsHCBQBBJY+1jytxT/oNK43g/HVMiiy
	 JSXjgZMfbeyZZQ8MkM8zGzJGRuThoPYRv402F4X01deypegFLl1MdpcpF53SHyspJ/
	 Qk7QQcclBvDF4Vr9n9u8446hbXD8KeDBviFI/YwLmPz4ZH474HQXvTH1UsJA1NGyPR
	 4z3RhSgDOJqcw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 30/33] bpf: crypto: Add AES-GCM support
Date: Mon,  6 Jul 2026 22:35:00 -0700
Message-ID: <20260707053503.209874-31-ebiggers@kernel.org>
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

Add AES-GCM support as requested at
https://lore.kernel.org/r/CAHAB8Wy1APeCcm7_OfrNYeZFcMXfZ5rUSeDX7-c7WO_rGg2Zig@mail.gmail.com/

With the library this is straightforward to do.

The associated data is assumed to be empty.  If control over that is
needed, support would need to be added for it as well.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 kernel/bpf/Kconfig  |  2 ++
 kernel/bpf/crypto.c | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
index c4f1086b2daf..d14dd1788bd4 100644
--- a/kernel/bpf/Kconfig
+++ b/kernel/bpf/Kconfig
@@ -92,12 +92,14 @@ config BPF_CRYPTO
 	depends on BPF_SYSCALL
 	select CRYPTO_LIB_AES_CBC
 	select CRYPTO_LIB_AES_ECB
+	select CRYPTO_LIB_AES_GCM
 	help
 	  Provide the kfuncs needed for BPF programs to encrypt and decrypt
 	  data. The supported algorithms are:
 
 	    - AES-CBC
 	    - AES-ECB
+	    - AES-GCM
 
 source "kernel/bpf/preload/Kconfig"
 
diff --git a/kernel/bpf/crypto.c b/kernel/bpf/crypto.c
index 17e0d2fd422a..934d049ee91c 100644
--- a/kernel/bpf/crypto.c
+++ b/kernel/bpf/crypto.c
@@ -8,6 +8,7 @@
 #include <linux/skbuff.h>
 #include <crypto/aes-cbc.h>
 #include <crypto/aes-ecb.h>
+#include <crypto/aes-gcm.h>
 
 /* BPF crypto initialization parameters struct */
 /**
@@ -33,6 +34,7 @@ struct bpf_crypto_params {
 enum bpf_crypto_algo_id {
 	BPF_ALGO_AES_CBC,
 	BPF_ALGO_AES_ECB,
+	BPF_ALGO_AES_GCM,
 };
 
 static const struct {
@@ -42,6 +44,7 @@ static const struct {
 } bpf_crypto_algos[] = {
 	{ "skcipher", "cbc(aes)", BPF_ALGO_AES_CBC },
 	{ "skcipher", "ecb(aes)", BPF_ALGO_AES_ECB },
+	{ "aead", "gcm(aes)", BPF_ALGO_AES_GCM },
 };
 
 static bool bpf_crypto_find_algo(const struct bpf_crypto_params *params,
@@ -72,6 +75,7 @@ struct bpf_crypto_ctx {
 	enum bpf_crypto_algo_id algo;
 	union {
 		struct aes_key aes;
+		struct aes_gcm_key aes_gcm;
 	} key;
 	struct rcu_head rcu;
 	refcount_t usage;
@@ -127,6 +131,10 @@ bpf_crypto_ctx_create(const struct bpf_crypto_params *params, u32 params__sz,
 			*err = aes_preparekey(&ctx->key.aes, params->key,
 					      params->key_len);
 		break;
+	case BPF_ALGO_AES_GCM:
+		*err = aes_gcm_preparekey(&ctx->key.aes_gcm, params->key,
+					  params->key_len, params->authsize);
+		break;
 	default:
 		WARN_ON(1);
 		*err = -ENOENT;
@@ -217,6 +225,27 @@ static int bpf_aes_ecb_crypt(u8 *dst, u32 dst_len, const u8 *src, u32 src_len,
 	return 0;
 }
 
+static int bpf_aes_gcm_crypt(u8 *dst, u32 dst_len, const u8 *src, u32 src_len,
+			     u8 *iv, u32 iv_len,
+			     const struct bpf_crypto_ctx *ctx, bool decrypt)
+{
+	const struct aes_gcm_key *key = &ctx->key.aes_gcm;
+	u32 authtag_len = key->authtag_len;
+
+	if (iv_len != GCM_AES_IV_SIZE)
+		return -EINVAL;
+	if (decrypt) {
+		if (src_len < authtag_len || dst_len < src_len - authtag_len)
+			return -EINVAL;
+		return aes_gcm_decrypt(dst, src, src + src_len - authtag_len,
+				       src_len - authtag_len, NULL, 0, iv, key);
+	}
+	if (dst_len < authtag_len || dst_len - authtag_len < src_len)
+		return -EINVAL;
+	aes_gcm_encrypt(dst, dst + src_len, src, src_len, NULL, 0, iv, key);
+	return 0;
+}
+
 static int bpf_crypto_crypt(const struct bpf_crypto_ctx *ctx,
 			    const struct bpf_dynptr_kern *src,
 			    const struct bpf_dynptr_kern *dst,
@@ -254,6 +283,9 @@ static int bpf_crypto_crypt(const struct bpf_crypto_ctx *ctx,
 	case BPF_ALGO_AES_ECB:
 		return bpf_aes_ecb_crypt(pdst, dst_len, psrc, src_len, piv,
 					 iv_len, ctx, decrypt);
+	case BPF_ALGO_AES_GCM:
+		return bpf_aes_gcm_crypt(pdst, dst_len, psrc, src_len, piv,
+					 iv_len, ctx, decrypt);
 	default:
 		return -EINVAL;
 	}
-- 
2.54.0

