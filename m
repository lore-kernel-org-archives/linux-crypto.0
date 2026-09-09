Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F725476D9
	for <linux-crypto@vger.kernel.org>; Wed,  9 Sep 2026 11:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788954927; cv=none; b=pwm48nCoZj/ybiz6L5vAo69UzYCJP+x5dpbzt5ySXdTIsDZz/EGDAF4g6VXj0kD3FLLLRSSQl1slJSvnbdhMncSGjw7pDPE9vJdDLPZ7QBVlkEY5dQmAlSYFSBaFE/nX0ZohPGeK5R8CIVybP29jTWPmNIeLlmrQFZ8kMExrxmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788954927; c=relaxed/simple;
	bh=Gauuyu1weASDOCUOi0niAJFHae1GpPUEFg2Emc3mczQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XH0S20kr0N/TabM+l70XrBADm26PmPoAgeveKrYVYaWUErDYyymu0D5jXtxJVkbvptklzUeToNlRJDMiXfRKnwHH3FFsMOKjmYJFsLajHOWQ/g+XEqDpMctLr3QvMuQiRQXXIW9XJ04Zh8M3eyZslMzhH3ii75lLqnIsEDokYtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JJPNFWBo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JJPNFWBo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788954924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/X0DqhKQVgSWZ6Kwg3nu2S/S85i2kZoDTzqHkKw8Nxs=;
	b=JJPNFWBoP8WDBdQDo8cQluPJptD4NT6unYnsXojja6iqUQXq4diq8flT+hhOxEkJUDc/AD
	kK6H7LuBWT5rjKvIGtEUcaUoSsdquCjSqHmmot4GBVDeKDkrZMXSoIigvj6exKk5wsQ23L
	L8VULc9EssuP8jJcCY1af7HswqIUt3U=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-168-_E0XYkbqMzOl27A0uF0LOQ-1; Wed,
 09 Sep 2026 07:55:21 -0400
X-MC-Unique: _E0XYkbqMzOl27A0uF0LOQ-1
X-Mimecast-MFC-AGG-ID: _E0XYkbqMzOl27A0uF0LOQ_1788954919
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3FA9B1954AE0;
	Wed,  9 Sep 2026 11:55:19 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3979D1956088;
	Wed,  9 Sep 2026 11:55:14 +0000 (UTC)
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
Subject: [PATCH v2 04/13] lib/crypto: aes-ccm: Provide functions for zeroizing aes_ccm* structures
Date: Wed,  9 Sep 2026 13:54:40 +0200
Message-ID: <20260909115455.157093-5-thuth@redhat.com>
In-Reply-To: <20260909115455.157093-1-thuth@redhat.com>
References: <20260909115455.157093-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

In certain cases crypto code needs to zeroize their local aes_ccm_key
or aes_ccm_ctx structures after use to avoid leaking sensitive material.
Provide aes_ccm_zeroize_key() and aes_ccm_zeroize_ctx() helper functions
that e.g. can be used with __cleanup() to automatically zeroize the
structures when they go out of scope.

While we're at it, replace the related memzero_explicit() calls in
lib/crypto/aes.c with calls to the new helper functions.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/crypto/aes-ccm.h | 22 ++++++++++++++++++++--
 lib/crypto/aes.c         |  8 +++-----
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/include/crypto/aes-ccm.h b/include/crypto/aes-ccm.h
index 8b00859ac4d6b..c52982dd91d2c 100644
--- a/include/crypto/aes-ccm.h
+++ b/include/crypto/aes-ccm.h
@@ -18,6 +18,15 @@ struct aes_ccm_key {
 	size_t authtag_len; /* Length of authentication tags in bytes */
 };
 
+/**
+ * aes_ccm_zeroize_key() - Zeroize an aes_ccm_key structure
+ * @key: The aes_ccm_key to zeroize
+ */
+static inline void aes_ccm_zeroize_key(struct aes_ccm_key *key)
+{
+	memzero_explicit(key, sizeof(*key));
+}
+
 /**
  * struct aes_ccm_ctx - Context for incrementally en/decrypting a message
  */
@@ -50,6 +59,15 @@ struct aes_ccm_ctx {
 	bool ad_padded;
 };
 
+/**
+ * aes_ccm_zeroize_ctx() - Zeroize an aes_ccm_ctx structure
+ * @ctx: The aes_ccm_ctx to zeroize
+ */
+static inline void aes_ccm_zeroize_ctx(struct aes_ccm_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /**
  * aes_ccm_preparekey() - Prepare a key for AES-CCM encryption and decryption
  * @key: (output) The key structure to initialize
@@ -58,8 +76,8 @@ struct aes_ccm_ctx {
  * @authtag_len: Length of the authentication tag in bytes:
  *		 4, 6, 8, 10, 12, 14, or 16.  16 is recommended.
  *
- * Users should use memzero_explicit() to zeroize the key struct at the end of
- * its lifetime.  (But if this function fails, zeroization is unnecessary.)
+ * Users should use aes_ccm_zeroize_key() to zeroize the key struct at the end
+ * of its lifetime.  (But if this function fails, zeroization is unnecessary.)
  *
  * Context: Any context.
  * Return:
diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index 0cb5d7355926e..2d29adca79532 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -2011,7 +2011,7 @@ void aes_ccm_encrypt_final(struct aes_ccm_ctx *ctx, u8 *authtag)
 	if (ctx->partial_len)
 		aes_encrypt(&ctx->key->aes, ctx->mac, ctx->mac);
 	crypto_xor_cpy(authtag, ctx->mac, ctx->s0, ctx->key->authtag_len);
-	memzero_explicit(ctx, sizeof(*ctx));
+	aes_ccm_zeroize_ctx(ctx);
 }
 EXPORT_SYMBOL_GPL(aes_ccm_encrypt_final);
 
@@ -2032,7 +2032,7 @@ int aes_ccm_decrypt_final(struct aes_ccm_ctx *ctx, const u8 *authtag)
 		      -EBADMSG :
 		      0;
 out:
-	memzero_explicit(ctx, sizeof(*ctx));
+	aes_ccm_zeroize_ctx(ctx);
 	return err;
 }
 EXPORT_SYMBOL_GPL(aes_ccm_decrypt_final);
@@ -2084,7 +2084,7 @@ static void __init aes_ccm_fips_test(void)
 	const size_t data_len = sizeof(fips_test_data);
 	const size_t nonce_len = 13;
 	u8 buf[sizeof(fips_test_data) + AES_BLOCK_SIZE];
-	struct aes_ccm_key key;
+	struct aes_ccm_key key __cleanup(aes_ccm_zeroize_key);
 	int err;
 
 	if (aes_ccm_preparekey(&key, fips_test_key, sizeof(fips_test_key),
@@ -2106,8 +2106,6 @@ static void __init aes_ccm_fips_test(void)
 		panic("aes: CCM FIPS self-test failed (decryption failed)\n");
 	if (memcmp(fips_test_data, buf, data_len) != 0)
 		panic("aes: CCM FIPS self-test failed (wrong plaintext)\n");
-
-	memzero_explicit(&key, sizeof(key));
 }
 #else /* CONFIG_CRYPTO_LIB_AES_CCM */
 static inline void aes_ccm_fips_test(void)
-- 
2.55.0

