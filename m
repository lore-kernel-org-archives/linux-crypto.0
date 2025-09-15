Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F02E25D917;
	Mon, 15 Sep 2025 16:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757952553; cv=none; b=BxC36X6F/ZS8/JVh2WfPjlnPehCQ3XTCbSpz9PP3WtTHvZPCtVmq+5vh96xtaj9Y+ov8r64sfftJ4dyW2lBkgIkiNgLTnMn1DdaifIh/eMoeDBz2dHjrUY9WL8ayiNuuXG5NZJDFLJGMPfu2JpkWewmXnfCTqH8I7MfSGcJX+Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757952553; c=relaxed/simple;
	bh=gj+fgAs1zZ9CeYNf/FEvftB7A3paX/EoqRRcTD8cP+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d83I4lbyIKxkJksKteoVD2V16qrcxNabfqDJS8gBIIu93wJRsCAiMlq397ILecNItDBuTggD5sKURq2tD7FyKs5k35ksfMMoUjdMGi7gcQHjdFrfJCUn23xWUJQ8urWTLQfVk5LzGMwKq+ZacZ6PnDFpwZBae+x5IjYqKKr8bNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=um1sGixW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="um1sGixW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AB9C4CEF7;
	Mon, 15 Sep 2025 16:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757952553;
	bh=gj+fgAs1zZ9CeYNf/FEvftB7A3paX/EoqRRcTD8cP+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=um1sGixWF2ADou7+Eck2eRZltfTfrMQK1Lak19pF1FVY2ockHA7V8Aq8VsfWlri2H
	 J1mq/1AfTeuIAnhT+MGPdozzO+ep1ZGIXHhYzB3dddncg/I1trgX3R+f48m1QiFMje
	 4F5P0GloyDJpkxZO07vnYkouDNq8ZrR8ceCIS/OWBAu278FhlFRPhvpCerG3Egqqtz
	 8fzenu5raxOoLchUHcvpeNzrKDU7tzbzpeqngJtn9CZeNnCdazsn39NoP2s+b392d0
	 rUkMTGfSj4Sl9cCqSAoS4o8CdkjvuPfWGSNr6Yfyey4xiQNEkvgUw1VPRepKc98jn+
	 i838epu/+VIaw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	x86@kernel.org,
	Sami Tolvanen <samitolvanen@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 1/6] lib/crypto: sha256: Add support for 2-way interleaved hashing
Date: Mon, 15 Sep 2025 11:08:14 -0500
Message-ID: <20250915160819.140019-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250915160819.140019-1-ebiggers@kernel.org>
References: <20250915160819.140019-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Many arm64 and x86_64 CPUs can compute two SHA-256 hashes in nearly the
same speed as one, if the instructions are interleaved.  This is because
SHA-256 is serialized block-by-block, and two interleaved hashes take
much better advantage of the CPU's instruction-level parallelism.

Meanwhile, a very common use case for SHA-256 hashing in the Linux
kernel is dm-verity and fs-verity.  Both use a Merkle tree that has a
fixed block size, usually 4096 bytes with an empty or 32-byte salt
prepended.  Usually, many blocks need to be hashed at a time.  This is
an ideal scenario for 2-way interleaved hashing.

To enable this optimization, add a new function sha256_finup_2x() to the
SHA-256 library API.  It computes the hash of two equal-length messages,
starting from a common initial context.

For now it always falls back to sequential processing.  Later patches
will wire up arm64 and x86_64 optimized implementations.

Note that the interleaving factor could in principle be higher than 2x.
However, that runs into many practical difficulties and CPU throughput
limitations.  Thus, both the implementations I'm adding are 2x.  In the
interest of using the simplest solution, the API matches that.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/sha2.h | 28 +++++++++++++++++
 lib/crypto/sha256.c   | 71 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 94 insertions(+), 5 deletions(-)

diff --git a/include/crypto/sha2.h b/include/crypto/sha2.h
index 15e461e568cca..e5dafb935cc88 100644
--- a/include/crypto/sha2.h
+++ b/include/crypto/sha2.h
@@ -373,10 +373,38 @@ void sha256_final(struct sha256_ctx *ctx, u8 out[SHA256_DIGEST_SIZE]);
  *
  * Context: Any context.
  */
 void sha256(const u8 *data, size_t len, u8 out[SHA256_DIGEST_SIZE]);
 
