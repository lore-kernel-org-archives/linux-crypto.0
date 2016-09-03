From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Re: Who will copy the AAD data to dest. buffer
Date: Sat, 3 Sep 2016 10:45:08 +0530
Message-ID: <CAFXBA=ndKKGhfQdWtRuAAQdeBCeoKyS6-obExPHFjBsrj4OjXw@mail.gmail.com>
References: <CAFXBA=m-Ued+9EGmfwa210cm6HZGxN3P-g_Fsapzcw+a3FKdZw@mail.gmail.com>
 <20160902144203.GA13135@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org, Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36774 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbcICFPJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 3 Sep 2016 01:15:09 -0400
Received: by mail-oi0-f42.google.com with SMTP id w78so341714oie.3
        for <linux-crypto@vger.kernel.org>; Fri, 02 Sep 2016 22:15:09 -0700 (PDT)
In-Reply-To: <20160902144203.GA13135@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks Herbert for clarification. It means Libkcapi documentation
needs update of chapter  "Aead Cipher API".

Regards
Harsh Jain



On Fri, Sep 2, 2016 at 8:12 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Sep 02, 2016 at 08:05:04PM +0530, Harsh Jain wrote:
>> Hi Herbert,
>>
>> Is copy of AAD data to destination buffer when dst != src is mandatory
>> requirements for crypto drivers or we can skip this copy. Actually I
>> am bit confused, In following link Stephen had mentioned caller will
>> memcpy the AAD to destination buffer but authenc.c also copies the AAD
>> to dest. buffer.
>>
>> http://www.chronox.de/libkcapi/html/ch02s02.html
>
> It has to be copied if src != dst.
>
>> Secondly When AAD data remains unchanged in AEAD encryption/decryption
>> operations. Why we copy the same data to destination buffer?
>
> This greatly simplifies the implementation of the AEAD algorithms
> because we can throw away src and use the dst only.  For example,
> authenc hashes the AAD and ciphertext.  If we didn't force the
> copy it would have to hash them separately, meaning the use of
> the slow init/update/final interface.  With the copy it can use
> the digest interface.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
