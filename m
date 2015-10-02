From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 0/3] crypto: akcipher - Changes to asymmetric key API
Date: Fri, 2 Oct 2015 12:04:09 +0800
Message-ID: <20151002040409.GA557@gondor.apana.org.au>
References: <20151001202845.7193.51602.stgit@tstruk-mobl1>
 <20151002032000.GA32754@gondor.apana.org.au>
 <560DFCAA.2040609@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36560 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbbJBEEP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 2 Oct 2015 00:04:15 -0400
Content-Disposition: inline
In-Reply-To: <560DFCAA.2040609@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 01, 2015 at 08:40:26PM -0700, Tadeusz Struk wrote:
> 
> I do use src_len for processing. The sg_len() is still useful for
> parameter checking to make sure that src_len <= sg_len(req->src)

I don't see the point.  We don't check that anywhere else in the
crypto API.  It's the caller's responsibility to provide valid input
parameters.

Untrusted callers must be vetted at the point of entry, i.e.,
algif.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
