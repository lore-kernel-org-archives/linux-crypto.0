Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A440C43334
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 16:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbiGEQmV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jul 2022 12:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233024AbiGEQmS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jul 2022 12:42:18 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C200F1EECB;
        Tue,  5 Jul 2022 09:42:17 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0C53367373; Tue,  5 Jul 2022 18:42:14 +0200 (CEST)
Date:   Tue, 5 Jul 2022 18:42:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     LABBE Corentin <clabbe@baylibre.com>
Cc:     Ben Dooks <ben.dooks@codethink.co.uk>, herbert@gondor.apana.org.au,
        hch@lst.de, heiko@sntech.de, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-sunxi@lists.linux.dev
Subject: Re: [RFC PATCH] crypto: flush poison data
Message-ID: <20220705164213.GA14484@lst.de>
References: <20220701132735.1594822-1-clabbe@baylibre.com> <4570f6d8-251f-2cdb-1ea6-c3a8d6bb9fcf@codethink.co.uk> <YsP0eekTthD4jWGV@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsP0eekTthD4jWGV@Red>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 05, 2022 at 10:21:13AM +0200, LABBE Corentin wrote:
> 
> I just copied what did drivers/crypto/xilinx/zynqmp-sha.c.
> I tried to do flush_dcache_range() but it seems to not be implemented on riscV.

That driver is broken and should no have been merged in that form.

> And flush_dcache_page(virt_to_page(addr), len) produce a kernel panic.

And that's good so.  Drivers have no business doing their own cache
flushing.  That is the job of the dma-mapping implementation, so I'd
suggest to look for problems there.
