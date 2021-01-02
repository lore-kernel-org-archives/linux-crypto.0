Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9865C433DB
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 22:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ED79207A5
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 22:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbhABWJ1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Jan 2021 17:09:27 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37382 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726935AbhABWJ1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Jan 2021 17:09:27 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kvp4a-0000bx-AZ; Sun, 03 Jan 2021 09:08:33 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sun, 03 Jan 2021 09:08:32 +1100
Date:   Sun, 3 Jan 2021 09:08:32 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     matthias.bgg@kernel.org
Cc:     mpm@selenic.com, rjui@broadcom.com, sbranden@broadcom.com,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        Julia.Lawall@inria.fr, bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, nsaenzjulienne@suse.de,
        linux-crypto@vger.kernel.org, Matthias Brugger <mbrugger@suse.com>
Subject: Re: [PATCH v2 1/2] hwrng: iproc-rng200: Fix disable of the block.
Message-ID: <20210102220832.GO12767@gondor.apana.org.au>
References: <20201218105708.28480-1-matthias.bgg@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218105708.28480-1-matthias.bgg@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 18, 2020 at 11:57:07AM +0100, matthias.bgg@kernel.org wrote:
> From: Matthias Brugger <mbrugger@suse.com>
> 
> When trying to disable the block we bitwise or the control
> register with value zero. This is confusing as using bitwise or with
> value zero doesn't have any effect at all. Drop this as we already set
> the enable bit to zero by appling inverted RNG_RBGEN_MASK.
> 
> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
> 
> ---
> 
> Changes in v2:
> - fix commit message, dropping Fixes tag
> - drop inverted RNT_RBGEN_ENABLE in disable case
> 
>  drivers/char/hw_random/iproc-rng200.c | 3 ---
>  1 file changed, 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
