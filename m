From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: IPSec ESP Authenc Offload
Date: Fri, 30 May 2008 09:35:15 +1000
Message-ID: <20080529233515.GA25096@gondor.apana.org.au>
References: <alpine.LFD.1.10.0805250731530.23219@localhost.localdomain> <20080526112058.GA16525@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D604814C4A@SDCEXCHANGE01.ad.amcc.com> <20080528063434.GA1173@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D604814F16@SDCEXCHANGE01.ad.amcc.com> <20080528222246.GA7798@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D604815113@SDCEXCHANGE01.ad.amcc.com> <20080529070130.GC18007@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D604815318@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38571 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752735AbYE2XfR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 May 2008 19:35:17 -0400
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D604815318@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 29, 2008 at 10:44:47AM -0700, Loc Ho wrote:
> 
> [Loc Ho]
> I would like to use the existent interface and it does work. Except, it
> will require extra works such as 1) another context SA per an operation
> (this is in addition to the context SA with the tfm), 2) as there are
> now multiple context SA's, they need to be in sync, and 3) copy fields
> from one context SA to another. We can not use the same context SA for
> per operation for following reasons:

Is it possible to have a look at your hardware spec?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
