Return-Path: <SRS0=NP+Z=6A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 378E4C38A29
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Apr 2020 06:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F0E121569
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Apr 2020 06:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436959AbgDPGwQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Apr 2020 02:52:16 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:41436 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436852AbgDPGwI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Apr 2020 02:52:08 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jOyNE-0005Ji-AF; Thu, 16 Apr 2020 16:51:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Apr 2020 16:51:44 +1000
Date:   Thu, 16 Apr 2020 16:51:44 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     narmstrong@baylibre.com, clabbe@baylibre.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6]crypto: amlogic - Delete duplicate dev_err in
 meson_crypto_probe()
Message-ID: <20200416065144.GF7901@gondor.apana.org.au>
References: <20200403220754.7856-1-tangbin@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200403220754.7856-1-tangbin@cmss.chinamobile.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Apr 04, 2020 at 06:07:54AM +0800, Tang Bin wrote:
> When something goes wrong, platform_get_irq() will print an error message,
> so in order to avoid the situation of repeat output，we should remove
> dev_err here.
> 
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> ---
> Changes from v5
>  - modify the commit message.
> 
> Changes from v4:
>  - rewrite the code, because the code in v4 is wrong, sorry.
> 
> Changes form v3:
>  - fix the theme writing error.
> 
> Changes from v2:
>  - modify the theme format and content description.
>  - reformat the patch, it's the wrong way to resubmit a new patch that
>    should be modified on top of the original. The original piece is:
>    https://lore.kernel.org/patchwork/patch/1219611/
> 
> Changes from v1:
>  - the title has changed, because the description is not very detailed.
>  - the code has been modified, because it needs to match the theme.
> 
>  drivers/crypto/amlogic/amlogic-gxl-core.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
