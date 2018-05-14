From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 1/2] crypto: vmx - Remove overly verbose printk from AES init routines
Date: Mon, 14 May 2018 21:18:35 +1000
Message-ID: <87po1ypjsk.fsf@concordia.ellerman.id.au>
References: <20180503122930.17448-1-mpe@ellerman.id.au> <20180511161913.nr7woksn2jejipzm@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, mhcerri@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180511161913.nr7woksn2jejipzm@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Thu, May 03, 2018 at 10:29:29PM +1000, Michael Ellerman wrote:
>> In the vmx AES init routines we do a printk(KERN_INFO ...) to report
>> the fallback implementation we're using.
>> 
>> However with a slow console this can significantly affect the speed of
>> crypto operations. Using 'cryptsetup benchmark' the removal of the
>> printk() leads to a ~5x speedup for aes-cbc decryption.
>> 
>> So remove them.
>> 
>> Fixes: 8676590a1593 ("crypto: vmx - Adding AES routines for VMX module")
>> Fixes: 8c755ace357c ("crypto: vmx - Adding CBC routines for VMX module")
>> Fixes: 4f7f60d312b3 ("crypto: vmx - Adding CTR routines for VMX module")
>> Fixes: cc333cd68dfa ("crypto: vmx - Adding GHASH routines for VMX module")
>> Cc: stable@vger.kernel.org # v4.1+
>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>> ---
>>  drivers/crypto/vmx/aes.c     | 2 --
>>  drivers/crypto/vmx/aes_cbc.c | 3 ---
>>  drivers/crypto/vmx/aes_ctr.c | 2 --
>>  drivers/crypto/vmx/ghash.c   | 2 --
>>  4 files changed, 9 deletions(-)
>
> Patch applied.  Thanks.

Thanks.

>> If this is the wrong fix please let me know, I'm not a crypto expert.
>> 
>> What we see is 'cryptsetup benchmark' causing thousands of these printks() to
>> happen. The call trace is something like:
>> 
>> [c000001e47867a60] [c0000000009cf6b4] p8_aes_cbc_init+0x74/0xf0
>> [c000001e47867ae0] [c000000000551a80] __crypto_alloc_tfm+0x1d0/0x2c0
>> [c000001e47867b20] [c00000000055aea4] crypto_skcipher_init_tfm+0x124/0x280
>> [c000001e47867b60] [c00000000055138c] crypto_create_tfm+0x9c/0x1a0
>> [c000001e47867ba0] [c000000000552220] crypto_alloc_tfm+0xa0/0x140
>> [c000001e47867c00] [c00000000055b168] crypto_alloc_skcipher+0x48/0x70
>> [c000001e47867c40] [c00000000057af28] skcipher_bind+0x38/0x50
>> [c000001e47867c80] [c00000000057a07c] alg_bind+0xbc/0x220
>> [c000001e47867d10] [c000000000a016a0] __sys_bind+0x90/0x100
>> [c000001e47867df0] [c000000000a01750] sys_bind+0x40/0x60
>> [c000001e47867e30] [c00000000000b320] system_call+0x58/0x6c
>> 
>> 
>> Is it normal for init to be called on every system call?
>
> This is the tfm init function, so yes it is called every time
> you allocate a tfm.

OK thanks. So we just shouldn't be printk'ing in there in the non-error
path, good to know.

cheers
