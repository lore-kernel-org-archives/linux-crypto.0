Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71028224898;
	Thu,  6 Feb 2025 07:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738827623; cv=none; b=SoAdQX2vjeoDccrTtZ9xkXz7ghLG+Yz9bE6BQz+Lvs+FHAkhOwpMuR3hkMKwAJUm6gPdzYX15hFjQfXtNlRQR8LV0ccpbmEWzvzhZ2boIapn96wz1r9emKsIw4jtI/kPr+VzhfquiHRAVmLR1M1BCuVv9ntd4eB701YG8m8v57k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738827623; c=relaxed/simple;
	bh=6YdgFoO0IvFlvyr/aCgXCXK5r3QyBAQdWnRvasoz10k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EmfYEqbkAoUcKNiVZcXYAhfTaCCBqtIlTqQtOA3zXX5ueXRyvt7EFRJ/BGjTWROFdY+V4wUpy8Ds0IuEsJ/dbCCHlnYrrM7NwgZJ4gkWwXnmTDXa2k9K0qs4la4PXhDRpzObdTsKtAw01sr0Y3be1NQK3+TQxyUd/epP/aX0Uxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qDhObrwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qDhObrwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98171C4CEDD;
	Thu,  6 Feb 2025 07:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738827622;
	bh=6YdgFoO0IvFlvyr/aCgXCXK5r3QyBAQdWnRvasoz10k=;
	h=From:To:Cc:Subject:Date:From;
	b=qDhObrwgTZRyTRYrnnZJPbErZEx7jZgRxcddnixeLjwlBlnyGDLZqJzInHKrX9LLH
	 nOpaspFGJ3X+K6YnM4KHPhRv3VmF7F8Ux90PHDLA7vUPUAlv4t69USrVADBgrTBv52
	 g6UENT4Oj7ve+Ud9L7XxRzgP3PqlnitFvA19KESNyBfpFtmzDdZWkr10dOVbNFb0Go
	 AGpm8UOIZdlnT7AHygFXqL5ojBnb5YA0OLzKUKW4zvAxFsPEN/oexDfRCb/x9T6h8R
	 o1Lmvv1qEO5fs1fEMAgXdkrq1KKE2GRQGdbcm0W7TRl/WGEBPlyH3hBDvLsi/lKzLv
	 TABpGGBmg60aQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	linux-block@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 0/6] x86 CRC optimizations
Date: Wed,  5 Feb 2025 23:39:42 -0800
Message-ID: <20250206073948.181792-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset applies to the crc tree and is also available at:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git crc-x86-v3

This series replaces the existing x86 PCLMULQDQ optimized CRC code with
new code that is shared among the different CRC variants and also adds
VPCLMULQDQ support, greatly improving performance on recent CPUs.  The
last patch wires up the same optimization to crc64_be() and crc64_nvme()
(a.k.a. the old "crc64_rocksoft") which previously were unoptimized,
improving the performance of those CRC functions by as much as 100x.
crc64_be is used by bcachefs, and crc64_nvme is used by blk-integrity.

Changed in v3:
- It's back to just the x86 patches now, since I've applied the CRC64
  library rework patches.
- Added review and ack tags.
- Made more improvements to crc-pclmul-template.S and gen-crc-consts.py,
  such as improving the comments that explain some of the steps,
  tweaking the exact choice of constants in certain cases where more
  than one is equivalent, sharing a bit more of the source code between
  lsb and msb-first CRCs, and eliminating an unnecessary instruction.

Changed in v2:
- Rebased onto upstream
- Added CRC64 library rework patches
- Capitalized YMM and ZMM
- Moved gen-crc-consts.py from scripts/crc/ to just scripts/
- Renamed crc-pclmul-template-glue.h to just crc-pclmul-template.h
- The asm functions that use longer vectors no longer tail-call the ones
  that use shorter vectors in order to handle short lengths.  Each
  function now handles all lengths >= 16 bytes directly.
- Made various other improvements to crc-pclmul-template.S and
  gen-crc-consts.py
- It's 2025 now; updated the copyright statements
- Improved commit messages
- Added ack tags

Eric Biggers (6):
  x86: move ZMM exclusion list into CPU feature flag
  scripts/gen-crc-consts: add gen-crc-consts.py
  x86/crc: add "template" for [V]PCLMULQDQ based CRC functions
  x86/crc32: implement crc32_le using new template
  x86/crc-t10dif: implement crc_t10dif using new template
  x86/crc64: implement crc64_be and crc64_nvme using new template

 MAINTAINERS                         |   1 +
 arch/x86/Kconfig                    |   3 +-
 arch/x86/crypto/aesni-intel_glue.c  |  22 +-
 arch/x86/include/asm/cpufeatures.h  |   1 +
 arch/x86/kernel/cpu/intel.c         |  22 ++
 arch/x86/lib/Makefile               |   5 +-
 arch/x86/lib/crc-pclmul-consts.h    | 195 ++++++++++
 arch/x86/lib/crc-pclmul-template.S  | 584 ++++++++++++++++++++++++++++
 arch/x86/lib/crc-pclmul-template.h  |  81 ++++
 arch/x86/lib/crc-t10dif-glue.c      |  23 +-
 arch/x86/lib/crc16-msb-pclmul.S     |   6 +
 arch/x86/lib/crc32-glue.c           |  37 +-
 arch/x86/lib/crc32-pclmul.S         | 219 +----------
 arch/x86/lib/crc64-glue.c           |  50 +++
 arch/x86/lib/crc64-pclmul.S         |   7 +
 arch/x86/lib/crct10dif-pcl-asm_64.S | 332 ----------------
 scripts/gen-crc-consts.py           | 239 ++++++++++++
 17 files changed, 1214 insertions(+), 613 deletions(-)
 create mode 100644 arch/x86/lib/crc-pclmul-consts.h
 create mode 100644 arch/x86/lib/crc-pclmul-template.S
 create mode 100644 arch/x86/lib/crc-pclmul-template.h
 create mode 100644 arch/x86/lib/crc16-msb-pclmul.S
 create mode 100644 arch/x86/lib/crc64-glue.c
 create mode 100644 arch/x86/lib/crc64-pclmul.S
 delete mode 100644 arch/x86/lib/crct10dif-pcl-asm_64.S
 create mode 100755 scripts/gen-crc-consts.py


base-commit: 5b793bbee96c666ca14db8409509abd73a3e0130
-- 
2.48.1

