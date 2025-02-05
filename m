Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22926211A1D;
	Wed,  5 Feb 2025 00:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738716929; cv=none; b=BvbakvnH3u9HcP43rQjTgnesw0Y3Ck00ATGxaOt1BJcDJTVVcrnppRto/nWOufXorPyiL0vCgSNUUQWu+euPU4jDvSxJR34wnZirz+IFKUA1qYQL4eqQ/8g2LXSqIxrXFowoT33K1+6BD4wfgBwt67/vT8QhffiK18IWYmk7TOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738716929; c=relaxed/simple;
	bh=m7CemJXEGQ8FW+1m+rcfK7LEC6O+Ar9C18VmkPsPWNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QL3MJmStNaUtbyGe+G0xPJZw2JU4f42NVQaJRc3Bc7OlsrJ15ULmmtHM4V73uNg+ZGe9Qcsro0MQPGqkn9EF0teivxeSF32OlJPvTEYaK7kV6BRAxg8GVw0h5r2SU9EYr6NwOJ7E27VfSj4xIKgULUCSnuaM+O99EqGouaX3a9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KX3GMRhl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KX3GMRhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F52DC4CEE6;
	Wed,  5 Feb 2025 00:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738716928;
	bh=m7CemJXEGQ8FW+1m+rcfK7LEC6O+Ar9C18VmkPsPWNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KX3GMRhlXb3sU+rL0Cx8giIywTo2wODedD3TRIPUMgCOH2QcYqpLldsSD0WFj0Wmb
	 YJ9jUDU+Eue9wkeUXyu+cCBanWCTUF9wclOj4rtX2hQut6T74LZFDCWBbzkjry/D29
	 fe5u+UcbpCloxaHOwBEh9braAq0ycfsuhAU4mkyU3U03VWVf2ttVlQFr2m8aj/DDdH
	 strzIpce6X6PSQGHUA7gX8+oeFS5oJELMu0ZY9+9d6LzN3HnHXPzdubF4ZmoHPEND5
	 5zz6PO547fcfe8FO3WkBL/bIcgI+PCzAMXBAXimjvE4Q0cBhAlLYbMW6IJuWq3KQQL
	 bU0xcYOAW/6qg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 1/5] lib/crc32: use void pointer for data
Date: Tue,  4 Feb 2025 16:53:59 -0800
Message-ID: <20250205005403.136082-2-ebiggers@kernel.org>
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

