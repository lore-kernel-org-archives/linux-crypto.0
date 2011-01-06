From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Subject: Re: Crypto Update for 2.6.38
Date: Fri, 7 Jan 2011 01:02:25 +0200
Message-ID: <201101070102.26927.mihai.dontu@gmail.com>
References: <20081225002020.GA2912@gondor.apana.org.au> <20110106211645.GA26184@gondor.apana.org.au> <4D26381A.8040901@gnu.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Pavel Roskin <proski@gnu.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D26381A.8040901@gnu.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thursday 06 January 2011 23:46:02 Pavel Roskin wrote:
> On 01/06/2011 04:16 PM, Herbert Xu wrote:
> > This is also why only hash and skcipher are supported as they
> > are the main algorithm types supported by teh current async
> > drivers in the kernel.
>=20
> Are there any chances AEAD will be supported?  Is the API extendable =
to
> allow that?
>=20
> If I remember correctly, the original patch was simply a port of Free=
BSD
> /dev/crypto, which doesn't support AEAD.

If it's meant to work like the FreeBSD /dev/crypto, then maybe this[1] =
paper=20
is worth mentionning, which includes some performance numbers. There wa=
s a=20
single thing that drew my attention, from "Drawbacks and problems [of=20
userspace crypto]": "Lots of scary code-duplication".

[1] http://www.paeps.cx/pubs/crypto_acceleration/slides.pdf

--=20
Mihai Don=C8=9Bu
