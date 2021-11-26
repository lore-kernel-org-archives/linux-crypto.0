Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0163CC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Nov 2021 05:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345224AbhKZF3u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Nov 2021 00:29:50 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57144 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345380AbhKZF1t (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Nov 2021 00:27:49 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mqTid-0008O2-VT; Fri, 26 Nov 2021 13:24:20 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mqTiL-0004XE-DX; Fri, 26 Nov 2021 13:24:01 +0800
Date:   Fri, 26 Nov 2021 13:24:01 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Marek Vasut <marex@denx.de>, Ard Biesheuvel <ardb@kernel.org>,
        linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/9] crypto: stm32/cryp - fix CTR counter carry
Message-ID: <20211126052401.GA17410@gondor.apana.org.au>
References: <20211118150756.6593-1-nicolas.toromanoff@foss.st.com>
 <20211118150756.6593-4-nicolas.toromanoff@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118150756.6593-4-nicolas.toromanoff@foss.st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 18, 2021 at 04:07:50PM +0100, Nicolas Toromanoff wrote:
> STM32 CRYP hardware doesn't manage CTR counter bigger than max U32, as
> a workaround, at each block the current IV is saved, if the saved IV
> lower u32 is 0xFFFFFFFF, the full IV is manually incremented, and set
> in hardware.
> Fixes: bbb2832620ac ("crypto: stm32 - Fix sparse warnings")
> 
> Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
> ---
>  drivers/crypto/stm32/stm32-cryp.c | 25 ++++++++++++-------------
>  1 file changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
> index 7b55ad6d2f1a..9d6ccf1eb4ce 100644
> --- a/drivers/crypto/stm32/stm32-cryp.c
> +++ b/drivers/crypto/stm32/stm32-cryp.c
> @@ -163,7 +163,7 @@ struct stm32_cryp {
>  	struct scatter_walk     in_walk;
>  	struct scatter_walk     out_walk;
>  
> -	u32                     last_ctr[4];
> +	__be32                  last_ctr[4];

This introduces a sparse warning, please fix and resubmit.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
