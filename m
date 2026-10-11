Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D4725F98A
	for <linux-crypto@vger.kernel.org>; Sun, 11 Oct 2026 05:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791695739; cv=none; b=IK4RFYIvBL4rmLGED20027GerbvIEJj0D2a5zsrIh3guM8oSmqR4jRvhp8cHFDy+gkk4Kp8KCYuNRE62pKT0qDEO4ifNxDEGqnTC+yqzg3ZjXevTHTTPBy+o787Yaq5jXbr6oJimREtVp1cOgpaE5VqVFITwskyi4h0OPOJRjVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791695739; c=relaxed/simple;
	bh=9BunIciQcKJsll7WyEutsDEQR74br6ZN/XmTthqtjSY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CKh6z+Qj9d5rKgpp3VjtL5OMgvOab5HKo/fIvP1yxdxSw4vGUKezT8gv5f2EHsZXg9RUVbj4N40NxtXxDa2GEkf+XyGTkYrMZv0rgC5He9ifs74hkD0Lzur5ex99yFleVILb96zwW/WQAzmK+idgQmUKNtSt9W3r1fT4HH2IscA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gkx+ZtL+; arc=none smtp.client-ip=74.125.82.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gkx+ZtL+"
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-3282db206d3so3535521eec.0
        for <linux-crypto@vger.kernel.org>; Sat, 10 Oct 2026 22:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791695736; x=1792300536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=H3Xv76cxiscF9BmNse8Pdd0IVkWBwffvOMSzyozEsUU=;
        b=Gkx+ZtL+GEuzt3snJ2cgpKjhMSwt/cN7MmSa5H2axjHfR0x7V+fz/0w+p3LMVuxSmn
         +hGB/EVto2ORFN5ytisA5l8HM8c9Sdy3Ju5qkuHHN5HF/yVG4KqT8VLrC/ZhDLkCC74U
         eL8yzLrNVAFaInNcrYToSMTv8wqs41iDgLkzBA0GW1/X5w/Wpux+pQpIB7HgZKqwI7pK
         ffee2w3iDsv1ExcDbwaMKTZpXDZtdoAVmd9DWDahG4mLp+kavklzc0/AWi0Dgr8rk5FG
         6n3a0HPndTJJTBABK/MSFPUn0TZajG9uLs9HKrKcdJ1orxBOGDYroWchNf6rLaoKv00W
         yyzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791695736; x=1792300536;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H3Xv76cxiscF9BmNse8Pdd0IVkWBwffvOMSzyozEsUU=;
        b=txmmJ33hijDGqJoO8u+j86plbZpcj/t5PtTljjjHto3bQzTbuMl02+jNm29uNfMgUF
         7Ud3V8visXkkM3tqIqPdItr8wNoUj2tf+fqhqHLFtKOgxgAxjNnwWrmY8TwlgKCtULQJ
         Sq5PnhvaTluNeacF4PbPVSqZYHSXVBcENS8kf4bq7cSiCm4FMS/vd0oGBgO5l5EFj8/c
         t4ioRt9N0aiuG5EexD9W5uJwOZ2NfLP/pZwCVy2c4Tz/2OXYiZ397ofbNvwqPffXl6Nl
         ic91DXHS2pnN8e3rfOGW0ye82YpPszUXAD6fgnTv7bZ648D22aS2H40A2l2y2SH4qatY
         Q2qQ==
X-Forwarded-Encrypted: i=1; AKwUvBwDVK1N/5oyEClw9b31kQfzSOKlOFdckrUJAfkg9QElVcF26NnF/GX3q6ZUWDDUxwaZqMfFhGY3uN0aeYk=@vger.kernel.org
X-Gm-Message-State: AFq9FYIUl0tg1J7bhh0xgnlCwgIKrHzwPgGbuPhgNdP4q4PChSBcnF3H
	ozKx5FTjxl2H65pTi+5JHvO2GSI4GV7L2t6gP4O/1I7jnSL2nDzK0ynlKOv8TA==
