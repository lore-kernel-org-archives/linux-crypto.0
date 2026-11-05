Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793840180;
	b=pktFxPximIymgffIuzKqdU8BaAn+htnsKyK3Ytrk8faPIC5l9rEjx2nrdI1hOJiNJEkA
	 d3UdzwBICXmn28pt0PxKdfs9hcbFONm10FtUiuhGJk+Krc4o6NeEnIUcTKIxKZ+79Yq5/
	 6KcmyFIuLY/1D7FlaLQR/PAJFsg8UPt1qRle3IweGBZERmJuc8oj89las5WRWw7r1Jaks
	 C7reDTnFTqiDC9ixZim890mg/33y90V7AqvEilUmjhFlxQXo1kFQTRJ9yIRZVH3D56UlK
	 bIlba6iVavDGbBvrarsVg/lcK7yTykUxiU0ix7Y/d5gmX8d5mniZyWh6MFBdKnDTqkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793840180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZGcQ3yAQo2lh3KDOjkq5y231LznUfwRWHoArGG8ApFA=;
	b=PeoDXAN9FDl+1LLquXGRJ2XnrRmg0jKsqdDz8YJH6/pV54CO1idN6KN8uHI/aSNjJG/p
	 pBhv0CFngo7SZshUIhiMl/bdjUp7o6HK2avobAvrchvUP8muBNzgbGLT23uWiXiA4pc31
	 Ow6ZJ34lgX2rbTa6DcBU1G+twQXgZUIjrtKrLQMgdVMBhO+Y920fxvIBzZGmAvcEDg/sV
	 WOdBjTlNQpc6VXFt59mayc9OU8FwQ1Hag+ZiB+13E2hgEbJrJZzYNhdOELH+giSIU/Oti
	 n1jq606iDiTuRXex4Fe9T5dAoaujAG9l4QMqgvSVSwz4OTFXhnnGzzUfgTz4leTnigg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mi3NLqps;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF89606D801
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 00:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mi3NLqps
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D5E1F00A02;
	Thu,  5 Nov 2026 00:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793840180;
	bh=ZGcQ3yAQo2lh3KDOjkq5y231LznUfwRWHoArGG8ApFA=;
	h=From:To:Cc:Subject:Date;
	b=Mi3NLqpsULVxmBEguIl+beT6AxYah0g8IIYXWYqKPmCBBVmQyRK20Qsk9KhuAluSR
	 YuAsvWUcum1orZ8RT/sViU/V5rCXf5Pgb9ihHz1knQFsCXEQdI1N2gfZMr8cQEMfx0
	 rY3L4UH7VO9eHXX59VkqCaLKyOgyapOqW7ITSe+hP7DP6sTZnY87UEBXO4RH0e9maA
	 UTrf+/Ur4FyJ//VoNWhhhvwhmDVl1a4dYVHXxcolZUjtn8BMdndorKSsLFQ5MHrrva
	 3+eQ1wXl4+yKld8wS6CFOCVs+YWKyM3FxqBU5+Gc2mkQrSjFQ6QOadi7C/JUDrMBOz
	 kfoiRUD5MAtwg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/3] crc, crypto: Opt out of initializing MXCSR and 387 state
Date: Wed,  4 Nov 2026 16:55:20 -0800
Message-ID: <20261105005523.84925-1-ebiggers@kernel.org>
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

This series is targeting libcrypto-next.

The crypto and CRC code using "kernel-mode FPU" is integer code that
does not use any MMX or x87 instructions.  To the extent that
float-domain instructions are used at all, they are only moves and
shuffles, neither of which raises SIMD floating-point exceptions or
depends on MXCSR.

Therefore, there's no need to initialize MXCSR or the 387 FPU state.

Opt out of this initialization by using kernel_fpu_begin_mask(0) instead
of kernel_fpu_begin().  This eliminates an 'ldmxcsr' instruction in
every kernel-mode FPU section, reducing overhead, which matters most for
short input lengths.  On 32-bit kernels it also eliminates 'fninit'.

A precedent for this optimization can be found in
commit a58db7ad80e8 ("netfilter: nft_set_pipapo_avx2: Skip LDMXCSR, we
don't need a valid MXCSR state").

Eric Biggers (3):
  lib/crc: x86: Opt out of initializing MXCSR and 387 state
  lib/crypto: x86: Opt out of initializing MXCSR and 387 state
  crypto: x86 - Opt out of initializing MXCSR and 387 state

 arch/x86/crypto/aegis128-aesni-glue.c   |  6 +++---
 arch/x86/crypto/aesni-intel_glue.c      | 10 +++++-----
 arch/x86/crypto/aria_aesni_avx2_glue.c  |  4 ++--
 arch/x86/crypto/aria_aesni_avx_glue.c   |  2 +-
 arch/x86/crypto/aria_gfni_avx512_glue.c |  6 +++---
 arch/x86/crypto/ecb_cbc_helpers.h       |  2 +-
 arch/x86/crypto/sm4_aesni_avx_glue.c    |  6 +++---
 lib/crc/x86/crc-pclmul-template.h       | 18 +++++++++---------
 lib/crc/x86/crc32.h                     |  2 +-
 lib/crypto/x86/aes.h                    | 24 ++++++++++++------------
 lib/crypto/x86/blake2s.h                |  2 +-
 lib/crypto/x86/chacha.h                 |  4 ++--
 lib/crypto/x86/gf128hash.h              |  8 ++++----
 lib/crypto/x86/nh.h                     |  2 +-
 lib/crypto/x86/poly1305.h               |  2 +-
 lib/crypto/x86/sha1.h                   |  4 ++--
 lib/crypto/x86/sha256.h                 |  4 ++--
 lib/crypto/x86/sha512.h                 |  2 +-
 lib/crypto/x86/sm3.h                    |  2 +-
 19 files changed, 55 insertions(+), 55 deletions(-)


base-commit: 9fbbbaefd5f95551da18426c200cf41e1b4255a1
-- 
2.56.0

