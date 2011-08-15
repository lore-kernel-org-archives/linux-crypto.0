From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 01/16] crypto: authenc - Don't multiply priorities
Date: Mon, 15 Aug 2011 15:19:29 +0800
Message-ID: <20110815071928.GA29761@gondor.apana.org.au>
References: <20110811112603.GD16877@secunet.com> <20110811112639.GE16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:38363 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab1HOHTc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Aug 2011 03:19:32 -0400
Content-Disposition: inline
In-Reply-To: <20110811112639.GE16877@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 11, 2011 at 01:26:39PM +0200, Steffen Klassert wrote:
> Most crypto algorithms simply take the priority value of the underlying
> algorithm and add some value to calculate the algorithms priority.
> The only exeptions are the authenc algorithms. We change the authenc
> algorithms to calculate their priority to the sum of the underlying
> algorithms plus 100. With this we can keep the priority consistent if
> one of the underlying algorithms changes the priority.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Actually the reason it places a bigger weight on the cipher's
priority is because typically ciphers are slower than hashes.
So this is expressing the fact that we'd rather use a faster
cipher with a slower hash than the other way around.

Do you have a particular scenario in mind where this is broken?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
