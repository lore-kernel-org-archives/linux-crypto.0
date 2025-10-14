Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85703054E7;
	Tue, 14 Oct 2025 21:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760476627; cv=none; b=JajFRojgCsFvB4FmmRN/iPNqq6HomwZiBq3vmqLpY8i1hcVhrPD+mbdUhAQ+92Y1Z9vHut4+j5bhJGR9cn/ZfD1XLE5laq4mgokc/EljgzbCfLK9jOsVCxFRRS55sZkjDE36QO1Ep2kPpG+DunPFZ8YSkxOoEyWY8wlL8TaYdb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760476627; c=relaxed/simple;
	bh=GQqRG0Qhhlu34lcPLJ619xauhWCSz2lh/zQ9duPhve8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qec4dMfveCOuc1rnWI+o7bMTczsAzeZG5Qc/NxyenqOiRaT+u5SnJJjvT+c2DoGj+DZp+/VSeekzlsMDzSNkN0x+b6uiMbpa6ddm3Isiv5ealoYZHoBWd/Qrn8tsHopLpuhhKU4+Czldpq8lBh4DiXkXfolHANDuR/054f27qzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tuRdAwK+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tuRdAwK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033C0C4CEFE;
	Tue, 14 Oct 2025 21:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760476627;
	bh=GQqRG0Qhhlu34lcPLJ619xauhWCSz2lh/zQ9duPhve8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tuRdAwK+J4Jy6UMccTumuiN1f6WGQdMTlvTvJkzBmOZWNU1Qf9/S2TbnJbvLHVk1V
	 riQX8zoW2oDNgRtOXmOkz2dQFtdGlAZ4OBOxN4hCzp/6/4+sF+qwW3hDJ/fbOoMw7q
	 mv0E+AAtP3dSfpOJgljZyO4N7QHKjNlP+c8OJ18n4rmOq4t+G5aoTupKkZRg8/8gxo
	 1sHsPRXtvgPPgX/UYc/C/+/fmPO9RSok697XbRcA1ROn04Qtlbeo9Fr98ZYxILY6uK
	 b+uiU95ZAAYaQ1fkmpTkRcdwUjBWwwdJ13aY3sJDC/YnzSnwHet/vqjrJHIX+xgE0R
	 k3CuP9CtdRAEA==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/4] dm-verity: use SHA-256 library for SHA-256
Date: Tue, 14 Oct 2025 14:16:55 -0700
Message-ID: <20251014211657.113603-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251014211657.113603-1-ebiggers@kernel.org>
References: <20251014211657.113603-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the hash algorithm is SHA-256 and the verity version is not 0, use
the SHA-256 library instead of crypto_shash.

This is a prerequisite for making dm-verity interleave the computation
of SHA-256 hashes for increased performance.  That optimization is
available in the SHA-256 library but not in crypto_shash.

Even without interleaved hashing, switching to the library also slightly
improves performance by itself because it avoids the overhead of
crypto_shash, including indirect calls and other API overhead.
(Benchmark on x86_64, AMD Zen 5: hashing 4K blocks gets 2.1% faster.)

SHA-256 is by far the most common hash algorithm used with dm-verity.
It makes sense to optimize for the common case and fall back to the
generic crypto layer for uncommon cases, as suggested by Linus:
https://lore.kernel.org/r/CAHk-=wgp-fOSsZsYrbyzqCAfEvrt5jQs1jL-97Wc4seMNTUyng@mail.gmail.com

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/Kconfig            |  1 +
 drivers/md/dm-verity-target.c | 61 +++++++++++++++++++++++++++--------
 drivers/md/dm-verity.h        | 20 +++++++++---
 3 files changed, 64 insertions(+), 18 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 104aa53550905..cac4926fc3401 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -544,10 +544,11 @@ config DM_FLAKEY
 config DM_VERITY
 	tristate "Verity target support"
 	depends on BLK_DEV_DM
 	select CRYPTO
 	select CRYPTO_HASH
