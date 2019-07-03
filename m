Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B545DC06513
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 16:15:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AB22218A0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 16:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562170501;
	bh=teE3VF+r2gEAdO7AE/iYCU7y2y5tlqdZ7l8i0yKOIPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=X2QPdMyPqhYbz2NsjO0fJoUeBsv/cwzLQGXRKIxVBAah48muiCODUHYbLuwn6SkOS
	 8aV0tI1fcqOWgUvhL5BRaCCfh59vZ8qwdNYYDOzd5ww1H2ejMcRdsSdtHFt74Ci30+
	 JfFNCwmUlqqh8Hbcfeqyi4R0uvwfymUL9Vytg920=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfGCQPA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 12:15:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727011AbfGCQO7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 12:14:59 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C38B21882;
        Wed,  3 Jul 2019 16:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562170498;
        bh=teE3VF+r2gEAdO7AE/iYCU7y2y5tlqdZ7l8i0yKOIPc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gWocQ9FlqhmMmx01IHs1ayLjCFq3vVMgpFJyU3uc0McJent02zZZ1vNQAynOIrVsV
         XJKS8z3K5AMYj87RBtDOzk+I3iuILpmIZRdBu4p41gmw/k9Scz5rnQgtq0Hktd2Dei
         AyK8/HzlGzY8hfrxxbwImhcGvRBN2fNSYBp4HRG0=
Date:   Wed, 3 Jul 2019 09:14:56 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Fangrui Song <maskray@google.com>,
        Peter Smith <peter.smith@linaro.org>
Subject: Re: crypto: x86/crct10dif-pcl - cleanup and optimizations
Message-ID: <20190703161456.GC21629@sol.localdomain>
References: <CA+icZUX3EOhrUp0Afbo_fK9rb5AbXjbaBFwhj1qmBaHom1b3MA@mail.gmail.com>
 <CAKwvOdn8Za1Dy4QgdDZu1My5oYLJJzyRqYsq+XkpRpnViC6aKQ@mail.gmail.com>
 <20190617182256.GB92263@gmail.com>
 <CA+icZUV8693G8jgHw2t9qUay4_Ad-7BgNOkL6z+4z8xNXyL=cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUV8693G8jgHw2t9qUay4_Ad-7BgNOkL6z+4z8xNXyL=cA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Sedat,

On Wed, Jul 03, 2019 at 05:16:40PM +0200, Sedat Dilek wrote:
> 
> Hi Eric, Hi Nick,
> 
> I am building Linux v5.1.16 with a new llvm-toolchain including the fix for LLD:
> 
> "[ELF] Allow placing SHF_MERGE sections with different alignments into
> the same MergeSyntheticSection"
> 
> [ Alignment=16 before my patch ]
> 
> $ cd arch/x86/crypto/
> $ for o in $(ls *.o) ; do echo [ $o ] ; readelf -WS $o | grep
> rodata\.cst32 ; done
> 
> [ crct10dif-pcl-asm_64.o ]
>   [ 9] .rodata.cst32.byteshift_table PROGBITS        0000000000000000
> 0004e0 000020 20  AM  0   0 16
> 
> [ crct10dif-pclmul.o ]
>   [ 9] .rodata.cst32.byteshift_table PROGBITS        0000000000000000
> 000b40 000020 20  AM  0   0 16
> 
> [ Alignment=32 after my patch ]
> 
> [ crct10dif-pcl-asm_64.o ]
>   [ 9] .rodata.cst32.byteshift_table PROGBITS        0000000000000000
> 0004e0 000020 20  AM  0   0 32
> 
> [ crct10dif-pclmul.o ]
>   [ 9] .rodata.cst32.byteshift_table PROGBITS        0000000000000000
> 000b40 000020 20  AM  0   0 32
> 
> I am still building the Linux-kernel but first checks in [3] looks good.
> 
> I can send out a separate patch if you like for the issue I have reported.

Sorry, I am still confused.  Are you saying that something still needs to be
fixed in the kernel code, and if so, why?  To reiterate, the byteshift_table
doesn't actually *need* any particular alignment.  Would it avoid the confusion
if I changed it to no alignment?  Or is there some section merging related
reason it actually needs to be 32?

> 
> I can not say much to ...
> 
> >         .rodata.cst16.aegis128_const
> >         .rodata.cst16.aegis128l_const
> >         .rodata.cst16.aegis256_const
> >         .rodata.cst16.morus640_const
> >         .rodata.cst256.K256
> 
> ... as I am not a Linker or Linux/x86/crypto specialist.

Well those all seem to be the same issue; the needed alignment isn't the same as
the entity size.  So if the crct10dif one needs to be fixed, these need to be
too.  Am I missing something?

- Eric
