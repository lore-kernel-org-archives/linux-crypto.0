Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FBACC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Jan 2021 05:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E9E3238E9
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Jan 2021 05:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbhANFcT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Jan 2021 00:32:19 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:42062 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726123AbhANFcT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Jan 2021 00:32:19 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kzvE3-0007Ww-Mg; Thu, 14 Jan 2021 16:31:16 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 14 Jan 2021 16:31:15 +1100
Date:   Thu, 14 Jan 2021 16:31:15 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Mark Gross <mgross@linux.intel.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: keembay - CRYPTO_DEV_KEEMBAY_OCS_HCU should
 depend on ARCH_KEEMBAY
Message-ID: <20210114053115.GA18700@gondor.apana.org.au>
References: <20210112161540.1109016-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112161540.1109016-1-geert+renesas@glider.be>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 12, 2021 at 05:15:40PM +0100, Geert Uytterhoeven wrote:
> The Intel Keem Bay Offload and Crypto Subsystem (OCS) Hash Control Unit
> (HCU) is only present on Intel Keem Bay SoCs.  Hence add a dependency on
> ARCH_KEEMBAY, to prevent asking the user about this driver when
> configuring a kernel without Intel Keem Bay platform support.
> 
> Fixes: 472b04444cd39e16 ("crypto: keembay - Add Keem Bay OCS HCU driver")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/crypto/keembay/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

There is already a patch in the queue that fixes this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
