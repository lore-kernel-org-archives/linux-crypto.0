Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB2A49F11B;
	Thu,  3 Sep 2026 12:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788437036; cv=none; b=UO9knQPCH3Te7JHf0UrAfGXgLU3w4xAGrlysBovTmqpQKXbyXvmjy1a2Tyfd8g+a4pkGdhCz873qMovkBGXgM2IszYIFfR72A5wJe+Yx1f+NavcU3jAgLA/RudP/w1FVGbRzWnc3eQKXDdpI1ibnhH1V0hEgDyk2Pk1CTkVcDlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788437036; c=relaxed/simple;
	bh=bYWU7J3LzTLt01IWwStr02unJlD2QYQqsa5rWqDkxFM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s4BncbJFLb0hU5DB+kvdV1RztnbqW+Xs3OC3CrZscdem+xNa9+aUFqUo/wxCY/CfH/HZ5yR+t4WW4bB2EVAuNbaUTBJtDd5M04xjrhIN/SL38WXpCHBw5qEOCnHkskGoVhwk202zLR40qu0rMCAtPr6f9z0hK+hnVih5yYcSjGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2279F1F000E9;
	Thu,  3 Sep 2026 12:03:52 +0000 (UTC)
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] lib/crc: arm64: Fix const keyword in asm prototypes
Date: Thu,  3 Sep 2026 14:03:50 +0200
Message-ID: <1073b77747354d8d46d8804970acd80245e4c318.1788436846.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit d36cebe03c3ae4ea ("lib/crc32: improve support for arch-specific
overrides") corrected the position of the "const" keyword in the
arch-specific funcions, and replaced "unsigned char" by "u8" for
consistency.

Make the same change to the forward declarations for the asm
implementations.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 lib/crc/arm64/crc32.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/crc/arm64/crc32.h b/lib/crc/arm64/crc32.h
index 1939a5dee4772972..332d9092ba2f3875 100644
--- a/lib/crc/arm64/crc32.h
+++ b/lib/crc/arm64/crc32.h
@@ -7,13 +7,13 @@
 // The minimum input length to consider the 4-way interleaved code path
 static const size_t min_len = 1024;
 
-asmlinkage u32 crc32_le_arm64(u32 crc, unsigned char const *p, size_t len);
-asmlinkage u32 crc32c_le_arm64(u32 crc, unsigned char const *p, size_t len);
-asmlinkage u32 crc32_be_arm64(u32 crc, unsigned char const *p, size_t len);
+asmlinkage u32 crc32_le_arm64(u32 crc, const u8 *p, size_t len);
+asmlinkage u32 crc32c_le_arm64(u32 crc, const u8 *p, size_t len);
+asmlinkage u32 crc32_be_arm64(u32 crc, const u8 *p, size_t len);
 
-asmlinkage u32 crc32_le_arm64_4way(u32 crc, unsigned char const *p, size_t len);
-asmlinkage u32 crc32c_le_arm64_4way(u32 crc, unsigned char const *p, size_t len);
-asmlinkage u32 crc32_be_arm64_4way(u32 crc, unsigned char const *p, size_t len);
+asmlinkage u32 crc32_le_arm64_4way(u32 crc, const u8 *p, size_t len);
+asmlinkage u32 crc32c_le_arm64_4way(u32 crc, const u8 *p, size_t len);
+asmlinkage u32 crc32_be_arm64_4way(u32 crc, const u8 *p, size_t len);
 
 static inline u32 crc32_le_arch(u32 crc, const u8 *p, size_t len)
 {
-- 
2.43.0

