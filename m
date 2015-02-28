From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: aesni - make driver-gcm-aes-aesni helper a proper aead
 alg
Date: Sat, 28 Feb 2015 23:33:04 +1300
Message-ID: <20150228103304.GA7591@gondor.apana.org.au>
References: <20150206182520.5705.54282.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adrian.hoban@intel.com, linux-crypto@vger.kernel.org,
	davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:43657 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbbB1KdL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 28 Feb 2015 05:33:11 -0500
Content-Disposition: inline
In-Reply-To: <20150206182520.5705.54282.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 06, 2015 at 10:25:20AM -0800, Tadeusz Struk wrote:
> Changed the __driver-gcm-aes-aesni to be a proper aead algorithm.
> This required a valid setkey and setauthsize functions to be added and also
> some changes to make sure that math context is not corrupted when the alg is
> used directly.
> Note that the __driver-gcm-aes-aesni should not be used directly by modules
> that can use it in interrupt context as we don't have a good fallback mechanism
> in this case.
> 
> Signed-off-by: Adrian Hoban <adrian.hoban@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
