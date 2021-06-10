Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D855C48BD1
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Jun 2021 18:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D924613B0
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Jun 2021 18:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhFJSuD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Jun 2021 14:50:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229935AbhFJSuC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jun 2021 14:50:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C657613DF;
        Thu, 10 Jun 2021 18:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623350886;
        bh=V7TG4y7UNJ3EHwuNTUY6ZTRf2X1MD+YMR1lY0uWspXo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OGptpNtxHYLF7t6tCrjkhrpLMK9PDbecotaG7d1VeTacWqsnxqF78YCwbZ2IFVfum
         zDq+tAeEKzht5wSS/eePTC9zzrhAW+dBxiM+XgdfyLU9RJqT9a/wpb9pHfWKyr8/XU
         I6Fc9NoFaYdG7JAmLR2N/Ud9lHwuShAIpVTMxlgvvzuJPfFudmL0Eks4kBVWe0XBYw
         kezjFCpaZgrH1bmjpuOsrWZWdROELmfFUnj8maPQKqvwNEq7FZpTOPH3BCH1o+V9oj
         VwZcfiezhOmWTXaARYZjkpE33HhZtbSEdmmdWX/ybddE16YO0zlepo5JfA8gMqiUqG
         4FEfrKS0lSYPQ==
Date:   Thu, 10 Jun 2021 11:48:04 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v3] crypto: shash - avoid comparing pointers to exported
 functions under CFI
Message-ID: <YMJeZMiRW7Xjo/sZ@gmail.com>
References: <20210610062150.212779-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610062150.212779-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 10, 2021 at 08:21:50AM +0200, Ard Biesheuvel wrote:
> crypto_shash_alg_has_setkey() is implemented by testing whether the
> .setkey() member of a struct shash_alg points to the default version,
> called shash_no_setkey(). As crypto_shash_alg_has_setkey() is a static
> inline, this requires shash_no_setkey() to be exported to modules.
> 
> Unfortunately, when building with CFI, function pointers are routed
> via CFI stubs which are private to each module (or to the kernel proper)
> and so this function pointer comparison may fail spuriously.
> 
> Let's fix this by turning crypto_shash_alg_has_setkey() into an out of
> line function.
> 
> Cc: Sami Tolvanen <samitolvanen@google.com>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> v3: improve comment as per Eric's suggestion
> v2: add code comment to explain why the function needs to remain out of
> line
> 
>  crypto/shash.c                 | 18 +++++++++++++++---
>  include/crypto/internal/hash.h |  8 +-------
>  2 files changed, 16 insertions(+), 10 deletions(-)
> 

Reviewed-by: Eric Biggers <ebiggers@google.com>
