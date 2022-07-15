Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 400D8C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Jul 2022 08:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbiGOIrL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Jul 2022 04:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbiGOIrI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Jul 2022 04:47:08 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9172E814B2;
        Fri, 15 Jul 2022 01:47:07 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oCGyS-000nsb-6M; Fri, 15 Jul 2022 18:47:01 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Jul 2022 16:47:00 +0800
Date:   Fri, 15 Jul 2022 16:47:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yuan Can <yuancan@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, gilad@benyossef.com
Subject: Re: [PATCH -next] crypto: ccree: Add missing clk_disable_unprepare()
 in cc_pm_resume()
Message-ID: <YtEphJCnOOkh8pDf@gondor.apana.org.au>
References: <20220704130145.103520-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704130145.103520-1-yuancan@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 04, 2022 at 01:01:45PM +0000, Yuan Can wrote:
> Add clk_disable_unprepare() on error path in cc_pm_resume().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
>  drivers/crypto/ccree/cc_pm.c | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
