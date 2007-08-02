From: Sebastian Siewior <bigeasy@breakpoint.cc>
Subject: Re: [patch/rfc] crypto: padlock-aes use crypto API
Date: Thu, 2 Aug 2007 11:23:51 +0200
Message-ID: <20070802092351.GA24639@Chamillionaire.breakpoint.cc>
References: <20070802081009.GA24488@Chamillionaire.breakpoint.cc> <20070802085816.GA12882@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:49394 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755837AbXHBJXx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Aug 2007 05:23:53 -0400
Content-Disposition: inline
In-Reply-To: <20070802085816.GA12882@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-08-02 16:58:16 [+0800]:

>On Thu, Aug 02, 2007 at 10:10:09AM +0200, Sebastian Siewior wrote:
>> It seems that the driver uses something like crypto_.*_ctx_aligned() of his own.
>> Replace it with the API's functions. Compile tested.
>> 
>> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
>
>Actually this is intentional as it allows the align
>operation to be completely optimised out.

The only difference I can see is, that crypto_tfm_alg_alignmask() is
replaced with a static defined number instead of a lookup in a struct.
IS this the optimization?

Sebastian
