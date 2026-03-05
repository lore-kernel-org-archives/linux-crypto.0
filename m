Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C3035E946
	for <linux-crypto@vger.kernel.org>; Thu,  5 Mar 2026 22:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772748394; cv=none; b=NKALa2/eIIJHm8Pa4spZayKohf8Oae6sAD5HjGR0h5swfo1FGV9MuJwkwn/0o5iHVMtnrjQ368l6oU/yIPEqvuo0giZW4fHzzNUrQeCYe5tLIfNAJEPGoG2zh5G2vEzW1jyLALCuw6n2D+o3Hn9vYfX8lhaUWfv4KHywBydJ0Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772748394; c=relaxed/simple;
	bh=eHugqbIjgLQla4/OLlxHu+L7fKAHiH2BHenO/NNYqdA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TJyJFsEayR4DJY2lmolACuzOrOYtyqkczI0QoO0Vq4ZXg9aPqPjUSCqZVKMvEh8qKvB4Ndmt3BR3Q10R3M339M7whFdAY5asNuv0eMu54QW0RrUsnNEhNuJoRvFrI9zzwO103HIMFbIX2T4UwkuANO7LzKb+ai0dRFp1f72zVmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=A5dg12i4; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="A5dg12i4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1772748391;
	bh=eHugqbIjgLQla4/OLlxHu+L7fKAHiH2BHenO/NNYqdA=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=A5dg12i4cUrYI8AQO+xz8RHuTeE3keCoDXxCz+TjRXV4+XuR3DAZZOJDlLMAArKm5
	 drvx+1t2eSrWnCmYB02V3gKmYrPDDQaJsJfBk9OUfDqL79/GI/ENfMdD/g+TRzrfnN
	 kFo0Ho/W1RqwQ6wVkUtD711m3dNAyMOGreFnMl3M=
