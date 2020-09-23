Return-Path: <SRS0=nWKA=DA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85776C4363D
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Sep 2020 06:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B41620639
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Sep 2020 06:02:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hZCmO8Od"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgIWGCx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Sep 2020 02:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgIWGCx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Sep 2020 02:02:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9ACC061755;
        Tue, 22 Sep 2020 23:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hZUL2HnNKYLfhcs8IoUDD8keLkSgoNqI3GOKUrr4gtI=; b=hZCmO8Od0bWL+z/luBOLjY+bwK
        Nad77oKEyuEVoNTuVlPLlqafZ1BWpYKTAUHsC992ktWe5f9RKNgPv5YMl6i8OMdaQCW4gOAbY40F8
        08TqkJVinw37x+Dujpfr50jBrGBrtNKEXJiOfImvFH4z82gW5h2LGTS+ewfAin7nG3ORGU72iSf2X
        hZ8RP5r3CGShYRSWmwmwiOsUAgjWiXJy6/lfakYhUHFjrX+M6KMFgDKahNXMaENqXtSv85ftDHcjb
        4IzU+cu/sO3HUqmGrP/EWO5CZzOY4hd8NUhKsIX5tz2LT3b4ukBQCIfK0P3ARnbSRVK3tqPsuMYFU
        G0ls0mTw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKxrb-0003Dy-1F; Wed, 23 Sep 2020 06:02:47 +0000
Date:   Wed, 23 Sep 2020 07:02:46 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc:     herbert@gondor.apana.org.au, t-kristo@ti.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        j-keerthy@ti.com
Subject: Re: [PATCH] crypto: sa2ul: Fix DMA mapping API usage
Message-ID: <20200923060246.GA11550@infradead.org>
References: <20200921113846.6973-1-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921113846.6973-1-peter.ujfalusi@ti.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 21, 2020 at 02:38:46PM +0300, Peter Ujfalusi wrote:
> Make sure that we call the dma_unmap_sg on the correct scatterlist on
> completion with the correct sg_nents.
> 
> We also should be calling dma_sync_sg_for_device() on the tx buffer before
> giving it to the DMA and the dma_sync_sg_for_cpu() should be called on the
> scatterlist we received the data back.

You might want to look into using struct sg_table and the DMA mapping
helpers using it to simplify this a bit.
