Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CF717109D;
	Tue, 11 Jun 2024 03:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718077755; cv=none; b=oqv2czeRYr8ZywspvzD5eyCEZpSWTk452hBBE0TDsKDlgcGcgu7OL75GxvB3HHXGeXlpCe20nL9pAYiYqVSDVfZFIzlChulPnczzDXrWhFZeRsE2PuBZ1AOY+yBZClnxNV7TG8YowQQnzz2KIWRweqi5r6B8ZnWaQ5afiITDMdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718077755; c=relaxed/simple;
	bh=7xT8iSkdXZmfe7HplWpRU3dl8gRd/9Mg4ADBs1YgLRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KsA9L/ZMb3ZxOQhke7OE3sbjYbGUBP4xY9MWxPl59xZwMTSHLYG3apGOcbgIEjrPHXlFaKTHrA+YR9wR8+vrHXFlDxW3j3LJDacLD24H2qGj4IF19KxhXrJkhjnqxyzIeGeddRS80LfuAvuHM+K5aQh3p7LREt33tEvVLiZgmzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JsuJJLbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JsuJJLbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DCAC2BD10;
	Tue, 11 Jun 2024 03:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718077755;
	bh=7xT8iSkdXZmfe7HplWpRU3dl8gRd/9Mg4ADBs1YgLRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JsuJJLbnHORxjXHxUPcxAOZRBA1YPVSbXyQhPgWZCNa5tCt0UR+P+iryn5LqJlzcj
	 fA93tZZi3MBQa8OENcnnbSev1VNvHBvmWttecvTJUqcHxIcO1Tq56pBVYCXvnL3imD
	 8F/sb8pMdaXEFu906+mCmyaFz4pZRR0qy84sr4XH5RcoAO1ct0HGgFBkVzNqkp38FR
	 Ch3lUdLqwY4VhzJA8wFD1Q1ynnHpq58kJ9CIXF+n2VlIyR+SArpkuHT8qPcY0a2fYC
	 1dTOzeqEn/ZV+AUqi30JocD85hpSf9cbhL9eiopo7bvxxs0WADdlzSzlI9/UxqSBtS
	 8QjD70W7BweMA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v5 12/15] dm-verity: make verity_hash() take dm_verity_io instead of ahash_request
Date: Mon, 10 Jun 2024 20:48:19 -0700
Message-ID: <20240611034822.36603-13-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240611034822.36603-1-ebiggers@kernel.org>
References: <20240611034822.36603-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

