Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E8B5C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 18:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 502766137B
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 18:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhI1Seh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 14:34:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241724AbhI1Sdz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 14:33:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4761861246;
        Tue, 28 Sep 2021 18:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632853933;
        bh=ITumyMSLVuu7tgo4iRF6EGhJy0N7SHomYPhr6cSr0MI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VaC3EgKSrHGizNtBgdPVNZzinC4iR1U0WSkLghN+fHfbtWd7dYGoUB2w1IZ2nHo0N
         aR/koF6+R91rbaE36NwCaK7XMe0BkSH8XqyyMdCVV+DMExUCgCzfDAPuTOVWmE3V6R
         khIyqvTQDIPQ3/HnlHXJV65m902aJ1FY/qapyy+akG7rPX27khZHMPjGSmt1bzAqTN
         VzW8dccLjOD7BAdqCAFdNZDM0TJ99Hi+/646v67sLa0cGTkF8HkkDPszPSNQRX+1r9
         Xei6OpzlxS/05iY90x9qK3uCL0LaTetJsInjTyvMyw2/0UeXsu0JtESBhG6rCayGxO
         uOlMPA9hglGRQ==
Date:   Tue, 28 Sep 2021 11:32:09 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>, llvm@lists.linux.dev
Subject: Re: [v2 PATCH] crypto: api - Fix built-in testing dependency failures
Message-ID: <YVNfqUVJ7w4Z3WXK@archlinux-ax161>
References: <20210913071251.GA15235@gondor.apana.org.au>
 <20210917002619.GA6407@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917002619.GA6407@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 17, 2021 at 08:26:19AM +0800, Herbert Xu wrote:
> When complex algorithms that depend on other algorithms are built
> into the kernel, the order of registration must be done such that
> the underlying algorithms are ready before the ones on top are
> registered.  As otherwise they would fail during the self-test
> which is required during registration.
> 
> In the past we have used subsystem initialisation ordering to
> guarantee this.  The number of such precedence levels are limited
> and they may cause ripple effects in other subsystems.
> 
> This patch solves this problem by delaying all self-tests during
> boot-up for built-in algorithms.  They will be tested either when
> something else in the kernel requests for them, or when we have
> finished registering all built-in algorithms, whichever comes
> earlier.
> 
> Reported-by: Vladis Dronov <vdronov@redhat.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

This patch as commit 3cefb01905df ("crypto: api - Fix built-in testing
dependency failures") in -next (along with the follow up fix) causes the
following depmod error:

$ make -skj"$(nproc)" ARCH=powerpc CROSS_COMPILE=powerpc-linux- INSTALL_MOD_PATH=rootfs ppc44x_defconfig all modules_install
depmod: ERROR: Cycle detected: crypto -> crypto_algapi -> crypto
depmod: ERROR: Found 2 modules in dependency cycles!
make: *** [Makefile:1946: modules_install] Error 1

Initially reported on our CI:

https://github.com/ClangBuiltLinux/continuous-integration2/runs/3732847295?check_suite_focus=true

Cheers,
Nathan
