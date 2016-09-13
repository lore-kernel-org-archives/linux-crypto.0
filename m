From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: algif_aead: AIO broken with more than one iocb
Date: Tue, 13 Sep 2016 18:12:46 +0800
Message-ID: <20160913101246.GA30851@gondor.apana.org.au>
References: <6245755.LbXSUvPjJL@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44560 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756705AbcIMKNB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 06:13:01 -0400
Content-Disposition: inline
In-Reply-To: <6245755.LbXSUvPjJL@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Sep 11, 2016 at 04:59:19AM +0200, Stephan Mueller wrote:
> Hi Herbert,
> 
> The AIO support for algif_aead is broken when submitting more than one iocb. 
> The break happens in aead_recvmsg_async at the following code:
> 
>         /* ensure output buffer is sufficiently large */
>         if (usedpages < outlen)
>                 goto free;
> 
> The reason is that when submitting, say, two iocb, ctx->used contains the 
> buffer length for two AEAD operations (as expected). However, the recvmsg code 

I don't think we should allow that.  We should make it so that you
must start a recvmsg before you can send data for a new request.

Remember that the async path should be identical to the sync path,
except that you don't wait for completion.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
