Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F401E25F2;
	Wed,  9 Jul 2025 01:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752022871; cv=none; b=mbseJeF1pl4rm9/JhR58hu+aNO6xXzooX5F18pv09Fbi370IUtf4Pb2e7NReSVtQOxUujtgWGJAT5Jp8UwZ6X4kgU3DSmU4rG9HTxG6hw4LpYBO2JPJItswZt5lNPw1u9c1XW6s7xM6dRWQjVbrjD3wQG9h1HJ1PrZGVmlm/7UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752022871; c=relaxed/simple;
	bh=p+1ebn6vNh2rTReGQh5//ZEGguo2HhmtUqjfNBzIbsA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ek9Ifmsp9L6dIBtSAeS2PYmxQgkInfQKPrJgUSxi4Q2GROFJ901HjxoorrtHlFatxinaSnZ4/4ERebdZNDH9MdDFSpUTLZAUrXzQLg3zso9JDE3C4a2wyX2RVkkcLpam6o4L6KD6Vl70KQwKZWwJOsLXNDbBk3SOSQj4DXp/GTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=siR4dsf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="siR4dsf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847C2C4CEED;
	Wed,  9 Jul 2025 01:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752022870;
	bh=p+1ebn6vNh2rTReGQh5//ZEGguo2HhmtUqjfNBzIbsA=;
	h=From:To:Cc:Subject:Date:From;
	b=siR4dsf+Qg4aH582lCEJSjNPrARp+yxvfN1ZWSiE0VArxrV7Wg0rvVbVzk3aAmR2C
	 fW0UvCJqV75pNUXKVLcMcnxxSbboD4E2OqJj1Ye/tjG+2f3SY7iy6ZRHxtdavW7rE7
	 w+FvKz4JzaB9I6sSneEhICDNVFWj9JT56JnbUPzCpCZ2437l3qvgyRY97HHOhJpwlB
	 EosXTkedkaLlnJKhgJCXeAOLLkSuSr4+FmMRT4hdgbR4jhQ7ZanxXiAtA6peZVEdyQ
	 FxY++8pR0lW+OzcFoQBLsk5cRFSn+hX4kmKnjL6QWEigl7j3PgY52G48MTw2gfqx8O
	 gQLXARE5hYghA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: acomp - Fix CFI failure due to type punning
Date: Tue,  8 Jul 2025 17:59:54 -0700
Message-ID: <20250709005954.155842-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To avoid a crash when control flow integrity is enabled, make the
workspace ("stream") free function use a consistent type, and call it
through a function pointer that has that same type.

Fixes: 42d9f6c77479 ("crypto: acomp - Move scomp stream allocation code into acomp")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/deflate.c                    | 7 ++++++-
 crypto/zstd.c                       | 7 ++++++-
 include/crypto/internal/acompress.h | 5 +----
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/crypto/deflate.c b/crypto/deflate.c
index fe8e4ad0fee10..21404515dc77e 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -46,13 +46,18 @@ static void *deflate_alloc_stream(void)
 	ctx->stream.workspace = ctx->workspace;
 
 	return ctx;
 }
 
+static void deflate_free_stream(void *ctx)
+{
+	kvfree(ctx);
+}
+
 static struct crypto_acomp_streams deflate_streams = {
 	.alloc_ctx = deflate_alloc_stream,
-	.cfree_ctx = kvfree,
+	.free_ctx = deflate_free_stream,
 };
 
 static int deflate_compress_one(struct acomp_req *req,
 				struct deflate_stream *ds)
 {
diff --git a/crypto/zstd.c b/crypto/zstd.c
index 657e0cf7b9524..ff5f596a4ea7e 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -52,13 +52,18 @@ static void *zstd_alloc_stream(void)
 	ctx->wksp_size = wksp_size;
 
 	return ctx;
 }
 
+static void zstd_free_stream(void *ctx)
+{
+	kvfree(ctx);
+}
+
 static struct crypto_acomp_streams zstd_streams = {
 	.alloc_ctx = zstd_alloc_stream,
-	.cfree_ctx = kvfree,
+	.free_ctx = zstd_free_stream,
 };
 
 static int zstd_init(struct crypto_acomp *acomp_tfm)
 {
 	int ret = 0;
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index ffffd88bbbad3..2d97440028ffd 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -61,14 +61,11 @@ struct crypto_acomp_stream {
 };
 
 struct crypto_acomp_streams {
 	/* These must come first because of struct scomp_alg. */
 	void *(*alloc_ctx)(void);
-	union {
-		void (*free_ctx)(void *);
-		void (*cfree_ctx)(const void *);
-	};
+	void (*free_ctx)(void *);
 
 	struct crypto_acomp_stream __percpu *streams;
 	struct work_struct stream_work;
 	cpumask_t stream_want;
 };

base-commit: 181698af38d3f93381229ad89c09b5bd0496661a
-- 
2.50.1

