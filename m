From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto, gf128: fix call to memset()
Date: Fri, 8 Jul 2011 17:21:38 +0800
Message-ID: <20110708092137.GA29180@gondor.apana.org.au>
References: <1310027630-26488-1-git-send-email-minipli@googlemail.com> <20110707.021039.1936036404024998528.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: minipli@googlemail.com, linux-crypto@vger.kernel.org,
	pageexec@freemail.hu
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:48509 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab1GHJVr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jul 2011 05:21:47 -0400
Content-Disposition: inline
In-Reply-To: <20110707.021039.1936036404024998528.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 07, 2011 at 02:10:39AM -0700, David Miller wrote:
> From: Mathias Krause <minipli@googlemail.com>
> Date: Thu,  7 Jul 2011 10:33:50 +0200
> 
> > In gf128mul_lle() and gf128mul_bbe() r isn't completely initialized with
> > zero because the size argument passed to memset() is the size of the
> > pointer, not the structure it points to.
> > 
> > Luckily there are no in-kernel users of those functions so the ABI
> > change implied by this fix should break no existing code.
> > 
> > Based on a patch by the PaX Team.
> > 
> > Signed-off-by: Mathias Krause <minipli@googlemail.com>
> > Cc: PaX Team <pageexec@freemail.hu>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Patch applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
