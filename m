From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH][RESEND] crypto: caam - Fixed the memory out of bound
 overwrite issue
Date: Wed, 10 Jul 2013 16:52:05 +1000
Message-ID: <20130710065205.GA32296@gondor.apana.org.au>
References: <1373437573-21588-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Vakul Garg <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:33561 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750736Ab3GJGwH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jul 2013 02:52:07 -0400
Content-Disposition: inline
In-Reply-To: <1373437573-21588-1-git-send-email-vakul@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 10, 2013 at 06:26:13AM +0000, Vakul Garg wrote:
> When kernel is compiled with CONFIG_SLUB_DEBUG=y and
> CRYPTO_MANAGER_DISABLE_TESTS=n, during kernel bootup, the kernel
> reports error given below. The root cause is that in function
> hash_digest_key(), for allocating descriptor, insufficient memory was
> being allocated. The required number of descriptor words apart from
> input and output pointers are 8 (instead of 6).

Patch applied to crypto.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
