From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Why care about signal when instantiate an crypt template
Date: Thu, 17 Apr 2014 17:52:44 +0800
Message-ID: <20140417095244.GA25307@gondor.apana.org.au>
References: <20140417074449.GA24539@gondor.apana.org.au>
 <534F9CE2.1050509@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Fan Du <fan.du@windriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:36180 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbaDQJws (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Apr 2014 05:52:48 -0400
Content-Disposition: inline
In-Reply-To: <534F9CE2.1050509@windriver.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 17, 2014 at 05:20:34PM +0800, Fan Du wrote:
> 
> The signal checking is only to bail out from the infinite loop, it shouldn't
> override original err code -EAGAIN with -EINTR.
> 
> With -EAGAIN, user space app can try again, what do you think?

EAGAIN makes no sense when we bail out due to a signal.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
