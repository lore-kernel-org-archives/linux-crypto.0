Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:59702 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728181AbfAJOGK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 09:06:10 -0500
Date: Thu, 10 Jan 2019 22:06:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] crypto: sm3 - fix undefined shift by >= width of value
Message-ID: <20190110140607.25stdthan45e7tbl@gondor.apana.org.au>
References: <20190109061241.6943-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190109061241.6943-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 08, 2019 at 10:12:41PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> sm3_compress() calls rol32() with shift >= 32, which causes undefined
> behavior.  This is easily detected by enabling CONFIG_UBSAN.
> 
> Explicitly AND with 31 to make the behavior well defined.
> 
> Fixes: 4f0fc1600edb ("crypto: sm3 - add OSCCA SM3 secure hash")
> Cc: <stable@vger.kernel.org> # v4.15+
> Cc: Gilad Ben-Yossef <gilad@benyossef.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/sm3_generic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
