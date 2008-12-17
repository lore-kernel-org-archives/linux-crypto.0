From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4] crypto: des3_ede: permit weak keys unless
	REQ_WEAK_KEY set
Date: Wed, 17 Dec 2008 16:51:24 +1100
Message-ID: <20081217055124.GB14432@gondor.apana.org.au>
References: <200812041557.49601.jarod@redhat.com> <20081205152427.GA32475@gondor.apana.org.au> <200812051458.10426.jarod@redhat.com> <200812081041.42296.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
	linux-kernel@vger.kernel.org
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:32982 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750903AbYLQFva (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Dec 2008 00:51:30 -0500
Content-Disposition: inline
In-Reply-To: <200812081041.42296.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 08, 2008 at 10:41:41AM -0500, Jarod Wilson wrote:
> While its a slightly insane to bypass the key1 == key2 ||
> key2 == key3 check in triple-des, since it reduces it to the
> same strength as des, some folks do need to do this from time
> to time for backwards compatibility with des.
> 
> My own case is FIPS CAVS test vectors. Many triple-des test
> vectors use a single key, replicated 3x. In order to get the
> expected results, des3_ede_setkey() needs to only reject weak
> keys if the CRYPTO_TFM_REQ_WEAK_KEY flag is set.
> 
> Also sets a more appropriate RES flag when a weak key is found.
> 
> This time, hopefully without unintended line wrapping...
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Patch applied.  Thanks Jarod!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
