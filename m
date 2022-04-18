Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2174C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Apr 2022 19:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbiDRTc4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Apr 2022 15:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiDRTcz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Apr 2022 15:32:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695E75F98
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 12:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E97AB8105F
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 19:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17D8C385AA;
        Mon, 18 Apr 2022 19:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650310212;
        bh=orr8Bf8gXxvUF7gw/QZO/nPx2iP4XIZEALzlkUBWYN8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q4FBDXozkJ0XvRerBqnkRhFgqPx7nivcN3fwSY2dLxMCpdXO3OgQXc/3AL0/ozV9R
         6qR7QdDViOF9zmyylFkK4zaNmzt9WBYgChH9TqOurQugBgXFaGjpHBxCl3AHORaUQc
         QrNQTMUD3dmcFCiQ0C/JvzJQGkWOlBh4YOX3gWw5fVTLrDIsw+HAsAMK2hfzieo2EZ
         YeDgkW3D4Jj4ytJNtaIslovUZQk1pgwatQz9dyWACLt2YZbPe4uWGSgc/Jh3dWNTMn
         JcfZImPaHadqgIJ7bvXPTsH1GBrsXfwuz3T8a3Fbhj+XlR2Ple9j2FynBP8d1oevqT
         uh4FzF24e8CrA==
Date:   Mon, 18 Apr 2022 12:30:11 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     chinayanlei2002@163.com
Cc:     herbert@gondor.apana.org.au, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com,
        linux-crypto@vger.kernel.org, Yan Lei <yan_lei@dahuatech.com>
Subject: Re: [PATCH] x86: crypto: fix Using uninitialized value walk.flags
Message-ID: <Yl28Qyy1hP+5Scjx@sol.localdomain>
References: <20220410060757.4009-1-chinayanlei2002@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220410060757.4009-1-chinayanlei2002@163.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Apr 10, 2022 at 02:07:57PM +0800, chinayanlei2002@163.com wrote:
> From: Yan Lei <yan_lei@dahuatech.com>
> 
> ----------------------------------------------------------
> Using uninitialized value "walk.flags" when calling "skcipher_walk_virt".
> 
> Signed-off-by: Yan Lei <yan_lei@dahuatech.com>
> ---
>  arch/x86/crypto/sm4_aesni_avx_glue.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/crypto/sm4_aesni_avx_glue.c b/arch/x86/crypto/sm4_aesni_avx_glue.c
> index 7800f77d6..417e3bbfe 100644
> --- a/arch/x86/crypto/sm4_aesni_avx_glue.c
> +++ b/arch/x86/crypto/sm4_aesni_avx_glue.c
> @@ -40,7 +40,7 @@ static int sm4_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
>  
>  static int ecb_do_crypt(struct skcipher_request *req, const u32 *rkey)
>  {
> -	struct skcipher_walk walk;
> +	struct skcipher_walk walk = { 0 };
>  	unsigned int nbytes;
>  	int err;
>  

This caller is no different from any other caller of skcipher_walk_virt().  So
this is not the proper place to fix this.  Can you do the following instead?

	1. Audit all callers of skcipher_walk_virt() to verify that they would be
	   okay with walk->flags being initialized to 0.  I.e., verify that no
	   callers are intentionally initializing the flags to something else.

	2. Update skcipher_walk_virt() to initialize walk->flags to 0, rather
	   than doing 'walk->flags &= ~SKCIPHER_WALK_PHYS' as it does currently.

- Eric
