Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C4933FE14
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 10:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761907192; cv=none; b=YUyjgqT1bmd6Eln/KoebJl95YEbEJg8mKAKcKQy7+ETQv9dK3FDk830QJkbqalcmg1OF2X40RRhfbyFRflZBctJLDY/bmI8hwTvVws6bEUHrextmqdhsUMQc75rznTH6+KV3+SHSr+k6EtOXc3sZ/LaMAaBeME3A0N06LFc0y/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761907192; c=relaxed/simple;
	bh=BJMZI7b2vwwoob2+Y/C61N/aS3PcsU16KD7zSWRIv08=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i0jEJJFmKuGvNraUj4kL5ftdbmOAzDc03fukFX67+6pDaevamBYGLIJSbot6AvlDBKEvGPChcxixrsTne4QActBFg36pjF/ea3MmBGhrUz5FNd5mz5PTWTwI70g9bmQsWXoM8boIjuHxcdgO1JRyM0tIah9RHxz9zlcMzA0qmOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zmJOF90J; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zmJOF90J"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b707e595229so25074066b.1
        for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 03:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761907189; x=1762511989; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZwX5OSigI0JdbJe/ghC6Nz1Hun3Gyl+7nBcMkOknwv4=;
        b=zmJOF90J+kw76CagWPYlBFYUmEIXeEdDoZwtr5NZT8gS3XkzXcXH17rcFsR1GRGKIz
         LJGZfGEVH6vjL0OeuOGsY/eaNlP1TJhTiFU4snMFVQL3HebGhLNaJ/9aHJbKLupuVsW9
         Y7ksQ36QYxjL5ST8jaRaTujbeVLWBMDtXIcqhqZOZ0CckiSk8Jy9naU2ESl+4OGlBP5c
         T99OdxY5MDwQbGQb+W0QNt1+zfz5s/sNS5yw2pJV7WB0WJR30pXI7PO6ohFH90Vaiemk
         L4qb34g7EXyj0kfID+iM2KgFXz1DGkzTLR7QYzFtLTO8k/1oJzaCr0qi/Eg9VuIlXnJv
         lGVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761907189; x=1762511989;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZwX5OSigI0JdbJe/ghC6Nz1Hun3Gyl+7nBcMkOknwv4=;
        b=lKjbig/jYjJ5bLnnJAc+DgG6r3c1We+mhAYTfJR98AkwzDA+mLxAc9QPcIj7cn0h0G
         /h1OP0HJLdy0ft1HL7i4iDS32hK3Owqx2sSDQOrmZf2WD0jOpHeROOCtlKaABOEXOVzV
         eJ6VyJkQM8dGmNwUXPrncc0BmHhdiHI9Ou6ZlSRz5hGcuwOkW5pJx0hZG5aZsR9MQZ3F
         Sd3FxXlaw4kme3Gv6bmuHz2VG6PvIGruz3j9LSwGIkBBqZoSzfyyZDTuL1xU1bR8cEJM
         6kqB0kNt5m8/5TCZ9wegVNC8dE1Rp/lQ70U7QZiivQfn/BAeCuybjYLhrGJ0CaKcVR6x
         Pdew==
X-Forwarded-Encrypted: i=1; AJvYcCX2yoDFSacoyzXz3U2lZq2M4a391kGfhviPXwwrHoVmAQPqsMnutgWBV21IRrY+WMrkLQH6kWNgneY5ams=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgQmG50p/np5u73mdacmlK8M5nBVBVT3ttMKsLN5DJrhSxcasB
	VU5qjrj3vVNIauq/D6sb3uPHKF5TInGKgfX+3dXg3qnmKi5vgW/v6uAdLaB7lEg2LXwSU+/vmQ=
	=
X-Google-Smtp-Source: AGHT+IG2w9Vi0qrSdd2t9CIYM3Jx8PEua5OuP5pZQSuAoghiP0ZDJ01QHeEVRbAeOEHa+k//Ah65fYrH
X-Received: from ejbmd20.prod.google.com ([2002:a17:906:ae94:b0:b6d:5fc2:65ea])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:7241:b0:b40:e7ee:b5ec
 with SMTP id a640c23a62f3a-b7070845975mr319361266b.59.1761907189198; Fri, 31
 Oct 2025 03:39:49 -0700 (PDT)
Date: Fri, 31 Oct 2025 11:39:02 +0100
In-Reply-To: <20251031103858.529530-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031103858.529530-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2015; i=ardb@kernel.org;
 h=from:subject; bh=HLMA/w9qPUHfG22juJFC8tVZVVYrXXnkL8gtOvgDLHg=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZNl4vGA/peW+wtXBbVv7Dpsf1jj5lGGQqNs5jdprn94z
 b5wBnzsKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABPJnMnI8LL7+4pN6kEvdOb1
 bjocqLR//fHEVdcE4yWCrAU2iy2Yp8zIsCdvqadSueE7XuVPQucX/n3y1+LMi9Bv9y+1n33y/2X KbEYA
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031103858.529530-26-ardb+git@google.com>
Subject: [PATCH v4 03/21] crypto/arm64: sm4-ce-gcm - Avoid pointless yield of
 the NEON unit
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Kernel mode NEON sections are now preemptible on arm64, and so there is
no need to yield it when calling APIs that may sleep.

Also, move the calls to kernel_neon_end() to the same scope as
kernel_neon_begin(). This is needed for a subsequent change where a
stack buffer is allocated transparently and passed to
kernel_neon_begin().

While at it, simplify the logic.

Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/sm4-ce-gcm-glue.c | 25 +++++---------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/crypto/sm4-ce-gcm-glue.c b/arch/arm64/crypto/sm4-ce-gcm-glue.c
index c2ea3d5f690b..8f6fc8c33c3f 100644
--- a/arch/arm64/crypto/sm4-ce-gcm-glue.c
+++ b/arch/arm64/crypto/sm4-ce-gcm-glue.c
@@ -154,36 +154,23 @@ static int gcm_crypt(struct aead_request *req, struct skcipher_walk *walk,
 	if (req->assoclen)
 		gcm_calculate_auth_mac(req, ghash);
 
-	while (walk->nbytes) {
+	do {
 		unsigned int tail = walk->nbytes % SM4_BLOCK_SIZE;
 		const u8 *src = walk->src.virt.addr;
 		u8 *dst = walk->dst.virt.addr;
+		const u8 *l = NULL;
 
 		if (walk->nbytes == walk->total) {
-			sm4_ce_pmull_gcm_crypt(ctx->key.rkey_enc, dst, src, iv,
-					       walk->nbytes, ghash,
-					       ctx->ghash_table,
-					       (const u8 *)&lengths);
-
-			kernel_neon_end();
-
-			return skcipher_walk_done(walk, 0);
+			l = (const u8 *)&lengths;
+			tail = 0;
 		}
 
 		sm4_ce_pmull_gcm_crypt(ctx->key.rkey_enc, dst, src, iv,
 				       walk->nbytes - tail, ghash,
-				       ctx->ghash_table, NULL);
-
-		kernel_neon_end();
+				       ctx->ghash_table, l);
 
 		err = skcipher_walk_done(walk, tail);
-
-		kernel_neon_begin();
-	}
-
-	sm4_ce_pmull_gcm_crypt(ctx->key.rkey_enc, NULL, NULL, iv,
-			       walk->nbytes, ghash, ctx->ghash_table,
-			       (const u8 *)&lengths);
+	} while (walk->nbytes);
 
 	kernel_neon_end();
 
-- 
2.51.1.930.gacf6e81ea2-goog

