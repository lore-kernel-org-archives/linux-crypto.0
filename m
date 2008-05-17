From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: rmd128: make it work on my prefered architecture
Date: Sat, 17 May 2008 16:37:38 +0800
Message-ID: <20080517083738.GA17452@gondor.apana.org.au>
References: <20080515200706.GA3081@Chamillionaire.breakpoint.cc> <20080517081003.GA19540@Chamillionaire.breakpoint.cc> <20080517.012235.82078077.davem@davemloft.net> <20080517082754.GC19540@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	rueegsegger@swiss-it.ch
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39845 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751581AbYEQIhp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 May 2008 04:37:45 -0400
Content-Disposition: inline
In-Reply-To: <20080517082754.GC19540@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, May 17, 2008 at 10:27:54AM +0200, Sebastian Siewior wrote:
>
> I know that. Please see my follow up mail with some tiny numbers.
> gcc-4.1.1 was used on a mpc8544.

But what do the numbers look like on other architectures?  In
particular, x86-* and sparc64?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