Received: from [172.19.0.240] (unknown [75.104.94.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 9735C1C024C;
	Thu, 05 Mar 2026 17:06:23 -0500 (EST)
Message-ID: <8b645c324e2046e493f2f18ac28c6fd22ea8c598.camel@HansenPartnership.com>
Subject: Re: [PATCH v3 3/5] crypto: pkcs7: allow pkcs7_digest() to be called
 from pkcs7_trust
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Date: Thu, 05 Mar 2026 17:06:13 -0500
In-Reply-To: <20260305213651.GA64054@quark>
References: <20260225211907.7368-1-James.Bottomley@HansenPartnership.com>
	 <20260225211907.7368-4-James.Bottomley@HansenPartnership.com>
	 <20260226203133.GB2273@sol>
	 <bf8b8c374d4398a677b87246bb426c4cd157e1d0.camel@HansenPartnership.com>
	 <20260305075831.GB155793@sol>
	 <51cf814b5dd2a126c4b2379c7b7d02ff9d2e17f2.camel@HansenPartnership.com>
	 <20260305185016.GC2796@quark>
	 <8fc67a378cc379065fc187e00e728956a86c9894.camel@HansenPartnership.com>
	 <20260305213651.GA64054@quark>
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-03-05 at 13:36 -0800, Eric Biggers wrote:
> On Thu, Mar 05, 2026 at 03:11:29PM -0500, James Bottomley wrote:
> > On Thu, 2026-03-05 at 10:50 -0800, Eric Biggers wrote:
> > > On Thu, Mar 05, 2026 at 09:53:56AM -0500, James Bottomley wrote:
> > > > On Wed, 2026-03-04 at 23:58 -0800, Eric Biggers wrote:
> > > > > On Thu, Feb 26, 2026 at 10:50:10PM -0500, James Bottomley
> > > > > wrote:
> > > > > > On Thu, 2026-02-26 at 12:31 -0800, Eric Biggers wrote:
> > > > > > > On Wed, Feb 25, 2026 at 04:19:05PM -0500, James Bottomley
> > > > > > > wrote:
> > > > > > > > +	/*
> > > > > > > > +	 * if we're being called immediately after
> > > > > > > > parse,
> > > > > > > > the
> > > > > > > > +	 * signature won't have a calculated digest
> > > > > > > > yet,
> > > > > > > > so
> > > > > > > > calculate
> > > > > > > > +	 * one.=C2=A0 This function returns immediately if
> > > > > > > > a
> > > > > > > > digest
> > > > > > > > has
> > > > > > > > +	 * already been calculated
> > > > > > > > +	 */
> > > > > > > > +	pkcs7_digest(pkcs7, sinfo);
> > > > > > >=20
> > > > > > > pkcs7_digest() can fail, returning an error code and
> > > > > > > leaving
> > > > > > > sig-
> > > > > > > > m
> > > > > > > =3D=3D NULL && sig->m_size =3D=3D 0.=C2=A0 Here, the error is=
 just
> > > > > > > being
> > > > > > > ignored.
> > > > > >=20
> > > > > > That's right.=C2=A0 Basically I wasn't sure what to return on
> > > > > > error
> > > > > > (although -ENOKEY looks about right since it will cause
> > > > > > retries
> > > > > > on
> > > > > > a
> > > > > > different sig chain).
> > > > > >=20
> > > > > > > Doesn't that then cause the signature verification to
> > > > > > > proceed
> > > > > > > against an empty message, rather than anything related to
> > > > > > > the
> > > > > > > data provided?
> > > > > >=20
> > > > > > Not if sig->m is NULL, no, because the verifier will try to
> > > > > > reget the digest in that case (and error out if it fails).
> > > > >=20
> > > > > Can you point to where that happens?=C2=A0 It still looks like it
> > > > > just
> > > > > proceeds with an empty message.
> > > >=20
> > > > It's the obvious one:
> > > >=20
> > > > verify_pkcs7_message_sig->pkcs7_verify->pkcs7_verify_one-
> > > > > pkcs7_digest
> > > >=20
> > > > The latter will allocate and calculate the digest if sig->m is
> > > > null.
> > > >=20
> > > > Regards,
> > > >=20
> > > > James
> > > >=20
> > >=20
> > > But looking at hornet_check_program() from
> > > https://lore.kernel.org/linux-security-module/20251211021257.1208712-=
9-bboscaccy@linux.microsoft.com/
> > > ,
> > > it calls:
> > >=20
> > > =C2=A0=C2=A0=C2=A0 pkcs7_parse_message()
> > > =C2=A0=C2=A0=C2=A0 validate_pkcs7_trust()
> > > =C2=A0=C2=A0=C2=A0 pkcs7_get_authattr()
> > >=20
> > > The actual signature check happens in validate_pkcs7_trust(),
> > > which
> > > appears to have the issue where it can proceed with an empty
> > > message,
> > > as I mentioned.
> >=20
> > The whole design of validate_pkccs7_trust() is to validate the
> > signature only so we can trust the attributes.=C2=A0 It doesn't actuall=
y
> > verify the digest against the data, that's the job of the
> > verify_pkcs7_sig.. class of functions.=C2=A0 The original thought behin=
d
> > this was that we might not have the original data by the time we
> > came
> > to extract the OID.=C2=A0 However, it turns out we do, so the split of
> > the
> > trust functions is not really necessary..
>=20
> But surely you *do* want to verify the data as well, as that is the
> contents of the BPF program?=C2=A0 I think the API you want is something
> like verify_pkcs7_signature() extended to return your signed
> attribute as extra information on success.

No, the data has already been verified in eBPF before the hook was
called.  Because of the way the hooks work, that's a guarantee we can
rely on.

> Of course, again it would be a lot simpler if you could find a way to
> format all the information you want to sign into one message, instead
> of relying on the PKCS#7 message-within-a-message thing that is hard
> to understand and implement correctly.

Well, as I said, we have enough information to reverify if required,
but the original verification also has to happen in the way eBPF
designed it.

Regards,

James

