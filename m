Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792955551;
	b=C0D54WStqsru9cIIkT0U/t2jTKZC+GsUNR7+4LJDEoWGHO0/1pcZmEV+Rg1Xb+7qKZrh
	 cSkrUG0fqGC0ErLAVlN6OnKmicvrtvGGNxSTMukHVFpqm80s+IDywyKrdPYSQQ723u3Cz
	 bfQRiFLHgQMmf90XfAWT6J+8QxyQsJnF1SNLl1sjkFYps7RtaLBGCGPXKoI1LukAzQaA+
	 QcEwclNCi8JPtqh/Rl6NpIBoImiMjmHpyI+tVyBuIDghzb/KgZkjox3zfPWBuqz2T8TrA
	 yjCifeFc5MLOuY/61lL140P1xNvLdGJ5j21+2YSRZJc64r0HA/vhT6+r6KR5ODosDgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792955551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b1bEpNAUSZi6CYvRzi6aLNZ/xOZsJuz2nnCH7hlv1W4=;
	b=nPm4s0NzWbCE8Jnct80GxLuSNkKzdUisnMYmkrIbbze4yTSm4TsOx0uDplOq276umHJc
	 Y6IlAaH7vwPnxfCTB+Ng3h80Yu51sfa4kkw3aGZx55iHvCh6vOhdLLy9YOZtP+9THYSyR
	 Wu7cmGsufMajEiUkjCcnnwu7G9oCjK+BkgMOxoXO6lHWNJMJjs2D8EQc2Lrl5iVijxgiz
	 9h8d632sBWSJ1ckuhCd/v7I4yhLGDUG//5XsRebUntOXWgWpcADCgCtmZZluf7NapxMV9
	 EeTIRa2di4Mo0LXegv35pUFjJBqBHnwkCCLOIkbH25FjieKSIOp5ZHBMqKmqkVdYQjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QC8DzALF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43BB606A31A;
	Sun, 25 Oct 2026 19:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QC8DzALF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F171F01825;
	Sun, 25 Oct 2026 19:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792955550;
	bh=b1bEpNAUSZi6CYvRzi6aLNZ/xOZsJuz2nnCH7hlv1W4=;
	h=From:To:Cc:Subject:Date;
	b=QC8DzALFg55K1kTN77G56NT5Ph1biGGe478L1rcSyxSSmNGwllrlf6QXz/qqorUov
	 7DA2U7RhpYfaUgN4AOZl4nIdUZoSPeQ2trw8wWOmQJBIZyFeC3k+cALwd0CudFhJfd
	 3+RJPw4OBXxabhJid06sRwnZDMWGzVTzfQF1TrGOWdZ+KYcwmj653KsKLn9Fir9aoD
	 diYlrwYxWaN3zea74pm65BRva0e0whUR4AutBHTfJ2MUgYM01q7+HRFWi0kIaCMW70
	 A6Q2nS/FovJMVKKhWJJgqy6Ru9KenpCzEpPF17BIIJH6WjB/pgyZI7DanpBYZzzTlJ
	 ZGh9PpV4vGqdg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-raid@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/3] raid: remove obsolete MMX optimized code
Date: Sun, 25 Oct 2026 12:12:04 -0700
Message-ID: <20261025191207.86590-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series retires 32-bit MMX optimizations for RAID.

Affected CPUs, such as the Pentium MMX and Pentium II, will just fall
back to the existing well-tested scalar code instead.

This was the only remaining MMX optimized code in the kernel.  MMX
optimizations for the much more commonly called functions memcpy(),
copy_page(), and clear_page() were already removed years ago by commit
c6dbd3e5e69c ("x86/mmx_32: Remove X86_USE_3DNOW").  There are zero MMX
optimizations for anything else, like crypto or CRC, which left the RAID
code as an outlier.

Patch 3 also cleans up the CPU feature checks in the RAID6 code.

Eric Biggers (3):
  xor: remove MMX optimized code
  raid6: remove MMX optimized code
  raid6: simplify CPU feature checks

 lib/raid/raid6/Makefile      |   4 -
 lib/raid/raid6/x86/mmx.c     | 118 --------
 lib/raid/raid6/x86/pq_arch.h |  69 +----
 lib/raid/raid6/x86/sse1.c    | 136 ---------
 lib/raid/xor/Makefile        |   2 +-
 lib/raid/xor/x86/xor-mmx.c   | 515 -----------------------------------
 lib/raid/xor/x86/xor_arch.h  |   5 -
 7 files changed, 12 insertions(+), 837 deletions(-)
 delete mode 100644 lib/raid/raid6/x86/mmx.c
 delete mode 100644 lib/raid/raid6/x86/sse1.c
 delete mode 100644 lib/raid/xor/x86/xor-mmx.c


base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7
-- 
2.56.0

