From: Stephan Mueller <smueller@chronox.de>
Subject: Re: cipher implementations allowed to sleep?
Date: Thu, 31 Mar 2016 11:39:23 +0200
Message-ID: <76813960.D08iDPCg0d@tauon.atsec.com>
References: <8342050.C1sDSzNQxT@tauon.atsec.com> <20160331092106.GA28538@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33832 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756979AbcCaJj0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Mar 2016 05:39:26 -0400
In-Reply-To: <20160331092106.GA28538@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 31. M=E4rz 2016, 17:21:06 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Mar 31, 2016 at 11:18:48AM +0200, Stephan Mueller wrote:
> > Hi Herbert,
> >=20
> > is it allowed that cipher implementations sleep? The driver of my q=
uestion
> > is whether I can use spin_lock_irqsave() as a lock around a cipher
> > operation.
> >=20
> > The cipher operations in question are hashing, HMACing and symmetri=
c
> > ciphers.
> Whether they can sleep is controlled by the MAY_SLEEP flag.
>=20
> Of course, even if they can't sleep, if you invoke an async op
> then it may return -EINPROGRESS and continue the processing in
> the background.

Right, I was always thinking about sync invocations.

Thanks.

Ciao
Stephan
