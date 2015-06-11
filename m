From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/drbg: report backend_cra_name when allocation
 fails
Date: Thu, 11 Jun 2015 22:00:25 +0800
Message-ID: <20150611140025.GA21446@gondor.apana.org.au>
References: <1433942868-16447-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1433942868-16447-2-git-send-email-sergey.senozhatsky@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	sergey.senozhatsky.work@gmail.com
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34040 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbbFKOA3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2015 10:00:29 -0400
Content-Disposition: inline
In-Reply-To: <1433942868-16447-2-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 10, 2015 at 10:27:48PM +0900, Sergey Senozhatsky wrote:
> Be more verbose and also report ->backend_cra_name when
> crypto_alloc_shash() or crypto_alloc_cipher() fail in
> drbg_init_hash_kernel() or drbg_init_sym_kernel()
> correspondingly.
> 
> Example
>  DRBG: could not allocate digest TFM handle: hmac(sha256)
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
