From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - ring returning retry even though ring has
 BW
Date: Sat, 12 Dec 2015 13:43:55 +0800
Message-ID: <20151212054355.GC17504@gondor.apana.org.au>
References: <20151209195945.17552.86742.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: harvijayx.saini@intel.com, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49927 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbbLLFn7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 Dec 2015 00:43:59 -0500
Content-Disposition: inline
In-Reply-To: <20151209195945.17552.86742.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 09, 2015 at 11:59:45AM -0800, Tadeusz Struk wrote:
> From: Harvijay Saini <harvijayx.saini@intel.com>
> 
> When many threads submit multiple requests they get blocked until all
> responses are processed, which prevents them from submitting more requests
> even though there is space on the rings.
> To fix this we need to decrement the inflight counter early to in the callback.
> 
> Signed-off-by: Harvijay Saini <harvijayx.saini@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
