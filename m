From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: Kernel panic - encryption/decryption failed when open file on Arm64
Date: Fri, 9 Sep 2016 11:31:47 +0100
Message-ID: <CAKv+Gu9JDCHDteOvgpEg4SJP4OKgM6=euF3pzBcXDJxTt=dAYg@mail.gmail.com>
References: <57D15BD3.40903@huawei.com> <20160908124709.GA26586@gondor.apana.org.au>
 <57D28CB8.4080904@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
        nhorman@tuxdriver.com, mh1@iki.fi,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bintian <bintian.wang@huawei.com>, liushuoran@huawei.com,
        Huxinwei <huxinwei@huawei.com>, zhangzhibin.zhang@huawei.com
To: xiakaixu <xiakaixu@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <57D28CB8.4080904@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 9 September 2016 at 11:19, xiakaixu <xiakaixu@huawei.com> wrote:
> Hi,
>
> After a deeply research about this crash, seems it is a specific
> bug that only exists in armv8 board. And it occurs in this function
> in arch/arm64/crypto/aes-glue.c.
>
> static int ctr_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
>                        struct scatterlist *src, unsigned int nbytes)
> {
>        ...
>
>         desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
>         blkcipher_walk_init(&walk, dst, src, nbytes);
>         err = blkcipher_walk_virt_block(desc, &walk, AES_BLOCK_SIZE); --->
> page allocation failed
>
>         ...
>
>         while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {           ---->
> walk.nbytes = 0, and skip this loop
>                 aes_ctr_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
>                                 (u8 *)ctx->key_enc, rounds, blocks, walk.iv,
>                                 first);
>         ...
>                 err = blkcipher_walk_done(desc, &walk,
>                                           walk.nbytes % AES_BLOCK_SIZE);
>         }
>         if (nbytes) {                                                 ---->
> enter this if() statement
>                 u8 *tdst = walk.dst.virt.addr + blocks * AES_BLOCK_SIZE;
>                 u8 *tsrc = walk.src.virt.addr + blocks * AES_BLOCK_SIZE;
>         ...
>
>                 aes_ctr_encrypt(tail, tsrc, (u8 *)ctx->key_enc, rounds,
> ----> the the sencond input parameter is NULL, so crash...
>                                 blocks, walk.iv, first);
>         ...
>         }
>         ...
> }
>
>
> If the page allocation failed in the function blkcipher_walk_virt_block(),
> the variable walk.nbytes = 0, so it will skip the while() loop and enter
> the if(nbytes) statment. But here the varibale tsrc is NULL and it is also
> the sencond input parameter of the function aes_ctr_encrypt()... Kernel
> Panic...
>
> I have also researched the similar function in other architectures, and
> there if(walk.nbytes) is used, not this if(nbytes) statement in the armv8.
> so I think this armv8 function ctr_encrypt() should deal with the page
> allocation failed situation.
>

OK, thanks for the report, and for the analysis. I will investigate,
and propose a fix

Thanks,
Ard.
