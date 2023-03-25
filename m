Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA8AC6FD1C
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Mar 2023 05:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjCYF7q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 25 Mar 2023 01:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCYF7q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Mar 2023 01:59:46 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCE119685;
        Fri, 24 Mar 2023 22:59:43 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pfww8-008XTb-Is; Sat, 25 Mar 2023 13:59:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 25 Mar 2023 13:59:32 +0800
Date:   Sat, 25 Mar 2023 13:59:32 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2] crypto - img-hash: Depend on OF and silence compile
 test warning
Message-ID: <ZB6NxI9/llX7oFdg@gondor.apana.org.au>
References: <20230319144439.31399-1-krzysztof.kozlowski@linaro.org>
 <ZB14gXqnkBzhdm0i@gondor.apana.org.au>
 <2dd13286-c518-66a7-44f4-b6c4f8acd061@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2dd13286-c518-66a7-44f4-b6c4f8acd061@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 24, 2023 at 11:51:43AM +0100, Krzysztof Kozlowski wrote:
>
> > You should either add a dependency on OF or __maybe_unused.
> > Adding both makes no sense.
> 
> Of course it makes, otherwise you have warnings which is also fixed here.

It won't create a warning if you depend on OF without COMPILE_TEST.

Anyway, I think adding __maybe_unused by itself is sufficient.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
