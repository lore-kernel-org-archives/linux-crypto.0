Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 071A7C04FDE
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Dec 2022 11:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiLILIE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Dec 2022 06:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiLILID (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Dec 2022 06:08:03 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBA111C3E
        for <linux-crypto@vger.kernel.org>; Fri,  9 Dec 2022 03:08:03 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1p3bEK-005gk4-9e; Fri, 09 Dec 2022 19:07:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Dec 2022 19:07:48 +0800
Date:   Fri, 9 Dec 2022 19:07:48 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     davem@davemloft.net, james.hartley@imgtec.com,
        abrestic@chromium.org, will.thomas@imgtec.com,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: img-hash - Fix variable dereferenced before
 check 'hdev->req'
Message-ID: <Y5MXBMkmckXyvyGG@gondor.apana.org.au>
References: <20221201062526.4089-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201062526.4089-1-cuigaosheng1@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 01, 2022 at 02:25:26PM +0800, Gaosheng Cui wrote:
> Smatch report warning as follows:
> 
> drivers/crypto/img-hash.c:366 img_hash_dma_task() warn: variable
> dereferenced before check 'hdev->req'
> 
> Variable dereferenced should be done after check 'hdev->req',
> fix it.
> 
> Fixes: d358f1abbf71 ("crypto: img-hash - Add Imagination Technologies hw hash accelerator")
> Fixes: 10badea259fa ("crypto: img-hash - Fix null pointer exception")
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> ---
>  drivers/crypto/img-hash.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
