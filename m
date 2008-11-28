From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Validate output length in (de)compression tests
Date: Fri, 28 Nov 2008 20:52:17 +0800
Message-ID: <20081128125217.GA31706@gondor.apana.org.au>
References: <Pine.LNX.4.64.0811271847240.10372@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48977 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751290AbYK1MwU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Nov 2008 07:52:20 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811271847240.10372@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 27, 2008 at 06:48:13PM +0100, Geert Uytterhoeven wrote:
> When self-testing (de)compression algorithms, make sure the actual size of
> the (de)compressed output data matches the expected output size.
> Otherwise, in case the actual output size would be smaller than the expected
> output size, the subsequent buffer compare test would still succeed, and no
> error would be reported.
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Nice patch.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
