From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aead - move aead_request_cast helper to aead.h
Date: Mon, 1 Feb 2016 17:46:33 +0800
Message-ID: <20160201094633.GA6299@gondor.apana.org.au>
References: <20160127220916.12466.99501.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smueller@chronox.de, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36884 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbcBAJqn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 04:46:43 -0500
Content-Disposition: inline
In-Reply-To: <20160127220916.12466.99501.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 27, 2016 at 02:09:16PM -0800, Tadeusz Struk wrote:
> Move the helper function to common header for everybody to use.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

This should go into internal/aead.h if at all.  Longer term we
should look for ways to do away with direct uses of crypto_async_request.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
