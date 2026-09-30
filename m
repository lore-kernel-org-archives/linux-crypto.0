Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A667B1F875A;
	Wed, 30 Sep 2026 07:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.189.121.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790753561; cv=none; b=bHpBf3bCFLtaRXVjfSOvItFHGtJt0hQH2w+YJeKWAVIY8qaJjavCGgEF63vnrVSMuZPpKRa0/SjLmsppFKghvkOg1PX+q8CiMiEIv7FWPgQuRIoUmpM9kKhUnPQx49ymdhZ30wN5K6F6I91Cv5Kn+Ple1CoNSTiNAFk42hTMbkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790753561; c=relaxed/simple;
	bh=FOBD6w50aH3La6YrnSYxR0NgpZSSXfXSZp2dcOzr82w=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KmGws8twQl1KpJHcAlWPBusTnzKlxM9LnDZC/RH+R4MyorWm97xSdIhOpq5OEHCuhmrWCwL8TjWv3Vs7G6cVIyHymiI5lo5A/jVc+nt5/PNlTfBHEpij+AsQ0GKS1wNPpnTkmbM4hFvpdIoo+LbS8KWd2pdC+B8ED1jWTd1NOoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no; spf=pass smtp.mailfrom=itx.no; dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.b=hAJ5TUPf; arc=none smtp.client-ip=91.189.121.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=itx.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.b="hAJ5TUPf"
Message-ID: <322e5255353e3a5f9e3840a496018edd980fb016.camel@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1790753557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uWZ4wz/xFm6cJNcxHRzz2aCALgOcUXbJs12YgIhBUPw=;
	b=hAJ5TUPfz0JkLCEYSFHPYtX4UG706wkcVugc0mmnWfx2z8Fge8ZqT6BSr2/ioaYvdrroAt
	HmRL4scYcmopeMVZZKy1axU2y/S+wnFaRuYpWIfCNa1DCgxK7IHDtR+7Xa8upRirR5X3gk
	bsJEmb3BYIA7VcLv5RPKIIbjNeEYepk=
Subject: Re: [PATCH v3] crypto: aes - Fix undesired override of some
 optimized AES modes
From: Stian Halseth <stian@itx.no>
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A
 . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 sparclinux@vger.kernel.org
Date: Wed, 30 Sep 2026 09:32:36 +0200
In-Reply-To: <20260929222752.36427-1-ebiggers@kernel.org>
References: <20260929222752.36427-1-ebiggers@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-fwsjTeomEhuBv/yMGL2B"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


--=-fwsjTeomEhuBv/yMGL2B
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable


