Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87670C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Dec 2022 19:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbiLMTvB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Dec 2022 14:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbiLMTvA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Dec 2022 14:51:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87CA1FCF2
        for <linux-crypto@vger.kernel.org>; Tue, 13 Dec 2022 11:50:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB5EBB81283
        for <linux-crypto@vger.kernel.org>; Tue, 13 Dec 2022 19:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4CDC433EF;
        Tue, 13 Dec 2022 19:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670961054;
        bh=hYXrulh1is+u82Hc6+D4w5TON+i41flRtmz2gYSnuFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qUi+M03MnXrsaZ2gLoxtuN6a4ahQUF+Ovk8wl8zFSAPAHqLxe3nktMTMCa0FNhqdt
         lMuhfoGkgoL4NA51z9+a7gsDSAHs2AtlDVILZ9J7gzucHvoxqJQhNJegWCLPsGBoJK
         BNz2Ahd4njxChmQ8Vi3i3Ul+rc7d4NHtP9fxh0xlrMQZr4okBzYMbN4m1qw/aXrjkx
         wB6DalRKQ9WXwCnOwLnrb2GmVRKzEwIte9vfqZSpavdYmC0FFMx9wea6C1mJD/5j8E
         ArAOO1ufmjROg2c9fj4j/Eufs+EQT2tH1u57TuKMgQe/tBEZCrc2dw1ygDRrelarJv
         h7e9O9KQyPBBg==
Date:   Tue, 13 Dec 2022 11:50:52 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Elliott, Robert (Servers)" <elliott@hpe.com>
Subject: Re: [RFC PATCH] crypto: use kmap_local() not kmap_atomic()
Message-ID: <Y5jXnE8e2SRHFRQN@sol.localdomain>
References: <20221213161310.2205802-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213161310.2205802-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 13, 2022 at 05:13:10PM +0100, Ard Biesheuvel wrote:
> kmap_atomic() is used to create short-lived mappings of pages that may
> not be accessible via the kernel direct map. This is only needed on
> 32-bit architectures that implement CONFIG_HIGHMEM, but it can be used
> on 64-bit other architectures too, where the returned mapping is simply
> the kernel direct address of the page.
> 
> However, kmap_atomic() does not support migration on CONFIG_HIGHMEM
> configurations, due to the use of per-CPU kmap slots, and so it disables
> preemption on all architectures, not just the 32-bit ones. This implies
> that all scatterwalk based crypto routines essentially execute with
> preemption disabled all the time, which is less than ideal.
> 
> So let's switch scatterwalk_map/_unmap and the shash/ahash routines to
> kmap_local() instead, which serves a similar purpose, but without the
> resulting impact on preemption on architectures that have no need for
> CONFIG_HIGHMEM.
> 
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "Elliott, Robert (Servers)" <elliott@hpe.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  crypto/ahash.c               | 4 ++--
>  crypto/shash.c               | 4 ++--
>  include/crypto/scatterwalk.h | 4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 

Thanks Ard, this looks good to me, especially given the broader effort to
replace kmap_atomic() with kmap_local_page() in the kernel.

One question: should the kmap_atomic() in crypto/skcipher.c be replaced as well?

- Eric
