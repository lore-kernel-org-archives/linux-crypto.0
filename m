From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next] crypto: ux500 - fix error return code in
 hash_dma_final()
Date: Wed, 3 Apr 2013 09:52:29 +0800
Message-ID: <20130403015229.GA20205@gondor.apana.org.au>
References: <CAPgLHd94xmvDhOm7xFAV0Ef2O4DFST+npQYN7sfRKVL+y+Msdw@mail.gmail.com>
 <CACRpkdZYwGhXqZpmu5FovAo=_C6U97_3tcOw3hXJ0sw9gRx2CA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wei Yongjun <weiyj.lk@gmail.com>, andreas.westin@stericsson.com,
	arnd@arndb.de, rubini@unipv.it, yongjun_wei@trendmicro.com.cn,
	linux-crypto@vger.kernel.org,
	Rikard OLSSON <rikard.p.olsson@stericsson.com>,
	magnus.p.persson@stericsson.com
To: Linus Walleij <linus.walleij@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:42064 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760469Ab3DCBwr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Apr 2013 21:52:47 -0400
Content-Disposition: inline
In-Reply-To: <CACRpkdZYwGhXqZpmu5FovAo=_C6U97_3tcOw3hXJ0sw9gRx2CA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 25, 2013 at 04:15:36PM +0100, Linus Walleij wrote:
> On Fri, Mar 22, 2013 at 2:18 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> 
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> >
> > Fix to return a negative error code from the error handling
> > case instead of 0, as returned elsewhere in this function.
> >
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
