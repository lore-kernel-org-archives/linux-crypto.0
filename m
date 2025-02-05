Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2C52F43;
	Wed,  5 Feb 2025 00:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738716928; cv=none; b=Q+MSyojqBWe4VsOAaaGOr72maeaJjOcv4NxsQ+oCokUsGhlQ86vUKYqYc/bUiDRIiRy9EoxB6HOfNXvfwxIZF89QPiVowtK9xLNwIgyZKt2ekar3fjTTJJ8GOosDXYa76rhtw1HIUq/XMC5jKS2VN+cF2eDukEczaSkfNXzd/cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738716928; c=relaxed/simple;
	bh=iabXW1wLoNee5sMeVGMrB49SjnTr7CzOkV8BByU8jwM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vtq23xHIAOTwDoh2e8ZMK/XzS79O3TXIW0O5E3zhaBK/Wka7UolvTw+opAGUerItHaeI8PlI36StlwfL5/FSq1snzCZ8W+ENXpaiYRkY6PLae1P8LcXCICL3INhGgo7PJCi2EIJpMRn3+cgraardsSwyipkN519Uu+R5NcRPQAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nc1L12to; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nc1L12to"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F067DC4CEDF;
	Wed,  5 Feb 2025 00:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738716928;
	bh=iabXW1wLoNee5sMeVGMrB49SjnTr7CzOkV8BByU8jwM=;
	h=From:To:Cc:Subject:Date:From;
	b=nc1L12topO6mgtTidVKnoY2HKVjW8zN36xYeTyJsUQayVFbXHNN+6ML0uVPSV0YfE
	 qDZRv1WH9NSJn5kv4GZeGDiH5nbFprHeh/Vd4+LkiNygZrJYZ9FP6Y9Mb2rK2wV+yt
	 0x9Anhi40fWNGYiB4oS8bBpaljMCg9Uyu2XQ3JgaXtJ88g2xjNHtV6nmMGvIsgDNER
	 +PWkbtTv40kWM6UFdDjdZ7EcNO+yhj951qhjZIqarMjP85WOnPKi8i5J9ycJVBVvDE
	 VYp9MNYhwzpvrQzE88Sd2gY6RDPnGWIsOkeFeTopRAv1RqvL2+R5oyLWS/VvL5i1ze
	 0ycdi64oAv8LQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 0/5] A few more CRC32 library cleanups
Date: Tue,  4 Feb 2025 16:53:58 -0800
Message-ID: <20250205005403.136082-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series makes the CRC32 library functions have consistent
prototypes, and it makes the Castagnoli CRC32 be consistently called
simply crc32c instead of a mix of crc32c, crc32c_le, and __crc32c_le.

Eric Biggers (5):
  lib/crc32: use void pointer for data
  lib/crc32: don't bother with pure and const function attributes
  lib/crc32: standardize on crc32c() name for Castagnoli CRC32
  lib/crc32: rename __crc32c_le_combine() to crc32c_combine()
  lib/crc32: remove "_le" from crc32c base and arch functions

 arch/arm/lib/crc32-glue.c                     | 12 ++---
 arch/arm64/lib/crc32-glue.c                   | 10 ++--
 arch/loongarch/lib/crc32-loongarch.c          |  6 +--
 arch/mips/lib/crc32-mips.c                    |  6 +--
 arch/powerpc/lib/crc32-glue.c                 | 10 ++--
 arch/riscv/lib/crc32-riscv.c                  | 17 +++---
 arch/s390/lib/crc32-glue.c                    |  2 +-
 arch/sparc/lib/crc32_glue.c                   | 10 ++--
 arch/x86/lib/crc32-glue.c                     |  6 +--
 crypto/crc32c_generic.c                       |  8 +--
 drivers/crypto/stm32/stm32-crc32.c            |  2 +-
 drivers/infiniband/sw/siw/siw.h               |  4 +-
 drivers/md/raid5-cache.c                      | 31 ++++++-----
 drivers/md/raid5-ppl.c                        | 16 +++---
 .../net/ethernet/broadcom/bnx2x/bnx2x_sp.c    |  2 +-
 drivers/thunderbolt/ctl.c                     |  2 +-
 drivers/thunderbolt/eeprom.c                  |  2 +-
 include/linux/crc32.h                         | 53 +++++++++----------
 include/linux/crc32c.h                        |  8 ---
 include/net/sctp/checksum.h                   |  7 +--
 lib/crc32.c                                   | 21 ++++----
 lib/crc_kunit.c                               |  2 +-
 sound/soc/codecs/aw88395/aw88395_device.c     |  2 +-
 23 files changed, 111 insertions(+), 128 deletions(-)


base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
2.48.1

