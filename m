Return-Path: <SRS0=KZld=OW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:50528 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727733AbeLMKdv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Dec 2018 05:33:51 -0500
Date: Thu, 13 Dec 2018 18:33:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: xchacha20 - fix comments for test vectors
Message-ID: <20181213103349.d6uiwdln7ixxac7j@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181206210008.188975-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The kernel's ChaCha20 uses the RFC7539 convention of the nonce being 12
> bytes rather than 8, so actually I only appended 12 random bytes (not
> 16) to its test vectors to form 24-byte nonces for the XChaCha20 test
> vectors.  The other 4 bytes were just from zero-padding the stream
> position to 8 bytes.  Fix the comments above the test vectors.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> crypto/testmgr.h | 14 ++++++--------
> 1 file changed, 6 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
