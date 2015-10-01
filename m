From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: blkcipher and ablkcipher should it be static
Date: Thu, 1 Oct 2015 22:01:47 +0800
Message-ID: <20151001140147.GE27726@gondor.apana.org.au>
References: <d1ae7b48c3c85404ceec994ab2762e947554e9eb.1443365135.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geliang Tang <geliangtang@163.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34005 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbbJAOB5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Oct 2015 10:01:57 -0400
Content-Disposition: inline
In-Reply-To: <d1ae7b48c3c85404ceec994ab2762e947554e9eb.1443365135.git.geliangtang@163.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Sep 27, 2015 at 10:47:05PM +0800, Geliang Tang wrote:
> Fixes the following sparse warnings:
> 
>  crypto/skcipher.c:94:5:
>  warning: symbol 'crypto_init_skcipher_ops_blkcipher'
>  was not declared. Should it be static?
> 
>  crypto/skcipher.c:185:5:
>  warning: symbol 'crypto_init_skcipher_ops_ablkcipher'
>  was not declared. Should it be static?
> 
> Signed-off-by: Geliang Tang <geliangtang@163.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
