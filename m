Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9EA8C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 06:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA6B0611CA
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 06:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbhI1G2s (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 02:28:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234207AbhI1G2s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 02:28:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 309B5611BD;
        Tue, 28 Sep 2021 06:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632810429;
        bh=gGSfvzOmjzE3uTefL139gVbIvttn9yn4r5LhiGbvw/I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jo3iPuwkTOeimGBgEgOu8dd17zrY7ubjaXar4ncU7iWGiXBIJItkqjmkeqmxuo5Qw
         GDGoPQG4TOEzGzaXtGs5W8eugUfsDMwBaxjRg/XitBV3DcorMjkZEW+2Tz36EvyRFe
         HMjlVawtRWZwurFLvveKPWUyvG3vE4pnjA1L45lr0YS2IkV6vbHgry3FLvPe6ISIpc
         /9G4l3wWtgodeRBdOjc5v7Y3aR6FC/gErEZ68BV+oiW2m6QTRgERJ+cVeiUjoWNXzO
         l09Fx5FOgKWr4CBqROaVFgmXE0MzYU8TPviVVqLUtiNBjYIrHu36jVkl7p20oyBAzp
         CgvW/Ch/zpydg==
Date:   Mon, 27 Sep 2021 23:27:07 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     XiaokangQian <xiaokang.qian@arm.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, nd@arm.com, ardb@kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: arm64/gcm-ce - unroll factors to 4-way
 interleave of aes and ghash
Message-ID: <YVK1u4BgVAa84fMa@sol.localdomain>
References: <20210923063027.166247-1-xiaokang.qian@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923063027.166247-1-xiaokang.qian@arm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 23, 2021 at 06:30:25AM +0000, XiaokangQian wrote:
> To improve performance on cores with deep piplines such as A72,N1,
> implement gcm(aes) using a 4-way interleave of aes and ghash (totally
> 8 blocks in parallel), which can make full utilize of pipelines rather
> than the 4-way interleave we used currently. It can gain about 20% for
> big data sizes such that 8k.
> 
> This is a complete new version of the GCM part of the combined GCM/GHASH
> driver, it will co-exist with the old driver, only serve for big data
> sizes. Instead of interleaving four invocations of AES where each chunk
> of 64 bytes is encrypted first and then ghashed, the new version uses a
> more coarse grained approach where a chunk of 64 bytes is encrypted and
> at the same time, one chunk of 64 bytes is ghashed (or ghashed and
> decrypted in the converse case).
> 
> The table below compares the performance of the old driver and the new
> one on various micro-architectures and running in various modes with
> various data sizes.
> 
>             |     AES-128       |     AES-192       |     AES-256       |
>      #bytes | 1024 | 1420 |  8k | 1024 | 1420 |  8k | 1024 | 1420 |  8k |
>      -------+------+------+-----+------+------+-----+------+------+-----+
>         A72 | 5.5% |  12% | 25% | 2.2% |  9.5%|  23%| -1%  |  6.7%| 19% |
>         A57 |-0.5% |  9.3%| 32% | -3%  |  6.3%|  26%| -6%  |  3.3%| 21% |
>         N1  | 0.4% |  7.6%|24.5%| -2%  |  5%  |  22%| -4%  |  2.7%| 20% |
> 
> Signed-off-by: XiaokangQian <xiaokang.qian@arm.com>

Does this pass the self-tests, including the fuzz tests which are enabled by
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?

- Eric