+	select CRYPTO_LIB_SHA256
 	select DM_BUFIO
 	help
 	  This device-mapper target creates a read-only device that
 	  transparently validates the data on one underlying device against
 	  a pre-generated tree of cryptographic checksums stored on a second
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 20ddf560d22e3..bba9810805631 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -115,23 +115,37 @@ static sector_t verity_position_at_level(struct dm_verity *v, sector_t block,
 }
 
 int verity_hash(struct dm_verity *v, struct dm_verity_io *io,
 		const u8 *data, size_t len, u8 *digest)
 {
-	struct shash_desc *desc = &io->hash_desc;
+	struct shash_desc *desc;
 	int r;
 
+	if (likely(v->use_sha256_lib)) {
+		struct sha256_ctx *ctx = &io->hash_ctx.sha256;
+
+		/*
+		 * Fast path using SHA-256 library.  This is enabled only for
+		 * verity version 1, where the salt is at the beginning.
+		 */
+		*ctx = *v->initial_hashstate.sha256;
+		sha256_update(ctx, data, len);
+		sha256_final(ctx, digest);
+		return 0;
+	}
+
+	desc = &io->hash_ctx.shash;
 	desc->tfm = v->shash_tfm;
-	if (unlikely(v->initial_hashstate == NULL)) {
+	if (unlikely(v->initial_hashstate.shash == NULL)) {
 		/* Version 0: salt at end */
 		r = crypto_shash_init(desc) ?:
 		    crypto_shash_update(desc, data, len) ?:
 		    crypto_shash_update(desc, v->salt, v->salt_size) ?:
 		    crypto_shash_final(desc, digest);
 	} else {
 		/* Version 1: salt at beginning */
-		r = crypto_shash_import(desc, v->initial_hashstate) ?:
+		r = crypto_shash_import(desc, v->initial_hashstate.shash) ?:
 		    crypto_shash_finup(desc, data, len, digest);
 	}
 	if (unlikely(r))
 		DMERR("Error hashing block: %d", r);
 	return r;
@@ -1002,11 +1016,11 @@ static void verity_dtr(struct dm_target *ti)
 	if (v->bufio)
 		dm_bufio_client_destroy(v->bufio);
 
 	kvfree(v->validated_blocks);
 	kfree(v->salt);
-	kfree(v->initial_hashstate);
+	kfree(v->initial_hashstate.shash);
 	kfree(v->root_digest);
 	kfree(v->zero_digest);
 	verity_free_sig(v);
 
 	crypto_free_shash(v->shash_tfm);
@@ -1067,12 +1081,11 @@ static int verity_alloc_zero_digest(struct dm_verity *v)
 	v->zero_digest = kmalloc(v->digest_size, GFP_KERNEL);
 
 	if (!v->zero_digest)
 		return r;
 
-	io = kmalloc(sizeof(*io) + crypto_shash_descsize(v->shash_tfm),
-		     GFP_KERNEL);
+	io = kmalloc(v->ti->per_io_data_size, GFP_KERNEL);
 
 	if (!io)
 		return r; /* verity_dtr will free zero_digest */
 
 	zero_data = kzalloc(1 << v->data_dev_block_bits, GFP_KERNEL);
@@ -1254,10 +1267,24 @@ static int verity_setup_hash_alg(struct dm_verity *v, const char *alg_name)
 	v->digest_size = crypto_shash_digestsize(shash);
 	if ((1 << v->hash_dev_block_bits) < v->digest_size * 2) {
 		ti->error = "Digest size too big";
 		return -EINVAL;
 	}
+	if (likely(v->version && strcmp(alg_name, "sha256") == 0)) {
+		/*
+		 * Fast path: use the library API for reduced overhead and
+		 * interleaved hashing support.
+		 */
+		v->use_sha256_lib = true;
+		ti->per_io_data_size =
+			offsetofend(struct dm_verity_io, hash_ctx.sha256);
+	} else {
+		/* Fallback case: use the generic crypto API. */
+		ti->per_io_data_size =
+			offsetofend(struct dm_verity_io, hash_ctx.shash) +
+			crypto_shash_descsize(shash);
+	}
 	return 0;
 }
 
 static int verity_setup_salt_and_hashstate(struct dm_verity *v, const char *arg)
 {
@@ -1274,28 +1301,39 @@ static int verity_setup_salt_and_hashstate(struct dm_verity *v, const char *arg)
 		    hex2bin(v->salt, arg, v->salt_size)) {
 			ti->error = "Invalid salt";
 			return -EINVAL;
 		}
 	}
