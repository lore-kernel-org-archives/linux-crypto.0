Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD771714AE
	for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 13:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728990; cv=none; b=aWhMPSoZ2l6mgMyHL/IfTZGvSrygG1JgWAJ6v6yF8P7oTEzRjD1iOHofkC7rdfluvDm/z7PJmqlt2mpXGavbIfIHRmbYfPBg72r+wZWfmw5vdGg5q4ALDiuHqfVYPl4WyakFX1NkOYNg4+6RWwBj1hNMyMD8fFmbz4/lEB3tSCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728990; c=relaxed/simple;
	bh=R4b+BevwFhONDEGuu7nofcOB8xkn9DayS2NTXvOdpRg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cvLe9Sov1NIqVJcVn8/Pok2xpRI7m+J2+2aTa98oR5Pr2l8gI6Xc8wyCA5LQ/DphRkFTiaijikFe7vL7wqmLvrygCwhInAdhXRMNeAMQF7HOFNeJ++PozZp7bRNpdr1D0vFDLTiLehcvj5DExd4+bJwuzX8/jNEQdCMsGW764MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=QDQMgCoi; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="QDQMgCoi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1723728988;
	bh=R4b+BevwFhONDEGuu7nofcOB8xkn9DayS2NTXvOdpRg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=QDQMgCoiRE1eOSF5MYro1rB4lCa2Tt/SpR1PI5puWUKrSJpKP1CcwbGNZtL59vwVF
	 89hOE0piS2D1HhoeH9Xj6bi1MZRSIorKArtXpSceBrzt7UNHMT9ULf/xDGP3Ga6dc0
	 ZJoEkwgAMVpIQY+p8t+BdVq/slu/nan7VrlaScCA=
Received: from [IPv6:240e:456:1030:181:abd4:6e7f:e826:ac0f] (unknown [IPv6:240e:456:1030:181:abd4:6e7f:e826:ac0f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 6D76D66F26;
	Thu, 15 Aug 2024 09:36:23 -0400 (EDT)
Message-ID: <31494f15332037052d1ecf17fa1de874538b9333.camel@xry111.site>
Subject: Re: [PATCH 0/2] LoongArch: Implement getrandom() in vDSO
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>, Huacai Chen
 <chenhuacai@kernel.org>,  WANG Xuerui <kernel@xen0n.name>
Cc: linux-crypto@vger.kernel.org, loongarch@lists.linux.dev, Jinyang He
 <hejinyang@loongson.cn>, Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd
 Bergmann <arnd@arndb.de>
Date: Thu, 15 Aug 2024 21:36:18 +0800
In-Reply-To: <20240815131759.33302-1-xry111@xry111.site>
References: <20240815131759.33302-1-xry111@xry111.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

This series is not properly sent.  See v2 instead:
https://lore.kernel.org/all/20240815133357.35829-1-xry111@xry111.site/

On Thu, 2024-08-15 at 21:17 +0800, Xi Ruoyao wrote:
> For the rationale to implement getrandom() in vDSO see [1].
>=20
> The vDSO getrandom() needs a stack-less ChaCha20 implementation, so we
> need to add architecture-specific code and wire it up with the generic
> code.
>=20
> Without LSX it's not easy to implement ChaCha20 without stack.=C2=A0 So t=
he
> current implementation just falls back to a getrandom() syscall if LSX
> is unavailable.=C2=A0 In the 1st patch the existing alternative runtime
> patching mechanism is expanded to cover vDSO in the first patch, so we
> don't need to invoke cpucfg for each vDSO getrandom() call.
>=20
> Then in the 2nd patch stack-less ChaCha20 is implemented with LSX.=C2=A0 =
The
> code is basically a direct translate from the x86 SSE2 implementation.
> One annoying thing here is the compiler generates a memset() call for a
> "large" struct initialization in a cold path and there seems no way to
> prevent it.=C2=A0 So a naive memset implementation is copied from the ker=
nel
> code into vDSO.
>=20
> The implementation is tested with the kernel selftests added by the last
> patch in [1].=C2=A0 I had to make some adjustments to make it work on
> LoongArch (see [2], I've not submitted the changes as at now because I'm
> unsure about the KHDR_INCLUDES addition).=C2=A0 The vdso_test_getrandom
> bench-single result:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vdso: 25000000 times in 0.631345201 =
seconds
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 libc: 25000000 times in 6.953121083 =
seconds
> =C2=A0=C2=A0=C2=A0 syscall: 25000000 times in 6.992112386 seconds
>=20
> The vdso_test_getrandom bench-multi result:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vdso: 25000000 x 256 times in 29.558=
284986 seconds
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 libc: 25000000 x 256 times in 356.63=
3930139 seconds
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 syscall: 25000000 x 256 times in 334=
.885555338 seconds
>=20
> [1]:https://lore.kernel.org/all/20240712014009.281406-1-Jason@zx2c4.com/
> [2]:https://github.com/xry111/linux/commits/xry111/la-vdso/
>=20
> Cc: linux-crypto@vger.kernel.org
> Cc: loongarch@lists.linux.dev
> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Jinyang He <hejinyang@loongson.cn>
> Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
> Cc: Arnd Bergmann <arnd@arndb.de>
>=20
> Xi Ruoyao (2):
> =C2=A0 LoongArch: Perform alternative runtime patching on vDSO
> =C2=A0 LoongArch: vDSO: Wire up getrandom() vDSO implementation
>=20
> =C2=A0arch/loongarch/Kconfig=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0=C2=A0 1 +
> =C2=A0arch/loongarch/include/asm/vdso/getrandom.h |=C2=A0 47 ++++++
> =C2=A0arch/loongarch/include/asm/vdso/vdso.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0=C2=A0 8 +
> =C2=A0arch/loongarch/kernel/asm-offsets.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 |=C2=A0 10 ++
> =C2=A0arch/loongarch/kernel/vdso.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 14 +-
> =C2=A0arch/loongarch/vdso/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +
> =C2=A0arch/loongarch/vdso/memset.S=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 24 +++
> =C2=A0arch/loongarch/vdso/vdso.lds.S=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 7 +
> =C2=A0arch/loongarch/vdso/vgetrandom-alt.S=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 19 +++
> =C2=A0arch/loongarch/vdso/vgetrandom-chacha.S=C2=A0=C2=A0=C2=A0=C2=A0 | 1=
62 ++++++++++++++++++++
> =C2=A0arch/loongarch/vdso/vgetrandom.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 16 ++
> =C2=A011 files changed, 309 insertions(+), 1 deletion(-)
> =C2=A0create mode 100644 arch/loongarch/include/asm/vdso/getrandom.h
> =C2=A0create mode 100644 arch/loongarch/vdso/memset.S
> =C2=A0create mode 100644 arch/loongarch/vdso/vgetrandom-alt.S
> =C2=A0create mode 100644 arch/loongarch/vdso/vgetrandom-chacha.S
> =C2=A0create mode 100644 arch/loongarch/vdso/vgetrandom.c
>=20

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
