Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0156C433E6
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 20:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0B85601FC
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 20:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241813AbhCAUhS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Mar 2021 15:37:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:51354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237307AbhCAUds (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Mar 2021 15:33:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6319B64F13;
        Mon,  1 Mar 2021 18:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614623423;
        bh=xUaeibXatA3E/fnkKaWrEFY9LwgQ7UQ40j4QBxDkJiI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RtuGGTWJLZHoBSQ+bdltuAbkcDURW6hWwVVwl5XxYfqTw3BBg9GeCC4lc1YYcxySh
         Kh1uukcimvkvP3KLgFXHMiGkFShG8AWNCOpBqG9gsCnlZNteoGLiQtnRJDD99y8G+U
         OrvvFSt2BxJVC9FCSYF2d+zXGnzIRToNXa5uVhl3Yn2BvRc/WHe+db7e7w2XZVQlQA
         yJy5ZYbqFM7dBFFSzKFNm1TkrJ7K5999dZZVIYRh+Gck4uKG10c5ODvannetgeqLue
         aNhAdbglm5PnUkykGARKGwLq2znzhUu1XjuAMispa2Wy58Bvs4E3cI88wFW9lg+/iV
         0n1b+HLebiPmA==
Date:   Mon, 1 Mar 2021 10:30:21 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        syzbot+12cf5fbfdeba210a89dd@syzkaller.appspotmail.com
Subject: Re: [PATCH] crypto: api - check for ERR pointers in
 crypto_destroy_tfm()
Message-ID: <YD0yvYc22b17HVEw@gmail.com>
References: <20210228122824.5441-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210228122824.5441-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Feb 28, 2021 at 01:28:24PM +0100, Ard Biesheuvel wrote:
> Given that crypto_alloc_tfm() may return ERR pointers, and to avoid
> crashes on obscure error paths where such pointers are presented to
> crypto_destroy_tfm() (such as [0]), add an ERR_PTR check there
> before dereferencing the second argument as a struct crypto_tfm
> pointer.
> 
> [0] https://lore.kernel.org/linux-crypto/000000000000de949705bc59e0f6@google.com/
> 
> Reported-by: syzbot+12cf5fbfdeba210a89dd@syzkaller.appspotmail.com
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  crypto/api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/api.c b/crypto/api.c
> index ed08cbd5b9d3..c4eda56cff89 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -562,7 +562,7 @@ void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm)
>  {
>  	struct crypto_alg *alg;
>  
> -	if (unlikely(!mem))
> +	if (IS_ERR_OR_NULL(mem))
>  		return;
>  
>  	alg = tfm->__crt_alg;

Could you update the comments for the functions which call crypto_destroy_tfm()
(crypto_free_aead(), crypto_free_skcipher(), etc.) to mention that they do
nothing when passed NULL or an ERR_PTR()?

- Eric