-	if (v->version) { /* Version 1: salt at beginning */
+	if (likely(v->use_sha256_lib)) {
+		/* Implies version 1: salt at beginning */
+		v->initial_hashstate.sha256 =
+			kmalloc(sizeof(struct sha256_ctx), GFP_KERNEL);
+		if (!v->initial_hashstate.sha256) {
+			ti->error = "Cannot allocate initial hash state";
+			return -ENOMEM;
+		}
+		sha256_init(v->initial_hashstate.sha256);
+		sha256_update(v->initial_hashstate.sha256,
+			      v->salt, v->salt_size);
+	} else if (v->version) { /* Version 1: salt at beginning */
 		SHASH_DESC_ON_STACK(desc, v->shash_tfm);
 		int r;
 
 		/*
 		 * Compute the pre-salted hash state that can be passed to
 		 * crypto_shash_import() for each block later.
 		 */
-		v->initial_hashstate = kmalloc(
+		v->initial_hashstate.shash = kmalloc(
 			crypto_shash_statesize(v->shash_tfm), GFP_KERNEL);
-		if (!v->initial_hashstate) {
+		if (!v->initial_hashstate.shash) {
 			ti->error = "Cannot allocate initial hash state";
 			return -ENOMEM;
 		}
 		desc->tfm = v->shash_tfm;
 		r = crypto_shash_init(desc) ?:
 		    crypto_shash_update(desc, v->salt, v->salt_size) ?:
-		    crypto_shash_export(desc, v->initial_hashstate);
+		    crypto_shash_export(desc, v->initial_hashstate.shash);
 		if (r) {
 			ti->error = "Cannot set up initial hash state";
 			return r;
 		}
 	}
@@ -1553,13 +1591,10 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		ti->error = "Cannot allocate workqueue";
 		r = -ENOMEM;
 		goto bad;
 	}
 
-	ti->per_io_data_size = sizeof(struct dm_verity_io) +
-			       crypto_shash_descsize(v->shash_tfm);
-
 	r = verity_fec_ctr(v);
 	if (r)
 		goto bad;
 
 	ti->per_io_data_size = roundup(ti->per_io_data_size,
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 6d141abd965c7..cdcee68a4bc0a 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -14,10 +14,11 @@
 #include <linux/dm-io.h>
 #include <linux/dm-bufio.h>
 #include <linux/device-mapper.h>
 #include <linux/interrupt.h>
 #include <crypto/hash.h>
+#include <crypto/sha2.h>
 
 #define DM_VERITY_MAX_LEVELS		63
 
 enum verity_mode {
 	DM_VERITY_MODE_EIO,
@@ -40,11 +41,14 @@ struct dm_verity {
 	struct dm_bufio_client *bufio;
 	char *alg_name;
 	struct crypto_shash *shash_tfm;
 	u8 *root_digest;	/* digest of the root block */
 	u8 *salt;		/* salt: its size is salt_size */
-	u8 *initial_hashstate;	/* salted initial state, if version >= 1 */
+	union {
+		struct sha256_ctx *sha256;	/* for use_sha256_lib=1 */
+		u8 *shash;			/* for use_sha256_lib=0 */
+	} initial_hashstate; /* salted initial state, if version >= 1 */
 	u8 *zero_digest;	/* digest for a zero block */
 #ifdef CONFIG_SECURITY
 	u8 *root_digest_sig;	/* signature of the root digest */
 	unsigned int sig_size;	/* root digest signature size */
 #endif /* CONFIG_SECURITY */
@@ -57,10 +61,11 @@ struct dm_verity {
 	unsigned char hash_per_block_bits;	/* log2(hashes in hash block) */
 	unsigned char levels;	/* the number of tree levels */
 	unsigned char version;
 	bool hash_failed:1;	/* set if hash of any block failed */
 	bool use_bh_wq:1;	/* try to verify in BH wq before normal work-queue */
+	bool use_sha256_lib:1;	/* use SHA-256 library instead of generic crypto API */
 	unsigned int digest_size;	/* digest size for the current hash algorithm */
 	enum verity_mode mode;	/* mode for handling verification errors */
 	enum verity_mode error_mode;/* mode for handling I/O errors */
 	unsigned int corrupted_errs;/* Number of errors for corrupted blocks */
 
@@ -96,15 +101,20 @@ struct dm_verity_io {
 
 	u8 real_digest[HASH_MAX_DIGESTSIZE];
 	u8 want_digest[HASH_MAX_DIGESTSIZE];
 
 	/*
-	 * Temporary space for hashing.  This is variable-length and must be at
-	 * the end of the struct.  struct shash_desc is just the fixed part;
-	 * it's followed by a context of size crypto_shash_descsize(shash_tfm).
+	 * Temporary space for hashing.  Either sha256 or shash is used,
+	 * depending on the value of use_sha256_lib.  If shash is used,
+	 * then this field is variable-length, with total size
+	 * sizeof(struct shash_desc) + crypto_shash_descsize(shash_tfm).
+	 * For this reason, this field must be the end of the struct.
 	 */
-	struct shash_desc hash_desc;
+	union {
+		struct sha256_ctx sha256;
+		struct shash_desc shash;
+	} hash_ctx;
 };
 
 static inline u8 *verity_io_real_digest(struct dm_verity *v,
 					struct dm_verity_io *io)
 {
-- 
2.51.0

