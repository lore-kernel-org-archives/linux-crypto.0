Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794430588;
	b=XM8HdxZRC5pKfHvv2W6WIsi1dZ/Bi9+VzJdfKaJ449j/etu3aKNkUc99XnikQmFrTNhV
	 /upbFW/teytAlb8zAeJ4RJK6ipi7gLqpqvmkiLATDbrubpabxaLUnMAAmqhCIG5dBcQRo
	 ZFXAlgjPVQbNwkSz0dfeAbD/sA+ffsgBmxUt0LT1yEgyelSoehE7Xr5hQeHTUqA1+zx54
	 SbhjM8f7CHDiimRaHDI9J3oKnomonRSN7gNXe2mvBGxvpXOQrBqwWOUeS2BmlCq/aVM+g
	 aFyyIlCDBj9BDI92MMqwKYH0QvNVv0eatWk8UObleFeNrKEnIetAlEyVw6y8AlvV/Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794430588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+Ozfd/UGl2JfH7oM0NdRPY4AUBHvoqAHb4WsrY6jft0=;
	b=h5UTyVceG+AU/C+IQkq0HjF+9Vfg+iqUUKYLjeLDhXUxCXISYXAE4BesLNy89cioPPyR
	 dEyqFeaWpSdpn56bvZ9/66Uk2XW5uT4hpPE9q8ZU1Z1bv1RH9ekiEBd1uzVqKIDag52yG
	 mjSSyupOlQaKPs6qF/KENrmSRQuDu1ddbimyAac3+AZqL8D9n8hcxgDiGVEDIlpord5tS
	 plBk4UbRzSV7DV+1fx6cqlSjb3dqhRPdzLly+N+d3Q97T+UTNXw1LW8MwzaCUaAxgLKun
	 XhhbNwSvnP+M3CHA7DrzSrmAVSYFf008cUCgoemKFOni3Q/ntQA1pqT+cTMDqEkegIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CnsIQZmI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0A8606A31C;
	Wed, 11 Nov 2026 20:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CnsIQZmI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3391E1F00A05;
	Wed, 11 Nov 2026 20:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794430587;
	bh=+Ozfd/UGl2JfH7oM0NdRPY4AUBHvoqAHb4WsrY6jft0=;
	h=From:To:Cc:Subject:Date;
	b=CnsIQZmIDu0zX+R7fJahTWEnO+LDhd5bHuHgGISJjFshK9S8OfUbJBR+m2JHCwTYY
	 96eUQUOUvmycrccd7F1UIKO71hQ9XpjfdqB7Noxllri/4v7QX81AY1vKazW9d5FgeD
	 qlCiEBOGV39CC2qH+KSYRXjxJyJVfERF2hwTM6L72g7FoPEq7Di1AwuyPS3+7BHXbe
	 F4o6uzro0F6EC0QF4xZ4DnZRg2n3b4qXWiXQySl+SZWCRgH101WPUzKeO6wMR8GggQ
	 BEWFB0bKMzOZLNISsMt/2MgWz3AWo9lzYZ9UQ6IuZPlD8zeJIAoO/K5w58h50gvJQs
	 hbbxgLwMbfAYw==
From: Eric Biggers <ebiggers@kernel.org>
To: akpm@linux-foundation.org,
	linux-raid@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/3] lib/raid: opt out of initializing MXCSR and 387 state
Date: Wed, 11 Nov 2026 12:56:01 -0800
Message-ID: <20261111205604.47547-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
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

This series slightly reduces the overhead of the x86 kernel-mode "FPU"
sections in the RAID code by using kernel_fpu_begin_mask(0) instead of
kernel_fpu_begin(), thus opting out of the 'ldmxcsr' (and on 32-bit
kernels, also 'fninit').  MXCSR is irrelevant for integer code.

This mirrors similar optimizations for the crypto and CRC code
(https://lore.kernel.org/linux-crypto/20261105005523.84925-1-ebiggers@kernel.org/).
It's more important there than in the RAID code, since short lengths are
common in the x86-optimized crypto and CRC functions.  However, I think
it's worth updating the RAID code too for consistency.

Unlike the crypto and CRC code, the RAID code is built for user-mode
Linux.  Therefore, as a prerequisite for this change, patch 1 also
defines a stub for kernel_fpu_begin_mask() on user-mode Linux.

This series is targeting mm/mm-nonmm-unstable.

Eric Biggers (3):
  um: Define kernel_fpu_begin_mask()
  xor: opt out of initializing MXCSR and 387 state
  raid6: opt out of initializing MXCSR and 387 state

 arch/um/include/asm/fpu/api.h     |  1 +
 lib/raid/raid6/x86/avx2.c         | 12 ++++++------
 lib/raid/raid6/x86/avx512.c       | 12 ++++++------
 lib/raid/raid6/x86/recov_avx2.c   |  4 ++--
 lib/raid/raid6/x86/recov_avx512.c |  4 ++--
 lib/raid/raid6/x86/recov_ssse3.c  |  4 ++--
 lib/raid/raid6/x86/sse2.c         | 12 ++++++------
 lib/raid/xor/x86/xor-avx.c        |  2 +-
 lib/raid/xor/x86/xor-avx512.c     |  2 +-
 lib/raid/xor/x86/xor-sse.c        |  4 ++--
 10 files changed, 29 insertions(+), 28 deletions(-)


base-commit: d0ad02b9d5dd7ae551f450cfd233f3e28bbf59d3
-- 
2.56.1

