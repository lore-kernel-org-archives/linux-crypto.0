From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: skcipher - Remove unused
 crypto_lookup_skcipher() declaration
Date: Fri, 21 Oct 2016 11:14:10 +0800
Message-ID: <20161021031409.GF22979@gondor.apana.org.au>
References: <1475874815-136813-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33541 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbcJUDOQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Oct 2016 23:14:16 -0400
Content-Disposition: inline
In-Reply-To: <1475874815-136813-1-git-send-email-ebiggers@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 07, 2016 at 02:13:34PM -0700, Eric Biggers wrote:
> The definition of crypto_lookup_skcipher() was already removed in
> commit 3a01d0ee2b99 ("crypto: skcipher - Remove top-level givcipher
> interface").  So the declaration should be removed too.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
