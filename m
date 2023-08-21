Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15262EE4996
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Aug 2023 10:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234680AbjHUK0k (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Aug 2023 06:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbjHUK0k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Aug 2023 06:26:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E175D8F
        for <linux-crypto@vger.kernel.org>; Mon, 21 Aug 2023 03:26:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7747E615B6
        for <linux-crypto@vger.kernel.org>; Mon, 21 Aug 2023 10:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D61C433C7;
        Mon, 21 Aug 2023 10:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692613597;
        bh=uOeWcgmBXNJ1zsagH2XKY9cjPF1OwXjOc/LzhgltRCw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=om98UPqQt8+7VwNOi6EHSsz4DgxTepm65hAEQpraA2/9EbVGsZYL6/Q2hFvDdupZ0
         v0tueCcDPTI6YHDHHuo/5HseWtqB7E51KZUwW5kwUGD4oZVz8VXKDFVyp6PXMPtJfp
         tD6L5WCTTiUqi3LacbAOGpbCJo0zKjoose8Uye03+NjYbggYMhNUWBYm5TXesSmgFw
         qpV/1YZJDMCUSp9LJN9mrLrFpbG2gohAabrCr/67NPeGqfFhWz8EO9/O2g9VacT52t
         48gR2dAADHiUsXpVtcm3lPzqYt2HWQSWseaQ8sM3GWV87S0vUBQFnkTJQBMm6lbMC/
         N9pQbXotryN1Q==
Date:   Mon, 21 Aug 2023 11:26:32 +0100
From:   Will Deacon <will@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Weili Qian <qianweili@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        shenyang39@huawei.com, liulongfang@huawei.com
Subject: Re: [PATCH v2 1/7] crypto: hisilicon/qm - obtain the mailbox
 configuration at one time
Message-ID: <20230821102632.GA19294@willie-the-truck>
References: <20230811140749.5202-1-qianweili@huawei.com>
 <20230811140749.5202-2-qianweili@huawei.com>
 <ZN8oEpUBq87m+r++@gondor.apana.org.au>
 <CAMj1kXGNesF91=LScsDSgMx7LwQXOuMjLy7RN5SPLjO3ab7SHA@mail.gmail.com>
 <ZOBBH/XS7Fe0yApm@gondor.apana.org.au>
 <CAMj1kXHd6svuQ-JSVmUZK=xUPR4fC4BCoUjMhFKfg2KBZcavrw@mail.gmail.com>
 <ZOMeKhMOIEe+VKPt@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZOMeKhMOIEe+VKPt@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 21, 2023 at 04:19:54PM +0800, Herbert Xu wrote:
> On Sat, Aug 19, 2023 at 09:33:18AM +0200, Ard Biesheuvel wrote:
> >
> > No, that otx2_write128() routine looks buggy, actually, The ! at the
> > end means writeback, and so the register holding addr will be
> > modified, which is not reflect in the asm constraints. It also lacks a
> > barrier.
> 
> OK.  But at least having a helper called write128 looks a lot
> cleaner than just having unexplained assembly in the code.

I guess we want something similar to how writeq() is handled on 32-bit
architectures (see include/linux/io-64-nonatomic-{hi-lo,lo-hi}.h.

It's then CPU-dependent on whether you get atomicity.

Will
