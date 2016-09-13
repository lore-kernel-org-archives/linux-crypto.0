From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv3 06/11] crypto: omap-des: Fix support for unequal lengths
Date: Tue, 13 Sep 2016 17:35:06 +0800
Message-ID: <20160913093506.GA30561@gondor.apana.org.au>
References: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
 <1470306526-27219-7-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lokeshvutla@ti.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lokesh Vutla <a0131933@ti.com>
To: Tero Kristo <t-kristo@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59409 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755679AbcIMJhG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 05:37:06 -0400
Content-Disposition: inline
In-Reply-To: <1470306526-27219-7-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 04, 2016 at 01:28:41PM +0300, Tero Kristo wrote:
> From: Lokesh Vutla <a0131933@ti.com>
> 
> For cases where total length of an input SGs is not same as
> length of the input data for encryption, omap-des driver
> crashes. This happens in the case when IPsec is trying to use
> omap-des driver.
> 
> To avoid this, we copy all the pages from the input SG list
> into a contiguous buffer and prepare a single element SG list
> for this buffer with length as the total bytes to crypt, which is
> similar thing that is done in case of unaligned lengths.

Ugh, that means copying every single packet, right?

So if it's just the SG list that's the problem, why don't you
copy that instead? That is, allocate a new SG list and set it
up so that there is no excess data.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
