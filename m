Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B4E3A3816;
	Wed, 30 Sep 2026 07:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.133.4.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754078; cv=none; b=De53MfmG+4XfBdE3uF4TcIzZ7/UI+ETCi+cawBdWpqA0kntrDd3+HgO4MgaZChJX/hCKDUxCT77oPSCZ7gFLZjUsK2R50y/qiKbktAjVMOsZNccMM/lwptxhFf1+OGIJHhEzGbcyx/hhlHzws4JjFiwtt/66iCjMFyV6c2Tirok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754078; c=relaxed/simple;
	bh=jm5/IahvPT6fHWYYuJXACfYQ+dmTH8STdro5QL2jwWg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EgvALigiqmaIBBPUmuSYk8VXmT+v93n3lB2oUBLBkIRSVr54ILMcnpGA+0PAFbShpNMDObfWurQWI+0dnrZRJUHRbIGFvvdh0+iBPddgdfWuzicvImWGW5izhrPcgJHArcEy7eJmWTHFuUws+cxH6xK7cOJzoKqkeP1kvgYa6go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de; spf=pass smtp.mailfrom=zedat.fu-berlin.de; dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b=H7azRZUg; arc=none smtp.client-ip=130.133.4.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zedat.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b="H7azRZUg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=C8fHG6YGBQdK+Ru3ZqFs+0D6DcczxOVnC9rzLIJLeMI=; t=1790754075;
	x=1791358875; b=H7azRZUg9tPyloQT51qSdJa6yDHiAdY4NeJnoZk2omACSO/+P4OQa40wlSSeF
	c7KHU+MKGfFtysZMMpFnA689MkmnJ+r0lpy09O7h7HWwXfbLry1ySkUbttWo5ul//aFjdrIk0D6GW
	KnjHelDngiulVRI4Z3bsRUoxVf0ajtyJrnx6g7czpoootDkj64PE5qK97zs9iPapfxkDfmcFK5PU1
	VFFnU0Mrnw5pRlltQDkdmynrUaBjCGFqWaZdNdsTLYjJg8/FdS8QKq253JuXwiiQlwpPHwtAlnmD6
	+g917KUaM2lBbBJ/goSY9e+sLcDetWAWTHG5xNrLiv2dJoAGkw==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.100)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1xBowB-00000001dwC-3Mvk; Wed, 30 Sep 2026 09:41:11 +0200
Received: from p5dc55206.dip0.t-ipconnect.de ([93.197.82.6] helo=[192.168.178.61])
          by inpost2.zedat.fu-berlin.de (Exim 4.100)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1xBowB-00000002phv-2OMM; Wed, 30 Sep 2026 09:41:11 +0200
Message-ID: <1f85bdb9614365fedda81fb649147da48bf7be13.camel@physik.fu-berlin.de>
Subject: Re: [PATCH v3] crypto: aes - Fix undesired override of some
 optimized AES modes
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Stian Halseth <stian@itx.no>, Eric Biggers <ebiggers@kernel.org>, 
	linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A
 . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 sparclinux@vger.kernel.org
Date: Wed, 30 Sep 2026 09:41:10 +0200
In-Reply-To: <322e5255353e3a5f9e3840a496018edd980fb016.camel@itx.no>
References: <20260929222752.36427-1-ebiggers@kernel.org>
	 <322e5255353e3a5f9e3840a496018edd980fb016.camel@itx.no>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-ZEDAT-Hint: PO

Hi Stian,

