From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: af_alg - add async support to algif_aead
Date: Tue, 5 Apr 2016 20:43:41 +0800
Message-ID: <20160405124341.GA13048@gondor.apana.org.au>
References: <20160311195033.22534.88064.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smueller@chronox.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52248 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758326AbcDEMns (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Apr 2016 08:43:48 -0400
Content-Disposition: inline
In-Reply-To: <20160311195033.22534.88064.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 11, 2016 at 11:50:33AM -0800, Tadeusz Struk wrote:
> Following the async change for algif_skcipher
> this patch adds similar async read to algif_aead.
> 
> changes in v3:
> - add call to aead_reset_ctx directly from aead_put_sgl instead of calling
>   them separatelly one after the other
> - remove wait from aead_sock_destruct function as it is not needed
>   when sock_hold is used
> 
> changes in v2:
> - change internal data structures from fixed size arrays, limited to
>   RSGL_MAX_ENTRIES, to linked list model with no artificial limitation.
> - use sock_kmalloc instead of kmalloc for memory allocation
> - use sock_hold instead of separate atomic ctr to wait for outstanding
>   request
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
