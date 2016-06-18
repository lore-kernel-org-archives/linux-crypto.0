From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Sat, 18 Jun 2016 10:22:28 +0200
Message-ID: <4842429.MGkO9sKMeG@positron.chronox.de>
References: <1466007463.20087.11.camel@redhat.com> <1466171773.20087.66.camel@redhat.com> <CACXcFm=ysn15Lh9Exeo8nKEAuBoZ7pB3eDesL_P_Ne3Kaxcunw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David =?utf-8?B?SmHFoWE=?= <djasa@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACXcFm=ysn15Lh9Exeo8nKEAuBoZ7pB3eDesL_P_Ne3Kaxcunw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 17. Juni 2016, 11:26:23 schrieb Sandy Harris:

Hi Sandy,

> David Ja=C5=A1a <djasa@redhat.com> wrote:
> > BTW when looking at an old BSI's issue with Linux urandom that Jaro=
d
> > Wilson tried to solve with this series:
> > https://www.spinics.net/lists/linux-crypto/msg06113.html
> > I was thinking:
> > 1) wouldn't it help for large urandom consumers if kernel created a=
 DRBG
> > instance for each of them? It would likely enhance performance and =
solve
> > BSI's concern of predicting what numbers could other urandom consum=
ers
> > obtain at cost of memory footprint
> > and then, after reading paper associated with this series:
> > 2) did you evaluate use of intermediate DRBG fed by primary generat=
or to
> > instantiate per-node DRBG's? It would allow initialization of all
> > secondary DRBGs right after primary generator initialization.
>=20
> Theodore Ts'o, the random maintainer, already has a patch that
> seems to deal with this issue. He has posted more than one
> version & I'm not sure this is the best or latest, but ...
> https://lkml.org/lkml/2016/5/30/22

His latest patch set that he mentioned to appear in 4.8 covers a per-NU=
MA DRNG=20
where there is a "primary" /dev/urandom DRNG where secondary DRNGs for =
the=20
NUMA nodes are spawned from.


Ciao
Stephan
