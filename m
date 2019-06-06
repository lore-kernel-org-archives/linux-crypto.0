Return-Path: <SRS0=NolZ=UF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80173C04AB5
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 06:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53E382083D
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 06:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfFFGyK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 02:54:10 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38938 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbfFFGyK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 02:54:10 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hYmHp-0006xu-HW; Thu, 06 Jun 2019 14:54:09 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hYmHn-0006l5-P4; Thu, 06 Jun 2019 14:54:07 +0800
Date:   Thu, 6 Jun 2019 14:54:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        pvanleeuwen@insidesecure.com, linux-imx@nxp.com,
        Horia Geanta <horia.geanta@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] crypto: caam - limit output IV to CBC to work around CTR
 mode DMA issue
Message-ID: <20190606065407.sc5bzbtxigii7bac@gondor.apana.org.au>
References: <20190531081306.30359-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531081306.30359-1-ard.biesheuvel@linaro.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 31, 2019 at 10:13:06AM +0200, Ard Biesheuvel wrote:
> The CAAM driver currently violates an undocumented and slightly
> controversial requirement imposed by the crypto stack that a buffer
> referred to by the request structure via its virtual address may not
> be modified while any scatterlists passed via the same request
> structure are mapped for inbound DMA.
> 
> This may result in errors like
> 
>   alg: aead: decryption failed on test 1 for gcm_base(ctr-aes-caam,ghash-generic): ret=74
>   alg: aead: Failed to load transform for gcm(aes): -2
> 
> on non-cache coherent systems, due to the fact that the GCM driver
> passes an IV buffer by virtual address which shares a cacheline with
> the auth_tag buffer passed via a scatterlist, resulting in corruption
> of the auth_tag when the IV is updated while the DMA mapping is live.
> 
> Since the IV that is returned to the caller is only valid for CBC mode,
> and given that the in-kernel users of CBC (such as CTS) don't trigger the
> same issue as the GCM driver, let's just disable the output IV generation
> for all modes except CBC for the time being.
> 
> Cc: Horia Geanta <horia.geanta@nxp.com>
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
> Reported-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/crypto/caam/caamalg.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
