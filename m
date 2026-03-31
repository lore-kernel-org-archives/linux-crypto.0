Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8B33C1408
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 07:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774943394; cv=none; b=g6b1P1fnLQzsC6By9kUW3nRG+tPiNP8CF0hCo5DXZ0LH5YuzG6A7BP12tZzmknhTSttnePOWDC2kcJFmpCOqAMndvjJzW9H1hE6jXWg6h5vWTCvDCAiTzI3zC6BDhl+M3QEwRnZnUKvWaoXO4jdfgyfGnRUX/dB3HP2JkmuHxCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774943394; c=relaxed/simple;
	bh=iXJrBlKmLTcqP1wDNnrbo+d2gBcbIcXAmCzPaC4nVao=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=gA/9Jlk1DkhQLJtuEnLeCjzpj+qEguvvvXhI6jYxGYz6iMpk6hFl3B88eQ7htU5Td1616MhMKtFa5Orw8AY09gTqJrOmLo4P+xEMzfpHMHaSXaHPHdAe6jB9RRWY8H/5Y2C9H88ZfXTNt81h+N1MPYqMXzdvbJ3up3mHROtVLpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y/n9oT9k; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y/n9oT9k"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-66b0d92bffaso4316087a12.1
        for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 00:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774943391; x=1775548191; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZGH3ymB2jwjCiHm6wtb76PJ1E35x0Um1oAlYfSnm17o=;
        b=Y/n9oT9kr3v/M0Wss7hClJywmi0iGgrHWQBD09mybkpb5CARDcXmgqh9tyDdCeNnMb
         vQesWOepu9AtW+L/tn0nUKS+jwwW+YubJWM1vH7cqYUhnC3sTpO9Woeefw5yNaFAEZtX
         s+FLAKlUhzDNK7kLiolmqJG4g6PqESHw7LWnJpb4e5lzTCnNMZDoXxHZu3C5RR7wzg12
         3qz4EIwS1k0eukD6IjmexZNXnLhmWrCL7axd7jXVwQ3gk65cvHbLZ90xPkuY1RwcX3Bz
         JmWtP98qt/17ZKEwqgkIY+gd/W6neNxVe/BfC3v2Yt8koddcRKoNDr9fsoLN+Gii86dt
         0dxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774943391; x=1775548191;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZGH3ymB2jwjCiHm6wtb76PJ1E35x0Um1oAlYfSnm17o=;
        b=GN9BnExzBy+Qkb0zzR4bfTw7Hiav7kOrWOLKDujqk08xU54oAyKf3WPfwEbn93tFkG
         RPgVCzygrDyfVp6vvc8jiUGzEHDN9XsAk5mOac9Z/1PJTuzg0ALkGniUM0LfjMwxpeRc
         Sr+NQy1XdZvk5rzykTytsIyg1tVnFR1MU/QRN/+8mThvBzH2+1UN+V5TryJ3ntVjtHLp
         Sm2Rox7kQ3NMM+GJDawHycYK8BB9Sxp/FQSWOCF45Iva5A2g8l/gxqiJCq7bKFIFCfAD
         uysjhoiDUm81GcsxD8XMTtX17SdKPMmAGeQNcAiKcFaFeqibJjvzfv1m6wprv9w4CwlY
         FLfw==
X-Forwarded-Encrypted: i=1; AJvYcCWbUvTwSxr3kAcyHDIcBsdwbBh4K0uhhAcM93ntflTTXGlo/iJ9brzabq0cIPNfZux/ReLhgGQybNmKH3s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwK/yH34CujukoZBpJev8BtTGio5o8KcvsLRX+1sLIwTR7aAdZN
	KqAOz8CIGuSSr6lw3s7ncfRMRQqpfe5upYvYmt3trnisSfGWbztpCPui51giQwN+Oy4I8IED8Q=
	=
X-Received: from eday9.prod.google.com ([2002:a05:6402:4409:b0:66b:a77e:548e])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:46db:b0:661:8ccc:473
 with SMTP id 4fb4d7f45d1cf-66b28c6ac35mr7784086a12.27.1774943391017; Tue, 31
 Mar 2026 00:49:51 -0700 (PDT)
Date: Tue, 31 Mar 2026 09:49:40 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2643; i=ardb@kernel.org;
 h=from:subject; bh=zSkjOYBXbEwftTvpZU0nBNQV37U7ijaf9h5sMhcXtdM=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN0zZRXt/cX/t1Uv+9+V197wPEbC1971nnN7nh85P+T4
 myVpztKOkpZGMS4GGTFFFkEZv99t/P0RKla51myMHNYmUCGMHBxCsBEfsszMqzZ7C0+2a4gdZOy
 cWiLnK/U7piDl4ydXjMxJzX0/53zchLD/5r6H65XFsbfEbZRyczUjHwy/Uj3tnadPSXqnX6bGEI 6WAE=
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260331074940.55502-7-ardb+git@google.com>
Subject: [PATCH v2 0/5] xor/arm: Replace vectorized version with intrinsics
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

Changes since v1:
- Update kernel_mode_neon.rst to state that arm_neon.h must not be
  included directly, but the new asm/neon-intrinsics.h should be used
  instead
- Avoid #include's of .c files - instead, build arm/xor-neon.c for arm64
  as a separate compilation unit, and export the symbol that is shared
  between the EOR and EOR3 implementations.

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

 Documentation/arch/arm/kernel_mode_neon.rst |   4 +-
 arch/arm/include/asm/neon-intrinsics.h      |  64 +++++++
 arch/arm/include/uapi/asm/types.h           |  41 -----
 crypto/aegis128-neon-inner.c                |   4 +-
 lib/raid/xor/Makefile                       |   3 +-
 lib/raid/xor/arm/xor-neon.c                 | 187 ++++++++++++++++++--
 lib/raid/xor/arm/xor-neon.h                 |   7 +
 lib/raid/xor/arm/xor_arch.h                 |   7 +-
 lib/raid/xor/arm64/xor-neon.c               | 172 +-----------------
 lib/raid/xor/xor-8regs.c                    |   2 -
 10 files changed, 251 insertions(+), 240 deletions(-)
 create mode 100644 arch/arm/include/asm/neon-intrinsics.h
 delete mode 100644 arch/arm/include/uapi/asm/types.h
 create mode 100644 lib/raid/xor/arm/xor-neon.h

-- 
2.53.0.1018.g2bb0e51243-goog

