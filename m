From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: fix invalid select for AKCIPHER
Date: Sun, 21 Jun 2015 20:07:09 +0800
Message-ID: <20150621120709.GB30479@gondor.apana.org.au>
References: <20150619172739.13509.80660.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: andreas.ruprecht@fau.de, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44918 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbbFUMHV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Jun 2015 08:07:21 -0400
Content-Disposition: inline
In-Reply-To: <20150619172739.13509.80660.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 19, 2015 at 10:27:39AM -0700, Tadeusz Struk wrote:
> Should be CRYPTO_AKCIPHER instead of AKCIPHER
> 
> Reported-by: Andreas Ruprecht <andreas.ruprecht@fau.de>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
