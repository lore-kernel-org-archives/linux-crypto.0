Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F85C4338F
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jul 2021 06:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB87760ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jul 2021 06:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbhGWGDD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Jul 2021 02:03:03 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51488 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233973AbhGWGDD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jul 2021 02:03:03 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1m6ouC-00076e-Fk; Fri, 23 Jul 2021 14:43:32 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1m6ou8-00025Z-KF; Fri, 23 Jul 2021 14:43:28 +0800
Date:   Fri, 23 Jul 2021 14:43:28 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Latypov <dlatypov@google.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        brendanhiggins@google.com, davidgow@google.com,
        linux-kernel@vger.kernel.org, kunit-dev@googlegroups.com
Subject: Re: [RFC v1 1/2] crypto: tcrypt: minimal conversion to run under
 KUnit
Message-ID: <20210723064328.GA7986@gondor.apana.org.au>
References: <20210715213138.1363079-1-dlatypov@google.com>
 <20210715213138.1363079-2-dlatypov@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715213138.1363079-2-dlatypov@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 15, 2021 at 02:31:37PM -0700, Daniel Latypov wrote:
>> == Questions ==
> * does this seem like it would make running the test easier?

I don't mind.  tcrypt these days isn't used so much for correctness
testing.  It's mostly being used for speed testing.  A secondary
use is to instantiate templates.

> * does `tvmem` actually need page-aligned buffers?

I think it may be needed for those split-SG test cases where
we deliberately create a buffer that straddles a page boundary.

> * I have no clue how FIPS intersects with all of this.

It doesn't really matter because in FIPS mode when a correctness
test fails the kernel panics.

>   * would it be fine to leave the test code built-in for FIPS instead of
>   returning -EAGAIN?

The returning -EAGAIN is irrelevant in FIPS mode.  It's more of
an aid in normal mode when you use tcrypt for speed testing.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
