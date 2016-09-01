From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv3 03/11] crypto: omap-sham: implement context
 export/import APIs
Date: Thu, 1 Sep 2016 15:31:13 +0800
Message-ID: <20160901073113.GA2232@gondor.apana.org.au>
References: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
 <1470306526-27219-4-git-send-email-t-kristo@ti.com>
 <20160809100633.GA6751@gondor.apana.org.au>
 <d828fca9-a97a-7722-c4cb-24e07816cbc4@ti.com>
 <20160901033320.GA650@gondor.apana.org.au>
 <60a5ed40-5552-3ec8-fa21-7e6fb8213fc3@ti.com>
 <20160901061630.GB650@gondor.apana.org.au>
 <70468d4d-9f26-1bad-ace1-4b7c5cf43b52@ti.com>
 <20160901071958.GA2076@gondor.apana.org.au>
 <4c45de7f-002c-48b5-c950-f445354adb09@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lokeshvutla@ti.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Tero Kristo <t-kristo@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37977 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754553AbcIAHbd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2016 03:31:33 -0400
Content-Disposition: inline
In-Reply-To: <4c45de7f-002c-48b5-c950-f445354adb09@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 01, 2016 at 10:28:47AM +0300, Tero Kristo wrote:
>
> Yeah, the flush should do the trick now. Kind of a chicken-egg
> problem here. :P How do you see the situation with the above
> explanation?

The export function is not allowed to sleep so you must not wait
for the hardware to complete in it.

If you need to wait, then you must use the completion mechanism.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
