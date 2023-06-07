Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66173C77B7A
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Jun 2023 04:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbjFGEhg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Jun 2023 00:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbjFGEhe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Jun 2023 00:37:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB19189
        for <linux-crypto@vger.kernel.org>; Tue,  6 Jun 2023 21:37:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEB8B62AF6
        for <linux-crypto@vger.kernel.org>; Wed,  7 Jun 2023 04:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C12FC433D2;
        Wed,  7 Jun 2023 04:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686112652;
        bh=y+MJc1VjMX5Gn4arTHqYZJUjiEPmaH69ZcSGMK0Bs/4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lrivbXq0iGS2gRx5+kOiPZ3qIe50hg/wv+QZ0fnUhGHpZsU1ebrqBZ7FBSaWtM2UN
         Pt6VFQ1Yx1RhDAiq4aP5qW1ykZHacW56bgWjX3jFW/CRWXlQBzwU/+zcNRcePktu6W
         nEuoEebUg/LLlAANQ4rjQ2+co0WhcazxBqg9Gyjk6l51uSy3hA4VGyJUb+CAUagR0m
         0vgeu+q+nRYc+wDkWPB9WglP+YkB6ujRK+ADwxSzpErm5G87RH+Klfa8xcd1nb7KeX
         hVVYLynNuZG+0YqIjqFt8C+hIo1+gDwpKyYE+/bG+O4BcsayeoOdF4l+zrY+koPWYS
         1R1vgmn1zOM/Q==
Date:   Tue, 6 Jun 2023 21:37:30 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH 0/3] crypto - some SPDX cleanups for arch code
Message-ID: <20230607043730.GB941@sol.localdomain>
References: <20230606173127.4050254-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606173127.4050254-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 06, 2023 at 07:31:24PM +0200, Ard Biesheuvel wrote:
> Some SPDX cleanups for the arch crypto code on ARM, arm64 and x86
> 
> Ard Biesheuvel (3):
>   crypto: arm64 - add some missing SPDX headers
>   crypto: arm - add some missing SPDX headers
>   crypto: x86 - add some missing SPDX headers
> 
>  arch/arm/crypto/chacha-neon-core.S          | 10 +----
>  arch/arm/crypto/crc32-ce-core.S             | 30 ++-----------
>  arch/arm/crypto/crct10dif-ce-core.S         | 40 +----------------
>  arch/arm64/crypto/chacha-neon-core.S        | 10 +----
>  arch/arm64/crypto/chacha-neon-glue.c        | 10 +----
>  arch/arm64/crypto/crct10dif-ce-core.S       | 40 +----------------
>  arch/x86/crypto/aesni-intel_avx-x86_64.S    | 36 +--------------
>  arch/x86/crypto/camellia-aesni-avx-asm_64.S |  7 +--
>  arch/x86/crypto/crc32-pclmul_glue.c         | 24 +---------
>  arch/x86/crypto/crc32c-pcl-intel-asm_64.S   | 29 +-----------
>  arch/x86/crypto/crct10dif-pcl-asm_64.S      | 36 +--------------
>  arch/x86/crypto/crct10dif-pclmul_glue.c     | 16 +------
>  arch/x86/crypto/sha1_avx2_x86_64_asm.S      | 46 +-------------------
>  arch/x86/crypto/sha1_ni_asm.S               | 46 +-------------------
>  arch/x86/crypto/sha256-avx-asm.S            | 28 +-----------
>  arch/x86/crypto/sha256-avx2-asm.S           | 29 +-----------
>  arch/x86/crypto/sha256-ssse3-asm.S          | 29 +-----------
>  arch/x86/crypto/sha256_ni_asm.S             | 46 +-------------------
>  arch/x86/crypto/sha256_ssse3_glue.c         | 15 +------
>  arch/x86/crypto/sha512-avx-asm.S            | 29 +-----------
>  arch/x86/crypto/sha512-avx2-asm.S           | 29 +-----------
>  arch/x86/crypto/sha512-ssse3-asm.S          | 29 +-----------
>  arch/x86/crypto/sha512_ssse3_glue.c         | 16 +------
>  arch/x86/crypto/twofish_glue.c              | 16 +------
>  24 files changed, 26 insertions(+), 620 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
