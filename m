Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394CC1B4132;
	Tue, 13 May 2025 02:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747102925; cv=none; b=JZ8eKl0fpVzkHuvwnFthcgegRck3NSmevvlbIlVzLLkrXXPC4viiY0RYW57r3OYykGYS8bUixKFVSPtGxRJMwt1iutZjt8An2mN8G+b+KKAwj2X6RuTGWcSgqx9JcCtA+bh6iotcly0LIZdwqTU74mjOH2n+mkDYTGmtF7loJSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747102925; c=relaxed/simple;
	bh=iISSICdj90rJC+RRFsOSSGzkgQFlFlqkHJXh04fX5kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxWt0c7tuuGCtR6B77qUxPxCl8M4uzO4bLIxE7ivRuNLxaJM6QV9y4uNgMsiAQdKJ8Z1iOIfCBRSXNYjw2dhJWBgKjN8dfc8CdSuo14Nf8LYi7bLiBmxcp3vYSEEBZrWAplE1KGJ9wUCnU6RboQMOpIbikqtZmjkPsE7LoGlsqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B81jOWJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B81jOWJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99121C4CEEF;
	Tue, 13 May 2025 02:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747102924;
	bh=iISSICdj90rJC+RRFsOSSGzkgQFlFlqkHJXh04fX5kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B81jOWJmtysYfHtSNY6PCK4wysVbsWy1/nqCCQf+p0wXmI64mAI+K79al7ipL1zPU
	 6HJFpR89kkxfsM0b33kZRuqq8/HuzGIc5Vtfhwfqwr9mWfYS6e+k8SfOqxENhrcUxK
	 zy8bKjFSPRVrV6+IKIwgaLANsd6GMLIlhsUFh22thvurwbFgcbHOaEJFQgvA0Nys3R
	 GY8SlxCLobw0g9tIvFXDv6zPmojrrnUA9bmOgZbTIsBjrZYggxsFc5dgLe1/kIZJIS
	 E36CJ+CtpRqYwbceFuGpr/sJRSP5LneajHpXyAVdEu3A12xEE69SZo8X8B2mhL2LcU
	 EmbazUATcDZHA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 2/2] lib/crc16: unexport crc16_table and crc16_byte()
Date: Mon, 12 May 2025 19:21:15 -0700
Message-ID: <20250513022115.39109-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250513022115.39109-1-ebiggers@kernel.org>
References: <20250513022115.39109-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Now that neither crc16_table nor crc16_byte() is used outside
lib/crc16.c, fold them into lib/crc16.c.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/linux/crc16.h | 9 +--------
 lib/crc16.c           | 9 ++++-----
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/include/linux/crc16.h b/include/linux/crc16.h
index 9fa74529b317..b861d969b161 100644
--- a/include/linux/crc16.h
+++ b/include/linux/crc16.h
@@ -13,16 +13,9 @@
 #ifndef __CRC16_H
 #define __CRC16_H
 
 #include <linux/types.h>
 
-extern u16 const crc16_table[256];
-
-extern u16 crc16(u16 crc, const u8 *buffer, size_t len);
-
-static inline u16 crc16_byte(u16 crc, const u8 data)
-{
-	return (crc >> 8) ^ crc16_table[(crc ^ data) & 0xff];
-}
+u16 crc16(u16 crc, const u8 *p, size_t len);
 
 #endif /* __CRC16_H */
 
diff --git a/lib/crc16.c b/lib/crc16.c
index 5c3a803c01e0..9c71eda9bf4b 100644
--- a/lib/crc16.c
+++ b/lib/crc16.c
@@ -6,11 +6,11 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/crc16.h>
 
 /** CRC table for the CRC-16. The poly is 0x8005 (x^16 + x^15 + x^2 + 1) */
-u16 const crc16_table[256] = {
+static const u16 crc16_table[256] = {
 	0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301, 0x03C0, 0x0280, 0xC241,
 	0xC601, 0x06C0, 0x0780, 0xC741, 0x0500, 0xC5C1, 0xC481, 0x0440,
 	0xCC01, 0x0CC0, 0x0D80, 0xCD41, 0x0F00, 0xCFC1, 0xCE81, 0x0E40,
 	0x0A00, 0xCAC1, 0xCB81, 0x0B40, 0xC901, 0x09C0, 0x0880, 0xC841,
 	0xD801, 0x18C0, 0x1980, 0xD941, 0x1B00, 0xDBC1, 0xDA81, 0x1A40,
@@ -40,24 +40,23 @@ u16 const crc16_table[256] = {
 	0x8801, 0x48C0, 0x4980, 0x8941, 0x4B00, 0x8BC1, 0x8A81, 0x4A40,
 	0x4E00, 0x8EC1, 0x8F81, 0x4F40, 0x8D01, 0x4DC0, 0x4C80, 0x8C41,
 	0x4400, 0x84C1, 0x8581, 0x4540, 0x8701, 0x47C0, 0x4680, 0x8641,
 	0x8201, 0x42C0, 0x4380, 0x8341, 0x4100, 0x81C1, 0x8081, 0x4040
 };
-EXPORT_SYMBOL(crc16_table);
 
 /**
  * crc16 - compute the CRC-16 for the data buffer
  * @crc:	previous CRC value
- * @buffer:	data pointer
+ * @p:		data pointer
  * @len:	number of bytes in the buffer
  *
  * Returns the updated CRC value.
  */
-u16 crc16(u16 crc, u8 const *buffer, size_t len)
+u16 crc16(u16 crc, const u8 *p, size_t len)
 {
 	while (len--)
-		crc = crc16_byte(crc, *buffer++);
+		crc = (crc >> 8) ^ crc16_table[(crc & 0xff) ^ *p++];
 	return crc;
 }
 EXPORT_SYMBOL(crc16);
 
 MODULE_DESCRIPTION("CRC16 calculations");
-- 
2.49.0

