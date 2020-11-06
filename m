Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC98C2D0A3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 07:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78D0B206F4
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 07:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgKFHCv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 02:02:51 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:35074 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgKFHCv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 02:02:51 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kavlW-000836-10; Fri, 06 Nov 2020 18:02:31 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2020 18:02:30 +1100
Date:   Fri, 6 Nov 2020 18:02:30 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: arm/aes-neonbs - fix usage of cbc(aes) fallback
Message-ID: <20201106070229.GG11620@gondor.apana.org.au>
References: <20201028090320.4222-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201028090320.4222-1-horia.geanta@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 28, 2020 at 11:03:20AM +0200, Horia Geantă wrote:
> Loading the module deadlocks since:
> -local cbc(aes) implementation needs a fallback and
> -crypto API tries to find one but the request_module() resolves back to
> the same module
> 
> Fix this by changing the module alias for cbc(aes) and
> using the NEED_FALLBACK flag when requesting for a fallback algorithm.
> 
> Fixes: 00b99ad2bac2 ("crypto: arm/aes-neonbs - Use generic cbc encryption path")
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> ---
>  arch/arm/crypto/aes-neonbs-glue.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
