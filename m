Return-Path: <SRS0=+KeW=2R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF4CC2D0C6
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 10:37:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C71B520CC7
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 10:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfL0Khv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Dec 2019 05:37:51 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60206 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbfL0Khv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Dec 2019 05:37:51 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ikn02-0007MU-A7; Fri, 27 Dec 2019 18:37:42 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ikmzy-0005mE-7i; Fri, 27 Dec 2019 18:37:38 +0800
Date:   Fri, 27 Dec 2019 18:37:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc:     davem@davemloft.net, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, vkoul@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] crypto: stm32/hash - Use dma_request_chan() instead
 dma_request_slave_channel()
Message-ID: <20191227103738.3zi6vezpppngnuei@gondor.apana.org.au>
References: <20191217073506.20861-1-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217073506.20861-1-peter.ujfalusi@ti.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 17, 2019 at 09:35:06AM +0200, Peter Ujfalusi wrote:
> dma_request_slave_channel() is a wrapper on top of dma_request_chan()
> eating up the error code.
> 
> By using dma_request_chan() directly the driver can support deferred
> probing against DMA.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/crypto/stm32/stm32-hash.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
