Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04AF4C6FD1C
	for <linux-crypto@archiver.kernel.org>; Sun, 26 Mar 2023 02:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjCZCxh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 25 Mar 2023 22:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCZCxg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Mar 2023 22:53:36 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EAA65BBF;
        Sat, 25 Mar 2023 19:53:35 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pgGVW-008kD7-JH; Sun, 26 Mar 2023 10:53:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 26 Mar 2023 10:53:22 +0800
Date:   Sun, 26 Mar 2023 10:53:22 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2] crypto - img-hash: Depend on OF and silence compile
 test warning
Message-ID: <ZB+zopc6ieXoqFcE@gondor.apana.org.au>
References: <20230319144439.31399-1-krzysztof.kozlowski@linaro.org>
 <ZB14gXqnkBzhdm0i@gondor.apana.org.au>
 <2dd13286-c518-66a7-44f4-b6c4f8acd061@linaro.org>
 <ZB6NxI9/llX7oFdg@gondor.apana.org.au>
 <03009090-e1e9-a176-c629-dee99993e9ad@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03009090-e1e9-a176-c629-dee99993e9ad@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Mar 25, 2023 at 12:01:47PM +0100, Krzysztof Kozlowski wrote:
>
> In that case yes, but we want COMPILE_TEST for build coverage.

No we don't.  Selecting OF is trivial and even the bots will
cover this.  We have lots of drivers under crypto that depend
on COMPILE_TEST as well as OF.

> > Anyway, I think adding __maybe_unused by itself is sufficient.

If you really want to patch this driver then adding maybe_unused
is the way to go.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
