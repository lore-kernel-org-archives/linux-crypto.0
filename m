Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B9228695;
	Thu, 18 Dec 2025 19:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766084775; cv=none; b=K9kwhnDQW8YKaB6LnAtQbTWoQOdxc2GXwAv+H+B5NngjZjifzctpHz/f9DcThApFNALN1pdwgQGw2TRZ9wXSMiMMUg1gcQ6LfL0ocSxV6SAMFHIep/zmehEs/ZIsGAU3o8uj9KMCftZ2LBR7bIs83cF5i7j/i3g0qbgJHuMczHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766084775; c=relaxed/simple;
	bh=hcPZnrm8YPqK45k98pFrwJEZ6Doc8/FaNbmeUK/pRcs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KnQdSLVC8Mu2E3Z4eKgrRCNNaSKbN7v1JB7aMgwv/2ZMb9bydhFxx+3QC+JRxyTbwQXFJfAYk+qTu4Sks885Aullr79ZclCxNSqK+LY4SYz5jUbnnBbYD6Hsr0cyLqOQ3i/gUl9CoExxIg/ABt73UelYhwmRQOhpaTT/UYNMjsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OmfKrH3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OmfKrH3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CE2C4CEFB;
	Thu, 18 Dec 2025 19:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766084775;
	bh=hcPZnrm8YPqK45k98pFrwJEZ6Doc8/FaNbmeUK/pRcs=;
	h=Date:From:To:Cc:Subject:From;
	b=OmfKrH3sdzJSRkoXJ83lIbxEEMpI6kqcJN5wTqrQCjc8uVBzAFXNvdaY2k/5B8wRD
	 8m7kisIx5Shmacsr1hm2rcWM17HR55lMyEyhLyIWTv0xYtBj9O6siyRJaz/csdGpg6
	 X5JvayyvvvE5/vZd/zCDjEaM6BsHDbz64oLnyaz/dr1nDW/s6vIMMOQKh3Lg6v26OF
	 APPJGQ45a46r8pjFrxYH+CX8SmgvstwEYFV+VMWV3IeMXYph7o0WY3mHouwnGZZElL
	 mEuKn/LCsdq/8EyHMfThGZK+gqeLvLnmWv2O3+ckjrjFa58dhRBZN8yHVc4KLHn4iV
	 pIt8OgedhaW8Q==
Date: Thu, 18 Dec 2025 11:06:06 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Charles Mirabile <cmirabil@redhat.com>,
	Kees Cook <keescook@chromium.org>, Will Deacon <will@kernel.org>
Subject: [GIT PULL] Crypto library fixes for v6.19-rc2
Message-ID: <20251218190606.GB21380@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 8f0b4cce4481fb22653697cced8d0d04027cb1e8:

  Linux 6.19-rc1 (2025-12-14 16:05:07 +1200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-fixes-for-linus

for you to fetch changes up to 5a0b1882506858b12cc77f0e2439a5f3c5052761:

  lib/crypto: riscv: Add poly1305-core.S to .gitignore (2025-12-14 10:18:22 -0800)

----------------------------------------------------------------

 - Fix a performance issue with the scoped_ksimd() macro (new in 6.19)
   where it unnecessarily initialized the entire fpsimd state.

 - Add a missing gitignore entry for a generated file added in 6.18.

----------------------------------------------------------------
Ard Biesheuvel (1):
      arm64/simd: Avoid pointless clearing of FP/SIMD buffer

Charles Mirabile (1):
      lib/crypto: riscv: Add poly1305-core.S to .gitignore

 arch/arm64/include/asm/simd.h | 9 ++++++++-
 lib/crypto/riscv/.gitignore   | 2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)
 create mode 100644 lib/crypto/riscv/.gitignore
