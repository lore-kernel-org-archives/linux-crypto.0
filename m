From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [CRYPTO] cast6: inline bloat--
Date: Thu, 10 Jan 2008 10:44:12 +0100
Message-ID: <20080110094412.GA25292@one.firstfloor.org>
References: <Pine.LNX.4.64.0801071535300.31652@kivilampi-30.cs.helsinki.fi> <p73ve62nzzk.fsf@bingen.suse.de> <Pine.LNX.4.64.0801101114070.1408@kivilampi-30.cs.helsinki.fi> <20080110092555.GB25076@one.firstfloor.org> <20080110092746.GA11613@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:54787 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbYAJJlh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jan 2008 04:41:37 -0500
Content-Disposition: inline
In-Reply-To: <20080110092746.GA11613@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 10, 2008 at 08:27:46PM +1100, Herbert Xu wrote:
> On Thu, Jan 10, 2008 at 10:25:55AM +0100, Andi Kleen wrote:
> >
> > Then I don't think the patch should have been applied.
> 
> I disagree.  There isn't any evidence showing that the inlined version
> is significantly faster either.  In the absence of that, the version
> with the smaller size is preferable.

Just seems very risky to mess with cipher inner loops like that. Normally
people originally spent quite some effort tuning those; especially for
an AES candidate. Also putting quite a lot of function calls in there
doesn't seem right -- especially if frame pointer is enabled function
calls are not that cheap anymore. Also it messes up the register
allocation.

> Of course if anyone is keen enough about cast6 to provide benchmarks

If nobody is keen enough then the code could be just dropped
completely, couldn't it?

> showing that the inlined version is significantly faster then I'm
> happy to revert the patch.

There used to be papers with performance analysis of all the AES
candidates, but I cannot find them right now for CAST6. But I doubt
the code was written without proper thought.

-Andi
