Received: from devnull.danielhodges.dev (vps-2f6e086e.vps.ovh.us [135.148.138.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B2E466B5C;
	Tue, 20 Jan 2026 18:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.148.138.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768934864; cv=none; b=izzJu7bK7V3CZQ5tJimfPBlHMjpjCviwuOLXGuN6zDwuvBOgLUr0hO02IEx3yDpu+2OmjDShFcZkr117Jw+GtlGxf6oQZcW8esaMSQntNFVXvz5yEmnFn1hJO+sZZhN+93zUZznQsldE46EzN717YCZBL8p0xTvjic+ZxfXddqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768934864; c=relaxed/simple;
	bh=c9c112CfqOZIUtPBXyYub4SXP7/w2oeWMEWy4e/iG8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RT1puisbv0tvYJ1I0m1GVZSV3I/jwbwuIKADpuSunAun9exEPFN0y8Rz2QlAyaHKvCpn8TD6BRDhlEOJsN2ApZzsafkMLwQ+WM2BhzmRegSENamtQz/dp+9zC+WLbytPJU+oL7icqMC/+aHJdhw6VSyL5zQZ/Ju0l7IMKaAdkqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev; spf=pass smtp.mailfrom=danielhodges.dev; dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=iWc/fKVr; dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=UvdXDLmc; arc=none smtp.client-ip=135.148.138.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="iWc/fKVr";
	dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="UvdXDLmc"
DKIM-Signature: v=1; a=rsa-sha256; s=202510r; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1768934822; bh=x+cKrahUYB9zMrFLU4yGCt2
	1rJRa9TAmp18ETboD+hQ=; b=iWc/fKVr4sx0aosPo1yP5CuqSAkum91Cqebi5R6NmuIsDgWrhb
	NKW9RZGuxLh8SSj3bV9m6ZNFmMhfV7N0SwvOnoTwYkqIryFNMlij/T+2w7/5oqrh/4HpHaUG3LE
	WFfsq+DxqnruH1AkJg7VMe04Pl8k64q43+Fh/dGIlOB1D71j4XaHfZURxN+jNQ6vPEesgZYZKnn
	+N2VSAWxwpesR43/DjJPgMqDNcYLz7qO/vCWputzYiRCCPLyvwUGoIXEjQQwi7eKSGkMEclQI9x
	yT0O1NxF8mhxpaS2ePo8isvdR13rCf4JVxsXicjNPZWX5TTiu2kPwYek1/Etvash/Wg==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202510e; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1768934822; bh=x+cKrahUYB9zMrFLU4yGCt2
	1rJRa9TAmp18ETboD+hQ=; b=UvdXDLmcxDUPQj9khnXaNeEpuU/qpWiCXN8Dp3Q74qFreFiwyY
	r43aq1c9lJQvY9NrAZibnKzsATOuaU4peuAA==;
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
Subject: [PATCH bpf-next v5 2/7] crypto: Add BPF hash algorithm type registration module
Date: Tue, 20 Jan 2026 13:46:56 -0500
Message-ID: <20260120184701.23082-3-git@danielhodges.dev>
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

Add bpf_crypto_shash module that registers a hash type with the BPF
crypto infrastructure, enabling BPF programs to access kernel hash
algorithms through a unified interface.

Update the bpf_crypto_type interface with hash-specific callbacks:
   - alloc_tfm: Allocates crypto_shash context with proper descriptor size
   - free_tfm: Releases hash transform and context memory
   - has_algo: Checks algorithm availability via crypto_has_shash()
   - hash: Performs single-shot hashing via crypto_shash_digest()
   - digestsize: Returns the output size for the hash algorithm
   - get_flags: Exposes transform flags to BPF programs

Update bpf_shash_ctx to contain crypto_shash transform and shash_desc
descriptor to accommodate algorithm-specific descriptor requirements.

Signed-off-by: Daniel Hodges <git@danielhodges.dev>
---
 MAINTAINERS                |  1 +
 crypto/Makefile            |  3 ++
 crypto/bpf_crypto_shash.c  | 96 ++++++++++++++++++++++++++++++++++++++
 include/linux/bpf_crypto.h |  7 +++
 4 files changed, 107 insertions(+)
 create mode 100644 crypto/bpf_crypto_shash.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 491d567f7dc8..4e9b369acd1c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4713,6 +4713,7 @@ BPF [CRYPTO]
 M:	Vadim Fedorenko <vadim.fedorenko@linux.dev>
 L:	bpf@vger.kernel.org
 S:	Maintained
+F:	crypto/bpf_crypto_shash.c
 F:	crypto/bpf_crypto_skcipher.c
 F:	include/linux/bpf_crypto.h
 F:	kernel/bpf/crypto.c
diff --git a/crypto/Makefile b/crypto/Makefile
index 16a35649dd91..853dff375906 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -30,6 +30,9 @@ obj-$(CONFIG_CRYPTO_ECHAINIV) += echainiv.o
 crypto_hash-y += ahash.o
 crypto_hash-y += shash.o
 obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
+ifeq ($(CONFIG_BPF_SYSCALL),y)
+obj-$(CONFIG_CRYPTO_HASH2) += bpf_crypto_shash.o
+endif
 
 obj-$(CONFIG_CRYPTO_AKCIPHER2) += akcipher.o
 obj-$(CONFIG_CRYPTO_SIG2) += sig.o
diff --git a/crypto/bpf_crypto_shash.c b/crypto/bpf_crypto_shash.c
new file mode 100644
index 000000000000..6e9b0d757ec9
--- /dev/null
+++ b/crypto/bpf_crypto_shash.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/bpf_crypto.h>
+#include <crypto/hash.h>
+
+struct bpf_shash_ctx {
+	struct crypto_shash *tfm;
+	struct shash_desc desc;
+};
+
+static void *bpf_crypto_shash_alloc_tfm(const char *algo)
+{
+	struct bpf_shash_ctx *ctx;
+	struct crypto_shash *tfm;
+
+	tfm = crypto_alloc_shash(algo, 0, 0);
+	if (IS_ERR(tfm))
+		return tfm;
+
+	ctx = kzalloc(sizeof(*ctx) + crypto_shash_descsize(tfm), GFP_KERNEL);
+	if (!ctx) {
+		crypto_free_shash(tfm);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	ctx->tfm = tfm;
+	ctx->desc.tfm = tfm;
+
+	return ctx;
+}
+
+static void bpf_crypto_shash_free_tfm(void *tfm)
+{
+	struct bpf_shash_ctx *ctx = tfm;
+
+	crypto_free_shash(ctx->tfm);
+	kfree(ctx);
+}
+
+static int bpf_crypto_shash_has_algo(const char *algo)
+{
+	return crypto_has_shash(algo, 0, 0);
+}
+
+static int bpf_crypto_shash_hash(void *tfm, const u8 *data, u8 *out,
+				 unsigned int len)
+{
+	struct bpf_shash_ctx *ctx = tfm;
+
+	return crypto_shash_digest(&ctx->desc, data, len, out);
+}
+
+static unsigned int bpf_crypto_shash_digestsize(void *tfm)
+{
+	struct bpf_shash_ctx *ctx = tfm;
+
+	return crypto_shash_digestsize(ctx->tfm);
+}
+
+static u32 bpf_crypto_shash_get_flags(void *tfm)
+{
+	struct bpf_shash_ctx *ctx = tfm;
+
+	return crypto_shash_get_flags(ctx->tfm);
+}
+
+static const struct bpf_crypto_type bpf_crypto_shash_type = {
+	.alloc_tfm	= bpf_crypto_shash_alloc_tfm,
+	.free_tfm	= bpf_crypto_shash_free_tfm,
+	.has_algo	= bpf_crypto_shash_has_algo,
+	.hash		= bpf_crypto_shash_hash,
+	.digestsize	= bpf_crypto_shash_digestsize,
+	.get_flags	= bpf_crypto_shash_get_flags,
+	.owner		= THIS_MODULE,
+	.type_id	= BPF_CRYPTO_TYPE_HASH,
+	.name		= "hash",
+};
+
+static int __init bpf_crypto_shash_init(void)
+{
+	return bpf_crypto_register_type(&bpf_crypto_shash_type);
+}
+
+static void __exit bpf_crypto_shash_exit(void)
+{
+	int err = bpf_crypto_unregister_type(&bpf_crypto_shash_type);
+
+	WARN_ON_ONCE(err);
+}
+
+module_init(bpf_crypto_shash_init);
+module_exit(bpf_crypto_shash_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Hash algorithm support for BPF");
diff --git a/include/linux/bpf_crypto.h b/include/linux/bpf_crypto.h
index c84371cc4e47..cf2c66f9782b 100644
--- a/include/linux/bpf_crypto.h
+++ b/include/linux/bpf_crypto.h
@@ -3,6 +3,12 @@
 #ifndef _BPF_CRYPTO_H
 #define _BPF_CRYPTO_H
 
+enum bpf_crypto_type_id {
+	BPF_CRYPTO_TYPE_SKCIPHER = 1,
+	BPF_CRYPTO_TYPE_HASH,
+	BPF_CRYPTO_TYPE_SIG,
+};
+
 struct bpf_crypto_type {
 	void *(*alloc_tfm)(const char *algo);
 	void (*free_tfm)(void *tfm);
@@ -17,6 +23,7 @@ struct bpf_crypto_type {
 	unsigned int (*digestsize)(void *tfm);
 	u32 (*get_flags)(void *tfm);
 	struct module *owner;
+	enum bpf_crypto_type_id type_id;
 	char name[14];
 };
 
-- 
2.52.0

