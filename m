Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E493A15D5D9
	for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 13:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723727925; cv=none; b=DKkdlXpnrxsRhqS0AsFa4WqHUbOnfkehalB54oR0XyPKY/64lOMnuAVHmjNSz7aJax0LoB6qgaJ4SVjKmu5xttRaAs217x8Ga3ogJX5y9U0iPId9NyHoSwrgHrCEqGVewGtiGdzL3ixc6glYsYX5KmwDCaMB6O2p0ksKesN2X28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723727925; c=relaxed/simple;
	bh=4hzUrzKMfzOotKIdtZ/WcRr8hPE8sUsUUimVai+Neao=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VD141GtIHrUmoJhb9pCFrMrVFq4afl3BjYAQjjIC15NkGezojupLy6y8JDb40B/jh+ikbyY2XBTKt+daJlhzTmVXtzHeRfz7NdfdZoVUYUn0IjdeLkVHDoS+uC9lpZuR8Mk+XbayncVtxkugRaPVFHbpOn626pY7EZPTTqP2+M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=BoU3hHlu; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="BoU3hHlu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1723727922;
	bh=4hzUrzKMfzOotKIdtZ/WcRr8hPE8sUsUUimVai+Neao=;
	h=From:To:Cc:Subject:Date:From;
	b=BoU3hHluVt0EeMMkZd7TORKax3TxUo7uOcm14ZjGiO6Vhuzf1uLc9s1Sxxv2zkOQP
	 7cNeKSSJ15UgmaxQY3auoAuCHFI4qJL+JmqovaJTS1cadqq2lIoKnXAfa2iBOL9PvD
	 ak3+eG2oGJ20IRyotUDJlsIjzbMQugHWabZXjxts=
Received: from stargazer.. (unknown [IPv6:240e:456:1030:181:abd4:6e7f:e826:ac0f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id BFC6E66F26;
	Thu, 15 Aug 2024 09:18:34 -0400 (EDT)
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
Subject: [PATCH 0/2] LoongArch: Implement getrandom() in vDSO
Date: Thu, 15 Aug 2024 21:17:57 +0800
Message-ID: <20240815131759.33302-1-xry111@xry111.site>
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

Without LSX it's not easy to implement ChaCha20 without stack.  So the
current implementation just falls back to a getrandom() syscall if LSX
is unavailable.  In the 1st patch the existing alternative runtime
patching mechanism is expanded to cover vDSO in the first patch, so we
don't need to invoke cpucfg for each vDSO getrandom() call.

Then in the 2nd patch stack-less ChaCha20 is implemented with LSX.  The
code is basically a direct translate from the x86 SSE2 implementation.
One annoying thing here is the compiler generates a memset() call for a
"large" struct initialization in a cold path and there seems no way to
prevent it.  So a naive memset implementation is copied from the kernel
code into vDSO.

The implementation is tested with the kernel selftests added by the last
patch in [1].  I had to make some adjustments to make it work on
LoongArch (see [2], I've not submitted the changes as at now because I'm
unsure about the KHDR_INCLUDES addition).  The vdso_test_getrandom
bench-single result:

       vdso: 25000000 times in 0.631345201 seconds
       libc: 25000000 times in 6.953121083 seconds
    syscall: 25000000 times in 6.992112386 seconds

The vdso_test_getrandom bench-multi result:

       vdso: 25000000 x 256 times in 29.558284986 seconds
       libc: 25000000 x 256 times in 356.633930139 seconds
       syscall: 25000000 x 256 times in 334.885555338 seconds

[1]:https://lore.kernel.org/all/20240712014009.281406-1-Jason@zx2c4.com/
[2]:https://github.com/xry111/linux/commits/xry111/la-vdso/

Cc: linux-crypto@vger.kernel.org
Cc: loongarch@lists.linux.dev
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Jinyang He <hejinyang@loongson.cn>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Arnd Bergmann <arnd@arndb.de>

Xi Ruoyao (2):
  LoongArch: Perform alternative runtime patching on vDSO
  LoongArch: vDSO: Wire up getrandom() vDSO implementation

 arch/loongarch/Kconfig                      |   1 +
 arch/loongarch/include/asm/vdso/getrandom.h |  47 ++++++
 arch/loongarch/include/asm/vdso/vdso.h      |   8 +
 arch/loongarch/kernel/asm-offsets.c         |  10 ++
 arch/loongarch/kernel/vdso.c                |  14 +-
 arch/loongarch/vdso/Makefile                |   2 +
 arch/loongarch/vdso/memset.S                |  24 +++
 arch/loongarch/vdso/vdso.lds.S              |   7 +
 arch/loongarch/vdso/vgetrandom-alt.S        |  19 +++
 arch/loongarch/vdso/vgetrandom-chacha.S     | 162 ++++++++++++++++++++
 arch/loongarch/vdso/vgetrandom.c            |  16 ++
 11 files changed, 309 insertions(+), 1 deletion(-)
 create mode 100644 arch/loongarch/include/asm/vdso/getrandom.h
 create mode 100644 arch/loongarch/vdso/memset.S
 create mode 100644 arch/loongarch/vdso/vgetrandom-alt.S
 create mode 100644 arch/loongarch/vdso/vgetrandom-chacha.S
 create mode 100644 arch/loongarch/vdso/vgetrandom.c

-- 
2.46.0

