From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: catch base cipher self-test failures in fips
	mode
Date: Wed, 29 Apr 2009 21:26:46 +0800
Message-ID: <20090429132646.GA17481@gondor.apana.org.au>
References: <200904282111.52074.jarod@redhat.com> <20090429131506.GA17254@gondor.apana.org.au> <200904290918.37623.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43702 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753109AbZD2N0t (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Apr 2009 09:26:49 -0400
Content-Disposition: inline
In-Reply-To: <200904290918.37623.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 29, 2009 at 09:18:37AM -0400, Jarod Wilson wrote:
> On Wednesday 29 April 2009 09:15:07 Herbert Xu wrote:
> > On Tue, Apr 28, 2009 at 09:11:51PM -0400, Jarod Wilson wrote:
> > >
> > > +notest:
> > > +	printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);
> > 
> > Can notest ever get here with rc != 0?
> 
> Nope.

So why do we need to move it?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
