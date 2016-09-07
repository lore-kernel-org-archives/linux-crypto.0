From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv3 03/11] crypto: omap-sham: implement context
 export/import APIs
Date: Wed, 7 Sep 2016 21:29:40 +0800
Message-ID: <20160907132940.GA17927@gondor.apana.org.au>
References: <d828fca9-a97a-7722-c4cb-24e07816cbc4@ti.com>
 <20160901033320.GA650@gondor.apana.org.au>
 <60a5ed40-5552-3ec8-fa21-7e6fb8213fc3@ti.com>
 <20160901061630.GB650@gondor.apana.org.au>
 <70468d4d-9f26-1bad-ace1-4b7c5cf43b52@ti.com>
 <20160901071958.GA2076@gondor.apana.org.au>
 <4c45de7f-002c-48b5-c950-f445354adb09@ti.com>
 <20160901073113.GA2232@gondor.apana.org.au>
 <9af173f7-cc94-a92f-80ee-c746d97ab110@ti.com>
 <0e19ed55-f24b-ad98-215b-1eb318193f06@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lokeshvutla@ti.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Tero Kristo <t-kristo@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44087 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752829AbcIGN3v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2016 09:29:51 -0400
Content-Disposition: inline
In-Reply-To: <0e19ed55-f24b-ad98-215b-1eb318193f06@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 05, 2016 at 03:06:05PM +0300, Tero Kristo wrote:
>
> Additional request, would it be possible for you to check the rest
> of the series and just ignore patches #2 and #3 for now, the rest
> don't have any dependencies against these and can be applied cleanly
> without.
> 
> I would like to see these move forward while I figure out how to
> handle the buffer / export+import...

Sure I'll review them again.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
