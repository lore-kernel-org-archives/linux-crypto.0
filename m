From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [cryptodev:master 62/75] crypto/rsa-pkcs1pad.c:680:21: error:
 assignment from incompatible pointer type
Date: Tue, 13 Jun 2017 11:15:01 +0300
Message-ID: <17f39eb5-cfec-0e5b-9367-c3f0c8e10dfc@microchip.com>
References: <201706130933.8QjNp9hg%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kbuild test robot <fengguang.wu@intel.com>, <kbuild-all@01.org>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:26827 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751753AbdFMIPC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Jun 2017 04:15:02 -0400
In-Reply-To: <201706130933.8QjNp9hg%fengguang.wu@intel.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Herbert,

Sorry, I thought that is better to make a patch for each driver.

Bisectibility is affected because I changed the declaration of max_size
function to return an unsigned int instead of an int, but I updated
each driver that uses this function in a different patch.

Bisectibility will be ok if we squash the patch that modifies the
declaration with the ones that use it. This also applies for kpp.

How should I proceed from here?

Thanks,
ta

On 13.06.2017 04:34, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   48df28b85991ac67a2270f0bb818221527834b78
> commit: 561f8e2df990a7a2859a98bd208d0f7dc932c3f7 [62/75] crypto: akcipher - assume key is already set in maxsize
> config: x86_64-randconfig-x019-201724 (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>          git checkout 561f8e2df990a7a2859a98bd208d0f7dc932c3f7
>          # save the attached .config to linux build tree
>          make ARCH=x86_64
> 
> Note: the cryptodev/master HEAD 48df28b85991ac67a2270f0bb818221527834b78 builds fine.
>        It only hurts bisectibility.
> 
> All errors (new ones prefixed by >>):
> 
>     crypto/rsa-pkcs1pad.c: In function 'pkcs1pad_create':
>>> crypto/rsa-pkcs1pad.c:680:21: error: assignment from incompatible pointer type [-Werror=incompatible-pointer-types]
>       inst->alg.max_size = pkcs1pad_get_max_size;
>                          ^
>     cc1: some warnings being treated as errors
> 
> vim +680 crypto/rsa-pkcs1pad.c
> 
> a49de377 Tadeusz Struk      2016-03-03  664  	    CRYPTO_MAX_ALG_NAME)
> c0d20d22 Herbert Xu         2016-06-29  665  		goto out_drop_alg;
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  666
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  667  	inst->alg.base.cra_flags = rsa_alg->base.cra_flags & CRYPTO_ALG_ASYNC;
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  668  	inst->alg.base.cra_priority = rsa_alg->base.cra_priority;
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  669  	inst->alg.base.cra_ctxsize = sizeof(struct pkcs1pad_ctx);
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  670
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  671  	inst->alg.init = pkcs1pad_init_tfm;
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  672  	inst->alg.exit = pkcs1pad_exit_tfm;
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  673
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  674  	inst->alg.encrypt = pkcs1pad_encrypt;
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  675  	inst->alg.decrypt = pkcs1pad_decrypt;
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  676  	inst->alg.sign = pkcs1pad_sign;
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  677  	inst->alg.verify = pkcs1pad_verify;
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  678  	inst->alg.set_pub_key = pkcs1pad_set_pub_key;
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  679  	inst->alg.set_priv_key = pkcs1pad_set_priv_key;
> 3d5b1ecd Andrzej Zaborowski 2015-12-05 @680  	inst->alg.max_size = pkcs1pad_get_max_size;
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  681  	inst->alg.reqsize = sizeof(struct pkcs1pad_request) + rsa_alg->reqsize;
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  682
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  683  	inst->free = pkcs1pad_free;
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  684
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  685  	err = akcipher_register_instance(tmpl, inst);
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  686  	if (err)
> c0d20d22 Herbert Xu         2016-06-29  687  		goto out_drop_alg;
> 3d5b1ecd Andrzej Zaborowski 2015-12-05  688
> 
> :::::: The code at line 680 was first introduced by commit
> :::::: 3d5b1ecdea6fb94f8c61554fcb2ba776a2d3d0e6 crypto: rsa - RSA padding algorithm
> 
> :::::: TO: Andrzej Zaborowski <andrew.zaborowski@intel.com>
> :::::: CC: Herbert Xu <herbert@gondor.apana.org.au>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
