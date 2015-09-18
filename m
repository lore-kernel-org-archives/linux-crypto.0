From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/8] crypto: akcipher - return status from
 crypto_unregister_alg
Date: Fri, 18 Sep 2015 19:29:33 +0800
Message-ID: <20150918112933.GA7638@gondor.apana.org.au>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1>
 <20150909161501.2828.78012.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57113 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbbIRL3i (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 07:29:38 -0400
Content-Disposition: inline
In-Reply-To: <20150909161501.2828.78012.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 09, 2015 at 09:15:01AM -0700, Tadeusz Struk wrote:
> Return status from crypto_unregister_alg to the caller.

Why? My plan is to turn crypto_unregister_alg into a void function.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
