Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65714281353;
	Thu, 21 Aug 2025 03:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755747263; cv=none; b=pBmtNKfAZggALZc6kmwI1wds+1UmoorIl9A6JLjsebv/D6HGDdIQ3813ZRMd7wi+XM3xrqP/a5fE2TfsPxJLJyIB5LfNL1g4rfjZLebjSly1OU9BC7HveskkcI4/frj3N0qbEeNuGs/DPUJV3Tyv84Ay4tLv2beSnnAgggjpFWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755747263; c=relaxed/simple;
	bh=WDmmYdxvpq2UMvNH7SzTCIRj2nfQH92lBEKnLvaAGk8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=m1xbV1LH1HYBzllqXdx5LgdgwklzsuhVfPo0zOeEWIKrhHA1vbchN9eSKhTtKrOAXEkSb54PNms1wk+X+LT3B//0wSXeL04yzRHE/e4fr5Q8+HauCMvJOLdFt/N79hK+BGuzSs0+btgfVOmGC1MOg9vmDviw4DjGf4gPhbRIFwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KMn4M4m6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KMn4M4m6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA99C4CEF4;
	Thu, 21 Aug 2025 03:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755747262;
	bh=WDmmYdxvpq2UMvNH7SzTCIRj2nfQH92lBEKnLvaAGk8=;
	h=Date:From:To:Cc:Subject:From;
	b=KMn4M4m6IgA3HJtyfu11vJmaSkHDPPZzFbEgiFiAQUoGzHw88PRtqmeSs4K7F8WxE
	 tPo7/XaWU2mRDgaZyvR9vmQUje8miKXqu33Jglw1lXidfZ8Aexm29keEl9VKTx4LBo
	 svmaKQ9vH0oLUarBfZNXedoULr+5IdWt1eJPDlxKS5YBpdmCTopVS+UWUPGEKVWh7T
	 etD+Q3C5l3ZqIl05I9dM/FUnEICgWgP65+0DYme0tsD8AbM4y2+iMOJcAHZXi5ibcp
	 Wpj91iENUhMwmvpbyObYtyaKn8Ha8OI6XV8LOf4FY5sOHsddWnJE5rbaDG2zT8JWaA
	 S0Af+zBd5vZDQ==
Date: Wed, 20 Aug 2025 23:34:20 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Tal Zussman <tz2294@columbia.edu>
Subject: [GIT PULL] Crypto library fixes for v6.17-rc3
Message-ID: <20250821033420.GB185832@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 8f5ae30d69d7543eee0d70083daf4de8fe15d585:

  Linux 6.17-rc1 (2025-08-10 19:41:16 +0300)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

for you to fetch changes up to fd7e5de4b2eddd34e3567cd419812d8869ef4f13:

  lib/crypto: ensure generated *.S files are removed on make clean (2025-08-14 18:01:03 -0700)

----------------------------------------------------------------

Fix a regression where 'make clean' stopped removing some of the
generated assembly files on arm and arm64.

----------------------------------------------------------------
Eric Biggers (1):
      lib/crypto: sha: Update Kconfig help for SHA1 and SHA256

Tal Zussman (1):
      lib/crypto: ensure generated *.S files are removed on make clean

 lib/crypto/Kconfig  | 10 +++++-----
 lib/crypto/Makefile |  8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)
