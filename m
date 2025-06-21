Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA1A1BC2A;
	Sat, 21 Jun 2025 01:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750469023; cv=none; b=ThVVAQnjOzKWQfTrKmE3kE7xZMfbS6Jsdj2urhtClQmvSgf3QEpcESWPgJgoQ4V1aQ3SsM62jKHISvf9+okng+fHZtbdzuT+rPuJ4RTHe1j4QsVdAGMi1UVddNT9Ts0AIatE72PsibCE+kc62XCfhxgxIzc/TPXto7npTtf+Vog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750469023; c=relaxed/simple;
	bh=LabTIhp+kyQC3L5lv1TCEAIfMiewHjslioR/m9+tYyo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dnhm6ddyq039X6RZcYq1adbUevR5bWGeA5Ubsv10u/ZY01eEpRAEtvcXVdaMvbZyolj4kuJRjWuryN0NNLNTuBESoxVywGFZz7VZwsdSqyKSPHNVZcEijpV0NmC5o82HPFyuLEU5wqevYFX6/Memv9dHUc8xbobY6/Zfr5VvkQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=buNTUuAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="buNTUuAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1187EC4CEE3;
	Sat, 21 Jun 2025 01:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750469023;
	bh=LabTIhp+kyQC3L5lv1TCEAIfMiewHjslioR/m9+tYyo=;
	h=From:To:Cc:Subject:Date:From;
	b=buNTUuAOZKJJF1B9LR+nFyLtMVRkzN99AQrzZe0Zb+8hFENULfcJ4K9Oacu0wmxy7
	 DZ1aJYLh8XTnD3TnrjyIjAqgnLK+vP4u548UboxsDN2NiKKhonDD5Ii8T5hMrUY51T
	 WO3hoyJkBDH2Xbh81L2+FEteoUyqaBeBVUvBtkDLnO/UpTDrrVskYOh0EsbYU/GDXT
	 ZsoZPFGev/BbCkai17YJ7YsfO0wLuwsUqZ2bduiq+j3Y7M6uqjut8oY5kuzHhF0c1H
	 Z74RJPIZ/aw4xNeEXP/BIRHkeGtj7i+NyeIQiqxk5mqui+TSaDlSoEe38nVFR9TrQh
	 v71lQi1oQ6d8Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crc: Move __maybe_unused after function return type
Date: Fri, 20 Jun 2025 18:22:21 -0700
Message-ID: <20250621012221.4351-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While both locations work, having the attribute go after the return type
is the more common convention.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crc/crc-t10dif-main.c | 2 +-
 lib/crc/crc32-main.c      | 6 +++---
 lib/crc/crc64-main.c      | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/crc/crc-t10dif-main.c b/lib/crc/crc-t10dif-main.c
index 0c595cb0d4c1c..08dde238e89ff 100644
--- a/lib/crc/crc-t10dif-main.c
+++ b/lib/crc/crc-t10dif-main.c
@@ -49,11 +49,11 @@ static const u16 t10_dif_crc_table[256] = {
 	0xA415, 0x2FA2, 0x38CC, 0xB37B, 0x1610, 0x9DA7, 0x8AC9, 0x017E,
 	0x1F65, 0x94D2, 0x83BC, 0x080B, 0xAD60, 0x26D7, 0x31B9, 0xBA0E,
 	0xF0D8, 0x7B6F, 0x6C01, 0xE7B6, 0x42DD, 0xC96A, 0xDE04, 0x55B3
 };
 
-static inline __maybe_unused u16
+static inline u16 __maybe_unused
 crc_t10dif_generic(u16 crc, const u8 *p, size_t len)
 {
 	while (len--)
 		crc = (crc << 8) ^ t10_dif_crc_table[(crc >> 8) ^ *p++];
 	return crc;
diff --git a/lib/crc/crc32-main.c b/lib/crc/crc32-main.c
index 70c4ef170526d..fbb90c9006e5e 100644
--- a/lib/crc/crc32-main.c
+++ b/lib/crc/crc32-main.c
@@ -29,27 +29,27 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
 #include "crc32table.h"
 
-static inline __maybe_unused u32
+static inline u32 __maybe_unused
 crc32_le_base(u32 crc, const u8 *p, size_t len)
 {
 	while (len--)
 		crc = (crc >> 8) ^ crc32table_le[(crc & 255) ^ *p++];
 	return crc;
 }
 
-static inline __maybe_unused u32
+static inline u32 __maybe_unused
 crc32_be_base(u32 crc, const u8 *p, size_t len)
 {
 	while (len--)
 		crc = (crc << 8) ^ crc32table_be[(crc >> 24) ^ *p++];
 	return crc;
 }
 
-static inline __maybe_unused u32
+static inline u32 __maybe_unused
 crc32c_base(u32 crc, const u8 *p, size_t len)
 {
 	while (len--)
 		crc = (crc >> 8) ^ crc32ctable_le[(crc & 255) ^ *p++];
 	return crc;
diff --git a/lib/crc/crc64-main.c b/lib/crc/crc64-main.c
index aef8282b63fba..1337036010fe0 100644
--- a/lib/crc/crc64-main.c
+++ b/lib/crc/crc64-main.c
@@ -38,19 +38,19 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
 #include "crc64table.h"
 
-static inline __maybe_unused u64
+static inline u64 __maybe_unused
 crc64_be_generic(u64 crc, const u8 *p, size_t len)
 {
 	while (len--)
 		crc = (crc << 8) ^ crc64table[(crc >> 56) ^ *p++];
 	return crc;
 }
 
-static inline __maybe_unused u64
+static inline u64 __maybe_unused
 crc64_nvme_generic(u64 crc, const u8 *p, size_t len)
 {
 	while (len--)
 		crc = (crc >> 8) ^ crc64nvmetable[(crc & 0xff) ^ *p++];
 	return crc;

base-commit: 5453f75923b1e2ea471aa67aec64f98164faa352
-- 
2.50.0

