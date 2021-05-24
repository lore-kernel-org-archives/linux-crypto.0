Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 137A2C04FF3
	for <linux-crypto@archiver.kernel.org>; Mon, 24 May 2021 21:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEE0761418
	for <linux-crypto@archiver.kernel.org>; Mon, 24 May 2021 21:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhEXVyp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 May 2021 17:54:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232662AbhEXVyo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 May 2021 17:54:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 291CE600CD;
        Mon, 24 May 2021 21:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621893196;
        bh=5vb8ChgnerQT/NGevHl6r63aPAuvU9KJ+h6D8O37gh4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Up4OA561MudWrVUA7K9jSpQhEaeqoKkXE31NuWdP1CDYvXqce577DT7zO8rOGlmdI
         nXCmMOSjhYw8csue2B/qSVTlQQ1GC5VHxFlGjSOnCkHljTinhZggIcN3a1DgWGpwdi
         0Hw2izU4Ivu1HSHNYCi7wDSXpKBkzaimAp3GHeE4IKrh2LPPSG0pyckhgHwiGRjYvu
         6/ZC1uoDqSSwtitnXsM3Go5+r97v1EVQe7nBAuXkSParaCgWEueFs7Io2COkde/iLH
         QTz49ym80BNA1AZWmDXHtAMds+/FaisidOZ7WBoTP5jSvSicFdh3ZlDP0VyU+k7J44
         +KfsU0VoIXThA==
Date:   Mon, 24 May 2021 14:53:14 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v5 5/5] crypto: arm64/aes-ccm - avoid by-ref argument for
 ce_aes_ccm_auth_data
Message-ID: <YKwgSnb4RJr40Ns2@gmail.com>
References: <20210521102053.66609-1-ardb@kernel.org>
 <20210521102053.66609-6-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521102053.66609-6-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 21, 2021 at 12:20:53PM +0200, Ard Biesheuvel wrote:
> With the SIMD code path removed, we can clean up the CCM auth-only path
> a bit further, by passing the 'macp' input buffer pointer by value,
> rather than by reference, and taking the output value from the
> function's return value.
> 
> This way, the compiler is no longer forced to allocate macp on the
> stack. This is not expected to make any difference in practice, it just
> makes for slightly cleaner code.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/aes-ce-ccm-core.S | 23 ++++++++++----------
>  arch/arm64/crypto/aes-ce-ccm-glue.c | 17 +++++----------
>  2 files changed, 17 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/arm64/crypto/aes-ce-ccm-core.S b/arch/arm64/crypto/aes-ce-ccm-core.S
> index 8adff299fcd3..b03f7f71f893 100644
> --- a/arch/arm64/crypto/aes-ce-ccm-core.S
> +++ b/arch/arm64/crypto/aes-ce-ccm-core.S
> @@ -12,22 +12,21 @@
>  	.arch	armv8-a+crypto
>  
>  	/*
> -	 * void ce_aes_ccm_auth_data(u8 mac[], u8 const in[], u32 abytes,
> -	 *			     u32 *macp, u8 const rk[], u32 rounds);
> +	 * u32 ce_aes_ccm_auth_data(u8 mac[], u8 const in[], u32 abytes,
> +	 *			    u32 macp, u8 const rk[], u32 rounds);

How is this different from 'u8 mac[]' which is already one of the parameters?

- Eric
