From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: use kernel-provided bitops, unaligned access helpers
Date: Sun, 17 Aug 2008 21:59:19 +1000
Message-ID: <20080817115919.GA25517@gondor.apana.org.au>
References: <1215119038.16647.23.camel@brick> <20080704114315.GA6266@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42778 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752525AbYHQL70 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Aug 2008 07:59:26 -0400
Content-Disposition: inline
In-Reply-To: <20080704114315.GA6266@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 04, 2008 at 07:43:15PM +0800, Herbert Xu wrote:
> On Thu, Jul 03, 2008 at 02:03:57PM -0700, Harvey Harrison wrote:
> > Remove the private implementation of 32-bit rotation and unaligned
> > access with byteswapping.
> > 
> > As a bonus, fixes sparse warnings:
> > crypto/camellia.c:602:2: warning: cast to restricted __be32
> > crypto/camellia.c:603:2: warning: cast to restricted __be32
> > crypto/camellia.c:604:2: warning: cast to restricted __be32
> > crypto/camellia.c:605:2: warning: cast to restricted __be32
> > crypto/camellia.c:710:2: warning: cast to restricted __be32
> > crypto/camellia.c:711:2: warning: cast to restricted __be32
> > crypto/camellia.c:712:2: warning: cast to restricted __be32
> > crypto/camellia.c:713:2: warning: cast to restricted __be32
> > crypto/camellia.c:714:2: warning: cast to restricted __be32
> > crypto/camellia.c:715:2: warning: cast to restricted __be32
> > crypto/camellia.c:716:2: warning: cast to restricted __be32
> > crypto/camellia.c:717:2: warning: cast to restricted __be32
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> 
> Patch applied.  BTW, this driver should perhaps use align mask
> instead rather than handling unaligned data on its own.

Hmm, camellia is now failing the tcrypt self-test.  Harvey,
could you have a look at this?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
