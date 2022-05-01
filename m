Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 744E2C433EF
	for <linux-crypto@archiver.kernel.org>; Sun,  1 May 2022 22:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378162AbiEAWNE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 May 2022 18:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378883AbiEAWMr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 May 2022 18:12:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9A324596
        for <linux-crypto@vger.kernel.org>; Sun,  1 May 2022 15:09:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCB0D61093
        for <linux-crypto@vger.kernel.org>; Sun,  1 May 2022 22:09:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CADC385A9;
        Sun,  1 May 2022 22:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651442940;
        bh=3AM2LPqUXOJEvhKUdQ7/6AGmjfNNTo+QZUxKRD+NOUM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mJK5T4K+SNba89tnbaXOHxxNM+eQrvLtMdTCOJS82hvk3OufVkLONqJn23hSgVVt9
         +MDkKycvZy+IIW+0Kf8gDGrtLZm4/6TEC7lDZavHHIAR/2cxev/qSfkqlVrHM1laaF
         LoT7Mwm48Iw/SRvTDQp+xSwMDfgf/6ixItZYeYKfBEThBL/krQ7ROuL/X6HbGPxqcb
         nmiL8jm1AVoWoHvzoP/u4H4XwDcEp8rCacqmxprNTB3FdhASR8F6udVCkoGFhb/pag
         Eq0eoNBFHjl4/eTCVtSJmzjKpywf8U4GEWif5RbEVo0dLiNRpWUKJKka9z1c2K6rGl
         2cs84GtIbTaeg==
Date:   Sun, 1 May 2022 15:08:56 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        linux-fscrypt.vger.kernel.org@google.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v5 5/8] crypto: arm64/aes-xctr: Add accelerated
 implementation of XCTR
Message-ID: <Ym8E+C86txJvYtZK@sol.localdomain>
References: <20220427003759.1115361-1-nhuck@google.com>
 <20220427003759.1115361-6-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427003759.1115361-6-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 27, 2022 at 12:37:56AM +0000, Nathan Huckleberry wrote:
> diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
> index dc35eb0245c5..39a0c2b5c24d 100644
> --- a/arch/arm64/crypto/aes-modes.S
> +++ b/arch/arm64/crypto/aes-modes.S
> @@ -318,126 +318,186 @@ AES_FUNC_END(aes_cbc_cts_decrypt)
>  	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
>  	.previous
>  
> -
>  	/*
> -	 * aes_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
> -	 *		   int bytes, u8 ctr[])
> +	 * This macro generates the code for CTR and XCTR mode.
>  	 */

So I did ask for the register aliases and extra comments, but it's hard to
review this with the cleanups to the existing code mixed in with the
XCTR-specific additions.  Would you mind splitting this up into two patches, one
to improve the readability of the existing aes_ctr_encrypt(), and one to add
xctr support?

Also, I noticed that the register aliases aren't being used consistently.  E.g.

	 ld1             {vctr.16b}, [x5]

... should use IV for x5, and

	eor             x6, x6, x12
	eor             x7, x7, x12
	eor             x8, x8, x12
	eor             x9, x9, x12
	eor             x10, x10, x12

Should use IV_PART for x12.

- Eric
