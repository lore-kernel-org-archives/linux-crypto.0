Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01312352C2C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Mar 2026 11:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611076; cv=none; b=EIArInNeRgfzyqsAptjH8LAHTyS7cjCJLKbWTkDV4AgJHFothiHUwd/FWKgCRCJpIbFikwhF0l9UVBcA2cEjc3k9NCTrwNNyq/hPUIyQ2Mv09dN3an+zu4YX9IwEtCq8fQQGD14eAEX77VXszW+nuolBVW3wba94FDjNl+gKEL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611076; c=relaxed/simple;
	bh=UmL46xDerX8cYINsA2i+1E9wjT2HoBExSADUSLKiakQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=FS7NAffFA4jAMX7eP4Wx8e7Gn3S5LO17H9qpkmoaKtPpQOJsKXSfX1LWrRhfwPD6YBNTVmM8MPAc8y3cCjym5oOWeMPZGHCjMF3LauiDvXWYwBhsIffmctgCrmhIv45pNdVmoaK4OXLOHOg1lnEFMMYFAzMp3FlUaDHWiN4DmOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TW6EA4XN; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TW6EA4XN"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-439bab2d095so1669703f8f.3
        for <linux-crypto@vger.kernel.org>; Fri, 27 Mar 2026 04:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774611072; x=1775215872; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cWi4tsU07W8zdjWvbAUHzl7MmNBwNpbFy2DN6BpKSUQ=;
        b=TW6EA4XND+VGeLxQNDlAEIKGtAAfbnwKEHlZgLanovhp48LjOUYmC8ECGW3rNDi7+C
         P87RPAujvLF7FUza3JhE67cEVLnD+r5PBCb2RrPI/5y1KgOfOhR1pdLZBdecPXW5xmpG
         aMN/UV70DF/9KRK5szeNwazeIdl/k7N+tkek4dgPoGr2WerY2nsijHUa4m3n70JVbbkG
         9jd0Az6/44QNhK/jNuxlhi0r6ymiy+EMFZdEfkZsdmdiufrssg7YXUptbWpyR2dECx+u
         L0RdpQ7M/ug+N8bWC0RwUDsWz0x83mVeXTPrkv3bvke8NXXIjoqc9H1kyGCTbB7whYoO
         E7pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774611072; x=1775215872;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cWi4tsU07W8zdjWvbAUHzl7MmNBwNpbFy2DN6BpKSUQ=;
        b=RAY9owFWQsz0NZiJBeYXJlWNqGmVo2VX200bD/QPgTt1dB5X7Iiz9gfzr+Vj573W1/
         NJ0zxzv8SsxnM3b03fyjqdBfUXYTuIA5vDTmcobjSfrjKzoOeDjX60VlZSOZ7lZwVNOr
         8+byd+yhjk5x7N1/RD/7BJq36IEn/AcQNQOEG/OCs1KLj5Wrl6dc9wh3UFvJ3ym9HAnM
         pWAceVUYMruYyLC0SoylpuQi3IyjEpY0CRbWTAvX2yJzInyNeluNtJhTrBpPjvHVAPms
         jacYm0qCGlja5Lx+RDsMuQddOuTaybu7Y3h9/3ZpIPgVhdQ24AVivM8GHrjpa/Ut6w5R
         5aHg==
X-Forwarded-Encrypted: i=1; AJvYcCVF7DBAgeGndHgl7AYNVNc2BTkiPJ4GFIlv7xgS0VUHQebXfwVGs0l4urzXghAMWU9P3KeH/OyJsWQNzE4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrFi/nSCbtVlpuQLGFlngmU5BlSa1m3nPBIW+fKIQVe8fSRrmF
	8PBARGEsX/JRbkc7U7MmQK9/XOEl92BDfhRnUW+L38QQZ5QCXonsdn4sqeVLDf4nBCe8nNwv7A=
	=
X-Received: from wrvx13.prod.google.com ([2002:a5d:54cd:0:b0:43a:5b:6a87])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2313:b0:43b:905d:f89f
 with SMTP id ffacd0b85a97d-43b9ea66dccmr3373359f8f.39.1774611071907; Fri, 27
 Mar 2026 04:31:11 -0700 (PDT)
Date: Fri, 27 Mar 2026 12:30:48 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2230; i=ardb@kernel.org;
 h=from:subject; bh=XeSSbbJ4zYZ7OrRBfI89bxz2saKmw5oGCVUlBedEe7Y=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfNYVkbKiv4duu7JN5Z7mAaYh728pH0o9uj5Rd9/Wp7Zu
 lmx1e1ARykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjIlDUMfzjtU/pt9PJXccrv
 3PtJ8cWzTxc+3Nh6/m/g+4h2pk/PDigz/C9S+Wp2et9q3njmjbrXbv1at7hGbpbORrWS2Glfd+x S0eAEAA==
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260327113047.4043492-7-ardb+git@google.com>
Subject: [PATCH 0/5] xor/arm: Replace vectorized version with intrinsics
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-raid@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, Russell King <linux@armlinux.org.uk>, 
	Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Replace the compiler vectorized XOR implementation for ARM with the
existing NEON intrinsics implementation used by arm64. This is slightly
faster, and allows some minor cleanups of the type hacks in the headers
now that intrinsics are the only C code permitted to use FP/SIMD
instructions.

Performance (QEMU mach-virt VM running on Synquacer [Cortex-A53 @ 1 GHz]

Before:

[    3.519687] xor: measuring software checksum speed
[    3.521725]    neon            :  1660 MB/sec
[    3.524733]    32regs          :  1105 MB/sec
[    3.527751]    8regs           :  1098 MB/sec
[    3.529911]    arm4regs        :  1540 MB/sec

After:

[    3.517654] xor: measuring software checksum speed
[    3.519454]    neon            :  1896 MB/sec
[    3.522499]    32regs          :  1090 MB/sec
[    3.525560]    8regs           :  1083 MB/sec
[    3.527700]    arm4regs        :  1556 MB/sec

This applies onto Christoph's XOR cleanup series.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biggers <ebiggers@kernel.org>

Ard Biesheuvel (5):
  ARM: Add a neon-intrinsics.h header like on arm64
  crypto: aegis128 - Use neon-intrinsics.h on ARM too
  xor/arm: Replace vectorized implementation with arm64's intrinsics
  xor/arm64: Use shared NEON intrinsics implementation from 32-bit ARM
  ARM: Remove hacked-up asm/types.h header

 arch/arm/include/asm/neon-intrinsics.h |  64 +++++++
 arch/arm/include/uapi/asm/types.h      |  41 -----
 crypto/aegis128-neon-inner.c           |   4 +-
 lib/raid/xor/arm/xor-neon.c            | 183 ++++++++++++++++++--
 lib/raid/xor/arm/xor-neon.h            |   7 +
 lib/raid/xor/arm/xor_arch.h            |   7 +-
 lib/raid/xor/arm64/xor-neon.c          | 170 +-----------------
 lib/raid/xor/arm64/xor-neon.h          |   3 +
 lib/raid/xor/arm64/xor_arch.h          |   4 +-
 lib/raid/xor/xor-8regs.c               |   2 -
 10 files changed, 244 insertions(+), 241 deletions(-)
 create mode 100644 arch/arm/include/asm/neon-intrinsics.h
 delete mode 100644 arch/arm/include/uapi/asm/types.h
 create mode 100644 lib/raid/xor/arm/xor-neon.h

-- 
2.53.0.1018.g2bb0e51243-goog

