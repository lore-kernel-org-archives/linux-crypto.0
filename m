Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9051EC352A1
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Dec 2022 06:28:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbiLFG2a (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Dec 2022 01:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiLFG21 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Dec 2022 01:28:27 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84F92715C;
        Mon,  5 Dec 2022 22:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zvJHRg8epOGP7B5mR8RnlBGi9TRfSPxBhBQXSLBakps=; b=DOU8MPSo4/6Yazfa2uAn8wzXSS
        eFsmLNzVCEYxo5MoDVzwF2EepzbtjgG3Uj8csdjHne35+YBCYYXFH6WOnvTzHKZQNf25x06nyWsz5
        Hy5306ZvwyeXOSQ8GjrtnL/G/5wvYtKutyu17uvfXmKTF5cOCKuv51k2F7qyYJ8CLHj1fWvaDTHkP
        LN9nyRPZCXa2+qv688B642E7P97BNxw7Jl+rktMfTWym9G8fOII5Y/FoR1mn474mGflPHSrPyKKEw
        XWsgUkFvndIeYNrKBxJ5bMGsIWXZJOWztZscwkmNzxDeIs+EMZebJsdRko/nTwfiNulIRVsaWOYjE
        b66gqmfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p2RQs-0026iT-33; Tue, 06 Dec 2022 06:27:58 +0000
Date:   Mon, 5 Dec 2022 22:27:58 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LinuxKernelMailingList@gondor.apana.org.au,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 0/10] crypto: Driver conversions for DMA alignment
Message-ID: <Y47g7qO8dsRdxCgf@infradead.org>
References: <Y4nDL50nToBbi4DS@gondor.apana.org.au>
 <Y4xpGNNsfbucyUlt@infradead.org>
 <Y47BgCuZsYLX61A9@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y47BgCuZsYLX61A9@gondor.apana.org.au>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 06, 2022 at 12:13:52PM +0800, Herbert Xu wrote:
> Yes they're clearly bogus.  Basically they are saying they want
> memory that is aligned sufficiently for DMA.  So if Catalin's
> patch-set will break this assumption, then all the GFP_DMA allocations
> in drivers/crypto will need to be enlarged to take this into
> account.

But GFP_DMA never did do anything at all about alignment.  It picks
allocations from ZONE_DMA (which on x86 is the first 16MB only).
