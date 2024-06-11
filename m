Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C82171085;
	Tue, 11 Jun 2024 03:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718077755; cv=none; b=Hyjok7xf5lGlkuz3xPMU4MKNv4n1OxLCjHgy9qIJLqzcktwBwRjz6uLIzi4gnW8JWFXlmVOgz8SLwcs6InkuVXgUDhlrFUr8iY+Gc2y1Y5aJcgh8Z/9JaQKlWw4XGYamJAqFCQaEvv3UpV1UlOUDtRFiMpUoP02W5JdqqEPmL4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718077755; c=relaxed/simple;
	bh=ukGSgX5MesqBbGJj7yzKjyDULlLyq2Ow1gHuSG/PLIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JAVjymsFb8+imFa45nSqmumyOP/b4hypuwWkQyzRx8U2+VZVdfMUbtvZzl5tHVlbC9ucATuFOCPskSoaGaQKb8dipQoBfkF2YGWqn8c1BCDmAzpCosoMvFJ0mVggnxFAx70vUhsQRdKdZP+Ax9KTeqsxBLOvR4S//KLojAD6PVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fhpkSPea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fhpkSPea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97374C4AF1C;
	Tue, 11 Jun 2024 03:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718077754;
	bh=ukGSgX5MesqBbGJj7yzKjyDULlLyq2Ow1gHuSG/PLIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fhpkSPeaAOYUhZnC1IAvTG86aeMudfDvPq1AJ6d6PBVbWVNiywtoyarmcuYIVIRgT
	 mt0/r3cn4fzilUMhCwJ1eZndrcwxywUR+FtWNh8uxCsfANn6/0Mq2lD9u6PZ05I/mD
	 /mU6ttCVE6/nJOtzF70jguI/TQy8ARn0fQC5r2FnWiIibMSiQ3ozGBG6h1j2bjbut4
	 w+71Z7NyZWRqgc2Zv1cPBRT38X4gYHu5L2hb2JwTkGYX6ZYyL3UmAAQc01fLBC0D4o
	 I5vibPzddTy2imZTf+oBNSPIy6dWOwbuAlQpVdorpq6gg5NAv6W8xbYK4ov+gFE0ap
	 sLw30XMUFPUbg==
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
Subject: [PATCH v5 10/15] dm-verity: provide dma_alignment limit in io_hints
Date: Mon, 10 Jun 2024 20:48:17 -0700
Message-ID: <20240611034822.36603-11-ebiggers@kernel.org>
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

Since Linux v6.1, some filesystems support submitting direct I/O that is
aligned to only dma_alignment instead of the logical_block_size
alignment that was required before.  I/O that is not aligned to the
logical_block_size is difficult to handle in device-mapper targets that
do cryptographic processing of data, as it makes the units of data that
are hashed or encrypted possibly be split across pages, creating rarely
used and rarely tested edge cases.

As such, dm-crypt and dm-integrity have already opted out of this by
setting dma_alignment to 'logical_block_size - 1'.

Although dm-verity does have code that handles these cases (or at least
is intended to do so), supporting direct I/O with such a low amount of
alignment is not really useful on dm-verity devices.  So, opt dm-verity
out of it too so that it's not necessary to handle these edge cases.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-target.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 4ef814a7faf4..c6a0e3280e39 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1021,10 +1021,12 @@ static void verity_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 	if (limits->physical_block_size < 1 << v->data_dev_block_bits)
 		limits->physical_block_size = 1 << v->data_dev_block_bits;
 
 	blk_limits_io_min(limits, limits->logical_block_size);
+
+	limits->dma_alignment = limits->logical_block_size - 1;
 }
 
 static void verity_dtr(struct dm_target *ti)
 {
 	struct dm_verity *v = ti->private;
-- 
2.45.1

