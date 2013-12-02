From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 0/2] pcrypt/padata rcu fixes
Date: Mon, 2 Dec 2013 13:12:33 +0100
Message-ID: <20131202121233.GP31491@secunet.com>
References: <1385662805-16919-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:46588 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781Ab3LBMMm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Dec 2013 07:12:42 -0500
Content-Disposition: inline
In-Reply-To: <1385662805-16919-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 28, 2013 at 07:20:03PM +0100, Mathias Krause wrote:
> Two small RCU related fixes, lockdep complained about.
> 
> Please apply!
> 
> 
> Mathias Krause (2):
>   crypto: pcrypt - Fix wrong usage of rcu_dereference()
>   padata: Fix wrong usage of rcu_dereference()
> 

Both
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Thanks!
