Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D428917BEB5
	for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 11:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723806464; cv=none; b=YKeCmLW1NDKk3aWsFr7hs7JqSdayh8PTO0ZwTruLE3ePm20aVvgRCLsFB/yAJTXBF/8RvYB+RVuGoUkDqOwCF6kwoYeyJ+hgAk0AmreF2F8TroENZIRG9XOX6dWUK/dNQ97yTZZv1ewxSIrSo0Dfq3LuISN83amZHI/51xj71L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723806464; c=relaxed/simple;
	bh=Ist7kymIdrBgHBhzaycHtnyoW3xAaoZVWRQN5c2CX74=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fsg+UGNSBW2vysloN8vn+hnltWRALe/MGxkFSQL3tyR2287wJfaUpKEJ8JU2BXXY+xJtnxBkqrwhWnlJWWP5yZlPf0dO/glqE/vBx9t2SRCXK+5TnHZcW7gKzsYU+Q/HdZtHv/URrcunOU1elU89F0ix0+xxvoQvux8V5dd7syg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=Ajym5f+P; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="Ajym5f+P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1723806455;
	bh=Ist7kymIdrBgHBhzaycHtnyoW3xAaoZVWRQN5c2CX74=;
	h=From:To:Cc:Subject:Date:From;
	b=Ajym5f+PAXP5cuYUitQsvO2qTV+f6ASVUqJpfVZxAWzSMt96fy+n9H53cnYVwjgWy
	 pbFyksORbd/pb+kAV2mIBQWZzh6CtKiDSUgAPd83JPTG4iCiufcAl/A5uDkWq9erlp
	 1Z/7Y/pn6TVIwi8tG8xLHiamErtsZjMrsWUP9UgQ=
Received: from stargazer.. (unknown [IPv6:240e:457:1000:1603:4ab7:c07d:7ab1:44b2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id E085C66F26;
	Fri, 16 Aug 2024 07:07:28 -0400 (EDT)
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>
Cc: Xi Ruoyao <xry111@xry111.site>,
	linux-crypto@vger.kernel.org,
	loongarch@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Arnd Bergmann <arnd@arndb.de>
Subject: 
Date: Fri, 16 Aug 2024 19:07:13 +0800
Message-ID: <20240816110717.10249-1-xry111@xry111.site>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Subject: [PATCH v3 0/2] LoongArch: Implement getrandom() in vDSO

For the rationale to implement getrandom() in vDSO see [1].

The vDSO getrandom() needs a stack-less ChaCha20 implementation, so we
need to add architecture-specific code and wire it up with the generic
code.  Both generic LoongArch implementation and Loongson SIMD eXtension
based implementation are added.  To dispatch them at runtime without
invoking cpucfg on each call, the alternative runtime patching mechanism
is extended to cover the vDSO.

The implementation is tested with the kernel selftests added by the last
patch in [1].  I had to make some adjustments to make it work on
LoongArch (see [2], I've not submitted the changes as at now because I'm
unsure about the KHDR_INCLUDES addition).  The vdso_test_getrandom
bench-single result:

       vdso: 25000000 times in 0.647855257 seconds (generic)
       vdso: 25000000 times in 0.601068605 seconds (LSX)
       libc: 25000000 times in 6.948168864 seconds
    syscall: 25000000 times in 6.990265548 seconds

The vdso_test_getrandom bench-multi result:

       vdso: 25000000 x 256 times in 35.322187834 seconds (generic)
       vdso: 25000000 x 256 times in 29.183885426 seconds (LSX)
       libc: 25000000 x 256 times in 356.628428409 seconds
       syscall: 25000000 x 256 times in 334.764602866 seconds

[1]:https://lore.kernel.org/all/20240712014009.281406-1-Jason@zx2c4.com/
[2]:https://github.com/xry111/linux/commits/xry111/la-vdso-v3/

[v2]->v3:
- Add a generic LoongArch implementation for which LSX isn't needed.

v1->v2:
- Properly send the series to the list.

[v2]:https://lore.kernel.org/all/20240815133357.35829-1-xry111@xry111.site/

Xi Ruoyao (3):
  LoongArch: vDSO: Wire up getrandom() vDSO implementation
  LoongArch: Perform alternative runtime patching on vDSO
  LoongArch: vDSO: Add LSX implementation of vDSO getrandom()

 arch/loongarch/Kconfig                      |   1 +
 arch/loongarch/include/asm/vdso/getrandom.h |  47 ++++
 arch/loongarch/include/asm/vdso/vdso.h      |   8 +
 arch/loongarch/kernel/asm-offsets.c         |  10 +
 arch/loongarch/kernel/vdso.c                |  14 +-
 arch/loongarch/vdso/Makefile                |   6 +
 arch/loongarch/vdso/memset.S                |  24 ++
 arch/loongarch/vdso/vdso.lds.S              |   7 +
 arch/loongarch/vdso/vgetrandom-chacha-lsx.S | 162 +++++++++++++
 arch/loongarch/vdso/vgetrandom-chacha.S     | 252 ++++++++++++++++++++
 arch/loongarch/vdso/vgetrandom.c            |  19 ++
 11 files changed, 549 insertions(+), 1 deletion(-)
 create mode 100644 arch/loongarch/include/asm/vdso/getrandom.h
 create mode 100644 arch/loongarch/vdso/memset.S
 create mode 100644 arch/loongarch/vdso/vgetrandom-chacha-lsx.S
 create mode 100644 arch/loongarch/vdso/vgetrandom-chacha.S
 create mode 100644 arch/loongarch/vdso/vgetrandom.c

-- 
2.46.0

