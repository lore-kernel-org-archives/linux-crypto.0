Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E76B5C04FF3
	for <linux-crypto@archiver.kernel.org>; Mon, 24 May 2021 21:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B43F861413
	for <linux-crypto@archiver.kernel.org>; Mon, 24 May 2021 21:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbhEXVs5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 May 2021 17:48:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233353AbhEXVs5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 May 2021 17:48:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 894B76140F;
        Mon, 24 May 2021 21:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621892848;
        bh=6UtPVe5j5lU53z6ufcGH+xS6wYft4GtHhBP9rLOwuKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IvsgDE/nyMtbskw0KxoVrSLkNDJqMh2ThPHYP86qfc/NAW1kLsfo8sFRj/5Cgj+hE
         5L1cG4suzCfl0Fqb811J8/9FefB4IUieY+Hj3dLzHsKuJzlwWtgyWthrID1NaP+qwz
         7hrNsaFD3c+VJh6kSfaFMmRWaah7uOsLyOzOPSfBdz6mkYOLPUktWNtmZfL5oyzIp9
         a6wcHWp3mKzt+kDyqfXRGiE3vIEWacT11PDpS+vFT8VgGdAYYWHcqJCVNP9OxDeEMs
         3gmIAFJdBD6tf9EuJixkwOmHUXgwR7YHuClfny/s6wEplLq807z3x73I4s4dzDjGXb
         z6PWe6yNUmI8w==
Date:   Mon, 24 May 2021 14:47:27 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v5 3/5] crypto: arm64/aes-ce - stop using SIMD helper for
 skciphers
Message-ID: <YKwe72jUbq1m6lY/@gmail.com>
References: <20210521102053.66609-1-ardb@kernel.org>
 <20210521102053.66609-4-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521102053.66609-4-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 21, 2021 at 12:20:51PM +0200, Ard Biesheuvel wrote:
> Calls into the skcipher API can only occur from contexts where the SIMD
> unit is available, so there is no need for the SIMD helper.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/Kconfig    |   4 -
>  arch/arm64/crypto/aes-glue.c | 102 +++-----------------
>  2 files changed, 13 insertions(+), 93 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@google.com>
