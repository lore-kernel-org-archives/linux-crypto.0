Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F84118C01D
	for <linux-crypto@vger.kernel.org>; Fri, 18 Oct 2024 07:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729238036; cv=none; b=rT831nbfqcS8Dcq+WNbWhQYirjYL7yLm0zeu/7mNgeU7tkE6Rj62P8PNpFZh8T85qIXWoawM8WKLf7tHsc92IoKEsLJUWV6R//dCyjURYBFfk9gR1HX6gqguNhTONoJplTPRhfneggRfPaXKafvQscriwZ7M+HXSxwpXyfZMXh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729238036; c=relaxed/simple;
	bh=TQ9m0wk2JZV6++i0OCfcENL4vYhhU64zD697oje3x7g=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=MlriokRBjuRUEDmVueUvjPx3mxin9UgUxBWCzo3clrq6I44VQXKmOzyUjdhSRR0Vk8TkVa3B4BEpOlGncONEF8M+WedCLMIGMLDbUAlRlbrzZZjqmEE8qLwCnvHAFwFb9COpRk1bNFyNddpDXhpzm8/C0O5tavTTRO40lrzIvso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RkWjTprG; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RkWjTprG"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e24a31ad88aso2704285276.1
        for <linux-crypto@vger.kernel.org>; Fri, 18 Oct 2024 00:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729238034; x=1729842834; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=x2mv8TUZpeEH80uut1qGXx+8u/loznjO7IbL6g6IhOA=;
        b=RkWjTprGi8I96/a1ygHiiAXlfvKnpvJGN8HgEtwpw5giftR8YFkN+FvBvt/hC2VUnz
         bHb1tTyPdmjCn7gOa7gBkGm9C10eATqGjI1iWM9C1PD54JcM9KgqXSC2FkHiL6rhM24G
         Cd8W3SQ6x6TeEC5rnUJnPtwu05TTXQ8Tf1kMPqes3pESZJw7o8iE8tFgCTaC4weBgdfS
         UTye4xvK1zxcn/SMYD7RakYy9RHav1AsNeGUOa9TyAEggqW/hNIclx07NgX5aiZkUNTq
         AA4YzwzUurMf6FjR6xnH8YGfLA1lRpL6CKdIUlTOW8d/Vy1AZ1Tr6yAh2bV5Bb5mfTRh
         vu0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729238034; x=1729842834;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x2mv8TUZpeEH80uut1qGXx+8u/loznjO7IbL6g6IhOA=;
        b=gkQGXGuLp9jRHjxH2kvqeO1Xf0rF4Cs6vKzofZZtzQ45g6l4oHHNARQ5l8vIJqbeYF
         OhJEXfULueg8UfqsZBpTQfEN0hXpWLYfjBtzL7BOk5AvDb7iU8W7DGzKMYam/92QmwlE
         xVBXuQSG6/2GbH37rZKb+88Z8AttwHWAC04g89zYt22u/RFSAOBF0Yztr+qdzLsE+18A
         LGROOmZCL7Ov41NRH0EwzrUj8CLc/uIo3EyLd/VPnES9i4TQJC3Cm8GQSMaYDM5PcUm1
         XuSJJApzsq35Jszw30PfPPzbIuUcH46PSo4gSrrXKQ7+k4tUOV2xWsR115xUUmm8RTlu
         O5YA==
X-Forwarded-Encrypted: i=1; AJvYcCWEIWSWCa7aza/m/UESFgQiMmdfQ3b+dPpeAAgs/mOKa+rSGozmTZAXzf5rfbYz3ia1lYMMeN1V2uvc/vg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVcaEEBj1KaBxtQcWoUGHF6xnU6sRWijkdxa1H0CeidPGxP6dk
	s9zxc/wy3HlCIs1gE4sClmeZiBSWJHEXaTazFG4kenQrYVyiwrornA5Ui4SuR0X6e+w/rg==
X-Google-Smtp-Source: AGHT+IFwhKYzBpNi2YE4PRKeSOzLm+jjRSZJxfIsQP2aLt1c19XKh2lrrRVvRcdv+mI23HTHM9bSq9gI
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a25:abcf:0:b0:e28:f19c:fd4 with SMTP id
 3f1490d57ef6-e2bb16cd37dmr931276.11.1729238034003; Fri, 18 Oct 2024 00:53:54
 -0700 (PDT)
Date: Fri, 18 Oct 2024 09:53:48 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1847; i=ardb@kernel.org;
 h=from:subject; bh=FYOaF0aLEwhF6mjikhwenNhSc8+8y/Xk24OlbqUyWJA=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIV1IhEfo2T2/XVWmCy5NjfBtzD+meLuqQMG3YY24qu+iC
 5N4Vwh3lLIwiHEwyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIlIvGP4px4zu8T/NmPiyYv3
 OPXU6ma+Vb7m5TBNQVpQ5XDUZ90pJxkZvnarL4uyqp48Zdb6oHYtx96DIuolnM9OcuTdnrl2mXk xPwA=
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241018075347.2821102-5-ardb+git@google.com>
Subject: [PATCH v4 0/3] arm64: Speed up CRC-32 using PMULL instructions
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, will@kernel.org, catalin.marinas@arm.com, 
	Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The CRC-32 code is library code, and is not part of the crypto
subsystem. This means that callers may not generally be aware of the
kind of implementation that backs it, and so we've refrained from using
FP/SIMD code in the past, as it disables preemption, and this may incur
scheduling latencies that the caller did not anticipate.

This was solved a while ago, and on arm64, kernel mode FP/SIMD no longer
disables preemption.

This means we can happily use PMULL instructions in the CRC-32 library
code, which permits an optimization to be implemented that results in a
speedup of 2 - 2.8x for inputs >1k in size (on Apple M2)

Patch #1 implements some prepwork to handle the scalar CRC-32
alternatives patching in C code.

Changes since v3:
- fix broken crc32be version
- add patch to tidy up existing code for reuse
- add 4-way code to existing .S file

Changes since v2:
- drop alternatives.h #include (#1)
- drop unneeded branch (#2)
- fix comment max -> min (#2)
- add Eric's Rb

Changes since v1:
- rename crc32-pmull.S to crc32-4way.S and avoid pmull in the function
  names to avoid confusion about the nature of the implementation;
- polish the asm a bit, and add some comments
- don't return via the scalar code if len dropped to 0 after calling the
  4-way code.

Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Kees Cook <kees@kernel.org>

Ard Biesheuvel (3):
  arm64/lib: Handle CRC-32 alternative in C code
  arm64/crc32: Reorganize bit/byte ordering macros
  arm64/crc32: Implement 4-way interleave using PMULL

 arch/arm64/lib/Makefile     |   2 +-
 arch/arm64/lib/crc32-glue.c |  82 +++++
 arch/arm64/lib/crc32.S      | 344 ++++++++++++++++----
 3 files changed, 356 insertions(+), 72 deletions(-)
 create mode 100644 arch/arm64/lib/crc32-glue.c

-- 
2.47.0.rc1.288.g06298d1525-goog

