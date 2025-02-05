Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89201227BAF;
	Wed,  5 Feb 2025 00:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738716929; cv=none; b=a/WlFcfPw0o5U+N8fnG40T6P+xIbCdOKiCy/qAgplfVYhTlxdeBFae4uGIBfPHEJlXKiScKiQk0X8knY32VDXfpgHSg1iSCMuffocFRsbjD0q0fYMRhTLwxq/Lfq/8MFAoEZoPFp3r7cmsfXIZsvZ8tNz1C2ogRWrKhV4Ecq2Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738716929; c=relaxed/simple;
	bh=/p3RkOgwF9GzSkNhjGXoQ7EdOyAbeizN2712J8f87x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDepENHRTpn2w+BNvHoEgVFNnHzpVKW3W8oWaoQhkp0aWHR/64vPZJwsg91+R3Z8eLq/x+2qmufgcBZ8D3sUHPej8cSly4P6iPv7e7bfz3muRQhJPGkMbkEsQYRIUSkO3M5G7vK45OVUOhR0bsL2GmgGunA1TezOH1CGIhFqq2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QzfVh/bl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QzfVh/bl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40440C4CEE9;
	Wed,  5 Feb 2025 00:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738716929;
	bh=/p3RkOgwF9GzSkNhjGXoQ7EdOyAbeizN2712J8f87x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzfVh/blLb0EMNpOTWAFacjAqfMtgLsnE2bS5Su/De9Yx7U/tEw+A3SAFGT4b3ruh
	 DX6cJUeQZ8u0DJjgAjYtGZnv5kJKZ3KZE+HWMtt+tbdnTftUkyaPSkA1XrILy/uKiW
	 Jz8l0DGB6goiUK5P/opeySINX6RkZGqbn15iSW9CvKVnqu9lUPSJtJ5LsGKt6Ooann
	 irlenCTO3IMeZPEgdyxFlIdIQJUkkOIQU1/XWGikTB5Zx/0ULwLrfahD+qf8FlLZml
	 0i939VkPxHqz3xH/OpxUiF6pVIWYWlUvoz4RsN6bk2qPCUNgfpoRzhIxagTYzmWtys
	 H3zH71fsBXCCw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4/5] lib/crc32: rename __crc32c_le_combine() to crc32c_combine()
Date: Tue,  4 Feb 2025 16:54:02 -0800
Message-ID: <20250205005403.136082-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205005403.136082-1-ebiggers@kernel.org>
References: <20250205005403.136082-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Since the Castagnoli CRC32 is now always just crc32c(), rename
__crc32c_le_combine() and __crc32c_le_shift() accordingly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/infiniband/sw/siw/siw.h |  4 ++--
 include/linux/crc32.h           | 26 ++++++++++++--------------
 include/net/sctp/checksum.h     |  4 ++--
 lib/crc32.c                     |  6 +++---
 lib/crc_kunit.c                 |  2 +-
 5 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw.h b/drivers/infiniband/sw/siw/siw.h