+/**
+ * sha256_finup_2x() - Compute two SHA-256 digests from a common initial
+ *		       context.  On some CPUs, this is faster than sequentially
+ *		       computing each digest.
+ * @ctx: an optional initial context, which may have already processed data.  If
+ *	 NULL, a default initial context is used (equivalent to sha256_init()).
+ * @data1: data for the first message
+ * @data2: data for the second message
+ * @len: the length of each of @data1 and @data2, in bytes
+ * @out1: (output) the first SHA-256 message digest
+ * @out2: (output) the second SHA-256 message digest
+ *
+ * Context: Any context.
+ */
+void sha256_finup_2x(const struct sha256_ctx *ctx, const u8 *data1,
+		     const u8 *data2, size_t len, u8 out1[SHA256_DIGEST_SIZE],
+		     u8 out2[SHA256_DIGEST_SIZE]);
+
+/**
+ * sha256_finup_2x_is_optimized() - Check if sha256_finup_2x() is using a real
+ *				    interleaved implementation, as opposed to a
+ *				    sequential fallback
+ * @return: true if optimized
+ *
+ * Context: Any context.
+ */
+bool sha256_finup_2x_is_optimized(void);
+
 /**
  * struct hmac_sha256_key - Prepared key for HMAC-SHA256
  * @key: private
  */
 struct hmac_sha256_key {
diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 8fa15165d23e8..881b935418cea 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -23,17 +23,24 @@ static const struct sha256_block_state sha224_iv = {
 		SHA224_H0, SHA224_H1, SHA224_H2, SHA224_H3,
 		SHA224_H4, SHA224_H5, SHA224_H6, SHA224_H7,
 	},
 };
 
-static const struct sha256_block_state sha256_iv = {
-	.h = {
-		SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
-		SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7,
+static const struct sha256_ctx initial_sha256_ctx = {
+	.ctx = {
+		.state = {
+			.h = {
+				SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
+				SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7,
+			},
+		},
+		.bytecount = 0,
 	},
 };
 
+#define sha256_iv (initial_sha256_ctx.ctx.state)
+
 static const u32 sha256_K[64] = {
 	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1,
 	0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
 	0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786,
 	0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
@@ -259,12 +266,66 @@ void sha256(const u8 *data, size_t len, u8 out[SHA256_DIGEST_SIZE])
 	sha256_update(&ctx, data, len);
 	sha256_final(&ctx, out);
 }
 EXPORT_SYMBOL(sha256);
 
-/* pre-boot environment (as indicated by __DISABLE_EXPORTS) doesn't need HMAC */
+/*
+ * Pre-boot environment (as indicated by __DISABLE_EXPORTS being defined)
+ * doesn't need either HMAC support or interleaved hashing support
+ */
 #ifndef __DISABLE_EXPORTS
+
+#ifndef sha256_finup_2x_arch
+static bool sha256_finup_2x_arch(const struct __sha256_ctx *ctx,
+				 const u8 *data1, const u8 *data2, size_t len,
+				 u8 out1[SHA256_DIGEST_SIZE],
+				 u8 out2[SHA256_DIGEST_SIZE])
+{
+	return false;
+}
+static bool sha256_finup_2x_is_optimized_arch(void)
+{
+	return false;
+}
+#endif
+
+/* Sequential fallback implementation of sha256_finup_2x() */
+static noinline_for_stack void sha256_finup_2x_sequential(
+	const struct __sha256_ctx *ctx, const u8 *data1, const u8 *data2,
+	size_t len, u8 out1[SHA256_DIGEST_SIZE], u8 out2[SHA256_DIGEST_SIZE])
+{
+	struct __sha256_ctx mut_ctx;
+
+	mut_ctx = *ctx;
+	__sha256_update(&mut_ctx, data1, len);
+	__sha256_final(&mut_ctx, out1, SHA256_DIGEST_SIZE);
+
+	mut_ctx = *ctx;
+	__sha256_update(&mut_ctx, data2, len);
+	__sha256_final(&mut_ctx, out2, SHA256_DIGEST_SIZE);
+}
+
+void sha256_finup_2x(const struct sha256_ctx *ctx, const u8 *data1,
+		     const u8 *data2, size_t len, u8 out1[SHA256_DIGEST_SIZE],
+		     u8 out2[SHA256_DIGEST_SIZE])
+{
+	if (ctx == NULL)
+		ctx = &initial_sha256_ctx;
+
+	if (likely(sha256_finup_2x_arch(&ctx->ctx, data1, data2, len, out1,
+					out2)))
+		return;
+	sha256_finup_2x_sequential(&ctx->ctx, data1, data2, len, out1, out2);
+}
+EXPORT_SYMBOL_GPL(sha256_finup_2x);
+
+bool sha256_finup_2x_is_optimized(void)
+{
+	return sha256_finup_2x_is_optimized_arch();
+}
+EXPORT_SYMBOL_GPL(sha256_finup_2x_is_optimized);
+
 static void __hmac_sha256_preparekey(struct sha256_block_state *istate,
 				     struct sha256_block_state *ostate,
 				     const u8 *raw_key, size_t raw_key_len,
 				     const struct sha256_block_state *iv)
 {
-- 
2.51.0

