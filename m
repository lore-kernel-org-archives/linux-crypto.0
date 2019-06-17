Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C15CC31E5D
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 18:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 619EF208C4
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 18:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560795782;
	bh=qV75+HHF0tyoMwQTIa7ewndX/1kvxlqxzUpwV/VWlfA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=K7wjF0mEWf5/nWcEeleH4CqIU3fuU/AtOBfkiZMQKf/lE717bQneBn36F0MHPVLtp
	 9jRV9Cqy9xXBdQR6SlFSEI+M7dvcenHCwojB/W8wemv8/XOdcDehxmqFk9I/fMs4vL
	 2USuVR3GDJODcUg7axDaDw2V5Ukex3Qy6VO/qFNk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbfFQSXB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 14:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbfFQSXB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 14:23:01 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 786432084D;
        Mon, 17 Jun 2019 18:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560795779;
        bh=qV75+HHF0tyoMwQTIa7ewndX/1kvxlqxzUpwV/VWlfA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vuYrcUY26U0i1F1ZABfYZNwvLuMC2DD+FIF1Gvt0y0qc8n0wL+8pksifRQzx6eT0T
         5FoUOX7ClJaYyc1kt9TdmFU/0PUsWjrvpydlG5bEEuxEhcY9tp8yguQpXxpd7gDfbK
         CzOU72IYcXnAf1T+zj7et3KvNB+etwSTWxRgvQbM=
Date:   Mon, 17 Jun 2019 11:22:57 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sedat Dilek <sedat.dilek@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Fangrui Song <maskray@google.com>,
        Peter Smith <peter.smith@linaro.org>
Subject: Re: crypto: x86/crct10dif-pcl - cleanup and optimizations
Message-ID: <20190617182256.GB92263@gmail.com>
References: <CA+icZUX3EOhrUp0Afbo_fK9rb5AbXjbaBFwhj1qmBaHom1b3MA@mail.gmail.com>
 <CAKwvOdn8Za1Dy4QgdDZu1My5oYLJJzyRqYsq+XkpRpnViC6aKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdn8Za1Dy4QgdDZu1My5oYLJJzyRqYsq+XkpRpnViC6aKQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 17, 2019 at 11:06:21AM -0700, Nick Desaulniers wrote:
> On Mon, Jun 17, 2019 at 6:35 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >
> > Hi,
> >
> > while digging through a ClangBuiltLinux issue when linking with LLD
> > linker on x86-64 I checked the settings for...
> >
> > .rodata.cst16 and .rodata.cst32
> >
> > ...in crypto tree and fell over this change in...
> >
> > commit "crypto: x86/crct10dif-pcl - cleanup and optimizations":
> >
> > -.section .rodata.cst16.SHUF_MASK, "aM", @progbits, 16
> > +.section .rodata.cst32.byteshift_table, "aM", @progbits, 32
> > .align 16
> >
> > Is that a typo?
> > I would have expected...
> > .rodata.cst32.XXX -> .align 32
> > or
> > rodata.cst16.XXX -> .align 16
> >
> > But I might be wrong as I am no expert for crypto and x86/asm.
> >
> > Thanks in advance.
> >
> > Regards,
> > - Sedat -
> >
> > [1] https://github.com/ClangBuiltLinux/linux/issues/431
> > [2] https://bugs.llvm.org/show_bug.cgi?id=42289
> 
> > [3] https://git.kernel.org/linus/0974037fc55c
> 
> + Peter, Fangrui (who have looked at this, and started looking into
> this from LLD's perspective)
> 
> In fact, looking closer at that diff, the section in question
> previously had 32b alignment.  Eric, was that change intentional?  It
> seems funny to have a 32b entity size but a 16b alignment.
> 
> PDF page 81 / printed page 67 of this doc:
> https://web.eecs.umich.edu/~prabal/teaching/resources/eecs373/Assembler.pdf
> says:
> 
> "The linker may remove duplicates within sections with the
> same name, same entity size and same flags. "
> 
> So for us, LLD is NOT merging these sections due to differing
> alignments, which is producing warnings when loading such kernel
> modules that link against these object files.
> -- 
> Thanks,
> ~Nick Desaulniers

It was an intentional change since actually no alignment is required for this.
It's an array of 32 bytes and the code loads 16 bytes starting from some byte
offset in the range 1...16, so it has to use movdqu anyway.

There's no problem with changing it back to 32, but I don't fully understand
what's going on here.  Where is it documented how alignment specifiers interact
with the section merging?  Also, there are already other mergeable sections in
the x86 crypto code with alignment smaller than their entity size, e.g.

	.rodata.cst16.aegis128_const
	.rodata.cst16.aegis128l_const
	.rodata.cst16.aegis256_const
	.rodata.cst16.morus640_const
	.rodata.cst256.K256

Do those need to be changed too?

- Eric
