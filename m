Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609A32FFDD5;
	Fri, 26 Jun 2026 04:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782448765; cv=none; b=t5MRAcaxjR4BZcDsOfFeTXVxZGYxkFKgIlCGnVQUJrSwnAJngTbuRTY7sI9kIkUqAPFvVPSkgKKYi3nTYnQVCS7fJT6N5YZ+Koz1d+sG2xPzWwif0/urGdmhDhVUcC5kpjtxn0k9na5HLPR41m/+tcd4DdbjYS0vaDpsN46lG3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782448765; c=relaxed/simple;
	bh=Iiz/QnMDtEg87voSGJUNobj8UoEi8PBqq45GKQWEmD4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oL0OCyUTdV0M7Y4iT7IjAh7xBvy2GIcVFKxqBp3YSK7/yh3ukoiJGl4jnjKmtLXHmQl3hMZWFddunU9wqwJ5pfXoeQTdV3S9hhVvQ445gRpbm+JjogQWcJv4v/ht29zLlf9/WOUOKnD4yNZ58xsblLPdOSxvf4nCi6nBNWQ2e0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ij6vpCDh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ij6vpCDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AA91F000E9;
	Fri, 26 Jun 2026 04:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782448764;
	bh=EThdRu/11wp6N0JSfRIxy1kA6W323gFL4ICwbKnuv1w=;
	h=From:To:Cc:Subject:Date;
	b=ij6vpCDhyTlRwiqupSK0EHeAXKevHJCyIHbjmW2s/O85CCp68rYWWunAGtELDSHzF
	 tuw7kMRdbe5vx/ULc8iV7pybd4jEEPz/BTc/5b1rEXDNzrisDikUTO+2n9KeN1fjxY
	 vb9lJbaDgvQGbn9hlJ02dZ7FiL95jp5wGu+kl+MKL5QkGNUv+K4hve8OEGtNtNXTAo
	 X8VNIRH//W5F0MnZQSigvXDTODiV/rTsZqwOSM/nKjOIO8lwkRfNQgpeT8lmghCYqy
	 074dsVHwlftgIusGkl0Oaqm8eAzif6n6YIif2LUYi+sm8Zt6/KAJboYJU2dxkvyk8a
	 Ao8VCKNR4Sgjg==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/8] x86: Remove cpu_has_xfeatures() and add AVX-512 xor_gen()
Date: Thu, 25 Jun 2026 21:37:23 -0700
Message-ID: <20260626043731.319287-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

My patch "lib/raid/xor: x86: Add AVX-512 optimized xor_gen()"
(https://lore.kernel.org/r/20260615190338.26581-1-ebiggers@kernel.org/)
still seems to be blocked on a Sashiko comment about cpu_has_xfeatures()
not being called.

However, the x86-optimized RAID library code supports UML, and currently
UML doesn't implement cpu_has_xfeatures().  That's perhaps why the
existing AVX-512 optimized RAID6 code doesn't check it either.

In fact, it seems to have been getting by fine without it, which
suggests that it's not truly needed.

But to eliminate any doubts, I've had a go at fully resolving the
situation by making both native x86 and UML explicitly clear any
X86_FEATURE_* flags at boot time whose xfeatures are missing.

Then, cpu_has_xfeatures() is entirely removed from the kernel.

The last patch adds the AVX-512 optimized xor_gen().  I do still think
it would be fine to proceed with it without the rest.  But if there are
any doubts, we can take this more comprehensive cleanup route.

Eric Biggers (8):
  x86/fpu: Check for missing AVX and AVX-512 xstate bits
  um: Check for missing AVX and AVX-512 xstate bits
  crypto: x86 - Stop using cpu_has_xfeatures()
  lib/crypto: x86: Stop using cpu_has_xfeatures()
  lib/crc: x86: Stop using cpu_has_xfeatures()
  x86/fpu: Remove cpu_has_xfeatures()
  lib/raid/xor: x86: Remove redundant X86_FEATURE_OSXSAVE check
  lib/raid/xor: x86: Add AVX-512 optimized xor_gen()

 arch/um/kernel/um_arch.c                   |  78 ++++++++++++-
 arch/x86/crypto/aegis128-aesni-glue.c      |   3 +-
 arch/x86/crypto/aesni-intel_glue.c         |   7 +-
 arch/x86/crypto/aria_aesni_avx2_glue.c     |  11 +-
 arch/x86/crypto/aria_aesni_avx_glue.c      |  11 +-
 arch/x86/crypto/aria_gfni_avx512_glue.c    |  11 +-
 arch/x86/crypto/camellia_aesni_avx2_glue.c |  11 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c  |  11 +-
 arch/x86/crypto/cast5_avx_glue.c           |   7 +-
 arch/x86/crypto/cast6_avx_glue.c           |   7 +-
 arch/x86/crypto/serpent_avx2_glue.c        |   9 +-
 arch/x86/crypto/serpent_avx_glue.c         |   7 +-
 arch/x86/crypto/sm4_aesni_avx2_glue.c      |  11 +-
 arch/x86/crypto/sm4_aesni_avx_glue.c       |  11 +-
 arch/x86/crypto/twofish_avx_glue.c         |   6 +-
 arch/x86/include/asm/fpu/api.h             |   9 --
 arch/x86/kernel/fpu/xstate.c               |  63 ++++-------
 lib/crc/x86/crc-pclmul-template.h          |   6 +-
 lib/crypto/x86/blake2s.h                   |   4 +-
 lib/crypto/x86/chacha.h                    |   3 +-
 lib/crypto/x86/nh.h                        |   4 +-
 lib/crypto/x86/poly1305.h                  |   7 +-
 lib/crypto/x86/sha1.h                      |   4 +-
 lib/crypto/x86/sha256.h                    |   4 +-
 lib/crypto/x86/sha512.h                    |   3 +-
 lib/crypto/x86/sm3.h                       |   3 +-
 lib/raid/xor/Makefile                      |   2 +-
 lib/raid/xor/x86/xor-avx512.c              | 121 +++++++++++++++++++++
 lib/raid/xor/x86/xor_arch.h                |  24 ++--
 29 files changed, 264 insertions(+), 194 deletions(-)
 create mode 100644 lib/raid/xor/x86/xor-avx512.c


base-commit: 4edcdefd4083ae04b1a5656f4be6cd83ae919ef4
-- 
2.54.0

