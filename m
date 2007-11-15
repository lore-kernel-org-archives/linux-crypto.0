From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: IV copy strategy
Date: Thu, 15 Nov 2007 22:10:05 +0100
Message-ID: <20071115211005.GA21159@Chamillionaire.breakpoint.cc>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc> <20071114142253.GA15201@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:56777 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933386AbXKOVKK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Nov 2007 16:10:10 -0500
Content-Disposition: inline
In-Reply-To: <20071114142253.GA15201@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-11-14 22:22:53 [+0800]:

>Indeed the last call to blkcipher_walk_done will free the IV if
>we had to copy it due to an alignment mismatch.  Since geode has
>an alignment of 16 bytes, that's almost a given.
Ach

>You could copy from/to desc->info instead which would solve the
>problem.
>
>However, why does op->iv exist at all? Surely we can just use
>walk->iv directly and the problem goes away completely?
Yes, you are absolutely right. I get rid of op->iv and copy the IV back
to walk->iv in the crypt function (where I have to do it anyway).

In this case, the s390 has the same bug (they copy the IV back after
blkcipher_walk_done()). Howevere it will probably never get triggered
because they have an aligment of 0 (what gets pushed to 3 by the crypto
API if I remenber correcrtly). 
So a general question: Is it a must (requirement by the crypto API) to
copy the IV back or not? I guess not if we move completely to async (one
day) :)

>
>Cheers,

Sebastian
