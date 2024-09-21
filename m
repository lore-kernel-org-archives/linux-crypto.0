Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BAA320E;
	Sat, 21 Sep 2024 05:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726895819; cv=none; b=AhRpCnDtRt6AOMzfJ/OWMkI6BktAYv8as769h70mNFy3uqsxZ92vMbwsjYY1YSjZIVtVK/OMxE88r/OKHBvPiOWCScvuxDBzO1sV6ChHRK8bUYxnFdkaExT49D4Ai0pVn0ZBmyrG6gYlG29e+uE1K3ajrD62LXr1Av6VWR6H57Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726895819; c=relaxed/simple;
	bh=ScQl6UYtagc5vPNtjCqcvlPuXz//URKuWT/fOGD5SFo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZmGVm8saB313DlgjSl78ZoKuHelf8Y7zTvDvL74+cHuiDv4utHxN97pJmNZdLGhfliW3wXZBAgYgz0RI/dgw53wkSWuYQ0t1JNVAuDpwRaQAxMgGXLh5QpK9osbga4KWRydQG/Y08+XTViq2SZtXTz2FfpamLm+5+2xtjWm9dpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=Id95Uh0T; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="Id95Uh0T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1726895806;
	bh=qyx/dHX7YUt7tYPdVE5RWKeFUCXghcIpaCAzPuASVKA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Id95Uh0TMdJVZiDEBKIrjFEpwJCF9A1H/c/voUcjFf9gh5bnQcyoiu77PbCHWvM3W
	 07SUJ5XFJ8nnlFheNhmmfp67Edcp66LSRIN+sZtk6Dx7qT/FKHKN4U2uBdr9ptL2TI
	 i2l/2ihF0fwG2U1K7e+zjqDAVcGdzywGlICGZSYVoPd08ashLz7hRLEG9uP0eKD4et
	 WnrPQk8az/kxSzG1Zcx0HtL+3UahEY0p1xW2HUb5SOlfBnB+84L/VJkKd+7CUttfHS
	 hkQjphjGLYEu1d41Yc+Lds62wBd7ORIZgL4MmDam0uJX2o0Pjuqb67bI8Vw2P9H9uV
	 988q5puR1c9TQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4X9ctj1Syrz4x8Y;
	Sat, 21 Sep 2024 15:16:44 +1000 (AEST)
Date: Sat, 21 Sep 2024 15:16:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kamlesh Gurudasani <kamlesh@ti.com>
Cc: Danny Tsen <dtsen@linux.ibm.com>, <linux-crypto@vger.kernel.org>,
 <stable@vger.kernel.org>, <herbert@gondor.apana.org.au>,
 <leitao@debian.org>, <nayna@linux.ibm.com>, <appro@cryptogams.org>,
 <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
 <mpe@ellerman.id.au>, <ltcgcw@linux.vnet.ibm.com>, <dtsen@us.ibm.com>
Subject: Re: [PATCH v3] crypto: Removing CRYPTO_AES_GCM_P10.
Message-ID: <20240921151642.60b89e86@canb.auug.org.au>
In-Reply-To: <87ldzmll80.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
References: <20240919113637.144343-1-dtsen@linux.ibm.com>
	<87ldzmll80.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/jhSltXngbv+WsRpVn7yvHAs";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/jhSltXngbv+WsRpVn7yvHAs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Kamlesh,

On Fri, 20 Sep 2024 15:07:19 +0530 Kamlesh Gurudasani <kamlesh@ti.com> wrot=
e:
>
> Danny Tsen <dtsen@linux.ibm.com> writes:
>=20
> > Data mismatch found when testing ipsec tunnel with AES/GCM crypto.
> > Disabling CRYPTO_AES_GCM_P10 in Kconfig for this feature.
> >
> > Fixes: fd0e9b3e2ee6 ("crypto: p10-aes-gcm - An accelerated AES/GCM stit=
ched implementation")
> > Fixes: cdcecfd9991f ("crypto: p10-aes-gcm - Glue code for AES/GCM stitc=
hed implementation")
> > Fixes: 45a4672b9a6e2 ("crypto: p10-aes-gcm - Update Kconfig and Makefil=
e")
> >
> > Signed-off-by: Danny Tsen <dtsen@linux.ibm.com> =20
> nitpick
> checkpatch complains
> Please use correct Fixes: style 'Fixes: <12 chars of sha1> ("<title line>=
")' -
> ie: 'Fixes: 45a4672b9a6e ("crypto: p10-aes-gcm - Update Kconfig and
> Makefile")'
>=20
> There is no rule for 12 characters, but it is generally preferred.
> I guess it is just a typo for you as you have correctly added other
> Fixes tag.

It should be at least 12 hex digits i.e. more is fine.  It is possible
that some commits need more than 12 hex digits of the SHA1 to be
uniquely identified in some git repositories already.  I guess
checkpatch needs a patch.

> Also, just to understand,
>=20
> "A Fixes: tag indicates that the patch fixes an issue in a previous
>  commit. It is used to make it easy to determine where a bug originated,
>  which can help review a bug fix"
>=20
> from=20
> https://docs.kernel.org/process/submitting-patches.html
>=20
> should there not be just single Fixes tag? as bug originated from one
> commit, may be the commit that actually broke the functionality.

While we generally prefer that a patch only fix one bug, it is very
possible that the bug may have been introduced in more than one commit
e.g. in different files.

--=20
Cheers,
Stephen Rothwell

--Sig_/jhSltXngbv+WsRpVn7yvHAs
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmbuVroACgkQAVBC80lX
0GzFnwf/e23oe9Qw1Ca7dvh9xkyu30hNMVeham1rhS6bKpc17gT0szzMz8eWWdln
m4DiWnBXv3x7L07rJ22+fiEtO9N6KZMKW5PWJzEQElsBzmMJfrSwgo/eUnODTZZx
3LpE0RV0scL9+XdTaM1nOjy5nOHXG33QR3llmtXuJ/PG+RrEARjBXctl6tF/8uzp
UI8R/NmiDozwvMXb+xGaTfxemK9CDZX0HRgY28XdRlz+Tz8j3FwEJQ7vdAJanzgp
poRsA7urS2fg2KQBRVFL2oFaW/9OVWuoYmB4eXF971g0qOyBCMg8smG5n4TdRKsM
8uHloMPT9uun/CL6E4onHEIgjddfvQ==
=S5Bm
-----END PGP SIGNATURE-----

--Sig_/jhSltXngbv+WsRpVn7yvHAs--
