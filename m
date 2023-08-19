Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 579DBEE49A2
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Aug 2023 04:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjHSEMp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 19 Aug 2023 00:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjHSEMb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Aug 2023 00:12:31 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96A126AB
        for <linux-crypto@vger.kernel.org>; Fri, 18 Aug 2023 21:12:27 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qXDJv-005Ymg-4r; Sat, 19 Aug 2023 12:12:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 19 Aug 2023 12:12:15 +0800
Date:   Sat, 19 Aug 2023 12:12:15 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Weili Qian <qianweili@huawei.com>, Will Deacon <will@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        shenyang39@huawei.com, liulongfang@huawei.com
Subject: Re: [PATCH v2 1/7] crypto: hisilicon/qm - obtain the mailbox
 configuration at one time
Message-ID: <ZOBBH/XS7Fe0yApm@gondor.apana.org.au>
References: <20230811140749.5202-1-qianweili@huawei.com>
 <20230811140749.5202-2-qianweili@huawei.com>
 <ZN8oEpUBq87m+r++@gondor.apana.org.au>
 <CAMj1kXGNesF91=LScsDSgMx7LwQXOuMjLy7RN5SPLjO3ab7SHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGNesF91=LScsDSgMx7LwQXOuMjLy7RN5SPLjO3ab7SHA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 18, 2023 at 12:21:02PM +0200, Ard Biesheuvel wrote:
>
> IIRC there have been other cases (ThunderX?) where 128 bit MMIO
> accessors were needed for some peripheral, but common arm64 helpers
> were rejected on the basis that this atomic behavior is not
> architectural.
> 
> Obviously, using inline asm in the driver is not the right way either,
> so perhaps we should consider introducing some common infrastructure
> anyway, including some expectation management about their guarantees.

The ones in

	drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h

look better.  So perhaps copy them into hisilicon?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
