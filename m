Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CFA1C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Dec 2021 03:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351129AbhLXDZM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Dec 2021 22:25:12 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58448 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234131AbhLXDZM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Dec 2021 22:25:12 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n0bCZ-0006Ge-8E; Fri, 24 Dec 2021 14:25:04 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Dec 2021 14:25:03 +1100
Date:   Fri, 24 Dec 2021 14:25:03 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yang Shen <shenyang39@huawei.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, wangzhou1@hisilicon.com,
        liulongfang@huawei.com
Subject: Re: [PATCH] crypto: hisilicon/zip - add new algorithms for uacce
 device
Message-ID: <YcU9j60rAFNLeXVI@gondor.apana.org.au>
References: <20211214064509.58773-1-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214064509.58773-1-shenyang39@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 14, 2021 at 02:45:09PM +0800, Yang Shen wrote:
> Enable deflate/lz77_zstd algorithm for uacce device on Kunpeng930.
> 
> Signed-off-by: Yang Shen <shenyang39@huawei.com>
> ---
>  drivers/crypto/hisilicon/zip/zip_main.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
