Return-Path: <SRS0=Vvbd=45=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6387FC10DCE
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Mar 2020 12:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43C22206FA
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Mar 2020 12:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbgCLMkD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Mar 2020 08:40:03 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60006 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbgCLMkD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Mar 2020 08:40:03 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jCN7p-00023v-0l; Thu, 12 Mar 2020 23:39:46 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Mar 2020 23:39:44 +1100
Date:   Thu, 12 Mar 2020 23:39:44 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Martin Kaiser <martin@kaiser.cx>
Cc:     PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] imx-rngc - several small fixes
Message-ID: <20200312123944.GF28885@gondor.apana.org.au>
References: <20200128110102.11522-1-martin@kaiser.cx>
 <20200305205824.4371-1-martin@kaiser.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305205824.4371-1-martin@kaiser.cx>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 05, 2020 at 09:58:19PM +0100, Martin Kaiser wrote:
> This is a set of small fixes for the imx-rngc driver.
> 
> I tried to clarify the approach for masking/unmasking the interrupt from
> the rngc.
> 
> The rngc should be set to auto-seed mode, where it creates a new seed
> when required.
> 
> In the probe function, we should check that the rng type is supported by
> this driver.
> 
> Thanks for reviewing the patches,
> 
>    Martin
> 
> changes in v2:
> - remove the contentious devres patch
> - add PrasannaKumar's tags
> 
> Martin Kaiser (5):
>   hwrng: imx-rngc - fix an error path
>   hwrng: imx-rngc - use automatic seeding
>   hwrng: imx-rngc - (trivial) simplify error prints
>   hwrng: imx-rngc - check the rng type
>   hwrng: imx-rngc - simplify interrupt mask/unmask
> 
>  drivers/char/hw_random/imx-rngc.c | 85 +++++++++++++++++++++++++------
>  1 file changed, 69 insertions(+), 16 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
