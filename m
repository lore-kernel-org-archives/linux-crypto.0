Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DB0C001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 05:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346657AbjJTF5l (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 01:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235625AbjJTF5l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 01:57:41 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6925FD41
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 22:57:39 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qtiVr-0097iC-1U; Fri, 20 Oct 2023 13:57:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Oct 2023 13:57:40 +0800
Date:   Fri, 20 Oct 2023 13:57:40 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] crypto: skcipher - fix weak key check for lskciphers
Message-ID: <ZTIW1G7/82fclFuu@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231013055613.39655-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When an algorithm of the new "lskcipher" type is exposed through the
> "skcipher" API, calls to crypto_skcipher_setkey() don't pass on the
> CRYPTO_TFM_REQ_FORBID_WEAK_KEYS flag to the lskcipher.  This causes
> self-test failures for ecb(des), as weak keys are not rejected anymore.
> Fix this.
> 
> Fixes: 31865c4c4db2 ("crypto: skcipher - Add lskcipher")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> v2: remove prototype for crypto_lskcipher_setkey_sg()
> 
> crypto/lskcipher.c | 8 --------
> crypto/skcipher.c  | 8 +++++++-
> crypto/skcipher.h  | 2 --
> 3 files changed, 7 insertions(+), 11 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