X-Gm-Gg: AYBFou2hPCaWqeQOWRJWBMen+Ij2B6pUoupnquJH4IBVn2xkxCjBBo0qLlHN3cVvhHs
	RALhSTz7hWTVzJJ7+/zvBJLeEWLkHYjLii4OzxbEZLSZE4U3heNxWrbizzOEXqRTWnnj8d+KuOZ
	RtxtFvS87E/genhEeyYrauYANvmTubLAeeO0+UOHonMKpa0qjnBVB/1FYNkcP9itN05JwOAvifX
	iOFSxwf35fx5/WIPApGbOFz+aEmqmEzolL04mhJ0VsPjsY6QIH8dkXjNRHWmx5WO5Cqm9j4oOtk
	Lb0ulxGUY8fIWsSg8HC4LRZrVD1FgW3hcfSro78ZsQhYUjSZ/7KLyHjE1jt4QZYsHsqWHJDg2hZ
	iooVJrWG2ZpPTXZxGYayaUCYRRR20dtusCAGX74XVhdOLliFo4yCslbu6ur1i2uMpYcyvBobZtD
	+WiwhuSmrpEr8kf8Zehj+/HRqfyn2Mw3yd7l4D+/bagpcRLBKDN94SMbIv2DYzRPatkaV5IZX+I
	CNlXkYv8FasRJI=
X-Received: by 2002:a05:7300:4306:b0:34e:67d0:bbb9 with SMTP id 5a478bee46e88-3537e0368fdmr13315398eec.29.1791695736039;
        Sat, 10 Oct 2026 22:15:36 -0700 (PDT)
Received: from kernel ([45.251.35.97])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cb2954bsm21382050eec.26.2026.10.10.22.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 22:15:35 -0700 (PDT)
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: ebiggers@kernel.org,
	ardb@kernel.org,
	Jason@zx2c4.com
Cc: skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Subject: [PATCH] lib/crypto: sha1: use put_unaligned_be64() for length encoding
Date: Sun, 11 Oct 2026 10:45:24 +0530
Message-ID: <20261011051524.6703-1-raizudeen.kerneldev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The SHA1 final code in __sha1_final() and hmac_sha1_final() writes the
64-bit message bit length of the SHA1 padding using direct access
pointer casts:

`*(__be64 *)&ctx->buf[SHA1_BLOCK_SIZE - 8] = cpu_to_be64(bitcount);`
`*(__be32 *)&ctx->sha_ctx.buf[SHA1_BLOCK_SIZE - 4] =
	 cpu_to_be32(8 * (SHA1_BLOCK_SIZE + SHA1_DIGEST_SIZE));`

The rest of this file already uses the unaligned access helpers like
get_unaligned_be32() for reading input and put_unaligned_be32() for writing
the digest, for all structured buffer accesses. Replace both casts with
put_unaligned_be64() for consistency.

In hmac_sha1_final(), this also writes the full 64-bit length field
explicitly rather than writing only 32 bits and relying on a preceding
memset() to zero the upper 32 bits. The resulting bytes are identical,
nothing changes functionally.

Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
---
 lib/crypto/sha1.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/crypto/sha1.c b/lib/crypto/sha1.c
index b687b89d97cb..17d97160d578 100644
--- a/lib/crypto/sha1.c
+++ b/lib/crypto/sha1.c
@@ -183,7 +183,7 @@ static void __sha1_final(struct sha1_ctx *ctx, u8 out[SHA1_DIGEST_SIZE])
 		partial = 0;
 	}
 	memset(&ctx->buf[partial], 0, SHA1_BLOCK_SIZE - 8 - partial);
-	*(__be64 *)&ctx->buf[SHA1_BLOCK_SIZE - 8] = cpu_to_be64(bitcount);
+	put_unaligned_be64(bitcount, &ctx->buf[SHA1_BLOCK_SIZE - 8]);
 	sha1_blocks(&ctx->state, ctx->buf, 1);
 
 	for (size_t i = 0; i < SHA1_DIGEST_SIZE; i += 4)
@@ -267,8 +267,8 @@ void hmac_sha1_final(struct hmac_sha1_ctx *ctx, u8 out[SHA1_DIGEST_SIZE])
 	memset(&ctx->sha_ctx.buf[SHA1_DIGEST_SIZE], 0,
 	       SHA1_BLOCK_SIZE - SHA1_DIGEST_SIZE);
 	ctx->sha_ctx.buf[SHA1_DIGEST_SIZE] = 0x80;
-	*(__be32 *)&ctx->sha_ctx.buf[SHA1_BLOCK_SIZE - 4] =
-		cpu_to_be32(8 * (SHA1_BLOCK_SIZE + SHA1_DIGEST_SIZE));
+	put_unaligned_be64((u64)8 * (SHA1_BLOCK_SIZE + SHA1_DIGEST_SIZE),
+			&ctx->sha_ctx.buf[SHA1_BLOCK_SIZE - 8]);
 
 	/* Compute the outer hash, which gives the HMAC value. */
 	sha1_blocks(&ctx->ostate, ctx->sha_ctx.buf, 1);
-- 
2.53.0

