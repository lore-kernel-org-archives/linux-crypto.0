From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v1,1/4] crypto: crypto4xx - shuffle iomap in front of
 request_irq
Date: Fri, 5 Jan 2018 22:15:24 +1100
Message-ID: <20180105111524.GA16271@gondor.apana.org.au>
References: <4baa099377d73ea99c7802a9685815b32e8bf119.1513908140.git.chunkeey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Christian Lamparter <chunkeey@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:49972 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751577AbeAELP0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jan 2018 06:15:26 -0500
Content-Disposition: inline
In-Reply-To: <4baa099377d73ea99c7802a9685815b32e8bf119.1513908140.git.chunkeey@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 22, 2017 at 09:18:35PM +0100, Christian Lamparter wrote:
> It is possible to avoid the ce_base null pointer check in the
> drivers' interrupt handler routine "crypto4xx_ce_interrupt_handler()"
> by simply doing the iomap in front of the IRQ registration.
> 
> This way, the ce_base will always be valid in the handler and
> a branch in an critical path can be avoided.
> 
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
