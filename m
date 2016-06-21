From: David =?UTF-8?Q?Ja=C5=A1a?= <djasa@redhat.com>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Tue, 21 Jun 2016 14:25:36 +0200
Message-ID: <1466511936.9421.18.camel@redhat.com>
References: <1466007463.20087.11.camel@redhat.com>
	 <6137456.oZ1CFC9kFY@positron.chronox.de>
	 <1466171773.20087.66.camel@redhat.com> <20160618144408.GA5344@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephan Mueller <smueller@chronox.de>,
	Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbcFUMZn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 08:25:43 -0400
In-Reply-To: <20160618144408.GA5344@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On So, 2016-06-18 at 10:44 -0400, Theodore Ts'o wrote:
> On Fri, Jun 17, 2016 at 03:56:13PM +0200, David Ja=C5=A1a wrote:
> > I was thinking along the lines that "almost every important package
> > supports FreeBSD as well where they have to handle the condition so
> > option to switch to Rather Break Than Generate Weak Keys would be n=
ice"
> > - but I didn't expect that systemd could be a roadblock here. :-/
>=20
> It wasn't just systemd; it also broke OpenWRT and Ubuntu Quantal
> systems from booting.
>=20
> > I was also thinking of little devices where OpenWRT or proprietary
> > Linux-based systems run that ended up with predictable keys way too
> > ofter (or as in OpenWRT's case, with cumbersome tutorials how to
> > generate keys elsewhere).
>=20
> OpenWRT and other embedded devices (a) generally use a single master
> oscillator to drive everything, and (b) often use RISC architectures
> such as MIPS.
>=20
> Which means that arguments of the form ``the Intel L1 / L2 cache
> architecture is ****soooo**** complicated that no human could possibl=
y
> figure out how they would affect timing calculations, and besides, my
> generator passes FIPS 140-2 tests (never mind AES(NSA_KEY, CNTR++)

this

> also passes the FIPS 140-2 statistical tests)'' --- which I normally
> have trouble believing --- are even harder for me to believe.
>=20
> At the end of the day, with these devices you really badly need a
> hardware RNG. =20

and this.

It seems much easier to me to embed AES(NSA_KEY, CNTR++) logic directly
to HW RNG compared to tweaking of every microarchitecture to make
jitter/maxwell/havege return known numbers that are going to be mixed
with other entropy anyway (won't they?). So if I put the bits together
correctly, HW RNG helps getting more random numbers but itself is
insufficient to ensure that random numbers are truly random...

Cheers,

David Ja=C5=A1a

> We can't generate randomness out of thin air.  The only
> thing you really can do requires user space help, which is to generat=
e
> keys lazily, or as late as possible, so you can gather as much entrop=
y
> as you can --- and to feed in measurements from the WiFi (RSSI
> measurements, MAC addresses seen, etc.)  This won't help much if you
> have an FBI van parked outside your house trying to carry out a
> TEMPEST attack, but hopefully it provides some protection against a
> remote attacker who isn't try to carry out an on-premises attack.
>=20
> Cheers,
>=20
> 						- Ted
