Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673702701B8;
	Mon, 15 Sep 2025 16:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757952559; cv=none; b=SwuG/xmC3geGjgAPzyb/t0XMjPDFwIr69wBe7TG+sfIJTBNfBrcdkCkB/9Tx4KrLdTXkDuJw0mVwJz1wyA3q643/fheprqbWI4XfCvS67kcE7fc25wb79/JiOGKGZTpRZA2skgOcd8O6zoWnBxBtM690usOKul95QxeVt8zubYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757952559; c=relaxed/simple;
	bh=QlXjFWDuIZ5Q91ysSw6RnwWPX7rDoxkJzLK13J6/BvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBDhuXG2WCOcqhfXS0rTkcJhEAenNz87IBXBkxYu/L2PDyS2Ave3CRDEonnPev33dEGz3rVNR5rJqnw95zk+rz5eRrCxc94s6D5oN3CXP6HkDnxmhHy42huNN30o7uYTfjfCzPyvuKRHy2CnIsQoQ0L46uP6EHpq6rgG6lG0uk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ekbXC5n0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ekbXC5n0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098A3C4CEFD;
	Mon, 15 Sep 2025 16:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757952559;
	bh=QlXjFWDuIZ5Q91ysSw6RnwWPX7rDoxkJzLK13J6/BvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekbXC5n0FLvzvBeRPluIRi+2hVD8B2A+PfYAMbVW9WMyyxJjRAgDHUknxb+gGelLU
	 No8L0eh94TPy8UvP+VvfL6UJmzhoeKTvTiCrgCskyWTE+aTAUlU3mLgZF2BR14hYw6
	 G0cDACes2Qv3gxu6b6zHMea02RGAboGI/i7wccufletQW/ec5Dfifyvhi61g6lT1qc
	 8yK2+Y/jGN9BIP6fbWiOtBkmA6IqePh36ZKwO5dp21sPrDnHZVgi5NCG2++arkDaHh
	 J6QypfxLVqoqV6S/bRx46oty54bAyLTVcFvP1/mFdyOynA4AZctZkL0KXnKa77UKzH
	 Ow/7SUB6ZzMhQ==
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
Subject: [PATCH v2 5/6] fsverity: Remove inode parameter from fsverity_hash_block()
Date: Mon, 15 Sep 2025 11:08:18 -0500
Message-ID: <20250915160819.140019-6-ebiggers@kernel.org>
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

Due to the conversion from crypto_shash to the library API,
fsverity_hash_block() can no longer fail.  Therefore, the inode
parameter, which was used only to print an error message in the case of
a failure, is no longer necessary.  Remove it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/verity/enable.c           | 12 +++++-------
 fs/verity/fsverity_private.h |  2 +-
 fs/verity/hash_algs.c        |  3 +--
 fs/verity/verify.c           |  4 ++--
 4 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index 503268cf42962..f2f5b0471b6b2 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -17,12 +17,11 @@ struct block_buffer {
 	bool is_root_hash;
 	u8 *data;
 };
 
 /* Hash a block, writing the result to the next level's pending block buffer. */
