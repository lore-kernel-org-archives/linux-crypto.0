Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A4CC47088
	for <linux-crypto@archiver.kernel.org>; Wed, 26 May 2021 17:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC7A0613D2
	for <linux-crypto@archiver.kernel.org>; Wed, 26 May 2021 17:18:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbhEZRTl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 May 2021 13:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234273AbhEZRTl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 May 2021 13:19:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B0E7611B0;
        Wed, 26 May 2021 17:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622049489;
        bh=fue/kOF/ZOdJ77PEzAFEhm+XX/PeZi69M1P5v2+QnWc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GNtglhlGxNzBlWnhUrmXDUMYf+jw6Yb9kZCSfhNTKjIMYYrFpSwiBELyDeJVhCqBM
         QlUpwdnA3i3wKMw/xPZIbz5WpRK2+vBFFm0FY1YEfxOuJbxGtR2kyP7tlSUJJltR2S
         FMJkjYncZARKnS6MtC4WS5vwk5GSMjdo39C508zlU/FFjGb1qzytdmYy/yo/PvunDU
         b6F2q+9W+Wbiq1w9+z7ZkOYJ2acjt68HN4BQ+8tS5pOl8QLApujRrV4Uh/x+PbswFV
         B6t2EaX2Sre7vkeHAzWbRzR67wwgvdVgg3ofmHde+wYYG7ULOEa1adUiluRzcb0rGW
         h3f2jJCEivs/A==
Date:   Wed, 26 May 2021 10:18:08 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v6 6/6] crypto: arm64/aes-ccm - avoid by-ref argument for
 ce_aes_ccm_auth_data
Message-ID: <YK6C0Ogq9tpByQOk@gmail.com>
References: <20210526100729.12939-1-ardb@kernel.org>
 <20210526100729.12939-7-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526100729.12939-7-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 26, 2021 at 12:07:29PM +0200, Ard Biesheuvel wrote:
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

Reviewed-by: Eric Biggers <ebiggers@google.com>
