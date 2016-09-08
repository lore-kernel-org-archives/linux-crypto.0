From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Kernel panic - encryption/decryption failed when open file on
 Arm64
Date: Thu, 8 Sep 2016 20:47:09 +0800
Message-ID: <20160908124709.GA26586@gondor.apana.org.au>
References: <57D15BD3.40903@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, tytso@mit.edu, jaegeuk@kernel.org,
        nhorman@tuxdriver.com, ard.biesheuvel@linaro.org, mh1@iki.fi,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bintian <bintian.wang@huawei.com>, liushuoran@huawei.com,
        Huxinwei <huxinwei@huawei.com>, zhangzhibin.zhang@huawei.com
To: xiakaixu <xiakaixu@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47251 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932478AbcIHMrq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Sep 2016 08:47:46 -0400
Content-Disposition: inline
In-Reply-To: <57D15BD3.40903@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 08, 2016 at 08:38:43PM +0800, xiakaixu wrote:
> Hi,
> 
> I am using the encryption/decryption feature on arm64 board and a kernel
> panic occurs just when open a file.  As the memory size of the board
> is limited
> and there are some page allocation failures before the panic.
> 
> Seems it is a kernel bug from the call trace log.
> 
>     ...
>     - fscrypt_get_encryption_info
>       - get_crypt_info.part.1
>        - validate_user_key.isra.0
>         - derive_aes_gcm_key
>          - crypto_gcm_decrypt
>           - ablk_decrypt
>            - ctr_encrypt
>             - blkcipher_walk_done
>               - blkcipher_walk_next
>                -  __get_free_pages
> ----------------------------------> page allocation failure
>       ...
>            - aes_ctr_encrypt
> -----------------------------------------> the input parameter is
> NULL pointer as the page allocation failure
> 
> 
> The input parameter of function aes_ctr_encrypt() comes from the
> /struct blkcipher_walk//
> //walk/, and this variable /walk /is allocated by the function
> __get_free_pages(). So if this
> page allocate failed, the input parameter of function
> aes_ctr_encrypt() will be NULL. The
> panic will occurs if we don't check the input parameter.
> 
> Not sure about this and wish to get your opinions!

If the page allocation fails in blkcipher_walk_next it'll simply
switch over to processing it block by block. so I don't think the
warning is related to the crash.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
