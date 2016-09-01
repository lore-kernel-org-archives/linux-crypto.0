From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv3 03/11] crypto: omap-sham: implement context
 export/import APIs
Date: Thu, 1 Sep 2016 14:16:30 +0800
Message-ID: <20160901061630.GB650@gondor.apana.org.au>
References: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
 <1470306526-27219-4-git-send-email-t-kristo@ti.com>
 <20160809100633.GA6751@gondor.apana.org.au>
 <d828fca9-a97a-7722-c4cb-24e07816cbc4@ti.com>
 <20160901033320.GA650@gondor.apana.org.au>
 <60a5ed40-5552-3ec8-fa21-7e6fb8213fc3@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lokeshvutla@ti.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Tero Kristo <t-kristo@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58157 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752051AbcIAGRL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2016 02:17:11 -0400
Content-Disposition: inline
In-Reply-To: <60a5ed40-5552-3ec8-fa21-7e6fb8213fc3@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 01, 2016 at 09:12:59AM +0300, Tero Kristo wrote:
> 
> Well, but the driver doesn't flush its buffers automatically, it
> caches data until it has sufficient amount available. So, assuming
> you want to do this:
> 
> sham_init
>   sham_update 256 bytes
>   sham_update 256 bytes
>   wait until two above updates are complete
>   sham_export
> 
> ... the execution hangs at the wait phase as the driver is still

Well that's a bug in the driver.  While it's not illegal to wait
for more data, it's usually unnecessary.  Because we instead try
to get our users to generate as big a request as possible, e.g.,
one packet for IPsec.

If you really have to do the hold thing, then you must install a
timer like sha1-mb does on x86 to do the flush.

In any case, the completion function must not be called until
you're actually complete.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
