Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E39E95A91
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Oct 2023 07:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345393AbjJIHjg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Oct 2023 03:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345391AbjJIHje (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Oct 2023 03:39:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF9B8F
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 00:39:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D9CC433C8
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 07:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696837173;
        bh=6gmkf3r8EIroqh78FvTO1bF3f2O0oPmF3+XjE3OaQ74=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=I7NbGhT00L0mXH4pnAyx+5uwKuLb7+2qVlRNsp3k6M/6zJtI0rAZPUbQ2jtIcXIXN
         kycejeCnstWnuvQYI8MbMcvoglzWb5Rkdqfmhp8/3mGY9G2mg0nf06hfdn1Pz8HXw0
         aUWblnvsSIpdlpaU4b29gRWzN6lDG3Ndqr5Ll70RbOTDeprqgY1Be6ZKY1i5kKSK7u
         ZJctqFxEl2CQO0/BLNEw/jYDzAg+MS6E62n5I83UDo7LDFJbsBXdFJhqmz9i/byiqx
         Y0pxTqY2z9PcI1yo17/To9CJsSvlu2oJBZ4y7gRnuuWkRqLsRM6oDIrCuV19S17ckl
         4DpUYAZbD28rQ==
Date:   Mon, 9 Oct 2023 00:39:31 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: xts - use 'spawn' for underlying single-block
 cipher
Message-ID: <20231009073931.GB279961@sol.localdomain>
References: <20231009023116.266210-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231009023116.266210-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Oct 08, 2023 at 07:31:16PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since commit adad556efcdd ("crypto: api - Fix built-in testing
> dependency failures"), the following warning appears when booting an
> x86_64 kernel that is configured with
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y and CONFIG_CRYPTO_AES_NI_INTEL=y,
> even when CONFIG_CRYPTO_XTS=y and CONFIG_CRYPTO_AES=y:
> 
>     alg: skcipher: skipping comparison tests for xts-aes-aesni because xts(ecb(aes-generic)) is unavailable
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

BTW, I noticed that the essiv template has this problem too.  It shows up when
essiv-cbc-aes-sha256-ce is tested on arm64.

- Eric
