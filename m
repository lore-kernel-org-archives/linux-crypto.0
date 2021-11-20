Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA93C433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Nov 2021 04:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236974AbhKTEdZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Nov 2021 23:33:25 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:56910 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236990AbhKTEdR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Nov 2021 23:33:17 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1moI0u-0001Jx-JQ; Sat, 20 Nov 2021 12:30:08 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1moI0t-0006m0-1e; Sat, 20 Nov 2021 12:30:07 +0800
Date:   Sat, 20 Nov 2021 12:30:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Chengfeng Ye <cyeaa@connect.ust.hk>
Cc:     thara.gopinath@linaro.org, davem@davemloft.net,
        svarbanov@mm-sol.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] crypto: qce: fix uaf on qce_ahash_register_one
Message-ID: <20211120043007.GI25752@gondor.apana.org.au>
References: <20211104133831.20049-1-cyeaa@connect.ust.hk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104133831.20049-1-cyeaa@connect.ust.hk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 04, 2021 at 06:38:31AM -0700, Chengfeng Ye wrote:
> Pointer base points to sub field of tmpl, it
> is dereferenced after tmpl is freed. Fix
> this by accessing base before free tmpl.
> 
> Fixes: ec8f5d8f ("crypto: qce - Qualcomm crypto engine driver")
> Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
> ---
>  drivers/crypto/qce/sha.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