-static int hash_one_block(struct inode *inode,
-			  const struct merkle_tree_params *params,
+static int hash_one_block(const struct merkle_tree_params *params,
 			  struct block_buffer *cur)
 {
 	struct block_buffer *next = cur + 1;
 
 	/*
@@ -34,12 +33,11 @@ static int hash_one_block(struct inode *inode,
 		return -EINVAL;
 
 	/* Zero-pad the block if it's shorter than the block size. */
 	memset(&cur->data[cur->filled], 0, params->block_size - cur->filled);
 
-	fsverity_hash_block(params, inode, cur->data,
-			    &next->data[next->filled]);
+	fsverity_hash_block(params, cur->data, &next->data[next->filled]);
 	next->filled += params->digest_size;
 	cur->filled = 0;
 	return 0;
 }
 
@@ -121,22 +119,22 @@ static int build_merkle_tree(struct file *filp,
 		if (bytes_read != buffers[-1].filled) {
 			err = -EINVAL;
 			fsverity_err(inode, "Short read of file data");
 			goto out;
 		}
-		err = hash_one_block(inode, params, &buffers[-1]);
+		err = hash_one_block(params, &buffers[-1]);
 		if (err)
 			goto out;
 		for (level = 0; level < num_levels; level++) {
 			if (buffers[level].filled + params->digest_size <=
 			    params->block_size) {
 				/* Next block at @level isn't full yet */
 				break;
 			}
 			/* Next block at @level is full */
 
-			err = hash_one_block(inode, params, &buffers[level]);
+			err = hash_one_block(params, &buffers[level]);
 			if (err)
 				goto out;
 			err = write_merkle_tree_block(inode,
 						      buffers[level].data,
 						      level_offset[level],
@@ -152,11 +150,11 @@ static int build_merkle_tree(struct file *filp,
 		cond_resched();
 	}
 	/* Finish all nonempty pending tree blocks. */
 	for (level = 0; level < num_levels; level++) {
 		if (buffers[level].filled != 0) {
-			err = hash_one_block(inode, params, &buffers[level]);
+			err = hash_one_block(params, &buffers[level]);
 			if (err)
 				goto out;
 			err = write_merkle_tree_block(inode,
 						      buffers[level].data,
 						      level_offset[level],
diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index 5fe854a5b9ad3..d0458877afea4 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -87,11 +87,11 @@ const struct fsverity_hash_alg *fsverity_get_hash_alg(const struct inode *inode,
 						      unsigned int num);
 union fsverity_hash_ctx *
 fsverity_prepare_hash_state(const struct fsverity_hash_alg *alg,
 			    const u8 *salt, size_t salt_size);
 void fsverity_hash_block(const struct merkle_tree_params *params,
-			 const struct inode *inode, const void *data, u8 *out);
+			 const void *data, u8 *out);
 void fsverity_hash_buffer(const struct fsverity_hash_alg *alg,
 			  const void *data, size_t size, u8 *out);
 void __init fsverity_check_hash_algs(void);
 
 /* init.c */
diff --git a/fs/verity/hash_algs.c b/fs/verity/hash_algs.c
index 9bb3c6344907e..de53e14c8aa78 100644
--- a/fs/verity/hash_algs.c
+++ b/fs/verity/hash_algs.c
@@ -92,19 +92,18 @@ fsverity_prepare_hash_state(const struct fsverity_hash_alg *alg,
 }
 
 /**
  * fsverity_hash_block() - hash a single data or hash block
  * @params: the Merkle tree's parameters
- * @inode: inode for which the hashing is being done
  * @data: virtual address of a buffer containing the block to hash
  * @out: output digest, size 'params->digest_size' bytes
  *
  * Hash a single data or hash block.  The hash is salted if a salt is specified
  * in the Merkle tree parameters.
  */
 void fsverity_hash_block(const struct merkle_tree_params *params,
-			 const struct inode *inode, const void *data, u8 *out)
+			 const void *data, u8 *out)
 {
 	union fsverity_hash_ctx ctx;
 
 	if (!params->hashstate) {
 		fsverity_hash_buffer(params->hash_alg, data, params->block_size,
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index a1f00c3fd3b27..d7d5f65700b03 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -200,11 +200,11 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 		struct page *hpage = hblocks[level - 1].page;
 		const void *haddr = hblocks[level - 1].addr;
 		unsigned long hblock_idx = hblocks[level - 1].index;
 		unsigned int hoffset = hblocks[level - 1].hoffset;
 
-		fsverity_hash_block(params, inode, haddr, real_hash);
+		fsverity_hash_block(params, haddr, real_hash);
 		if (memcmp(want_hash, real_hash, hsize) != 0)
 			goto corrupted;
 		/*
 		 * Mark the hash block as verified.  This must be atomic and
 		 * idempotent, as the same hash block might be verified by
@@ -219,11 +219,11 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 		kunmap_local(haddr);
 		put_page(hpage);
 	}
 
 	/* Finally, verify the data block. */
-	fsverity_hash_block(params, inode, data, real_hash);
+	fsverity_hash_block(params, data, real_hash);
 	if (memcmp(want_hash, real_hash, hsize) != 0)
 		goto corrupted;
 	return true;
 
 corrupted:
-- 
2.51.0

