Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A2BC433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Oct 2021 05:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57A636124B
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Oct 2021 05:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352098AbhJAFwx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Oct 2021 01:52:53 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55750 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241958AbhJAFwq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Oct 2021 01:52:46 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mWBRk-00065u-FU; Fri, 01 Oct 2021 13:51:00 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mWBRi-0007qF-UQ; Fri, 01 Oct 2021 13:50:58 +0800
Date:   Fri, 1 Oct 2021 13:50:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>, llvm@lists.linux.dev
Subject: Re: [v2 PATCH] crypto: api - Fix built-in testing dependency failures
Message-ID: <20211001055058.GA6081@gondor.apana.org.au>
References: <20210913071251.GA15235@gondor.apana.org.au>
 <20210917002619.GA6407@gondor.apana.org.au>
 <YVNfqUVJ7w4Z3WXK@archlinux-ax161>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVNfqUVJ7w4Z3WXK@archlinux-ax161>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 28, 2021 at 11:32:09AM -0700, Nathan Chancellor wrote:
>
> This patch as commit 3cefb01905df ("crypto: api - Fix built-in testing
> dependency failures") in -next (along with the follow up fix) causes the
> following depmod error:
> 
> $ make -skj"$(nproc)" ARCH=powerpc CROSS_COMPILE=powerpc-linux- INSTALL_MOD_PATH=rootfs ppc44x_defconfig all modules_install
> depmod: ERROR: Cycle detected: crypto -> crypto_algapi -> crypto
> depmod: ERROR: Found 2 modules in dependency cycles!
> make: *** [Makefile:1946: modules_install] Error 1
> 
> Initially reported on our CI:
> 
> https://github.com/ClangBuiltLinux/continuous-integration2/runs/3732847295?check_suite_focus=true

That's weird, I can't reproduce this.  Where can I find your Kconfig
file? Alternatively, can you identify exactly what is in algapi that
is being depended on by crypto?

The crypto module should be at the very base and there should be no
depenedencies from it on algapi.  The algapi module is meant to be
on top of crypto obviously.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
