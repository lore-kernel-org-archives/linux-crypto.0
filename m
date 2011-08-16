From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 01/16] crypto: authenc - Don't multiply priorities
Date: Tue, 16 Aug 2011 14:37:09 +0200
Message-ID: <20110816123709.GW16877@secunet.com>
References: <20110811112603.GD16877@secunet.com>
 <20110811112639.GE16877@secunet.com>
 <20110815071928.GA29761@gondor.apana.org.au>
 <20110815080257.GU16877@secunet.com>
 <20110815085546.GA30341@gondor.apana.org.au>
 <20110815100806.GV16877@secunet.com>
 <20110816123051.GA9413@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:35231 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab1HPMgP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Aug 2011 08:36:15 -0400
Content-Disposition: inline
In-Reply-To: <20110816123051.GA9413@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 16, 2011 at 08:30:51PM +0800, Herbert Xu wrote:
> 
> We don't want to automatically update a value that the user may
> have previously set.  So I think updating instances on mass won't
> work anyway.
> 
> Besides, an instance may depend on an algorithm which should not
> influence its priority value at all (e.g., if it's only used during
> setkey).
> 
> So let's just remove that and make this simpler.
> 

Ok, I'll remove it and respin the patches.
