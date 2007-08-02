From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch/rfc] crypto: padlock-aes use crypto API
Date: Thu, 2 Aug 2007 17:28:25 +0800
Message-ID: <20070802092825.GA13085@gondor.apana.org.au>
References: <20070802081009.GA24488@Chamillionaire.breakpoint.cc> <20070802085816.GA12882@gondor.apana.org.au> <20070802092351.GA24639@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2731 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754662AbXHBJ22 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Aug 2007 05:28:28 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IGWyo-0007l8-Ck
	for <linux-crypto@vger.kernel.org>; Thu, 02 Aug 2007 19:28:26 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IGWyn-0003PJ-00
	for <linux-crypto@vger.kernel.org>; Thu, 02 Aug 2007 17:28:25 +0800
Content-Disposition: inline
In-Reply-To: <20070802092351.GA24639@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 02, 2007 at 11:23:51AM +0200, Sebastian Siewior wrote:
> 
> The only difference I can see is, that crypto_tfm_alg_alignmask() is
> replaced with a static defined number instead of a lookup in a struct.
> IS this the optimization?

Yes, the fact that the alignment mask is a constant allows
it to be optimised away.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
