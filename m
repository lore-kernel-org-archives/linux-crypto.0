Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FB717D366
	for <linux-crypto@vger.kernel.org>; Tue,  5 Nov 2024 16:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730823260; cv=none; b=tZcOsYGorQghghBSRtGFol5h3fq8lY7s7SkUgI8vHQ5Xhb/nbQi0PBmgscmYWbYFh8Ja4CpMKOw33KtoTmAZUNuxBEnT12H60Lub+xqk+AKvQEdpI4hwdzT4guKOTlTremLZ6LzQNUn7L3SzfktJt9ZQx3dBh37F3fg3qeHjRas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730823260; c=relaxed/simple;
	bh=8oIY4h4B74i1xUTGWfVW4amdouYKz+ni0Kezd1CGvxE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A/bJ72HPLl4XqSXv048Pk8Qey0aEjzjV+I/JBCBYot+kaMxGr5ep98ZFC4adzli2L47dKkJJpNhi/vtunCrxwm9KEuBekVzxAXMhBpjso84U9GJouoQHVbcp6RKG2iLyywVgSMUdBqgt+TOip9QCfni8wuKcBIIj1S4UkoQM0Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mz/HAnmp; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mz/HAnmp"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4314a22ed8bso39886155e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 05 Nov 2024 08:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730823257; x=1731428057; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6N2VBOA9rFVK0/GkkoRg7xkFe5ZWEmXf+9rCp3hK2ew=;
        b=Mz/HAnmp35o7mzSHEHyBFY0wqwgkG7m22KA/j2djoUhhz6PGwtbjlhNoVrM8Vmuq/F
         pObCJWjKp4lRcvoR5Wpnfpy/HwhAEYiacYoHEkvmSIz7w8+pYVRztp/t5ZGUqkbfNJ1P
         +k7bHkMsdKTgOQtrnqjX9veTlw7jNysDVD6kNmV5KcIPdq1diNdcrA6M704QzuRpjv4q
         aiqeWTdn0oPtz06YhpNsxcBREgPcbTgg/ZGPZu4O4ndgZZfBJKDVEuh6XtYoITTkDvV/
         Hzptrx+yoFcdmRsX06WpSUb1AhXOQ6rwZUhgGHhcQf7ONB1X2mgathwQMYew6WwfbCxm
         OD7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730823257; x=1731428057;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6N2VBOA9rFVK0/GkkoRg7xkFe5ZWEmXf+9rCp3hK2ew=;
        b=wkQ6wgjK9AGi2Q09zDgY1xN4HqNdy1v59JGcDgKu9k4n1YrM8WPj+hYh91En/XeBU6
         lEwLlhZ2erlB5w1v9QP/K4uN6bRNRp+vdoVSgyN8hQC9bd35hfXjTrgmUkEmYJWDoIwC
         I6wkD9zvcNTYRT4T2JzPUIj2GNS2BNwpW2Wj22xLMZvLYFZsdJZk+PRryZ2SDLmDl2n5
         LPKZpNHIE3Of6pGSqdrj9Pvc/ltC5mclacZmfdaNpNkFjvE9N6mDJ9geGCfaQG5vEmQM
         PdnZMVX69vD1lRXVzrhBA167KjS/YfhFJnKRxwE5GmY0Pv0tH1A1AormDB8cjQITmwXG
         EL0w==
X-Gm-Message-State: AOJu0YwdJFIueBpRxJP/dGQawHqrIhhPMFJZKJTna3QADZP5DhVTChh2
	e4keuFjEt/DPDEKvmU8dUUoZDzxF4Tk5MFEcmnREi/zY3so7Nng79FLPgWU3I3DVBLAz/WTxptS
	a+RlqMK2ibwVqeesGdFZIYsOp4jWlldSrvOp+k9s/LDGuee6lXH9OEBqGIH006tRortndJnKMbp
	aKbh6bbNQtUhEynVavi8O5YzCOx+d7qw==
X-Google-Smtp-Source: AGHT+IE1eGkHlmoaTOuZHS5yxUb+zHYCL/xdGqZApRlfh1/UEprDAnMdWsqBst7cBf+cLypOHteKNsFR
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a7b:ce8b:0:b0:42c:ae30:fc33 with SMTP id
 5b1f17b1804b1-4327b7fcdc4mr378795e9.4.1730823256859; Tue, 05 Nov 2024
 08:14:16 -0800 (PST)
Date: Tue,  5 Nov 2024 17:09:04 +0100
In-Reply-To: <20241105160859.1459261-8-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105160859.1459261-8-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1687; i=ardb@kernel.org;
 h=from:subject; bh=AKN1MPIUQxwxJZBx0Ms0cbfUdj7H9BFpnNX0+RF49+Q=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIV3LWSl0q66lZ/662TXljbc3tB3cpZ1md1SgeJnF7gcV7
 kpXJl3tKGVhEONgkBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABPZlMTwP1qsR+bTg3cWmeZ3
 100Pv3aS6c5lwZVFc+cydibuvKl57hXDP90Dv1ScRJ4vyVG8d6rs+/tLiuqt3RJqnQ3+J9elpz3 azAYA
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105160859.1459261-12-ardb+git@google.com>
Subject: [PATCH v2 4/6] crypto: arm/crct10dif - Use existing mov_l macro
 instead of __adrl
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org, 
	herbert@gondor.apana.org.au, keescook@chromium.org, 
	Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Eric Biggers <ebiggers@google.com>
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
2.47.0.199.ga7371fff76-goog

