Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649B32BDC1B
	for <linux-crypto@vger.kernel.org>; Wed,  8 Oct 2025 15:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759938411; cv=none; b=JO1h+SOW8cXWRiFfisXgtoWz5NZiH3zPOCvBEJPz4T20HKOrFJITiIHpmGHYj1Xg7rgwdiD5crKxQr8P8X8bmNsrrv4O+SQFLZWLKYJyj50JoQTJTJDLOVr+iv2ESmWGnqGJb9HMbKLs/29nbDXWBn15Ah8/gZUbHpRrJAM0ol0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759938411; c=relaxed/simple;
	bh=81RCAUhzxGVASsLN/Sj+xtc3cF0rIGFNTxe2ppMxs6A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RDW/4ZSTdP46gSVq3DDeLF2dMAqRKAm0F9Rd7uEbduKsyXxEOvrnlU5xH8eXcY0lGmKh+YOvIx92i1Jzh+yCznt/rc90eAgOYcPJdzq5HaAp8gJ2rjBCoYTv/iMvakHVsC2Iz2TfoS5100SfgEq/bMFoBaFkpwtTRv6F7VZ3Isg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OEwFH1Kx; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OEwFH1Kx"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6305c385adbso10124675a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 08:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759938407; x=1760543207; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0aOpjZgoFTagPU2U7+lhs7TWsUUBL3VjC18ylyP94Gs=;
        b=OEwFH1KxTvKNXc9bq+YswcwfENtIULETZ1TtiVs3cm+YpI895pHJ8rc6WCwYr5J5ts
         Xfr+cokOHdl61V7X9KujDAzdEN8NjLI8Jr1yfmdKbq9N5N6PmCFb31FxvcmX92b+Yh1A
         mo09X4Utq6DBsT/XTWpBDGXd9wbC/9TBhUcga9cgApie2B8c5ZdeGuG7tkeLzTcL5BM3
         8xRnwxAEhmC7VKA/Y0vvfZB/6a9DaUgoXeVJlw4ZZl6f1x5XEzWNGhM0BWLOl2XQCBIx
         rkEj0PLYfJ4NnbPVMBFByMQFORrMEuTNUMuU5OTIc9dYC2A2NNTApea1w++3swzuQphR
         b6fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938407; x=1760543207;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0aOpjZgoFTagPU2U7+lhs7TWsUUBL3VjC18ylyP94Gs=;
        b=lGVqT4NAsnUOIiPRGUOfi36eGTWANkzV/n9GUqfqoITExaF+mADnB/55lVg9TVjyu5
         TV37Y9GHOHPBb2MuB1LRyzGqFqixQz7boKTCqL6BIL43sjO6VBTXjZyiGrXSBdQNnr2L
         tUpWs4MMwB2dIGZeQhg/ej1kuDQ9e+sbg7+IO0QNKijrqxunIClTJyES6zeDh0f+oLpr
         5B1gj5JkSnR9ny0lrEVHsaZAxjxju0zkDSe2PU6SkbRdh5Xk/AiIunsYIEVed6Yvt41G
         H0oZGOoELyK6hEL9aSeevleq+fuYjhcMUK5dpYMAe+dqTv7+MorplLlE93BSWWmNhTra
         FlQg==
X-Forwarded-Encrypted: i=1; AJvYcCUq/L/Nd/14ilQ/eYu25BXGZjQa9gB+5cv+IEHi1zGfXi7KQr0iFiUGAz6kiGxKoGo1yXkSi3geJ5Gltz8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzW9+643b/mVj2wH8A9sbEBvO7IiX7cP4rJKKbo0oPDAFsl4/Ni
	nXjWZ+JdKxKXYxahkrrfxaEVzhyeQ7BWyn9g/eQpdEs92+3nU5JSY+Id1eb6WcTHPwPEpSj/LA=
	=
X-Google-Smtp-Source: AGHT+IEjXfSRLqs1LdB6T1FDKUwIpLPy5cDnenPLXjF2fx7wJgZU+J3eEdql/LMEKYHPQ3roG7kHp6XU
X-Received: from edzh6.prod.google.com ([2002:a05:6402:946:b0:637:87fb:3b14])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:518a:b0:639:6bc8:c7bd
 with SMTP id 4fb4d7f45d1cf-639d5b89335mr3498965a12.15.1759938406837; Wed, 08
 Oct 2025 08:46:46 -0700 (PDT)
Date: Wed,  8 Oct 2025 17:45:36 +0200
In-Reply-To: <20251008154533.3089255-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008154533.3089255-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1857; i=ardb@kernel.org;
 h=from:subject; bh=j9GSsyZWNvCHsZ+73xBchQmAL5ZAXeZZs4NWX80DqD8=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeNZu8rfJAkfjdO/9vefY02Zc5ad2+qC2S4lbn8HkaMf6
 6Lv5f/qKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABPZbcXwz5j/pePnsrXLRIR8
 Hq0oNPfN4NuQPeX7guViSn0WLx5O92L4n2s8Y/Yhht5nll/sv2RFRi8UzXQ75xt2sXyZqpx+ilA yAwA=
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008154533.3089255-25-ardb+git@google.com>
Subject: [PATCH v3 02/21] crypto/arm64: sm4-ce-ccm - Avoid pointless yield of
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

Acked-by: Eric Biggers <ebiggers@kernel.org>
[ardb: Simplify convoluted logic]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/sm4-ce-ccm-glue.c | 25 +++++---------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/crypto/sm4-ce-ccm-glue.c b/arch/arm64/crypto/sm4-ce-ccm-glue.c
index e9cc1c1364ec..e92cbdf1aaee 100644
--- a/arch/arm64/crypto/sm4-ce-ccm-glue.c
+++ b/arch/arm64/crypto/sm4-ce-ccm-glue.c
@@ -172,35 +172,22 @@ static int ccm_crypt(struct aead_request *req, struct skcipher_walk *walk,
 	if (req->assoclen)
 		ccm_calculate_auth_mac(req, mac);
 
-	while (walk->nbytes && walk->nbytes != walk->total) {
+	while (walk->nbytes) {
 		unsigned int tail = walk->nbytes % SM4_BLOCK_SIZE;
 
+		if (walk->nbytes == walk->total)
+			tail = 0;
+
 		sm4_ce_ccm_crypt(rkey_enc, walk->dst.virt.addr,
 				 walk->src.virt.addr, walk->iv,
 				 walk->nbytes - tail, mac);
 
-		kernel_neon_end();
-
 		err = skcipher_walk_done(walk, tail);
-
-		kernel_neon_begin();
 	}
 
-	if (walk->nbytes) {
-		sm4_ce_ccm_crypt(rkey_enc, walk->dst.virt.addr,
-				 walk->src.virt.addr, walk->iv,
-				 walk->nbytes, mac);
-
-		sm4_ce_ccm_final(rkey_enc, ctr0, mac);
+	sm4_ce_ccm_final(rkey_enc, ctr0, mac);
 
-		kernel_neon_end();
-
-		err = skcipher_walk_done(walk, 0);
-	} else {
-		sm4_ce_ccm_final(rkey_enc, ctr0, mac);
-
-		kernel_neon_end();
-	}
+	kernel_neon_end();
 
 	return err;
 }
-- 
2.51.0.710.ga91ca5db03-goog

