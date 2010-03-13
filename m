From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Converting mac80211 CCMP to packet-at-a-time processing
Date: Sat, 13 Mar 2010 20:28:47 +0800
Message-ID: <20100313122847.GA26337@gondor.apana.org.au>
References: <1268451778.9161.5.camel@mj>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: roberto.sassu@polito.it, linux-crypto@vger.kernel.org
To: Pavel Roskin <proski@gnu.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60323 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753395Ab0CMM36 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 13 Mar 2010 07:29:58 -0500
Content-Disposition: inline
In-Reply-To: <1268451778.9161.5.camel@mj>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Pavel Roskin <proski@gnu.org> wrote:
> 
> However, it's disappointing that the caller needs to deal explicitly
> with completions.  The blkcipher API is much simpler.  I would have hard
> time advocating a patch to CCMP that makes the code more complicated.

You won't have to deal with completions if you allocate your
algorithm with the CRYPTO_ALG_ASYNC bit off.  Of course you won't
be able to use most hardware accelerations either.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
