From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH] crypto/arc4: now arc needs blockcipher support
Date: Sun, 8 Jul 2012 19:46:24 +0200
Message-ID: <20120708174624.GD2872@breakpoint.cc>
References: <20120626161346.GB6509@breakpoint.cc>
 <20120627065247.GE22920@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33966 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279Ab2GHRq3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Jul 2012 13:46:29 -0400
Content-Disposition: inline
In-Reply-To: <20120627065247.GE22920@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 27, 2012 at 02:52:47PM +0800, Herbert Xu wrote:
> > On a side note: do we pull in the blkcipher block mode for each cip=
her now to
> > gain some extra performance like the openssl project? I was under t=
he
> > impression that is in general not worth it.
>=20
> You mean normal block ciphers? Does it really make that much
> of a difference?

Yes. Jussi added block mode for RC4 instead that auto block-mode that i=
s
prefered over the "automatic" one that is generated otherwise. I don't =
know
how much performance it brings but I would be supprised if it is a lot =
on an
average CPU. With this patch in I think it is a matter of time until we=
 get
the AES-CBC & and friends block mode optimized code (which should be a =
little
faster since comparing to calling a function call for the XOR=E2=80=A6)=
 you get the
idea.

Sebastian
