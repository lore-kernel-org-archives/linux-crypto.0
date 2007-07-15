From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto Update for 2.6.23
Date: Sun, 15 Jul 2007 21:15:57 +0800
Message-ID: <20070715131557.GA21255@gondor.apana.org.au>
References: <20070711130849.GA10494@gondor.apana.org.au> <20070714.234839.34761809.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: torvalds@linux-foundation.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2151 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752305AbXGONQB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Jul 2007 09:16:01 -0400
Content-Disposition: inline
In-Reply-To: <20070714.234839.34761809.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Jul 14, 2007 at 11:48:39PM -0700, David Miller wrote:
>
> I merged this into my net-2.6 tree, there was a tiny conflict
> in crypto/Kconfig I had to resolve because of the async_tx
> stuff that went in upstream.

Thanks!

> Herbert can you contact the async_tx author to make sure that
> his crypto/ bits go through you in the future so that conflicts
> like this can be avoided?

No problems.  This was a once-off because it involved multiple
conflicts all over the place as Andrew can no doubt attest to :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
