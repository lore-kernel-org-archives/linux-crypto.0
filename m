Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09A425634;
	Thu, 30 Jan 2025 03:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738209293; cv=none; b=GzJOTwD7DozcIqIlhB63L9y8MA+ITFHWsgujYLim51E4B5qXfyNRaT7+NVnA/amRUbIWGHiMQo33KfDRiC8IMAaVLvaZDY5k5sEVfawfGFg9cvBNkmnf0PK6yVjRZvSFyFKB8eRWXMSYxZGZ8GIhaZ6K267qvl8Xya7q3Te9mRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738209293; c=relaxed/simple;
	bh=zb14REqSnK9mUMN1Rn8pCnFPl+DRVjCVkxPBmXkakQk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YPoT7k63LVhfWYXfcwZHabCF3I5G2rU1P/wzuJixIRDaeeX532sVn4SuZy5TpxZF88dEJGg97Gsg5G8mNBTzuJsZb1sWrB/gBccConT7lD+2aG+7FFvIeImGYiouS+4A/OEJU9IPL2tFlM5PbiLxLfBnju/vWUpRxnLposIL60U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q4L2lXGi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q4L2lXGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EE5C4CED2;
	Thu, 30 Jan 2025 03:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738209292;
	bh=zb14REqSnK9mUMN1Rn8pCnFPl+DRVjCVkxPBmXkakQk=;
	h=From:To:Cc:Subject:Date:From;
	b=q4L2lXGiP40VBAqvFDal9CBlJXqFUxUCuqn8mo825Avsag+WRT4s2He9FMPUi0r8E
	 3jup90FqvZuKsU0VGvxb0hPY6fAvnbCaaByTobEADZlFsh9K171vyWgepd3/ep1Y0x
	 EhEuT3rpSzbCQpOg7IhJmasKLX4wVkc87IfRItQE2osMHP0yScNEwr8GK+VL58iv55
	 3wZ/ECLggLkvVaY5+hWa9xVpLYcoJq2hsW+5XfOWWuzogZBAjf/Xx11AE9NHQYItRG
	 uyOV5bqn7nHy/NfqhNBy24lg2UFFB/JiDZ/5Y3NUxXi4X8jJ/urAKXvxVCVGK9POk/
	 RY0nkT2GvN4lQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	linux-block@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 00/11] CRC64 library rework and x86 CRC optimization
Date: Wed, 29 Jan 2025 19:51:19 -0800
Message-ID: <20250130035130.180676-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset applies to commit 72deda0abee6e7 and is also available at:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git crc-x86-v2

This is the next major set of CRC library improvements, targeting 6.15.

Patches 1-5 rework the CRC64 library along the lines of what I did for
CRC32 and CRC-T10DIF in 6.14.  They add direct support for
architecture-specific optimizations, fix the naming of the NVME CRC64
variant, and eliminate a pointless use of the crypto API.

Patches 6-10 replace the existing x86 PCLMULQDQ optimized CRC code with
new code that is shared among the different CRC variants and also adds
VPCLMULQDQ support, greatly improving performance on recent CPUs.
Patch 11 wires up the same optimization to crc64_be() and crc64_nvme()
(a.k.a. the old "crc64_rocksoft") which previously were unoptimized,
improving the performance of those CRC functions by as much as 100x.
crc64_be is used by bcachefs, and crc64_nvme is used by blk-integrity.

Eric Biggers (11):
  lib/crc64-rocksoft: stop wrapping the crypto API
  crypto: crc64-rocksoft - remove from crypto API
  lib/crc64: rename CRC64-Rocksoft to CRC64-NVME
  lib/crc_kunit.c: add test and benchmark for CRC64-NVME
  lib/crc64: add support for arch-optimized implementations
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
 arch/x86/lib/crc-pclmul-template.S  | 578 ++++++++++++++++++++++++++++
 arch/x86/lib/crc-pclmul-template.h  |  81 ++++
 arch/x86/lib/crc-t10dif-glue.c      |  23 +-
 arch/x86/lib/crc16-msb-pclmul.S     |   6 +
 arch/x86/lib/crc32-glue.c           |  37 +-
 arch/x86/lib/crc32-pclmul.S         | 219 +----------
 arch/x86/lib/crc64-glue.c           |  50 +++
 arch/x86/lib/crc64-pclmul.S         |   7 +
 arch/x86/lib/crct10dif-pcl-asm_64.S | 332 ----------------
 block/Kconfig                       |   2 +-
 block/t10-pi.c                      |   2 +-
 crypto/Kconfig                      |  11 -
 crypto/Makefile                     |   1 -
 crypto/crc64_rocksoft_generic.c     |  89 -----
 crypto/testmgr.c                    |   7 -
 crypto/testmgr.h                    |  12 -
 include/linux/crc64.h               |  38 +-
 lib/Kconfig                         |  16 +-
 lib/Makefile                        |   1 -
 lib/crc64-rocksoft.c                | 126 ------
 lib/crc64.c                         |  49 +--
 lib/crc_kunit.c                     |  30 +-
 lib/gen_crc64table.c                |  10 +-
 scripts/gen-crc-consts.py           | 214 ++++++++++
 31 files changed, 1270 insertions(+), 920 deletions(-)
 create mode 100644 arch/x86/lib/crc-pclmul-consts.h
 create mode 100644 arch/x86/lib/crc-pclmul-template.S
 create mode 100644 arch/x86/lib/crc-pclmul-template.h
 create mode 100644 arch/x86/lib/crc16-msb-pclmul.S
 create mode 100644 arch/x86/lib/crc64-glue.c
 create mode 100644 arch/x86/lib/crc64-pclmul.S
 delete mode 100644 arch/x86/lib/crct10dif-pcl-asm_64.S
 delete mode 100644 crypto/crc64_rocksoft_generic.c
 delete mode 100644 lib/crc64-rocksoft.c
 create mode 100755 scripts/gen-crc-consts.py


base-commit: 72deda0abee6e705ae71a93f69f55e33be5bca5c
-- 
2.48.1

