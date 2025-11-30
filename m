Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C941E0DCB;
	Sun, 30 Nov 2025 02:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764470949; cv=none; b=pObdepUv5IOv30H4ywuSobK6qS7xGx2ornbLrOvUWKVJYNUeYtO6zbgVNWKTHQT1U+DxVuphKIwsPojzVR99n93LT6A1+KIi+1JWOuhO4H5it7ImQqT7xdCplC3zqeCJOUvVc8WZN733oDGxNtwrn827OkfTX31vYywQc2GXtgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764470949; c=relaxed/simple;
	bh=pg27yUJFtJXneU5qJim8ZDqOKEOE1LxwflkzOUfe8jk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=lXWgXUmLilFtA99gFhceBMXdywe5WK+7fKaaiS1jTDj7sE+pqmWb5v4s6+qCnz2lW+H2rMVhCbUCfIUW9Hh8+OafnjITy564L59pS2OPhPTqWY/7kckESW7zS/yIo3OxcDR04xQ9CBMoKxsB9lUDFeaPaTMqCW4R7qNdnok5M5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dw7kwXGr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dw7kwXGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251E2C4CEF7;
	Sun, 30 Nov 2025 02:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764470949;
	bh=pg27yUJFtJXneU5qJim8ZDqOKEOE1LxwflkzOUfe8jk=;
	h=Date:From:To:Cc:Subject:From;
	b=Dw7kwXGr8lsUDdFuckWktcy4aJtBxLRSaPa0A/v2P8LbN0HCzHJNY1iQURoDY62H+
	 sXEdEa0Y+U7ratCf2jtxL+G2Taqijje39c4Bn4ZZZ5KGDCU65mafdLm28TkZQLTTjM
	 6iWIFcEVVwMYx2r29yoP3ssAMqnkKUL7vTW4hsO0wAPhSv9pZ+2u+n3NRTgZbNZMOl
	 LDQcGU5yOrnQz+/1zJYJ9A5wfzIszrtR9vC0CISASxzEeu6noI8LHGSdVXmBYmdNIi
	 MpHMJPbo7st5HxZVgFYGpNcju/bgHaZcOj81lFESlUnpnokKOesMXFhCnIe483MzSu
	 LZSK9pgbnurfg==
Date: Sat, 29 Nov 2025 18:47:19 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [GIT PULL] AES-GCM optimizations for 6.19
Message-ID: <20251130024719.GD12664@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa:

  Linux 6.18-rc3 (2025-10-26 15:59:49 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/aes-gcm-for-linus

for you to fetch changes up to 0e253e250ed0e46f5ff6962c840157da9dab48cd:

  crypto: x86/aes-gcm-vaes-avx2 - initialize full %rax return register (2025-11-03 09:07:57 -0800)

----------------------------------------------------------------

More optimizations and cleanups for the x86_64 AES-GCM code:

- Add a VAES+AVX2 optimized implementation of AES-GCM. This is very
  helpful on CPUs that have VAES but not AVX512, such as AMD Zen 3.

- Make the VAES+AVX512 optimized implementation of AES-GCM handle
  large amounts of associated data efficiently.

- Remove the "avx10_256" implementation of AES-GCM. It's superseded by
  the VAES+AVX2 optimized implementation.

- Rename the "avx10_512" implementation to "avx512".

Overall, this fills in a gap where AES-GCM wasn't fully optimized on
some recent CPUs. It also drops code that won't be as useful as
initially expected due to AVX10/256 being dropped from the AVX10 spec.

----------------------------------------------------------------
Eric Biggers (9):
      crypto: x86/aes-gcm - add VAES+AVX2 optimized code
      crypto: x86/aes-gcm - remove VAES+AVX10/256 optimized code
      crypto: x86/aes-gcm - rename avx10 and avx10_512 to avx512
      crypto: x86/aes-gcm - clean up AVX512 code to assume 512-bit vectors
      crypto: x86/aes-gcm - reorder AVX512 precompute and aad_update functions
      crypto: x86/aes-gcm - revise some comments in AVX512 code
      crypto: x86/aes-gcm - optimize AVX512 precomputation of H^2 from H^1
      crypto: x86/aes-gcm - optimize long AAD processing with AVX512
      crypto: x86/aes-gcm-vaes-avx2 - initialize full %rax return register

 arch/x86/crypto/Makefile                           |    5 +-
 arch/x86/crypto/aes-gcm-aesni-x86_64.S             |   12 +-
 arch/x86/crypto/aes-gcm-vaes-avx2.S                | 1146 ++++++++++++++++++++
 ...es-gcm-avx10-x86_64.S => aes-gcm-vaes-avx512.S} |  722 ++++++------
 arch/x86/crypto/aesni-intel_glue.c                 |  264 +++--
 5 files changed, 1663 insertions(+), 486 deletions(-)
 create mode 100644 arch/x86/crypto/aes-gcm-vaes-avx2.S
 rename arch/x86/crypto/{aes-gcm-avx10-x86_64.S => aes-gcm-vaes-avx512.S} (69%)
