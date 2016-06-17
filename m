From: David =?UTF-8?Q?Ja=C5=A1a?= <djasa@redhat.com>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Fri, 17 Jun 2016 15:56:13 +0200
Message-ID: <1466171773.20087.66.camel@redhat.com>
References: <1466007463.20087.11.camel@redhat.com>
	 <6137456.oZ1CFC9kFY@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428AbcFQN4Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jun 2016 09:56:25 -0400
In-Reply-To: <6137456.oZ1CFC9kFY@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

thank you for your thorough reply,

On St, 2016-06-15 at 18:58 +0200, Stephan Mueller wrote:
> Am Mittwoch, 15. Juni 2016, 18:17:43 schrieb David Ja=C5=A1a:
>=20
> Hi David,
>=20
> > Hello Stephan,
> >=20
> > Did you consider blocking urandom output or returning error until
> > initialized? Given the speed of initialization you report, it shoul=
dn't
> > break any userspace apps while making sure that nobody uses predict=
able
> > pseudoranom numbers.
>=20
> My LRNG will definitely touch the beginning of the initramfs booting =
until it=20
> is fully seeded. As these days the initramfs is driven by systemd whi=
ch always=20
> pulls from /dev/urandom, we cannot block as this would block systemd.=
 In Ted's=20
> last patch, he mentioned that he tried to make /dev/urandom block whi=
ch caused=20
> user space pain.

I was thinking along the lines that "almost every important package
supports FreeBSD as well where they have to handle the condition so
option to switch to Rather Break Than Generate Weak Keys would be nice"
- but I didn't expect that systemd could be a roadblock here. :-/

I was also thinking of little devices where OpenWRT or proprietary
Linux-based systems run that ended up with predictable keys way too
ofter (or as in OpenWRT's case, with cumbersome tutorials how to
generate keys elsewhere).

>=20
> But if you use the getrandom system call, it works like /dev/urandom =
but=20
> blocks until the DRBG behind /dev/urandom is fully initialized.
> >=20
> > I was considering asking for patch (or even trying to write it myse=
lf)
> > to make current urandom block/fail when not initialized but that wo=
uld
> > surely have to be off by default over "never break userspace" rule =
(even
> > if it means way too easy security problem with both random and uran=
dom).
> > Properties of your urandom implementation makes this point moot and=
 it
> > could make the random/urandom wars over.
>=20
> That patch unfortunately will not work. But if you are interested in =
that=20
> blocking /dev/urandom behavior for your application, use getrandom.
>=20

I'm QA with a touch of sysadmin so the numbers of apps to fix is large
and I don't have neither control over the projects nor abilities to
patch them all myself. :)

> >=20
> > Best Regards,
> >=20
> > David Ja=C5=A1a
>=20
>=20
> Ciao
> Stephan

BTW when looking at an old BSI's issue with Linux urandom that Jarod
Wilson tried to solve with this series:
https://www.spinics.net/lists/linux-crypto/msg06113.html
I was thinking:
1) wouldn't it help for large urandom consumers if kernel created a DRB=
G
instance for each of them? It would likely enhance performance and solv=
e
BSI's concern of predicting what numbers could other urandom consumers
obtain at cost of memory footprint
and then, after reading paper associated with this series:
2) did you evaluate use of intermediate DRBG fed by primary generator t=
o
instantiate per-node DRBG's? It would allow initialization of all
secondary DRBGs right after primary generator initialization.

Cheers,

David
