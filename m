Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E73D6C43334
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Jul 2022 08:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiGOIsr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Jul 2022 04:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbiGOIsi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Jul 2022 04:48:38 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A26CD9F;
        Fri, 15 Jul 2022 01:48:34 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oCGzp-000nua-UL; Fri, 15 Jul 2022 18:48:27 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Jul 2022 16:48:26 +0800
Date:   Fri, 15 Jul 2022 16:48:26 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Andrew Davis <afd@ti.com>
Cc:     Nishanth Menon <nm@ti.com>, Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] crypto: sa2ul - Set the supported_algos bits
 individually
Message-ID: <YtEp2uafxm1X9gVZ@gondor.apana.org.au>
References: <20220706191144.26437-1-afd@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706191144.26437-1-afd@ti.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 06, 2022 at 02:11:43PM -0500, Andrew Davis wrote:
> Setting these individually gives a better picture of supported
> functions at a glance. Plus if the list changes an unwanted
> one will not accidentally get set with GENMASK.
> 
> Signed-off-by: Andrew Davis <afd@ti.com>
> ---
> 
> Changes from v1:
>  - Split these two patches from the DTS changes
> 
>  drivers/crypto/sa2ul.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
