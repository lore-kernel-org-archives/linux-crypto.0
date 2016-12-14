From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: skcipher - fix crash in virtual walk
Date: Wed, 14 Dec 2016 18:39:05 +0800
Message-ID: <20161214103905.GB11960@gondor.apana.org.au>
References: <1481636042-27347-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58077 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755377AbcLNKje (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Dec 2016 05:39:34 -0500
Content-Disposition: inline
In-Reply-To: <1481636042-27347-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 13, 2016 at 01:34:02PM +0000, Ard Biesheuvel wrote:
> The new skcipher walk API may crash in the following way. (Interestingly,
> the tcrypt boot time tests seem unaffected, while an explicit test using
> the module triggers it)
> 
>   Unable to handle kernel NULL pointer dereference at virtual address 00000000
>   ...
>   [<ffff000008431d84>] __memcpy+0x84/0x180
>   [<ffff0000083ec0d0>] skcipher_walk_done+0x328/0x340
>   [<ffff0000080c5c04>] ctr_encrypt+0x84/0x100
>   [<ffff000008406d60>] simd_skcipher_encrypt+0x88/0x98
>   [<ffff0000083fa05c>] crypto_rfc3686_crypt+0x8c/0x98
>   [<ffff0000009b0900>] test_skcipher_speed+0x518/0x820 [tcrypt]
>   [<ffff0000009b31c0>] do_test+0x1408/0x3b70 [tcrypt]
>   [<ffff0000009bd050>] tcrypt_mod_init+0x50/0x1000 [tcrypt]
>   [<ffff0000080838f4>] do_one_initcall+0x44/0x138
>   [<ffff0000081aee60>] do_init_module+0x68/0x1e0
>   [<ffff0000081524d0>] load_module+0x1fd0/0x2458
>   [<ffff000008152c38>] SyS_finit_module+0xe0/0xf0
>   [<ffff0000080836f0>] el0_svc_naked+0x24/0x28
> 
> This is due to the fact that skcipher_done_slow() may be entered with
> walk->buffer unset. Since skcipher_walk_done() already deals with the
> case where walk->buffer == walk->page, it appears to be the intention
> that walk->buffer point to walk->page after skcipher_next_slow(), so
> ensure that is the case.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
