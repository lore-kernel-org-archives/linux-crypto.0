Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF566C43334
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 17:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiGER6l (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jul 2022 13:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbiGER6k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jul 2022 13:58:40 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC5616589;
        Tue,  5 Jul 2022 10:58:38 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7FD8E67373; Tue,  5 Jul 2022 19:58:34 +0200 (CEST)
Date:   Tue, 5 Jul 2022 19:58:34 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     LABBE Corentin <clabbe@baylibre.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        herbert@gondor.apana.org.au, heiko@sntech.de,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-sunxi@lists.linux.dev
Subject: Re: [RFC PATCH] crypto: flush poison data
Message-ID: <20220705175834.GA15815@lst.de>
References: <20220701132735.1594822-1-clabbe@baylibre.com> <4570f6d8-251f-2cdb-1ea6-c3a8d6bb9fcf@codethink.co.uk> <YsP0eekTthD4jWGV@Red> <20220705164213.GA14484@lst.de> <YsR7O4q4IRI14Wkc@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsR7O4q4IRI14Wkc@Red>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 05, 2022 at 07:56:11PM +0200, LABBE Corentin wrote:
> My problem is that a dma_sync on the data buffer corrupt the poison buffer as collateral dommage.
> Probably because the sync operate on a larger region than the requested dma_sync length.
> So I try to flush poison data in the cryptoAPI.

Data structures that are DMAed to must be aligned to
the value returned by dma_get_cache_alignment(), as non-coherent DMA
by definition can disturb the data inside that boundary.  That is not
a bug but fundamentally part of how DMA works when the device attachment
is not cache coherent.
