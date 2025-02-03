Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DA620AF6C
	for <linux-crypto@vger.kernel.org>; Mon,  3 Feb 2025 14:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738592686; cv=none; b=HY0OMfyZhtEacYR1LZeRTmC69NBS+tlkWTQFYWHgNc+ODsSAa4V6AZ7tVOY5neT24ykw6a7CpaFe+yVV4LxUDXtis8hXDyqd5Ze+h9WcF0Dvzd/HrSJ8EvXKzGvPaefaiLRagxCceXs1cbMrKnyhjNR/SaJirWJEc4IhJ/l/C7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738592686; c=relaxed/simple;
	bh=JcyPdWy78fKBopVVye0ree1vSM3jlLIGLEJUiFgR21Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEnF72hG4WzgSNvkhgCOlNNXkuTnn8ASMJ4T7r3dlFAcShA41ffwvH0RokIiBJu+cs+xdmmj0KnsjSdsCJ1MHTecwhT2bCaZNTGG3Ap4wgHGO1IkVd0XyXc1w/2wXVnUz54TGkZ3ReghfvsNqIr2kvTl1hJcLX+KOqjmjANqyyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dzyP0Ybs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dzyP0Ybs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738592683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k0MyFqVjGmAifeFhcdjYdHD2lCDeGii6cjQVMPh/emU=;
	b=dzyP0YbsmU1pm6hOCRcgb49SsHUMAFUDebVMrhkx/eRRwZPAtFew0cx/NhhHJfgcDcgkuJ
	ZfVfwLxtTRQUo/WZLAIgIRthV8FrYvrvguRy+4DyUMWhdNCwDCTurptj2LKbn+7Nsqksi+
	S9XaWM2hx/sj7ypydDVHzc23vvFVyTw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-131-ee24gBp1MymNfUmWGYpjbw-1; Mon,
 03 Feb 2025 09:24:40 -0500
X-MC-Unique: ee24gBp1MymNfUmWGYpjbw-1
X-Mimecast-MFC-AGG-ID: ee24gBp1MymNfUmWGYpjbw
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2510B1955F26;
	Mon,  3 Feb 2025 14:24:38 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.92])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5A4F018008D0;
	Mon,  3 Feb 2025 14:24:33 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-nfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net 07/24] crypto/krb5: Add an API to alloc and prepare a crypto object
Date: Mon,  3 Feb 2025 14:23:23 +0000
Message-ID: <20250203142343.248839-8-dhowells@redhat.com>
In-Reply-To: <20250203142343.248839-1-dhowells@redhat.com>
References: <20250203142343.248839-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Add an API by which users of the krb5 crypto library can get an allocated
and keyed crypto object.

For encryption-mode operation, an AEAD object is returned; for
checksum-mode operation, a synchronous hash object is returned.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: "David S. Miller" <davem@davemloft.net>
cc: Chuck Lever <chuck.lever@oracle.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: linux-nfs@vger.kernel.org
cc: linux-crypto@vger.kernel.org
cc: netdev@vger.kernel.org
---
 crypto/krb5/internal.h |  10 +++
 crypto/krb5/krb5_api.c | 144 +++++++++++++++++++++++++++++++++++++++++
 include/crypto/krb5.h  |   7 ++
 3 files changed, 161 insertions(+)

diff --git a/crypto/krb5/internal.h b/crypto/krb5/internal.h
index 3ede858be4f7..b542d24e5fa5 100644
--- a/crypto/krb5/internal.h
+++ b/crypto/krb5/internal.h
@@ -110,3 +110,13 @@ struct krb5_crypto_profile {
 #define krb5_digest_size(TFM) \
 	crypto_roundup(crypto_shash_digestsize(TFM))
 #define round16(x) (((x) + 15) & ~15)
+
+/*
+ * krb5_api.c
+ */
+struct crypto_aead *krb5_prepare_encryption(const struct krb5_enctype *krb5,
+					    const struct krb5_buffer *keys,
+					    gfp_t gfp);
+struct crypto_shash *krb5_prepare_checksum(const struct krb5_enctype *krb5,
+					   const struct krb5_buffer *Kc,
+					   gfp_t gfp);
diff --git a/crypto/krb5/krb5_api.c b/crypto/krb5/krb5_api.c
index f6d1bc813daa..f7f2528b3895 100644
--- a/crypto/krb5/krb5_api.c
+++ b/crypto/krb5/krb5_api.c
@@ -148,3 +148,147 @@ void crypto_krb5_where_is_the_data(const struct krb5_enctype *krb5,
 	}
 }
 EXPORT_SYMBOL(crypto_krb5_where_is_the_data);
