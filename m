From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/8] crypto: akcipher - Changes to asymmetric key API
Date: Fri, 18 Sep 2015 19:35:11 +0800
Message-ID: <20150918113511.GB7638@gondor.apana.org.au>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1>
 <20150909161520.2828.35852.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34761 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbbIRLfP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 07:35:15 -0400
Content-Disposition: inline
In-Reply-To: <20150909161520.2828.35852.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 09, 2015 at 09:15:20AM -0700, Tadeusz Struk wrote:
> Setkey function has been split into set_priv_key and set_pub_key.
> Akcipher requests takes sgl for src and dst instead of void *.
> Users of the API need to be disabled so that the build works fine
> after this patch.
> They will be enabled in subsequent patches.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Either do everything as a single patch (patches 4,6-8) or do it
properly by making incremental changes like what I did with AEAD
and RNG.

In this case I think a single patch is probably the best option.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
