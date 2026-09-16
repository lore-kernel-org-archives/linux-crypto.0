Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEA04B338A
	for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2026 09:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789552294; cv=none; b=DkFIUI6nCJQVf/MfaGWprhsxEfJdxDI3slCbOKyYKJZSQXfSYQAjCfCF/9qbc//1nzsWJwJK4Aft3JG6ByDjvHVHlopMDS1AcQwxR4FMmz+LGm1m0o0Xu6dLhPuCZGsyszjBtz31raaol+deiIgWJI+JbPpbwHbAwuy3X9mrIqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789552294; c=relaxed/simple;
	bh=8Nhgl85UqN7JQx2CBcnw7jYv6wkT5XU8Jx+KGKUJbB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptCnoOkJLD+/vmhclVT3Al2Vn3zT5VVZv1aiA+3rxeB1WpRuek71REfc+7L/WUQ0Peu+mjqr3fZcq2m81GS32L963M1cV1zA7eg/Y/+Vj2wrjNfkr7IiFiLlURhMvBDFY19E+caPhTfNBCqycOW+MDzhsKeQbxLHI+rZZXxaSDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U4Bg8dWF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U4Bg8dWF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789552271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ouNZYOOt8CIaEFrfD0VxsHURoh7bbScAMyQARtiv7Dg=;
	b=U4Bg8dWFnYOyq+p778L7aKRYkyju7l2yJJYa6Xbb9qvmkBqQWKwM1V6tsAjs6ND6wyVolB
	PIHJppfnW2G142L66Xzk9qDNw0KS71EwxZQqsp2qH8hMGX9uVxMy8a4IFop0wzKwd45k6v
	D5xrqjlt6vLbElKdNUOJ8LYTdbwjB28=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-502-Jt1XCjSpOPSY1HZei2dzpA-1; Wed,
 16 Sep 2026 05:51:06 -0400
X-MC-Unique: Jt1XCjSpOPSY1HZei2dzpA-1
X-Mimecast-MFC-AGG-ID: Jt1XCjSpOPSY1HZei2dzpA_1789552265
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 73702196F75A;
	Wed, 16 Sep 2026 09:51:01 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7B65B1800446;
	Wed, 16 Sep 2026 09:50:57 +0000 (UTC)
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
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH v4 07/13] lib/crypto: blake2: Provide functions for zeroizing blake2*_ctx structures
Date: Wed, 16 Sep 2026 11:50:09 +0200
Message-ID: <20260916095022.604354-8-thuth@redhat.com>
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

In certain cases crypto code needs to zeroize their local blake2b_ctx
or blake2s_ctx structures after use to avoid leaking sensitive material.
Provide blake2b_zeroize_ctx() and blake2s_zeroize_ctx() helper functions
that e.g. can be used with __cleanup() to automatically zeroize the
structures when they go out of scope.

While we're at it, replace the related memzero_explicit() calls in
lib/crypto/blake2*.c with calls to the new helper functions.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/crypto/blake2b.h | 9 +++++++++
 include/crypto/blake2s.h | 9 +++++++++
 lib/crypto/blake2b.c     | 2 +-
 lib/crypto/blake2s.c     | 2 +-
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/crypto/blake2b.h b/include/crypto/blake2b.h
index 3bc37fd103a7a..eda1604bce780 100644
--- a/include/crypto/blake2b.h
+++ b/include/crypto/blake2b.h
@@ -37,6 +37,15 @@ struct blake2b_ctx {
 	unsigned int outlen;
 };
 
+/**
+ * blake2b_zeroize_ctx() - Zeroize a blake2b_ctx structure
+ * @ctx: The blake2b_ctx to zeroize
+ */
+static inline void blake2b_zeroize_ctx(struct blake2b_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 enum blake2b_iv {
 	BLAKE2B_IV0 = 0x6A09E667F3BCC908ULL,
 	BLAKE2B_IV1 = 0xBB67AE8584CAA73BULL,
diff --git a/include/crypto/blake2s.h b/include/crypto/blake2s.h
index 648cb78243588..bb4e6870ed196 100644
--- a/include/crypto/blake2s.h
+++ b/include/crypto/blake2s.h
@@ -41,6 +41,15 @@ struct blake2s_ctx {
 	unsigned int outlen;
 };
 
+/**
+ * blake2s_zeroize_ctx() - Zeroize a blake2s_ctx structure
+ * @ctx: The blake2s_ctx to zeroize
+ */
+static inline void blake2s_zeroize_ctx(struct blake2s_ctx *ctx)
+{
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 enum blake2s_iv {
 	BLAKE2S_IV0 = 0x6A09E667UL,
 	BLAKE2S_IV1 = 0xBB67AE85UL,
diff --git a/lib/crypto/blake2b.c b/lib/crypto/blake2b.c
index 581b7f8486fae..55d6c437f311f 100644
--- a/lib/crypto/blake2b.c
+++ b/lib/crypto/blake2b.c
@@ -148,7 +148,7 @@ void blake2b_final(struct blake2b_ctx *ctx, u8 *out)
 	blake2b_compress(ctx, ctx->buf, 1, ctx->buflen);
 	cpu_to_le64_array(ctx->h, ARRAY_SIZE(ctx->h));
 	memcpy(out, ctx->h, ctx->outlen);
-	memzero_explicit(ctx, sizeof(*ctx));
+	blake2b_zeroize_ctx(ctx);
 }
 EXPORT_SYMBOL(blake2b_final);
 
diff --git a/lib/crypto/blake2s.c b/lib/crypto/blake2s.c
index 71578a0847423..24f7f34334b01 100644
--- a/lib/crypto/blake2s.c
+++ b/lib/crypto/blake2s.c
@@ -142,7 +142,7 @@ void blake2s_final(struct blake2s_ctx *ctx, u8 *out)
 	blake2s_compress(ctx, ctx->buf, 1, ctx->buflen);
 	cpu_to_le32_array(ctx->h, ARRAY_SIZE(ctx->h));
 	memcpy(out, ctx->h, ctx->outlen);
-	memzero_explicit(ctx, sizeof(*ctx));
+	blake2s_zeroize_ctx(ctx);
 }
 EXPORT_SYMBOL(blake2s_final);
 
-- 
2.55.0

