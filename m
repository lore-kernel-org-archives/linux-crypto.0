From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add ctr(aes) test vectors
Date: Tue, 5 May 2009 21:18:35 +0800
Message-ID: <20090505131835.GA18659@gondor.apana.org.au>
References: <200904282118.22823.jarod@redhat.com> <20090504111010.GA4991@gondor.apana.org.au> <200905041624.45060.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52464 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750935AbZEENSj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 May 2009 09:18:39 -0400
Content-Disposition: inline
In-Reply-To: <200905041624.45060.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 04, 2009 at 04:24:44PM -0400, Jarod Wilson wrote:
>
> Indeed, the first enc/dec operation after we set the counter *is*
> completely deterministic across all implementations, the AESAVS
> is referring to tests with multiple operations, which aren't
> possible, due to varying implementations of counter increment
> routines. This patch adds test vectors for ctr(aes), using the
> first block input values from Appendix F.5 of NIST Special Pub
> 800-38A.

Well, our ctr(aes) must be completely deterministic as it is
used as the base for CCM and GCM.  In fact, if it weren't so
then you can't use it for anything since two implementations
may produces different outputs.

So if you could resend some vectors that test multiple blocks
then I'll happily add them.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
