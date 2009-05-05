From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] crypto: add ctr(aes) test vectors
Date: Tue, 5 May 2009 09:55:24 -0400
Message-ID: <200905050955.24743.jarod@redhat.com>
References: <200904282118.22823.jarod@redhat.com> <200905041624.45060.jarod@redhat.com> <20090505131835.GA18659@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56530 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbZEEN4M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 May 2009 09:56:12 -0400
In-Reply-To: <20090505131835.GA18659@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday 05 May 2009 09:18:35 Herbert Xu wrote:
> On Mon, May 04, 2009 at 04:24:44PM -0400, Jarod Wilson wrote:
> >
> > Indeed, the first enc/dec operation after we set the counter *is*
> > completely deterministic across all implementations, the AESAVS
> > is referring to tests with multiple operations, which aren't
> > possible, due to varying implementations of counter increment
> > routines. This patch adds test vectors for ctr(aes), using the
> > first block input values from Appendix F.5 of NIST Special Pub
> > 800-38A.
> 
> Well, our ctr(aes) must be completely deterministic as it is
> used as the base for CCM and GCM.  In fact, if it weren't so
> then you can't use it for anything since two implementations
> may produces different outputs.

Yeah, that makes sense, I believe I finally see the light.

> So if you could resend some vectors that test multiple blocks
> then I'll happily add them.

Multi-block test vectors coming shortly, passing in all the input
blocks from F.5 of 800-38A is spitting back the expected answers
for ever block.

-- 
Jarod Wilson
jarod@redhat.com
