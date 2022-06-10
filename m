Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0650DCCA480
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jun 2022 09:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348725AbiFJJTA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jun 2022 05:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348722AbiFJJSH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jun 2022 05:18:07 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5B32050F1;
        Fri, 10 Jun 2022 02:15:53 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nzajw-005MbQ-I2; Fri, 10 Jun 2022 19:15:38 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Jun 2022 17:15:36 +0800
Date:   Fri, 10 Jun 2022 17:15:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     Kai Ye <yekai13@huawei.com>, kernel-janitors@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: hisilicon/sec - fix typos in comment
Message-ID: <YqMLuMKwp5X2H5fT@gondor.apana.org.au>
References: <20220521111145.81697-35-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220521111145.81697-35-Julia.Lawall@inria.fr>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, May 21, 2022 at 01:10:45PM +0200, Julia Lawall wrote:
> Spelling mistakes (triple letters) in comment.
> Detected with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 
> ---
>  drivers/crypto/hisilicon/sec2/sec.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
