From: Stephan Mueller <smueller@chronox.de>
Subject: Re: cipher implementations allowed to sleep?
Date: Thu, 31 Mar 2016 15:02:03 +0200
Message-ID: <9479344.AexDexa4Nc@tauon.atsec.com>
References: <8342050.C1sDSzNQxT@tauon.atsec.com> <5387862.2PP9F0yuod@tauon.atsec.com> <20160331125825.GA30134@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33842 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756238AbcCaNCI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Mar 2016 09:02:08 -0400
In-Reply-To: <20160331125825.GA30134@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 31. M=E4rz 2016, 20:58:25 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Mar 31, 2016 at 01:47:50PM +0200, Stephan Mueller wrote:
> > Considering the implementation in ansi_cprng.c, is it allowed to us=
e
> > spin_lock_bh with the sync operations assuming that a cipher
> > implementation
> > may sleep?
>=20
> As I said, it's only allowed to sleep if you set the MAY_SLEEP
> flag.

Now I see, I as a caller can controll whether it can sleep. Thank you.

Ciao
Stephan
