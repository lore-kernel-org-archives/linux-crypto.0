Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA9444385
	for <linux-crypto@vger.kernel.org>; Wed, 29 Nov 2023 11:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uHW9BMYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518E2C433C8;
	Wed, 29 Nov 2023 11:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701256341;
	bh=/coNSpmuwlu7aZMGLXJ3EaK+coscmuirD3fIRDyp1uM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uHW9BMYgIEhTEqKl/kgeus1mAfaC24bTLFknNCVdCgivrIV4xIareTJc1aZl+7sg8
	 tcJX1bZeT2v9L+VJjvSiC5P1wvRy/Kaa7TCTB/wtLhA9wymeZk/tG2lN3rTphc1yN7
	 xIDXXbyvd7kPzrMMaO0T7Et6s2qh57vQaCxKBuIdNBMubVuxknQru14j89u+71Jv2R
	 nPuTTXXcT8FyQS0Spn1TW/ubqWFQJSlS4+aBBoBUP5lels3jhRndKCOYNkjFn8yCfC
	 AXmM2L+J/u2dSrpUShsC1fUBQQ+/CTFTF0wg/cU46H+b/BIadIzGxYgmqVR0kR+5kl
	 GxePfv72XOs8A==
Date: Wed, 29 Nov 2023 11:12:16 +0000
From: Conor Dooley <conor@kernel.org>
To: Jerry Shih <jerry.shih@sifive.com>, Andy Chiu <andy.chiu@sifive.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, herbert@gondor.apana.org.au,
	davem@davemloft.net, conor.dooley@microchip.com, ardb@kernel.org,
	heiko@sntech.de, phoebe.chen@sifive.com, hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 04/13] RISC-V: crypto: add Zvkned accelerated AES
 implementation
Message-ID: <20231129-subtitle-unlinked-c0871a28ac88@spud>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
 <20231127070703.1697-5-jerry.shih@sifive.com>
 <20231128-await-tipper-2094715466f2@spud>
 <20231128201228.GE1148@sol.localdomain>
 <E78B3BF9-8E49-417B-A89E-05F72690A92F@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="YXU66bvB/doJduzO"
Content-Disposition: inline
In-Reply-To: <E78B3BF9-8E49-417B-A89E-05F72690A92F@sifive.com>


--YXU66bvB/doJduzO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 29, 2023 at 10:39:56AM +0800, Jerry Shih wrote:
> On Nov 29, 2023, at 04:12, Eric Biggers <ebiggers@kernel.org> wrote:
> > On Tue, Nov 28, 2023 at 05:54:49PM +0000, Conor Dooley wrote:
> >>> +static inline bool check_aes_ext(void)
> >>> +{
> >>> +	return riscv_isa_extension_available(NULL, ZVKNED) &&
> >>> +	       riscv_vector_vlen() >=3D 128;
> >>> +}
> >>=20
> >> I'm not keen on this construct, where you are checking vlen greater th=
an
> >> 128 and the presence of Zvkned without checking for the presence of V
> >> itself. Can you use "has_vector()" in any places where you depend on t=
he
> >> presence of vector please?
> >=20
> > Shouldn't both of those things imply vector support already?
>=20
> The vector crypto extensions imply `V` extension. Should we still need to=
 check
> the `V` explicitly?
> https://github.com/riscv/riscv-crypto/blob/main/doc/vector/riscv-crypto-s=
pec-vector.adoc#1-extensions-overview

The check for Zkvned is only for whether or not Zvkned has been provided
in the DT or ACPI tables, it doesn't mean that the kernel supports the V
extension. I could see something like a hypervisor that does not support
vector parsing the "v" out of the DT or ACPI tables but not eliminating
every single extension that may depend on vector support.

The latter check is, IMO, an implementation detail and also should not
be used to imply that vector is supported.

Actually, Andy - questions for you. If the vsize is not homogeneous we do
not support vector for userspace and we disable vector in hwcap, but
riscv_v_size will have been set by riscv_fill_hwcap(). Is the disabling
of vector propagated to other locations in the kernel that inform
userspace, like hwprobe? I only skimmed the in-kernel vector patchset,
but I could not see anything there that ensures homogeneity either.
Should has_vector() calls start to fail if the vsize is not homogeneous?
I feel like they should, but I might very well be missing something here.

> >> Also, there are potentially a lot of places in this drivers where you
> >> can replace "riscv_isa_extension_available()" with
> >> "riscv_has_extension_likely()". The latter is optimised with
> >> alternatives, so in places that are going to be evaluated frequently it
> >> may be beneficial for you.
> >=20
> > These extension checks are only executed in module_init functions, so t=
hey're
> > not performance critical.

That's fine, they can continue as they are so.

Cheers,
Conor.

--YXU66bvB/doJduzO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZWccjwAKCRB4tDGHoIJi
0i5BAP9Hco6K4yVD6S5aXOUTYMtHVQcZxhQ+VfDhgiERySBDLgD+LCnaxJynwJot
3xWQVY1/DM6nF8Rg8OJO6T63AZfqYQI=
=4b6u
-----END PGP SIGNATURE-----

--YXU66bvB/doJduzO--
