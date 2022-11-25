Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D042C4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Nov 2022 09:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiKYJrN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Nov 2022 04:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiKYJq0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Nov 2022 04:46:26 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD1C42180;
        Fri, 25 Nov 2022 01:45:23 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oyVGq-000hvO-5H; Fri, 25 Nov 2022 17:45:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Nov 2022 17:45:20 +0800
Date:   Fri, 25 Nov 2022 17:45:20 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhang Yiqun <zhangyiqun@phytium.com.cn>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhangyiqun@phytium.com.cn
Subject: Re: [PATCH] crypto: tcrypt - Fix multibuffer skcipher speed test mem
 leak
Message-ID: <Y4COsJN27wpejCEV@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116092411.2432-1-zhangyiqun@phytium.com.cn>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Zhang Yiqun <zhangyiqun@phytium.com.cn> wrote:
> In the past, the data for mb-skcipher test has been allocated
> twice, that means the first allcated memory area is without
> free, which may cause a potential memory leakage. So this
> patch is to remove one allocation to fix this error.
> 
> Signed-off-by: Zhang Yiqun <zhangyiqun@phytium.com.cn>
> ---
> crypto/tcrypt.c | 9 ---------
> 1 file changed, 9 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
