Received: from devnull.danielhodges.dev (vps-2f6e086e.vps.ovh.us [135.148.138.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C08328B77;
	Tue, 20 Jan 2026 18:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.148.138.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768934842; cv=none; b=RuC/U8WGjCy/J16QFNcyNpb5ZCk8fTC8blh7OHwPuuSTfya8Atu3Fhxi5cKySxTjJ9p+VpSyCJRN57dQTv3jM6qf5eD+eEc5yM9R5mF47oZL54X2WR9WOnmGJ4USCCjg5LtR+YqpNIuIxZh6e7E3BGDhVzT1l4GJDA+BoRITEVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768934842; c=relaxed/simple;
	bh=qCVuNNAjSm2ZryoOADn8nw2wzLohyxAWfpXZDz/Ghu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sweCWGp+DXLw9/Ka7ds/CQRamAO1VLbXAEUZmFViSscUw9KqnCWdnSua5aS5zAYK5qsfHpYTauOI9nCaXJX2DsojZDLeMRiPZjk5jO12UZ8Azl016FeZ0TX51JyzWdSnbvtWkfi0BG2u0sKJsl6qXq2uZr1jbASe36m5Bb6e6UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev; spf=pass smtp.mailfrom=danielhodges.dev; dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=R2rVd4f0; dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=lnYnsnre; arc=none smtp.client-ip=135.148.138.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="R2rVd4f0";
	dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="lnYnsnre"
DKIM-Signature: v=1; a=rsa-sha256; s=202510r; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1768934822; bh=oSDTKco5Z+cIUPHV2/IWFXX
	+zYklRUkeNigBk+7VzAY=; b=R2rVd4f0+h+siD3DjmILgTK7NnVBlb/aM/xsccQdPzZ+3Pl3Lt
	CoX1micfT5W2cVndN5m55Ve1+UjP3qg430aEEtEzO+UIoFc1rB2tuWhXKSpbUlCJ3PBRc8yUEAN
	1gbrmxkEzzsAOnGkefgyCTzL5RR5mP1cFRVOFVyBhfrGhXFunbJc9JLSkrMVb0GQlrFGUupR4lS
	Q4/yBTR3OtEkJSi+daZUktIiAPyGSJj2o3PbQ/oFoZWG+wB+nPhTyDcFQx80gnqqqJNYTGh/13b
	3QOZEvMQ6us4Gz/Lsw3dHvses2UgQH3hqv3qlECfHpFT6mjfdw0mVOe22R45lq2JcZg==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202510e; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1768934822; bh=oSDTKco5Z+cIUPHV2/IWFXX
	+zYklRUkeNigBk+7VzAY=; b=lnYnsnre7UItQ+bWyx/HJhq8dhq0uJusTVHxQqpb9wVuhxgB3A
	pv5euYf/G4+LoC1u/0NBlnqVVf+yltMZbkCg==;
From: Daniel Hodges <git@danielhodges.dev>
To: bpf@vger.kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Song Liu <song@kernel.org>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Yonghong Song <yonghong.song@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Daniel Hodges <git@danielhodges.dev>
Subject: [PATCH bpf-next v5 4/7] bpf: Add hash kfunc for cryptographic hashing
Date: Tue, 20 Jan 2026 13:46:58 -0500
Message-ID: <20260120184701.23082-5-git@danielhodges.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260120184701.23082-1-git@danielhodges.dev>
References: <20260120184701.23082-1-git@danielhodges.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend bpf_crypto_type structure with hash operations:
 - hash(): Performs hashing operation
 - digestsize(): Returns hash output size

Update bpf_crypto_ctx_create() to support keyless operations:
 - Hash algorithms don't require keys, unlike ciphers
 - Only validates key presence if type->setkey is defined
 - Conditionally sets IV/state length for cipher operations only

Add bpf_crypto_hash() kfunc that works with any hash algorithm
registered in the kernel's crypto API through the BPF crypto type
system. This enables BPF programs to compute cryptographic hashes for
use cases such as content verification, integrity checking, and data
authentication.

Signed-off-by: Daniel Hodges <git@danielhodges.dev>
---
 kernel/bpf/crypto.c | 87 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 78 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/crypto.c b/kernel/bpf/crypto.c
index 7e75a1936256..c8f354b1a2cb 100644
--- a/kernel/bpf/crypto.c
+++ b/kernel/bpf/crypto.c
@@ -139,7 +139,7 @@ __bpf_kfunc_start_defs();
  * It may return NULL if no memory is available.
  * @params:	pointer to struct bpf_crypto_params which contains all the
  *		details needed to initialise crypto context.
- * @params__sz:	size of steuct bpf_crypto_params usef by bpf program
+ * @params__sz:	size of struct bpf_crypto_params used by bpf program
  * @err:	integer to store error code when NULL is returned.
  */
 __bpf_kfunc struct bpf_crypto_ctx *
@@ -171,7 +171,12 @@ bpf_crypto_ctx_create(const struct bpf_crypto_params *params, u32 params__sz,
 		goto err_module_put;
 	}
 
-	if (!params->key_len || params->key_len > sizeof(params->key)) {
+	/* Hash operations don't require a key, but cipher operations do */
+	if (params->key_len > sizeof(params->key)) {
+		*err = -EINVAL;
+		goto err_module_put;
+	}
+	if (!params->key_len && type->setkey) {
 		*err = -EINVAL;
 		goto err_module_put;
 	}
@@ -195,16 +200,23 @@ bpf_crypto_ctx_create(const struct bpf_crypto_params *params, u32 params__sz,
 			goto err_free_tfm;
 	}
 
-	*err = type->setkey(ctx->tfm, params->key, params->key_len);
-	if (*err)
-		goto err_free_tfm;
+	if (params->key_len) {
+		if (!type->setkey) {
+			*err = -EINVAL;
+			goto err_free_tfm;
+		}
+		*err = type->setkey(ctx->tfm, params->key, params->key_len);
+		if (*err)
+			goto err_free_tfm;
 
-	if (type->get_flags(ctx->tfm) & CRYPTO_TFM_NEED_KEY) {
-		*err = -EINVAL;
-		goto err_free_tfm;
+		if (type->get_flags(ctx->tfm) & CRYPTO_TFM_NEED_KEY) {
+			*err = -EINVAL;
+			goto err_free_tfm;
+		}
 	}
 
-	ctx->siv_len = type->ivsize(ctx->tfm) + type->statesize(ctx->tfm);
+	if (type->ivsize && type->statesize)
+		ctx->siv_len = type->ivsize(ctx->tfm) + type->statesize(ctx->tfm);
 
 	refcount_set(&ctx->usage, 1);
 
@@ -349,6 +361,58 @@ __bpf_kfunc int bpf_crypto_encrypt(struct bpf_crypto_ctx *ctx,
 	return bpf_crypto_crypt(ctx, src_kern, dst_kern, siv_kern, false);
 }
 
+#if IS_ENABLED(CONFIG_CRYPTO_HASH2)
+/**
+ * bpf_crypto_hash() - Compute hash using configured context
+ * @ctx:	The crypto context being used. The ctx must be a trusted pointer.
+ * @data:	bpf_dynptr to the input data to hash. Must be a trusted pointer.
+ * @out:	bpf_dynptr to the output buffer. Must be a trusted pointer.
+ *
+ * Computes hash of the input data using the crypto context. The output buffer
+ * must be at least as large as the digest size of the hash algorithm.
+ */
+__bpf_kfunc int bpf_crypto_hash(struct bpf_crypto_ctx *ctx,
+				const struct bpf_dynptr *data,
+				const struct bpf_dynptr *out)
+{
+	const struct bpf_dynptr_kern *data_kern = (struct bpf_dynptr_kern *)data;
+	const struct bpf_dynptr_kern *out_kern = (struct bpf_dynptr_kern *)out;
+	unsigned int digestsize;
+	u64 data_len, out_len;
+	const u8 *data_ptr;
+	u8 *out_ptr;
+
+	if (ctx->type->type_id != BPF_CRYPTO_TYPE_HASH)
+		return -EINVAL;
+
+	if (!ctx->type->hash)
+		return -EOPNOTSUPP;
+
+	data_len = __bpf_dynptr_size(data_kern);
+	out_len = __bpf_dynptr_size(out_kern);
+
+	if (data_len == 0 || data_len > UINT_MAX)
+		return -EINVAL;
+
+	if (!ctx->type->digestsize)
+		return -EOPNOTSUPP;
+
+	digestsize = ctx->type->digestsize(ctx->tfm);
+	if (out_len < digestsize)
+		return -EINVAL;
+
+	data_ptr = __bpf_dynptr_data(data_kern, data_len);
+	if (!data_ptr)
+		return -EINVAL;
+
+	out_ptr = __bpf_dynptr_data_rw(out_kern, out_len);
+	if (!out_ptr)
+		return -EINVAL;
+
+	return ctx->type->hash(ctx->tfm, data_ptr, out_ptr, data_len);
+}
+#endif /* CONFIG_CRYPTO_HASH2 */
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(crypt_init_kfunc_btf_ids)
@@ -365,6 +429,9 @@ static const struct btf_kfunc_id_set crypt_init_kfunc_set = {
 BTF_KFUNCS_START(crypt_kfunc_btf_ids)
 BTF_ID_FLAGS(func, bpf_crypto_decrypt, KF_RCU)
 BTF_ID_FLAGS(func, bpf_crypto_encrypt, KF_RCU)
+#if IS_ENABLED(CONFIG_CRYPTO_HASH2)
+BTF_ID_FLAGS(func, bpf_crypto_hash, KF_RCU)
+#endif
 BTF_KFUNCS_END(crypt_kfunc_btf_ids)
 
 static const struct btf_kfunc_id_set crypt_kfunc_set = {
@@ -389,6 +456,8 @@ static int __init crypto_kfunc_init(void)
 	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &crypt_kfunc_set);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_ACT, &crypt_kfunc_set);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &crypt_kfunc_set);
+	/* Register for SYSCALL programs to enable testing and debugging */
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL, &crypt_kfunc_set);
 	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL,
 					       &crypt_init_kfunc_set);
 	return  ret ?: register_btf_id_dtor_kfuncs(bpf_crypto_dtors,
-- 
2.52.0

