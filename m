Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA201A0AF4
	for <linux-crypto@vger.kernel.org>; Tue, 27 Aug 2024 14:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724768822; cv=none; b=QSvs+W0IuxKt+YkPZk8jAgnkEQjicrCLx1P160ECQCCXTJMRKTrSSuFwSLQq0j0PBQgB74cK/NfiToBWBRvXnZyssqK1nXFCnOhVhlXKUOwEb3SpbIGvGkfZwvWmJ1XMnR00jiEKhILZJpI4na36iCfmlsKGDcFXT6Mh/ZrmCuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724768822; c=relaxed/simple;
	bh=+q2+LZWCWXtLQCcNQ3ibvgIQp4F3rZIVxQwsHCBGARY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EUWQ4lGfbNf/xX4iXXSHbl66H8AVTKTcRvamQ4Sp9KCSr12onEDoH/BiMpS5cozff/vIMn/Lj9Gd6HrMB7HwnK5f5LWJQS1qKUZTkzaHdQwINGw5fNTZniZ+R0BOeRTW+a6kgnRAFjTl/GEfBUmYnacRVrhVvfmKffJ5s1Ln0bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=M4qZwCN1; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="M4qZwCN1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1724768818;
	bh=+q2+LZWCWXtLQCcNQ3ibvgIQp4F3rZIVxQwsHCBGARY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=M4qZwCN1nUoS8g8eiWSSfchqgF0ZC2KS+LtJVgtOwBaAAm7bYKOZuT+BAuR3sze90
	 Cx7H6PXSEu1mB4jRiy7pANWpxT2k9BYrul+nzQq4k2tUeOuF+BkmzBpzjXxQU4iSAQ
	 c1dE0AzP3dOupf+pU3bWFV6YVQOSj27Auw427z4w=
Received: from [127.0.0.1] (unknown [IPv6:2001:470:683e::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 9D3F766F26;
	Tue, 27 Aug 2024 10:26:55 -0400 (EDT)
Message-ID: <f404ae352a8cba3e035c9d5a10b553fb4497bb02.camel@xry111.site>
Subject: Re: [PATCH v4 1/4] LoongArch: vDSO: Wire up getrandom() vDSO
 implementation
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 linux-crypto@vger.kernel.org, loongarch@lists.linux.dev, Jinyang He
 <hejinyang@loongson.cn>, Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd
 Bergmann <arnd@arndb.de>
Date: Tue, 27 Aug 2024 22:26:53 +0800
In-Reply-To: <Zs3ZWm-218Cb_ir0@zx2c4.com>
References: <20240827132018.88854-1-xry111@xry111.site>
	 <20240827132018.88854-2-xry111@xry111.site> <Zs3ZWm-218Cb_ir0@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-08-27 at 15:49 +0200, Jason A. Donenfeld wrote:
> On Tue, Aug 27, 2024 at 09:20:14PM +0800, Xi Ruoyao wrote:
> > +	register long ret asm("a0");
> > +	register long int nr asm("a7") =3D __NR_getrandom;
>=20
> The first line is `long` and the second line is `long int` here. Just
> call them both `long` like usual?

I'll change it.
>=20
> > =C2=A0struct loongarch_vdso_data {
> > =C2=A0	struct vdso_pcpu_data pdata[NR_CPUS];
> > +#ifdef CONFIG_VDSO_GETRANDOM
> > +	struct vdso_rng_data rng_data;
> > +#endif
>=20
> If VSO_GETRANDOM is selected unconditionally for the arch, why the
> ifdef
> here?
>=20
> > +obj-vdso-$(CONFIG_VDSO_GETRANDOM) +=3D vgetrandom.o vgetrandom-
> > chacha.o
>=20
> Likewise, same question here.

I'll remove the ifdef and just add them into obj-vdso-y.

> > +	/* copy[3] =3D "expa" */
> > +	li.w		copy3, 0x6b206574
>=20
> Might want to mention why you're doing this.
>=20
> =C2=A0=C2=A0=C2=A0 /* copy[3] =3D "expa", because it was clobbered by the=
 i index. */

I'll add it.

> Or something like that.
>=20
> But on the topic of those constants,
>=20
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 li.w=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 copy0, 0x61707865
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 li.w=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 copy1, 0x3320646e
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 li.w=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 copy2, 0x79622d32
>=20
> What if you avoid doing this,
>=20
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ld.w=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cnt_lo, counter, 0
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ld.w=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cnt_hi, counter, 4
> > +
> > +.Lblock:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* state[0,1,2,3] =3D "expand 32-=
byte k" */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 move=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 state0, copy0
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 move=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 state1, copy1
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 move=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 state2, copy2
>=20
> Use li.w here with the integer literals,

li.w is expanded to two instructions (lu12i.w + addi.w) by the
assembler.

> > +	/* copy[3] =3D "expa" */
> > +	li.w		copy3, 0x6b206574
>=20
> Skip this,
>=20
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 add.w=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 state0, state0, copy0
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 add.w=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 state1, state1, copy1
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 add.w=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 state2, state2, copy2
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 add.w=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 state3, state3, copy3
>=20
> And then use addi.w here with the integer literals instead?

LoongArch addi.w can only handle 12-bit signed immediate values (such a
limitation is very common in RISC machines).  On my processor I can
avoid using a register to materialize the constant with addu16i.d +
addu12i.w + addi.w.  But there would be 3 instructions, and addu12i.w is
a part of the Loongson Binary Translation extension which is not
available on some processors.  Also LBT isn't intended for general use,
so most LBT instructions have a lower throughput than the basic
instructions.

> I don't know anything about loongarch, so just guessing.

> BTW, can you confirm that this passes the test in test_vdso_chacha?

Yes, it has passed the test.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
