Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E8616A396;
	Fri, 21 Jun 2024 17:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718989221; cv=none; b=riFg5McE8XwlW0vZhsbWNACphB5NXM3/+Xr12HdnBJkindskySBYkVtYIDulz90hNr/75xtbBVYRmJgRQGsr4Z7hrszKK9QD/dPX9iAdd9frx2rVSMMDwdeKXMLfe9yw0RoJov/FzQYU9JD0GBEEPb9R7OufBh0gbvUooOcvMbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718989221; c=relaxed/simple;
	bh=L8QaQlnQZqDSbKGcaArdBOq7kSV7Mtdn6A22XnKLLFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7Vul1pZNhJpg+DwahJBWI0O9AcIRB+927NWPQFi0hnHkd3T3JYBcHphDyHvgbYLteGpLoKN9g4vjAh7TGBhIib3AiQWNbkuCuvxZdXbFEAzcJiZjQjAMfSSt5q7yjLvFDmCZHH3c3zs1D2MJk//oyj+U1JF79AY3iDvD8JADCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B5xMtIKI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B5xMtIKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E275C4AF08;
	Fri, 21 Jun 2024 17:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718989221;
	bh=L8QaQlnQZqDSbKGcaArdBOq7kSV7Mtdn6A22XnKLLFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B5xMtIKI0abIpZKaD5d6w6YP0ikA0bpre7moHPS1gFNG8CmW1HR3KD8ZdL+DlqdCu
	 jQvst1jVu7M+gbPCo7bM4AYdIlZozo2VHC8iI+aThWLb7vP0FbqoCRbNfKP8LGsime
	 6AJk1W+zHnhJ+4Gs0xwbBqX1UZwJUBbARuNC/6oHkfMbFgSu+ZNRDF4OoqRKQD7BkM
	 r8N+Y0gG7jmbrh2+IBWo89FNGozD3iHFz5GRs0WeUo0QM9ssRd1RQkUIl08mbj6vA7
	 bGRVcELKNtCF87Nj0/FZs+lS/28sbO6cM7J019o2kdLHlXteNZQIJ/0mEpg7AfvG49
	 qccGCsjQOoMiw==
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
Subject: [PATCH v6 10/15] dm-verity: provide dma_alignment limit in io_hints
Date: Fri, 21 Jun 2024 09:59:17 -0700
Message-ID: <20240621165922.77672-11-ebiggers@kernel.org>
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

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
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
2.45.2

