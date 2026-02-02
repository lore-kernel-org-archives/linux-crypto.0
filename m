Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F703816F0
	for <linux-crypto@vger.kernel.org>; Mon,  2 Feb 2026 17:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770051764; cv=none; b=darutbBygwYEORqLQrji+J30toAd+lhYUU3aMsh4HPud7T46hL/VB4apYnPg/SixsRmqu9vINhp96+Ku+K2eFpKx7d5/Uk29njV2XlA70Gjd1GlgdyxCzilFPxysKxSoDRRC8Sv2NV2EKhzR4+qIWSRK18CA2XVoBt8/kyGdEkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770051764; c=relaxed/simple;
	bh=yxuz1XGwka25nwbP3TQtMQjnCd1A9XYnkw4fpQ+1zI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jo6I2yEYDpuiL2JMguQgtxBNJi6i0ypzpusJukhSCPYhumTm+6hLRObmYy/Tom2k9r7ts98nxfzMUtl+6Qz2jDoKNaMG2yXTN+J/yh5EH18e/BtdwlaA+j7xG/sHrsRzU/9xKVzusH4a1jyQ9l55vEXhJnEgAdl3ikx68X1c924=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZgeTb5rb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZgeTb5rb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770051761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PrapPTZIg/B6PDqm9XjQ/SresbhuKzegBZp9ZIwUVT0=;
	b=ZgeTb5rbMLRWzs6yrRjjhhw81GPeXvI+JeGVH1u+hZItW/rFWPKEzg3p3xAXGd6JmlljEn
	Wt7NkJdQ8Kj/2lNdxAC6lISdy6hE8x0Q5VBcmVii3B/+aqwUJhOXxNQ3OW9pWu2MZh9sWt
	ucSGsnEkWIkZUZi3S3aesJ4rhvXLygs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-664-H6kPryn1O0SQJfkHmAJ4jw-1; Mon,
 02 Feb 2026 12:02:34 -0500
X-MC-Unique: H6kPryn1O0SQJfkHmAJ4jw-1
X-Mimecast-MFC-AGG-ID: H6kPryn1O0SQJfkHmAJ4jw_1770051752
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9CB84195609F;
	Mon,  2 Feb 2026 17:02:31 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.44.33.164])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 889F419560B2;
	Mon,  2 Feb 2026 17:02:26 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@cloudflare.com>
Cc: David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org,
	keyrings@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v16 1/7] crypto: Add ML-DSA crypto_sig support
Date: Mon,  2 Feb 2026 17:02:06 +0000
Message-ID: <20260202170216.2467036-2-dhowells@redhat.com>
In-Reply-To: <20260202170216.2467036-1-dhowells@redhat.com>
References: <20260202170216.2467036-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Add verify-only public key crypto support for ML-DSA so that the
X.509/PKCS#7 signature verification code, as used by module signing,
amongst other things, can make use of it through the common crypto_sig API.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
cc: Eric Biggers <ebiggers@kernel.org>
cc: Lukas Wunner <lukas@wunner.de>
cc: Ignat Korchagin <ignat@cloudflare.com>
cc: Stephan Mueller <smueller@chronox.de>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: keyrings@vger.kernel.org
cc: linux-crypto@vger.kernel.org
---
 crypto/Kconfig  |   9 +++
 crypto/Makefile |   2 +
 crypto/mldsa.c  | 201 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 212 insertions(+)
 create mode 100644 crypto/mldsa.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 12a87f7cf150..a210575fa5e0 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -344,6 +344,15 @@ config CRYPTO_ECRDSA
 	  One of the Russian cryptographic standard algorithms (called GOST
 	  algorithms). Only signature verification is implemented.
 
+config CRYPTO_MLDSA
+	tristate "ML-DSA (Module-Lattice-Based Digital Signature Algorithm)"
+	select CRYPTO_SIG
+	select CRYPTO_LIB_MLDSA
+	help
+	  ML-DSA (Module-Lattice-Based Digital Signature Algorithm) (FIPS-204).
+
+	  Only signature verification is implemented.
+
 endmenu
 
 menu "Block ciphers"
