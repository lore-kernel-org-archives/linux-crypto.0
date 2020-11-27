Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C3C2C64E7D
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 06:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A57E221FD
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 06:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392654AbgK0G11 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Nov 2020 01:27:27 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:33514 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392527AbgK0G10 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Nov 2020 01:27:26 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kiXE0-00011X-67; Fri, 27 Nov 2020 17:27:21 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2020 17:27:20 +1100
Date:   Fri, 27 Nov 2020 17:27:20 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] crypto: ccree - rework cache parameters handling
Message-ID: <20201127062720.GJ11448@gondor.apana.org.au>
References: <20201122075154.20478-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201122075154.20478-1-gilad@benyossef.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Nov 22, 2020 at 09:51:53AM +0200, Gilad Ben-Yossef wrote:
> Rework the setting of DMA cache parameters, program more appropriate
> values and explicitly set sharability domain.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
> 
> Changes from previous versions:
> - After discussion with Rob H., drop notion of setting the parameters
>   from device tree and just use good defaults for cached/non cached.
> 
>  drivers/crypto/ccree/cc_driver.c | 75 +++++++++++++++++++++++++-------
>  drivers/crypto/ccree/cc_driver.h |  6 +--
>  drivers/crypto/ccree/cc_pm.c     |  2 +-
>  3 files changed, 63 insertions(+), 20 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
