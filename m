Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E1CC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Oct 2021 12:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C0B96108D
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Oct 2021 12:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhJVMjJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Oct 2021 08:39:09 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56246 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231473AbhJVMjE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Oct 2021 08:39:04 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mdtmR-00030v-LC; Fri, 22 Oct 2021 20:36:15 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mdtmK-0001o2-4u; Fri, 22 Oct 2021 20:36:08 +0800
Date:   Fri, 22 Oct 2021 20:36:08 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Heyuan Shi <heyuan@linux.alibaba.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: x86/sm4 - Fix invalid section entry size
Message-ID: <20211022123608.GA6920@gondor.apana.org.au>
References: <20211015034733.51205-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015034733.51205-1-tianjia.zhang@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 15, 2021 at 11:47:33AM +0800, Tianjia Zhang wrote:
> This fixes the following warning:
> 
>   vmlinux.o: warning: objtool: elf_update: invalid section entry size
> 
> The size of the rodata section is 164 bytes, directly using the
> entry_size of 164 bytes will cause errors in some versions of the
> gcc compiler, while using 16 bytes directly will cause errors in
> the clang compiler. This patch correct it by filling the size of
> rodata to a 16-byte boundary.
> 
> Fixes: a7ee22ee1445 ("crypto: x86/sm4 - add AES-NI/AVX/x86_64 implementation")
> Fixes: 5b2efa2bb865 ("crypto: x86/sm4 - add AES-NI/AVX2/x86_64 implementation")
> Reported-by: Peter Zijlstra <peterz@infradead.org>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> Tested-by: Heyuan Shi <heyuan@linux.alibaba.com>
> ---
>  arch/x86/crypto/sm4-aesni-avx-asm_64.S  | 6 +++++-
>  arch/x86/crypto/sm4-aesni-avx2-asm_64.S | 6 +++++-
>  2 files changed, 10 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
