Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11346C4167B
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Dec 2022 15:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235013AbiL3POj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Dec 2022 10:14:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiL3POj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Dec 2022 10:14:39 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA172633;
        Fri, 30 Dec 2022 07:14:38 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pBH5b-00COuz-Ti; Fri, 30 Dec 2022 23:14:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Dec 2022 23:14:31 +0800
Date:   Fri, 30 Dec 2022 23:14:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: wp512: disable kmsan checks in
 wp512_process_buffer()
Message-ID: <Y68AV8f2cyyYcrLe@gondor.apana.org.au>
References: <20221215162956.4037570-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215162956.4037570-1-arnd@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 15, 2022 at 05:29:38PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The memory sanitizer causes excessive register spills in this function:
> 
> crypto/wp512.c:782:13: error: stack frame size (2104) exceeds limit (2048) in 'wp512_process_buffer' [-Werror,-Wframe-larger-than]
> 
> Assume that this one is safe, and mark it as needing no checks to
> get the stack usage back down to the normal level.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  crypto/wp512.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
