From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Who will copy the AAD data to dest. buffer
Date: Fri, 2 Sep 2016 22:42:03 +0800
Message-ID: <20160902144203.GA13135@gondor.apana.org.au>
References: <CAFXBA=m-Ued+9EGmfwa210cm6HZGxN3P-g_Fsapzcw+a3FKdZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Stephan Mueller <smueller@chronox.de>
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35125 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753490AbcIBOm1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Sep 2016 10:42:27 -0400
Content-Disposition: inline
In-Reply-To: <CAFXBA=m-Ued+9EGmfwa210cm6HZGxN3P-g_Fsapzcw+a3FKdZw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 02, 2016 at 08:05:04PM +0530, Harsh Jain wrote:
> Hi Herbert,
> 
> Is copy of AAD data to destination buffer when dst != src is mandatory
> requirements for crypto drivers or we can skip this copy. Actually I
> am bit confused, In following link Stephen had mentioned caller will
> memcpy the AAD to destination buffer but authenc.c also copies the AAD
> to dest. buffer.
> 
> http://www.chronox.de/libkcapi/html/ch02s02.html

It has to be copied if src != dst.

> Secondly When AAD data remains unchanged in AEAD encryption/decryption
> operations. Why we copy the same data to destination buffer?

This greatly simplifies the implementation of the AEAD algorithms
because we can throw away src and use the dst only.  For example,
authenc hashes the AAD and ciphertext.  If we didn't force the
copy it would have to hash them separately, meaning the use of
the slow init/update/final interface.  With the copy it can use
the digest interface.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
