Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3744C1DE8AD;
	Fri, 27 Jun 2025 18:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751048105; cv=none; b=gwBq/lwjAZ+HvM0fIXWOIzxbI51xjEGCajnrwyPcyzBjvLNGhUzcquaV+o5GetmvqSmCJzvUAqUD7n7bkGTxbet3kcMC5Kl4+G1YkLh0dko9qlYXUoVgbqM933Zv892DwN5uhCz343tfaQzl9cIWkGXPJUtArHhR4820mgEjhPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751048105; c=relaxed/simple;
	bh=cIP4izaMvFnQys6iv3/mLZYwBvTrUNghSROmVDUoauI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FIq6N5Lh5n1gYtoWZdn15N6h+LG8Wl6khDp8wRcvOQFBGJwfDR8zBQ5mbIA6s928O6YFsZCg8b5H3HFBlAfZH2+Fz54BsbeCX9UxKAMCyUmSfajIOIQTT/5sbKO+vXdSwfgHLhGYriL2yAv9fzLYRa8wSz1JABOzjZ5/knQrQi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HiGwjV+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HiGwjV+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A67C4CEE3;
	Fri, 27 Jun 2025 18:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751048104;
	bh=cIP4izaMvFnQys6iv3/mLZYwBvTrUNghSROmVDUoauI=;
	h=Date:From:To:Cc:Subject:From;
	b=HiGwjV+jEkg7ctuDSS9RXUWcVsMjcNcr9DnJjBTcvrb0mP7GP674tPwbGy6Yx/2Sk
	 DYSb8Qyl2J+CacfT3C7cQdtqKTIhCIbGhEJiY0BduGFZiOS2igEymv9s2j8QoCSSw6
	 rpahtxpNQ1P08ZEHgrBVfRgbulj0I/RWsn4A7bRv+/yd+zo9hAsH3Ntg7CtRErPzbT
	 +cn+hvL/6tqXph+LznMF7sEe7qGm1bEIEZ3NMLZ4GbKzav5DvWHp88a6O3U8DrmzYS
	 Wprm4eE4YZVoOMvgWFazKzQCUe1MTwA5+xviW3+TZXl26Zu3jckOTK3F/Qu98D6Lkk
	 KPWrJjf3dZRJQ==
Date: Fri, 27 Jun 2025 11:14:28 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL] Crypto library fix for v6.16-rc4
Message-ID: <20250627181428.GA1234@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 9d4204a8106fe7dc80e3f2e440c8f2ba1ba47319:

  lib/crypto/poly1305: Fix arm64's poly1305_blocks_arch() (2025-06-16 12:51:34 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

for you to fetch changes up to 64f7548aad63d2fbca2eeb6eb33361c218ebd5a5:

  lib/crypto: sha256: Mark sha256_choose_blocks as __always_inline (2025-06-20 13:22:03 -0700)

----------------------------------------------------------------

Fix a regression where the purgatory code sometimes fails to build.

----------------------------------------------------------------
Arnd Bergmann (1):
      lib/crypto: sha256: Mark sha256_choose_blocks as __always_inline

 include/crypto/internal/sha2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
