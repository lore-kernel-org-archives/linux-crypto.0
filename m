From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RESEND 2/2] crypto: algif - change algif_skcipher to be
 asynchronous
Date: Fri, 6 Mar 2015 23:09:56 +1100
Message-ID: <20150306120956.GA5715@gondor.apana.org.au>
References: <20150227193538.10553.6144.stgit@tstruk-mobl1>
 <20150227193549.10553.52267.stgit@tstruk-mobl1>
 <20150306114417.GA4949@gondor.apana.org.au>
 <54F997E1.8050601@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:50103 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbbCFMJ7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Mar 2015 07:09:59 -0500
Content-Disposition: inline
In-Reply-To: <54F997E1.8050601@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 06, 2015 at 12:04:49PM +0000, Tadeusz Struk wrote:
> It helps to make it faster.
> This way I can do some of the request setup beforehand and minimize overhead on the data path.

Do you have numbers to back this up?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
