From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: gcm - Fix IV buffer size in crypto_gcm_setkey
Date: Sun, 2 Oct 2016 22:38:13 +0800
Message-ID: <20161002143813.GD18268@gondor.apana.org.au>
References: <1474620452-7278-1-git-send-email-omosnacek@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Ondrej Mosnacek <omosnacek@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36366 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751639AbcJBOiQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Oct 2016 10:38:16 -0400
Content-Disposition: inline
In-Reply-To: <1474620452-7278-1-git-send-email-omosnacek@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 23, 2016 at 10:47:32AM +0200, Ondrej Mosnacek wrote:
> The cipher block size for GCM is 16 bytes, and thus the CTR transform
> used in crypto_gcm_setkey() will also expect a 16-byte IV. However,
> the code currently reserves only 8 bytes for the IV, causing
> an out-of-bounds access in the CTR transform. This patch fixes
> the issue by setting the size of the IV buffer to 16 bytes.
> 
> Fixes: 84c911523020 ("[CRYPTO] gcm: Add support for async ciphers")
> Signed-off-by: Ondrej Mosnacek <omosnacek@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
