Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4F4C46467
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Jan 2023 07:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbjACH1I (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Jan 2023 02:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236902AbjACH0z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Jan 2023 02:26:55 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053091124;
        Mon,  2 Jan 2023 23:26:52 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pCbgj-00DN68-DB; Tue, 03 Jan 2023 15:26:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Jan 2023 15:26:21 +0800
Date:   Tue, 3 Jan 2023 15:26:21 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LinuxKernelMailingList@gondor.apana.org.au,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: sun8i-ss - Remove GFP_DMA and add DMA alignment
 padding
Message-ID: <Y7PYnb+oQpo7CI+N@gondor.apana.org.au>
References: <Y4nDL50nToBbi4DS@gondor.apana.org.au>
 <Y4xpGNNsfbucyUlt@infradead.org>
 <Y47BgCuZsYLX61A9@gondor.apana.org.au>
 <Y47g7qO8dsRdxCgf@infradead.org>
 <Y47+gxbdKR03EYCj@gondor.apana.org.au>
 <Y61WrVAjjtAMAvSh@gondor.apana.org.au>
 <Y7PQbNrgs2EvkXMB@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7PQbNrgs2EvkXMB@Red>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 03, 2023 at 07:51:24AM +0100, Corentin Labbe wrote:
.
> Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> Tested-on: sun8i-a83t-bananapi-m3
> Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks,

> This means that lot of other crypto driver (sun8i-ce, amlogic, etc...) I maintain need the same fix, right ?

I checked the other drivers and none of them seem to be broken.
Only DMA from the device (DMA_FROM_DEVICE or DMA_BIDIRECTIONAL)
need to be aligned appropriately.

However, please do remove any unnecessary uses of GFP_DMA in those
drivers.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
