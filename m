Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D22FBC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 09:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241743AbiKRJKf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241762AbiKRJKd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 04:10:33 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59D68C0A7;
        Fri, 18 Nov 2022 01:10:32 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ovxO1-00FYNO-Pr; Fri, 18 Nov 2022 17:10:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Nov 2022 17:10:13 +0800
Date:   Fri, 18 Nov 2022 17:10:13 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tomas Marek <tomas.marek@elrest.cz>
Cc:     mpm@selenic.com, mcoquelin.stm32@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        alexandre.torgue@foss.st.com
Subject: Re: [PATCH] hwrng: stm32 - rename readl return value
Message-ID: <Y3dL9UCTvanZcVI0@gondor.apana.org.au>
References: <20221108064240.30878-1-tomas.marek@elrest.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108064240.30878-1-tomas.marek@elrest.cz>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 08, 2022 at 07:42:40AM +0100, Tomas Marek wrote:
> Use a more meaningful name for the readl return value variable.
> 
> Link: https://lore.kernel.org/all/Y1J3QwynPFIlfrIv@loth.rohan.me.apana.org.au/
> 
> Signed-off-by: Tomas Marek <tomas.marek@elrest.cz>
> ---
>  drivers/char/hw_random/stm32-rng.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
