From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: tcrypt: add option to not exit on success
Date: Wed, 13 May 2009 23:27:52 +1000
Message-ID: <20090513132752.GA17262@gondor.apana.org.au>
References: <200905111006.32675.jarod@redhat.com> <20090513110826.GA16406@hmsreliant.think-freely.org> <20090513113819.GA15662@gondor.apana.org.au> <200905130912.46965.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38864 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750790AbZEMN14 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 May 2009 09:27:56 -0400
Content-Disposition: inline
In-Reply-To: <200905130912.46965.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 13, 2009 at 09:12:46AM -0400, Jarod Wilson wrote:
> 
> Hm... FIPS has the requirement that we test all algs before we use any
> algs, self-tests on demand before first use for each alg is
> insufficient. At first blush, I'm not seeing how we ensure this
> happens. How can we trigger a cbc(des3_ede) self-test from userspace?
> I see that modprobe'ing des.ko runs the base des and des3_ede
> self-tests, but modprobe'ing cbc.ko doesn't lead to any self-tests
> being run.

Once we have a user-space interface crypto API you will be able
to instantiate any given algorithm.

For now I suggest that you create your own module to instantiate
these FIPS algorithms.  Or just load tcrypt and ignore the exit
status, or make tcrypt return 0 if we're in FIPS mode.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
