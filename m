From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: api - Remove no-op exit_ops code
Date: Fri, 21 Oct 2016 11:14:28 +0800
Message-ID: <20161021031428.GG22979@gondor.apana.org.au>
References: <1475874815-136813-2-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54038 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751873AbcJUDOe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Oct 2016 23:14:34 -0400
Content-Disposition: inline
In-Reply-To: <1475874815-136813-2-git-send-email-ebiggers@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 07, 2016 at 02:13:35PM -0700, Eric Biggers wrote:
> crypto_exit_cipher_ops() and crypto_exit_compress_ops() are no-ops and
> have been for a long time, so remove them.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
