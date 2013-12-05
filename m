From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] pcrypt/padata rcu fixes
Date: Thu, 5 Dec 2013 22:36:15 +0800
Message-ID: <20131205143615.GE1976@gondor.apana.org.au>
References: <1385662805-16919-1-git-send-email-minipli@googlemail.com>
 <20131202121233.GP31491@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mathias Krause <minipli@googlemail.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:56286 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807Ab3LEOgY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Dec 2013 09:36:24 -0500
Content-Disposition: inline
In-Reply-To: <20131202121233.GP31491@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 02, 2013 at 01:12:33PM +0100, Steffen Klassert wrote:
> On Thu, Nov 28, 2013 at 07:20:03PM +0100, Mathias Krause wrote:
> > Two small RCU related fixes, lockdep complained about.
> > 
> > Please apply!
> > 
> > 
> > Mathias Krause (2):
> >   crypto: pcrypt - Fix wrong usage of rcu_dereference()
> >   padata: Fix wrong usage of rcu_dereference()
> > 
> 
> Both
> Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Both patches applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
