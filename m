From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: gcm - make GMAC work when dst and src are
 different
Date: Wed, 10 Apr 2013 11:32:06 +0800
Message-ID: <20130410033206.GB32360@gondor.apana.org.au>
References: <20130407134340.8718.96643.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:41642 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755146Ab3DJDcJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Apr 2013 23:32:09 -0400
Content-Disposition: inline
In-Reply-To: <20130407134340.8718.96643.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Apr 07, 2013 at 04:43:41PM +0300, Jussi Kivilinna wrote:
> The GMAC code assumes that dst==src, which causes problems when trying to add
> rfc4543(gcm(aes)) test vectors.
> 
> So fix this code to work when source and destination buffer are different.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

All applied.  Thanks Jussi!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
