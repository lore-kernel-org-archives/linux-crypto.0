Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B076C47082
	for <linux-crypto@archiver.kernel.org>; Wed, 26 May 2021 17:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65EB9613BE
	for <linux-crypto@archiver.kernel.org>; Wed, 26 May 2021 17:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbhEZRPn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 May 2021 13:15:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234188AbhEZRPl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 May 2021 13:15:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5B81613BE;
        Wed, 26 May 2021 17:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622049250;
        bh=WilcpziL7v+iMFq6RwDqrjuswQfu7ScP1b0OzDTgk5s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TeyGUyS+o/tyfWuoSfPUXTpBAaif2tajHI4JN7ar+RSvdhpwYvVSnRbjqGSt2Nmw2
         MFAKYt5bgVqvLdMGuNBlo6ywpbR53lahzxbM61x8CQxcCD/k5VGYgno5ORwK7h/lyI
         dioYaVu6WxI+3Iv6Tfm1lJGIS4PvPGypP2ObnDS0ECW5AyD+pKLSVCBeCWgGDGLBJt
         st8DFwyJ2GLiQoMxFb4yt2O2pvpVbQcoNJXr9FXF8e4pqJMM3wuRATwT6SE9t/Qzo8
         fiT563sA1jNHnSRrddsfp+lcUPKEYKG5CvZ2IfdI7lsVKEli9if8SFiUJxgKY0iZDt
         7yUI+zXydvbMA==
Date:   Wed, 26 May 2021 10:14:08 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v6 5/6] crypto: arm64/aes-ccm - reduce NEON begin/end
 calls for common case
Message-ID: <YK6B4PDchHbXNx3U@gmail.com>
References: <20210526100729.12939-1-ardb@kernel.org>
 <20210526100729.12939-6-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526100729.12939-6-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 26, 2021 at 12:07:28PM +0200, Ard Biesheuvel wrote:
> AES-CCM (as used in WPA2 CCMP, for instance) typically involves
> authenticate-only data, and operates on a single network packet, and so
> the common case is for the authenticate, en/decrypt and finalize SIMD
> helpers to all be called exactly once in sequence. Since
> kernel_neon_end() now involves manipulation of the preemption state as
> well as the softirq mask state, let's reduce the number of times we are
> forced to call it to only once if we are handling this common case.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/aes-ce-ccm-core.S |  1 +
>  arch/arm64/crypto/aes-ce-ccm-glue.c | 74 +++++++++++---------
>  2 files changed, 43 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/arm64/crypto/aes-ce-ccm-core.S b/arch/arm64/crypto/aes-ce-ccm-core.S
> index 99a028e298ed..8adff299fcd3 100644
> --- a/arch/arm64/crypto/aes-ce-ccm-core.S
> +++ b/arch/arm64/crypto/aes-ce-ccm-core.S
> @@ -124,6 +124,7 @@ SYM_FUNC_START(ce_aes_ccm_final)
>  SYM_FUNC_END(ce_aes_ccm_final)
>  
>  	.macro	aes_ccm_do_crypt,enc
> +	cbz	x2, 5f
>  	ldr	x8, [x6, #8]			/* load lower ctr */
>  	ld1	{v0.16b}, [x5]			/* load mac */
>  CPU_LE(	rev	x8, x8			)	/* keep swabbed ctr in reg */
> diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
> index 54bd2494a000..98159f2c49ae 100644
> --- a/arch/arm64/crypto/aes-ce-ccm-glue.c
> +++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
> @@ -97,10 +97,8 @@ static int ccm_init_mac(struct aead_request *req, u8 maciv[], u32 msglen)
>  static void ccm_update_mac(struct crypto_aes_ctx *key, u8 mac[], u8 const in[],
>  			   u32 abytes, u32 *macp)
>  {
> -	kernel_neon_begin();
>  	ce_aes_ccm_auth_data(mac, in, abytes, macp, key->key_enc,
>  			     num_rounds(key));
> -	kernel_neon_end();
>  }
[...]
> +	if (req->assoclen)
> +		ccm_calculate_auth_mac(req, mac);
> +

This still makes all the associated data be processed under a single
kernel_neon_begin() / kernel_neon_end() pair, even if there is a large amount of
it.  Shouldn't it be limited to a reasonable amount at a time, like 4K?
This sort of thing has been considered a bug before, e.g. see
commit 706024a52c6 ("crypto: arch/lib - limit simd usage to 4k chunks").

You could do the entire CCM operation under a single pair as long as there isn't
more than 4K of associated data.

- Eric
