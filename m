From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 0/3] enhance RNG api with flags to allow for different
	operational modes
Date: Thu, 17 Sep 2009 13:08:24 -0400
Message-ID: <20090917170824.GB26276@hmsreliant.think-freely.org>
References: <20090916160456.GC11163@hmsreliant.think-freely.org> <20090917033729.GA13826@gondor.apana.org.au> <20090917124351.GA26276@hmsreliant.think-freely.org> <20090917153951.GB19535@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, jarod@redhat.com, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41252 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbZIQRI0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Sep 2009 13:08:26 -0400
Content-Disposition: inline
In-Reply-To: <20090917153951.GB19535@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 17, 2009 at 08:39:51AM -0700, Herbert Xu wrote:
> On Thu, Sep 17, 2009 at 08:43:51AM -0400, Neil Horman wrote:
> >
> > As Jarod mentioned, currently only the NIST certification vectors and, as a
> > result our testmgr vectors require disabling of the internal continuity test,
> > but to generalize from that, I would imagine that any set of certification
> > vectors that exist in the wild, may or may not assume the presence of the oth
> > iteration consumption, and this patch gives us the flexability to make use of
> > those.  I was thinking that this api extension could also be used for various
> > debugging purposes (additional flags could be created to enable internal
> > debugging, etc).
> 
> My gut feeling would be to just get rid of the test vectors.
> 
> But if you really want to keep them, please do it like CTR and
> RFC3686.  That is, have the raw RNG tested with the current vectors,
> and implement the FIPS version as a wrapper on top of it to remove
> the required bits.
> 

Just so that I'm clear on what your suggesting, you're approach would be to
register two algs in ansi_cprng, a 'raw' cprng, and a 'fips compliant cprng'
underneath that used the raw cprng as a base, but implemented the continuity
test underneath it?  If so, yeah, I can get behind that idea.  I'll spin a new
set of patches shortly.

Neil

