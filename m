Return-Path: <SRS0=iDha=6J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA30CC55185
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Apr 2020 23:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B482920672
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Apr 2020 23:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgDYXvR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 25 Apr 2020 19:51:17 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:49329 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbgDYXvQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Apr 2020 19:51:16 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 498nqk5LQ7z9sRf; Sun, 26 Apr 2020 09:51:14 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 5990cdee689c6885b27c6d969a3d58b09002b0bc
In-Reply-To: <20200413195041.24064-1-natechancellor@gmail.com>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     kbuild test robot <lkp@intel.com>, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Paul Mackerras <paulus@samba.org>,
        linux-crypto@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] lib/mpi: Fix building for powerpc with clang
Message-Id: <498nqk5LQ7z9sRf@ozlabs.org>
Date:   Sun, 26 Apr 2020 09:51:14 +1000 (AEST)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 2020-04-13 at 19:50:42 UTC, Nathan Chancellor wrote:
> 0day reports over and over on an powerpc randconfig with clang:
> 
> lib/mpi/generic_mpih-mul1.c:37:13: error: invalid use of a cast in a
> inline asm context requiring an l-value: remove the cast or build with
> -fheinous-gnu-extensions
> 
> Remove the superfluous casts, which have been done previously for x86
> and arm32 in commit dea632cadd12 ("lib/mpi: fix build with clang") and
> commit 7b7c1df2883d ("lib/mpi/longlong.h: fix building with 32-bit
> x86").
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/991
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied to powerpc fixes, thanks.

https://git.kernel.org/powerpc/c/5990cdee689c6885b27c6d969a3d58b09002b0bc

cheers
