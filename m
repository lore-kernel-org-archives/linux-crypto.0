Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8860AC4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 06:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235088AbiKRGGa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 01:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbiKRGG3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 01:06:29 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70F28D498;
        Thu, 17 Nov 2022 22:06:27 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ovuVs-00FVGi-4Q; Fri, 18 Nov 2022 14:06:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Nov 2022 14:06:08 +0800
Date:   Fri, 18 Nov 2022 14:06:08 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nikolaus Voss <nikolaus.voss@haag-streit.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        David Gstir <david@sigma-star.at>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Nikolaus Voss <nv@vosn.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: caam: blob_gen.c: warn if key is insecure
Message-ID: <Y3cg0FjeO272ncFb@gondor.apana.org.au>
References: <20221107080756.E0AA673D8@mail.steuer-voss.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107080756.E0AA673D8@mail.steuer-voss.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 07, 2022 at 09:00:30AM +0100, Nikolaus Voss wrote:
> If CAAM is not in "trusted" or "secure" state, a fixed non-volatile key
> is used instead of the unique device key. This is the default mode of
> operation without secure boot (HAB). In this scenario, CAAM encrypted
> blobs should be used only for testing but not in a production
> environment, so issue a warning.
> 
> Signed-off-by: Nikolaus Voss <nikolaus.voss@haag-streit.com>
> 
> ---
> Changes
> =======
> v2: make warning more verbose, correct register, style fixes
>  
>  drivers/crypto/caam/blob_gen.c | 9 +++++++++
>  drivers/crypto/caam/regs.h     | 3 +++
>  2 files changed, 12 insertions(+)

This patch introduces a new warning with gcc or sparse using
C=1 W=1.  Plesae fix.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
