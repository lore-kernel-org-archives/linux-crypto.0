From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] crypto: catch base cipher self-test failures in fips mode
Date: Wed, 29 Apr 2009 09:34:31 -0400
Message-ID: <200904290934.32404.jarod@redhat.com>
References: <200904282111.52074.jarod@redhat.com> <200904290918.37623.jarod@redhat.com> <20090429132646.GA17481@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40135 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756744AbZD2NfT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Apr 2009 09:35:19 -0400
In-Reply-To: <20090429132646.GA17481@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 29 April 2009 09:26:46 Herbert Xu wrote:
> On Wed, Apr 29, 2009 at 09:18:37AM -0400, Jarod Wilson wrote:
> > On Wednesday 29 April 2009 09:15:07 Herbert Xu wrote:
> > > On Tue, Apr 28, 2009 at 09:11:51PM -0400, Jarod Wilson wrote:
> > > >
> > > > +notest:
> > > > +	printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);
> > > 
> > > Can notest ever get here with rc != 0?
> > 
> > Nope.
> 
> So why do we need to move it?

Oh. Hrm. Upon looking a bit harder at it, I think the only reason
would be if we wanted to print out a message claiming success in
testing ctr(aes).

There's also a devious ulterior motive for this patch, which is
to make the cryptodev tree look identical(er) to the Red Hat
Enterprise Linux 5.x kernel tree w/in alg_test()...

-- 
Jarod Wilson
jarod@redhat.com
