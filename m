Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E59ECAAA3
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Aug 2022 11:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344280AbiHZLHq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Aug 2022 07:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343910AbiHZLHX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2022 07:07:23 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E6A61D6D;
        Fri, 26 Aug 2022 04:06:44 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oRXAT-00FQC3-M2; Fri, 26 Aug 2022 21:06:30 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Aug 2022 19:06:29 +0800
Date:   Fri, 26 Aug 2022 19:06:29 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kai Ye <yekai13@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH] crypto: hisilicon/qm - no judgment in the back process
Message-ID: <YwipNX09i2A5s4rg@gondor.apana.org.au>
References: <20220819074618.57101-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819074618.57101-1-yekai13@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 19, 2022 at 07:46:18AM +0000, Kai Ye wrote:
> Judgment should not be added in the back process. So clean it.
> 
> Signed-off-by: Kai Ye <yekai13@huawei.com>
> ---
>  drivers/crypto/hisilicon/qm.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)

Patch applied.  Thanks. 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
