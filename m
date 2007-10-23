From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] do not unroll big stuff in twofish key setup if OPTIMIZE_FOR_SIZE
Date: Tue, 23 Oct 2007 14:07:49 +0800
Message-ID: <20071023060748.GA27501@gondor.apana.org.au>
References: <200710212016.25792.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4626 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751252AbXJWGHx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Oct 2007 02:07:53 -0400
Content-Disposition: inline
In-Reply-To: <200710212016.25792.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Oct 21, 2007 at 08:16:25PM +0100, Denys Vlasenko wrote:
> Hello Herbert,
> 
> Currently twofish cipher key setup code
> has unrolled loops - approximately 70-100
> instructions are repeated 40 times.
> 
> As a result, twofish module is the biggest module
> in crypto/*.
> 
> Attached patch conditionalize this unrolling on
> CONFIG_CC_OPTIMIZE_FOR_SIZE. Presumably, people which
> want to use -Os will also prefer to not have these loops
> unrolled:

Thanks for the patch Denys.

Have you looked at the performance figures on x86 for the two
variants? If the difference is small we could just get rid of
the unrolled version altogether.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
