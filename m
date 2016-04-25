From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC][PATCH 0/6] /dev/random - a new approach
Date: Mon, 25 Apr 2016 10:02:08 +0200
Message-ID: <2009968.Rf1hsrr5t0@tauon.atsec.com>
References: <9192755.iDgo3Omyqe@positron.chronox.de> <1499137.D4Mft7n8bh@tauon.atsec.com> <CAJU7zaJOSXefQkGb9H-uFr=Rxv16Gk=vYm60mOztS4uG=S0JcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ted Tso <tytso@mit.edu>, Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Sandy Harris <sandyinchina@gmail.com>
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:53542 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231AbcDYICL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 04:02:11 -0400
In-Reply-To: <CAJU7zaJOSXefQkGb9H-uFr=Rxv16Gk=vYm60mOztS4uG=S0JcA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 25. April 2016, 09:55:14 schrieb Nikos Mavrogiannopoulos:

Hi Nikos,

> On Thu, Apr 21, 2016 at 5:16 PM, Stephan Mueller <smueller@chronox.de=
>=20
wrote:
> >> > ... DRBG is =E2=80=9Cminimally=E2=80=9D seeded with 112^6 bits o=
f entropy.
> >> > This is commonly achieved even before user space is initiated.
> >>=20
> >> Unfortunately one of the issues of the /dev/urandom interface is t=
he
> >> fact that it may start providing random numbers even before the
> >> seeding is complete. From the above quote, I understand that this
> >> issue is not addressed by the new interface. That's a serious
> >> limitation (of the current and inherited by the new implementation=
),
> >> since most/all newly deployed systems from "cloud" images generate
> >> keys using /dev/urandom (for sshd for example) on boot, and it is
> >> unknown to these applications whether they operate with uninitiali=
zed
> >> seed.
> >=20
> > One more item to consider: If you do not want to change to use
> > getrandom(2), the LRNG provides you with another means.
>=20
> The main problem is not about willing to switch to getrandom() or not=
,
> but finding any system where getrandom() exists. Today due to libc no=
t
> having the call, we can only use /dev/urandom and applications would
> most likely continue to do so long time after getrandom() is
> introduced to libc.

Implement the syscall yourself with syscall(). If you get ENOSYS back, =
revert=20
to your old logic of seeding from /dev/urandom.

If you know you are on kernels >=3D 3.14, you could use the following s=
teps in=20
your library:

- poll /proc/sys/kernel/random/entropy_avail in spaces of, say, one sec=
ond and=20
block your seeding process until that value becomes non-zero

- if you unblock, seed from /dev/urandom and you have the guarantee of =
having=20
a /dev/urandom seeded with 128 bits.
>=20
> regards,
> Nikos


Ciao
Stephan
