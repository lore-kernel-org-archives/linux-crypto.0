From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch/rfc] crypto: padlock-aes use crypto API
Date: Thu, 2 Aug 2007 16:58:16 +0800
Message-ID: <20070802085816.GA12882@gondor.apana.org.au>
References: <20070802081009.GA24488@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2399 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751517AbXHBI6T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Aug 2007 04:58:19 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IGWVd-0007Fw-A0
	for <linux-crypto@vger.kernel.org>; Thu, 02 Aug 2007 18:58:17 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IGWVc-0003M1-00
	for <linux-crypto@vger.kernel.org>; Thu, 02 Aug 2007 16:58:16 +0800
Content-Disposition: inline
In-Reply-To: <20070802081009.GA24488@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 02, 2007 at 10:10:09AM +0200, Sebastian Siewior wrote:
> It seems that the driver uses something like crypto_.*_ctx_aligned() of his own.
> Replace it with the API's functions. Compile tested.
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Actually this is intentional as it allows the align
operation to be completely optimised out.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
