Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 755C6C4321A
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 17:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FBFF21743
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 17:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560274783;
	bh=eXEBXK8NtMeUBXxccHVQ3Oj5mTZJseb3w/OvjPodQWs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=0Mm0DSGF9oJHGwuV4oC2r4k57vyP8C9af03fwjv14YoNw1bSpT2cYgayCi1VTDn3O
	 KkQixdyFxXLuHQeD8EuMdzQbEUBCvmik6yFXeu5OgWX456BA0EeOLZqKROrqs9e3to
	 6Wrh1+8JNDb0Bf57f8eDvCpVwcTC0xLRopmYbAp4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406484AbfFKRjm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 13:39:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406481AbfFKRjm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 13:39:42 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FB022173E;
        Tue, 11 Jun 2019 17:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560274780;
        bh=eXEBXK8NtMeUBXxccHVQ3Oj5mTZJseb3w/OvjPodQWs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pBKS7y59Z/5vyOoMDao6hbaiMGrWG/8depLM/USjmPQlMJtX3v2x1Lma0Bg6Vseki
         64VpjA3uodgIUlyFQLFUYF6xHNWhiFeUpY7qAFi/9Wb4gUBd7Z5aiTHlHDmqHAvYBT
         pVlTnoLE7xcZcnUBdJVfFE5cnXMezGnsqV7WlB5A=
Date:   Tue, 11 Jun 2019 10:39:39 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v3 5/7] crypto: arc4 - remove cipher implementation
Message-ID: <20190611173938.GA66728@gmail.com>
References: <20190611134750.2974-1-ard.biesheuvel@linaro.org>
 <20190611134750.2974-6-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611134750.2974-6-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 11, 2019 at 03:47:48PM +0200, Ard Biesheuvel wrote:
> There are no remaining users of the cipher implementation, and there
> are no meaningful ways in which the arc4 cipher can be combined with
> templates other than ECB (and the way we do provide that combination
> is highly dubious to begin with).
> 
> So let's drop the arc4 cipher altogether, and only keep the ecb(arc4)
> skcipher, which is used in various places in the kernel.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  crypto/arc4.c | 46 ++------------------
>  1 file changed, 4 insertions(+), 42 deletions(-)
> 
> diff --git a/crypto/arc4.c b/crypto/arc4.c
> index 6974dba1b7b9..79a51e9f90ae 100644
> --- a/crypto/arc4.c
> +++ b/crypto/arc4.c
> @@ -13,23 +13,12 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  
> -static int arc4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
> -			unsigned int key_len)
> -{
> -	struct arc4_ctx *ctx = crypto_tfm_ctx(tfm);
> -
> -	return arc4_setkey(ctx, in_key, key_len);
> -}
> -
>  static int arc4_set_key_skcipher(struct crypto_skcipher *tfm, const u8 *in_key,
>  				 unsigned int key_len)
>  {
> -	return arc4_set_key(&tfm->base, in_key, key_len);
> -}
> +	struct arc4_ctx *ctx = crypto_tfm_ctx(&tfm->base);
>  
> -static void arc4_crypt_one(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> -{
> -	arc4_crypt(crypto_tfm_ctx(tfm), out, in, 1);
> +	return arc4_setkey(ctx, in_key, key_len);
>  }
>  
>  static int ecb_arc4_crypt(struct skcipher_request *req)

Can you clean up the naming here?

	arc4_set_key_skcipher() => crypto_arc4_setkey()
	ecb_arc4_crypt() => crypto_arc4_crypt()

The current names were intended to distinguish the "skcipher" functions from the
"cipher" functions, but that will no longer be needed.

Also, crypto_arc4_setkey() should use crypto_skcipher_ctx() rather than
crypto_tfm_ctx(), now that it only handles "skcipher".

> @@ -50,23 +39,6 @@ static int ecb_arc4_crypt(struct skcipher_request *req)
>  	return err;
>  }
>  
> -static struct crypto_alg arc4_cipher = {
> -	.cra_name		=	"arc4",
> -	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
> -	.cra_blocksize		=	ARC4_BLOCK_SIZE,
> -	.cra_ctxsize		=	sizeof(struct arc4_ctx),
> -	.cra_module		=	THIS_MODULE,
> -	.cra_u			=	{
> -		.cipher = {
> -			.cia_min_keysize	=	ARC4_MIN_KEY_SIZE,
> -			.cia_max_keysize	=	ARC4_MAX_KEY_SIZE,
> -			.cia_setkey		=	arc4_set_key,
> -			.cia_encrypt		=	arc4_crypt_one,
> -			.cia_decrypt		=	arc4_crypt_one,
> -		},
> -	},
> -};
> -
>  static struct skcipher_alg arc4_skcipher = {

Similarly this could be renamed from arc4_skcipher to arc4_alg, now that the
skcipher algorithm doesn't need to be distinguished from the cipher algorithm.

>  	.base.cra_name		=	"ecb(arc4)",

Given the confusion this name causes, can you leave a comment?  Like:

        /*
         * For legacy reasons, this is named "ecb(arc4)", not "arc4".
         * Nevertheless it's actually a stream cipher, not a block cipher.
         */
	 .base.cra_name          =       "ecb(arc4)",


Also, due to removing the cipher algorithm, we need the following testmgr change
so that the comparison self-tests consider the generic implementation of this
algorithm to be itself rather than "ecb(arc4-generic)":

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 658a7eeebab28..5d3eb8577605f 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4125,6 +4125,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "ecb(arc4)",
+		.generic_driver = "ecb(arc4)-generic",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(arc4_tv_template)

- Eric
