From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 2/2] crypto/algapi - make crypto_xor() take separate dst
 and src arguments
Date: Tue, 18 Jul 2017 09:51:21 +0100
Message-ID: <CAKv+Gu_9S4GHmoUE-H8ZLra90OYNPjOwVGi0PJ02WFNDe6udeg@mail.gmail.com>
References: <20170710134548.20234-1-ard.biesheuvel@linaro.org>
 <20170710134548.20234-3-ard.biesheuvel@linaro.org> <20170718083956.GA5813@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        "David S. Miller" <davem@davemloft.net>, dm-devel@redhat.com,
        Johannes Berg <johannes@sipsolutions.net>,
        "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        "Alasdair G. Kergon" <agk@redhat.com>, snitzer@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:35153 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbdGRIvW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 04:51:22 -0400
Received: by mail-io0-f170.google.com with SMTP id k71so9834910iod.2
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jul 2017 01:51:22 -0700 (PDT)
In-Reply-To: <20170718083956.GA5813@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 18 July 2017 at 09:39, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Jul 10, 2017 at 02:45:48PM +0100, Ard Biesheuvel wrote:
>> There are quite a number of occurrences in the kernel of the pattern
>>
>>     if (dst != src)
>>             memcpy(dst, src, walk.total % AES_BLOCK_SIZE);
>>     crypto_xor(dst, final, walk.total % AES_BLOCK_SIZE);
>>
>> or
>>
>>     crypto_xor(keystream, src, nbytes);
>>     memcpy(dst, keystream, nbytes);
>
> What keeping crypto_xor as it is and adding a new entry point for
> the 4-argument case?
>

Also fine.
