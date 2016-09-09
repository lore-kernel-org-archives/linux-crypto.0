From: xiakaixu <xiakaixu@huawei.com>
Subject: Re: Kernel panic - encryption/decryption failed when open file on
 Arm64
Date: Fri, 9 Sep 2016 12:08:51 +0800
Message-ID: <57D235D3.9010107@huawei.com>
References: <57D15BD3.40903@huawei.com>
 <20160908124709.GA26586@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <davem@davemloft.net>, <tytso@mit.edu>, <jaegeuk@kernel.org>,
        <nhorman@tuxdriver.com>, <ard.biesheuvel@linaro.org>, <mh1@iki.fi>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bintian <bintian.wang@huawei.com>, <liushuoran@huawei.com>,
        Huxinwei <huxinwei@huawei.com>, <zhangzhibin.zhang@huawei.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:36481 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750710AbcIIEJk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Sep 2016 00:09:40 -0400
In-Reply-To: <20160908124709.GA26586@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sorry for resend this email, just add the linux-crypto@vger.kernel.org
and linux-kernel@vger.kernel.org.


Hi,

Firstly, thanks for your reply!

To reproduce this kernel panic, I test the encryption/decryption feature 
on arm64 board with more memory. Just add the following
change:

     diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
     index 0122bec..10ef3f4 100644
     --- a/crypto/blkcipher.c
     +++ b/crypto/blkcipher.c
     @@ -240,6 +240,7 @@ static int blkcipher_walk_next(struct 
blkcipher_desc *desc,
                     walk->flags |= BLKCIPHER_WALK_COPY;
                     if (!walk->page) {
                             walk->page = (void 
*)__get_free_page(GFP_ATOMIC);
     +                      walk->page = NULL;
                             if (!walk->page)
                                     n = 0;
                     }


This change just set the walk->page to NULL manually.
I get the same crash when open file with the above change log. So I 
think this NULL page failure is not be handled correctly in current code.

Regards
Kaixu Xia

> On Thu, Sep 08, 2016 at 08:38:43PM +0800, xiakaixu wrote:
>> Hi,
>>
>> I am using the encryption/decryption feature on arm64 board and a kernel
>> panic occurs just when open a file.  As the memory size of the board
>> is limited
>> and there are some page allocation failures before the panic.
>>
>> Seems it is a kernel bug from the call trace log.
>>
>>      ...
>>      - fscrypt_get_encryption_info
>>        - get_crypt_info.part.1
>>         - validate_user_key.isra.0
>>          - derive_aes_gcm_key
>>           - crypto_gcm_decrypt
>>            - ablk_decrypt
>>             - ctr_encrypt
>>              - blkcipher_walk_done
>>                - blkcipher_walk_next
>>                 -  __get_free_pages
>> ----------------------------------> page allocation failure
>>        ...
>>             - aes_ctr_encrypt
>> -----------------------------------------> the input parameter is
>> NULL pointer as the page allocation failure
>>
>>
>> The input parameter of function aes_ctr_encrypt() comes from the
>> /struct blkcipher_walk//
>> //walk/, and this variable /walk /is allocated by the function
>> __get_free_pages(). So if this
>> page allocate failed, the input parameter of function
>> aes_ctr_encrypt() will be NULL. The
>> panic will occurs if we don't check the input parameter.
>>
>> Not sure about this and wish to get your opinions!
>
> If the page allocation fails in blkcipher_walk_next it'll simply
> switch over to processing it block by block. so I don't think the
> warning is related to the crash.
>
> Cheers,
>
