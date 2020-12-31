Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56CB3C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 18:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D28B223E4
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 18:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgLaS7T (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 13:59:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgLaS7T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 13:59:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A61542222D;
        Thu, 31 Dec 2020 18:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609441118;
        bh=QyNkumX8q3gpicQ4OXrEuyjP/Bm2MwCRamcpOnxvOTU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gVKgi5Q2BEb25hPiUMxqxQhrvn6cs7FhH73lU+ZXqeSuzg4Ee+/wXHDMb8hbqxbAG
         FOLjAZy4Mw6jIzB51J+FwNiLGltFnsyQfGZ66KMKW3PraA/rJLko+S9uJ1TRsVqQL8
         334eMcoGTKObO+cgwB3krpx66q34D2ENC4/8HXVCLlN5mIjiDe6gJ18VFdvwrZrwx5
         pAcS9ZqZgO69eRVNLBRKd5A44ozd1bGPgz3BL7yswFTtA8XzLZH8NerVzpFvl/Kz5Z
         D7Kr8KoczvF8fn2dp/t0n5fK7ZbI9d7HdoQrSIx075P2yb9OCqMhjpSWIQe6/jJJz0
         dJJszhfE03yDw==
Date:   Thu, 31 Dec 2020 10:58:37 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Megha Dey <megha.dey@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 20/21] crypto: x86 - remove glue helper module
Message-ID: <X+4fXT2XZq9Pt1eK@sol.localdomain>
References: <20201231172337.23073-1-ardb@kernel.org>
 <20201231172337.23073-21-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201231172337.23073-21-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 31, 2020 at 06:23:36PM +0100, Ard Biesheuvel wrote:
> All dependencies on the x86 glue helper module have been replaced by
> local instantiations of the new ECB/CBC preprocessor helper macros, so
> the glue helper module can be retired.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/crypto/Makefile                  |   2 -
>  arch/x86/crypto/glue_helper.c             | 155 --------------------
>  arch/x86/include/asm/crypto/glue_helper.h |  74 ----------
>  crypto/Kconfig                            |   5 -
>  crypto/skcipher.c                         |   6 -
>  include/crypto/internal/skcipher.h        |   1 -
>  6 files changed, 243 deletions(-)

Acked-by: Eric Biggers <ebiggers@google.com>
