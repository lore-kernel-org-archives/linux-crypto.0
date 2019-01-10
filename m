Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:59676 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728181AbfAJOFb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 09:05:31 -0500
Date: Thu, 10 Jan 2019 22:05:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: adiantum - initialize crypto_spawn::inst
Message-ID: <20190110140529.5obcetf3ukrgvfdz@gondor.apana.org.au>
References: <20190106204606.11412-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190106204606.11412-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 06, 2019 at 12:46:05PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> crypto_grab_*() doesn't set crypto_spawn::inst, so templates must set it
> beforehand.  Otherwise it will be left NULL, which causes a crash in
> certain cases where algorithms are dynamically loaded/unloaded.  E.g.
> with CONFIG_CRYPTO_CHACHA20_X86_64=m, the following caused a crash:
> 
>     insmod chacha-x86_64.ko
>     python -c 'import socket; socket.socket(socket.AF_ALG, 5, 0).bind(("skcipher", "adiantum(xchacha12,aes)"))'
>     rmmod chacha-x86_64.ko
>     python -c 'import socket; socket.socket(socket.AF_ALG, 5, 0).bind(("skcipher", "adiantum(xchacha12,aes)"))'
> 
> Fixes: 059c2a4d8e16 ("crypto: adiantum - add Adiantum support")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/adiantum.c | 4 ++++
>  1 file changed, 4 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
