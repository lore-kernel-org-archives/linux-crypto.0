Return-Path: <SRS0=TFX5=DJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D172CC4363D
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 11:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A08D2207F7
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 11:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387852AbgJBLyv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Oct 2020 07:54:51 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49150 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387765AbgJBLyu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Oct 2020 07:54:50 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kOJe9-0005Ri-1e; Fri, 02 Oct 2020 21:54:46 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2020 21:54:45 +1000
Date:   Fri, 2 Oct 2020 21:54:45 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc:     t-kristo@ti.com, davem@davemloft.net, hch@infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        j-keerthy@ti.com
Subject: Re: [PATCH v2] crypto: sa2ul: Fix DMA mapping API usage
Message-ID: <20201002115445.GF1205@gondor.apana.org.au>
References: <20200923101144.24748-1-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923101144.24748-1-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 23, 2020 at 01:11:44PM +0300, Peter Ujfalusi wrote:
> Make sure that we call the dma_unmap_sg on the correct scatterlist on
> completion with the correct sg_nents.
> 
> Use sg_table to managed the DMA mapping and at the same time add the needed
> dma_sync calls for the sg_table.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
> Hi,
> 
> Changes since v1:
> - use sg_table to manage the mapped sgl as suggested by Christoph
> 
> Regards,
> Peter
> 
>  drivers/crypto/sa2ul.c | 215 ++++++++++++++++++++++-------------------
>  1 file changed, 117 insertions(+), 98 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
