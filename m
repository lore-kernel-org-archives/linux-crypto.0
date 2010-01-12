From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto test results unused?
Date: Tue, 12 Jan 2010 22:14:39 +1100
Message-ID: <20100112111439.GA31504@gondor.apana.org.au>
References: <m3ws07q865.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Krzysztof Halasa <khc@pm.waw.pl>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57244 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754132Ab0ALLOo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jan 2010 06:14:44 -0500
Content-Disposition: inline
In-Reply-To: <m3ws07q865.fsf@intrepid.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Krzysztof Halasa <khc@pm.waw.pl> wrote:
> 
> On little-endian IXP4xx 3 hardware-assisted algorithms fail (due to
> apparently unrelated bug which I will take care of). It seems the kernel
> is still using these failing algorithms (my debugging code adds extra
> fields to the /proc output):

How did you determine that it was still being used? When a kernel
user requests for an algorithm the system is supposed to skip
anything which failed the self-test.
 
> At this point alg->cra_flags includes CRYPTO_ALG_DEAD (due to failed
> test), but larval->alg.cra_flags has only the original flags (0x85).

CRYPTO_ALG_DEAD is used to mark algorithms deleted from the
system.  However, we don't delete algorithms just because they
fail the self-test.  They remain in the system so you can come
back and diagnose the problem.  They just aren't used by anyone.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
