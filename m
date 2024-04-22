Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3753D1B948;
	Mon, 22 Apr 2024 20:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713818162; cv=none; b=rNwtGhuWuoQOmIQ67x7OHMEybugKBPLzy7Tx89TMWK2U6WbAmggsAkLCYJTEgBUMSZw6Gu9EgAgZvWAGkm3LCvZ0hug3wMidAfKsLJMo7bdoEt97RsfCQFVZ61jpebEQZK6UqJU439uz/diuwLJL1tm5Qxhl1ZMHBFgrPIJvPsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713818162; c=relaxed/simple;
	bh=XeEp/lH/EzLpu3vZNqTNnlBpKE1ibOVuDw3pXhUB0GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2UXLTLJ2R8JL02af6rau7jaWYLeUeTURF5t6GAZxrD3UBXJFDZi+XY0pCI5C6DXUz9tpwFf3iQURP5L7GH8BqGmXQ3LuUyhRdHzNs7gT1PaGjH2wiANUQGSZIeWkn0IzzGSIZEPvdH0t6FysdC3oCh0o0pxyUzgndtX2vgW308=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DseM/aCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DseM/aCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CB2C32782;
	Mon, 22 Apr 2024 20:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713818161;
	bh=XeEp/lH/EzLpu3vZNqTNnlBpKE1ibOVuDw3pXhUB0GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DseM/aCqpZEGhnq/nk8bVPCjVeK/BkNQvFAesoIw+qAL9ZAUE+5v08bC7p+52rlQU
	 v/hNp7tRoUx8GWG4E/DTb1ZlDMb21oZLJc9d7A3LiOlDrZXSPLNlk9VrZkowvU88FN
	 adY5KNY2xbRz3cAyZ7pFl6zpINcZzkSW2FLpyjb6PsMzt0LrDTtE7Iid+xz4TeHEUW
	 zMhxQ0EUPDEH3G7WnQ77rQ6L3gYmSzqUQGRDZ/SUdvmAl/OzaLzv6iQNIdJHzNsXe5
	 Hw4BB2MegpwqUq+/rFZBxHxgICULUGoW6OrkPvZPRcsZdwjjHqf0pkxT1B9N+4h5TY
	 FFAK5it6YfLFQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 1/8] crypto: shash - add support for finup2x
Date: Mon, 22 Apr 2024 13:35:37 -0700
Message-ID: <20240422203544.195390-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422203544.195390-1-ebiggers@kernel.org>
References: <20240422203544.195390-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Most cryptographic hash functions are serialized, in the sense that they
have an internal block size and the blocks must be processed serially.
(BLAKE3 is a notable exception that has tree-based hashing built-in, but
all the more common choices such as the SHAs and BLAKE2 are serialized.
ParallelHash and Sakura are parallel hashes based on SHA3, but SHA3 is
much slower than SHA256 in software even with the ARMv8 SHA3 extension.)

This limits the performance of computing a single hash.  Yet, computing
multiple hashes simultaneously does not have this limitation.  Modern
CPUs are superscalar and often can execute independent instructions in
parallel.  As a result, on many modern CPUs, it is possible to hash two
equal-length messages in about the same time as a single message, if all
the instructions are interleaved.

Meanwhile, a very common use case for hashing in the Linux kernel is
dm-verity and fs-verity.  Both use a Merkle tree that has a fixed block
size, usually 4096 bytes with an empty or 32-byte salt prepended.  The
hash algorithm is usually SHA-256.  Usually, many blocks need to be
hashed at a time.  This is an ideal scenario for multibuffer hashing.

