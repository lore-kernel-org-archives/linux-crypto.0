From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Wed, 15 Jun 2016 18:58:50 +0200
Message-ID: <6137456.oZ1CFC9kFY@positron.chronox.de>
References: <1466007463.20087.11.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: David =?utf-8?B?SmHFoWE=?= <djasa@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36568 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbcFOQ6y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 12:58:54 -0400
In-Reply-To: <1466007463.20087.11.camel@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 15. Juni 2016, 18:17:43 schrieb David Ja=C5=A1a:

Hi David,

> Hello Stephan,
>=20
> Did you consider blocking urandom output or returning error until
> initialized? Given the speed of initialization you report, it shouldn=
't
> break any userspace apps while making sure that nobody uses predictab=
le
> pseudoranom numbers.

My LRNG will definitely touch the beginning of the initramfs booting un=
til it=20
is fully seeded. As these days the initramfs is driven by systemd which=
 always=20
pulls from /dev/urandom, we cannot block as this would block systemd. I=
n Ted's=20
last patch, he mentioned that he tried to make /dev/urandom block which=
 caused=20
user space pain.

But if you use the getrandom system call, it works like /dev/urandom bu=
t=20
blocks until the DRBG behind /dev/urandom is fully initialized.
>=20
> I was considering asking for patch (or even trying to write it myself=
)
> to make current urandom block/fail when not initialized but that woul=
d
> surely have to be off by default over "never break userspace" rule (e=
ven
> if it means way too easy security problem with both random and urando=
m).
> Properties of your urandom implementation makes this point moot and i=
t
> could make the random/urandom wars over.

That patch unfortunately will not work. But if you are interested in th=
at=20
blocking /dev/urandom behavior for your application, use getrandom.

>=20
> Best Regards,
>=20
> David Ja=C5=A1a


Ciao
Stephan
