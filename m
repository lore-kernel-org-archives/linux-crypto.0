From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: rmd128: make it work on my prefered architecture
Date: Sat, 17 May 2008 17:56:25 +0800
Message-ID: <20080517095625.GA17878@gondor.apana.org.au>
References: <20080517082754.GC19540@Chamillionaire.breakpoint.cc> <20080517083738.GA17452@gondor.apana.org.au> <20080517084735.GD19540@Chamillionaire.breakpoint.cc> <20080517.020122.229980431.davem@davemloft.net> <20080517091451.GE19540@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	rueegsegger@swiss-it.ch
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:32976 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752661AbYEQJ4c (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 May 2008 05:56:32 -0400
Content-Disposition: inline
In-Reply-To: <20080517091451.GE19540@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, May 17, 2008 at 11:14:51AM +0200, Sebastian Siewior wrote:
>
> modprobe tcrypt mode=314
> 
> do you need / want the three patches or do you convert them yourself?

If you pull my cryptodev-2.6 tree then you'll be able to run
the above test.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
