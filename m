Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E6F4B129D
	for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2026 09:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789552303; cv=none; b=by7dfOPwQqC8Ppa42ga6vDWApc9FpZ0Om+pvWHjtlxjMGiUYXxOIkxH2VFbNTdfbkqtEUGXKzu7JObIz7on9I+PNKqHchHJZcrPKugl2qCQgwAH5Sg3/1CivIyHT6AgWonh65mVzQQhDCOaFePt1mo8Ggc1mAiHuVwwIgNt92dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789552303; c=relaxed/simple;
	bh=Pznk8hfVuVukVfclBPzbhLEaJi6ZtK/4mQJu/n1NEDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMehHeO66CCnTtClIIZ1sWTT4h4Qj11ajkr3KnlSGUd82hGNibiU7CqKcjjBOnnHylcuXKSFtWBDXVSrB955afzEI4BueCrrkznVREjudUh+1ewff5oWJP+/Zp3QCWUpG+dCelg1ouk7sffkgyKVByPneuJXKGWz22sRuXw8oTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ipf7uDM1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ipf7uDM1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789552285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dAu1bQF4/jUeSXArCSj5+nJuZ/vxHgx8HbK6kP4IS9s=;
	b=ipf7uDM18qTliOSDBseI5ydx6yLeiTcKr6eUDaSE7nPvn9VHvVwf7YoSru3GJM0LYQLPjp
	rQn9yZ+t8QkxN23+YwlWpaPcwKrM1nwF5uBIgQk3co1hQtuTGqmMHfKlnmC3zd9SjGsaat
	oxy1b6SENRWu8OaCo76uXIidLkkepCw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-606-afO72ag2MPaTPknHrn1usQ-1; Wed,
 16 Sep 2026 05:51:24 -0400
X-MC-Unique: afO72ag2MPaTPknHrn1usQ-1
X-Mimecast-MFC-AGG-ID: afO72ag2MPaTPknHrn1usQ_1789552282
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7DE201954B27;
	Wed, 16 Sep 2026 09:51:22 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B41561800446;
	Wed, 16 Sep 2026 09:51:18 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 11/13] lib/crypto: sha2: Provide functions for zeroizing SHA2 hmac_sha* structures
Date: Wed, 16 Sep 2026 11:50:13 +0200
Message-ID: <20260916095022.604354-12-thuth@redhat.com>
In-Reply-To: <20260916095022.604354-1-thuth@redhat.com>
References: <20260916095022.604354-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

In certain cases crypto code functions need to zeroize their local SHA2
hmac_sha*_key or hmac_sha*_ctx structures after use to avoid leaking
sensitive material on the stack.
Provide hmac_sha*_zeroize_key() and hmac_sha*_zeroize_ctx() helper
functions that can be used with __cleanup() to automatically zeroize
the structure when it goes out of scope.

Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/crypto/sha2.h | 73 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/include/crypto/sha2.h b/include/crypto/sha2.h
index 7bb8fe169daf2..22fbc37ae8407 100644
--- a/include/crypto/sha2.h
+++ b/include/crypto/sha2.h
@@ -7,6 +7,7 @@
 #define _CRYPTO_SHA2_H
 
 #include <linux/types.h>
+#include <linux/string.h>
 
 #define SHA224_DIGEST_SIZE	28
 #define SHA224_BLOCK_SIZE	64
@@ -210,6 +211,15 @@ struct hmac_sha224_key {
 	struct __hmac_sha256_key key;
 };
 
+/**
+ * hmac_sha224_zeroize_key() - Zeroize an hmac_sha224_key structure
+ * @key: The hmac_sha224_key to zeroize
+ */
+static inline void hmac_sha224_zeroize_key(struct hmac_sha224_key *key)
+{
+	memzero_explicit(key, sizeof(*key));
+}
+
 /**
  * struct hmac_sha224_ctx - Context for computing HMAC-SHA224 of a message
  * @ctx: private
@@ -218,6 +228,15 @@ struct hmac_sha224_ctx {
 	struct __hmac_sha256_ctx ctx;
 };
 
+/**
+ * hmac_sha224_zeroize_ctx() - Zeroize an hmac_sha224_ctx structure
+ * @ctx: The hmac_sha224_ctx context to zeroize
+ */
+static inline void hmac_sha224_zeroize_ctx(struct hmac_sha224_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /**
  * hmac_sha224_preparekey() - Prepare a key for HMAC-SHA224
  * @key: (output) the key structure to initialize
@@ -414,6 +433,15 @@ struct hmac_sha256_key {
 	struct __hmac_sha256_key key;
 };
 
+/**
+ * hmac_sha256_zeroize_key() - Zeroize an hmac_sha256_key structure
+ * @key: The hmac_sha256_key to zeroize
+ */
+static inline void hmac_sha256_zeroize_key(struct hmac_sha256_key *key)
+{
+	memzero_explicit(key, sizeof(*key));
+}
+
 /**
  * struct hmac_sha256_ctx - Context for computing HMAC-SHA256 of a message
  * @ctx: private
@@ -422,6 +450,15 @@ struct hmac_sha256_ctx {
 	struct __hmac_sha256_ctx ctx;
 };
 
+/**
+ * hmac_sha256_zeroize_ctx() - Zeroize an hmac_sha256_ctx structure
+ * @ctx: The hmac_sha256_ctx context to zeroize
+ */
+static inline void hmac_sha256_zeroize_ctx(struct hmac_sha256_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /**
  * hmac_sha256_preparekey() - Prepare a key for HMAC-SHA256
  * @key: (output) the key structure to initialize
@@ -623,6 +660,15 @@ struct hmac_sha384_key {
 	struct __hmac_sha512_key key;
 };
 
+/**
+ * hmac_sha384_zeroize_key() - Zeroize an hmac_sha384_key structure
+ * @key: The hmac_sha384_key to zeroize
+ */
+static inline void hmac_sha384_zeroize_key(struct hmac_sha384_key *key)
+{
+	memzero_explicit(key, sizeof(*key));
+}
+
 /**
  * struct hmac_sha384_ctx - Context for computing HMAC-SHA384 of a message
  * @ctx: private
@@ -631,6 +677,15 @@ struct hmac_sha384_ctx {
 	struct __hmac_sha512_ctx ctx;
 };
 
+/**
+ * hmac_sha384_zeroize_ctx() - Zeroize an hmac_sha384_ctx structure
+ * @ctx: The hmac_sha384_ctx context to zeroize
+ */
+static inline void hmac_sha384_zeroize_ctx(struct hmac_sha384_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 /**
  * hmac_sha384_preparekey() - Prepare a key for HMAC-SHA384
  * @key: (output) the key structure to initialize
@@ -798,6 +853,15 @@ struct hmac_sha512_key {
 	struct __hmac_sha512_key key;
 };
 
+/**
+ * hmac_sha512_zeroize_key() - Zeroize an hmac_sha512_key structure
+ * @key: The hmac_sha512_key to zeroize
+ */
+static inline void hmac_sha512_zeroize_key(struct hmac_sha512_key *key)
+{
+	memzero_explicit(key, sizeof(*key));
+}
+
 /**
  * struct hmac_sha512_ctx - Context for computing HMAC-SHA512 of a message
  * @ctx: private
@@ -806,6 +870,15 @@ struct hmac_sha512_ctx {
 	struct __hmac_sha512_ctx ctx;
 };
 
+/**
+ * hmac_sha512_zeroize_ctx() - Zeroize an hmac_sha512_ctx structure
+ * @ctx: The hmac_sha512_ctx context to zeroize
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

