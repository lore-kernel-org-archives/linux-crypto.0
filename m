From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4] crypto: AF_ALG - fix AEAD tag memory handling
Date: Wed, 7 Dec 2016 19:42:45 +0800
Message-ID: <20161207114245.GA20486@gondor.apana.org.au>
References: <2319539.qMqmu7oTgO@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43624 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751563AbcLGLm7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2016 06:42:59 -0500
Content-Disposition: inline
In-Reply-To: <2319539.qMqmu7oTgO@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 05, 2016 at 03:26:19PM +0100, Stephan Mueller wrote:
> Hi Herbert,
> 
> Changes v4: restore the old behavior -- if the caller does not provide sufficient
> output buffer size, return an error.
> 
> ---8<---
> 
> For encryption, the AEAD ciphers require AAD || PT as input and generate
> AAD || CT || Tag as output and vice versa for decryption. Prior to this
> patch, the AF_ALG interface for AEAD ciphers requires the buffer to be
> present as input for encryption. Similarly, the output buffer for
> decryption required the presence of the tag buffer too. This implies
> that the kernel reads / writes data buffers from/to kernel space
> even though this operation is not required.
> 
> This patch changes the AF_ALG AEAD interface to be consistent with the
> in-kernel AEAD cipher requirements.
> 
> Due to this handling, he changes are transparent to user space with one
> exception: the return code of recv indicates the mount of output buffer.
> That output buffer has a different size compared to before the patch
> which implies that the return code of recv will also be different.
> For example, a decryption operation uses 16 bytes AAD, 16 bytes CT and
> 16 bytes tag, the AF_ALG AEAD interface before showed a recv return
> code of 48 (bytes) whereas after this patch, the return code is 32
> since the tag is not returned any more.
> 
> Reported-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Hmm, I don't see the code that copies the AAD over.  Did I miss it?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
