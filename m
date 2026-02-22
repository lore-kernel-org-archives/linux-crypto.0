Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D19535C182;
	Sun, 22 Feb 2026 20:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771792552; cv=none; b=gJU4MzEm25oc5iH0JWdYHga5w/WqGzmpolihgHbYmo9HETN9DpKAjOCtS+5++gGsLw6jLHouuOc8RmWg+cucoCIFHVnW6OdIdAKR7h3B9u8LyHluHcVXUp0GEGxDEYkj1a0lBIzF/5aWfrp1DqfqYkSwg/ClL8uUJ5zrzsVVzh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771792552; c=relaxed/simple;
	bh=nB3wfhscOxQHp0LEV1GBvtP30jxZODZvLWMqMVvIqSc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=M7K4UvbfNUBfm9ASTpsz5330o1Dho1vC85YXT3G2cmdJ3Tv4dheImpZV4Xcr3Ed1BzuXPlT0Fr+FuIeqUU933r6CKVgrWXQY0+ZZFS6rL08SvL/JfwHYlwtZKXY4ehWaPOK92KbUnDu9NQHInYUoh04ggeZm3C492OwaoqiuY0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h5VJEA6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h5VJEA6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7D1C116D0;
	Sun, 22 Feb 2026 20:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771792552;
	bh=nB3wfhscOxQHp0LEV1GBvtP30jxZODZvLWMqMVvIqSc=;
	h=Date:From:To:Cc:Subject:From;
	b=h5VJEA6w+T7vpIgRUfEycWyh6a0iGlFk2yJkPJQqTmVchoUkeyLsRJc+/Ia9LyXYr
	 zDkrk20h7S7Z3wW8hqwwGxqKFzFxp8FG0mUI4ta/e91XCa0r8gNSnWfT6tkPbnubdE
	 fBD45a5Fwjub3UfFnU/wI9+pp2+vq+1Zi7snQAl0z1ZG18U16aBlU9nx4/PM8mravY
	 64TofNgrwSdEjCP2lCOhcZPTluC3+Rx+SbqCSXSQCHEfFWhfU9/19VhNDaTM2tO3Xg
	 rqWBT94HCaBXD+s5Z8IgVaqh/xiQj/r/KzUEOMnfYeTYEwhg3GQtc0WbvLllcoOWOs
	 ym+z7sYC+yx8A==
Date: Sun, 22 Feb 2026 12:35:43 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [GIT PULL] Crypto library fix for v7.0-rc1
Message-ID: <20260222203543.GC37806@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 23b0f90ba871f096474e1c27c3d14f455189d2d9:

  Merge tag 'sysctl-7.00-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/sysctl/sysctl (2026-02-18 10:45:36 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

for you to fetch changes up to beeebffc807531f69445356180238500f56951cc:

  lib/crypto: powerpc/aes: Fix rndkey_from_vsx() on big endian CPUs (2026-02-18 13:38:14 -0800)

----------------------------------------------------------------

Fix a big endian specific issue in the PPC64-optimized AES code.

----------------------------------------------------------------
Eric Biggers (1):
      lib/crypto: powerpc/aes: Fix rndkey_from_vsx() on big endian CPUs

 lib/crypto/powerpc/aes.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)
