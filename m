Return-Path: <SRS0=Bmkv=B7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C552C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 07:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30BBD2063A
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 07:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgHUH4D (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Aug 2020 03:56:03 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49932 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726864AbgHUH4C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Aug 2020 03:56:02 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k91tw-0003wO-TA; Fri, 21 Aug 2020 17:55:54 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Aug 2020 17:55:52 +1000
Date:   Fri, 21 Aug 2020 17:55:52 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, chohnstaedt@innominate.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: ixp4xx - Fix the size used in a
 'dma_free_coherent()' call
Message-ID: <20200821075552.GE25143@gondor.apana.org.au>
References: <20200802145648.699335-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200802145648.699335-1-christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Aug 02, 2020 at 04:56:48PM +0200, Christophe JAILLET wrote:
> Update the size used in 'dma_free_coherent()' in order to match the one
> used in the corresponding 'dma_alloc_coherent()', in 'setup_crypt_desc()'.
> 
> Fixes: 81bef0150074 ("crypto: ixp4xx - Hardware crypto support for IXP4xx CPUs")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/crypto/ixp4xx_crypto.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
