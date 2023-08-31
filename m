Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3104C83F12
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Aug 2023 11:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbjHaL5x (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Aug 2023 07:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbjHaL5x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Aug 2023 07:57:53 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29A6CFA;
        Thu, 31 Aug 2023 04:57:50 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qbgIL-009eDu-Nm; Thu, 31 Aug 2023 19:57:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 31 Aug 2023 19:57:07 +0800
Date:   Thu, 31 Aug 2023 19:57:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yang Shen <shenyang39@huawei.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, ardb@kernel.org,
        kees@kernel.org, linux-kernel@vger.kernel.org, enlin.mu@unisoc.com,
        ebiggers@google.com, gpiccoli@igalia.com, willy@infradead.org,
        yunlong.xing@unisoc.com, yuxiaozhang@google.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        qat-linux@intel.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>
Subject: Re: [PATCH 1/4] crypto: hisilicon/zip - Remove driver
Message-ID: <ZPCAExA8Zs5J6QzJ@gondor.apana.org.au>
References: <ZO8ULhlJSrJ0Mcsx@gondor.apana.org.au>
 <E1qbI7v-009Bvf-CA@formenos.hmeau.com>
 <8a73f9cb-b1e8-3b54-4b6c-7cfb19244560@huawei.com>
 <ZPAoRvMYbsoNfnLk@gondor.apana.org.au>
 <aa6c291a-d9f0-1e2a-63df-e53dfcefba53@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa6c291a-d9f0-1e2a-63df-e53dfcefba53@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 31, 2023 at 05:39:08PM +0800, Yang Shen wrote:
>
> OK, I'm sorry I got missunderstand about the purpose of the patch. The
> hardware also
> support the deflate algorithm. I can change the driver to register the
> deflate interface and
> remove the zlib-deflate. Is this plan acceptable? If yes, please don't
> remove the hisilicon
> zip driver and I'll send the fix patch as soon as possible. It may take me a
> week to adapt
> and verify the driver.

Yes that's fine.  Please send a patch to add deflate and remove
zlib-deflate as well as gzip.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
