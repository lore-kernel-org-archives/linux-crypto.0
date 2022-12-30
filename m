Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0F55C4167B
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Dec 2022 15:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiL3PLH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Dec 2022 10:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiL3PLG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Dec 2022 10:11:06 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DAC14024
        for <linux-crypto@vger.kernel.org>; Fri, 30 Dec 2022 07:11:05 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pBH2E-00COpF-9l; Fri, 30 Dec 2022 23:11:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Dec 2022 23:11:02 +0800
Date:   Fri, 30 Dec 2022 23:11:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        "Elliott, Robert (Servers)" <elliott@hpe.com>
Subject: Re: [RFC PATCH] crypto: use kmap_local() not kmap_atomic()
Message-ID: <Y67/hm5JA8jinqMq@gondor.apana.org.au>
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

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
