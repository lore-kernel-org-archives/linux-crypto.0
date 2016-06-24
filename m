From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv2 06/27] crypto: ahash: increase the maximum allowed
 statesize
Date: Fri, 24 Jun 2016 18:32:09 +0800
Message-ID: <20160624103209.GA19607@gondor.apana.org.au>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
 <1466601840-18486-7-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-omap@vger.kernel.org, linux-crypto@vger.kernel.org,
	tony@atomide.com, davem@davemloft.net, lokeshvutla@ti.com,
	linux-arm-kernel@lists.infradead.org
To: Tero Kristo <t-kristo@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48548 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbcFXKcP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 06:32:15 -0400
Content-Disposition: inline
In-Reply-To: <1466601840-18486-7-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 22, 2016 at 04:23:39PM +0300, Tero Kristo wrote:
> The statesize is used to determine the maximum size for saved ahash
> context. In some cases, this can be much larger than what is currently
> allocated for it, for example omap-sham driver uses a buffer size of
> PAGE_SIZE. Increase the statesize to accommodate this.
> 
> Signed-off-by: Tero Kristo <t-kristo@ti.com>

Nack.  The exported state is supposed to consist of the actual
hash state, plus at most one block worth of unhashed data.  It's
limited so that we can store it on the stack.

So no I'm not taking this patch.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
