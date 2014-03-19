From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH cryptodev 1/4] crypto: caam - remove error propagation handling
Date: Wed, 19 Mar 2014 20:01:56 +0100
Message-ID: <201403192001.56356.marex@denx.de>
References: <1394812012-13714-1-git-send-email-horia.geanta@freescale.com> <201403171923.11855.marex@denx.de> <5329D31C.6030807@freescale.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Horia =?utf-8?q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:55866 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbaCSTMf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Mar 2014 15:12:35 -0400
In-Reply-To: <5329D31C.6030807@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday, March 19, 2014 at 06:25:48 PM, Horia Geant=C4=83 wrote:
> On 3/17/2014 8:23 PM, Marek Vasut wrote:
> > On Friday, March 14, 2014 at 04:46:49 PM, Horia Geanta wrote:
> >> Commit 61bb86bba169507a5f223b94b9176c32c84b4721
> >> ("crypto: caam - set descriptor sharing type to SERIAL")
> >> changed the descriptor sharing mode from SHARE_WAIT to SHARE_SERIA=
L.
> >>=20
> >> All descriptor commands that handle the "ok to share" and
> >> "error propagation" settings should also go away, since they have =
no
> >> meaning for SHARE_SERIAL.
> >=20
> > [...]
> >=20
> >> @@ -253,7 +236,7 @@ static int aead_set_sh_desc(struct crypto_aead
> >> *aead)
> >>=20
> >>   	/* assoclen + cryptlen =3D seqinlen - ivsize */
> >>   	append_math_sub_imm_u32(desc, REG2, SEQINLEN, IMM, tfm->ivsize)=
;
> >>=20
> >> -	/* assoclen + cryptlen =3D (assoclen + cryptlen) - cryptlen */
> >> +	/* assoclen =3D (assoclen + cryptlen) - cryptlen */
> >=20
> > This comment basically says 'x =3D x' , but it doesn't explain anyt=
hing to
> > uninformed observer. Can you fix such comments please ?
>=20
> The line under the comment is:
> append_math_sub(desc, VARSEQINLEN, REG2, REG3, CAAM_CMD_SZ);
>=20
> which translates to:
> VARSEQINLEN =3D REG2 - REG3
>=20
> The comment basically says that VARSEQINLEN gets assoclen by
> substracting REG3 =3D cryptlen from REG2 =3D assoclen + cryptlen.
>=20
> If you still think this is "cryptic", that's perfectly fine - I'll
> respin the patch.

OK, I don't get it anyway. But that's OK, I am sure the next Marek that=
 comes=20
across this code won't get it either. So I'd suggest you produce a patc=
h=20
afterwards, which cleans up the documentation ugliness in this driver. =
Would=20
that work for you?

Best regards,
Marek Vasut
