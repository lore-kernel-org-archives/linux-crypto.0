From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: tcrypt: add option to not exit on success
Date: Wed, 13 May 2009 11:30:50 +1000
Message-ID: <20090513013050.GA6545@gondor.apana.org.au>
References: <200905111006.32675.jarod@redhat.com> <200905121602.45960.jarod@redhat.com> <20090513003727.GA12788@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44879 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751291AbZEMBbF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 May 2009 21:31:05 -0400
Content-Disposition: inline
In-Reply-To: <20090513003727.GA12788@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 12, 2009 at 08:37:27PM -0400, Neil Horman wrote:
>
> > Would there be any objections to dropping the noexit parameter
> > entirely and just making its behavior the default? It would make
> > all users regardless of fips mode notice failures more readily.
> > 
> I think thats a fine idea.  Theres no reason that a user of the tcrypt module
> can't manually rmmod it when the testing is done.  Doing it that way just seems
> more sane to me to begin with anyway.

No, tcrypt is only a relic for correctness testing.  Its main
purpose these days is for speed testing.  Having to rmmod it
is silly.

There's really no need to load tcrypt for correctness testing
anymore.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
