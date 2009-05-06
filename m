From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH v2] crypto: add ctr(aes) test vectors
Date: Wed, 6 May 2009 08:51:33 -0400
Message-ID: <200905060851.34129.jarod@redhat.com>
References: <200904282118.22823.jarod@redhat.com> <200905051042.58929.jarod@redhat.com> <20090506093021.GA31073@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49595 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755684AbZEFMwV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 May 2009 08:52:21 -0400
In-Reply-To: <20090506093021.GA31073@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 06 May 2009 05:30:21 Herbert Xu wrote:
> On Tue, May 05, 2009 at 10:42:58AM -0400, Jarod Wilson wrote:
> > 
> > Now with multi-block test vectors, all from SP800-38A, Appendix F.5.
> > Also added ctr(aes) to case 10 in tcrypt.
> > 
> > Quickly smoke-tested in fips mode, got back "alg_test: alg
> > ctr(aes-x86_64) (ctr(aes)) self-test passed".
> > 
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
> It didn't build because you forgot to change the RFC3686 dec
> vector name.  I've fixed it for you.  Please test your patches
> in future.

Gah, apologies. Tested it in that other kernel tree I needed to
get this done for, then neglected to do so for cryptodev.

Thanks for the fixage.

-- 
Jarod Wilson
jarod@redhat.com
