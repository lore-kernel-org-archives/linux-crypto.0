Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98CE1C001B0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 11:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235000AbjHKL3f (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 07:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236476AbjHKL3f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 07:29:35 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31164E69
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 04:29:34 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUQKe-00248z-RU; Fri, 11 Aug 2023 19:29:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 19:29:29 +0800
Date:   Fri, 11 Aug 2023 19:29:29 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     qat-linux@intel.com, linux-crypto@vger.kernel.org,
        giovanni.cabiddu@intel.com, davem@davemloft.net
Subject: Re: [PATCH -next] crypto: qat - use kfree_sensitive instead of
 memset/kfree()
Message-ID: <ZNYbmfVgJEL0LaF6@gondor.apana.org.au>
References: <20230802091427.3269183-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230802091427.3269183-1-yangyingliang@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 02, 2023 at 05:14:27PM +0800, Yang Yingliang wrote:
> Use kfree_sensitive() instead of memset() and kfree().
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/crypto/intel/qat/qat_common/qat_compression.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
