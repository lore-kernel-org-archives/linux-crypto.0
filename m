From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: tcrypt: add option to not exit on success
Date: Wed, 13 May 2009 07:08:26 -0400
Message-ID: <20090513110826.GA16406@hmsreliant.think-freely.org>
References: <200905111006.32675.jarod@redhat.com> <200905121602.45960.jarod@redhat.com> <20090513003727.GA12788@localhost.localdomain> <20090513013050.GA6545@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43758 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758702AbZEMLIi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 May 2009 07:08:38 -0400
Content-Disposition: inline
In-Reply-To: <20090513013050.GA6545@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 13, 2009 at 11:30:50AM +1000, Herbert Xu wrote:
> On Tue, May 12, 2009 at 08:37:27PM -0400, Neil Horman wrote:
> >
> > > Would there be any objections to dropping the noexit parameter
> > > entirely and just making its behavior the default? It would make
> > > all users regardless of fips mode notice failures more readily.
> > > 
> > I think thats a fine idea.  Theres no reason that a user of the tcrypt module
> > can't manually rmmod it when the testing is done.  Doing it that way just seems
> > more sane to me to begin with anyway.
> 
> No, tcrypt is only a relic for correctness testing.  Its main
> purpose these days is for speed testing.  Having to rmmod it
> is silly.
> 
> There's really no need to load tcrypt for correctness testing
> anymore.
> 

Not really sure I agree with the logic here.  I agree that its pretty clear that
its major value is for quickly testing all the algorithms in a system, but
universally failing the loading of the module simply to save a few milliseconds
seems like a poor choice.  In so doing you create an alias effect, as jarod
noted between a non-existent module and a module that failed to load.  The
aliasing can be resolved, if you want to parse dmesg, but if speed is the issue
at hand, that parsing is a significant impact.  If you allow the module to load
properly, then for the cost of an rmmod, you can tell simply from the exit code
of modprobe:
1) If the module was found 
2) If the tests passed

And if the rmmod is simply to expensive for whatever reason, then for the cost
of a few k of ram taken up by the module, you can choose not to unload it.

Of course, if tcrypt is really as much of a relic as you say, perhaps that is an
argument for removing the module entirely.  Perhaps the testmgr interface could
be exported to userspace and the tcrypt tests be packaged as a userspace suite.

Regards
Neil

> Cheers,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 
