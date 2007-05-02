From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/6] [CRYPTO] cryptd: Add software async crypto daemon
Date: Wed, 2 May 2007 19:32:56 +1000
Message-ID: <20070502093256.GA16784@gondor.apana.org.au>
References: <<20070416105105.GA10188@gondor.apana.org.au>> <E1HdOom-0002uK-00@gondolin.me.apana.org.au> <20070501142329.GA3490@2ka.mipt.ru> <20070502045721.GC29384@gondor.apana.org.au> <20070502091433.GA31022@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1862 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992960AbXEBJdA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 May 2007 05:33:00 -0400
Content-Disposition: inline
In-Reply-To: <20070502091433.GA31022@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, May 02, 2007 at 01:14:33PM +0400, Evgeniy Polyakov wrote:
> 
> I.e. do not use uncommented^Wencrypted cryptd source, but just write a
> driver with couple of algorithms with magic CRYPTO_ALG_ASYNC bit set in
> its flags? That would be much simpler.

Well cryptd isn't completely useless for you either.  You just need to
ignore the template-specific bits.  All the rest would apply to any
async blkcipher driver.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
