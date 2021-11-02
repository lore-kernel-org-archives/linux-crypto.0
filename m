Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F939C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 04:01:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F27F360EBC
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 04:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhKBEE0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Nov 2021 00:04:26 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56460 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229566AbhKBEEZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Nov 2021 00:04:25 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mhkza-0004yC-Tu; Tue, 02 Nov 2021 12:01:46 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mhkzX-00067B-KK; Tue, 02 Nov 2021 12:01:43 +0800
Date:   Tue, 2 Nov 2021 12:01:43 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Denys Vlasenko <dvlasenk@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: Re: [GIT PULL] Crypto Fixes for 5.15
Message-ID: <20211102040143.GB23420@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au>
 <20200830223304.GA16882@gondor.apana.org.au>
 <20201026011159.GA2428@gondor.apana.org.au>
 <20201227113221.GA28744@gondor.apana.org.au>
 <20210108035450.GA6191@gondor.apana.org.au>
 <20210708030913.GA32097@gondor.apana.org.au>
 <20210817013601.GA14148@gondor.apana.org.au>
 <20210929023843.GA28594@gondor.apana.org.au>
 <20211029041408.GA3192@gondor.apana.org.au>
 <CAHk-=whEFkHvtecaUF5MEZMxW_UVUMn-bLmfAhcvx4t9Qia90A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whEFkHvtecaUF5MEZMxW_UVUMn-bLmfAhcvx4t9Qia90A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 29, 2021 at 10:39:35AM -0700, Linus Torvalds wrote:
>
> Plus, I get the feeling that some people have just copied-and-pasted
> those things, and don't necessarily realize just _how_ subtle 'M'
> sections are.
> 
> How much of a data savings is it to have this complexity? Particularly
> since I suspect most of the time these things end up being individual
> modules, and never actually get linked together at all?

Let me copy Denys Vlasenko who introduced this.

But you're absolutely right that the recent additions are
more likely to be just cut-n-paste rather than deeply thought
through.

FWIW the original change that added this was:

ommit e183914af00e15eb41ae666d44e323bfa154be13
Author: Denys Vlasenko <dvlasenk@redhat.com>
Date:   Thu Jan 19 22:33:04 2017 +0100

    crypto: x86 - make constants readonly, allow linker to merge them

    A lot of asm-optimized routines in arch/x86/crypto/ keep its
    constants in .data. This is wrong, they should be on .rodata.

    Mnay of these constants are the same in different modules.
    For example, 128-bit shuffle mask 0x000102030405060708090A0B0C0D0E0F
    exists in at least half a dozen places.

    There is a way to let linker merge them and use just one copy.
    The rules are as follows: mergeable objects of different sizes
    should not share sections. You can't put them all in one .rodata
    section, they will lose "mergeability".

    GCC puts its mergeable constants in ".rodata.cstSIZE" sections,
    or ".rodata.cstSIZE.<object_name>" if -fdata-sections is used.
    This patch does the same:

            .section .rodata.cst16.SHUF_MASK, "aM", @progbits, 16

    It is important that all data in such section consists of
    16-byte elements, not larger ones, and there are no implicit
    use of one element from another.

    When this is not the case, use non-mergeable section:

            .section .rodata[.VAR_NAME], "a", @progbits

    This reduces .data by ~15 kbytes:

        text    data     bss     dec      hex filename
    11097415 2705840 2630712 16433967  fac32f vmlinux-prev.o
    11112095 2690672 2630712 16433479  fac147 vmlinux.o

    Merged objects are visible in System.map:

    ffffffff81a28810 r POLY
    ffffffff81a28810 r POLY
    ffffffff81a28820 r TWOONE
    ffffffff81a28820 r TWOONE
    ffffffff81a28830 r PSHUFFLE_BYTE_FLIP_MASK <- merged regardless of
    ffffffff81a28830 r SHUF_MASK   <------------- the name difference
    ffffffff81a28830 r SHUF_MASK
    ffffffff81a28830 r SHUF_MASK
    ..
    ffffffff81a28d00 r K512 <- merged three identical 640-byte tables
    ffffffff81a28d00 r K512
    ffffffff81a28d00 r K512

    Use of object names in section name suffixes is not strictly necessary,
    but might help if someday link stage will use garbage collection
    to eliminate unused sections (ld --gc-sections).

    Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
    CC: Herbert Xu <herbert@gondor.apana.org.au>
    CC: Josh Poimboeuf <jpoimboe@redhat.com>
    CC: Xiaodong Liu <xiaodong.liu@intel.com>
    CC: Megha Dey <megha.dey@intel.com>
    CC: linux-crypto@vger.kernel.org
    CC: x86@kernel.org
    CC: linux-kernel@vger.kernel.org
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
