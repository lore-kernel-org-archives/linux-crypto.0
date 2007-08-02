From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [patch/rfc] crypto: padlock-aes use crypto API
Date: Thu, 2 Aug 2007 15:09:33 +0200
Message-ID: <20070802130933.GE24639@Chamillionaire.breakpoint.cc>
References: <20070802081009.GA24488@Chamillionaire.breakpoint.cc> <20070802085816.GA12882@gondor.apana.org.au> <20070802092351.GA24639@Chamillionaire.breakpoint.cc> <20070802092825.GA13085@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:39925 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658AbXHBNJj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Aug 2007 09:09:39 -0400
Content-Disposition: inline
In-Reply-To: <20070802092825.GA13085@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-08-02 17:28:25 [+0800]:

>On Thu, Aug 02, 2007 at 11:23:51AM +0200, Sebastian Siewior wrote:
>> 
>> The only difference I can see is, that crypto_tfm_alg_alignmask() is
>> replaced with a static defined number instead of a lookup in a struct.
>> IS this the optimization?
>
>Yes, the fact that the alignment mask is a constant allows
>it to be optimised away.

If this is that important, isn't it better to add/ replace the current
_aligned call with such an optimized one? Or applies this kind of
optimization only to this special driver where it is very expensive
otherwise?

>Cheers,

Sebastian
