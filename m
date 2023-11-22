Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E341B15A0
	for <linux-crypto@vger.kernel.org>; Wed, 22 Nov 2023 00:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FibQR4kN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84FDC433C8;
	Wed, 22 Nov 2023 00:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700613564;
	bh=30m/iYK2LTqC2vbblkdeJ7vVODP3+KWczJOiTOhJzso=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FibQR4kNrjgQTR1Ovh+Sr0EvibCJFmMcM0YyazW5D5yunfbzRRE0nkQWXN8ZYwCFc
	 FyLcKn2/A4clnUq0e4n469DOhAcjtQTfWF/krVJpLFxy4xW01idq+sfqNObdqvN+FL
	 03GeslT/45bKSbR730i6g4icyTzR57HtB6HVFgrHKlEXSy5dk2H9NG3UqdfPDvheHO
	 Gqq5zwR6lV4TBCAjaixLDwDMcQD6dsLl9FDL8Brj2s97ONAjOaYHNejYogdEc4N7at
	 /Py0i8POgUrqj70ZUl8gkAFjaNFLKtPNX7vrX9SypwCdS+XPnPPWhGnKQ6oXbhWVxm
	 EVqOkeU2VvEgQ==
Date: Wed, 22 Nov 2023 00:39:18 +0000
From: Conor Dooley <conor@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Conor Dooley <conor.dooley@microchip.com>,
	Jerry Shih <jerry.shih@sifive.com>,
	Paul Walmsley <paul.walmsley@sifive.com>, palmer@dabbelt.com,
	Albert Ou <aou@eecs.berkeley.edu>, herbert@gondor.apana.org.au,
	davem@davemloft.net, andy.chiu@sifive.com, greentime.hu@sifive.com,
	guoren@kernel.org, bjorn@rivosinc.com, heiko@sntech.de,
	ardb@kernel.org, phoebe.chen@sifive.com, hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 12/12] RISC-V: crypto: add Zvkb accelerated ChaCha20
 implementation
Message-ID: <20231122-displace-reformat-9ca68c3dc66c@spud>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
 <20231025183644.8735-13-jerry.shih@sifive.com>
 <20231102054327.GH1498@sol.localdomain>
 <90E2B1B4-ACC1-4316-81CD-E919D3BD03BA@sifive.com>
 <20231120191856.GA964@sol.localdomain>
 <9724E3A5-F43C-4239-9031-2B33B72C4EF4@sifive.com>
 <20231121-knelt-resource-5d71c9246015@wendy>
 <20231121233743.GD2172@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tAZuBie9e92hyVDR"
Content-Disposition: inline
In-Reply-To: <20231121233743.GD2172@sol.localdomain>


--tAZuBie9e92hyVDR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 21, 2023 at 03:37:43PM -0800, Eric Biggers wrote:
> On Tue, Nov 21, 2023 at 01:14:47PM +0000, Conor Dooley wrote:
> > On Tue, Nov 21, 2023 at 06:55:07PM +0800, Jerry Shih wrote:
> > > On Nov 21, 2023, at 03:18, Eric Biggers <ebiggers@kernel.org> wrote:
> > > > First, I can see your updated patchset at branch
> > > > "dev/jerrys/vector-crypto-upstream-v2" of https://github.com/JerryS=
hih/linux,
> > > > but I haven't seen it on the mailing list yet.  Are you planning to=
 send it out?
