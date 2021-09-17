Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B42C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 03:19:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB96A60F8F
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 03:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243788AbhIQDUW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Sep 2021 23:20:22 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55238 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243721AbhIQDUW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Sep 2021 23:20:22 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mR4Or-000695-Op; Fri, 17 Sep 2021 11:18:53 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mR4Oq-0001jI-1W; Fri, 17 Sep 2021 11:18:52 +0800
Date:   Fri, 17 Sep 2021 11:18:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, llvm@lists.linux.dev
Subject: Re: [PATCH] crypto: sm4 - Do not change section of ck and sbox
Message-ID: <20210917031851.GB6559@gondor.apana.org.au>
References: <20210825203859.416449-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825203859.416449-1-nathan@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 25, 2021 at 01:38:59PM -0700, Nathan Chancellor wrote:
> When building with clang and GNU as, there is a warning about ignored
> changed section attributes:
> 
> /tmp/sm4-c916c8.s: Assembler messages:
> /tmp/sm4-c916c8.s:677: Warning: ignoring changed section attributes for
> .data..cacheline_aligned
> 
> "static const" places the data in .rodata but __cacheline_aligned has
> the section attribute to place it in .data..cacheline_aligned, in
> addition to the aligned attribute.
> 
> To keep the alignment but avoid attempting to change sections, use the
> ____cacheline_aligned attribute, which is just the aligned attribute.
> 
> Fixes: 2b31277af577 ("crypto: sm4 - create SM4 library based on sm4 generic code")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1441
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  lib/crypto/sm4.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
