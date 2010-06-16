From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: talitos - fix ahash for multiple of blocksize
Date: Wed, 16 Jun 2010 15:29:25 +1000
Message-ID: <20100616052925.GA18745@gondor.apana.org.au>
References: <1276232130-19759-1-git-send-email-lee.nipper@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Lee Nipper <lee.nipper@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:58110 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753622Ab0FPF3a (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jun 2010 01:29:30 -0400
Content-Disposition: inline
In-Reply-To: <1276232130-19759-1-git-send-email-lee.nipper@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 11, 2010 at 04:55:30AM +0000, Lee Nipper wrote:
> Correct ahash_process_req() to properly handle cases
> where the total hash amount is a multiple of the blocksize.
> The SEC must have some data to hash during the very last
> descriptor operation; so up to one whole blocksize
> of data is buffered until the final hash.
> 
> Signed-off-by: Lee Nipper <lee.nipper@gmail.com>

Patch applied.  Thanks Lee!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
