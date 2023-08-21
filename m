Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC51EE4993
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Aug 2023 08:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjHUIUK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Aug 2023 04:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjHUIUK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Aug 2023 04:20:10 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B04698
        for <linux-crypto@vger.kernel.org>; Mon, 21 Aug 2023 01:20:06 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qY08f-0064VU-A8; Mon, 21 Aug 2023 16:19:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 21 Aug 2023 16:19:54 +0800
Date:   Mon, 21 Aug 2023 16:19:54 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Weili Qian <qianweili@huawei.com>, Will Deacon <will@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        shenyang39@huawei.com, liulongfang@huawei.com
Subject: Re: [PATCH v2 1/7] crypto: hisilicon/qm - obtain the mailbox
 configuration at one time
Message-ID: <ZOMeKhMOIEe+VKPt@gondor.apana.org.au>
References: <20230811140749.5202-1-qianweili@huawei.com>
 <20230811140749.5202-2-qianweili@huawei.com>
 <ZN8oEpUBq87m+r++@gondor.apana.org.au>
 <CAMj1kXGNesF91=LScsDSgMx7LwQXOuMjLy7RN5SPLjO3ab7SHA@mail.gmail.com>
 <ZOBBH/XS7Fe0yApm@gondor.apana.org.au>
 <CAMj1kXHd6svuQ-JSVmUZK=xUPR4fC4BCoUjMhFKfg2KBZcavrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHd6svuQ-JSVmUZK=xUPR4fC4BCoUjMhFKfg2KBZcavrw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Aug 19, 2023 at 09:33:18AM +0200, Ard Biesheuvel wrote:
>
> No, that otx2_write128() routine looks buggy, actually, The ! at the
> end means writeback, and so the register holding addr will be
> modified, which is not reflect in the asm constraints. It also lacks a
> barrier.

OK.  But at least having a helper called write128 looks a lot
cleaner than just having unexplained assembly in the code.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
