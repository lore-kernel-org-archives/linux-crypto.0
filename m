From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2] crypto: memzero_explicit - make sure to clear out
 sensitive data
Date: Mon, 8 Sep 2014 09:00:36 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1409080859100.2406@hadrien>
References: <1410125018-27277-1-git-send-email-dborkman@redhat.com> <1410157025.11627.10.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Daniel Borkmann <dborkman@redhat.com>, herbert@gondor.apana.org.au,
	tytso@mit.edu, linux-crypto@vger.kernel.org, gmazyland@gmail.com
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:48430
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751891AbaIHHAu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Sep 2014 03:00:50 -0400
In-Reply-To: <1410157025.11627.10.camel@localhost>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On Mon, 8 Sep 2014, Hannes Frederic Sowa wrote:

> On So, 2014-09-07 at 23:23 +0200, Daniel Borkmann wrote:
> > Recently, in commit 13aa93c70e71 ("random: add and use memzero_explicit()
> > for clearing data"), we have found that GCC may optimize some memset()
> > cases away when it detects a stack variable is not being used anymore
> > and going out of scope. This can happen, for example, in cases when we
> > are clearing out sensitive information such as keying material or any
> > e.g. intermediate results from crypto computations, etc.
> >
> > With the help of Coccinelle, we can figure out and fix such occurences
> > in the crypto subsytem as well. Julia Lawall provided the following
> > Coccinelle program:
> >
> >   @@
> >   type T;
> >   identifier x;
> >   @@
> >
> >   T x;
> >   ... when exists
> >       when any
> >   -memset
> >   +memzero_explicit
> >      (&x,
> >   -0,
> >      ...)
> >   ... when != x
> >       when strict
> >
> >   @@
> >   type T;
> >   identifier x;
> >   @@
> >
> >   T x[...];
> >   ... when exists
> >       when any
> >   -memset
> >   +memzero_explicit
> >      (x,
> >   -0,
> >      ...)
> >   ... when != x
> >       when strict
>
> I think this Coccinelle patch won't make it completely unnecessary for a
> manual audit as it does not take optimizations (dead code eliminitation)
> into account?

I agree.  If you see something else that could be taken into account in
the semantic patch, please let me know.

julia


>
> >
> > Therefore, make use of the drop-in replacement memzero_explicit() for
> > exactly such cases instead of using memset().
> >
> > Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> > Cc: Julia Lawall <julia.lawall@lip6.fr>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: Theodore Ts'o <tytso@mit.edu>
> > Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
>
> Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org
>
> Thanks,
> Hannes
>
>
>
