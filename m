Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9F01F03D7;
	Tue,  4 Mar 2025 22:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741128059; cv=none; b=Rmhy0gI/bh7ZUYR7wjOnaatnp7qxP0o+Njx01l/S2KkZpsZ1W2dezRSaWQkyTQqEHYx4kJVasiIUPGN6taxDISfPr1gEmo1a4ppgz8T+AuWtXpdqEfcK8ay6M2am0HHUAxmn2EB2IQKZ2QoF2DoaA/tPj2RE4SpO13m68KLoBaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741128059; c=relaxed/simple;
	bh=GgF7ox4Ph7gA2gW2WSndHkdXRt9eV/weI4chuZiDDS4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VEc3H3wcMIA26DwXC4uNGxAYmmMlv4+3NZftYHDUOFxmVKZ/xn5SyZfKGiijKF4N2D9lD4+YLQa2D3aVqxc+pOGsFyr/n82JN7O08M7/4JedTF0fbnYszB5n/LVgCMvFeE7XWC4oh7w9+6lFQYUz9if0fE4c0NojN/S3hWSG6UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M2j7fAbF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M2j7fAbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89613C4CEE5;
	Tue,  4 Mar 2025 22:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741128058;
	bh=GgF7ox4Ph7gA2gW2WSndHkdXRt9eV/weI4chuZiDDS4=;
	h=From:To:Cc:Subject:Date:From;
	b=M2j7fAbF1gjpo4YPkdbjydcS+xWJHI39qxa4j9ZRyszO3pkUslc7doLFZG2afz05s
	 WVUrbnPYihAzmOsCVk8oXLngNtXIDNJ87hqkj9+GZVvT5mIYto658n9TDET10YLbaV
	 8CW8gaEcBWZjqFGxM9dDY4Bf9OVAS1PYHmat90jaWghAfbfblPpZtItMdghIPiz7uF
	 RzDHPfEmcWOOkrLAO0envq3qPX3VUwINPomTAKPTlo/xfKgDbOyC57AXHTqMZNJBix
	 K5TDuUDqnN6qzMGoBZiuZUxM8HmuxJP36J3Pl/+u/qDwbtqf5AGKpeEp9Ic3FI2aAB
	 730sIxB+to6Yg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] lib/crc7: unexport crc7_be_syndrome_table
Date: Tue,  4 Mar 2025 14:40:52 -0800
Message-ID: <20250304224052.157915-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Since neither crc7_be_syndrome_table nor crc7_be_byte() are used outside
lib/crc7.c, fold them into lib/crc7.c.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/linux/crc7.h | 7 -------
 lib/crc7.c           | 6 ++----
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/include/linux/crc7.h b/include/linux/crc7.h
index b462842f3c32c..61d34749e437d 100644
--- a/include/linux/crc7.h
+++ b/include/linux/crc7.h
@@ -1,15 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _LINUX_CRC7_H
 #define _LINUX_CRC7_H
 #include <linux/types.h>
 
-extern const u8 crc7_be_syndrome_table[256];
-
-static inline u8 crc7_be_byte(u8 crc, u8 data)
-{
-	return crc7_be_syndrome_table[crc ^ data];
-}
-
 extern u8 crc7_be(u8 crc, const u8 *buffer, size_t len);
 
 #endif
diff --git a/lib/crc7.c b/lib/crc7.c
index 3848e313b7224..8dd991cc61146 100644
--- a/lib/crc7.c
+++ b/lib/crc7.c
@@ -5,18 +5,17 @@
 
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/crc7.h>
 
-
 /*
  * Table for CRC-7 (polynomial x^7 + x^3 + 1).
  * This is a big-endian CRC (msbit is highest power of x),
  * aligned so the msbit of the byte is the x^6 coefficient
  * and the lsbit is not used.
  */
-const u8 crc7_be_syndrome_table[256] = {
+static const u8 crc7_be_syndrome_table[256] = {
 	0x00, 0x12, 0x24, 0x36, 0x48, 0x5a, 0x6c, 0x7e,
 	0x90, 0x82, 0xb4, 0xa6, 0xd8, 0xca, 0xfc, 0xee,
 	0x32, 0x20, 0x16, 0x04, 0x7a, 0x68, 0x5e, 0x4c,
 	0xa2, 0xb0, 0x86, 0x94, 0xea, 0xf8, 0xce, 0xdc,
 	0x64, 0x76, 0x40, 0x52, 0x2c, 0x3e, 0x08, 0x1a,
@@ -46,11 +45,10 @@ const u8 crc7_be_syndrome_table[256] = {
 	0x2e, 0x3c, 0x0a, 0x18, 0x66, 0x74, 0x42, 0x50,
 	0xbe, 0xac, 0x9a, 0x88, 0xf6, 0xe4, 0xd2, 0xc0,
 	0x1c, 0x0e, 0x38, 0x2a, 0x54, 0x46, 0x70, 0x62,
 	0x8c, 0x9e, 0xa8, 0xba, 0xc4, 0xd6, 0xe0, 0xf2
 };
-EXPORT_SYMBOL(crc7_be_syndrome_table);
 
 /**
  * crc7_be - update the CRC7 for the data buffer
  * @crc:     previous CRC7 value
  * @buffer:  data pointer
@@ -63,11 +61,11 @@ EXPORT_SYMBOL(crc7_be_syndrome_table);
  *
  */
 u8 crc7_be(u8 crc, const u8 *buffer, size_t len)
 {
 	while (len--)
-		crc = crc7_be_byte(crc, *buffer++);
+		crc = crc7_be_syndrome_table[crc ^ *buffer++];
 	return crc;
 }
 EXPORT_SYMBOL(crc7_be);
 
 MODULE_DESCRIPTION("CRC7 calculations");

base-commit: 13f3d13d88b5dcba104a204fcbee61c75f8407d0
-- 
2.48.1

