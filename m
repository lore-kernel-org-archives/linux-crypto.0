From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algif_aead - fix invalid sgl linking
Date: Mon, 18 May 2015 12:17:11 +0800
Message-ID: <20150518041711.GA13167@gondor.apana.org.au>
References: <20150515171837.5222.92988.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smueller@chronox.de, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53639 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbbERERW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 May 2015 00:17:22 -0400
Content-Disposition: inline
In-Reply-To: <20150515171837.5222.92988.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 15, 2015 at 10:18:37AM -0700, Tadeusz Struk wrote:
> The current linking of receive sgls is invalid.
> It only works with a single list, but when multiple rsgls are being chained
> the list is built incorrectly. The following example, when run on the existing
> implementation causes an Oops.

Patch applied to crypto.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