+
+/*
+ * Prepare the encryption with derived key data.
+ */
+struct crypto_aead *krb5_prepare_encryption(const struct krb5_enctype *krb5,
+					    const struct krb5_buffer *keys,
+					    gfp_t gfp)
+{
+	struct crypto_aead *ci = NULL;
+	int ret = -ENOMEM;
+
+	ci = crypto_alloc_aead(krb5->encrypt_name, 0, 0);
+	if (IS_ERR(ci)) {
+		ret = PTR_ERR(ci);
+		if (ret == -ENOENT)
+			ret = -ENOPKG;
+		goto err;
+	}
+
+	ret = crypto_aead_setkey(ci, keys->data, keys->len);
+	if (ret < 0) {
+		pr_err("Couldn't set AEAD key %s: %d\n", krb5->encrypt_name, ret);
+		goto err_ci;
+	}
+
+	ret = crypto_aead_setauthsize(ci, krb5->cksum_len);
+	if (ret < 0) {
+		pr_err("Couldn't set AEAD authsize %s: %d\n", krb5->encrypt_name, ret);
+		goto err_ci;
+	}
+
+	return ci;
+err_ci:
+	crypto_free_aead(ci);
+err:
+	return ERR_PTR(ret);
+}
+
+/**
+ * crypto_krb5_prepare_encryption - Prepare AEAD crypto object for encryption-mode
+ * @krb5: The encoding to use.
+ * @TK: The transport key to use.
+ * @usage: The usage constant for key derivation.
+ * @gfp: Allocation flags.
+ *
+ * Allocate a crypto object that does all the necessary crypto, key it and set
+ * its parameters and return the crypto handle to it.  This can then be used to
+ * dispatch encrypt and decrypt operations.
+ */
+struct crypto_aead *crypto_krb5_prepare_encryption(const struct krb5_enctype *krb5,
+						   const struct krb5_buffer *TK,
+						   u32 usage, gfp_t gfp)
+{
+	struct crypto_aead *ci = NULL;
+	struct krb5_buffer keys = {};
+	int ret;
+
+	ret = krb5->profile->derive_encrypt_keys(krb5, TK, usage, &keys, gfp);
+	if (ret < 0)
+		goto err;
+
+	ci = krb5_prepare_encryption(krb5, &keys, gfp);
+	if (IS_ERR(ci)) {
+		ret = PTR_ERR(ci);
+		goto err;
+	}
+
+	kfree(keys.data);
+	return ci;
+err:
+	kfree(keys.data);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL(crypto_krb5_prepare_encryption);
+
+/*
+ * Prepare the checksum with derived key data.
+ */
+struct crypto_shash *krb5_prepare_checksum(const struct krb5_enctype *krb5,
+					   const struct krb5_buffer *Kc,
+					   gfp_t gfp)
+{
+	struct crypto_shash *ci = NULL;
+	int ret = -ENOMEM;
+
+	ci = crypto_alloc_shash(krb5->cksum_name, 0, 0);
+	if (IS_ERR(ci)) {
+		ret = PTR_ERR(ci);
+		if (ret == -ENOENT)
+			ret = -ENOPKG;
+		goto err;
+	}
+
+	ret = crypto_shash_setkey(ci, Kc->data, Kc->len);
+	if (ret < 0) {
+		pr_err("Couldn't set shash key %s: %d\n", krb5->cksum_name, ret);
+		goto err_ci;
+	}
+
+	return ci;
+err_ci:
+	crypto_free_shash(ci);
+err:
+	return ERR_PTR(ret);
+}
+
+/**
+ * crypto_krb5_prepare_checksum - Prepare AEAD crypto object for checksum-mode
+ * @krb5: The encoding to use.
+ * @TK: The transport key to use.
+ * @usage: The usage constant for key derivation.
+ * @gfp: Allocation flags.
+ *
+ * Allocate a crypto object that does all the necessary crypto, key it and set
+ * its parameters and return the crypto handle to it.  This can then be used to
+ * dispatch get_mic and verify_mic operations.
+ */
+struct crypto_shash *crypto_krb5_prepare_checksum(const struct krb5_enctype *krb5,
+						  const struct krb5_buffer *TK,
+						  u32 usage, gfp_t gfp)
+{
+	struct crypto_shash *ci = NULL;
+	struct krb5_buffer keys = {};
+	int ret;
+
+	ret = krb5->profile->derive_checksum_key(krb5, TK, usage, &keys, gfp);
+	if (ret < 0) {
+		pr_err("get_Kc failed %d\n", ret);
+		goto err;
+	}
+
+	ci = krb5_prepare_checksum(krb5, &keys, gfp);
+	if (IS_ERR(ci)) {
+		ret = PTR_ERR(ci);
+		goto err;
+	}
+
+	kfree(keys.data);
+	return ci;
+err:
+	kfree(keys.data);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL(crypto_krb5_prepare_checksum);
diff --git a/include/crypto/krb5.h b/include/crypto/krb5.h
index b414141b8b42..94af2c558fa1 100644
--- a/include/crypto/krb5.h
+++ b/include/crypto/krb5.h
@@ -10,6 +10,7 @@
 
 #include <linux/crypto.h>
 #include <crypto/aead.h>
+#include <crypto/hash.h>
 
 struct crypto_shash;
 struct scatterlist;
@@ -110,5 +111,11 @@ size_t crypto_krb5_how_much_data(const struct krb5_enctype *krb5,
 void crypto_krb5_where_is_the_data(const struct krb5_enctype *krb5,
 				   enum krb5_crypto_mode mode,
 				   size_t *_offset, size_t *_len);
+struct crypto_aead *crypto_krb5_prepare_encryption(const struct krb5_enctype *krb5,
+						   const struct krb5_buffer *TK,
+						   u32 usage, gfp_t gfp);
+struct crypto_shash *crypto_krb5_prepare_checksum(const struct krb5_enctype *krb5,
+						  const struct krb5_buffer *TK,
+						  u32 usage, gfp_t gfp);
 
 #endif /* _CRYPTO_KRB5_H */

