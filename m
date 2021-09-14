Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8B8C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Sep 2021 03:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37456610A6
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Sep 2021 03:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238594AbhINDaR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:30:17 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55126 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238424AbhINDaR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Sep 2021 23:30:17 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mPz7z-00042R-AX; Tue, 14 Sep 2021 11:28:59 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mPz7y-0005Yj-BX; Tue, 14 Sep 2021 11:28:58 +0800
Date:   Tue, 14 Sep 2021 11:28:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>
Subject: Re: [PATCH] crypto: api - Fix built-in testing dependency failures
Message-ID: <20210914032858.GA19339@gondor.apana.org.au>
References: <20210913071251.GA15235@gondor.apana.org.au>
 <YT+VYx7OKELJafYz@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YT+VYx7OKELJafYz@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 13, 2021 at 11:16:03AM -0700, Eric Biggers wrote:
>
> Are there any specific examples that you could give?

The one that triggered this was ecdh-nist-p256-generic, which
calls into drbg.  Both ecdh and drbg are at level subsys_initcall
so the order between them is random.

Beyond this, obviously we have already moved many algorithms
ot subsys_initcall precisely for this purpose and with this
patch, they can all be moved back to module_init.
 
> 'tested' is set before the algorithm has actually been tested, and it sounds
> like the same as CRYPTO_ALG_TESTED which already exists.  Maybe it should be
> called something else, like 'test_started'?

Sure, I can rename that.
 
> Is there a way to continue iterating from the previous algorithm, so that this
> doesn't take quadratic time?

It's certainly possible to optimise this, but I'm not inclined
to do it unless someone can show me that it's a real issue :)

The simplest way to optimise this would be to create a separate
list for the test larvae.

> A comment explaining why the tests aren't run until late_initcall would be
> helpful.  People shouldn't have to dig through commit messages to understand the
> code.

Sure.

> Also, did you check whether there is anything that relies on the crypto API
> being available before or during late_initcall?  That wouldn't work with this
> new approach, right?

The patch is supposed to deal with that scenario by starting the
test on-demand should someone request for it before late_initcall.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
