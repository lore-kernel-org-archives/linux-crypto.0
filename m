Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06AF172761;
	Fri, 21 Jun 2024 17:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718989221; cv=none; b=RDLSn8r0TTH2bpBZJYuKYp9JOyYaEhkAjaKodSq+W0xOWBXB+AQUK022qySNZJoOZDDU0JnUOKvMjYNDH069KtUQVNtUW+RL0/P3y1bjcE1EhgbHPshpV7/Z+H6M6iiDRrP2t80XbeyH64gQcGtrTDxyCZYO9590AfqdJawAR18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718989221; c=relaxed/simple;
	bh=FQIlGe1ODogKmI2ftbLTyX6pGZq9j7L+IwPSLI+6oQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0WtB73M3J32Jk4JjGcZYm9oQ12Btrlr2hTbRTpWTO6aYjhFv9t1VJFalIik7vVt6oZD56hP/Mxa6rT2A2xhzG9kAFOcvs91ysUHYHFpy44bqW9JiRnT1ZfeCOxcNRLH6BFR8clSKBml11/LzBwlgOxB0398320oUvd/Kdicr9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jrPFiXKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jrPFiXKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2090CC3277B;
	Fri, 21 Jun 2024 17:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718989220;
	bh=FQIlGe1ODogKmI2ftbLTyX6pGZq9j7L+IwPSLI+6oQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrPFiXKi4LvCNOgnzw+phKBA5RMKNvKjBEYelo/7go6XV8yi4vFGII9AS/EJkWvdd
	 GDOuq2HZ63To6E3tgcjpWX9Dcsar7WBntHgV6iRE/v0bTWlCGXk8f2THnUMc221xSJ
	 DmaUJBepd428UBiTB3dqkMvg87ZQLgfdPsvBEllsUTsjwtBl7PhAzCUup2kmVwvAZq
	 SccO2T5TsxGGtff0hPnRwsiJACJlRzRpvTdCDNy5+dLKvB4Ul2hjmvVV/DD8kHfE0j
	 +0x2CBv9sWxCqIJdnBHhpQvnFbgCRSCIMS0D1DCyDjncDmOwWiKx08b+qbwJjYk6Gh
	 Z6l5e45qmzHXQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v6 09/15] dm-verity: make real_digest and want_digest fixed-length
Date: Fri, 21 Jun 2024 09:59:16 -0700
Message-ID: <20240621165922.77672-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240621165922.77672-1-ebiggers@kernel.org>
References: <20240621165922.77672-1-ebiggers@kernel.org>
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

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
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
2.45.2

