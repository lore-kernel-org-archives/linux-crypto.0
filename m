Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB181D8A0B
	for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2024 09:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729158102; cv=none; b=VYf+RTiRyGZEpBreH9ZyYoIjL+n33EFWynRd8tKhAmGFSwrIO347JIscUE6L76w4QGIejgQEdYQv1kDongx/IezHrF69xCqt6qMSvk5EGh7doPL6fky/2Uwd27xSaxaWE7J45++KiuS2MeEu5FzEKA+smxa+2lZwP8LZ+pCpOvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729158102; c=relaxed/simple;
	bh=/Kj92XN7TPEcHDkHB1JRCwyCnItaDsg0z5AmTq8udWo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=HIBd+dRFm5Kcb8BZwEsLteL0G975B7k5esspgHdhT9qXMTTvW91nBi1JdW18Cdck0yriTMI6oDghPkk9VwXFkRmoNfFeTRWWifuI/q6tec7K1rlJdCTPX91g3Z0Cw9MMoYlpqCL5Eo71e+NPfcaPECLhLDCnMBoTpo8kZ7+Tde8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pL3nGRy0; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pL3nGRy0"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e370139342so12609237b3.3
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2024 02:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729158099; x=1729762899; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NL1g8QiMiw+GMLkaabWajcTuwbPu8SeRvj7pvi19l7E=;
        b=pL3nGRy0lYEL81WFanb+gnKOzqO36KpIq4e8g4EhM+w8EfS9TuUh+mYfK/jpk5g5+n
         224a3SYota+H+c7WwrvGO+AnUhUFAVH/VBEoZMtCrOW2Oucqw4Fqaa72k/S+cCMvt+x/
         QpdFpGSYoQbvRVlSDBahrqqYNy7VO4Nl8Ms2ZQVI82Rh8LCHrTkK8pSwQR8Rhde5LLrX
         xHrMybq3T9YDKV07v1rsH1QubWFpFBjM75+bvumsjuQoCv90O4EMcvhFzOfV1+xpCqGM
         IzZVBHAcCGGhkIVEXcEWrmxNXdmI+2/tcg/py9wI6PAeWV7WowLNeAKwzOxBHyNOiKjD
         0lTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729158099; x=1729762899;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NL1g8QiMiw+GMLkaabWajcTuwbPu8SeRvj7pvi19l7E=;
        b=pJASH/ck4Eul7+ekU5rErtDy5NPcB8dtHGQFf7E/Pe23TaHuIIckCcZNmc1NIMBzlY
         oWCDxdgymsPrD6OPRIJPcEj44yYn8KI99E5jem6gr6DB5fJ/JAgWRoFQ7PtnCaPN6cv6
         ohTAxvDw25+Av+qkTJlaXTxlDV/d9eD8YyiFKyBzoX3DEmVPlafMMFCVrv9gC900cjNm
         UBVGyzcOL1Btpx6Ini/wXRYFZDbif9Y/ZWGxy0l8W4BJdenLeIW2pMKuSOKstJ8i9vkF
         bQulLBcC2hhORwojS+nLvYKIUOXB8GVpku6tSJ5jY67xOs8hw1r3FJWlHXBV78shCsko
         2LYw==
X-Forwarded-Encrypted: i=1; AJvYcCUTs7KEOrLSjQDPwXNv+KCZ5Z9s+x27VNIjtQq+f+NJfNeC6lKZM7yBsS7urj+YdOsPIfvK3MzqOlFIOZc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtkdAGeYpgHyJazbQ9bedFw3P8lUPOpUowfO/9cBv+3eD1Jw4M
	QQh7zJAI/lhNNhooFUfK1Ac+DAsnFQmuUhOJShMYSK1aXq63Y+ivxTGOfN9giG1+iEfefA==
X-Google-Smtp-Source: AGHT+IGjgTrn0OdrhHX3rWorpZYzZht2bXo+DDqn8QkiQ+7uwl+ZSKCW9wNflH8e1sSt3+MKmVzadN5H
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a05:690c:6703:b0:6dd:bf69:7e06 with SMTP id
 00721157ae682-6e3d41e7a44mr1259657b3.7.1729158098641; Thu, 17 Oct 2024
 02:41:38 -0700 (PDT)
Date: Thu, 17 Oct 2024 11:41:33 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1748; i=ardb@kernel.org;
 h=from:subject; bh=A2qb4yG344KAaBkQYaztyqpHjkQf1nkWoa4ObJtOQZo=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIV3g9lnPuYlevqv5zz9+lbff6fRSr3zNzayiJ40XqJQZy
 Rv8M/7YUcrCIMbBICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACZy0YfhfyqHwLsTiTP493Ex
 Tzi9b5/49XDvbRGPgvp/Hbr7u/x0OyPDP7XrDJH+8Y8ZP014WDnzUmzswtbdZ1STtmSrdtg77ng SzwMA
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241017094132.2482168-4-ardb+git@google.com>
Subject: [PATCH v3 0/2] arm64: Speed up CRC-32 using PMULL instructions
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

Ard Biesheuvel (2):
  arm64/lib: Handle CRC-32 alternative in C code
  arm64/crc32: Implement 4-way interleave using PMULL

 arch/arm64/lib/Makefile     |   2 +-
 arch/arm64/lib/crc32-4way.S | 242 ++++++++++++++++++++
 arch/arm64/lib/crc32-glue.c |  82 +++++++
 arch/arm64/lib/crc32.S      |  22 +-
 4 files changed, 331 insertions(+), 17 deletions(-)
 create mode 100644 arch/arm64/lib/crc32-4way.S
 create mode 100644 arch/arm64/lib/crc32-glue.c

-- 
2.47.0.rc1.288.g06298d1525-goog

