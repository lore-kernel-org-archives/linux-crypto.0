Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8207C4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Nov 2022 09:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiKYJpl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Nov 2022 04:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiKYJpF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Nov 2022 04:45:05 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAF13AC2E
        for <linux-crypto@vger.kernel.org>; Fri, 25 Nov 2022 01:44:55 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oyVGO-000hvH-CL; Fri, 25 Nov 2022 17:44:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Nov 2022 17:44:52 +0800
Date:   Fri, 25 Nov 2022 17:44:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 0/6] crypto: reduce overhead when self-tests disabled
Message-ID: <Y4COlNVTyL2jEdrC@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114001238.163209-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> This patchset makes it so that the self-test code doesn't still slow
> things down when self-tests are disabled via the kconfig.
> 
> It also optimizes the registration of "internal" algorithms and silences
> a noisy log message.
> 
> Changed in v3:
>  - Made sure CRYPTO_MSG_ALG_LOADED still always gets sent.
>  - Fixed a race condition with larval->test_started.
>  - Used IS_ENABLED() in a couple places to avoid #ifdefs.
> 
> Eric Biggers (6):
>  crypto: optimize algorithm registration when self-tests disabled
>  crypto: optimize registration of internal algorithms
>  crypto: compile out crypto_boot_test_finished when tests disabled
>  crypto: skip kdf_sp800108 self-test when tests disabled
>  crypto: silence noisy kdf_sp800108 self-test
>  crypto: compile out test-related algboss code when tests disabled
> 
> crypto/algapi.c       | 160 ++++++++++++++++++++++++------------------
> crypto/algboss.c      |  22 ++----
> crypto/api.c          |  11 ++-
> crypto/internal.h     |  20 +++++-
> crypto/kdf_sp800108.c |  10 ++-
> 5 files changed, 127 insertions(+), 96 deletions(-)
> 
> 
> base-commit: 557ffd5a4726f8b6f0dd1d4b632ae02c1c063233

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
