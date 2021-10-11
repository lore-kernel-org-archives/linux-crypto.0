Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0239DC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Oct 2021 08:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E04AC60F24
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Oct 2021 08:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbhJKIol (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Oct 2021 04:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbhJKIoi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Oct 2021 04:44:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D45C061570;
        Mon, 11 Oct 2021 01:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/9XeIUL5t6UhFKE1bZ5lYwZBG0z2C2rYsqVo0XbNNGw=; b=N9LLFa/xSnmtbEzFI+Uhj2OkKN
        ihZZM0pAS2MXB6OyOrJ64OXgGDNZgg8TVgP3fu6G4BjgoGGvA/KQi5QXKXabr57k/uZw4MzmXBT2Z
        u9CWFDY5I53M67Vmk60eE79OtTetnrhgTVl/prrIiG0HjUmmD2A7j61Aro9AvZJc2B5Ew6B6JBQmT
        awUEM1gtXV6m+boK9+kffJGJFqLIVu7qqecOCAJl31zXw85Iz6rJCrkdG6WpGhZ1boPpARgKzMTCG
        N67cecqwq1ecmBG0Rse4YGTAMAxK40bl4R7I8gX8LlLvKIiOVvQwSMP9Ly8ZRvkw1r8BV69suNZcR
        aNXf8Zkw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mZqpN-005OAP-BH; Mon, 11 Oct 2021 08:39:04 +0000
Date:   Mon, 11 Oct 2021 09:38:33 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: octeontx2 - Use dma_alloc_coherent() instead of
 kzalloc/dma_map_single()
Message-ID: <YWP4CbI7yENsP8/f@infradead.org>
References: <20211010160010.435-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211010160010.435-1-caihuoqing@baidu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 11, 2021 at 12:00:04AM +0800, Cai Huoqing wrote:
> Replacing kzalloc/kfree/dma_map_single/dma_unmap_single()
> with dma_alloc_coherent/dma_free_coherent() helps to reduce
> code size, and simplify the code, and coherent DMA will not
> clear the cache every time.

As just explained in another patch like this please qualify the
savings as we have actual results that shows the reverse of your claims.
