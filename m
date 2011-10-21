From: Matthias-Christian Ott <ott@mirix.org>
Subject: Re: Hardware acceleration indication in af_alg
Date: Fri, 21 Oct 2011 16:34:15 +0200
Message-ID: <20111021143415.GE2050@qp>
References: <20111018131351.GB24865@qi>
 <20111021132336.GA1080@gondor.apana.org.au>
 <20111021141541.GC2050@qp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mirix.org ([78.46.130.147]:48080 "EHLO a.mirix.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600Ab1JUOeS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Oct 2011 10:34:18 -0400
Received: from [fdb9:f9c0:d128:9208::1] (helo=qp)
	by a.mirix.org with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.76)
	(envelope-from <ott@mirix.org>)
	id 1RHGAq-00020i-Sr
	for linux-crypto@vger.kernel.org; Fri, 21 Oct 2011 16:34:17 +0200
Content-Disposition: inline
In-Reply-To: <20111021141541.GC2050@qp>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 21, 2011 at 04:15:41PM +0200, Matthias-Christian Ott wrote:
> On Fri, Oct 21, 2011 at 03:23:36PM +0200, Herbert Xu wrote:
> > Matthias-Christian Ott <ott@mirix.org> wrote:
> > > I did some experiments with af_alg and noticed that to be really
> > > useful, it should indicate whether a certain algorithm is hardware
> > > accelerated. I guess this has to be inferred by the priority of the
> > > algorithm could be made available via a read-only socket option. Any
> > > thoughts on this?
> > > 
> > > I can imagine, an alternative approach and perhaps better approach
> > > would be to measure the speed of the kernel provided algorithm against
> > > a software implementation, but there are many other factors that could
> > > influence the results. Therefore, it is perhaps better to just make
> > > the assumption that hardware acceleration is faster which is made in
> > > the kernel anyhow.
> > 
> > You have to be careful to distinguish between hardware acceleration
> > that is directly available to user-space (such as AESNI) and those
> > that aren't.
> > 
> > For the former it makes zero sense to go through the kernel as
> > you'll only make it slower.  The latter case is the reason why
> > this interface exists.
> 
> This is why I didn't consider hardware acceleration that is directly
> available to user-space in the first place (I'm not aware of anything
> except CPUs that is usable this way). So the question remains whether
> e.g. the AES implementation provided through af_alg by the kernel is
> faster (and thus most likely hardware accelerated) than a software
> implementation. Since the kernel seems to make the assumption that
> hardware acceleration is faster, I asked whether it would be possible to
> pass this information to user-space as well.

Ignore that e-mail. The the recent user configuration patches
by Stefan Klassert seem to expose the algorithm's priority via
CRYPTOCFGA_PRIORITY_VAL. This should solve my problem, provided that
the patches will be included.

Regards,
Matthias-Christian
