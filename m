From: Jamie Heilman <jamie@audible.transient.net>
Subject: Re: v4.6-rc1 regression bisected, Problem loading in-kernel X.509
 certificate (-2)
Date: Tue, 3 May 2016 17:26:23 +0000
Message-ID: <20160503172623.GD20775@cucamonga.audible.transient.net>
References: <20160430083248.GA20775@cucamonga.audible.transient.net>
 <20160503071206.GB16446@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160503071206.GB16446@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Herbert Xu wrote:
> On Sat, Apr 30, 2016 at 08:32:48AM +0000, Jamie Heilman wrote:
> > I usually build my kernels to require module signatures and use
> > automatic signing.  As of v4.6-rc1 I'm getting this on boot:
> > 
> > Problem loading in-kernel X.509 certificate (-2)
> > 
> > I bisected that to commit d43de6c780a84def056afaf4fb3e66bdaa1efc00
> > (akcipher: Move the RSA DER encoding check to the crypto layer)
> > 
> > For some reason after this commit my system keyring always ends up
> > empty.  I use the deb-pkg make target.  My kernel config can
> > be found at
> > http://audible.transient.net/~jamie/k/modsign.config-4.6.0-rc5-guest
> > 
> > Let me know if you need anything else.
> 
> David, any ideas on this problem? If we can't get a quick fix
> on this then we'll have to revert.
> 
> Jamie, does reverting this patch by itself resolve the problem?

Haven't tried that, given the nature of the change I just assumed
it would break too much, but I'll give it a shot this evening after
work.

-- 
Jamie Heilman                     http://audible.transient.net/~jamie/
