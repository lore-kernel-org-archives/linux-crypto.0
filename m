From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC][PATCH 0/6] /dev/random - a new approach
Date: Thu, 21 Apr 2016 17:16:51 +0200
Message-ID: <1499137.D4Mft7n8bh@tauon.atsec.com>
References: <9192755.iDgo3Omyqe@positron.chronox.de> <CAJU7zaL26c33wApqb=S_NCP9gTZPMGnQ+DACjEi6vnXfTq6XkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ted Tso <tytso@mit.edu>, Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Sandy Harris <sandyinchina@gmail.com>
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:53002 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbcDUPQy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Apr 2016 11:16:54 -0400
In-Reply-To: <CAJU7zaL26c33wApqb=S_NCP9gTZPMGnQ+DACjEi6vnXfTq6XkA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 21. April 2016, 15:03:37 schrieb Nikos Mavrogiannopoulos=
:

Hi Nikos,
>=20
> [quote from pdf]
>=20
> > ... DRBG is =E2=80=9Cminimally=E2=80=9D seeded with 112^6 bits of e=
ntropy.
> > This is commonly achieved even before user space is initiated.
>=20
> Unfortunately one of the issues of the /dev/urandom interface is the
> fact that it may start providing random numbers even before the
> seeding is complete. From the above quote, I understand that this
> issue is not addressed by the new interface. That's a serious
> limitation (of the current and inherited by the new implementation),
> since most/all newly deployed systems from "cloud" images generate
> keys using /dev/urandom (for sshd for example) on boot, and it is
> unknown to these applications whether they operate with uninitialized
> seed.

One more item to consider: If you do not want to change to use getrando=
m(2),=20
the LRNG provides you with another means. You may use the=20
/proc/sys/kernel/random/drbg_minimally_seeded or drbg_fully_seeded bool=
eans.=20
If you poll on those, you will obtain the indication whether the second=
ary=20
DRBG feeding /dev/random is seeded with 112 bits (drbg_minimally_seeded=
 or 256=20
bits (drbg_fully_seeded).

Those two booleans are exported for exactly that purpose: allow user sp=
ace to=20
know about initial seeding status of the LRNG.

Ciao
Stephan
