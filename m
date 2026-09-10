Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4DA486B83
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 12:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789044127; cv=none; b=HufbbNDFF3pmCWU0a9lUyCpTK0OQf3sctAGNo5z0iYyQzs3BysHHoV9FzCCsaWW2HjBKb/7DnBdoTfHGwP7XyNWFrG7OJrk7oqmfB7OkauxF1FgGj8tDT42UVWZpsFKYl/7GZtIuYM4xMbFhcV4oHaZh+i9WmBWEPI5iS75OHW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789044127; c=relaxed/simple;
	bh=4/1kEsT70NlzkN+xrxR35Wl/GIQQI1l/UDDyNSo29h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FocthPWg/2iiQ6hM+T6FUBv4ImfwodylE9v5glEzM96Cha0FcKw40fmsuk6g/9vEEw8ZN/1W1kbeTS6B4RG8w8ib+ddbC/gHKq3lugBH0LSMvp48zcMMe06wY/YdhPw26O1Qcq86MZvApJ6VOg97voASD3uC+83TiT6iBwLcAM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SCfcv83C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SCfcv83C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789044122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UEdu/etGA8cxWfcQPyBtvpBW0rX8uyBFZbXJ3IuQEjE=;
	b=SCfcv83CqVcrdzv0cMYHTxP/EyOw409rUBC3WTsLAC/ajZ62e0b5VJ0Md6qMomtFxoPnvW
	ci8XVwoA2ZUikgCrzUtnghWrY4+VlEwnIq6zpFmW8KVy/PHKl2IkUV9Ot0Y2M+pMkipOEg
	rkxu25cbQKlZqrD6j4n6hkKSSvmUro4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-683-BWwW_glNM3CCrhYL_IQcVA-1; Thu,
 10 Sep 2026 08:41:59 -0400
X-MC-Unique: BWwW_glNM3CCrhYL_IQcVA-1
X-Mimecast-MFC-AGG-ID: BWwW_glNM3CCrhYL_IQcVA_1789044118
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D11EE1800767;
	Thu, 10 Sep 2026 12:41:57 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2C73E30001A2;
	Thu, 10 Sep 2026 12:41:53 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH v3 03/13] lib/crypto: aes-gcm: Provide functions for zeroizing aes_gcm* structures
Date: Thu, 10 Sep 2026 14:41:22 +0200
Message-ID: <20260910124138.417439-4-thuth@redhat.com>
In-Reply-To: <20260910124138.417439-1-thuth@redhat.com>
References: <20260910124138.417439-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

In certain cases crypto code needs to zeroize their local aes_gcm_key
or aes_gcm_ctx structures after use to avoid leaking sensitive material.
Provide aes_gcm_zeroize_key() and aes_gcm_zeroize_ctx() helper functions
that e.g. can be used with __cleanup() to automatically zeroize the
structures when they go out of scope.

While we're at it, replace the related memzero_explicit() calls in
lib/crypto/aes.c with calls to the new helper functions.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/crypto/aes-gcm.h | 22 ++++++++++++++++++++--
 lib/crypto/aes.c         |  8 +++-----
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/include/crypto/aes-gcm.h b/include/crypto/aes-gcm.h
index 2aee62f019891..a81b00fd8e27f 100644
--- a/include/crypto/aes-gcm.h
+++ b/include/crypto/aes-gcm.h
@@ -21,6 +21,15 @@ struct aes_gcm_key {
 	size_t authtag_len; /* Length of authentication tags in bytes */
 };
 
+/**
+ * aes_gcm_zeroize_key() - Zeroize an aes_gcm_key structure
+ * @key: The aes_gcm_key to zeroize
+ */
+static inline void aes_gcm_zeroize_key(struct aes_gcm_key *key)
+{
+	memzero_explicit(key, sizeof(*key));
+}
+
 /**
  * struct aes_gcm_ctx - Context for incrementally en/decrypting a message
  */
@@ -58,6 +67,15 @@ struct aes_gcm_ctx {
 	u64 data_len;
 };
 
+/**
+ * aes_gcm_zeroize_ctx() - Zeroize an aes_gcm_ctx structure
+ * @ctx: The aes_gcm_ctx to zeroize
+ */
+static inline void aes_gcm_zeroize_ctx(struct aes_gcm_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /**
  * aes_gcm_preparekey() - Prepare a key for AES-GCM encryption and decryption
  * @key: (output) The key structure to initialize
@@ -66,8 +84,8 @@ struct aes_gcm_ctx {
  * @authtag_len: Length of the authentication tag in bytes:
  *		 4, 8, 12, 13, 14, 15, or 16.  16 is recommended.
  *
- * Users should use memzero_explicit() to zeroize the key struct at the end of
- * its lifetime.  (But if this function fails, zeroization is unnecessary.)
+ * Users should use aes_gcm_zeroize_key() to zeroize the key struct at the end
+ * of its lifetime.  (But if this function fails, zeroization is unnecessary.)
  *
  * Context: Any context.
  * Return:
diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index 34ef5deca0a79..0cb5d7355926e 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -1670,7 +1670,7 @@ void aes_gcm_encrypt_final(struct aes_gcm_ctx *ctx, u8 *authtag)
 	ghash_final(&ctx->ghash, ctx->ctr); /* Use ctr as temp buffer */
 
 	crypto_xor_cpy(authtag, ctx->ctr, ctx->j0_enc, ctx->key->authtag_len);
-	memzero_explicit(ctx, sizeof(*ctx));
+	aes_gcm_zeroize_ctx(ctx);
 }
 EXPORT_SYMBOL_GPL(aes_gcm_encrypt_final);
 
@@ -1697,7 +1697,7 @@ int aes_gcm_decrypt_final(struct aes_gcm_ctx *ctx, const u8 *authtag)
 		      -EBADMSG :
 		      0;
 out:
-	memzero_explicit(ctx, sizeof(*ctx));
+	aes_gcm_zeroize_ctx(ctx);
 	return err;
 }
 EXPORT_SYMBOL_GPL(aes_gcm_decrypt_final);
@@ -1742,7 +1742,7 @@ static void __init aes_gcm_fips_test(void)
 {
 	const size_t data_len = sizeof(fips_test_data);
 	u8 buf[sizeof(fips_test_data) + AES_BLOCK_SIZE];
-	struct aes_gcm_key key;
+	struct aes_gcm_key key __cleanup(aes_gcm_zeroize_key);
 	int err;
 
 	if (aes_gcm_preparekey(&key, fips_test_key, sizeof(fips_test_key),
@@ -1760,8 +1760,6 @@ static void __init aes_gcm_fips_test(void)
 		panic("aes: GCM FIPS self-test failed (decryption failed)\n");
 	if (memcmp(fips_test_data, buf, data_len) != 0)
 		panic("aes: GCM FIPS self-test failed (wrong plaintext)\n");
-
-	memzero_explicit(&key, sizeof(key));
 }
 #else /* CONFIG_CRYPTO_LIB_AES_GCM */
 static inline void aes_gcm_fips_test(void)
-- 
2.55.0

