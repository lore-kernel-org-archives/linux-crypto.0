Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B997D1514E4;
	Sat,  8 Feb 2025 02:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738982963; cv=none; b=j0bb3bkTlVQpEGKeN3Wf5cviEatd1QDsnZCrW6jkDpE4GdaAI5fn4zrjbHhWNh9iFkPICoVexOcMEHydUfPCfEcION6nYwQBbdvXo7VqPTtA2drNpuDBZsFsRowpU9/qrWnwDCPecavQrXjNgkiFR0sohQ6K4qnCiFu8TF+aGpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738982963; c=relaxed/simple;
	bh=UKNOpRq17HglB9yaAPYXxH+dAXWyU/9qtlMNOx890CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXq88j7ESbD3L5ZkzWbkJRzjZ1MbeRReIPH/HpRqCfMsstsAlA4Yln7u4FzAOdyMthGDOyiONNhoy5dUtAE81/182idwW7OVSNTaHkQ9mxAuYZTSBs5yaop4faMLgAOQ1iy/uPT7LpiPJ0qVjmYO0U8DAM+WeKG4Ze5q0gt7BBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pzXD6Vhq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pzXD6Vhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD40C4CEE6;
	Sat,  8 Feb 2025 02:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738982963;
	bh=UKNOpRq17HglB9yaAPYXxH+dAXWyU/9qtlMNOx890CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzXD6VhqfQbZzGTIOLcudLteIcsTwk8A72fHLdL6pMdf/xEfP0RWBFHrSMxxYrgwU
	 yeV95g8pYAtUoOpDaOPh8+NSXse0ElEEexHGqNCFvI6KKm155c1JH5aFT8A2HjFVPG
	 YbMkG0SMdez/x8R19HAzFKZN07dlV+fpESJO4Oon3sgDZdmSVmFPk0DvDxRXN9pGr+
	 T5fNyKWnzGjQtftCcUBZRcY+wikNtkfyqDE+2XkEst23NDGc4ym4FCn8UJL1iR0EfK
	 50vouHi0ezyj4lmuUTmFEgP0zjhMm/s2r2Vjt6+YOp1KK9LW4kvyulKAxZs/qrAs5s
	 fK8tVGiRSRRhA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v2 2/6] lib/crc32: use void pointer for data
Date: Fri,  7 Feb 2025 18:49:07 -0800
Message-ID: <20250208024911.14936-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250208024911.14936-1-ebiggers@kernel.org>
References: <20250208024911.14936-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Update crc32_le(), crc32_be(), and __crc32c_le() to take the data as a
'const void *' instead of 'const u8 *'.

This makes them slightly easier to use, as it can eliminate the need for
casts in the calling code.  It's the only pointer argument, so there is
no possibility for confusion with another pointer argument.

Also, some of the CRC library functions, for example crc32c() and
crc64_be(), already used 'const void *'.  Let's standardize on that, as
it seems like a better choice.

The underlying base and arch functions continue to use 'const u8 *', as
that is often more convenient for the implementation.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/linux/crc32.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/crc32.h b/include/linux/crc32.h
index e9bd40056687a..e70977014cfdc 100644
--- a/include/linux/crc32.h
+++ b/include/linux/crc32.h
@@ -13,26 +13,26 @@ u32 __pure crc32_le_base(u32 crc, const u8 *p, size_t len);
 u32 __pure crc32_be_arch(u32 crc, const u8 *p, size_t len);
 u32 __pure crc32_be_base(u32 crc, const u8 *p, size_t len);
 u32 __pure crc32c_le_arch(u32 crc, const u8 *p, size_t len);
 u32 __pure crc32c_le_base(u32 crc, const u8 *p, size_t len);
 
-static inline u32 __pure crc32_le(u32 crc, const u8 *p, size_t len)
+static inline u32 __pure crc32_le(u32 crc, const void *p, size_t len)
 {
 	if (IS_ENABLED(CONFIG_CRC32_ARCH))
 		return crc32_le_arch(crc, p, len);
 	return crc32_le_base(crc, p, len);
 }
 
-static inline u32 __pure crc32_be(u32 crc, const u8 *p, size_t len)
+static inline u32 __pure crc32_be(u32 crc, const void *p, size_t len)
 {
 	if (IS_ENABLED(CONFIG_CRC32_ARCH))
 		return crc32_be_arch(crc, p, len);
 	return crc32_be_base(crc, p, len);
 }
 
 /* TODO: leading underscores should be dropped once callers have been updated */
-static inline u32 __pure __crc32c_le(u32 crc, const u8 *p, size_t len)
+static inline u32 __pure __crc32c_le(u32 crc, const void *p, size_t len)
 {
 	if (IS_ENABLED(CONFIG_CRC32_ARCH))
 		return crc32c_le_arch(crc, p, len);
 	return crc32c_le_base(crc, p, len);
 }
-- 
2.48.1

