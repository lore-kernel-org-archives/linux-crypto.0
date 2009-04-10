From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] add self-tests for rfc4309(ccm(aes))
Date: Thu, 9 Apr 2009 22:31:08 -0400
Message-ID: <20090410023108.GA7933@localhost.localdomain>
References: <200904091434.59639.jarod@redhat.com> <20090409185204.GA6758@hmsreliant.think-freely.org> <200904091516.57048.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neil Horman <nhorman@redhat.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Herbert Xu <herbert.xu@redhat.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43380 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbZDJCbP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Apr 2009 22:31:15 -0400
Content-Disposition: inline
In-Reply-To: <200904091516.57048.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 09, 2009 at 03:16:53PM -0400, Jarod Wilson wrote:
> On Thursday 09 April 2009 14:52:04 Neil Horman wrote:
> > On Thu, Apr 09, 2009 at 02:34:59PM -0400, Jarod Wilson wrote:
> > > Patch is against current cryptodev-2.6 tree, successfully tested via
> > > 'modprobe tcrypt type=45'. The number of test vectors might be a bit
> > > excessive, but I tried to hit a wide range of combinations of varying
> > > key sizes, associate data lengths, input lengths and pass/fail.
> > > 
> > > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > > 
> > >  
> > ><snip>
> > 
> > > +/*
> > > + * rfc4309 says section 8 contains test vectors, only, it doesn't, and NIST
> > > + * Special Publication 800-38C's test vectors use nonce lengths our rfc4309
> > > + * implementation doesn't support. The following are taken from fips cavs
> > > + * fax files on hand at Red Hat.
> > > + *
> > > + * nb: actual key lengths are (klen - 3), the last 3 bytes are actually
> > > + * part of the nonce which combine w/the iv, but need to be input this way.
> > > + */
> > 
> > RFC4309 section 8 actually says the test vectors you can use are here:
> > http://www.ietf.org/rfc/rfc3610.txt
> > in RFC3610 section 8.
> 
> Oh, I'm dense, didn't correctly parse that 4309 was referring back to 3610
> for the actual test vectors. I'll see what I can do with those...
> 
Its easy to miss.  It referrs to the RFC in an endnote by reference.

> > I don't think theres anything wrong with the vectors
> > your're using below, but you may want to add the vectors from 3610 just to
> > imrpove the testing.
> 
> I think I'd drop some of the ones in the initial patch in favor of adding
> some from 3610, rather than simply adding more. The coverage is already
> pretty good, increasing the number of vectors shouldn't really be necessary,
> but it would definitely be nice to have vectors that are already publicly
> published and verified.
> 
ACK to that.

> 
