Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D1D3803D4;
	Thu,  5 Mar 2026 18:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772736177; cv=none; b=QPW1Aa3Wkn2fARvYzNNCQb3dCvX7vQzVmpZKtmy7LhQZLTZWG2C0E7x2RYOC8jxX7iXpxk4lfOS520jUBSH2yuLnZyyWWYJFIB1pWFtchNON4eCfO7RH2I1MFeMhF2zSwLgab95eli6eBFGsHD5xaGA1aCp9v4/sFdvxxWtCbpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772736177; c=relaxed/simple;
	bh=HXFwye6TjZ2zWMOtockgbKzyxUfFjkR2RM+j2C5LwGA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=vFNyhQQcmX4vcf1I+dwd/LykXwkYgvp7e3AWXyChUof5838O3EypI9LrBtjEgKH4JnCYhMSPSsXNkohEen+vvHTOtRkLLmGdJplGpvfVaucL49T5Rnk9yundlbU+4pGMN3z0/r3++Bib7SLRhaDkAT5h4TOpfHdHU6jpWMxIHQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M1suozit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M1suozit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E7AC116C6;
	Thu,  5 Mar 2026 18:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772736176;
	bh=HXFwye6TjZ2zWMOtockgbKzyxUfFjkR2RM+j2C5LwGA=;
	h=Date:From:To:Cc:Subject:From;
	b=M1suozit7dnA6VnYkehSSjDHA4MZNTvi6XSrD8UZ2x3WX2hLMAjMca48vcvdyvQ3a
	 Xb3m/x+hGIyucGzAuQKOLnAXx8i2fmWywVk1IN1PASq99ZGN+p1L3H5SniaNjaoEGw
	 hCgnTHPlJkY+bwspr/AVnnsubDxZSjnW06CynSjfKFHMACoejDLmGqzd+mtKxOANmP
	 RXc1byRV8l/pVXR9Qh1oL5M6dcu/PGzjK0eMyi3CIROHCWOiIxkE0+3LZjmW0EXdsy
	 M/2NKRgwjMp+Rwf90evt4m9n+nyFN7QOvw9JIxk00nARp4ijrLrdrozKmBEWUthrT9
	 +ffkSOvvGFGjA==
Date: Thu, 5 Mar 2026 10:42:54 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kunit-dev@googlegroups.com, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	David Gow <david@davidgow.net>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [GIT PULL] Crypto library fixes for v7.0-rc3
Message-ID: <20260305184254.GA2796@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f:

  Linux 7.0-rc1 (2026-02-22 13:18:59 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

for you to fetch changes up to 3875ceb592d3cb23dc932165cc1eeb74cf4dc319:

  crypto: testmgr - Fix stale references to aes-generic (2026-03-03 11:57:15 -0800)

----------------------------------------------------------------

- Several test fixes:

   - Fix flakiness in the interrupt context tests in certain VMs.

   - Make the lib/crypto/ KUnit tests depend on the corresponding
     library options rather than selecting them. This follows the
     standard KUnit convention, and it fixes an issue where enabling
     CONFIG_KUNIT_ALL_TESTS pulled in all the crypto library code.

   - Add a kunitconfig file for lib/crypto/.

   - Fix a couple stale references to "aes-generic" that made it in
     concurrently with the rename to "aes-lib".

- Update the help text for several CRYPTO kconfig options to remove
  outdated information about users that now use the library instead.

----------------------------------------------------------------
Eric Biggers (4):
      kunit: irq: Ensure timer doesn't fire too frequently
      lib/crypto: tests: Depend on library options rather than selecting them
      lib/crypto: tests: Add a .kunitconfig file
      crypto: testmgr - Fix stale references to aes-generic

Geert Uytterhoeven (5):
      crypto: Clean up help text for CRYPTO_BLAKE2B
      crypto: Clean up help text for CRYPTO_SHA256
      crypto: Clean up help text for CRYPTO_XXHASH
      crypto: Clean up help text for CRYPTO_CRC32C
      crypto: Clean up help text for CRYPTO_CRC32

 crypto/Kconfig                     |  9 --------
 crypto/testmgr.c                   |  4 ++--
 include/kunit/run-in-irq-context.h | 44 ++++++++++++++++++++++++--------------
 lib/crypto/.kunitconfig            | 34 +++++++++++++++++++++++++++++
 lib/crypto/tests/Kconfig           | 35 +++++++++++-------------------
 5 files changed, 76 insertions(+), 50 deletions(-)
 create mode 100644 lib/crypto/.kunitconfig
