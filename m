Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9439C7EE21
	for <linux-crypto@archiver.kernel.org>; Thu,  4 May 2023 09:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjEDJfu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 May 2023 05:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjEDJft (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 May 2023 05:35:49 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849B844AD;
        Thu,  4 May 2023 02:35:45 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1puVNC-0057KI-BQ; Thu, 04 May 2023 17:35:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 04 May 2023 17:35:39 +0800
Date:   Thu, 4 May 2023 17:35:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Yang <mmyangfl@gmail.com>
Cc:     linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: hash - Add default handlers for digest, export,
 import
Message-ID: <ZFN8a0z6qQUW6Zbg@gondor.apana.org.au>
References: <20230504093255.350365-1-mmyangfl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504093255.350365-1-mmyangfl@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 04, 2023 at 05:32:55PM +0800, David Yang wrote:
> The document of struct ahash_alg explicitly states that @finup,
> combination of @update and @final, is optional, while said nothing about
> @digest, which is combination of @init and @finup (@update and @final).
> 
> This gives a illusion that @digest might be optional. However
> crypto_ahash_init_tfm() strangely does expect a non-NULL @digest,
> otherwise it'll result in NULL pointer dereference.
> 
> Add default handlers for digest, export, import according to the behavior
> in the document, and mark them optional.
> 
> Signed-off-by: David Yang <mmyangfl@gmail.com>
> ---
>  crypto/ahash.c        | 28 +++++++++++++++++++++++++---
>  include/crypto/hash.h | 12 ++++++------
>  2 files changed, 31 insertions(+), 9 deletions(-)

Nack.  There is a default for finup because finup was added later.
Every driver should implement all of the methods.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
