From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: add ctr(aes) test vectors
Date: Wed, 6 May 2009 17:30:21 +0800
Message-ID: <20090506093021.GA31073@gondor.apana.org.au>
References: <200904282118.22823.jarod@redhat.com> <20090505131835.GA18659@gondor.apana.org.au> <200905050955.24743.jarod@redhat.com> <200905051042.58929.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:56996 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753059AbZEFJa1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 May 2009 05:30:27 -0400
Content-Disposition: inline
In-Reply-To: <200905051042.58929.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 05, 2009 at 10:42:58AM -0400, Jarod Wilson wrote:
> 
> Now with multi-block test vectors, all from SP800-38A, Appendix F.5.
> Also added ctr(aes) to case 10 in tcrypt.
> 
> Quickly smoke-tested in fips mode, got back "alg_test: alg
> ctr(aes-x86_64) (ctr(aes)) self-test passed".
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

It didn't build because you forgot to change the RFC3686 dec
vector name.  I've fixed it for you.  Please test your patches
in future.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
