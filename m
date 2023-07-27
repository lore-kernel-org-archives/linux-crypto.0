Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD43EC001E0
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jul 2023 08:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbjG0IOf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jul 2023 04:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234330AbjG0IN4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jul 2023 04:13:56 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4184D5251;
        Thu, 27 Jul 2023 01:09:10 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qOw2I-000YeE-6L; Thu, 27 Jul 2023 16:07:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Jul 2023 16:07:50 +0800
Date:   Thu, 27 Jul 2023 16:07:50 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhang Yiqun <zhangyiqun@phytium.com.cn>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: all - alloc and init all req alloc as zero
Message-ID: <ZMIl1vSitJBU3UJS@gondor.apana.org.au>
References: <20230727080548.8666-1-zhangyiqun@phytium.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727080548.8666-1-zhangyiqun@phytium.com.cn>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 27, 2023 at 04:05:48PM +0800, Zhang Yiqun wrote:
> This patch is to change all req struct alloc function from kmalloc
> to kzalloc. Sometimes, it will incur some errors without initialized
> zero.
> 
> Signed-off-by: Zhang Yiqun <zhangyiqun@phytium.com.cn>
> ---
>  include/crypto/akcipher.h | 2 +-
>  include/crypto/hash.h     | 2 +-
>  include/crypto/kpp.h      | 2 +-
>  include/crypto/skcipher.h | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)

Nack.  Unless you have a specific issue please don't submit vague
patches like this.  You should always state what issue led you to
make a change like this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
