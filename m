Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCD31EDA1E;
	Wed, 18 Jun 2025 19:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750276230; cv=none; b=mA+gtzvGzPE3kJSefOqTDvReJ2fV0BjcXuPkl8CiGEW+jX4bbnTZlbSV0W7J8b6DguBTLKprhEUPUwFki0kKl6qMv0t7DzfdL896m1l9GY9AE1v0rhKnqwKDKiI8YphMoht0oEaDhB5CeFwIJh5OUSV5tn02LPx2vbAaGpGAxls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750276230; c=relaxed/simple;
	bh=wKUcMtrvvzK50yYjYJoEi7kJnjIJs9L4uafhlbXlqhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rv+zsz/Bo/bK084xUQpg9q9q0PD2OVOpSwj3siGZfes219brzhXsIqnDr00xTPaoTnRo9ViG83eDrFN6trOdzm623k+MCyHZUYcvOkSGwzLFYLrlkXOyALyggezJHKSiyojEHlWeri051qEOMZzTfmsuxd+g5WD319NhyeshwWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nDxGklm3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nDxGklm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686ECC4CEE7;
	Wed, 18 Jun 2025 19:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750276229;
	bh=wKUcMtrvvzK50yYjYJoEi7kJnjIJs9L4uafhlbXlqhQ=;
	h=Date:From:To:Cc:Subject:From;
	b=nDxGklm3sq+f3EsmxqAxFrDksuI0cMafbTK02VhqWQ5xaKpjP2+S0ERYh8srQGRJI
	 kNTf1NX5P23Zvpjcd6/gOCrsBEkOWy8cKRZghwUcu51Mo9OjR6+c0qg+Yw9TJxsyQu
	 Wqy34piF2m8y1DBZH2Fg2pHeLiMts/jJHwhr4GJcl3gzp65CJnQaQ6Qm07Jg6kyxdT
	 HPHPhhpr8mU8qFz1z7JvEz4ja69O9h80KcgEKMLMxaLrgdZ7mxSSNe7P59bM6g493m
	 zObNU+CXgxUdSiIlaWCeLvfEpmv4n5rsqX+8CslhLKcXbEoJVTuYxWK745v4F3cDp3
	 5C6vV7bxepd/g==
Date: Wed, 18 Jun 2025 12:49:58 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>, Kees Cook <kees@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [GIT PULL] Crypto library fixes for v6.16-rc3
Message-ID: <20250618194958.GA1312@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 19272b37aa4f83ca52bdf9c16d5d81bdd1354494:

  Linux 6.16-rc1 (2025-06-08 13:44:43 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

for you to fetch changes up to 9d4204a8106fe7dc80e3f2e440c8f2ba1ba47319:

  lib/crypto/poly1305: Fix arm64's poly1305_blocks_arch() (2025-06-16 12:51:34 -0700)

----------------------------------------------------------------

- Fix a regression in the arm64 Poly1305 code
- Fix a couple compiler warnings

----------------------------------------------------------------
Eric Biggers (1):
      lib/crypto/poly1305: Fix arm64's poly1305_blocks_arch()

Kees Cook (1):
      lib/crypto: Annotate crypto strings with nonstring

Nathan Chancellor (1):
      lib/crypto/curve25519-hacl64: Disable KASAN with clang-17 and older

 arch/arm64/lib/crypto/poly1305-glue.c |  4 +--
 lib/crypto/Makefile                   |  4 +++
 lib/crypto/aescfb.c                   |  8 +++---
 lib/crypto/aesgcm.c                   | 46 +++++++++++++++++------------------
 4 files changed, 33 insertions(+), 29 deletions(-)
