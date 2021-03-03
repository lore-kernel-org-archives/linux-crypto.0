Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA55DC15502
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF52B64F4F
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239795AbhCDAHP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:07:15 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37046 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241156AbhCCK1S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Mar 2021 05:27:18 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lHN9r-0000F8-KV; Wed, 03 Mar 2021 19:47:04 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 03 Mar 2021 19:47:03 +1100
Date:   Wed, 3 Mar 2021 19:47:03 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/13] x86/crypto/asm: objtool support
Message-ID: <20210303084703.GB8036@gondor.apana.org.au>
References: <cover.1614182415.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1614182415.git.jpoimboe@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
