From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: questions of crypto async api
Date: Mon, 8 Apr 2013 20:19:00 -0500
Message-ID: <20130408201900.b5fc071739e698c3e7ea6bcb@freescale.com>
References: <A83C99F8370D4D42BEB2D2B3153A6BBC23CDB94D@NASANEXD02C.na.qualcomm.com>
	<20130405173320.bed824d33bb493e8f5015835@freescale.com>
	<A83C99F8370D4D42BEB2D2B3153A6BBC23CDC1C3@NASANEXD02C.na.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Hsieh, Che-Min" <cheminh@qti.qualcomm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:11218
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936057Ab3DIBWb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Apr 2013 21:22:31 -0400
In-Reply-To: <A83C99F8370D4D42BEB2D2B3153A6BBC23CDC1C3@NASANEXD02C.na.qualcomm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 8 Apr 2013 13:49:58 +0000
"Hsieh, Che-Min" <cheminh@qti.qualcomm.com> wrote:

> Thanks for the answer.
>=20
> I have further question on the same subject.
> With regard to the commit in talitos.c, (attached at end of this mail=
), =20
>   the driver submits requests of same tfm to the same channel to ensu=
re the ordering. =20
>=20
> Is it because the tfm context needs to be maintained from one operati=
on to next operation? Eg, aead_givencrypt() generates iv based on previ=
ous iv result stored in tfm.

is that what the commit text says?

> If requests are sent to different channels dynamically. And driver at=
 the completion of a request from HW, reorders the requests completion =
callback, what would happen?=20

about the same thing as wrapping the driver with pcrypt?  why not
use the h/w to maintain ordering?

Kim

> Thanks in advance.
>=20
> Chemin
>=20
>=20
>=20
> commit 5228f0f79e983c2b39c202c75af901ceb0003fc1
> Author: Kim Phillips <kim.phillips@freescale.com>
> Date:   Fri Jul 15 11:21:38 2011 +0800
>=20
>     crypto: talitos - ensure request ordering within a single tfm
>=20
>     Assign single target channel per tfm in talitos_cra_init instead =
of
>     performing channel scheduling dynamically during the encryption r=
equest.
>     This changes the talitos_submit interface to accept a new channel
>     number argument.  Without this, rapid bursts of misc. sized reque=
sts
>     could make it possible for IPsec packets to be encrypted out-of-o=
rder,
>     which would result in packet drops due to sequence numbers fallin=
g
>     outside the anti-reply window on a peer gateway.
>=20
>     Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>=20
> -----Original Message-----
> From: Kim Phillips [mailto:kim.phillips@freescale.com]=20
> Sent: Friday, April 05, 2013 6:33 PM
> To: Hsieh, Che-Min
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: questions of crypto async api
>=20
> On Thu, 4 Apr 2013 14:38:41 +0000
> "Hsieh, Che-Min" <cheminh@qti.qualcomm.com> wrote:
>=20
> > If a driver supports multiple instances of HW crypto engines, the o=
rder of=A0the request completion from HW can be different from the orde=
r of requests submitted=A0to different HW.=A0 The 2nd request sent out =
to the 2nd=A0HW instance may take shorter time to complete than the fir=
st request=A0for different HW instance.=A0 Is the driver responsible fo=
r re-ordering the completion callout? Or the agents (such as IP protoco=
l stack) are responsible for reordering? How does pcrypt do it?
> >=20
> > =A0Does it make sense for a transform to send multiple requests out=
standing to async crypto api?
>=20
> see:
>=20
> http://comments.gmane.org/gmane.linux.kernel.cryptoapi/5350
>=20
> > =A0Is scatterwalk_sg_next() preferred method over sg_next()?=A0 Why=
?
>=20
> scatterwalk_* is the crypto subsystem's version of the function, so y=
es.
>=20
> > =A0sg_copy_to_buffer() and sg_copy_from_buffer() ->=20
> > sg_copy_buffer()->sg_copy_buffer() -> sg_miter_next()-> sg_next() S=
ometimes sg_copy_to_buffer() and sg_copy_from_buffer() in our driver do=
 not copy the whole list. We have to rewrite those functions by using s=
cattewalk_sg_next() to walk down the list. Is this the correct behavior=
?
>=20
> sounds like you're on the right track, although buffers shouldn't be =
being copied that often, if at all.
>=20
> Kim
>=20
>=20
