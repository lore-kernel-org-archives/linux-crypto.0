Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202B01E8332;
	Sun, 12 Apr 2026 00:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775953501; cv=none; b=LJDQa0e34nT5AuiOn40j1AZAvJ0+vjvQHcdOFJwwiz8UBIMJmcxg0p3qA6Z85Auce68dsdV046Fh9UnXkDAuJ8Q+gfLV2d75zH1fY2vCjkesx3N27bLdX93kb1bRA9qixYV+pRMhBQl1B0wIXpAjLs+HRP244gt2elYCYD9QSvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775953501; c=relaxed/simple;
	bh=wWhlmhjjl4CB0h9vyF/dH5qF8wuNI73erHpwPmrCbpM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tigzgJ958eJKXFLUY8f3L8XcJ475nphn3GwnxUc/yhLrFfsF0AHv/6xqHxWrlF3e/xf6phttIl3DAR/+exOY7UzpaBYPkHf7QU2f9caERV/sso606fxcUzj1hNEdTwZKLbvD97ujPUgGoSsoBDgtF3JTfwE5yTAm7QBIHdkytWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F/qg9T/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F/qg9T/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8FEC116C6;
	Sun, 12 Apr 2026 00:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775953500;
	bh=wWhlmhjjl4CB0h9vyF/dH5qF8wuNI73erHpwPmrCbpM=;
	h=Date:From:To:Cc:Subject:From;
	b=F/qg9T/UcUU6fpSAXbNPCUs9go6DcyZRtnCuBWsyv7BC+MocautWpjWobw07b+45J
	 EjBrrdD/3h8XbkfK5SC6tCqmtfHt9TXXaCDokOH3RiZWU8zH3u83R+Fq58hDAAICCd
	 H+Yq3SeVS9p4BLEc/hATIziNvOqSUIfkzRRO9dhqICC/3vKEPKb/L+kBOkjQTjojfT
	 U3zpZiU5729e3/KWV5cz4we82GOhcd+BIj3oog1W4qQH8N7DRgEMlANHWzWr4UKJgO
	 kj5F5CmyAZX+ymYhFRw++D11kcTX1ZYW10ogOLy6ZqySDbkJzj7gc/HLhHgo4nGqKt
	 tuYQYElxYyQRg==
Date: Sat, 11 Apr 2026 17:23:43 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Demian Shulhan <demyansh@gmail.com>
Subject: [GIT PULL] CRC updates for 7.1
Message-ID: <20260412002343.GB6632@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681:

  Linux 7.0-rc3 (2026-03-08 16:56:54 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus

for you to fetch changes up to 8fdef85d601db670e9c178314eedffe7bbb07e52:

  lib/crc: arm64: Simplify intrinsics implementation (2026-04-02 16:14:53 -0700)

----------------------------------------------------------------

- Several improvements related to crc_kunit, to align with the
  standard KUnit conventions and make it easier for developers and CI
  systems to run this test suite

- Add an arm64-optimized implementation of CRC64-NVME

- Remove unused code for big endian arm64

----------------------------------------------------------------
Ard Biesheuvel (3):
      lib/crc: arm64: Drop unnecessary chunking logic from crc64
      lib/crc: arm64: Use existing macros for kernel-mode FPU cflags
      lib/crc: arm64: Simplify intrinsics implementation

Demian Shulhan (1):
      lib/crc: arm64: add NEON accelerated CRC64-NVMe implementation

Eric Biggers (8):
      lib/crc: tests: Make crc_kunit test only the enabled CRC variants
      lib/crc: tests: Add CRC_ENABLE_ALL_FOR_KUNIT
      lib/crc: tests: Add a .kunitconfig file
      kunit: configs: Enable all CRC tests in all_tests.config
      crypto: crc32c - Remove more outdated usage information
      crypto: crc32c - Remove another outdated comment
      lib/crc: arm64: Drop check for CONFIG_KERNEL_MODE_NEON
      lib/crc: arm64: Assume a little-endian kernel

 crypto/crc32c.c                              | 19 +-------
 lib/crc/.kunitconfig                         |  3 ++
 lib/crc/Kconfig                              | 20 ++++++---
 lib/crc/Makefile                             |  7 ++-
 lib/crc/arm64/crc-t10dif-core.S              | 56 ++++++++++++------------
 lib/crc/arm64/crc32-core.S                   |  9 +---
 lib/crc/arm64/crc64-neon-inner.c             | 65 ++++++++++++++++++++++++++++
 lib/crc/arm64/crc64.h                        | 28 ++++++++++++
 lib/crc/tests/crc_kunit.c                    | 28 +++++++++---
 tools/testing/kunit/configs/all_tests.config |  2 +
 10 files changed, 172 insertions(+), 65 deletions(-)
 create mode 100644 lib/crc/.kunitconfig
 create mode 100644 lib/crc/arm64/crc64-neon-inner.c
 create mode 100644 lib/crc/arm64/crc64.h
