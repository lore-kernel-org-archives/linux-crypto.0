Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC5E9C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 09:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C09FE64FD5
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 09:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbhCLJcW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:32:22 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:51232 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232975AbhCLJcM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Mar 2021 04:32:12 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lKe8y-0001Q4-8r; Fri, 12 Mar 2021 20:31:41 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 12 Mar 2021 20:31:40 +1100
Date:   Fri, 12 Mar 2021 20:31:40 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     dan.carpenter@oracle.com, davem@davemloft.net,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] crypto: sun8i-ss: fix result memory leak on error path
Message-ID: <20210312093139.GA728@gondor.apana.org.au>
References: <20210302164145.28552-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302164145.28552-1-clabbe.montjoie@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 02, 2021 at 05:41:45PM +0100, Corentin Labbe wrote:
> This patch fixes a memory leak on an error path.
> 
> Fixes: d9b45418a917 ("crypto: sun8i-ss - support hash algorithms")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> ---
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This patch was already merged a month ago:

commit 1dbc6a1e25be8575d6c4114d1d2b841a796507f7
Author: Corentin Labbe <clabbe.montjoie@gmail.com>
Date:   Fri Feb 12 09:46:10 2021 +0100

    crypto: sun8i-ss - fix result memory leak on error path

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
