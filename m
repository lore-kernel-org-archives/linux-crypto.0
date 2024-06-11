Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAB5171078;
	Tue, 11 Jun 2024 03:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718077754; cv=none; b=FopazEtbXIYKH9QZQkI+1UsZoyPfNxgSne8a2vx9C1HPNw5V86vx/3H4JKSWgNsB4Dt9AbHCNSJrlZ3O2pTa6LKHNYNNr2eU3kgDE3YMwbp7rRZVgHo6+txAQrFMyvtpx717vlYwPEnmeolAiTgZFl7AdMdBDr5QOQ+HMDuviVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718077754; c=relaxed/simple;
	bh=DEFlmsbEWT/xZ+wzMO36ZCGur9JVhR2ovvX1zBGomis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Se6qHXtm8rKMwu9C13BiyaTJIXeQZwXSuHFeqeDmhjHBPc+/iNlOUcjBrYTY3lVk3ovsmRTQ4G+FLibrwCxK1Ksoa9Wk+xBDHui2Ff0JuiHQLGFPk4w8yVdsyzgDUZzANJAPSbxLu90BFlwRmB4xcn9kjbgVbqbsj05nM8FcJtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sJKS3qjX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sJKS3qjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F4AC4AF50;
	Tue, 11 Jun 2024 03:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718077754;
	bh=DEFlmsbEWT/xZ+wzMO36ZCGur9JVhR2ovvX1zBGomis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJKS3qjXL6k4MAmNi697sReT81K1UbDyoXvZjBLFCtBh8hTvdljzHE/wdrfRg9biJ
	 k3YeSo4XmEkpWPggdchydh0NVwVKVSrC61y8wiFXQDUTFO0sDLx2q+w18ypGS6wfq8
	 PVjreno9PVmneYU1g5Xnqf6ZldU16P3hBn8z6mO+xn5drOUGoBucQ14VuQV6dH3c6Q
	 d6mY4o98iqKcqbCJMTPRm8jMI2UL6ToItw3s4erkbmOITOkEeRvumcQC1E3T+SQ/+a
	 JbCraIQ6kiqfpDQDmMXWe87dS7Aj91QUhKl5kQ2uDZWx/DWr1vMULklP67w5CjmeWF
	 Mot5XbwmumKUA==
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
Subject: [PATCH v5 09/15] dm-verity: make real_digest and want_digest fixed-length
Date: Mon, 10 Jun 2024 20:48:16 -0700
Message-ID: <20240611034822.36603-10-ebiggers@kernel.org>
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

Change the digest fields in struct dm_verity_io from variable-length to
fixed-length, since their maximum length is fixed at
HASH_MAX_DIGESTSIZE, i.e. 64 bytes, which is not too big.  This is
simpler and makes the fields a bit faster to access.

(HASH_MAX_DIGESTSIZE did not exist when this code was written, which may
explain why it wasn't used.)

This makes the verity_io_real_digest() and verity_io_want_digest()
functions trivial, but this patch leaves them in place temporarily since
most of their callers will go away in a later patch anyway.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-target.c |  3 +--
 drivers/md/dm-verity.h        | 17 +++++++----------
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 796d85526696..4ef814a7faf4 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1527,12 +1527,11 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		ti->error = "Cannot allocate workqueue";
 		r = -ENOMEM;
 		goto bad;
 	}
 
-	ti->per_io_data_size = sizeof(struct dm_verity_io) +
-				v->ahash_reqsize + v->digest_size * 2;
+	ti->per_io_data_size = sizeof(struct dm_verity_io) + v->ahash_reqsize;
 
 	r = verity_fec_ctr(v);
 	if (r)
 		goto bad;
 
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 20b1bcf03474..5d3da9f5fc95 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -89,19 +89,16 @@ struct dm_verity_io {
 	struct work_struct work;
 	struct work_struct bh_work;
 
 	char *recheck_buffer;
 
+	u8 real_digest[HASH_MAX_DIGESTSIZE];
+	u8 want_digest[HASH_MAX_DIGESTSIZE];
+
 	/*
-	 * Three variably-size fields follow this struct:
-	 *
-	 * u8 hash_req[v->ahash_reqsize];
-	 * u8 real_digest[v->digest_size];
-	 * u8 want_digest[v->digest_size];
-	 *
-	 * To access them use: verity_io_hash_req(), verity_io_real_digest()
-	 * and verity_io_want_digest().
+	 * This struct is followed by a variable-sized struct ahash_request of
+	 * size v->ahash_reqsize.  To access it, use verity_io_hash_req().
 	 */
 };
 
 static inline struct ahash_request *verity_io_hash_req(struct dm_verity *v,
 						     struct dm_verity_io *io)
@@ -110,17 +107,17 @@ static inline struct ahash_request *verity_io_hash_req(struct dm_verity *v,
 }
 
 static inline u8 *verity_io_real_digest(struct dm_verity *v,
 					struct dm_verity_io *io)
 {
-	return (u8 *)(io + 1) + v->ahash_reqsize;
+	return io->real_digest;
 }
 
 static inline u8 *verity_io_want_digest(struct dm_verity *v,
 					struct dm_verity_io *io)
 {
-	return (u8 *)(io + 1) + v->ahash_reqsize + v->digest_size;
+	return io->want_digest;
 }
 
 extern int verity_for_bv_block(struct dm_verity *v, struct dm_verity_io *io,
 			       struct bvec_iter *iter,
 			       int (*process)(struct dm_verity *v,
-- 
2.45.1

