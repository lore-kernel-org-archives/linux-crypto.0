Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33133009D6;
	Thu,  6 Nov 2025 20:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762461106; cv=none; b=NiK6pTj0in78yocPb2C7Kt3F2JQeig2bhEkbTnxwD4hSWUBAjqXfDojHLLRtq5kMQ/zDGjgikp7MfUdGnRNYvx+/QK7KzZkXiFXbq7+PGNEfMQuEypo8jz07vQ4GLFVppuQjC6fa2K7kTxUXDMIn/qZYm4N87wsvQLGbQIShkOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762461106; c=relaxed/simple;
	bh=u/7TfbAlHuJ2UDT7ZAW9n8gHWzWOegJ6HHMiLpeGAv0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=L6nGv35mUfRvvarKt+fFb8MrS3TtNy2k5M/8Lfea3PNvid5e8qMASRuE78v7F5zKklU7kH1WOb6JZnkC7pq4SbzXcsvaPSd6NLA/csSCDWtbUHdYtOk5qdDBlpv0diG+IO5KNnOLt4fqwb6InbhyvVn5QON2s+4pWpvgfoGcoBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pK+B+mb3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pK+B+mb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C32C4CEF7;
	Thu,  6 Nov 2025 20:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762461105;
	bh=u/7TfbAlHuJ2UDT7ZAW9n8gHWzWOegJ6HHMiLpeGAv0=;
	h=Date:From:To:Cc:Subject:From;
	b=pK+B+mb3bIOm2SGfBcujpuyWAHsLgGD4gDiEL+R/1nwPkZgAM134lr//7+l8y9i0c
	 /MQoYetfY1mYJPrwkcI3yn9lUz4zyECmrbQZ3+2q5VEApE/+MA5D/DflwoRR5awkQw
	 e8XOq65sVKlOVXEofEQ1XiGqh+uBsDIe36ddNYksVHnwN4OGIF6WXFLwaicTjCbIwt
	 SQVY6MdEy3yQ5CYm7l8NBeHcqyBW6qao2FFSFvEDfuZa7ceUHmTE1M8KWBX/OUFMeQ
	 hx96Z9Y5HUwgPrFE+pdReSJ3CB7TcwQ748Fas8/jU+KeGI8exBfAD80awcy+aNt/Zm
	 ZC/WqwONBoF/w==
Date: Thu, 6 Nov 2025 12:31:36 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [GIT PULL] Crypto library fixes for v6.18-rc5
Message-ID: <20251106203136.GB7015@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 1af424b15401d2be789c4dc2279889514e7c5c94:

  lib/crypto: poly1305: Restore dependency of arch code on !KMSAN (2025-10-22 10:52:10 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

for you to fetch changes up to 44e8241c51f762aafa50ed116da68fd6ecdcc954:

  lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN (2025-11-04 09:36:22 -0800)

----------------------------------------------------------------

Two Curve25519 related fixes:

- Re-enable KASAN support on curve25519-hacl64.c with gcc.

- Disable the arm optimized Curve25519 code on CONFIG_CPU_BIG_ENDIAN=y
  kernels. It has always been broken in that configuration.

----------------------------------------------------------------
Eric Biggers (1):
      lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN

Nathan Chancellor (1):
      lib/crypto: curve25519-hacl64: Fix older clang KASAN workaround for GCC

 lib/crypto/Kconfig  | 2 +-
 lib/crypto/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
