Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45D22E7374;
	Mon, 15 Jun 2026 17:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781546101; cv=none; b=NNYK9IYo34yxHvBT9fUICmDPTUNGv/eDQ45ZYJ1i/ooUnmaw43xnQUi8jguCf30n1P8PlhrRgA4bwIoXeSbXZOfPyRmJXPpuDvZiekqbXEPplXtTHpVd7oP29xLlX9x4+hldQwmDH0QE7Y08AAfA/FSddVnYowCHmqGvLY3tJkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781546101; c=relaxed/simple;
	bh=xhSKKiZRhusBjiF74atW6q90/Ob4pADI0DEk3f1ZHos=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bBcy4q6x3SCjyHewj6VBs/2fdUnCuFWTO5SUsIuUcwp8EilTrExdBeJnK81H39wvo+Ud/UN3pJtVIiEhk9QhgLAiy9m+3LW6RXzkj+4h4duhdywv7GbobJastE5SDkIWDkjsPxcnazRKflultD893xOFuV+DybQWt1lgqJE0rYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f48ZGrYl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f48ZGrYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E921F000E9;
	Mon, 15 Jun 2026 17:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781546100;
	bh=Gtf4r9zurBlBqw5iBxglRnHWsIgGGwcWLAiCz77jg8c=;
	h=Date:From:To:Cc:Subject;
	b=f48ZGrYl8ZVDCPEI47eHlEc/DA9tiLO7r270cPIISfRQGXoMosSQ3/4wZYhrAhpEv
	 Zt7tIvLwSyaZliAZoJ/DCJysRYsgDy3a8y+1c6FeH759iV2rnJv7DBIBhcLAYOF2yh
	 6+KLoHxX7UsYPaQ0GGcmzUdNepeFdCJ9ZQjbI7mmfJW1ixS6DZ6x6QSBHF0+61n8/C
	 IFZ4sJlDHPfSprl78dOwaUN2Nk5qx+Pkf4pWuqnsWw/oVzRHQHJ0D9dkhmpvEekBWY
	 k1QWvOI33Z41VKHD92va+qsjyp3UvmiV039/uIeG7Z+UaweohdyMbZYDwqt6pCSNFx
	 Ul8vGrWQEvQyw==
Date: Mon, 15 Jun 2026 10:54:58 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Arnd Bergmann <arnd@arndb.de>,
	Christophe Leroy <chleroy@kernel.org>
Subject: [GIT PULL] Crypto library updates for 7.2
Message-ID: <20260615175458.GB1831@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 7fd2df204f342fc17d1a0bfcd474b24232fb0f32:

  Linux 7.1-rc2 (2026-05-03 14:21:25 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

for you to fetch changes up to 065f978a0e015c4dd9f536f5c08078a37f5509c1:

  lib/crypto: gf128hash: mark clmul32() as noinline_for_stack (2026-06-11 12:57:49 -0700)

----------------------------------------------------------------

- Drop the last architecture-specific implementation of MD5

- Mark clmul32() as noinline_for_stack to improve codegen in some cases

----------------------------------------------------------------
Arnd Bergmann (1):
      lib/crypto: gf128hash: mark clmul32() as noinline_for_stack

Eric Biggers (1):
      lib/crypto: powerpc/md5: Drop powerpc optimized MD5 code

 lib/crypto/Kconfig           |   5 -
 lib/crypto/Makefile          |   4 -
 lib/crypto/gf128hash.c       |   2 +-
 lib/crypto/md5.c             |  20 ++--
 lib/crypto/powerpc/md5-asm.S | 235 -------------------------------------------
 lib/crypto/powerpc/md5.h     |  12 ---
 6 files changed, 8 insertions(+), 270 deletions(-)
 delete mode 100644 lib/crypto/powerpc/md5-asm.S
 delete mode 100644 lib/crypto/powerpc/md5.h
