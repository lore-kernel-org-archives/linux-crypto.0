Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18018F64
	for <linux-crypto@vger.kernel.org>; Sat, 14 Jun 2025 00:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749859727; cv=none; b=spBoO6QujRYsos3niTW6RrynC+CLsN284p+YYsDKRucRe2xOxSnwJKpks9YgVLsML9oBSPoTWGC0z5XHyl4z+Weiul9QKQkcyAwpntWMr/GKD6l4NEk57ATv7b51W47b8rndX9c32I2b6C//UWCL/lNXRRKvpJmTAdMx6L6itF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749859727; c=relaxed/simple;
	bh=RRBTu/UcJXCy6H5m8hEZ9SDf/wYMt7phWeAfO5CJBvg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hBp3+WJ4bSjQGur5VWkV7YhzyNwdhsD4U6UL78igMFKKYOR9yrF9b/NeExCgmmaCfLDWsmQhhfTR/63yV7T38DkHCXGG7cHfMYJ0YenSAPS9kMNlHjGA8EeWX+QAwpDFucMvNDAN5jarW1RJAtaV3ABaNmBhRGdz3T9s2cbkfnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--yuzhuo.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=odTwI1Os; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--yuzhuo.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="odTwI1Os"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2c00e965d0so1682512a12.2
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 17:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749859725; x=1750464525; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mTDG/TDgRblDx+LSEqZBeH+bLXhEOKS8TgJ2OAQlhBo=;
        b=odTwI1OsjEWVaFb9YBnnI+ntXv7R8r9+miMrfgNXPWmkYxcRWD74T8LH+vjbhO9hIl
         +G3g9mhssQwqakKZF6HtLg9Rt8MItzzgpZvuQ1dZvyHUnavh9Z8le5vW2OwSjBHYQMfA
         ML1HKwv77QMCd1+U2parSelj10GDMzl080GB8AXjlTGEm2+G5rnXEjUxtXC2syKoV/SF
         46sKsYBDfZubG7lXsERKtVMMQ9oXTP9x+EdoZ4j2pxnj0FGxDwO2nbP6Rh3Js9yK+PXJ
         iitPJaJzf+NsErEwpICUI2VwtwRKdErzaFkeb7oBLbJ9bYku5mHtYQMdfDd+3bn2LLzu
         lKiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749859725; x=1750464525;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mTDG/TDgRblDx+LSEqZBeH+bLXhEOKS8TgJ2OAQlhBo=;
        b=dxOTHHjYV1po7E6ATUOBUDsY5IZhgjTyVWckRAi2pFsNdSnTB/p2OT1qg67ObhEvVb
         ufywT6ag+LDP2VADZ7cS0IPFGI2vqPahQWwIR6ewL3t7Xp+I2jw2a2F71yuE0UDSlkdY
         El9/7pNeKaPXS9lfux+57GbAwVrxwxmILBeUQ7dA2Ron9zM9dkk893XKXh0MhadXlPZP
         ezmRn76L8nPMGonl0O24r10l48SqDFfjFeL6qiAKp8wusi9caEPA3YY2mODGhmB21OQN
         E+IqsmxLC1owWaCwwYOmgZnI3fqdsag5GUxFN0lAe2paKtssUsY36XMnMycOKIbCRyoA
         b+mA==
X-Forwarded-Encrypted: i=1; AJvYcCX5/5lb5/ZN0xwZ3aJTAUE/cV924XVwZ1AiN4NVnNgU8F3DySiEfShF4O4lrguowT+cq4QC+5r4pPxn5CM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhwxyIPp9MM6k7yA+bFHmm4PGMosA8t6pmxg11KrfU9NjvLcb/
	LZ2NdAiGaLjqmsF5oQaL/F2YfVVG/kQB3z5rsXKD0Z0uHXJho5VKYoE/Hxaa4OZBkORn+PM6jQc
	BC9z8DQ==
X-Google-Smtp-Source: AGHT+IEgdl4JGvpGQHTlvQaZuMAmSd299962DqOd1Lqu7h2Sb8LIi/Q/7YD1GjewTKOR9QaSRwJAcNHb+mY=
X-Received: from pjtd4.prod.google.com ([2002:a17:90b:44:b0:311:a4ee:7c3d])
 (user=yuzhuo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:da90:b0:312:daf3:bac9
 with SMTP id 98e67ed59e1d1-313f1d07b65mr1845678a91.34.1749859725002; Fri, 13
 Jun 2025 17:08:45 -0700 (PDT)
Date: Fri, 13 Jun 2025 17:08:27 -0700
In-Reply-To: <20250614000828.311722-1-yuzhuo@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250614000828.311722-1-yuzhuo@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250614000828.311722-2-yuzhuo@google.com>
Subject: [PATCH v1 1/2] crypto: Fix sha1 signed integer comparison compile error
From: Yuzhuo Jing <yuzhuo@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Ian Rogers <irogers@google.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: Yuzhuo Jing <yuzhuo@google.com>
Content-Type: text/plain; charset="UTF-8"

On platforms where -Werror=sign-compare compiler flag is enabled, sha1
code gives errors when for signed to unsigned integer comparisons.
This patch fixes the issue.

Signed-off-by: Yuzhuo Jing <yuzhuo@google.com>
---
 include/crypto/sha1_base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/crypto/sha1_base.h b/include/crypto/sha1_base.h
index 0c342ed0d038..3460759d31db 100644
--- a/include/crypto/sha1_base.h
+++ b/include/crypto/sha1_base.h
@@ -73,7 +73,7 @@ static inline int sha1_base_do_update(struct shash_desc *desc,
 static inline int sha1_base_do_finalize(struct shash_desc *desc,
 					sha1_block_fn *block_fn)
 {
-	const int bit_offset = SHA1_BLOCK_SIZE - sizeof(__be64);
+	const unsigned int bit_offset = SHA1_BLOCK_SIZE - sizeof(__be64);
 	struct sha1_state *sctx = shash_desc_ctx(desc);
 	__be64 *bits = (__be64 *)(sctx->buffer + bit_offset);
 	unsigned int partial = sctx->count % SHA1_BLOCK_SIZE;
@@ -99,7 +99,7 @@ static inline int sha1_base_finish(struct shash_desc *desc, u8 *out)
 	__be32 *digest = (__be32 *)out;
 	int i;
 
-	for (i = 0; i < SHA1_DIGEST_SIZE / sizeof(__be32); i++)
+	for (i = 0; i < SHA1_DIGEST_SIZE / (int)sizeof(__be32); i++)
 		put_unaligned_be32(sctx->state[i], digest++);
 
 	memzero_explicit(sctx, sizeof(*sctx));
-- 
2.50.0.rc1.591.g9c95f17f64-goog

