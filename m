Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF10CC433E0
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 22:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90B31207A4
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 22:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbhABWJj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Jan 2021 17:09:39 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37394 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbhABWJi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Jan 2021 17:09:38 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kvp4k-0000hX-DJ; Sun, 03 Jan 2021 09:08:43 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sun, 03 Jan 2021 09:08:42 +1100
Date:   Sun, 3 Jan 2021 09:08:42 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     matthias.bgg@kernel.org
Cc:     mpm@selenic.com, rjui@broadcom.com, sbranden@broadcom.com,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org,
        Julia.Lawall@inria.fr, bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, nsaenzjulienne@suse.de,
        linux-crypto@vger.kernel.org, Matthias Brugger <mbrugger@suse.com>
Subject: Re: [PATCH v2 2/2] hwrng: iproc-rng200: Move enable/disable in
 separate function
Message-ID: <20210102220842.GP12767@gondor.apana.org.au>
References: <20201218105708.28480-1-matthias.bgg@kernel.org>
 <20201218105708.28480-2-matthias.bgg@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218105708.28480-2-matthias.bgg@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 18, 2020 at 11:57:08AM +0100, matthias.bgg@kernel.org wrote:
> From: Matthias Brugger <mbrugger@suse.com>
> 
> We are calling the same code for enable and disable the block in various
> parts of the driver. Put that code into a new function to reduce code
> duplication.
> 
> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> ---
> 
> Changes in v2:
> - rename function to iproc_rng200_enable_set()
> - use u32 value instead of uint32_t
> 
>  drivers/char/hw_random/iproc-rng200.c | 35 ++++++++++++---------------
>  1 file changed, 16 insertions(+), 19 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
