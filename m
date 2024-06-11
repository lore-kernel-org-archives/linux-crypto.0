Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9E616FF23;
	Tue, 11 Jun 2024 03:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718077754; cv=none; b=s9OLW1UsQo/JSt6mB7u5WQX88k3RhYaQXlYDVvXxYEUSsIcodUVdwO0ci7vx7z4DJB1nTNntZAG1cYMd64bWz8Ggo2Z8te0JIDUXNJcyK+F+058ra82c63fkYzLWbmEQSSsNaPKzfqQnAUcl3KWD1hXSKYtuFIxkKLDDniaQjII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718077754; c=relaxed/simple;
	bh=2pM8Bh/k5bufZBnNYlFVpUc6AsryaPnDFJJisGkWbN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUKPf3OOA04AWSz4qxaSGdyYBLjlh9ipk2I+JKWLnQoKUrxlyRFAsRToifLqSywH8gH62DWJMARWuBanzrf1t12qItg9TqXl1c8/boUO+J0kCcF1bKbq2dfXLiAeQxcHMaTxleA5l1CP1CwleJC1tvT6hgBGqRunEjmrzgsP0tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EamG2Rwy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EamG2Rwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C1BC4AF48;
	Tue, 11 Jun 2024 03:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718077754;
	bh=2pM8Bh/k5bufZBnNYlFVpUc6AsryaPnDFJJisGkWbN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EamG2RwyXGvbjbh4MMQC4xjGsPU9IK2HaOrMRT1//WIbymwcVaSopdZW7v4JFwGJU
	 UDoPCJecKhonShVEmJPhPrJdXc3NyYodQ/RJNXYsGDvdgf6D508CXHC550GwG675sa
	 m/UMf+FblEQeIYj17AfIXnBXP0px50LqZsms6pS9S8pAQmNrl62rxyJwbQqaTqUwe5
	 9k2kvMYsnTeG4VVVW0VMn22xG6JXnSads1CsRk8lfh+tghXNjzRO51H6HocdBmLESq
	 mMOV7aaRQYsf4XW17GN9gPtaeJOVmn5MuOALuBCPpjirtVt1zd/AFai8F7vNoI2441
	 3RWQDO+TUS1qg==
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
Subject: [PATCH v5 08/15] dm-verity: move data hash mismatch handling into its own function
Date: Mon, 10 Jun 2024 20:48:15 -0700
Message-ID: <20240611034822.36603-9-ebiggers@kernel.org>
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

Move the code that handles mismatches of data block hashes into its own
function so that it doesn't clutter up verity_verify_io().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-target.c | 64 ++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 88d2a49dca43..796d85526696 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -540,10 +540,42 @@ static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
 	mempool_free(page, &v->recheck_pool);
 
 	return r;
 }
 
+static int verity_handle_data_hash_mismatch(struct dm_verity *v,
+					    struct dm_verity_io *io,
+					    struct bio *bio, sector_t blkno,
+					    struct bvec_iter *start)
+{
+	if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
+		/*
+		 * Error handling code (FEC included) cannot be run in the
+		 * BH workqueue, so fallback to a standard workqueue.
+		 */
+		return -EAGAIN;
+	}
+	if (verity_recheck(v, io, *start, blkno) == 0) {
+		if (v->validated_blocks)
+			set_bit(blkno, v->validated_blocks);
+		return 0;
+	}
+#if defined(CONFIG_DM_VERITY_FEC)
+	if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA, blkno,
+			      NULL, start) == 0)
+		return 0;
+#endif
+	if (bio->bi_status)
+		return -EIO; /* Error correction failed; Just return error */
+
+	if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA, blkno)) {
+		dm_audit_log_bio(DM_MSG_PREFIX, "verify-data", bio, blkno, 0);
+		return -EIO;
+	}
+	return 0;
+}
+
 static int verity_bv_zero(struct dm_verity *v, struct dm_verity_io *io,
 			  u8 *data, size_t len)
 {
 	memset(data, 0, len);
 	return 0;
@@ -632,39 +664,15 @@ static int verity_verify_io(struct dm_verity_io *io)
 		if (likely(memcmp(verity_io_real_digest(v, io),
 				  verity_io_want_digest(v, io), v->digest_size) == 0)) {
 			if (v->validated_blocks)
 				set_bit(cur_block, v->validated_blocks);
 			continue;
-		} else if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
-			/*
-			 * Error handling code (FEC included) cannot be run in a
-			 * tasklet since it may sleep, so fallback to work-queue.
-			 */
-			return -EAGAIN;
-		} else if (verity_recheck(v, io, start, cur_block) == 0) {
-			if (v->validated_blocks)
-				set_bit(cur_block, v->validated_blocks);
-			continue;
-#if defined(CONFIG_DM_VERITY_FEC)
-		} else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA,
-					     cur_block, NULL, &start) == 0) {
-			continue;
-#endif
-		} else {
-			if (bio->bi_status) {
-				/*
-				 * Error correction failed; Just return error
-				 */
-				return -EIO;
-			}
-			if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
-					      cur_block)) {
-				dm_audit_log_bio(DM_MSG_PREFIX, "verify-data",
-						 bio, cur_block, 0);
-				return -EIO;
-			}
 		}
+		r = verity_handle_data_hash_mismatch(v, io, bio, cur_block,
+						     &start);
+		if (unlikely(r))
+			return r;
 	}
 
 	return 0;
 }
 
-- 
2.45.1