In preparation for adding shash support to dm-verity, change
verity_hash() to take a pointer to a struct dm_verity_io instead of a
pointer to the ahash_request embedded inside it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-fec.c    |  6 ++----
 drivers/md/dm-verity-target.c | 21 ++++++++++-----------
 drivers/md/dm-verity.h        |  2 +-
 3 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index b838d21183b5..62b1a44b8dd2 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -184,12 +184,11 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
  * Locate data block erasures using verity hashes.
  */
 static int fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
 			  u8 *want_digest, u8 *data)
 {
-	if (unlikely(verity_hash(v, verity_io_hash_req(v, io),
-				 data, 1 << v->data_dev_block_bits,
+	if (unlikely(verity_hash(v, io, data, 1 << v->data_dev_block_bits,
 				 verity_io_real_digest(v, io), true)))
 		return 0;
 
 	return memcmp(verity_io_real_digest(v, io), want_digest,
 		      v->digest_size) != 0;
@@ -386,12 +385,11 @@ static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
 
 		pos += fio->nbufs << DM_VERITY_FEC_BUF_RS_BITS;
 	}
 
 	/* Always re-validate the corrected block against the expected hash */
-	r = verity_hash(v, verity_io_hash_req(v, io), fio->output,
-			1 << v->data_dev_block_bits,
+	r = verity_hash(v, io, fio->output, 1 << v->data_dev_block_bits,
 			verity_io_real_digest(v, io), true);
 	if (unlikely(r < 0))
 		return r;
 
 	if (memcmp(verity_io_real_digest(v, io), verity_io_want_digest(v, io),
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 3e2e4f41714c..4aa140751166 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -178,13 +178,14 @@ static int verity_hash_final(struct dm_verity *v, struct ahash_request *req,
 	r = crypto_wait_req(crypto_ahash_final(req), wait);
 out:
 	return r;
 }
 
-int verity_hash(struct dm_verity *v, struct ahash_request *req,
+int verity_hash(struct dm_verity *v, struct dm_verity_io *io,
 		const u8 *data, size_t len, u8 *digest, bool may_sleep)
 {
+	struct ahash_request *req = verity_io_hash_req(v, io);
 	int r;
 	struct crypto_wait wait;
 
 	r = verity_hash_init(v, req, &wait, may_sleep);
 	if (unlikely(r < 0))
@@ -323,12 +324,11 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 		if (skip_unverified) {
 			r = 1;
 			goto release_ret_r;
 		}
 
-		r = verity_hash(v, verity_io_hash_req(v, io),
-				data, 1 << v->hash_dev_block_bits,
+		r = verity_hash(v, io, data, 1 << v->hash_dev_block_bits,
 				verity_io_real_digest(v, io), !io->in_bh);
 		if (unlikely(r < 0))
 			goto release_ret_r;
 
 		if (likely(memcmp(verity_io_real_digest(v, io), want_digest,
@@ -426,12 +426,11 @@ static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
 	io_loc.count = 1 << (v->data_dev_block_bits - SECTOR_SHIFT);
 	r = dm_io(&io_req, 1, &io_loc, NULL, IOPRIO_DEFAULT);
 	if (unlikely(r))
 		goto free_ret;
 
-	r = verity_hash(v, verity_io_hash_req(v, io), buffer,
-			1 << v->data_dev_block_bits,
+	r = verity_hash(v, io, buffer, 1 << v->data_dev_block_bits,
 			verity_io_real_digest(v, io), true);
 	if (unlikely(r))
 		goto free_ret;
 
 	if (memcmp(verity_io_real_digest(v, io),
@@ -542,11 +541,11 @@ static int verity_verify_io(struct dm_verity_io *io)
 			memset(data, 0, block_size);
 			kunmap_local(data);
 			continue;
 		}
 
-		r = verity_hash(v, verity_io_hash_req(v, io), data, block_size,
+		r = verity_hash(v, io, data, block_size,
 				verity_io_real_digest(v, io), !io->in_bh);
 		if (unlikely(r < 0)) {
 			kunmap_local(data);
 			return r;
 		}
@@ -983,33 +982,33 @@ static int verity_alloc_most_once(struct dm_verity *v)
 }
 
 static int verity_alloc_zero_digest(struct dm_verity *v)
 {
 	int r = -ENOMEM;
-	struct ahash_request *req;
+	struct dm_verity_io *io;
 	u8 *zero_data;
 
 	v->zero_digest = kmalloc(v->digest_size, GFP_KERNEL);
 
 	if (!v->zero_digest)
 		return r;
 
-	req = kmalloc(v->ahash_reqsize, GFP_KERNEL);
+	io = kmalloc(sizeof(*io) + v->ahash_reqsize, GFP_KERNEL);
 
-	if (!req)
+	if (!io)
 		return r; /* verity_dtr will free zero_digest */
 
 	zero_data = kzalloc(1 << v->data_dev_block_bits, GFP_KERNEL);
 
 	if (!zero_data)
 		goto out;
 
-	r = verity_hash(v, req, zero_data, 1 << v->data_dev_block_bits,
+	r = verity_hash(v, io, zero_data, 1 << v->data_dev_block_bits,
 			v->zero_digest, true);
 
 out:
-	kfree(req);
+	kfree(io);
 	kfree(zero_data);
 
 	return r;
 }
 
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index bd461c28b710..0e1dd02a916f 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -114,11 +114,11 @@ static inline u8 *verity_io_want_digest(struct dm_verity *v,
 					struct dm_verity_io *io)
 {
 	return io->want_digest;
 }
 
-extern int verity_hash(struct dm_verity *v, struct ahash_request *req,
+extern int verity_hash(struct dm_verity *v, struct dm_verity_io *io,
 		       const u8 *data, size_t len, u8 *digest, bool may_sleep);
 
 extern int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 				 sector_t block, u8 *digest, bool *is_zero);
 
-- 
2.45.1

