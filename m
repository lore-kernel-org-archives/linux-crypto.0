Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C54C4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 09:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241335AbiKRJSe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241769AbiKRJRu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 04:17:50 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF06690587;
        Fri, 18 Nov 2022 01:17:44 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ovxVG-00FYZi-3i; Fri, 18 Nov 2022 17:17:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Nov 2022 17:17:42 +0800
Date:   Fri, 18 Nov 2022 17:17:42 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kai Ye <yekai13@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] crypto: hisilicon/sec - some misc cleanup
Message-ID: <Y3dNtjwzdKvwB37v@gondor.apana.org.au>
References: <20221112085105.7644-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112085105.7644-1-yekai13@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Nov 12, 2022 at 08:51:03AM +0000, Kai Ye wrote:
> 1. Fix spelling mistake.
> 2. Remove continuous blank lines
> 
> Kai Ye (1):
>   crypto: hisilicon/sec - fix spelling mistake 'ckeck' -> 'check'
> 
> Wenkai Lin (1):
>   crypto: hisilicon/sec - remove continuous blank lines
> 
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 5 ++---
>  drivers/crypto/hisilicon/sec2/sec_main.c   | 1 -
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> -- 
> 2.17.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