Linux actually used to support SHA-256 multibuffer hashing on x86_64,
before it was removed by commit ab8085c130ed ("crypto: x86 - remove SHA
multibuffer routines and mcryptd").  However, it was integrated with the
crypto API in a weird way, where it behaved as an asynchronous hash that
queued up and executed all requests on a global queue.  This made it
very complex, buggy, and virtually unusable.

This patch takes a new approach of just adding an API
crypto_shash_finup2x() that synchronously computes the hash of two
equal-length messages, starting from a common state that represents the
(possibly empty) common prefix shared by the two messages.

The new API is part of the "shash" algorithm type, as it does not make
sense in "ahash".  It does a "finup" operation rather than a "digest"
operation in order to support the salt that is used by dm-verity and
fs-verity.  There is no fallback implementation that does two regular
finups if the underlying algorithm doesn't support finup2x, since users
probably will want to avoid the overhead of queueing up multiple hashes
when multibuffer hashing won't actually be used anyway.

For now the API only supports 2-way interleaving, as the usefulness and
practicality seems to drop off dramatically after 2.  The arm64 CPUs I
tested don't support more than 2 concurrent SHA-256 hashes.  On x86_64,
AMD's Zen 4 can do 4 concurrent SHA-256 hashes (at least based on a
microbenchmark of the sha256rnds2 instruction), and it's been reported
that the highest SHA-256 throughput on Intel processors comes from using
AVX512 to compute 16 hashes in parallel.  However, higher interleaving
factors would involve tradeoffs such as no longer being able to cache
the round constants in registers, further increasing the code size (both
source and binary), further increasing the amount of state that users
need to keep track of, and causing there to be more "leftover" hashes.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/hash.h | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 0014bdd81ab7..66d93c940861 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -177,10 +177,13 @@ struct shash_desc {
  * @finup: see struct ahash_alg
  * @digest: see struct ahash_alg
  * @export: see struct ahash_alg
  * @import: see struct ahash_alg
  * @setkey: see struct ahash_alg
+ * @finup2x: **[optional]** Finish calculating the digests of two equal-length
+ *	     messages, interleaving the instructions to potentially achieve
+ *	     better performance than hashing each message individually.
  * @init_tfm: Initialize the cryptographic transformation object.
  *	      This function is called only once at the instantiation
  *	      time, right after the transformation context was
  *	      allocated. In case the cryptographic hardware has
  *	      some special requirements which need to be handled
@@ -208,10 +211,12 @@ struct shash_alg {
 		      unsigned int len, u8 *out);
 	int (*export)(struct shash_desc *desc, void *out);
 	int (*import)(struct shash_desc *desc, const void *in);
 	int (*setkey)(struct crypto_shash *tfm, const u8 *key,
 		      unsigned int keylen);
+	int (*finup2x)(struct shash_desc *desc, const u8 *data1,
+		       const u8 *data2, unsigned int len, u8 *out1, u8 *out2);
 	int (*init_tfm)(struct crypto_shash *tfm);
 	void (*exit_tfm)(struct crypto_shash *tfm);
 	int (*clone_tfm)(struct crypto_shash *dst, struct crypto_shash *src);
 
 	unsigned int descsize;
@@ -749,10 +754,15 @@ static inline unsigned int crypto_shash_digestsize(struct crypto_shash *tfm)
 static inline unsigned int crypto_shash_statesize(struct crypto_shash *tfm)
 {
 	return crypto_shash_alg(tfm)->statesize;
 }
 
+static inline bool crypto_shash_supports_finup2x(struct crypto_shash *tfm)
+{
+	return crypto_shash_alg(tfm)->finup2x != NULL;
+}
+
 static inline u32 crypto_shash_get_flags(struct crypto_shash *tfm)
 {
 	return crypto_tfm_get_flags(crypto_shash_tfm(tfm));
 }
 
@@ -842,10 +852,34 @@ int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
  * Return: 0 on success; < 0 if an error occurred.
  */
 int crypto_shash_tfm_digest(struct crypto_shash *tfm, const u8 *data,
 			    unsigned int len, u8 *out);
 
+/**
+ * crypto_shash_finup2x() - finish hashing two equal-length messages
+ * @desc: the hash state that will be forked for the two messages.  This
+ *	  contains the state after hashing a (possibly-empty) common prefix of
+ *	  the two messages.
+ * @data1: the first message (not including any common prefix from @desc)
+ * @data2: the second message (not including any common prefix from @desc)
+ * @len: length of @data1 and @data2 in bytes
+ * @out1: output buffer for first message digest
+ * @out2: output buffer for second message digest
+ *
+ * Users must check crypto_shash_supports_finup2x(tfm) before calling this.
+ *
+ * Context: Any context.
+ * Return: 0 on success; a negative errno value on failure.
+ */
+static inline int crypto_shash_finup2x(struct shash_desc *desc,
+				       const u8 *data1, const u8 *data2,
+				       unsigned int len, u8 *out1, u8 *out2)
+{
+	return crypto_shash_alg(desc->tfm)->finup2x(desc, data1, data2, len,
+						    out1, out2);
+}
+
 /**
  * crypto_shash_export() - extract operational state for message digest
  * @desc: reference to the operational state handle whose state is exported
  * @out: output buffer of sufficient size that can hold the hash state
  *
-- 
2.44.0

