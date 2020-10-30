Return-Path: <SRS0=SmAa=EF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36923C56202
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Oct 2020 06:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E13B322203
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Oct 2020 06:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgJ3Gs3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Oct 2020 02:48:29 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60472 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgJ3Gs2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Oct 2020 02:48:28 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kYOD1-0004pa-E1; Fri, 30 Oct 2020 17:48:24 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Oct 2020 17:48:23 +1100
Date:   Fri, 30 Oct 2020 17:48:23 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] crypto: talitos - Fix return type of current_desc_hdr()
Message-ID: <20201030064823.GC25453@gondor.apana.org.au>
References: <002585b74fd8d24b051b6445a7de1058c14afde6.1602149655.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002585b74fd8d24b051b6445a7de1058c14afde6.1602149655.git.christophe.leroy@csgroup.eu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 08, 2020 at 09:34:56AM +0000, Christophe Leroy wrote:
> current_desc_hdr() returns a u32 but in fact this is a __be32,
> leading to a lot of sparse warnings.
> 
> Change the return type to __be32 and ensure it is handled as
> sure by the caller.
> 
> Fixes: 3e721aeb3df3 ("crypto: talitos - handle descriptor not found in error path")
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> ---
>  drivers/crypto/talitos.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