> > >=20
> > > I will send it out soon.
> > >=20
> > > > Second, with your updated patchset, I'm not seeing any of the RISC-=
V optimized
> > > > algorithms be registered when I boot the kernel in QEMU.  This is c=
aused by the
> > > > new check 'riscv_isa_extension_available(NULL, ZICCLSM)' not passin=
g.  Is
> > > > checking for "Zicclsm" the correct way to determine whether unalign=
ed memory
> > > > accesses are supported?
> > > >=20
> > > > I'm using 'qemu-system-riscv64 -cpu max -machine virt', with the ve=
ry latest
> > > > QEMU commit (af9264da80073435), so it should have all the CPU featu=
res.
> > > >=20
> > > > - Eric
> > >=20
> > > Sorry, I just use my `internal` qemu with vector-crypto and rva22 pat=
ches.
> > >=20
> > > The public qemu haven't supported rva22 profiles. Here is the qemu pa=
tch[1] for
> > > that. But here is the discussion why the qemu doesn't export these
> > > `named extensions`(e.g. Zicclsm).
> > > I try to add Zicclsm in DT in the v2 patch set. Maybe we will have mo=
re discussion
> > > about the rva22 profiles in kernel DT.
> >=20
> > Please do, that'll be fun! Please take some time to read what the
> > profiles spec actually defines Zicclsm fore before you send those patch=
es
> > though. I think you might come to find you have misunderstood what it
> > means - certainly I did the first time I saw it!
> >=20
> > > [1]
> > > LINK: https://lore.kernel.org/all/d1d6f2dc-55b2-4dce-a48a-4afbbf6df52=
6@ventanamicro.com/#t
> > >=20
> > > I don't know whether it's a good practice to check unaligned access u=
sing
> > > `Zicclsm`.=20
> > >=20
> > > Here is another related cpu feature for unaligned access:
> > > RISCV_HWPROBE_MISALIGNED_*
> > > But it looks like it always be initialized with `RISCV_HWPROBE_MISALI=
GNED_SLOW`[2].
> > > It implies that linux kernel always supports unaligned access. But we=
 have the
> > > actual HW which doesn't support unaligned access for vector unit.
> >=20
> > https://docs.kernel.org/arch/riscv/uabi.html#misaligned-accesses
> >=20
> > Misaligned accesses are part of the user ABI & the hwprobe stuff for
> > that allows userspace to figure out whether they're fast (likely
> > implemented in hardware), slow (likely emulated in firmware) or emulated
> > in the kernel.
> >
> > > [2]
> > > LINK: https://github.com/torvalds/linux/blob/98b1cc82c4affc16f5598d4f=
a14b1858671b2263/arch/riscv/kernel/cpufeature.c#L575
> > >=20
> > > I will still use `Zicclsm` checking in this stage for reviewing. And =
I will create qemu
> > > branch with Zicclsm enabled feature for testing.
> > >=20
>=20
> According to https://github.com/riscv/riscv-profiles/blob/main/profiles.a=
doc,
> Zicclsm means that "main memory supports misaligned loads/stores", but th=
ey
> "might execute extremely slowly."

Check the section it is defined in - it is only defined for the RVA22U64
profile which describes "features available to user-mode execution
environments". It otherwise has no meaning, so it is not suitable for
detecting anything from within the kernel. For other operating systems
it might actually mean something, but for Linux the uABI on RISC-V
unconditionally provides what Zicclsm is intended to convey:
https://www.kernel.org/doc/html/next/riscv/uabi.html#misaligned-accesses
We could (_perhaps_) set it in /proc/cpuinfo in riscv,isa there - but a
conversation would have to be had about what these non-extension
"features" actually are & whether it makes sense to put them there.

> In general, the vector crypto routines that Jerry is adding assume that
> misaligned vector loads/stores are supported *and* are fast.  I think the=
 kernel
> mustn't register those algorithms if that isn't the case.  Zicclsm sounds=
 like
> the wrong thing to check.  Maybe RISCV_HWPROBE_MISALIGNED_FAST is the rig=
ht
> thing to check?

It actually means something, so it is certainly better ;)
I think checking it makes sense as a good surrogate for actually knowing
whether or not the hardware supports misaligned access.

> BTW, something else I was wondering about is endianness.  Most of the vec=
tor
> crypto routines also assume little endian byte order, but I don't see tha=
t being
> explicitly checked for anywhere.  Should it be?

The RISC-V kernel only supports LE at the moment. I hope that doesn't
change tbh.

Cheers,
Conor.

--tAZuBie9e92hyVDR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZV1NtgAKCRB4tDGHoIJi
0pKmAP4wpUX32fmGfEBASlZcXQ9tXOvEp08kigjC/LnwvhN2rAEAtKF+PUAXuhZD
x7yqXOWXHJnTwdHKtg3B6kH1D8KbhQ4=
=7qzQ
-----END PGP SIGNATURE-----

--tAZuBie9e92hyVDR--
