Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AAF25B69C;
	Mon, 10 Feb 2025 17:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739209561; cv=none; b=Uv5JjrQIM87ZWmeuhJhcvsV6/LJFMLP8AxBWFITN3BCEYksj/Zi60ZP3ye11zRDQzT0OAa3bMdLyrLVXV2SH92s656iHWqL6R+iD8FqCaEd6W1g+iYVcFLLucRBcwSDUEDllC6/zV+iU5PPksXjm4t9oaJMScw9QQx0id/3nTUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739209561; c=relaxed/simple;
	bh=4Tvn487GXiKnkZ519LF64Yv54vgWRGaq99W5sfCgT1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XMS/wLiTOqG7bdQGNI7C+irdVXxcYqYg5XoEhvt1C71urSF1SobolXg2qp8yqvNRz+quE/4C1EDQ26rw2F8NDVz2RdjNdqt9IgL+fC9FaKJD+wxl5nPzrjdvWCdh9tnQ3J+Am54cp5dF9CFR+0eC/QRKAy+Z3n21QUbQlpldy8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ogZLgVLk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ogZLgVLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2AFC4CED1;
	Mon, 10 Feb 2025 17:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739209560;
	bh=4Tvn487GXiKnkZ519LF64Yv54vgWRGaq99W5sfCgT1Q=;
	h=From:To:Cc:Subject:Date:From;
	b=ogZLgVLkZwJBuVh3rfR1FiXL30RcxtCmcWUwlVBlBqE7BKUxNn42gUkBoKWInQVMo
	 YagLZX8e1ubC6/5K7wRW9ju04XvORNOT5w1zuRZFVSOsl5Ut7FBbLQSdBzaaV5v1P6
	 rn6zuYZUJOrf30eSuU6w7YYa29bZYZx7JbYsXHran26c9Kl8hiQiopTHvGnb7FrGrE
	 6a73ncY1OiJHhyC0Xdeg4itRgfR7bCs/89z80+Xnp+YUuDH4NhyJqojkE3VhMjldN/
	 a7UlKDffcy4ClPQhJaEso3z1CEqnk2z2DiMxc0vMosneOj5Yx3rSH79bdzfklGPBlP
	 6RhPGa4vmAt/g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	linux-block@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v4 0/6] x86 CRC optimizations
Date: Mon, 10 Feb 2025 09:45:34 -0800
Message-ID: <20250210174540.161705-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset applies to the crc tree and is also available at:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git crc-x86-v4

This series replaces the existing x86 PCLMULQDQ optimized CRC code with
new code that is shared among the different CRC variants and also adds
VPCLMULQDQ support, greatly improving performance on recent CPUs.  The
last patch wires up the same optimization to crc64_be() and crc64_nvme()
(a.k.a. the old "crc64_rocksoft") which previously were unoptimized,
improving the performance of those CRC functions by as much as 100x.
crc64_be is used by bcachefs, and crc64_nvme is used by blk-integrity.

Changed in v4:
- More small cleanups for gen-crc-consts.py and crc-pclmul-template.S.

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
 scripts/gen-crc-consts.py           | 238 ++++++++++++
 17 files changed, 1213 insertions(+), 613 deletions(-)
 create mode 100644 arch/x86/lib/crc-pclmul-consts.h
 create mode 100644 arch/x86/lib/crc-pclmul-template.S
 create mode 100644 arch/x86/lib/crc-pclmul-template.h
 create mode 100644 arch/x86/lib/crc16-msb-pclmul.S
 create mode 100644 arch/x86/lib/crc64-glue.c
 create mode 100644 arch/x86/lib/crc64-pclmul.S
 delete mode 100644 arch/x86/lib/crct10dif-pcl-asm_64.S
 create mode 100755 scripts/gen-crc-consts.py


base-commit: 0645b245a2bd1abf1b36b570db47517e5519819c
-- 
2.48.1

