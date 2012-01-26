From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Crypto Fixes for 3.3
Date: Wed, 25 Jan 2012 20:16:54 -0800
Message-ID: <CA+55aFwQ=KybWO6cgQLsWajF2-S9ndh2um_qmA8VP-mmdRCH7Q@mail.gmail.com>
References: <20100716022648.GA28219@gondor.apana.org.au> <20100722055043.GA25689@gondor.apana.org.au>
 <20100903060055.GA28915@gondor.apana.org.au> <20100903110722.GA31826@gondor.apana.org.au>
 <20101215115035.GA25248@gondor.apana.org.au> <20110216053911.GA10999@gondor.apana.org.au>
 <20110328071322.GA6569@gondor.apana.org.au> <20110629235153.GA16559@gondor.apana.org.au>
 <20120126024342.GA12492@gondor.apana.org.au> <CA+55aFzFecPSQverH7VQBDZY+gS7_RALwh3W4oqWLbWBcBzLqg@mail.gmail.com>
 <20120126040704.GA13369@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39112 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab2AZERO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Jan 2012 23:17:14 -0500
In-Reply-To: <20120126040704.GA13369@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 25, 2012 at 8:07 PM, Herbert Xu <herbert@gondor.apana.org.a=
u> wrote:
>
> Oops, I had incorrectly applied the first patch in the thread.
>
> I've fixed it in the tree now.

Oh well, I already pulled your tree. I just wanted to voice a few
comments on it.

>> We also avoid the problem with absolutely horrible gcc register usag=
e
>> by having an arch-specific "accessor macro":
>
> We could certainly do something like that. =A0Although I'd be
> more comfortable with pushing this through linux-next, OK?

Absolutely.

               Linus
