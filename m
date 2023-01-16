Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA757C54EBE
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Jan 2023 03:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbjAPD3w (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Jan 2023 22:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbjAPD3u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Jan 2023 22:29:50 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD137524B
        for <linux-crypto@vger.kernel.org>; Sun, 15 Jan 2023 19:29:47 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pHGBs-000MiO-RA; Mon, 16 Jan 2023 11:29:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 16 Jan 2023 11:29:44 +0800
Date:   Mon, 16 Jan 2023 11:29:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 0/4] crypto: Accelerated GCM for IPSec on ARM/arm64
Message-ID: <Y8TEqNJuEmWE5Tg/@gondor.apana.org.au>
References: <20221214171957.2833419-1-ardb@kernel.org>
 <CAMj1kXG_btjHUVpN9m5NoBdFv=3JWt-piPx_u40KTv70CC-sRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXG_btjHUVpN9m5NoBdFv=3JWt-piPx_u40KTv70CC-sRQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 13, 2023 at 05:00:59PM +0100, Ard Biesheuvel wrote:
>
> These prerequisite changes have now been queued up in the ARM tree.
> 
> Note that these are runtime prerequisites only so I think this series
> can be safely merged as well, as I don't think anyone builds cryptodev
> for 32-bit ARM and tests it on 64-bit hardware (which is the only
> hardware that implements the AES instructions that patch #1 relies on)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

I don't have any objections for merging this through the arm tree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
