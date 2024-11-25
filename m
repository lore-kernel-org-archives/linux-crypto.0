Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E302500DE;
	Mon, 25 Nov 2024 04:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732507969; cv=none; b=PzaWW3gKIUiX2YdTJvaQC7OZnxnyVaGPQf3PWbrUwMt+Op3G8+IKZUWUO0Y5GkV1MFgnNSot851MM0Jn5dMJsj/TqsTTwyhaxXsGYgY+4tgNy2kB7iPuhmeQVBe8s3KXVitH/x5cXAejgfVY+VOfDbObPB3bLbgmuEgnO8MEqJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732507969; c=relaxed/simple;
	bh=UUUA1ZgwPqZlO0/3ylK8xMN9W4suSmmy4ypAl0Eeb5s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TzXy6z5/s/8fruWoGYxyCbl5iH/wHc9zG/BcwzU37LJu7ndLmFKqzF0JWhLki1cZL8CfPA/vBcL4ppMplCwUspXPDmPi90u40fEFfVc69S05GmCw9I5ERRikHYh5fwAJ4XwvYx2l7ztgqh3i8ZpegTKQS1anV0h2rOKD1TnwITI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eV592IhP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eV592IhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599AAC4CED1;
	Mon, 25 Nov 2024 04:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732507968;
	bh=UUUA1ZgwPqZlO0/3ylK8xMN9W4suSmmy4ypAl0Eeb5s=;
	h=From:To:Cc:Subject:Date:From;
	b=eV592IhPDawLL+68tcYtw9FXThWgbpRzvTOqtOMDeDKOFSzKYf9xIgSvIV0MLIeBy
	 k0XyZOrx/sGYYZMuvscXowtVT9XQQBpfpXvEOqVd5klqE5uCWYRZZvJ9//wUGKhh0Y
	 ILT09ftkrkEhX6OyxmEquzASukyhiINi3QnowQCTGXehFl0ADAYfkIgetEjCTFuWMV
	 j1fnIVfHaxnJjaiDDLCz5naTURuWM3bWiegbOtM+h9gKk0agYh9Tgw9cjSQQZg9r6H
	 Hl9w6Cmq+82pqYkzV+9UaRiBkbQbMpxIZFrpLtxA5VxIUVpOPUM9hzLq+JJL0suahW
	 2oVYvH4vfxUEA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 0/6] x86: new optimized CRC functions, with VPCLMULQDQ support
Date: Sun, 24 Nov 2024 20:11:23 -0800
Message-ID: <20241125041129.192999-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset is also available in git via:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git crc-x86-v1

This patchset applies on top of my other recent CRC patchsets
https://lore.kernel.org/r/20241103223154.136127-1-ebiggers@kernel.org/ and
https://lore.kernel.org/r/20241117002244.105200-1-ebiggers@kernel.org/ .
Consider it a preview for what may be coming next, as my priority is
getting those two other patchsets merged first.

This patchset adds a new assembly macro that expands into the body of a
CRC function for x86 for the specified number of bits, bit order, vector
length, and AVX level.  There's also a new script that generates the
constants needed by this function, given a CRC generator polynomial.

This approach allows easily wiring up an x86-optimized implementation of
any variant of CRC-8, CRC-16, CRC-32, or CRC-64, including full support
for VPCLMULQDQ.  On long messages the resulting functions are up to 4x
faster than the existing PCLMULQDQ optimized functions when they exist,
or up to 29x faster than the existing table-based functions.

This patchset starts by wiring up the new macro for crc32_le,
crc_t10dif, and crc32_be.  Later I'd also like to wire up crc64_be and
crc64_rocksoft, once the design of the library functions for those has
been fixed to be like what I'm doing for crc32* and crc_t10dif.

A similar approach of sharing code between CRC variants, and vector
lengths when applicable, should work for other architectures.  The CRC
constant generation script should be mostly reusable.

Eric Biggers (6):
  x86: move zmm exclusion list into CPU feature flag
  scripts/crc: add gen-crc-consts.py
  x86/crc: add "template" for [V]PCLMULQDQ based CRC functions
  x86/crc32: implement crc32_le using new template
  x86/crc-t10dif: implement crc_t10dif using new template
  x86/crc32: implement crc32_be using new template

 arch/x86/Kconfig                        |   2 +-
 arch/x86/crypto/aesni-intel_glue.c      |  22 +-
 arch/x86/include/asm/cpufeatures.h      |   1 +
 arch/x86/kernel/cpu/intel.c             |  22 +
 arch/x86/lib/Makefile                   |   2 +-
 arch/x86/lib/crc-pclmul-consts.h        | 148 ++++++
 arch/x86/lib/crc-pclmul-template-glue.h |  84 ++++
 arch/x86/lib/crc-pclmul-template.S      | 588 ++++++++++++++++++++++++
 arch/x86/lib/crc-t10dif-glue.c          |  22 +-
 arch/x86/lib/crc16-msb-pclmul.S         |   6 +
 arch/x86/lib/crc32-glue.c               |  38 +-
 arch/x86/lib/crc32-pclmul.S             | 220 +--------
 arch/x86/lib/crct10dif-pcl-asm_64.S     | 332 -------------
 scripts/crc/gen-crc-consts.py           | 207 +++++++++
 14 files changed, 1087 insertions(+), 607 deletions(-)
 create mode 100644 arch/x86/lib/crc-pclmul-consts.h
 create mode 100644 arch/x86/lib/crc-pclmul-template-glue.h
 create mode 100644 arch/x86/lib/crc-pclmul-template.S
 create mode 100644 arch/x86/lib/crc16-msb-pclmul.S
 delete mode 100644 arch/x86/lib/crct10dif-pcl-asm_64.S
 create mode 100755 scripts/crc/gen-crc-consts.py

-- 
2.47.0

