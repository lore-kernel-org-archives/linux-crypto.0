Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62987C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Mar 2022 04:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiCYEZA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Mar 2022 00:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358203AbiCYEYx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Mar 2022 00:24:53 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB1F39696;
        Thu, 24 Mar 2022 21:23:19 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nXbTW-0003WZ-CO; Fri, 25 Mar 2022 15:22:59 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Mar 2022 16:22:58 +1200
Date:   Fri, 25 Mar 2022 16:22:58 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, ebiggers@google.com, Jason@zx2c4.com,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH 3/2] x86/poly1305: Fixup SLS
Message-ID: <Yj1DorXraB6uhnjF@gondor.apana.org.au>
References: <20220322114809.381992456@infradead.org>
 <20220323230555.GZ8939@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323230555.GZ8939@worktop.programming.kicks-ass.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 24, 2022 at 12:05:55AM +0100, Peter Zijlstra wrote:
> 
> Due to being a perl generated asm file, it got missed by the mass
> convertion script.
> 
> arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_init_x86_64()+0x3a: missing int3 after ret
> arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_blocks_x86_64()+0xf2: missing int3 after ret
> arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_emit_x86_64()+0x37: missing int3 after ret
> arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: __poly1305_block()+0x6d: missing int3 after ret
> arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: __poly1305_init_avx()+0x1e8: missing int3 after ret
> arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_blocks_avx()+0x18a: missing int3 after ret
> arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_blocks_avx()+0xaf8: missing int3 after ret
> arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_emit_avx()+0x99: missing int3 after ret
> arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_blocks_avx2()+0x18a: missing int3 after ret
> arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_blocks_avx2()+0x776: missing int3 after ret
> arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_blocks_avx512()+0x18a: missing int3 after ret
> arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_blocks_avx512()+0x796: missing int3 after ret
> arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_blocks_avx512()+0x10bd: missing int3 after ret
> 
> Fixes: f94909ceb1ed ("x86: Prepare asm files for straight-line-speculation")
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  arch/x86/crypto/poly1305-x86_64-cryptogams.pl |   38 +++++++++++++-------------
>  1 file changed, 19 insertions(+), 19 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
