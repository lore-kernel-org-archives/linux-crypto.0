From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 3/6] crypto: Linux Random Number Generator
Date: Sun, 24 Apr 2016 09:43:20 -0700
Message-ID: <1461516200.2726.73.camel@perches.com>
References: <1589319.WyasadRQQe@positron.chronox.de>
	 <4513249.IuhZztB3y6@positron.chronox.de>
	 <1461497424.2726.55.camel@perches.com>
	 <1907949.voNH4FmKbt@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, Theodore Tso <tytso@mit.edu>,
	sandyinchina@gmail.com, Jason Cooper <jason@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0233.hostedemail.com ([216.40.44.233]:48344 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752818AbcDXQnZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 24 Apr 2016 12:43:25 -0400
In-Reply-To: <1907949.voNH4FmKbt@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 2016-04-24 at 16:12 +0200, Stephan Mueller wrote:
> Am Sonntag, 24. April 2016, 04:30:24 schrieb Joe Perches:
> > On Sun, 2016-04-24 at 12:40 +0200, Stephan Mueller wrote:
> > > The LRNG with all its properties is documented in [1]. This
> > > documentation covers the functional discussion as well as testing=
 of all
> > > aspects of entropy processing. In addition, the documentation exp=
lains
> > > the conducted regression tests to verify that the LRNG is API and=
 ABI
> > > compatible with the legacy /dev/random implementation.
> > > [1] http://www.chronox.de/lrng.html
> > Links get stale.
> > It may be better to put an ascii version of the pdf
> > in Documentation/ and the test code in tools/
> I surely can do that. What would you think would be the proper locati=
on to add=A0
> such documentation? Simply Documentation/lrng.txt?
>=20
> How would you propose to handle the pictures (at least the big pictur=
e)?

I think figure 2.1 could look ok using something like asciio.
http://search.cpan.org/dist/App-Asciio/lib/App/Asciio.pm

> Regarding the tests: those are no regression tests, but tests to allo=
w other=A0
> researches to verify whether the LRNG operates appropriately. Thus, w=
ould=A0
> adding it to a new directory of tools/crypto/rng be appropriate?

Whatever you think best would be fine with me.

> > > +	pr_info(DRIVER_NAME": deactivating initial RNG - %d bytes deliv=
ered",
> > > +		atomic_read(&lrng_initrng_bytes));
> > Should use \n to terminate the format.
> Thank you, fixed. Though, I am wondering why I do see the line feed i=
n dmesg.=A0

The kernel will add a newline to dmesg output whenever a new
KERN_<LEVEL> is used, but there can be unprefixed content or
KERN_CONT uses from another thread before another message
that can unintentionally extend an old message without a
newline termination.

cheers, Joe
