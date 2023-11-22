Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C3258ACB
	for <linux-crypto@vger.kernel.org>; Wed, 22 Nov 2023 18:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LqMb3fRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73061C433C8;
	Wed, 22 Nov 2023 18:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700677206;
	bh=nkZlaJwfo+V2BOfC+0q1NUdNuKi157V0je+RZmbYjyY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LqMb3fRtSGpM264Q/X+r9Lc4ASZuUM8LRktFpUUOJ3hdGw+wHbwis7LyCwxrXzNYT
	 swSwg0XYFEOhwB9k2wV1Fye/mohrmhIiAce+Uhu6yl7adJ1qPtWWAY05yGxDStf231
	 3GbmhcLMee8pYot3pZRKhX4/AwIFGIDSTtCZKBLpeGlEHRq2GyS+9gC0TqFLNLMxM7
	 w0tQUvxan8VETFkQEFkWZBa+NaZtk6vmLhWS3WxriAf6K/+ok/O4o6Xa2axSTWz5Ea
	 GTAV06iAJrxIGhgh/zQonRDlzpbp18XIlJcQjb+g1w28RCn2pQCbPgObD3W/IyMNs3
	 j94dmdB/IdptQ==
Date: Wed, 22 Nov 2023 18:20:00 +0000
From: Conor Dooley <conor@kernel.org>
To: Jerry Shih <jerry.shih@sifive.com>
Cc: Conor Dooley <conor.dooley@microchip.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>, palmer@dabbelt.com,
	Albert Ou <aou@eecs.berkeley.edu>, herbert@gondor.apana.org.au,
	davem@davemloft.net, andy.chiu@sifive.com, greentime.hu@sifive.com,
	guoren@kernel.org, bjorn@rivosinc.com, heiko@sntech.de,
	ardb@kernel.org, phoebe.chen@sifive.com, hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 12/12] RISC-V: crypto: add Zvkb accelerated ChaCha20
 implementation
Message-ID: <20231122-bulldog-deceased-7e3dadf3a833@spud>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
 <20231025183644.8735-13-jerry.shih@sifive.com>
 <20231102054327.GH1498@sol.localdomain>
 <90E2B1B4-ACC1-4316-81CD-E919D3BD03BA@sifive.com>
 <20231120191856.GA964@sol.localdomain>
 <9724E3A5-F43C-4239-9031-2B33B72C4EF4@sifive.com>
 <20231121-knelt-resource-5d71c9246015@wendy>
 <3BDE7B86-0078-4C77-A383-1C83C88E44DA@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="vzAb+aUYU4qXrR/Z"
Content-Disposition: inline
In-Reply-To: <3BDE7B86-0078-4C77-A383-1C83C88E44DA@sifive.com>


--vzAb+aUYU4qXrR/Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 23, 2023 at 01:37:33AM +0800, Jerry Shih wrote:
> On Nov 21, 2023, at 21:14, Conor Dooley <conor.dooley@microchip.com> wrot=
e:
> > On Tue, Nov 21, 2023 at 06:55:07PM +0800, Jerry Shih wrote:
> >> Sorry, I just use my `internal` qemu with vector-crypto and rva22 patc=
hes.
> >>=20
> >> The public qemu haven't supported rva22 profiles. Here is the qemu pat=
ch[1] for
> >> that. But here is the discussion why the qemu doesn't export these
> >> `named extensions`(e.g. Zicclsm).
> >> I try to add Zicclsm in DT in the v2 patch set. Maybe we will have mor=
e discussion
> >> about the rva22 profiles in kernel DT.
> >=20
> > Please do, that'll be fun! Please take some time to read what the
> > profiles spec actually defines Zicclsm fore before you send those patch=
es
> > though. I think you might come to find you have misunderstood what it
> > means - certainly I did the first time I saw it!
>=20
> From the rva22 profile:

"rva22" is not a profile. As I pointed out to Eric, this is defined in
the RVA22U64 profile (and the RVA20U64 one, but that is effectively a
moot point). The profile descriptions for these only specify "the ISA
features available to user-mode execution environments", so it is not
suitable for use in any other context.

>   This requires misaligned support for all regular load and store instruc=
tions (including
>   scalar and ``vector``)
>=20
> The spec includes the explicit `vector` keyword.
> So, I still think we could use Zicclsm checking for these vector-crypto i=
mplementations.

In userspace, if Zicclsm was exported somewhere, that would be a valid
argument. Even for userspace, the hwprobe flags probably provide more
information though, since the firmware emulation is insanely slow.

> My proposed patch is just a simple patch which only update the DT documen=
t and
> update the isa string parser for Zicclsm.

Zicclsm has no meaning outside of user mode, so it's not suitable for
use in that context. Other "features" defined in the profiles spec might
be suitable for inclusion, but it'll be a case-by-case basis.

> If it's still not recommend to use Zicclsm
> checking, I will turn to use `RISCV_HWPROBE_MISALIGNED_*` instead.

Palmer has commented on the rest, so no need for me :)

--vzAb+aUYU4qXrR/Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZV5GUAAKCRB4tDGHoIJi
0oykAP4922JGXnpu07g8YFB8/6OUEt+yMcyfCYkI5roxjxUMvAD+IKrCIgs4o3KE
2V2NnvtXaLmpQQqGQ0bwPy/0N681yg4=
=fOfP
-----END PGP SIGNATURE-----

--vzAb+aUYU4qXrR/Z--
