Return-Path: <SRS0=bFPd=CD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C021C433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Aug 2020 01:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D217420738
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Aug 2020 01:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgHYByH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Aug 2020 21:54:07 -0400
Received: from [216.24.177.18] ([216.24.177.18]:58852 "EHLO fornost.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgHYByH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Aug 2020 21:54:07 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kAO9M-0005MQ-Og; Tue, 25 Aug 2020 11:53:25 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 25 Aug 2020 11:53:24 +1000
Date:   Tue, 25 Aug 2020 11:53:24 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Jason@zx2c4.com, linux@armlinux.org.uk,
        linux-crypto@vger.kernel.org, ardb@kernel.org
Subject: Re: [PATCH] crypto: arm/curve25519 - include <linux/scatterlist.h>
Message-ID: <20200825015324.GA28684@gondor.apana.org.au>
References: <20200824140953.5964-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824140953.5964-1-festevam@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 24, 2020 at 11:09:53AM -0300, Fabio Estevam wrote:
> Building ARM allmodconfig leads to the following warnings:
> 
> arch/arm/crypto/curve25519-glue.c:73:12: error: implicit declaration of function 'sg_copy_to_buffer' [-Werror=implicit-function-declaration]
> arch/arm/crypto/curve25519-glue.c:74:9: error: implicit declaration of function 'sg_nents_for_len' [-Werror=implicit-function-declaration]
> arch/arm/crypto/curve25519-glue.c:88:11: error: implicit declaration of function 'sg_copy_from_buffer' [-Werror=implicit-function-declaration]
> 
> Include <linux/scatterlist.h> to fix such warnings
> 
> Reported-by: Olof's autobuilder <build@lixom.net>
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
>  arch/arm/crypto/curve25519-glue.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
