Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CECC30E855;
	Thu, 19 Jun 2025 18:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750358128; cv=none; b=KzGc/Bt/K1T3XrqXiCIei7shPAAsfju1J5TkwuoUsXbwKJKcMRhgMvRSQHv7vh3mAJZcqV95SjJfnDC1EWpQ9LgLEe88+KyOOBG9jCYLJJUybyuBQ6nTUKkqDx7WhFxB3vL2nDq5D6DmhhsNm0AEJW2YJs0ZVXkwTaW5AtPyzxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750358128; c=relaxed/simple;
	bh=Tx8W3/+Pe/JrdMxVTO0yqNcBUIYsC1CyRtfbfAki0H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKGc8+0JFELYWpKnoviXL1xvaOFPDjjYn01OLgmU0l8QIengFQ+kbz6IYmnEN0occkzHSJzuIhhiWSopPtuW5RbbTHSRKd3f9iJ0wvHeprTNcyR3mmwl7QtxeaGMPV3UWxhE8RkmyMcUnBIdoJiaLqVawndkvN11BtqtjbWjshY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OU7Du3Lq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OU7Du3Lq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672CAC4CEED;
	Thu, 19 Jun 2025 18:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750358128;
	bh=Tx8W3/+Pe/JrdMxVTO0yqNcBUIYsC1CyRtfbfAki0H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OU7Du3LqOF+G3XqtL4Ynnp1RpMujTnrqMEI30vVAoFY/eqTn3S2btI+GEe2bizjHg
	 U6X5vuxkIpatuEDRR4ZkA2Veou4r420F3SZQ6TBFylsQGhBx49/IYaoQ3FApyXue2m
	 LmnvUN8/T0OLEyGkIyXR3D3Mkz40GX2yA26pWee1lEr9AgtCDgMsniqiuN+X2r6LKp
	 SusPxPfGw+/PL8e2X04SAm+hrAMZQ9yG4/p0Gd87A5uiEfXHns1p7O9MgxS28vCkLR
	 3XDObzPXzag0lu9bJ/Lk1lE3yOlZyzlUhxKA1Fh2ggytvv6H641RXR9k8l9CaDDphK
	 okF7t794TOmVA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org
Subject: [PATCH 2/3] lib/crc/crc32: change crc32() from macro to inline function and remove cast
Date: Thu, 19 Jun 2025 11:34:13 -0700
Message-ID: <20250619183414.100082-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250619183414.100082-1-ebiggers@kernel.org>
References: <20250619183414.100082-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

There's no need for crc32() to be a macro.  Make it an inline function
instead.  Also, remove the cast of the data pointer to
'unsigned char const *', which is no longer necessary now that the type
used in the function prototype is 'const void *'.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/linux/crc32.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/crc32.h b/include/linux/crc32.h
index f9c173206d4d1..da78b215ff2e9 100644
--- a/include/linux/crc32.h
+++ b/include/linux/crc32.h
@@ -28,10 +28,16 @@
  * Context: Any context
  * Return: The new CRC value
  */
 u32 crc32_le(u32 crc, const void *p, size_t len);
 
+/* This is just an alias for crc32_le(). */
+static inline u32 crc32(u32 crc, const void *p, size_t len)
+{
+	return crc32_le(crc, p, len);
+}
+
 /**
  * crc32_be() - Compute most-significant-bit-first IEEE CRC-32
  * @crc: Initial CRC value.  ~0 (recommended) or 0 for a new CRC computation, or
  *	 the previous CRC value if computing incrementally.
  * @p: Pointer to the data buffer
@@ -88,12 +94,10 @@ u32 crc32c(u32 crc, const void *p, size_t len);
 u32 crc32_optimizations(void);
 #else
 static inline u32 crc32_optimizations(void) { return 0; }
 #endif
 
-#define crc32(seed, data, length)  crc32_le(seed, (unsigned char const *)(data), length)
-
 /*
  * Helpers for hash table generation of ethernet nics:
  *
  * Ethernet sends the least significant bit of a byte first, thus crc32_le
  * is used. The output of crc32_le is bit reversed [most significant bit
-- 
2.50.0

