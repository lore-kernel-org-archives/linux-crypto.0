Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DBA481AA1
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 13:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786629045; cv=none; b=rmsR70pdxV8iJBKBiPk9+oNj9Fvahf093xp/F9k8X06yuyvFBcH7d0UEMSeTMA+JgboPt96sUqGPnE5ML8ab57mClPZSYmSiED6LOWT4OuyopdzUHtJ3Aui9ChClfjiKSYGWi9upDvGxfe6szu0J6kDMrMjeW6r77oxnLzG05g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786629045; c=relaxed/simple;
	bh=LBJGRPEX+c7ESpwmdOsrAF1eS6K7PlwVdVAherwht48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFtseCdMibcJnR+s/yN3rW2SbeCBYR7Vm/aPIJbHEIifkeyO3zJXe2dsLYA+wYgie/yyLMrgixvD74JrgLtra6WNSlaoQSn0QEoGRk644LR6LBbeQ4vSX5KSSZoxxremJFnVHOLo6FhcbBQkJ3xYIrad5fSAEws4VY3fsjyzoXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UJAFFgR4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UJAFFgR4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786629042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qrmNWOfIIVDyeK/HAUK9wucBz8cLmmeO96RwNn6+/qo=;
	b=UJAFFgR4x6FMI/+p6IZ1AmtAHSFe7Rpbxg5gtGKG4793VjkgOyX8NlFtlVUXaO1/FJ1BR9
	pYU8WousM+GFcnuY9gN7YwrYiTlv5uhTuSiFNYPwpMus885vIjgr7lwgvyrLQdJBAFvH+U
	JiI2slGntOdN2VayzTDpQkmzKPsrarY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-423-E9bXOoQfOG-mrSnz4Qjkww-1; Thu,
 13 Aug 2026 09:50:41 -0400
X-MC-Unique: E9bXOoQfOG-mrSnz4Qjkww-1
X-Mimecast-MFC-AGG-ID: E9bXOoQfOG-mrSnz4Qjkww_1786629040
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E98DD180075E;
	Thu, 13 Aug 2026 13:50:39 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 785791800348;
	Thu, 13 Aug 2026 13:50:37 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] lib/crypto: sha2: Provide wrappers for zeroizing SHA2 hmac_sha*_ctx structures
Date: Thu, 13 Aug 2026 15:49:49 +0200
Message-ID: <20260813134953.979481-12-thuth@redhat.com>
In-Reply-To: <20260813134953.979481-1-thuth@redhat.com>
References: <20260813134953.979481-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Thomas Huth <thuth@redhat.com>

Some crypto code functions need to zeroize their local SHA2 hmac_sha*_ctx
structures after use to avoid leaking sensitive material on the stack.
Provide hmac_sha*_zeroize_ctx() helper functions that can be used with
__cleanup() to automatically zeroize the context when it goes out of
scope.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 Note: These will be useful in some spots in the fs/smb/ code later.

 include/crypto/sha2.h | 57 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/include/crypto/sha2.h b/include/crypto/sha2.h
index 7bb8fe169daf2..2b2b06ebff993 100644
--- a/include/crypto/sha2.h
+++ b/include/crypto/sha2.h
@@ -7,6 +7,7 @@
 #define _CRYPTO_SHA2_H
 
 #include <linux/types.h>
+#include <linux/string.h>
 
 #define SHA224_DIGEST_SIZE	28
 #define SHA224_BLOCK_SIZE	64
@@ -218,6 +219,20 @@ struct hmac_sha224_ctx {
 	struct __hmac_sha256_ctx ctx;
 };
 
+/**
+ * hmac_sha224_zeroize_ctx() - Zeroize an hmac_sha224_ctx structure
+ * @ctx: The location of the context that should be zeroized
+ *
+ * This function explicitly fills the hmac_sha224_ctx with zeroes. For
+ * example, use it with __cleanup() for local hmac_sha224_ctx structures
+ * on the stack, so that their content is not leaked when the context is
+ * left. Note: This is only required when not using hmac_sha224_final().
+ */
+static inline void hmac_sha224_zeroize_ctx(struct hmac_sha224_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /**
  * hmac_sha224_preparekey() - Prepare a key for HMAC-SHA224
  * @key: (output) the key structure to initialize
@@ -422,6 +437,20 @@ struct hmac_sha256_ctx {
 	struct __hmac_sha256_ctx ctx;
 };
 
+/**
+ * hmac_sha256_zeroize_ctx() - Zeroize an hmac_sha256_ctx structure
+ * @ctx: The location of the context that should be zeroized
+ *
+ * This function explicitly fills the hmac_sha256_ctx with zeroes. For
+ * example, use it with __cleanup() for local hmac_sha256_ctx structures
+ * on the stack, so that their content is not leaked when the context is
+ * left. Note: This is only required when not using hmac_sha256_final().
+ */
+static inline void hmac_sha256_zeroize_ctx(struct hmac_sha256_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /**
  * hmac_sha256_preparekey() - Prepare a key for HMAC-SHA256
  * @key: (output) the key structure to initialize
@@ -631,6 +660,20 @@ struct hmac_sha384_ctx {
 	struct __hmac_sha512_ctx ctx;
 };
 
+/**
+ * hmac_sha384_zeroize_ctx() - Zeroize an hmac_sha384_ctx structure
+ * @ctx: The location of the context that should be zeroized
+ *
+ * This function explicitly fills the hmac_sha384_ctx with zeroes. For
+ * example, use it with __cleanup() for local hmac_sha384_ctx structures
+ * on the stack, so that their content is not leaked when the context is
+ * left. Note: This is only required when not using hmac_sha384_final().
+ */
+static inline void hmac_sha384_zeroize_ctx(struct hmac_sha384_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /**
  * hmac_sha384_preparekey() - Prepare a key for HMAC-SHA384
  * @key: (output) the key structure to initialize
@@ -806,6 +849,20 @@ struct hmac_sha512_ctx {
 	struct __hmac_sha512_ctx ctx;
 };
 
+/**
+ * hmac_sha512_zeroize_ctx() - Zeroize an hmac_sha512_ctx structure
+ * @ctx: The location of the context that should be zeroized
+ *
+ * This function explicitly fills the hmac_sha512_ctx with zeroes. For
+ * example, use it with __cleanup() for local hmac_sha512_ctx structures
+ * on the stack, so that their content is not leaked when the context is
+ * left. Note: This is only required when not using hmac_sha512_final().
+ */
+static inline void hmac_sha512_zeroize_ctx(struct hmac_sha512_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /**
  * hmac_sha512_preparekey() - Prepare a key for HMAC-SHA512
  * @key: (output) the key structure to initialize
-- 
2.55.0