On Wed, 2026-09-30 at 09:32 +0200, Stian Halseth wrote:
> On Tue, 2026-09-29 at 15:27 -0700, Eric Biggers wrote:
> > The new library APIs for AES encryption modes were wired up to the
> > traditional crypto API via crypto/aes.c.=C2=A0 However, for now the ker=
nel
> > is
> > still in a transitional state where various architectures still have
> > architecture-optimized implementations of AES modes in
> > arch/*/crypto/,
> > wired up to the traditional crypto API only.=C2=A0 Because of that, the
> > crypto/aes.c algorithms were given a cra_priority of only 110 to
> > prevent
> > them from overriding arch/*/crypto/ in the traditional crypto API.
> >=20
> > However, because of how the traditional crypto API works, the
> > cra_priority trick doesn't work in cases where the relevant algorithm
> > isn't directly implemented by arch/*/crypto/ but rather is provided
> > by a
> > template instance using other code in arch/*/crypto/.
> >=20
> > For example, x86 doesn't have its own "ccm(aes)" but rather relies on
> > the "ccm" template constructing it from the x86-optimized "ctr(aes)".
> > The existence of the library-based "ccm(aes)" prevents that, even
> > though
> > its priority is lower than what the template would produce.
> >=20
> > Thus, "ccm(aes)" ends up using the slower single-block AES code.
> >=20
> > Therefore, skip wiring up the relevant library-based code to the
> > traditional crypto API on architectures where this problem can occur,
> > as
> > determined by what exists in arch/*/crypto/ for each architecture.
> >=20
> > This is ugly, but it's also temporary: these conditions will go away
> > as
> > architecture-optimized implementations of AES modes are migrated into
> > the library.=C2=A0 But until then, we need to prevent performance
> > regressions
> > by ensuring that the optimized code continues to be used.
> >=20
> > Fixes: 20df21a482aa ("crypto: aes - Add CBC and CBC-CTS support using
> > library")
> > Fixes: 8ca62072faa1 ("crypto: aes - Add GCM support using library")
> > Fixes: f70ad727d1d6 ("crypto: aes - Add CCM support using library")
> > Fixes: 94efa0c9fb36 ("crypto: aes - Add XTS support using library")
> > Closes: https://github.com/sparclinux/issues/issues/106
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> >=20
> > This patch is intended to taken through libcrypto-fixes
> >=20
> > v3: Also suppress xts(aes) on SPARC, and improved comments
> > v2: Fixed PowerPC config option, and resent as standalone patch
> >=20
> >=20
> Tested on a SPARC T7-1 (M7) on top of v7.3-rc5. xts(aes) resolves to
> xts(ecb-aes-sparc64) again. cryptsetup benchmark aes-xts goes from
> 152/147 MiB/s back to 429/404 (AES-128/AES-256), the 7.2 figures.
> CRYPTO_SELFTESTS_FULL passes and XTS matches OpenSSL.
>=20
> Tested-by: Stian Halseth stian@itx.no

Very nice! Do you know which SPARC CPUs support these instructions?

Adrian

> > =C2=A0crypto/aes.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++=
---
> > -
> > =C2=A01 file changed, 47 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/crypto/aes.c b/crypto/aes.c
> > index 94791f481e98..51eee78396ea 100644
> > --- a/crypto/aes.c
> > +++ b/crypto/aes.c
> > @@ -637,7 +637,18 @@ static struct skcipher_alg skcipher_algs[] =3D {
> > =C2=A0		.decrypt =3D crypto_aes_cbc_decrypt,
> > =C2=A0	},
> > =C2=A0#endif
> > -#if IS_ENABLED(CONFIG_CRYPTO_CTS)
> > +	/*
> > +	 * Don't register library-based "cts(cbc(aes))" on
> > architectures where
> > +	 * it might block a "better" implementation from being
> > instantiated via
> > +	 * the "cts" template.=C2=A0 These exclusions are temporary and
> > will go away
> > +	 * as the arch-optimized AES code is migrated into the
> > library.
> > +	 */
> > +#if IS_ENABLED(CONFIG_CRYPTO_CTS) && \
> > +	!(IS_ENABLED(CONFIG_ARM) || \
> > +	=C2=A0 IS_ENABLED(CONFIG_ARM64) || \
> > +	=C2=A0 IS_ENABLED(CONFIG_PPC) || \
> > +	=C2=A0 IS_ENABLED(CONFIG_S390) || \
> > +	=C2=A0 IS_ENABLED(CONFIG_SPARC))
> > =C2=A0	{
> > =C2=A0		.base.cra_name =3D "cts(cbc(aes))",
> > =C2=A0		.base.cra_driver_name =3D "cts-cbc-aes-lib",
> > @@ -687,7 +698,13 @@ static struct skcipher_alg skcipher_algs[] =3D {
> > =C2=A0		.decrypt =3D crypto_aes_xctr_crypt,
> > =C2=A0	},
> > =C2=A0#endif
> > -#if IS_ENABLED(CONFIG_CRYPTO_XTS)
> > +	/*
> > +	 * Don't register library-based "xts(aes)" on architectures
> > where it
> > +	 * might block a "better" implementation from being
> > instantiated via the
> > +	 * "xts" template.=C2=A0 This exclusion is temporary and will go
> > away when
> > +	 * the library AES-XTS is optimized for SPARC.
> > +	 */
> > +#if IS_ENABLED(CONFIG_CRYPTO_XTS) && !IS_ENABLED(CONFIG_SPARC)
> > =C2=A0	{
> > =C2=A0		.base.cra_name =3D "xts(aes)",
> > =C2=A0		.base.cra_driver_name =3D "xts-aes-lib",
> > @@ -980,7 +997,20 @@ static __maybe_unused int
> > crypto_aes_ccm_decrypt(struct aead_request *req)
> > =C2=A0}
> > =C2=A0
> > =C2=A0static struct aead_alg aead_algs[] =3D {
> > -#if IS_ENABLED(CONFIG_CRYPTO_GCM)
> > +	/*
> > +	 * Don't register library-based "gcm(aes)" and
> > "rfc4106(gcm(aes))" on
> > +	 * architectures where they might block a "better"
> > implementation from
> > +	 * being instantiated via the "gcm" and "rfc4106"
> > templates.=C2=A0 These
> > +	 * exclusions are temporary and will go away as the arch-
> > optimized AES
> > +	 * code is migrated into the library.
> > +	 */
> > +#if IS_ENABLED(CONFIG_CRYPTO_GCM) && \
> > +	!(IS_ENABLED(CONFIG_ARM) || \
> > +	=C2=A0 IS_ENABLED(CONFIG_ARM64) || \
> > +	=C2=A0 IS_ENABLED(CONFIG_PPC) || \
> > +	=C2=A0 IS_ENABLED(CONFIG_RISCV) || \
> > +	=C2=A0 IS_ENABLED(CONFIG_S390) || \
> > +	=C2=A0 IS_ENABLED(CONFIG_SPARC))
> > =C2=A0	{
> > =C2=A0		.base.cra_name =3D "gcm(aes)",
> > =C2=A0		.base.cra_driver_name =3D "gcm-aes-lib",
> > @@ -1012,7 +1042,20 @@ static struct aead_alg aead_algs[] =3D {
> > =C2=A0		.chunksize =3D AES_BLOCK_SIZE,
> > =C2=A0	},
> > =C2=A0#endif /* CONFIG_CRYPTO_GCM */
> > -#if IS_ENABLED(CONFIG_CRYPTO_CCM)
> > +	/*
> > +	 * Don't register library-based "ccm(aes)" on architectures
> > where it
> > +	 * might block a "better" implementation from being
> > instantiated via the
> > +	 * "ccm" template.=C2=A0 These exclusions are temporary and will
> > go away as
> > +	 * the arch-optimized AES code is migrated into the library.
> > +	 */
> > +#if IS_ENABLED(CONFIG_CRYPTO_CCM) && \
> > +	!(IS_ENABLED(CONFIG_ARM) || \
> > +	=C2=A0 IS_ENABLED(CONFIG_ARM64) || \
> > +	=C2=A0 IS_ENABLED(CONFIG_PPC) || \
> > +	=C2=A0 IS_ENABLED(CONFIG_RISCV) || \
> > +	=C2=A0 IS_ENABLED(CONFIG_S390) || \
> > +	=C2=A0 IS_ENABLED(CONFIG_SPARC) || \
> > +	=C2=A0 IS_ENABLED(CONFIG_X86))
> > =C2=A0	{
> > =C2=A0		.base.cra_name =3D "ccm(aes)",
> > =C2=A0		.base.cra_driver_name =3D "ccm-aes-lib",
> >=20
> > base-commit: 93f51579e7df248780214094418f205253383cc5

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
