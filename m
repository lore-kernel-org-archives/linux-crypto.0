Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214312DC34C;
	Tue,  8 Jul 2025 16:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993161; cv=none; b=a6PXSD7774mT1rwXj/AJXaLQCZdf0DZ0ryRws5MByf4PdNYQAV7mSOdE91M0Xp+6YikshU5LZQ2K97m68jhAiTxTDsx2nKCZaAGkn7YMToFKWmKCYVjbw/XtaeJUJyR/LMhWIkeaVJ5sMEPARhYj3epuM5A1yPROZvurQhgkY3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993161; c=relaxed/simple;
	bh=4ddaXVIyv3r5pSRFFdHzns9XwfAeX8Wt7e0TkkY10t0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WTKAGFxRrcT+kAsXEddAtaB9VtdIOrSg5E+4tlKkGy5niOh11UctqHZn2Vk8cQ6TVVyJpF9MFeUjOBUR48b/HG8Brsy2+osqAAhx4KEPnXr5qX1PqdlXq86+JEhH2o4H1rvLvv7Vx93nagSFYo9RtkVY6s/wIwkYs6GhEr2+qaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zh2v2Mvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zh2v2Mvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D476C4CEF6;
	Tue,  8 Jul 2025 16:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751993160;
	bh=4ddaXVIyv3r5pSRFFdHzns9XwfAeX8Wt7e0TkkY10t0=;
	h=Date:From:To:Cc:Subject:From;
	b=Zh2v2MvfqEVna8Ib4zaYMflt575hNTyunDCAcTU+rucu8qU3LnAZKPpA8fymjjwVe
	 TAYVmSElWDRon2vslBozv3Z9L5a/vpu2F9vxNTrbKquiXgtelibtfYzkD5bMDDlrgB
	 0HCzLpdeuUmogd7NJuAy83k5pP4ppqe2Y3MHKUsi3jsXXM+JX5fVGSwa7TyCYnQdFB
	 u7YS9/tSQAawY3h4gnXuhczRq8ccBy+Yrd1d67390ey+lNbpiXCCLuPnkCLEoHf+o2
	 fs4KRUAuIdJOCKvQH7cEGb00VX0buH41/vW+dxHFhG3UW3s7G18S6nvVXEOwEzexO3
	 YO1y63bXUL6ag==
Date: Tue, 8 Jul 2025 09:45:17 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>
Subject: [GIT PULL] Crypto library fix for v6.16-rc6
Message-ID: <20250708164517.GA1255@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 64f7548aad63d2fbca2eeb6eb33361c218ebd5a5:

  lib/crypto: sha256: Mark sha256_choose_blocks as __always_inline (2025-06-20 13:22:03 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

for you to fetch changes up to 68279380266a5fa70e664de754503338e2ec3f43:

  crypto: s390/sha - Fix uninitialized variable in SHA-1 and SHA-2 (2025-07-03 10:27:26 -0700)

----------------------------------------------------------------

Fix an uninitialized variable in the s390 optimized SHA-1 and SHA-2.

Note that my librarification changes also fix this by greatly
simplifying how the s390 optimized SHA code is integrated.  However, we
need this separate fix for 6.16 and older versions.

----------------------------------------------------------------
Eric Biggers (1):
      crypto: s390/sha - Fix uninitialized variable in SHA-1 and SHA-2

 arch/s390/crypto/sha1_s390.c   | 2 ++
 arch/s390/crypto/sha512_s390.c | 3 +++
 2 files changed, 5 insertions(+)
