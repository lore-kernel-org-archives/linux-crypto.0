Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB35C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 09:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEA85218AC
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 09:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbfCOJpr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 05:45:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:56610 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726886AbfCOJpr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 05:45:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1EFEEACA9;
        Fri, 15 Mar 2019 09:45:46 +0000 (UTC)
Date:   Fri, 15 Mar 2019 10:45:44 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     ltp@lists.linux.it, linux-crypto@vger.kernel.org
Subject: Re: [LTP] [PATCH 0/6] ltp: AF_ALG test helpers and a few regression
 tests
Message-ID: <20190315094544.GD4990@dell5510>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20190221053026.18489-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190221053026.18489-1-ebiggers@kernel.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

apart from missing AF_ALG for old distros and missing record
in runtest/cve for af_alg0[3-5] LGTM.
Sorry for delay with the review.

Reviewed-by: Petr Vorel <pvorel@suse.cz>


Kind regards,
Petr

> Hello,

> This series adds helper functions for testing AF_ALG (the userspace
> interface to algorithms in the Linux kernel's crypto API) to the
> Linux Test Project.  It then adds a few sample regression tests.

> I've had these patches sitting around for a while with the goal of also
> writing some "real" tests that test for more than these specific bugs,
> but haven't gotten around to it yet.  And I now consider further
> improving the in-kernel crypto self-tests to be a higher priority.  But
> I figured I'd send this out as-is in case people are interested in
> having this merged, e.g. maybe other people want to add AF_ALG tests to
> LTP too and the 'tst_af_alg' lib would be a good starting point.

> Eric Biggers (6):
>   lib: add tst_af_alg lib
>   crypto/af_alg01: new regression test for hmac nesting bug
>   crypto/af_alg02: new regression test for salsa20 empty message bug
>   crypto/af_alg03: new regression test for rfc7539 hash alg validation
>   crypto/af_alg04: new regression test for vmac race conditions
>   crypto/af_alg05: new regression test for skcipher_walk error bug

>  configure.ac                       |   1 +
>  include/lapi/if_alg.h              |  40 ++++++++
>  include/tst_af_alg.h               | 136 ++++++++++++++++++++++++++
>  lib/tst_af_alg.c                   | 147 +++++++++++++++++++++++++++++
>  runtest/cve                        |   2 +
>  testcases/kernel/crypto/.gitignore |   5 +
>  testcases/kernel/crypto/af_alg01.c |  79 ++++++++++++++++
>  testcases/kernel/crypto/af_alg02.c |  29 ++++++
>  testcases/kernel/crypto/af_alg03.c |  31 ++++++
>  testcases/kernel/crypto/af_alg04.c |  56 +++++++++++
>  testcases/kernel/crypto/af_alg05.c |  43 +++++++++
>  11 files changed, 569 insertions(+)
>  create mode 100644 include/lapi/if_alg.h
>  create mode 100644 include/tst_af_alg.h
>  create mode 100644 lib/tst_af_alg.c
>  create mode 100644 testcases/kernel/crypto/af_alg01.c
>  create mode 100644 testcases/kernel/crypto/af_alg02.c
>  create mode 100644 testcases/kernel/crypto/af_alg03.c
>  create mode 100644 testcases/kernel/crypto/af_alg04.c
>  create mode 100644 testcases/kernel/crypto/af_alg05.c
