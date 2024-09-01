Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5377D2F28;
	Sun,  1 Sep 2024 06:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725171227; cv=none; b=uYwQCvecv2TutXF+e4U4bpH/xdMnLzh8rWK9+svXYhmW5R/UNuixCnMXMUPr03r93FkO3F4Uwwl0bimiuxq0nRO/hTzPJdPZMdfmdItI4BkiUfq1DQyhinIgyinJQ3yyNPbXoOByIzUuLriM5f5JDofDarhwkz8KZqYBsT0klYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725171227; c=relaxed/simple;
	bh=CzldQ8R74KRGEZMr+wtIlJ54mQi4+DTTVEIXhU8MinY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XF/otv3GAsTreob8cPbrB3ARnzD+TnhtWrQu7KAbJh461B8Mof4bD7+29ROnudtoRQMVhLqyfmg0huK5YV8KVDkqIIOlZB068VHzOr2eMdm2ydKrbcstJo6PEgEDNInFysmvdFOxSwVh2LC+tzEuNEKTj0DGu4gu2/b10xuLGcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Received: from stargazer.. (unknown [IPv6:240e:358:11b0:f100:dc73:854d:832e:2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 819CA1A3FE1;
	Sun,  1 Sep 2024 02:13:39 -0400 (EDT)
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>
Cc: Xi Ruoyao <xry111@xry111.site>,
	linux-crypto@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v6 0/3] LoongArch: Implement getrandom() in vDSO
Date: Sun,  1 Sep 2024 14:13:09 +0800
Message-ID: <20240901061315.15693-1-xry111@xry111.site>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement stack-less ChaCha20 and wire it with the generic vDSO
getrandom code.  It passes vdso_test_chacha test, and the
vdso_test_getrandom results:

bench-single:

   vdso: 25000000 times in 0.527882568 seconds
   libc: 25000000 times in 6.963153452 seconds
syscall: 25000000 times in 6.980286094 seconds

bench-multi:

   vdso: 25000000 x 256 times in 29.405172862 seconds
   libc: 25000000 x 256 times in 355.692605551 seconds
   syscall: 25000000 x 256 times in 338.481559154 seconds

bench-single in an unshared time namespace:

   vdso: 25000000 times in 0.528282411 seconds
   libc: 25000000 times in 6.966410240 seconds
syscall: 25000000 times in 6.976614579 seconds

Cc: linux-crypto@vger.kernel.org
Cc: loongarch@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Cc: Jinyang He <hejinyang@loongson.cn>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:	Thomas Gleixner <tglx@linutronix.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Arnd Bergmann <arnd@arndb.de>

[v5]->v6:
- Rebase onto crng/random.git.
- Separate selftest patch from the implementation patch again (both I
  and Huacai perfer this way).
- Add a patch to provide a __vdso_getrandom prototype shared by all
  ports, similar to the __vdso_gettimeofday prototype added by Arnd in
  commit 42874e4eb35b ("arch: vdso: consolidate gettime prototypes").
- Stop breaking lines at 80 characters for C code.
- In vdso.lds.S and Makefile, keep sigreturn the last in the lists.

[v4]->v5:
- Rebase onto crng/random.git:
  - Remove two selftest patches.
  - Remove __arch_chacha20_blocks_nostack forward declaration.
- Squash the remaining selftest patch into the vDSO getrandom
  implementation patch.
- Remove ifdef CONFIG_VDSO_GETRANDOM and $(CONFIG_VDSO_GETRANDOM) as
  they are always true in arch/loongarch.
- Remove asm-offsets.c change which has been already unneeded in v4.
- Add comment about rematerializing the constant in the assembly code.
- Add prototype for __vdso_getrandom to silence a -Wmissing-prototype
  warning.

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

[v5]:https://lore.kernel.org/all/20240829125656.19017-1-xry111@xry111.site/
[v4]:https://lore.kernel.org/all/20240827132018.88854-1-xry111@xry111.site/
[v3]:https://lore.kernel.org/all/20240816110717.10249-1-xry111@xry111.site/
[v2]:https://lore.kernel.org/all/20240815133357.35829-1-xry111@xry111.site/

Xi Ruoyao (3):
  arch: vDSO: Add a __vdso_getrandom prototype for all architectures
  LoongArch: vDSO: Wire up getrandom() vDSO implementation
  selftests/vDSO: Enable vdso getrandom tests for LoongArch

 arch/loongarch/Kconfig                      |   1 +
 arch/loongarch/include/asm/vdso/getrandom.h |  38 +++
 arch/loongarch/include/asm/vdso/vdso.h      |   6 +
 arch/loongarch/include/asm/vdso/vsyscall.h  |   8 +
 arch/loongarch/kernel/vdso.c                |   1 +
 arch/loongarch/vdso/Makefile                |   7 +-
 arch/loongarch/vdso/vdso.lds.S              |   1 +
 arch/loongarch/vdso/vgetrandom-chacha.S     | 242 ++++++++++++++++++++
 arch/loongarch/vdso/vgetrandom.c            |  10 +
 arch/x86/entry/vdso/vgetrandom.c            |   2 -
 include/vdso/getrandom.h                    |   5 +
 tools/arch/loongarch/vdso                   |   1 +
 tools/testing/selftests/vDSO/Makefile       |   4 +-
 13 files changed, 321 insertions(+), 5 deletions(-)
 create mode 100644 arch/loongarch/include/asm/vdso/getrandom.h
 create mode 100644 arch/loongarch/vdso/vgetrandom-chacha.S
 create mode 100644 arch/loongarch/vdso/vgetrandom.c
 create mode 120000 tools/arch/loongarch/vdso


base-commit: 0dfed8092247b5e179f52d27b93533bce3eaf5ba
-- 
2.46.0

