Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B2F1C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 18:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDC6F2222D
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 18:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgLaS6P (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 13:58:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:36440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgLaS6P (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 13:58:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BDB72222D;
        Thu, 31 Dec 2020 18:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609441054;
        bh=UjnjRi4ykP7qXNMPm4Vxc5Gdfo6QXG5jxXk05ONfkZg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NkPJ9HUn8MrOCrNahIYRHjC7/J6DZzM3Ltd+0+9yeOzNAcXuCOuHeJEEngcHGDEpa
         VvQZQIE4QLPNRE9fIFegECNBid57GFUHG8HgQDyjskfdBJZO7XvjqM4FNm3LEzfa00
         LyOvVE5F7++sLKfyzVptg+JWmMSjrrsag/QaPfO8CcG90GXdyYBnWgbUjN6wwpodUL
         77CSCuaa5NhUIa6DTtU6KJEYInI4wRO3LUCDe2WGhNL3cDeE201g3AA3SvOYYVAak6
         iZGaCIk4gFvTZo/dzZLrZNHXsqE1Ngty8MW4SLPvD7g+Pz6e7v+sd8/xzJfaFrwzOh
         yVt8wbevq2hFQ==
Date:   Thu, 31 Dec 2020 10:57:33 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Megha Dey <megha.dey@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 18/21] crypto: x86/cast6 - drop dependency on glue helper
Message-ID: <X+4fHXPZF5w3SFup@sol.localdomain>
References: <20201231172337.23073-1-ardb@kernel.org>
 <20201231172337.23073-19-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201231172337.23073-19-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 31, 2020 at 06:23:34PM +0100, Ard Biesheuvel wrote:
> Replace the glue helper dependency with implementations of ECB and CBC
> based on the new CPP macros, which avoid the need for indirect calls.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/crypto/cast6_avx_glue.c | 61 ++++++--------------
>  crypto/Kconfig                   |  1 -
>  2 files changed, 17 insertions(+), 45 deletions(-)

Acked-by: Eric Biggers <ebiggers@google.com>
