From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 01/16] crypto: authenc - Don't multiply priorities
Date: Tue, 16 Aug 2011 20:30:51 +0800
Message-ID: <20110816123051.GA9413@gondor.apana.org.au>
References: <20110811112603.GD16877@secunet.com> <20110811112639.GE16877@secunet.com> <20110815071928.GA29761@gondor.apana.org.au> <20110815080257.GU16877@secunet.com> <20110815085546.GA30341@gondor.apana.org.au> <20110815100806.GV16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:53219 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab1HPMay (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Aug 2011 08:30:54 -0400
Content-Disposition: inline
In-Reply-To: <20110815100806.GV16877@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 15, 2011 at 12:08:06PM +0200, Steffen Klassert wrote:
>
> I think the only value of the priority update is, if we can do it
> without removing existing transforms. If this is not possible
> it is much easier to just delete the algorithm in question and
> to build a new one with the updated priority.

We don't want to automatically update a value that the user may
have previously set.  So I think updating instances on mass won't
work anyway.

Besides, an instance may depend on an algorithm which should not
influence its priority value at all (e.g., if it's only used during
setkey).

So let's just remove that and make this simpler.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
