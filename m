Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2D551FCC0;
	Thu,  1 Oct 2026 17:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790877202; cv=none; b=F4MF6waAiZF3m6cW6QDhdBLMm6T6IK0F/8y4clBjnefjipflJkIaZt5j2cDZFLUD3KU/WIMBXEk21FC2h6TTUDmeYaxJj+OMnUrZfzjWI2LS8Afyl33GRK2hf5shbOSVxNVz2k69tsaG/s+N9ndyemUJuj+RQEqxAbnq6/TCpRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790877202; c=relaxed/simple;
	bh=jfrSZPOHg16qf7KBw2NKT9EEXP8iSQD1/pHMlTtf9t4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=s0uxojAUufiq/MDJshd+V9SBg0YjiuN/+QHFpWQ/K0831fFl2nflrvbW5gshemgN6dcVcavcIdanwxtz2lSLsYSkeTP03tSO3z/N7+XvsUHt8nsGm3qKODt+JN7Y8r5cPEn5TcI2/zKmTqCM1V0B8HxlGP8vw7nNEqYcppgYhz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P2Aa3/GD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P2Aa3/GD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A97E1F000FF;
	Thu,  1 Oct 2026 17:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790877194;
	bh=MsJyXNc8NItfY+T4WsuDMbDTI5sWTktPwy3b47Dtcz8=;
	h=Date:From:To:Cc:Subject;
	b=P2Aa3/GDrv3VxJB6o9Y5kXmp98k/qy+9Rwz650Jdf67sKS5K6aFJgDGkdhh1wx7Om
	 wETQSZeqUgdbu9mq2tH8aiiwLLvI1XJR8i/69nHZryzhUUPlCEt7Qzp08KK5oBKSbL
	 hV5jaGbPoX89kJ9mgvMohGOdFXpmDBcWP2zdOHV+q9gevFcqJgIL1wTpCiiEu7hFIE
	 QIlSUNFBJmW/2JwihdH53/1pVM1zPHTDDA6VcbV/YY8SAIXpHRT2g2f19D3hMBoLlH
	 EmbP2y7BQ8qHFYRzzImiomMGy1awnSefY8+rhdFpykl3f/xkaQxXIdt8Du23bJXd8u
	 9VApin8KG0AuA==
Date: Thu, 1 Oct 2026 10:53:12 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Stian Halseth <stian@itx.no>
Subject: [GIT PULL] Crypto library fixes for v7.3-rc6
Message-ID: <20261001175312.GA1709@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 93f51579e7df248780214094418f205253383cc5:

  Linux 7.3-rc4 (2026-09-20 13:48:15 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-fixes-for-linus

for you to fetch changes up to 572af6872e520c7102e58362ef7cd7c2ed4342be:

  crypto: aes - Fix undesired override of some optimized AES modes (2026-09-30 08:38:06 -0700)

----------------------------------------------------------------

- Fix a performance regression in certain AES encryption modes on
  certain architectures, introduced this cycle.

- Fix a small performance regression in the x86_64 optimized AES-GCM
  code, introduced in 6.15.

----------------------------------------------------------------
Eric Biggers (1):
      crypto: aes - Fix undesired override of some optimized AES modes

Mohamad Raizudeen (1):
      crypto: x86/aes-gcm - fix always true check for last AAD segment

 arch/x86/crypto/aesni-intel_glue.c |  2 +-
 crypto/aes.c                       | 51 +++++++++++++++++++++++++++++++++++---
 2 files changed, 48 insertions(+), 5 deletions(-)
