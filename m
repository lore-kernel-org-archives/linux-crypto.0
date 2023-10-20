Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F31CDB47E
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 05:53:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235618AbjJTFxJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 01:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbjJTFxI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 01:53:08 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC161A4
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 22:53:06 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qtiRS-0097Yk-71; Fri, 20 Oct 2023 13:53:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Oct 2023 13:53:07 +0800
Date:   Fri, 20 Oct 2023 13:53:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/5] crypto: arm64 - clean up backwards function names
Message-ID: <ZTIVw1NKshGpMF3u@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231010064127.323261-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> In the Linux kernel, a function whose name has two leading underscores
> is conventionally called by the same-named function without leading
> underscores -- not the other way around.  Some of the arm64 crypto code
> got this backwards.  Fix it.
> 
> Eric Biggers (5):
>  crypto: arm64/sha1-ce - clean up backwards function names
>  crypto: arm64/sha2-ce - clean up backwards function names
>  crypto: arm64/sha512-ce - clean up backwards function names
>  crypto: arm64/sha256 - clean up backwards function names
>  crypto: arm64/sha512 - clean up backwards function names
> 
> arch/arm64/crypto/sha1-ce-core.S   |  8 ++++----
> arch/arm64/crypto/sha1-ce-glue.c   | 21 ++++++++++----------
> arch/arm64/crypto/sha2-ce-core.S   |  8 ++++----
> arch/arm64/crypto/sha2-ce-glue.c   | 31 +++++++++++++++---------------
> arch/arm64/crypto/sha256-glue.c    | 26 ++++++++++++-------------
> arch/arm64/crypto/sha512-ce-core.S |  8 ++++----
> arch/arm64/crypto/sha512-ce-glue.c | 26 ++++++++++++-------------
> arch/arm64/crypto/sha512-glue.c    | 12 +++++-------
> 8 files changed, 69 insertions(+), 71 deletions(-)
> 
> base-commit: 8468516f9f93a41dc65158b6428a1a1039c68f20

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