On Tue, 2026-09-29 at 15:27 -0700, Eric Biggers wrote:
> The new library APIs for AES encryption modes were wired up to the
> traditional crypto API via crypto/aes.c.=A0 However, for now the kernel
> is
> still in a transitional state where various architectures still have
> architecture-optimized implementations of AES modes in
> arch/*/crypto/,
> wired up to the traditional crypto API only.=A0 Because of that, the
> crypto/aes.c algorithms were given a cra_priority of only 110 to
> prevent
> them from overriding arch/*/crypto/ in the traditional crypto API.
>=20
> However, because of how the traditional crypto API works, the
> cra_priority trick doesn't work in cases where the relevant algorithm
> isn't directly implemented by arch/*/crypto/ but rather is provided
> by a
> template instance using other code in arch/*/crypto/.
>=20
> For example, x86 doesn't have its own "ccm(aes)" but rather relies on
> the "ccm" template constructing it from the x86-optimized "ctr(aes)".
> The existence of the library-based "ccm(aes)" prevents that, even
> though
> its priority is lower than what the template would produce.
>=20
> Thus, "ccm(aes)" ends up using the slower single-block AES code.
>=20
> Therefore, skip wiring up the relevant library-based code to the
> traditional crypto API on architectures where this problem can occur,
> as
> determined by what exists in arch/*/crypto/ for each architecture.
>=20
> This is ugly, but it's also temporary: these conditions will go away
> as
> architecture-optimized implementations of AES modes are migrated into
> the library.=A0 But until then, we need to prevent performance
> regressions
> by ensuring that the optimized code continues to be used.
>=20
> Fixes: 20df21a482aa ("crypto: aes - Add CBC and CBC-CTS support using
> library")
> Fixes: 8ca62072faa1 ("crypto: aes - Add GCM support using library")
> Fixes: f70ad727d1d6 ("crypto: aes - Add CCM support using library")
> Fixes: 94efa0c9fb36 ("crypto: aes - Add XTS support using library")
> Closes: https://github.com/sparclinux/issues/issues/106
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>=20
> This patch is intended to taken through libcrypto-fixes
>=20
> v3: Also suppress xts(aes) on SPARC, and improved comments
> v2: Fixed PowerPC config option, and resent as standalone patch
>=20
>=20
Tested on a SPARC T7-1 (M7) on top of v7.3-rc5. xts(aes) resolves to
xts(ecb-aes-sparc64) again. cryptsetup benchmark aes-xts goes from
152/147 MiB/s back to 429/404 (AES-128/AES-256), the 7.2 figures.
CRYPTO_SELFTESTS_FULL passes and XTS matches OpenSSL.

Tested-by: Stian Halseth stian@itx.no
> =A0crypto/aes.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++---
> -
> =A01 file changed, 47 insertions(+), 4 deletions(-)
>=20
> diff --git a/crypto/aes.c b/crypto/aes.c
> index 94791f481e98..51eee78396ea 100644
> --- a/crypto/aes.c
> +++ b/crypto/aes.c
> @@ -637,7 +637,18 @@ static struct skcipher_alg skcipher_algs[] =3D {
> =A0		.decrypt =3D crypto_aes_cbc_decrypt,
> =A0	},
> =A0#endif
> -#if IS_ENABLED(CONFIG_CRYPTO_CTS)
> +	/*
> +	 * Don't register library-based "cts(cbc(aes))" on
> architectures where
> +	 * it might block a "better" implementation from being
> instantiated via
> +	 * the "cts" template.=A0 These exclusions are temporary and
> will go away
> +	 * as the arch-optimized AES code is migrated into the
> library.
> +	 */
> +#if IS_ENABLED(CONFIG_CRYPTO_CTS) && \
> +	!(IS_ENABLED(CONFIG_ARM) || \
> +	=A0 IS_ENABLED(CONFIG_ARM64) || \
> +	=A0 IS_ENABLED(CONFIG_PPC) || \
> +	=A0 IS_ENABLED(CONFIG_S390) || \
> +	=A0 IS_ENABLED(CONFIG_SPARC))
> =A0	{
> =A0		.base.cra_name =3D "cts(cbc(aes))",
> =A0		.base.cra_driver_name =3D "cts-cbc-aes-lib",
> @@ -687,7 +698,13 @@ static struct skcipher_alg skcipher_algs[] =3D {
> =A0		.decrypt =3D crypto_aes_xctr_crypt,
> =A0	},
> =A0#endif
> -#if IS_ENABLED(CONFIG_CRYPTO_XTS)
> +	/*
> +	 * Don't register library-based "xts(aes)" on architectures
> where it
> +	 * might block a "better" implementation from being
> instantiated via the
> +	 * "xts" template.=A0 This exclusion is temporary and will go
> away when
> +	 * the library AES-XTS is optimized for SPARC.
> +	 */
> +#if IS_ENABLED(CONFIG_CRYPTO_XTS) && !IS_ENABLED(CONFIG_SPARC)
> =A0	{
> =A0		.base.cra_name =3D "xts(aes)",
> =A0		.base.cra_driver_name =3D "xts-aes-lib",
> @@ -980,7 +997,20 @@ static __maybe_unused int
> crypto_aes_ccm_decrypt(struct aead_request *req)
> =A0}
> =A0
> =A0static struct aead_alg aead_algs[] =3D {
> -#if IS_ENABLED(CONFIG_CRYPTO_GCM)
> +	/*
> +	 * Don't register library-based "gcm(aes)" and
> "rfc4106(gcm(aes))" on
> +	 * architectures where they might block a "better"
> implementation from
> +	 * being instantiated via the "gcm" and "rfc4106"
> templates.=A0 These
> +	 * exclusions are temporary and will go away as the arch-
> optimized AES
> +	 * code is migrated into the library.
> +	 */
> +#if IS_ENABLED(CONFIG_CRYPTO_GCM) && \
> +	!(IS_ENABLED(CONFIG_ARM) || \
> +	=A0 IS_ENABLED(CONFIG_ARM64) || \
> +	=A0 IS_ENABLED(CONFIG_PPC) || \
> +	=A0 IS_ENABLED(CONFIG_RISCV) || \
> +	=A0 IS_ENABLED(CONFIG_S390) || \
> +	=A0 IS_ENABLED(CONFIG_SPARC))
> =A0	{
> =A0		.base.cra_name =3D "gcm(aes)",
> =A0		.base.cra_driver_name =3D "gcm-aes-lib",
> @@ -1012,7 +1042,20 @@ static struct aead_alg aead_algs[] =3D {
> =A0		.chunksize =3D AES_BLOCK_SIZE,
> =A0	},
> =A0#endif /* CONFIG_CRYPTO_GCM */
> -#if IS_ENABLED(CONFIG_CRYPTO_CCM)
> +	/*
> +	 * Don't register library-based "ccm(aes)" on architectures
> where it
> +	 * might block a "better" implementation from being
> instantiated via the
> +	 * "ccm" template.=A0 These exclusions are temporary and will
> go away as
> +	 * the arch-optimized AES code is migrated into the library.
> +	 */
> +#if IS_ENABLED(CONFIG_CRYPTO_CCM) && \
> +	!(IS_ENABLED(CONFIG_ARM) || \
> +	=A0 IS_ENABLED(CONFIG_ARM64) || \
> +	=A0 IS_ENABLED(CONFIG_PPC) || \
> +	=A0 IS_ENABLED(CONFIG_RISCV) || \
> +	=A0 IS_ENABLED(CONFIG_S390) || \
> +	=A0 IS_ENABLED(CONFIG_SPARC) || \
> +	=A0 IS_ENABLED(CONFIG_X86))
> =A0	{
> =A0		.base.cra_name =3D "ccm(aes)",
> =A0		.base.cra_driver_name =3D "ccm-aes-lib",
>=20
> base-commit: 93f51579e7df248780214094418f205253383cc5

--=-fwsjTeomEhuBv/yMGL2B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTK1ph9OaYoND1R57zoeAEuJe36VgUCary7FAAKCRDoeAEuJe36
VklAAP0f3vnpvdFSareUN1igFY70WOg+J2x+DWz20Yq1wQ8rMAD/aerBnYv3cK12
gwLowIMO5YjA45oT4/BtBw1SlSVdQgc=
=KC2U
-----END PGP SIGNATURE-----

--=-fwsjTeomEhuBv/yMGL2B--
