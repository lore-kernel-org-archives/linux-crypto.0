Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA7222157E;
	Fri,  2 Jan 2026 18:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767378232; cv=none; b=Y7jUSfmIxMzrkRz0iMWjwS82FECDGq+wc4txGt5aLFop51bTWw8Ms++7854MmdN1T0mthJeRJZBrk3I2/fuUbDVawx+TGJr2Kud3Hns057t+iUqEr/TP4VTcI7ewyoMZLmZwK/rTF+kHi58vE/q26CL7tX/b+MagTGlbmK8EdjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767378232; c=relaxed/simple;
	bh=bAAbAc7tTgAKFQ/cHsUbXE+LZDHg4lW0/MHKUOdanz8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Z5qtc0WlqTNTe+PK4gGs5ggbXw9Wec5bHtwisXFB/5fdLA/K1purMXuMwbYyY9xw1Zo4TiML25lnUqEgqCHA6h/+bcnon6BpBD83XSsQYsZ+2isWw5u9lAVpM2ok5ADoneBDeaOGiol1ep9oWndNSh1Vop7YGgjRBdk8O5qDf2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P+Q9+997; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P+Q9+997"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DF0C116B1;
	Fri,  2 Jan 2026 18:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767378232;
	bh=bAAbAc7tTgAKFQ/cHsUbXE+LZDHg4lW0/MHKUOdanz8=;
	h=Date:From:To:Cc:Subject:From;
	b=P+Q9+997x/y7t10mQEHHp1lYxnWGW7nOZYa1htn2eTHU+2/lougLHlZsV4dSn28eS
	 YmSuLLVP9j0TswGT3+F6zdA9YOEFrGav9Tp1TVg6yrTTLM+evNu8WaNr48SkuyEDJL
	 pVQlFd6raXPkqW6jid5WA2Dn+wSAx9TnsNIbpegY3rIO5E6jYjJs1cq8LrGKrWSX2P
	 v6Cgtp0BHbdjJZQThiOzxPC6yNRNMkU9P+ujMx/C4Ph2/8YGX7NluVRB6LXx7RYwW+
	 cJy/5SK1W48oNaRt7vkZ8m2bMSuGwfVbUMSPOY1RxsIec1iC/L0GnmhNzoo/DhYPPx
	 +OYyZMmxiqTAQ==
Date: Fri, 2 Jan 2026 10:23:34 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Gow <davidgow@google.com>
Subject: [GIT PULL] Crypto library fix for v6.19-rc4
Message-ID: <20260102182334.GA2294@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 9448598b22c50c8a5bb77a9103e2d49f134c9578:

  Linux 6.19-rc2 (2025-12-21 15:52:04 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-fixes-for-linus

for you to fetch changes up to c31f4aa8fed048fa70e742c4bb49bb48dc489ab3:

  kunit: Enforce task execution in {soft,hard}irq contexts (2025-12-22 12:20:08 -0800)

----------------------------------------------------------------

Fix the kunit_run_irq_test() function (which I recently added for the
CRC and crypto tests) to be less timing-dependent. This fixes flakiness
in the polyval kunit test suite.

----------------------------------------------------------------
David Gow (1):
      kunit: Enforce task execution in {soft,hard}irq contexts

 include/kunit/run-in-irq-context.h | 53 ++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 20 deletions(-)
