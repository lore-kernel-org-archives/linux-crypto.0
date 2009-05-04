From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] crypto: don't raise alarm for no ctr(aes*) tests in fips mode
Date: Mon, 4 May 2009 14:56:58 -0400
Message-ID: <200905041456.59427.jarod@redhat.com>
References: <200904282118.22823.jarod@redhat.com> <20090504111010.GA4991@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58809 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbZEDS5q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 May 2009 14:57:46 -0400
In-Reply-To: <20090504111010.GA4991@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Monday 04 May 2009 07:10:10 Herbert Xu wrote:
> On Tue, Apr 28, 2009 at 09:18:22PM -0400, Jarod Wilson wrote:
> > Per the NIST AESAVS document, Appendix A[1], it isn't possible to
> > have automated self-tests for counter-mode AES, but people are
> > misled to believe something is wrong by the message that says there
> > is no test for ctr(aes). Simply suppress all 'no test for ctr(aes*'
> > messages if fips_enabled is set to avoid confusion.
> 
> This is not true at all.  In our implementation the counter is
> set through the IV so it definitely is possible to test counter
> mode algorithms in Linux.

Ah... Now I think I see... We can provide an initial counter w/o a
problem, but counter incrementation is implementation-specific, so
we can't have automated tests that cover multiple enc/dec ops, but
if we limit ourselves to just one op, self-tests should be perfectly
doable, and NIST SP 800-38A, Appendix F.5 has vectors we could make
use of (using just the block #1 values). At least, spot-checking
the vectors, I'm getting the expected results for the 1st block.

Okay, I'll whip something up in a sec.

-- 
Jarod Wilson
jarod@redhat.com
