From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algif - Mark sgl end at the end of data
Date: Mon, 1 Dec 2014 23:00:10 +0800
Message-ID: <20141201150010.GA18277@gondor.apana.org.au>
References: <20141128184036.11421.36028.stgit@tstruk-mobl1>
 <20141201144026.GA18008@gondor.apana.org.au>
 <547C80F5.6000006@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:54508 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbaLAPAN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Dec 2014 10:00:13 -0500
Content-Disposition: inline
In-Reply-To: <547C80F5.6000006@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 01, 2014 at 06:53:41AM -0800, Tadeusz Struk wrote:
> Hi Herbert,
> On 12/01/2014 06:40 AM, Herbert Xu wrote:
> >> +			nents = sg_nents(ctx->rsgl.sg);
> >> > +			sg_mark_end(&sg[nents - 1]);
> > Huh? You're getting nents from the RX side and using it to mark
> > the TX side? This makes no sense because RX may have no relationship
> > whatsoever with TX.
> 
> Yes, but there shouldn't be more nents with data to be processed in TX
> than nents in RX and in most cases they should be equal. Or am I missing
> something?

As I said the two are arbitrary and we don't place any restrictions
on them at all (apart from the fact that the TX length in bytes must
obviously be longer than the RX bytes).

So you can have a 1-element TX list with a multi-element RX list.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
