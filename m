From: xiakaixu <xiakaixu@huawei.com>
Subject: Re: Kernel panic - encryption/decryption failed when open file on
 Arm64
Date: Fri, 9 Sep 2016 18:19:36 +0800
Message-ID: <57D28CB8.4080904@huawei.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160908124709.GA26586@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

After a deeply research about this crash, seems it is a specific
bug that only exists in armv8 board. And it occurs in this function
in arch/arm64/crypto/aes-glue.c.

static int ctr_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
                        struct scatterlist *src, unsigned int nbytes)
{
        ...

         desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
         blkcipher_walk_init(&walk, dst, src, nbytes);
         err = blkcipher_walk_virt_block(desc, &walk, AES_BLOCK_SIZE); ---> page allocation failed

	...

         while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {           ----> walk.nbytes = 0, and skip this loop
                 aes_ctr_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
                                 (u8 *)ctx->key_enc, rounds, blocks, walk.iv,
                                 first);
	...
                 err = blkcipher_walk_done(desc, &walk,
                                           walk.nbytes % AES_BLOCK_SIZE);
         }
         if (nbytes) {                                                 ----> enter this if() statement
                 u8 *tdst = walk.dst.virt.addr + blocks * AES_BLOCK_SIZE;
                 u8 *tsrc = walk.src.virt.addr + blocks * AES_BLOCK_SIZE;
	...

                 aes_ctr_encrypt(tail, tsrc, (u8 *)ctx->key_enc, rounds,  ----> the the sencond input parameter is NULL, so crash...
                                 blocks, walk.iv, first);
	...
         }
         ...
}


If the page allocation failed in the function blkcipher_walk_virt_block(),
the variable walk.nbytes = 0, so it will skip the while() loop and enter
the if(nbytes) statment. But here the varibale tsrc is NULL and it is also
the sencond input parameter of the function aes_ctr_encrypt()... Kernel Panic...

I have also researched the similar function in other architectures, and
there if(walk.nbytes) is used, not this if(nbytes) statement in the armv8.
so I think this armv8 function ctr_encrypt() should deal with the page
allocation failed situation.

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
