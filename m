Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B72C77B73
	for <linux-crypto@archiver.kernel.org>; Wed, 24 May 2023 10:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbjEXKSk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 May 2023 06:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbjEXKSH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2023 06:18:07 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D7DE56
        for <linux-crypto@vger.kernel.org>; Wed, 24 May 2023 03:17:21 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q1lYS-00Cl6q-0j; Wed, 24 May 2023 18:17:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 24 May 2023 18:17:16 +0800
Date:   Wed, 24 May 2023 18:17:16 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto/Kconfig: warn about performance overhead of
 CRYPTO_STATS
Message-ID: <ZG3kLCmzg5DnVLHF@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230520173105.8562-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Make the help text for CRYPTO_STATS explicitly mention that it reduces
> the performance of the crypto API.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> crypto/Kconfig | 3 +++
> 1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
