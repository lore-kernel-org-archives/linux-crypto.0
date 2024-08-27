Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C290D1BFE02
	for <linux-crypto@vger.kernel.org>; Tue, 27 Aug 2024 13:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724764831; cv=none; b=UOvpfth+vIDt8neSVu4EfJTO4u4Gwf+nejn1aDXkfgKcas8UFCeNYv8NjShe1zVTAhyQQtSYrzZx+j1FSX65WSKgCl7ZK4BMWBvJYqeDzd86DaHlxHNnqdFYhGGjrf2JTL9xwnS9SPciLvr/5kY5HaSXcAuqMQNYCpoHTKGdZSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724764831; c=relaxed/simple;
	bh=kl5svSFt0DG8jXH2eANoCk8le4jOPRaPOlMSXB0x8fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jwE4OgC9LPGGy4LWgH1HZnxPW1pYxP4M7f0KhwTDoh8DzkRaDQ8tc2tkYbOnzEkE2fEGgfyVKONRJISlADGhp/aqPKDNMNnsV5LALGinuIFr76e5NOGyCS0klwfTBYr5INHCd/gv2drm4Sxspztg2KOS9DDpMvhMvXECusaFle4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=Cdkr5ESv; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="Cdkr5ESv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1724764828;
	bh=kl5svSFt0DG8jXH2eANoCk8le4jOPRaPOlMSXB0x8fQ=;
	h=From:To:Cc:Subject:Date:From;
	b=Cdkr5ESvobApPDLdXtgmxRMmgRaGxDmJ4tqOIrVATNRkaUXYGkKTlBSDt/R2VDdQq
	 poSrPFfohoF+TxzFU7r0zvheaM5JA+263q37/Z61hP+DSBYEXk2s5VzztR9AKcVdAM
	 pNh6RjCl3VGcJiHqWuyUfU4pF5ulXCbs0TQMLLIs=
Received: from stargazer.. (unknown [113.200.174.85])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id C90A066F26;
	Tue, 27 Aug 2024 09:20:24 -0400 (EDT)
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
Subject: [PATCH v4 0/4] LoongArch: Implement getrandom() in vDSO
Date: Tue, 27 Aug 2024 21:20:13 +0800
Message-ID: <20240827132018.88854-1-xry111@xry111.site>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For the rationale to implement getrandom() in vDSO see [1].

The vDSO getrandom() needs a stack-less ChaCha20 implementation, so we
need to add architecture-specific code and wire it up with the generic
code.

The implementation is tested with the kernel vDSO selftests, which need
to be adapted as well.  The selftest changes are also included in the
series.

The vdso_test_getrandom bench-single result:

       vdso: 25000000 times in 0.501461533 seconds
       libc: 25000000 times in 6.975149458 seconds
    syscall: 25000000 times in 6.985865529 seconds

The vdso_test_getrandom bench-multi result:

       vdso: 25000000 x 256 times in 28.688809414 seconds
       libc: 25000000 x 256 times in 356.863400242 seconds
       syscall: 25000000 x 256 times in 338.562183570 seconds

[1]:https://lore.kernel.org/all/20240712014009.281406-1-Jason@zx2c4.com/

Cc: linux-crypto@vger.kernel.org
Cc: loongarch@lists.linux.dev
Cc: Jinyang He <hejinyang@loongson.cn>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Arnd Bergmann <arnd@arndb.de>

[v3]->v4:
- Remove LSX implementation, which isn't much faster than the generic
  implementaion.
- Rebase onto crng/random.git:
  - Define __arch_get_k_vdso_rng_data instead of using inline asm to
    provide the _vdso_rng_data symbol in a magic way.
  - Remove memset.S.
  - Use c-getrandom-y to easily include the generic C code.
  - The benchmark results seem better than v3, maybe related to the TLS
    refactoring in random.git.
- Add patches for selftests.

[v2]->v3:
- Add a generic LoongArch implementation for which LSX isn't needed.

v1->v2:
- Properly send the series to the list.

[v3]:https://lore.kernel.org/all/20240816110717.10249-1-xry111@xry111.site/
[v2]:https://lore.kernel.org/all/20240815133357.35829-1-xry111@xry111.site/

Xi Ruoyao (4):
  LoongArch: vDSO: Wire up getrandom() vDSO implementation
  selftests/vDSO: Add --cflags for pkg-config command querying libsodium
  selftests/vDSO: Use KHDR_INCLUDES to locate UAPI headers for
    vdso_test_getrandom
  selftests/vDSO: Enable vdso getrandom tests for LoongArch

 arch/loongarch/Kconfig                      |   1 +
 arch/loongarch/include/asm/vdso/getrandom.h |  47 ++++
 arch/loongarch/include/asm/vdso/vdso.h      |   8 +
 arch/loongarch/include/asm/vdso/vsyscall.h  |  10 +
 arch/loongarch/kernel/asm-offsets.c         |  10 +
 arch/loongarch/kernel/vdso.c                |   2 +
 arch/loongarch/vdso/Makefile                |   6 +
 arch/loongarch/vdso/vdso.lds.S              |   1 +
 arch/loongarch/vdso/vgetrandom-chacha.S     | 239 ++++++++++++++++++++
 arch/loongarch/vdso/vgetrandom.c            |  12 +
 tools/arch/loongarch/vdso                   |   1 +
 tools/testing/selftests/vDSO/Makefile       |   8 +-
 12 files changed, 341 insertions(+), 4 deletions(-)
 create mode 100644 arch/loongarch/include/asm/vdso/getrandom.h
 create mode 100644 arch/loongarch/vdso/vgetrandom-chacha.S
 create mode 100644 arch/loongarch/vdso/vgetrandom.c
 create mode 120000 tools/arch/loongarch/vdso


base-commit: c64dcc01ebf2b7d5a7cb56b5c6a4b6adc2273774
-- 
2.46.0

