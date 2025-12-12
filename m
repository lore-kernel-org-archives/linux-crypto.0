Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FB6381C4;
	Fri, 12 Dec 2025 03:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765511906; cv=none; b=pnkQyP0kzv5Jl2pNaJcr/TDmVgOQcwGrjV8Jh5q00oSnWF+5+ZtjWACm3oUbgm836zy68W2iSEHJPpYScXFKaRHcIRJMEEtKZa2K8IsUxrU/QRfWFgq0wCvCIrz+pxyXCxnTIYuquThA0WQNFLqetSg9oQ33UaA204C0rTIcUH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765511906; c=relaxed/simple;
	bh=1pHlS6z2ukRwKRMPs3eNcwfJlx3rGmydK2Jvd4JEZCk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=IxUhdS9mPeWhkn234RnS1PbHQYcsmzG6gBOtIBIVsgx5fdeCLT8ySvcMSzH4IpIotVe/ltfzwEtckJP8vW2d47JvUJzXZyl0TcvbfdeaDMPEZU3rx7nm+LtehAGAQplGDpoh1t9HWhQGwrdZo/2mvMcMOPKmS5GQyhw06+O33+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=twYESaRz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="twYESaRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A946C4CEF1;
	Fri, 12 Dec 2025 03:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765511905;
	bh=1pHlS6z2ukRwKRMPs3eNcwfJlx3rGmydK2Jvd4JEZCk=;
	h=Date:From:To:Cc:Subject:From;
	b=twYESaRzietm3/lI9Zi6UQXHrNzcVIiKPGyhkN3qVdeorN3zHek6lj/ra6kBREK9f
	 GlwQQ+vqTy+O3kTdvA6IlnQzAl+vVj+UFjzCigksQPTt52jqYt/3fKS/Jrm6uJcNsp
	 8E1zB6ad8AHlwKuxPVsNR2tHkTGFiDyYkkDlCZYSFPYbgg7hIuRk65LhO/060yz4SO
	 leNEoxcHnMl5vajxY4Shv0L1cSrrqw6cyiTMWK6es2hP6vS5qsk+l8b7p/gRbBGqcu
	 POkX11E2eAkWnmEDxhFRljS/XLkoX+ZSs5DAk2+W7qBY+ci8mDfHFb0R/BySe7k6x6
	 LxQqlCFNo53Ow==
Date: Thu, 11 Dec 2025 19:58:18 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Diederik de Haas <diederik@cknow-tech.com>,
	Jerry Shih <jerry.shih@sifive.com>,
	Vivian Wang <wangruikang@iscas.ac.cn>
Subject: [GIT PULL] Crypto library fixes for v6.19-rc1
Message-ID: <20251212035818.GA4838@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 7a3984bbd69055898add0fe22445f99435f33450:

  Merge tag 'mips_6.19' of git://git.kernel.org/pub/scm/linux/kernel/git/mips/linux (2025-12-10 06:20:22 +0900)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-fixes-for-linus

for you to fetch changes up to f6a458746f905adb7d70e50e8b9383dc9e3fd75f:

  crypto: arm64/ghash - Fix incorrect output from ghash-neon (2025-12-10 09:46:26 -0800)

----------------------------------------------------------------

Fixes for some recent regressions as well as some longstanding issues:

 - Fix incorrect output from the arm64 NEON implementation of GHASH

 - Merge the ksimd scopes in the arm64 XTS code to reduce stack usage

 - Roll up the BLAKE2b round loop on 32-bit kernels to greatly reduce
   code size and stack usage

 - Add missing RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS dependency

 - Fix chacha-riscv64-zvkb.S to not use frame pointer for data

----------------------------------------------------------------
Ard Biesheuvel (2):
      crypto/arm64: aes/xts - Use single ksimd scope to reduce stack bloat
      crypto/arm64: sm4/xts - Merge ksimd scopes to reduce stack bloat

Eric Biggers (4):
      lib/crypto: riscv: Depend on RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
      lib/crypto: blake2b: Roll up BLAKE2b round loop on 32-bit
      lib/crypto: blake2s: Replace manual unrolling with unrolled_full
      crypto: arm64/ghash - Fix incorrect output from ghash-neon

Vivian Wang (1):
      lib/crypto: riscv/chacha: Avoid s0/fp register

 arch/arm64/crypto/aes-glue.c           | 75 ++++++++++++++++------------------
 arch/arm64/crypto/aes-neonbs-glue.c    | 44 ++++++++++----------
 arch/arm64/crypto/ghash-ce-glue.c      |  2 +-
 arch/arm64/crypto/sm4-ce-glue.c        | 42 +++++++++----------
 arch/riscv/crypto/Kconfig              | 12 ++++--
 lib/crypto/Kconfig                     |  9 ++--
 lib/crypto/Makefile                    |  1 -
 lib/crypto/blake2b.c                   | 44 +++++++++-----------
 lib/crypto/blake2s.c                   | 38 ++++++++---------
 lib/crypto/riscv/chacha-riscv64-zvkb.S |  5 +--
 10 files changed, 130 insertions(+), 142 deletions(-)