index ea5eee50dc39d..4e692de1da933 100644
--- a/drivers/infiniband/sw/siw/siw.h
+++ b/drivers/infiniband/sw/siw/siw.h
@@ -674,12 +674,12 @@ static inline __wsum siw_csum_update(const void *buff, int len, __wsum sum)
 }
 
 static inline __wsum siw_csum_combine(__wsum csum, __wsum csum2, int offset,
 				      int len)
 {
-	return (__force __wsum)__crc32c_le_combine((__force __u32)csum,
-						   (__force __u32)csum2, len);
+	return (__force __wsum)crc32c_combine((__force __u32)csum,
+					      (__force __u32)csum2, len);
 }
 
 static inline void siw_crc_skb(struct siw_rx_stream *srx, unsigned int len)
 {
 	const struct skb_checksum_ops siw_cs_ops = {
diff --git a/include/linux/crc32.h b/include/linux/crc32.h
index bc39b023eac0f..fd6541920bfad 100644
--- a/include/linux/crc32.h
+++ b/include/linux/crc32.h
@@ -75,32 +75,30 @@ static inline u32 crc32_le_combine(u32 crc1, u32 crc2, size_t len2)
 {
 	return crc32_le_shift(crc1, len2) ^ crc2;
 }
 
 /**
- * __crc32c_le_combine - Combine two crc32c check values into one. For two
- * 			 sequences of bytes, seq1 and seq2 with lengths len1
- * 			 and len2, __crc32c_le() check values were calculated
- * 			 for each, crc1 and crc2.
+ * crc32c_combine - Combine two crc32c check values into one. For two sequences
+ *		    of bytes, seq1 and seq2 with lengths len1 and len2, crc32c()
+ *		    check values were calculated for each, crc1 and crc2.
  *
  * @crc1: crc32c of the first block
  * @crc2: crc32c of the second block
  * @len2: length of the second block
  *
- * Return: The __crc32c_le() check value of seq1 and seq2 concatenated,
- * 	   requiring only crc1, crc2, and len2. Note: If seq_full denotes
- * 	   the concatenated memory area of seq1 with seq2, and crc_full
- * 	   the __crc32c_le() value of seq_full, then crc_full ==
- * 	   __crc32c_le_combine(crc1, crc2, len2) when crc_full was
- * 	   seeded with the same initializer as crc1, and crc2 seed
- * 	   was 0. See also crc32c_combine_test().
+ * Return: The crc32c() check value of seq1 and seq2 concatenated,
+ *	   requiring only crc1, crc2, and len2. Note: If seq_full denotes the
+ *	   concatenated memory area of seq1 with seq2, and crc_full the crc32c()
+ *	   value of seq_full, then crc_full == crc32c_combine(crc1, crc2, len2)
+ *	   when crc_full was seeded with the same initializer as crc1, and crc2
+ *	   seed was 0. See also crc_combine_test().
  */
-u32 __crc32c_le_shift(u32 crc, size_t len);
+u32 crc32c_shift(u32 crc, size_t len);
 
-static inline u32 __crc32c_le_combine(u32 crc1, u32 crc2, size_t len2)
+static inline u32 crc32c_combine(u32 crc1, u32 crc2, size_t len2)
 {
-	return __crc32c_le_shift(crc1, len2) ^ crc2;
+	return crc32c_shift(crc1, len2) ^ crc2;
 }
 
 #define crc32(seed, data, length)  crc32_le(seed, (unsigned char const *)(data), length)
 
 /*
diff --git a/include/net/sctp/checksum.h b/include/net/sctp/checksum.h
index 93041c970753e..291465c258102 100644
--- a/include/net/sctp/checksum.h
+++ b/include/net/sctp/checksum.h
@@ -34,12 +34,12 @@ static inline __wsum sctp_csum_update(const void *buff, int len, __wsum sum)
 }
 
 static inline __wsum sctp_csum_combine(__wsum csum, __wsum csum2,
 				       int offset, int len)
 {
-	return (__force __wsum)__crc32c_le_combine((__force __u32)csum,
-						   (__force __u32)csum2, len);
+	return (__force __wsum)crc32c_combine((__force __u32)csum,
+					      (__force __u32)csum2, len);
 }
 
 static const struct skb_checksum_ops sctp_csum_ops = {
 	.update  = sctp_csum_update,
 	.combine = sctp_csum_combine,
diff --git a/lib/crc32.c b/lib/crc32.c
index 3c080cda5e1c9..554ef6827b80d 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -115,17 +115,17 @@ static u32 crc32_generic_shift(u32 crc, size_t len, u32 polynomial)
 
 u32 crc32_le_shift(u32 crc, size_t len)
 {
 	return crc32_generic_shift(crc, len, CRC32_POLY_LE);
 }
+EXPORT_SYMBOL(crc32_le_shift);
 
-u32 __crc32c_le_shift(u32 crc, size_t len)
+u32 crc32c_shift(u32 crc, size_t len)
 {
 	return crc32_generic_shift(crc, len, CRC32C_POLY_LE);
 }
-EXPORT_SYMBOL(crc32_le_shift);
-EXPORT_SYMBOL(__crc32c_le_shift);
+EXPORT_SYMBOL(crc32c_shift);
 
 u32 crc32_be_base(u32 crc, const u8 *p, size_t len)
 {
 	while (len--)
 		crc = (crc << 8) ^ crc32table_be[(crc >> 24) ^ *p++];
diff --git a/lib/crc_kunit.c b/lib/crc_kunit.c
index 6a61d4b5fd45a..672fe64f572a5 100644
--- a/lib/crc_kunit.c
+++ b/lib/crc_kunit.c
@@ -360,11 +360,11 @@ static u64 crc32c_wrapper(u64 crc, const u8 *p, size_t len)
 	return crc32c(crc, p, len);
 }
 
 static u64 crc32c_combine_wrapper(u64 crc1, u64 crc2, size_t len2)
 {
-	return __crc32c_le_combine(crc1, crc2, len2);
+	return crc32c_combine(crc1, crc2, len2);
 }
 
 static const struct crc_variant crc_variant_crc32c = {
 	.bits = 32,
 	.le = true,
-- 
2.48.1

