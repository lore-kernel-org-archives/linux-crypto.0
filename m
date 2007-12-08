From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] Geode: Copy the IV back in case of an fallback.
Date: Sat, 8 Dec 2007 09:46:41 +0800
Message-ID: <20071208014641.GC16140@gondor.apana.org.au>
References: <20071207182405.GA24292@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1411 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754593AbXLHBqo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Dec 2007 20:46:44 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J0omA-0001ZN-Hi
	for <linux-crypto@vger.kernel.org>; Sat, 08 Dec 2007 12:46:42 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1J0om9-0004Eb-00
	for <linux-crypto@vger.kernel.org>; Sat, 08 Dec 2007 09:46:41 +0800
Content-Disposition: inline
In-Reply-To: <20071207182405.GA24292@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 07, 2007 at 07:24:05PM +0100, Sebastian Siewior wrote:
> Jan pointed this out to me and fixed it in the fallback code for s390
> and now I remembered that this could also be fixed here :)
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

No, the default IV is put into desc->info by the system.

I see where the problem is though.  We should never call the
functions crypto_blkcipher_encrypt/decrypt, it should always be
crypto_blkcipher_encrypt_iv/crypto_blkcipher_decrypt_iv.

Please make a patch to get the fallback to do that.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
