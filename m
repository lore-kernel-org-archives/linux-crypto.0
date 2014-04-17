From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Why care about signal when instantiate an crypt template
Date: Thu, 17 Apr 2014 15:44:49 +0800
Message-ID: <20140417074449.GA24539@gondor.apana.org.au>
References: <53479BD1.3050508@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Fan Du <fan.du@windriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:57820 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaDQHow (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Apr 2014 03:44:52 -0400
Content-Disposition: inline
In-Reply-To: <53479BD1.3050508@windriver.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fan Du <fan.du@windriver.com> wrote:
> Hi,
> 
> I recently bump into a issue, ike daemon got interrupted(EINTR),
> after looking at the code, it seems there are places in crypto code
> where returning EINTR when current tasks has signal pending.
> 
> For example:
> crypto_alloc_base and crypto_alloc_tfm
> 
> 435 err:
> 436                 if (err != -EAGAIN)
> 437                         break;
> 438                 if (signal_pending(current)) {
> 439                         err = -EINTR;
> 440                         break;
> 441                 }
> 442         }
> 
> I can't understand why the codes here needs to care about signals?

Because otherwise you may end up with something that you can't
kill from user-space.  You should fix your app.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
