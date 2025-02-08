Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B51A8479;
	Sat,  8 Feb 2025 02:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738982963; cv=none; b=osPKS6IcOhusuZ3g3b9IdDwvwaGz3AUWsF4OaXVgoedvEbNHmXIZTSj9+KymyCgO/v5TIOZAIpODn+2SO9AVxXe7rViPDzxPvY+NWfdqAOcJJ/Inio4lDuDjUMWkMGAv/fuhJ526a7g5clfyvzUA0E+NcUjrQJJFiwN5SXcJIiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738982963; c=relaxed/simple;
	bh=Ze1FtiaEDEbbnypfR+zfcnEH0GEhEqceBLI6T9MCSuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ci9pf+q7jBxALPQfwsTlmh7BL3H6U3n6AfztSmQdWmgwv/alNSjYReRU1/BP6r5Nbh8ZjzH+Q0ttR2Gtg1jwupFpWvCgxzzo1MExO/whKlPgdzNKxQ6tlT2MQscCHqim4mqKMSI+0OLa6rq59a2x6yFsDhQAVRFEtDLYkOnFlto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X0eDw6+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X0eDw6+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69D4C4CED1;
	Sat,  8 Feb 2025 02:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738982962;
	bh=Ze1FtiaEDEbbnypfR+zfcnEH0GEhEqceBLI6T9MCSuQ=;
	h=From:To:Cc:Subject:Date:From;
	b=X0eDw6+GLDQrwkLdWgF006RorrqEdDiMJuPCpab0HeV6LxdnkHoFkDjroPZDw2Gjr
	 n8t2558gxegUqnvU2KZei6/v0HkHkknOMsnBXV8iO7pGsrmaYqfM9GC7UCboRpsuxg
	 1tM7OqYKxNURT0um0P1cp42Z9O5+4D2eYywKuxkZrLnQJDaEZl43MwIjSq3VpQXA/I
	 nncX2DPsewca12kVvTFf1hgARnzQQX3Ey4xp5OUmZbK12Pg2Gzg3z48oiY0nvPAlOj
	 NcsjLYpyS3SQTRIKij4W0P/gNoo5LNmsdeDqWliAjsPf2MjiG0ExkXA+S8bkhXtit2
	 X9HKCIItml2xw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v2 0/6] A few more CRC32 library cleanups
Date: Fri,  7 Feb 2025 18:49:05 -0800
Message-ID: <20250208024911.14936-1-ebiggers@kernel.org>
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

This series applies to the crc tree.

Changed in v2:
- Added mips/crc32 patch to fix a build error.
- Reformatted the kerneldoc comment for crc32c_combine() and moved it to
  the correct place.

Eric Biggers (6):
  mips/crc32: remove unused enums
  lib/crc32: use void pointer for data
  lib/crc32: don't bother with pure and const function attributes
  lib/crc32: standardize on crc32c() name for Castagnoli CRC32
  lib/crc32: rename __crc32c_le_combine() to crc32c_combine()
  lib/crc32: remove "_le" from crc32c base and arch functions

 arch/arm/lib/crc32-glue.c                     | 12 ++--
 arch/arm64/lib/crc32-glue.c                   | 10 ++--
 arch/loongarch/lib/crc32-loongarch.c          |  6 +-
 arch/mips/lib/crc32-mips.c                    | 15 +----
 arch/powerpc/lib/crc32-glue.c                 | 10 ++--
 arch/riscv/lib/crc32-riscv.c                  | 17 +++---
 arch/s390/lib/crc32-glue.c                    |  2 +-
 arch/sparc/lib/crc32_glue.c                   | 10 ++--
 arch/x86/lib/crc32-glue.c                     |  6 +-
 crypto/crc32c_generic.c                       |  8 +--
 drivers/crypto/stm32/stm32-crc32.c            |  2 +-
 drivers/infiniband/sw/siw/siw.h               |  4 +-
 drivers/md/raid5-cache.c                      | 31 +++++------
 drivers/md/raid5-ppl.c                        | 16 +++---
 .../net/ethernet/broadcom/bnx2x/bnx2x_sp.c    |  2 +-
 drivers/thunderbolt/ctl.c                     |  2 +-
 drivers/thunderbolt/eeprom.c                  |  2 +-
 include/linux/crc32.h                         | 55 +++++++++----------
 include/linux/crc32c.h                        |  8 ---
 include/net/sctp/checksum.h                   |  7 +--
 lib/crc32.c                                   | 21 ++++---
 lib/crc_kunit.c                               |  2 +-
 sound/soc/codecs/aw88395/aw88395_device.c     |  2 +-
 23 files changed, 112 insertions(+), 138 deletions(-)


base-commit: 0ebb2a6a60d195071d19c34da97b4ce67f4d7086
-- 
2.48.1

