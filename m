From: "Hsieh, Che-Min" <cheminh@qti.qualcomm.com>
Subject: RE: questions of crypto async api
Date: Mon, 8 Apr 2013 13:49:58 +0000
Message-ID: <A83C99F8370D4D42BEB2D2B3153A6BBC23CDC1C3@NASANEXD02C.na.qualcomm.com>
References: <A83C99F8370D4D42BEB2D2B3153A6BBC23CDB94D@NASANEXD02C.na.qualcomm.com>
 <20130405173320.bed824d33bb493e8f5015835@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58230 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935885Ab3DHNt7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Apr 2013 09:49:59 -0400
In-Reply-To: <20130405173320.bed824d33bb493e8f5015835@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks for the answer.

I have further question on the same subject.
With regard to the commit in talitos.c, (attached at end of this mail),=
 =20
  the driver submits requests of same tfm to the same channel to ensure=
 the ordering. =20

Is it because the tfm context needs to be maintained from one operation=
 to next operation? Eg, aead_givencrypt() generates iv based on previou=
s iv result stored in tfm.

If requests are sent to different channels dynamically. And driver at t=
he completion of a request from HW, reorders the requests completion ca=
llback, what would happen?=20

Thanks in advance.

Chemin



commit 5228f0f79e983c2b39c202c75af901ceb0003fc1
Author: Kim Phillips <kim.phillips@freescale.com>
Date:   Fri Jul 15 11:21:38 2011 +0800

    crypto: talitos - ensure request ordering within a single tfm

    Assign single target channel per tfm in talitos_cra_init instead of
    performing channel scheduling dynamically during the encryption req=
uest.
    This changes the talitos_submit interface to accept a new channel
    number argument.  Without this, rapid bursts of misc. sized request=
s
    could make it possible for IPsec packets to be encrypted out-of-ord=
er,
    which would result in packet drops due to sequence numbers falling
    outside the anti-reply window on a peer gateway.

    Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

-----Original Message-----
=46rom: Kim Phillips [mailto:kim.phillips@freescale.com]=20
Sent: Friday, April 05, 2013 6:33 PM
To: Hsieh, Che-Min
Cc: linux-crypto@vger.kernel.org
Subject: Re: questions of crypto async api

On Thu, 4 Apr 2013 14:38:41 +0000
"Hsieh, Che-Min" <cheminh@qti.qualcomm.com> wrote:

> If a driver supports multiple instances of HW crypto engines, the ord=
er of=A0the request completion from HW can be different from the order =
of requests submitted=A0to different HW.=A0 The 2nd request sent out to=
 the 2nd=A0HW instance may take shorter time to complete than the first=
 request=A0for different HW instance.=A0 Is the driver responsible for =
re-ordering the completion callout? Or the agents (such as IP protocol =
stack) are responsible for reordering? How does pcrypt do it?
>=20
> =A0Does it make sense for a transform to send multiple requests outst=
anding to async crypto api?

see:

http://comments.gmane.org/gmane.linux.kernel.cryptoapi/5350

> =A0Is scatterwalk_sg_next() preferred method over sg_next()?=A0 Why?

scatterwalk_* is the crypto subsystem's version of the function, so yes=
=2E

> =A0sg_copy_to_buffer() and sg_copy_from_buffer() ->=20
> sg_copy_buffer()->sg_copy_buffer() -> sg_miter_next()-> sg_next() Som=
etimes sg_copy_to_buffer() and sg_copy_from_buffer() in our driver do n=
ot copy the whole list. We have to rewrite those functions by using sca=
ttewalk_sg_next() to walk down the list. Is this the correct behavior?

sounds like you're on the right track, although buffers shouldn't be be=
ing copied that often, if at all.

Kim
