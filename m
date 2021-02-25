Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08AC5C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 09:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA53E64EDC
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 09:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhBYJnI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Feb 2021 04:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234107AbhBYJmi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Feb 2021 04:42:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AA6C061793;
        Thu, 25 Feb 2021 01:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2r8qTWCQuEAeQqk6EF6ekYZa+LRQpOnq8QiY31W/zA4=; b=PGIQVeqlTsjn8OCEcdTziCcyIB
        /7/qqI0p+RJJuAikuzXWsW2yFyGB1LCyvt/IyWJUdPzuR0YP/wHShezLq0yHpCTK96IQ2o5VGqUC+
        Xn8ebk1tvFBEugxYldRHqgtiYDuKKn3kqiyCrsd6P2As7DpdYFJMs9RxcloU1MIptblNNTEMH6IVf
        Z5nvP/99ja1TmUOfg/PAmibgg8rSOBghLFV449VIKjy+++iU4KjocoGzjEc6q3i9WzHaFgFuwamLy
        RTgOd0heoXK+kFUwErTNN9DFeUrxxYarVw74Q5b+dUCfY+1osuZGxHKH6pz32kBAR50n346SF9MN6
        yDx79NYA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFD6j-00AWyD-IP; Thu, 25 Feb 2021 09:38:56 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 349733010D2;
        Thu, 25 Feb 2021 10:38:51 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DB22B20BC92B4; Thu, 25 Feb 2021 10:38:51 +0100 (CET)
Date:   Thu, 25 Feb 2021 10:38:51 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     x86@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 04/13] x86/crypto/aesni-intel_avx: Standardize stack
 alignment prologue
Message-ID: <YDdwK8aPnc6X9WTB@hirez.programming.kicks-ass.net>
References: <cover.1614182415.git.jpoimboe@redhat.com>
 <02d00a0903a0959f4787e186e2a07d271e1f63d4.1614182415.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02d00a0903a0959f4787e186e2a07d271e1f63d4.1614182415.git.jpoimboe@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 24, 2021 at 10:29:17AM -0600, Josh Poimboeuf wrote:
> Use RBP instead of R14 for saving the old stack pointer before
> realignment.  This resembles what compilers normally do.
> 
> This enables ORC unwinding by allowing objtool to understand the stack
> realignment.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> ---
>  arch/x86/crypto/aesni-intel_avx-x86_64.S | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aesni-intel_avx-x86_64.S
> index 188f1848a730..98e3552b6e03 100644
> --- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
> +++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
> @@ -251,22 +251,20 @@ VARIABLE_OFFSET = 16*8
>  .macro FUNC_SAVE
>          push    %r12
>          push    %r13
> -        push    %r14
>          push    %r15
>  
> -        mov     %rsp, %r14
> -
> -
> +	push	%rbp
> +	mov	%rsp, %rbp
>  
>          sub     $VARIABLE_OFFSET, %rsp
>          and     $~63, %rsp                    # align rsp to 64 bytes
>  .endm
>  
>  .macro FUNC_RESTORE
> -        mov     %r14, %rsp
> +        mov     %rbp, %rsp
> +	pop	%rbp
>  
>          pop     %r15
> -        pop     %r14
>          pop     %r13
>          pop     %r12
>  .endm

Urgh, I was about to say your patch is whitespace damaged, but it's the
original file :-/
