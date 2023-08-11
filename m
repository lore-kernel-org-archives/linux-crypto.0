Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43EDC001B0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 11:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjHKL22 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 07:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236434AbjHKL21 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 07:28:27 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083B8E73
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 04:28:27 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUQJZ-00247Y-0Z; Fri, 11 Aug 2023 19:28:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 19:28:21 +0800
Date:   Fri, 11 Aug 2023 19:28:21 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-crypto@vger.kernel.org, jiajie.ho@starfivetech.com,
        william.qiu@starfivetech.com, huan.feng@starfivetech.com,
        davem@davemloft.net
Subject: Re: [PATCH -next] crypto: starfive - fix return value check in
 starfive_aes_prepare_req()
Message-ID: <ZNYbVZUcsqFBg1Cy@gondor.apana.org.au>
References: <20230731140249.2691001-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230731140249.2691001-1-yangyingliang@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 31, 2023 at 10:02:49PM +0800, Yang Yingliang wrote:
> kzalloc() returns NULL pointer not PTR_ERR() when it fails,
> so replace the IS_ERR() check with NULL pointer check.
> 
> Fixes: e22471c2331c ("crypto: starfive - Add AES skcipher and aead support")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/crypto/starfive/jh7110-aes.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
