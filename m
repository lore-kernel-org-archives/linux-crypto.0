Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F2ACDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 05:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbjJTFvL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 01:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235618AbjJTFvK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 01:51:10 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78840CA
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 22:51:08 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qtiPY-0097T9-2l; Fri, 20 Oct 2023 13:51:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Oct 2023 13:51:09 +0800
Date:   Fri, 20 Oct 2023 13:51:09 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: xts - use 'spawn' for underlying single-block
 cipher
Message-ID: <ZTIVTUcuU9lnsC72@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231009023116.266210-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since commit adad556efcdd ("crypto: api - Fix built-in testing
> dependency failures"), the following warning appears when booting an
> x86_64 kernel that is configured with
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y and CONFIG_CRYPTO_AES_NI_INTEL=y,
> even when CONFIG_CRYPTO_XTS=y and CONFIG_CRYPTO_AES=y:
> 
>    alg: skcipher: skipping comparison tests for xts-aes-aesni because xts(ecb(aes-generic)) is unavailable
> 
> This is caused by an issue in the xts template where it allocates an
> "aes" single-block cipher without declaring a dependency on it via the
> crypto_spawn mechanism.  This issue was exposed by the above commit
> because it reversed the order that the algorithms are tested in.
> 
> Specifically, when "xts(ecb(aes-generic))" is instantiated and tested
> during the comparison tests for "xts-aes-aesni", the "xts" template
> allocates an "aes" crypto_cipher for encrypting tweaks.  This resolves
> to "aes-aesni".  (Getting "aes-aesni" instead of "aes-generic" here is a
> bit weird, but it's apparently intended.)  Due to the above-mentioned
> commit, the testing of "aes-aesni", and the finalization of its
> registration, now happens at this point instead of before.  At the end
> of that, crypto_remove_spawns() unregisters all algorithm instances that
> depend on a lower-priority "aes" implementation such as "aes-generic"
> but that do not depend on "aes-aesni".  However, because "xts" does not
> use the crypto_spawn mechanism for its "aes", its dependency on
> "aes-aesni" is not recognized by crypto_remove_spawns().  Thus,
> crypto_remove_spawns() unexpectedly unregisters "xts(ecb(aes-generic))".
> 
> Fix this issue by making the "xts" template use the crypto_spawn
> mechanism for its "aes" dependency, like what other templates do.
> 
> Note, this fix could be applied as far back as commit f1c131b45410
> ("crypto: xts - Convert to skcipher").  However, the issue only got
> exposed by the much more recent changes to how the crypto API runs the
> self-tests, so there should be no need to backport this to very old
> kernels.  Also, an alternative fix would be to flip the list iteration
> order in crypto_start_tests() to restore the original testing order.
> I'm thinking we should do that too, since the original order seems more
> natural, but it shouldn't be relied on for correctness.
> 
> Fixes: adad556efcdd ("crypto: api - Fix built-in testing dependency failures")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> crypto/xts.c | 23 +++++++++++++++--------
> 1 file changed, 15 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
