From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/2] crypto: aead - move aead_request_cast helper to
 aead.h
Date: Sat, 6 Feb 2016 15:46:34 +0800
Message-ID: <20160206074634.GC22220@gondor.apana.org.au>
References: <20160201191730.21093.458.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smueller@chronox.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44039 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbcBFHqn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Feb 2016 02:46:43 -0500
Content-Disposition: inline
In-Reply-To: <20160201191730.21093.458.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 01, 2016 at 11:17:30AM -0800, Tadeusz Struk wrote:
> Move the helper function to common header for everybody to use.
> 
> changes in v2:
> - move the helper to crypto/internal/aead.h
>   instead of crypto/aead.h
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
