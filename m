Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7031CC19F2B
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jul 2022 10:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235645AbiG2Kk2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Jul 2022 06:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbiG2Kk1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Jul 2022 06:40:27 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B16525E85;
        Fri, 29 Jul 2022 03:40:26 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oHNPk-005oj6-OO; Fri, 29 Jul 2022 20:40:18 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 Jul 2022 18:40:17 +0800
Date:   Fri, 29 Jul 2022 18:40:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: tcrypt - Remove the static variable
 initialisations to NULL
Message-ID: <YuO5EUwke7Se/lIo@gondor.apana.org.au>
References: <20220723092640.7559-1-wangborong@cdjrlc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723092640.7559-1-wangborong@cdjrlc.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jul 23, 2022 at 05:26:40PM +0800, Jason Wang wrote:
> Initialise global and static variable to NULL is always unnecessary.
> Remove the unnecessary initialisations.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
> ---
>  crypto/tcrypt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
