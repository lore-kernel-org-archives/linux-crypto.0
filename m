From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: sha384 self-test failure oddity
Date: Tue, 16 Jun 2009 21:22:50 +1000
Message-ID: <20090616112250.GA13218@gondor.apana.org.au>
References: <20090602051027.GA24415@gondor.apana.org.au> <200906020901.42920.jarod@redhat.com> <20090602132038.GA29795@gondor.apana.org.au> <200906021541.34774.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44890 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754326AbZFPLWu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2009 07:22:50 -0400
Content-Disposition: inline
In-Reply-To: <200906021541.34774.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 02, 2009 at 03:41:34PM -0400, Jarod Wilson wrote:
> On Tuesday 02 June 2009 09:20:38 Herbert Xu wrote:
> > On Tue, Jun 02, 2009 at 09:01:42AM -0400, Jarod Wilson wrote:
> > >
> > > > I can't reproduce this with 2.6.30-rc7.
> > > 
> > > I'll rebase my cryptodev tree to 2.6.30-rcX and see if I can still
> > > reproduce the problem.
> > 
> > I just rebased cryptodev against 2.6.30-rc7 today so please let
> > me know whether you can still reproduce it with cryptodev.
> 
> Still happens after the rebase. Kernel config here, if it helps:
> 
> http://jwilson.fedorapeople.org/misc/cryptodev-2.6-config

Sorry, I still have no luck in reproducing this.  I used the current
linux-2.6 which has the cryptodev tree merged, and the crypto bits from
your config file.

Any chance you can let me log onto your system to have a look?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
