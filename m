From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/5] camellia: de-unrolling
Date: Tue, 6 Nov 2007 22:21:40 +0800
Message-ID: <20071106142140.GD24423@gondor.apana.org.au>
References: <200710251243.58701.vda.linux@googlemail.com> <200710251247.16843.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3278 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751170AbXKFOVn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Nov 2007 09:21:43 -0500
Content-Disposition: inline
In-Reply-To: <200710251247.16843.vda.linux@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 25, 2007 at 12:47:16PM +0100, Denys Vlasenko wrote:
> On Thursday 25 October 2007 12:43, Denys Vlasenko wrote:
> > Hi Hervert,
> > 
> > Please review and maybe propagate upstream following patches.
> > 
> > camellia4.diff
> >     Move huge unrolled pieces of code (3 screenfuls) at the end of
> >     128/256 key setup routines into common camellia_setup_tail(),
> >     convert it to loop there.
> >     Loop is still unrolled six times, so performance hit is very small,
> >     code size win is big.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Good work! Patch applied.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
