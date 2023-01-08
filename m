Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EDBBC53210
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Jan 2023 17:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235282AbjAHRhC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 Jan 2023 12:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236057AbjAHRhA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Jan 2023 12:37:00 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C89FCEE;
        Sun,  8 Jan 2023 09:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=mXbJGtv1Oa57M92L3wt+M4/0MI
        YZDbWS+df8D+AcR1r2Mg8niULnPRw/bUYivK6EPmA/p4OU6Ji0c12a2jLHdJhdtEVAtySGTXVXoo8
        sazKGhXBsuEFpnCGOsnmn1XMBa/l3NkGxRCSDf4xsmp5bd3tOEvLbuv1kqjimrn68a8jImUC1Yhct
        Yog+903RqMaSHR1K2KENA7U25h63HQkFwuukkKQftw4UV22IIwkGibjMkej2xPZrHlILOpOa/CkkO
        i6gNha8bW+vXRTKwVaSNNbisRiIfdfcFBYccmOzTdmx2GTXdNDvIzRSVRfb6sX+tX54Hzv6GB4OKd
        qR4BUGqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pEZbK-00Ef0j-VE; Sun, 08 Jan 2023 17:36:54 +0000
Date:   Sun, 8 Jan 2023 09:36:54 -0800
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>
Subject: Re: [PATCH] crypto: caam - Remove GFP_DMA and add DMA alignment
 padding
Message-ID: <Y7r/NriZiIB+/y9Z@infradead.org>
References: <Y4nDL50nToBbi4DS@gondor.apana.org.au>
 <Y4xpGNNsfbucyUlt@infradead.org>
 <Y47BgCuZsYLX61A9@gondor.apana.org.au>
 <Y47g7qO8dsRdxCgf@infradead.org>
 <Y47+gxbdKR03EYCj@gondor.apana.org.au>
 <Y61WrVAjjtAMAvSh@gondor.apana.org.au>
 <Y651YoR58cCg3adj@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y651YoR58cCg3adj@gondor.apana.org.au>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
