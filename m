Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EC21607BC;
	Mon,  1 Jul 2024 14:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719845350; cv=none; b=lT6LI2IEdh2oD6Tkzdebk0wUTIo/2XmQNdfl4ZG4mPqDYY3t8Jm1TEySi+CKUUQZhQHqCVcJRUEhQtp6gaXrufH3VJyk67lbVeh4Q6p/zOD7tIptc6QsOM+WVfSk/RenVaeBt05QXvThv9EM6aGots6NrDNiiPxTmOFUutxDsfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719845350; c=relaxed/simple;
	bh=WkCL1ZtXbT20Twn70fncPAHJFSJUbJU+HY43NH4uONA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jXQmNPwchbV8SJgQoRpn8K0VMG29BVogFjQen63iJzyVo2tMjQaF53CLTjsD833N5DG0WehowpzytTitYSSUVIXKuC+7khsmizaG5vws2bStWo2afQTUXZBk50WT0El5j2PikIpkDs+C52MqNdrtkSmjJxFyCF6OzSWBQygBSqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xa5MFv80; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xa5MFv80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74B0C116B1;
	Mon,  1 Jul 2024 14:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719845349;
	bh=WkCL1ZtXbT20Twn70fncPAHJFSJUbJU+HY43NH4uONA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xa5MFv80r+4pAPDZ5fyHk1iGI4kOHFt343DZEg4Yy6s8Dl4j8lbAGjdYaCnuI0gDi
	 nJeWJTNtf4l+8WZYAlNPwtZrpdQdG2N6EfUXvVeoBL83YXQ1cFzD5DFVZmTNBvIhBb
	 tg/dgDUelSRBKlJq81Sy/Zvv/JuRc8zXAbOLXpKbUt2FrxDC4RY1eEC17EnBYTpArG
	 ppjYqec/7UrVU4VwSbxb5bG1Q3I9aKA/V+oeZvePLmGprGPT+5HpICDbAgxr2oFWS4
	 JDxRfG9rucDW3Oq7hOpAwQYyb+7MlAHJES6T++BcRyCn5K4jVF8swSntvRIMfE1rpR
	 v1ramUBN/WP+g==
Date: Mon, 1 Jul 2024 15:49:05 +0100
From: Conor Dooley <conor@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>,
	stefanb@linux.ibm.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Warning at crypto/testmgr.c:5900, while booting to OS
Message-ID: <20240701-stress-mongrel-0ce4b3fdcff7@spud>
References: <25d1a371-a4be-41d9-a3ad-f97bd9348dbc@linux.vnet.ibm.com>
 <85c8e8095d22db8923c10a180d9e91c61ae64c54.camel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GovKvsg7izfMYmHO"
Content-Disposition: inline
In-Reply-To: <85c8e8095d22db8923c10a180d9e91c61ae64c54.camel@kernel.org>


--GovKvsg7izfMYmHO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Just a passer-by...

On Mon, Jul 01, 2024 at 02:45:28PM +0000, Jarkko Sakkinen wrote:
> On Wed, 2024-06-12 at 12:16 +0530, Venkat Rao Bagalkote wrote:
> > This issue is being caused by the patch: 2fd2a82ccbfc106aec314db6c4bda5=
e24fd32a22.
> >=20
> > After reverting the above patch, issue is not seen.
>=20
> $ git show 2fd2a82ccbfc106aec314db6c4bda5e24fd32a22 # [1]
> fatal: bad object 2fd2a82ccbfc106aec314db6c4bda5e24fd32a22
>=20
> Unless I made a mistake, for me it really looks like that the commit is
> non-existent.

It's in linux-next I think:
commit 2fd2a82ccbfc106aec314db6c4bda5e24fd32a22
Author: Stefan Berger <stefanb@linux.ibm.com>
Date:   Wed May 29 19:08:26 2024 -0400

    crypto: ecdsa - Use ecc_digits_from_bytes to create hash digits array
   =20
    Since ecc_digits_from_bytes will provide zeros when an insufficient num=
ber
    of bytes are passed in the input byte array, use it to create the hash
    digits directly from the input byte array. This avoids going through an
    intermediate byte array (rawhash) that has the first few bytes filled w=
ith
    zeros.
   =20
    Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
    Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

--GovKvsg7izfMYmHO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZoLB4QAKCRB4tDGHoIJi
0tlGAP9V/MbdSdhA0ynV6By+bRXnk+lgwN/zvO5VN4z2eGFTIAEAkOTA+xrWLiim
aTTlPig2K3zuRNEBCiRdbMzEsTh4rQA=
=xjdV
-----END PGP SIGNATURE-----

--GovKvsg7izfMYmHO--
