Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC69ECAAD5
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Sep 2022 10:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbiIBKZy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Sep 2022 06:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235795AbiIBKZw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Sep 2022 06:25:52 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A785926E;
        Fri,  2 Sep 2022 03:25:50 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oU3rt-000Kmt-Km; Fri, 02 Sep 2022 20:25:46 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Sep 2022 18:25:45 +0800
Date:   Fri, 2 Sep 2022 18:25:45 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     cuigaosheng <cuigaosheng1@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 1/2] crypto: api - Fix IS_ERR() vs NULL check
Message-ID: <YxHaKSOedCC9DLX1@gondor.apana.org.au>
References: <20220825084138.1881954-1-cuigaosheng1@huawei.com>
 <20220825084138.1881954-2-cuigaosheng1@huawei.com>
 <Ywc3u9ObRCpxQsK0@gondor.apana.org.au>
 <0ae57826-6a8c-b08b-2889-f91d50bf6e59@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ae57826-6a8c-b08b-2889-f91d50bf6e59@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 25, 2022 at 09:10:49PM +0800, cuigaosheng wrote:
> Thanks for taking the time to review this patch.
> 
> crypto_alloc_test_larval() will return null if manager is disabled,
> it will not return error pointers, IS_ERR should not be used to checking
> return value, should we fix it? or use another solution?

That's because NULL is returned indicating success.  When a genuine
error occurs then an error pointer will be returned.  IS_ERR will be
true only in case of a genuine error.  It will be false when either
NULL or a real larval pointer is returned.

You need to describe your problem more clearly as I have no idea what
you're trying to fix.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
