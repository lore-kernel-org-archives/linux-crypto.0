From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv3 03/11] crypto: omap-sham: implement context
 export/import APIs
Date: Thu, 1 Sep 2016 11:33:20 +0800
Message-ID: <20160901033320.GA650@gondor.apana.org.au>
References: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
 <1470306526-27219-4-git-send-email-t-kristo@ti.com>
 <20160809100633.GA6751@gondor.apana.org.au>
 <d828fca9-a97a-7722-c4cb-24e07816cbc4@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lokeshvutla@ti.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Tero Kristo <t-kristo@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55848 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754179AbcIADdb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Aug 2016 23:33:31 -0400
Content-Disposition: inline
In-Reply-To: <d828fca9-a97a-7722-c4cb-24e07816cbc4@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 29, 2016 at 05:11:35PM +0300, Tero Kristo wrote:
>
> >>+static int omap_sham_export(struct ahash_request *req, void *out)
> >>+{
> >>+	struct omap_sham_reqctx *rctx = ahash_request_ctx(req);
> >>+
> >>+	while (omap_sham_flush(req) == -EINPROGRESS)
> >>+		msleep(10);
> >
> >Do we really need this? You must not call export until the previous
> >operation has completed.
> >
> >Cheers,
> >
> 
> Sorry about a late reply, I was out on vacation.
> 
> For OMAP SHAM, this is actually needed, because the driver still has
> a very large internal buffer for performance reasons, and the whole
> buffer can't be exported. The flush functionality pushes out
> sufficient amount of data to the hardware, so that the rest of the
> buffer can be exported to the available space.

It doesn't matter whether you have a buffer or not.  The point
is that the completion function should not be called until the
operation is actually complete.  This is the whole point of the
async interface.

As the user must not call export until the completion function
has been called, there should be no need to wait in the export
function.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