diff --git a/crypto/Makefile b/crypto/Makefile
index 23d3db7be425..267d5403045b 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -60,6 +60,8 @@ ecdsa_generic-y += ecdsa-p1363.o
 ecdsa_generic-y += ecdsasignature.asn1.o
 obj-$(CONFIG_CRYPTO_ECDSA) += ecdsa_generic.o
 
+obj-$(CONFIG_CRYPTO_MLDSA) += mldsa.o
+
 crypto_acompress-y := acompress.o
 crypto_acompress-y += scompress.o
 obj-$(CONFIG_CRYPTO_ACOMP2) += crypto_acompress.o
diff --git a/crypto/mldsa.c b/crypto/mldsa.c
new file mode 100644
index 000000000000..d8de082cc67a
--- /dev/null
+++ b/crypto/mldsa.c
@@ -0,0 +1,201 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * crypto_sig wrapper around ML-DSA library.
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <crypto/internal/sig.h>
+#include <crypto/mldsa.h>
+
+struct crypto_mldsa_ctx {
+	u8 pk[MAX(MAX(MLDSA44_PUBLIC_KEY_SIZE,
+		      MLDSA65_PUBLIC_KEY_SIZE),
+		  MLDSA87_PUBLIC_KEY_SIZE)];
+	unsigned int pk_len;
+	enum mldsa_alg strength;
+	bool key_set;
+};
+
+static int crypto_mldsa_sign(struct crypto_sig *tfm,
+			     const void *msg, unsigned int msg_len,
+			     void *sig, unsigned int sig_len)
+{
+	return -EOPNOTSUPP;
+}
+
+static int crypto_mldsa_verify(struct crypto_sig *tfm,
+			       const void *sig, unsigned int sig_len,
+			       const void *msg, unsigned int msg_len)
+{
+	const struct crypto_mldsa_ctx *ctx = crypto_sig_ctx(tfm);
+
+	if (unlikely(!ctx->key_set))
+		return -EINVAL;
+
+	return mldsa_verify(ctx->strength, sig, sig_len, msg, msg_len,
+			    ctx->pk, ctx->pk_len);
+}
+
+static unsigned int crypto_mldsa_key_size(struct crypto_sig *tfm)
+{
+	struct crypto_mldsa_ctx *ctx = crypto_sig_ctx(tfm);
+
+	switch (ctx->strength) {
+	case MLDSA44:
+		return MLDSA44_PUBLIC_KEY_SIZE;
+	case MLDSA65:
+		return MLDSA65_PUBLIC_KEY_SIZE;
+	case MLDSA87:
+		return MLDSA87_PUBLIC_KEY_SIZE;
+	default:
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+}
+
+static int crypto_mldsa_set_pub_key(struct crypto_sig *tfm,
+				    const void *key, unsigned int keylen)
+{
+	struct crypto_mldsa_ctx *ctx = crypto_sig_ctx(tfm);
+	unsigned int expected_len = crypto_mldsa_key_size(tfm);
+
+	if (keylen != expected_len)
+		return -EINVAL;
+
+	ctx->pk_len = keylen;
+	memcpy(ctx->pk, key, keylen);
+	ctx->key_set = true;
+	return 0;
+}
+
+static int crypto_mldsa_set_priv_key(struct crypto_sig *tfm,
+				     const void *key, unsigned int keylen)
+{
+	return -EOPNOTSUPP;
+}
+
+static unsigned int crypto_mldsa_max_size(struct crypto_sig *tfm)
+{
+	struct crypto_mldsa_ctx *ctx = crypto_sig_ctx(tfm);
+
+	switch (ctx->strength) {
+	case MLDSA44:
+		return MLDSA44_SIGNATURE_SIZE;
+	case MLDSA65:
+		return MLDSA65_SIGNATURE_SIZE;
+	case MLDSA87:
+		return MLDSA87_SIGNATURE_SIZE;
+	default:
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+}
+
+static int crypto_mldsa44_alg_init(struct crypto_sig *tfm)
+{
+	struct crypto_mldsa_ctx *ctx = crypto_sig_ctx(tfm);
+
+	ctx->strength = MLDSA44;
+	ctx->key_set = false;
+	return 0;
+}
+
+static int crypto_mldsa65_alg_init(struct crypto_sig *tfm)
+{
+	struct crypto_mldsa_ctx *ctx = crypto_sig_ctx(tfm);
+
+	ctx->strength = MLDSA65;
+	ctx->key_set = false;
+	return 0;
+}
+
+static int crypto_mldsa87_alg_init(struct crypto_sig *tfm)
+{
+	struct crypto_mldsa_ctx *ctx = crypto_sig_ctx(tfm);
+
+	ctx->strength = MLDSA87;
+	ctx->key_set = false;
+	return 0;
+}
+
+static void crypto_mldsa_alg_exit(struct crypto_sig *tfm)
+{
+}
+
+static struct sig_alg crypto_mldsa_algs[] = {
+	{
+		.sign			= crypto_mldsa_sign,
+		.verify			= crypto_mldsa_verify,
+		.set_pub_key		= crypto_mldsa_set_pub_key,
+		.set_priv_key		= crypto_mldsa_set_priv_key,
+		.key_size		= crypto_mldsa_key_size,
+		.max_size		= crypto_mldsa_max_size,
+		.init			= crypto_mldsa44_alg_init,
+		.exit			= crypto_mldsa_alg_exit,
+		.base.cra_name		= "mldsa44",
+		.base.cra_driver_name	= "mldsa44-lib",
+		.base.cra_ctxsize	= sizeof(struct crypto_mldsa_ctx),
+		.base.cra_module	= THIS_MODULE,
+		.base.cra_priority	= 5000,
+	}, {
+		.sign			= crypto_mldsa_sign,
+		.verify			= crypto_mldsa_verify,
+		.set_pub_key		= crypto_mldsa_set_pub_key,
+		.set_priv_key		= crypto_mldsa_set_priv_key,
+		.key_size		= crypto_mldsa_key_size,
+		.max_size		= crypto_mldsa_max_size,
+		.init			= crypto_mldsa65_alg_init,
+		.exit			= crypto_mldsa_alg_exit,
+		.base.cra_name		= "mldsa65",
+		.base.cra_driver_name	= "mldsa65-lib",
+		.base.cra_ctxsize	= sizeof(struct crypto_mldsa_ctx),
+		.base.cra_module	= THIS_MODULE,
+		.base.cra_priority	= 5000,
+	}, {
+		.sign			= crypto_mldsa_sign,
+		.verify			= crypto_mldsa_verify,
+		.set_pub_key		= crypto_mldsa_set_pub_key,
+		.set_priv_key		= crypto_mldsa_set_priv_key,
+		.key_size		= crypto_mldsa_key_size,
+		.max_size		= crypto_mldsa_max_size,
+		.init			= crypto_mldsa87_alg_init,
+		.exit			= crypto_mldsa_alg_exit,
+		.base.cra_name		= "mldsa87",
+		.base.cra_driver_name	= "mldsa87-lib",
+		.base.cra_ctxsize	= sizeof(struct crypto_mldsa_ctx),
+		.base.cra_module	= THIS_MODULE,
+		.base.cra_priority	= 5000,
+	},
+};
+
+static int __init mldsa_init(void)
+{
+	int ret, i;
+
+	for (i = 0; i < ARRAY_SIZE(crypto_mldsa_algs); i++) {
+		ret = crypto_register_sig(&crypto_mldsa_algs[i]);
+		if (ret < 0)
+			goto error;
+	}
+	return 0;
+
+error:
+	pr_err("Failed to register (%d)\n", ret);
+	for (i--; i >= 0; i--)
+		crypto_unregister_sig(&crypto_mldsa_algs[i]);
+	return ret;
+}
+module_init(mldsa_init);
+
+static void mldsa_exit(void)
+{
+	for (int i = 0; i < ARRAY_SIZE(crypto_mldsa_algs); i++)
+		crypto_unregister_sig(&crypto_mldsa_algs[i]);
+}
+module_exit(mldsa_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Crypto API support for ML-DSA signature verification");
+MODULE_ALIAS_CRYPTO("mldsa44");
+MODULE_ALIAS_CRYPTO("mldsa65");
+MODULE_ALIAS_CRYPTO("mldsa87");

