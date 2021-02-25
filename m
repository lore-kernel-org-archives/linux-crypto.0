Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFACC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 09:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D80164EC3
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 09:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbhBYJsN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Feb 2021 04:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbhBYJsM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Feb 2021 04:48:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199C0C06174A;
        Thu, 25 Feb 2021 01:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HURRimf/rjBeqsWwOvbXeNiLX7bq1D1hp76NynxPQvc=; b=T09LrmP8vyGWSLC1HLbvVl5x/J
        cCZklA50HCSlRki+7Je/QGQn7a09AhXLb0TyOU1Fxrn3R1w8XBVj3s+SxghpfOBQfYUowYpk/U9JT
        UDClKh2WZQ+KlRoUSL+9zo1Gspn2mBHjGLerfawgTR5xdz4A9MqfTqoqcn/gbp52Wk2nIzf9Hr6wi
        iFeDPjsr+zaBB2ajCjODKKklATwR3WBxDO2i4jwjCbm1WgtEsE82q6ABaNoMArNq/WKqtfGZwbPQf
        L6vXQ2PMk3QEQqM7DW8aJxb6SX/MBlVJyPKpjd+ICYtR8H5hu3mNSYPN8EF/hzruqH6WoKbEouzG1
        rrOif4sw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFDEX-00AXQw-Uo; Thu, 25 Feb 2021 09:47:01 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 078983006D0;
        Thu, 25 Feb 2021 10:46:57 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E4B0120BC92B4; Thu, 25 Feb 2021 10:46:56 +0100 (CET)
Date:   Thu, 25 Feb 2021 10:46:56 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     x86@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/13] x86/crypto/asm: objtool support
Message-ID: <YDdyEKqDEKmdg9yW@hirez.programming.kicks-ass.net>
References: <cover.1614182415.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1614182415.git.jpoimboe@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 24, 2021 at 10:29:13AM -0600, Josh Poimboeuf wrote:
> Standardize the crypto asm to make it resemble compiler-generated code,
> so that objtool can understand it.
> 
> This magically enables ORC unwinding from crypto code.  It also fixes
> the last known remaining objtool warnings on vmlinux.o, for LTO and
> more.
> 
> Josh Poimboeuf (13):
>   objtool: Support asm jump tables
>   x86/crypto/aesni-intel_avx: Remove unused macros
>   x86/crypto/aesni-intel_avx: Fix register usage comments
>   x86/crypto/aesni-intel_avx: Standardize stack alignment prologue
>   x86/crypto/camellia-aesni-avx2: Unconditionally allocate stack buffer
>   x86/crypto/crc32c-pcl-intel: Standardize jump table
>   x86/crypto/sha_ni: Standardize stack alignment prologue
>   x86/crypto/sha1_avx2: Standardize stack alignment prologue
>   x86/crypto/sha256-avx2: Standardize stack alignment prologue
>   x86/crypto/sha512-avx: Standardize stack alignment prologue
>   x86/crypto/sha512-avx2: Standardize stack alignment prologue
>   x86/crypto/sha512-ssse3: Standardize stack alignment prologue
>   x86/crypto: Enable objtool in crypto code
> 
>  arch/x86/crypto/Makefile                     |  2 -
>  arch/x86/crypto/aesni-intel_avx-x86_64.S     | 28 +++++--------
>  arch/x86/crypto/camellia-aesni-avx2-asm_64.S |  5 +--
>  arch/x86/crypto/crc32c-pcl-intel-asm_64.S    |  7 +---
>  arch/x86/crypto/sha1_avx2_x86_64_asm.S       |  8 ++--
>  arch/x86/crypto/sha1_ni_asm.S                |  8 ++--
>  arch/x86/crypto/sha256-avx2-asm.S            | 13 +++---
>  arch/x86/crypto/sha512-avx-asm.S             | 41 +++++++++----------
>  arch/x86/crypto/sha512-avx2-asm.S            | 42 ++++++++++----------
>  arch/x86/crypto/sha512-ssse3-asm.S           | 41 +++++++++----------
>  tools/objtool/check.c                        | 14 ++++++-
>  11 files changed, 98 insertions(+), 111 deletions(-)

One nit, there's lots and lots of:

	mov %rbp, %rsp
	pop %rbp

and we have this 'leave' instruction that does exactly that, should we
be using it?

Otherwise:

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
