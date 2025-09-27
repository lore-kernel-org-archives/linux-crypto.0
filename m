Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494C11FA859;
	Sat, 27 Sep 2025 19:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759002781; cv=none; b=gvulO8o8sNXPBdNDRYflPYxJQzQE7P4+TtKzEcr3Eo9ByPWMHVidI+IUTjetIyTSdJVcmsls0KkQMQOtt8g4z0NxQb/Ey2pCmNydCDZB+DHZlrcOfMlFR9229xNzqg0IfX+SDJ09q65Zxi86Kv0c6hLhS19EuT+ykPvihvWs8DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759002781; c=relaxed/simple;
	bh=eCos0g0v+ia8yCfPb3Au3oRgY4b9F0p0qfg//K2yklA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cQ62FP4uErXZa5GWr53EpYzMnr0roxH/c1d6dKztYiq6URYXAN43h+fmbUEfpazMPH4xtslray/R4+a0aaqAuzyPWbOKMFBSe5Xj6g18Rqd5xGlh10GW4PDmVRhukZ86PUoE41N2zc/q0pNdWbSQnkeAq2qJAjeSaOXKJdTP+BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XcEIghCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XcEIghCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4874DC4CEE7;
	Sat, 27 Sep 2025 19:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759002780;
	bh=eCos0g0v+ia8yCfPb3Au3oRgY4b9F0p0qfg//K2yklA=;
	h=Date:From:To:Cc:Subject:From;
	b=XcEIghCl0BVy4Bhd08GRn6zbexY3AudujSwd5EjO1NNgrdtTFcITHpsd4PsKPkmvI
	 CKJ9s9RUN6UUiKk/zImnOt6HjifOfbC1bHF5vrf8aZH/Szu2nflseINbGoLGwK8DlS
	 xclniy3nRskdHqYpcnHZekmSxGNlyRzkaoSOS9WL6Czeq46sigPPASY3zRNIbgGJRS
	 n1FdXj3qXb0vV2OcH9T9hjpEMY8rsD6Eyf6zNvyGA1rIrwW8irgpiy5YxSbVZVOB5t
	 gi3ZngKmfuazZqbl8fpcleO8szgrDVQ9Wjc3HscYXPyHGj5gsYDPvDrB/pLdpRQpvs
	 MwEB9Ip6kpRZw==
Date: Sat, 27 Sep 2025 12:52:57 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kunit-dev@googlegroups.com, Ard Biesheuvel <ardb@kernel.org>,
	Rakuram Eswaran <rakuram.e96@gmail.com>
Subject: [GIT PULL] CRC updates for 6.18
Message-ID: <20250927195257.GA9798@quark>
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

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus

for you to fetch changes up to 136d029662cdde77d3e4db5c07de655f35f0239f:

  Documentation/staging: Fix typo and incorrect citation in crc32.rst (2025-08-20 23:53:32 -0400)

----------------------------------------------------------------

Update crc_kunit to test the CRC functions in softirq and hardirq
contexts, similar to what the lib/crypto/ KUnit tests do. Move the
helper function needed to do this into a common header.

This is useful mainly to test fallback code paths for when
FPU/SIMD/vector registers are unusable.

----------------------------------------------------------------
Eric Biggers (4):
      kunit, lib/crypto: Move run_irq_test() to common header
      lib/crc: crc_kunit: Test CRC computation in interrupt contexts
      lib/crc: Use underlying functions instead of crypto_simd_usable()
      lib/crc: Drop inline from all *_mod_init_arch() functions

Rakuram Eswaran (1):
      Documentation/staging: Fix typo and incorrect citation in crc32.rst

 Documentation/staging/crc32.rst       |   4 +-
 include/kunit/run-in-irq-context.h    | 129 ++++++++++++++++++++++++++++++++++
 lib/crc/arm/crc-t10dif.h              |   8 +--
 lib/crc/arm/crc32.h                   |   8 +--
 lib/crc/arm64/crc-t10dif.h            |   8 +--
 lib/crc/arm64/crc32.h                 |  11 +--
 lib/crc/loongarch/crc32.h             |   2 +-
 lib/crc/mips/crc32.h                  |   2 +-
 lib/crc/powerpc/crc-t10dif.h          |   7 +-
 lib/crc/powerpc/crc32.h               |   7 +-
 lib/crc/sparc/crc32.h                 |   2 +-
 lib/crc/tests/crc_kunit.c             |  62 +++++++++++++---
 lib/crc/x86/crc-pclmul-template.h     |   3 +-
 lib/crc/x86/crc-t10dif.h              |   2 +-
 lib/crc/x86/crc32.h                   |   4 +-
 lib/crc/x86/crc64.h                   |   2 +-
 lib/crypto/tests/hash-test-template.h | 123 ++------------------------------
 17 files changed, 219 insertions(+), 165 deletions(-)
 create mode 100644 include/kunit/run-in-irq-context.h
