Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6467C1A2646
	for <linux-crypto@vger.kernel.org>; Mon,  2 Sep 2024 16:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725293965; cv=none; b=CexhTvhGuBwrjqd+KABGZMqmnXqb0s9XPYls1M2mEmPsvQH9dNWTpdX0CDZ6K0YtuP/vLKEsCJepa0GsD3s4LWCORlrWq1OVzkR4X+GKFj5lpt0pldEJCFrbe81yh66R+IHsj31jCQqYTLY+CJeEx4Y4pfCG0zTxJUJjW4cNoko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725293965; c=relaxed/simple;
	bh=44yzxRSTqwlOROlkCwEXzmTbMUBKaeO1+N1E/oREDTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EggcZAoVp/ihuuYPyRvdWJNRYB9VMAKHH108PUk0buvvRXOb4zrDczh6MmqQ6GavuThi+1Z++H37xPDBoPnTnPAHHxeacK9msf8bT7g2bGDkvVLeH4WJXLr5Zw59thaZXQWkMIwTE5nG7OGeBhC3/gLm+v/uf/OH40NGDRIPOEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lwcYyvop; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lwcYyvop"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-42c7a384b18so17506925e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 02 Sep 2024 09:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725293962; x=1725898762; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/DUDom//tRZnCzR0TPrW7dnmFkZZ6kQdXEFrODb12u4=;
        b=lwcYyvopyDeBgfSRp7/tIiAcqCkEOuFwD51W4k3NPu9Z6o0XfXuP2+72Sw/TLb8l22
         nQoGWBcyhptiOP9BWeovgiZROJ/CsKQPSFiQKAz6HVa744lxQEkY8Y8cNNJONSJaqo0Z
         jIwNlMZFR2t5UCdFYyQi+b3ZrSaEsm7QHFderSjWPCWotBHMQ6CHgLXxO1Ek/hU6KEp2
         NPSygsa+43jKjimBcilASH91FJYo1bn5ILNa7BJkZZS7y4NeOiXSYFauUgcDV0fN1jdo
         RiyQpgMOeopXXpxua9DY/ap9RlBvAWatpvlw4KVWhUf2T+78DpwEfJrkMNz+2GuTgURj
         IOAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725293962; x=1725898762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/DUDom//tRZnCzR0TPrW7dnmFkZZ6kQdXEFrODb12u4=;
        b=U9hoel8ZwE4+CpqdhBO/Xim+p7wAtIA3t3/5X1FmtCtuIdRHdliKQz0N/weRaA2VJu
         7VANv4NRVQBgFSWJsIgu8OMKxDSy87JE+PBqa2yQnmeH7ngBxjhafAg9nkQRupb3tic1
         hG2UA7sZfUNJuEprooKdtQtSNchEKOp+ZPHSW5kuBKLXX+ocErAjWTy0ZP2CUx7zbtmw
         Pw5AD0zUcjCJjS8HRs9NPqyVUn0Ug3UJGtyXPkLtONDp6mDCde8niWvTq24GsLec9P+j
         dK8pSRkRJFRZH8RSaA/dEJMm4PHvDIYdbAkDWJG+6AB35MZo8Zth90TLJbTtECpA80cM
         TR3w==
X-Forwarded-Encrypted: i=1; AJvYcCWYxJ5syFcEoEaYCczpfkMwIiW28iU1uSDex+/ctYZfLScrS6Qci7A56f7hfdhOI/kWlzVkCi8DynQJ0DE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5VbT2XPjX7t7rxQ97TArmXMPqcEIV3JIHZwAOstpT6EVieF8W
	0PfrR1KRLFky0/8j3VLvsQoZ2n5g+hGimTENc/o+9hE5ip+wxGJbJBjnJLCxKv4=
X-Google-Smtp-Source: AGHT+IHxlg744kdhRp7ia5MEnyLycaQtMyvS6PmquQ558nqH6B/b8PrByKr+corJQzJhDTQ9+etDCA==
X-Received: by 2002:a05:600c:3b87:b0:428:151b:e8e with SMTP id 5b1f17b1804b1-42bdc63348bmr46501825e9.10.1725293961685;
        Mon, 02 Sep 2024 09:19:21 -0700 (PDT)
Received: from ubuntu-vm.. (51-148-40-55.dsl.zen.co.uk. [51.148.40.55])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bb6deb239sm145970065e9.5.2024.09.02.09.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 09:19:21 -0700 (PDT)
From: Adhemerval Zanella <adhemerval.zanella@linaro.org>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-arch@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Eric Biggers <ebiggers@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v4 1/2] arm64: alternative: make alternative_has_cap_likely() VDSO compatible
Date: Mon,  2 Sep 2024 16:15:46 +0000
Message-ID: <20240902161912.2751-2-adhemerval.zanella@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240902161912.2751-1-adhemerval.zanella@linaro.org>
References: <20240902161912.2751-1-adhemerval.zanella@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mark Rutland <mark.rutland@arm.com>

Currently alternative_has_cap_unlikely() can be used in VDSO code, but
alternative_has_cap_likely() cannot as it references alt_cb_patch_nops,
which is not available when linking the VDSO. This is unfortunate as it
would be useful to have alternative_has_cap_likely() available in VDSO
code.

The use of alt_cb_patch_nops was added in commit:

  d926079f17bf8aa4 ("arm64: alternatives: add shared NOP callback")

... as removing duplicate NOPs within the kernel Image saved areasonable
amount of space.

Given the VDSO code will have nowhere near as many alternative branches
as the main kernel image, this isn't much of a concern, and a few extra
nops isn't a massive problem.

Change alternative_has_cap_likely() to only use alt_cb_patch_nops for
the main kernel image, and allow duplicate NOPs in VDSO code.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Adhemerval Zanella <adhemerval.zanella@linaro.org>
---
 arch/arm64/include/asm/alternative-macros.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/alternative-macros.h b/arch/arm64/include/asm/alternative-macros.h
index d328f549b1a6..c8c77f9e36d6 100644
--- a/arch/arm64/include/asm/alternative-macros.h
+++ b/arch/arm64/include/asm/alternative-macros.h
@@ -230,7 +230,11 @@ alternative_has_cap_likely(const unsigned long cpucap)
 		return false;
 
 	asm goto(
+#ifdef BUILD_VDSO
+	ALTERNATIVE("b	%l[l_no]", "nop", %[cpucap])
+#else
 	ALTERNATIVE_CB("b	%l[l_no]", %[cpucap], alt_cb_patch_nops)
+#endif
 	:
 	: [cpucap] "i" (cpucap)
 	:
-- 
2.43.0

