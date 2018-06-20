From: Christophe LEROY <christophe.leroy@c-s.fr>
Subject: Re: [PATCH 01/11] crypto: shash: Remove VLA usage
Date: Wed, 20 Jun 2018 22:39:58 +0200
Message-ID: <073a8f9e-8ad5-6fd5-e9b8-33e2c9a65e37@c-s.fr>
References: <20180620190408.45104-1-keescook@chromium.org>
 <20180620190408.45104-2-keescook@chromium.org>
 <638faf05-946a-1345-dda4-f75fee5b07d9@c-s.fr>
 <CAGXu5jKmZ2jn1V8rd3B5BcS0z_WOj0x4eThSG=DYdxSj+fnd2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alasdair Kergon <agk@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>, qat-linux@intel.com,
        dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jKmZ2jn1V8rd3B5BcS0z_WOj0x4eThSG=DYdxSj+fnd2g@mail.gmail.com>
Content-Language: fr
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



Le 20/06/2018 à 22:36, Kees Cook a écrit :
> On Wed, Jun 20, 2018 at 12:30 PM, Christophe Leroy
> <christophe.leroy@c-s.fr> wrote:
>>
>>
>> On 06/20/2018 07:03 PM, Kees Cook wrote:
>>>
>>> In the quest to remove all stack VLA usage from the kernel[1], this
>>> removes the VLAs in SHASH_DESC_ON_STACK (via crypto_shash_descsize())
>>> by using the maximum allowable size (which is now more clearly captured
>>> in a macro). Similar limits are turned into macros as well.
>>>
>>> [1]
>>> https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>>>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>
>>
>> Got the following warnings:
>>
>> crypto/testmgr.c: In function ‘alg_test_crc32c.part.4’:
>> crypto/testmgr.c:1896:1: warning: the frame size of 2088 bytes is larger
>> than 1024 bytes [-Wframe-larger-than=]
>> crypto/hmac.c: In function ‘hmac_setkey’:
>> crypto/hmac.c:88:1: warning: the frame size of 2088 bytes is larger than
>> 1024 bytes [-Wframe-larger-than=]
> 
> Ah yes. I didn't do 32-bit builds. So, here's the issue: this uncovers
> the frame size problems that were hidden by in being a VLA before. It
> was always possible for the frame to get this big, it's just that the
> compiler couldn't see it.
> 
> For qat, I raised the -Wframe-larger-than flag. It seems we'll need to
> do this in some other places too.

Maybe the issue is because I have selected 16k pages ?

Christophe

> 
> -Kees
> 
