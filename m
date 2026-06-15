Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CED25776;
	Mon, 15 Jun 2026 17:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781545690; cv=none; b=dHvy+ArTS/79opTB+rHQ7y4FGix743CJ8bQfaiNtOJsU9Y03iD5J1V2mw6IiqK37Mq3OoACoEKnTglrwGfV1EfZmQn06Ftv2TqtoRyJK9sCJSRutmRt8t8w4UVqnAF6uo/PfkCzAZJ+Vu9ednJPok5nWNDozt0fXeuT+NSViq6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781545690; c=relaxed/simple;
	bh=LOW5/cZFS3D0ftqsSj0IJyqTEgbjMrfsDUjPtNdOgcw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XebO6TxTHgbHZ4KM7nj/dc0uxyQ5L6TnbayvD6ETqBBO3Tt0EEr7+UXnr5JG6QrChTSPw0GpSsWr+fmUTJSaVfaYX9znwP0NcZDiLu/+NJMEbFU3HEyMqkHmIxe0dbEfWznD4e0zA798dQfZ54ncttNwIyzvPE+VvFHjjr3o8BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f91BvxTW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f91BvxTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8331F000E9;
	Mon, 15 Jun 2026 17:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781545688;
	bh=ktoQ097mTWDtSnEGRbrmbkUtEyP+n9X+6dQfQpSj2Uc=;
	h=Date:From:To:Cc:Subject;
	b=f91BvxTWW4vbP4wROAwq0ubKzzRPfgcUf1eIuUoIBtiafesnv0Fs3SHQvjr/83yZi
	 5meui5L5dvBxmtuia4DBAqneoGYhfyWleyEC+/vz939Tg3BtjEFr9DHRQF0etp7FA+
	 g81Hucy32zYNnc1brS9KXiBtpmNaupnTQMKy5MB02cANyykr0br+n3SwLwMrASSzQV
	 d/0ExFglsuisWzYfwkuVStfKxzg19mkQsoQKaLtT+J0Hu5aKHBw4qJp6shGh3HhJ5K
	 w6JjsuRs5Z1Gl9WWZIDOHl3dO9t21j2JAwxpFjdsQ4b5cp9wYeDPZr4XzRbPfXEOFo
	 9RGeXvFUwY4Ng==
Date: Mon, 15 Jun 2026 10:48:07 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [GIT PULL] CRC updates for 7.2
Message-ID: <20260615174807.GA1831@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit e7ae89a0c97ce2b68b0983cd01eda67cf373517d:

  Linux 7.1-rc5 (2026-05-24 13:48:06 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus

for you to fetch changes up to cbe44c389ae80362e72696ac08f7c55a83f2a050:

  crypto: aegis128 - Use neon-intrinsics.h on ARM too (2026-05-28 13:14:25 -0700)

----------------------------------------------------------------

Accelerate CRC64-NVME for 32-bit ARM by refactoring the arm64 NEON
intrinsics implementation to be shared by 32-bit and 64-bit.

Also apply a similar cleanup to the 32-bit ARM NEON implementation of
xor_gen(), where it now reuses code from the 64-bit implementation.

----------------------------------------------------------------
Ard Biesheuvel (6):
      ARM: Add a neon-intrinsics.h header like on arm64
      xor/arm: Replace vectorized implementation with arm64's intrinsics
      xor/arm64: Use shared NEON intrinsics implementation from 32-bit ARM
      lib/crc: Turn NEON intrinsics crc64 implementation into common code
      lib/crc: arm: Enable arm64's NEON intrinsics implementation of crc64
      crypto: aegis128 - Use neon-intrinsics.h on ARM too

 Documentation/arch/arm/kernel_mode_neon.rst        |   4 +-
 arch/arm/include/asm/neon-intrinsics.h             |  60 +++++++++
 crypto/Makefile                                    |  10 +-
 crypto/aegis128-neon-inner.c                       |   4 +-
 lib/crc/Kconfig                                    |   1 +
 lib/crc/Makefile                                   |   9 +-
 lib/crc/arm/crc64-neon.h                           |  34 +++++
 lib/crc/arm/crc64.h                                |  36 +++++
 lib/crc/arm64/crc64-neon.h                         |  21 +++
 lib/crc/arm64/crc64.h                              |   4 +-
 lib/crc/{arm64/crc64-neon-inner.c => crc64-neon.c} |  26 +---
 lib/raid/xor/Makefile                              |  13 +-
 lib/raid/xor/arm/xor-neon.c                        |  26 ----
 lib/raid/xor/arm/xor-neon.h                        |   7 +
 lib/raid/xor/arm/xor_arch.h                        |   7 +-
 lib/raid/xor/arm64/xor-eor3.c                      | 146 +++++++++++++++++++++
 lib/raid/xor/xor-8regs.c                           |   2 -
 lib/raid/xor/{arm64 => }/xor-neon.c                | 143 +-------------------
 18 files changed, 338 insertions(+), 215 deletions(-)
 create mode 100644 arch/arm/include/asm/neon-intrinsics.h
 create mode 100644 lib/crc/arm/crc64-neon.h
 create mode 100644 lib/crc/arm/crc64.h
 create mode 100644 lib/crc/arm64/crc64-neon.h
 rename lib/crc/{arm64/crc64-neon-inner.c => crc64-neon.c} (62%)
 delete mode 100644 lib/raid/xor/arm/xor-neon.c
 create mode 100644 lib/raid/xor/arm/xor-neon.h
 create mode 100644 lib/raid/xor/arm64/xor-eor3.c
 rename lib/raid/xor/{arm64 => }/xor-neon.c (56%)
