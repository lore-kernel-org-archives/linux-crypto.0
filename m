From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] crypto: tcrypt: add option to not exit on success
Date: Wed, 13 May 2009 09:37:32 -0400
Message-ID: <200905130937.33449.jarod@redhat.com>
References: <200905111006.32675.jarod@redhat.com> <200905130912.46965.jarod@redhat.com> <20090513132752.GA17262@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38184 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbZEMNiY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 May 2009 09:38:24 -0400
In-Reply-To: <20090513132752.GA17262@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 13 May 2009 09:27:52 Herbert Xu wrote:
> On Wed, May 13, 2009 at 09:12:46AM -0400, Jarod Wilson wrote:
> > 
> > Hm... FIPS has the requirement that we test all algs before we use any
> > algs, self-tests on demand before first use for each alg is
> > insufficient. At first blush, I'm not seeing how we ensure this
> > happens. How can we trigger a cbc(des3_ede) self-test from userspace?
> > I see that modprobe'ing des.ko runs the base des and des3_ede
> > self-tests, but modprobe'ing cbc.ko doesn't lead to any self-tests
> > being run.
> 
> Once we have a user-space interface crypto API you will be able
> to instantiate any given algorithm.
> 
> For now I suggest that you create your own module to instantiate
> these FIPS algorithms.  Or just load tcrypt and ignore the exit
> status, or make tcrypt return 0 if we're in FIPS mode.

The latter option is more or less what the patch at the start of this
thread did, although via a param to tcrypt, not keying off the fips
flag. If I were to modify the patch to drop the mod param usage, and
instead key off the fips flag to not exit, would that be acceptable
for committing until such time as the userspace interface is ready?

-- 
Jarod Wilson
jarod@redhat.com
