Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5C01DFDBE
	for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2024 19:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730142163; cv=none; b=h4JLXm0swDN5bSv9IjgxX4obDcnUPOYGDoco2cfQODgjm22aBoaUxlk6kevhbG8HJ6YZL1usR6HDupMMxbJmvtZsa/PDzBKdm7PjO3XwhCJvNVVETu2q5jELS2iMMSGRQVNCF9akwgr+Q1okWPnbYq4BTsCrWd6cFkmKnJtNFcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730142163; c=relaxed/simple;
	bh=CS6UcgBuTMfLsyQGJno1a+xI08hKCy85Zzce1SdkcXU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b61cbY9crkDAD9pO++/mwWw0NkByF1IZOduSKbVgko4i1IkkoMHwYpCM4QIpsJ7Ve2ySXpnij+ey4eD3MJDeDiw99IIrX6QLiarW6aKYIfSFBs3K3uzc0BSSkyDBowH5DOwsES68Xp9S341nbej68ky/9LmNfzLTcs2rcqiSF5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gn8YuE+E; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gn8YuE+E"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-431ad45828aso7460975e9.3
        for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2024 12:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730142159; x=1730746959; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mW4N9RcBemcG+LSxm4j7sDWA+GX7u+7PH3vPvZyT3dE=;
        b=Gn8YuE+EeMDBKy32Evm42dcmKSpv1MKUz56wiE5hy/W+kBgDKsw0H9y+2xRUnRpviB
         ySps8D8vQEazlw6l/SoCbvaimOw0VYO1kkLjcMjT2Pg66rLiWqNHX84u9K7s3WlumNs7
         9WLlcXrUjY4u7tNAQ/QIWg0gBtkiuGnLAi+b60sAvKCXQ5JfwQUpAWeEJJOdQafp4cBI
         ceZD1Z5svZmkw0tP6xPfTHQATdKALm+qUZJiuQzwAVdmymWfCGo9lBs3Nnz8V3PUrJ0u
         5SUWoQwVbwuiiMBZcZP/MJUHkQPR9Om6eueg2aJErgqYu8EWluvIwjUYMpa0DFMdVi4r
         QfYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730142159; x=1730746959;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mW4N9RcBemcG+LSxm4j7sDWA+GX7u+7PH3vPvZyT3dE=;
        b=IDO1K4pihk21xbOd5b4KtHyqY78U7JrKyKFwmfthfzc3Td1BT/kGPTyQrxpI4d2k46
         oQPcipVMkjBoZksX6Uqs5WRV8/176yH8fus5yI9PEJPMsUIVPKTkUVyH3iPYebdloV9H
         qywbp4MpeMpOxdsNNI0+dR4oCvEpAKDrmHfqN2gKPOi+JmcsRwizZ0rist1gPN0j+DIt
         5iGtb/qMM+bnj2eB4v6oaAZqDwAqIeJBKY/0H8ROhnfMgWd/7dBc+JANGNm2Nesm20+m
         e5dQyEj7LMFFcUYBnA/ULJMubif+8pIZ/ibD7Oj02OBqecQx6ab/lG8IY+iz1/CCAIMI
         +jWQ==
X-Gm-Message-State: AOJu0Yyue+EnGdEAjndumk3dRpuptrwEi2w0Vui97S+WvKdLWhD2qIob
	kc9l5NfrBSIjp1x3k7RXWK1ySW9DHEOl+OlSor18rLJGCJqqrR6Qmxcvtav6RtjMzwilXsqL+YB
	d+NijhKhjeBL2xsPKQzhm6V5YQcq8b5hhvbZScsUTcnfdbADXyeiNxBRbhqHc78d2xM81kS/5ea
	axvn/Tl3/CTaI35utdx3wPJT2M7bYVTg==
X-Google-Smtp-Source: AGHT+IG4LbMrWCrTV5C1ezOwLSzp6ulJZwcKc6XgeUCOiB+YpT02bX0ZVvYmPcxlEno86XBHwdx9cESK
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a05:600c:796:b0:42c:8875:95da with SMTP id
 5b1f17b1804b1-4319ad7daecmr188275e9.7.1730142158545; Mon, 28 Oct 2024
 12:02:38 -0700 (PDT)
Date: Mon, 28 Oct 2024 20:02:12 +0100
In-Reply-To: <20241028190207.1394367-8-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241028190207.1394367-8-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1638; i=ardb@kernel.org;
 h=from:subject; bh=6LxElQtkWbCdfRpyCBv0NKZQB6OtvRTpcDbX0wXSeRA=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIV3+/lbNS/dteh45mPsbnXd5Eqx08v5DZ1+DmNAkE1eTM
 vXJThUdpSwMYhwMsmKKLAKz/77beXqiVK3zLFmYOaxMIEMYuDgFYCK7LjL8lel4z3zW4avv1eRf
 q933aYcd/ly+e1d634dOYdmZM19bhDL8sztomR+5vNBptpr3D4kVGzf++/oke/K9ul1lh8/ZRvB 3cQMA
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241028190207.1394367-12-ardb+git@google.com>
Subject: [PATCH 4/6] crypto: arm/crct10dif - Use existing mov_l macro instead
 of __adrl
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org, 
	herbert@gondor.apana.org.au, keescook@chromium.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/crypto/crct10dif-ce-core.S | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/arm/crypto/crct10dif-ce-core.S b/arch/arm/crypto/crct10dif-ce-core.S
index 46c02c518a30..4dac32e020de 100644
--- a/arch/arm/crypto/crct10dif-ce-core.S
+++ b/arch/arm/crypto/crct10dif-ce-core.S
@@ -144,11 +144,6 @@ CPU_LE(	vrev64.8	q12, q12	)
 	veor.8		\dst_reg, \dst_reg, \src_reg
 	.endm
 
-	.macro		__adrl, out, sym
-	movw		\out, #:lower16:\sym
-	movt		\out, #:upper16:\sym
-	.endm
-
 //
 // u16 crc_t10dif_pmull(u16 init_crc, const u8 *buf, size_t len);
 //
@@ -160,7 +155,7 @@ ENTRY(crc_t10dif_pmull)
 	cmp		len, #256
 	blt		.Lless_than_256_bytes
 
-	__adrl		fold_consts_ptr, .Lfold_across_128_bytes_consts
+	mov_l		fold_consts_ptr, .Lfold_across_128_bytes_consts
 
 	// Load the first 128 data bytes.  Byte swapping is necessary to make
 	// the bit order match the polynomial coefficient order.
@@ -262,7 +257,7 @@ CPU_LE(	vrev64.8	q0, q0	)
 	vswp		q0l, q0h
 
 	// q1 = high order part of second chunk: q7 left-shifted by 'len' bytes.
-	__adrl		r3, .Lbyteshift_table + 16
+	mov_l		r3, .Lbyteshift_table + 16
 	sub		r3, r3, len
 	vld1.8		{q2}, [r3]
 	vtbl.8		q1l, {q7l-q7h}, q2l
@@ -324,7 +319,7 @@ CPU_LE(	vrev64.8	q0, q0	)
 .Lless_than_256_bytes:
 	// Checksumming a buffer of length 16...255 bytes
 
-	__adrl		fold_consts_ptr, .Lfold_across_16_bytes_consts
+	mov_l		fold_consts_ptr, .Lfold_across_16_bytes_consts
 
 	// Load the first 16 data bytes.
 	vld1.64		{q7}, [buf]!
-- 
2.47.0.163.g1226f6d8fa-goog

