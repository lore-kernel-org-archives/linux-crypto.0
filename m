Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FE27C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Sep 2022 06:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiI3GQv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Sep 2022 02:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiI3GQW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Sep 2022 02:16:22 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA51017DC18;
        Thu, 29 Sep 2022 23:16:19 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oe9Jn-00A5Bk-NY; Fri, 30 Sep 2022 16:16:17 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Sep 2022 14:16:15 +0800
Date:   Fri, 30 Sep 2022 14:16:15 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, ye xingchen <ye.xingchen@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] crypto: zip - remove the unneeded result
 variable
Message-ID: <YzaJr11yEq2XT0FZ@gondor.apana.org.au>
References: <20220922112753.236815-1-ye.xingchen@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922112753.236815-1-ye.xingchen@zte.com.cn>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 22, 2022 at 11:27:53AM +0000, cgel.zte@gmail.com wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> Return the value directly instead of storing it in another redundant
> variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> ---
>  drivers/crypto/cavium/zip/zip_crypto.c | 30 ++++++--------------------
>  1 file changed, 6 insertions(+), 24 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
