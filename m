Return-Path: <SRS0=6fPk=5K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D0F8C43331
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 11:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E41F20772
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 11:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585137264;
	bh=LsL/hiN8iiqHayL/ck0O9zj6iDVzDf7dcqjIdEwdZqQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ZT13FYdvuNBr2QdWcgQQX4UH8A9XbH58befzvP052+dSr8DJFTrMi4Iqhi1O7DVXE
	 tqmMCTuWEgUEGRngstZzGJZRyPrirYTonDftabnWGm6aAPiH9RtlOsS842PuQXAPtU
	 4t1akBCIkccUR1uE2enCZn1zxxq5dml2rlgkD+BI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgCYLyX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Mar 2020 07:54:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726313AbgCYLyX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Mar 2020 07:54:23 -0400
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1604520772
        for <linux-crypto@vger.kernel.org>; Wed, 25 Mar 2020 11:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585137263;
        bh=LsL/hiN8iiqHayL/ck0O9zj6iDVzDf7dcqjIdEwdZqQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PE9FUWtRuQSZhE5ocuFjx2Bv9DJIydfmHEidt4iwqV6cVGhanxkwoCeIE+FH7ak42
         m9u+qZBXRltqGbjRtjA9yJE88P1Qa8LlgQK0yqD0BW5phl0hMqktR/MYR+gLhYMjji
         PE0FD31ya5y6pWAZFdIITicWONxuWcdSZXnArfAg=
Received: by mail-io1-f46.google.com with SMTP id h8so1921215iob.2
        for <linux-crypto@vger.kernel.org>; Wed, 25 Mar 2020 04:54:23 -0700 (PDT)
X-Gm-Message-State: ANhLgQ1er0zCo2/veY2FyZNAqDC/5vHvwH+B5vCCicuXeKMpP7/PGWDv
        fXS8JKxSd1FRn2qUyCqki2xjyZhBu/IusGRYOiQ=
X-Google-Smtp-Source: ADFU+vt4xC5mw0oM26Ews4opw4C+CNEm8+d+DQty6FNcE/yLrCg1vbftwwIbsJHR4LmOMTpfmZ2QxEYzEvXvlRT1M+o=
X-Received: by 2002:a5d:980f:: with SMTP id a15mr2470032iol.203.1585137262516;
 Wed, 25 Mar 2020 04:54:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200325114110.23491-1-broonie@kernel.org> <CAMj1kXH=g5N4ZtnZeX5N8hf9cnWVam4Htnov6qAmQwD58Wp73Q@mail.gmail.com>
 <20200325115038.GD4346@sirena.org.uk>
In-Reply-To: <20200325115038.GD4346@sirena.org.uk>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 25 Mar 2020 12:54:10 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEogCrLS1o9sQyiXsKZhykfc2kuOssCeME8HyhSnMEFvA@mail.gmail.com>
Message-ID: <CAMj1kXEogCrLS1o9sQyiXsKZhykfc2kuOssCeME8HyhSnMEFvA@mail.gmail.com>
Subject: Re: [PATCH 0/3] arm64: Open code .arch_extension
To:     Mark Brown <broonie@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 25 Mar 2020 at 12:50, Mark Brown <broonie@kernel.org> wrote:
>
> On Wed, Mar 25, 2020 at 12:45:11PM +0100, Ard Biesheuvel wrote:
>
> > I don't think this is the right fix. What is wrong with keeping these
> > .cpu and .arch directives in the .S files, and simply make
> > SYM_FUNC_START() expand to something that includes .arch_extension pac
> > or .arch_extension bti when needed? That way, we only use
> > .arch_extension when we know the assembler supports it (given that
> > .arch_extension support itself should predate BTI or PAC support in
> > GAS or Clang)
>
> Since BTI is a mandatory feature of v8.5 there is no BTI arch_extension,
> you can only enable it by moving the base architecture to v8.5.  You'd
> need to use .arch and that feels likely to find us sharp edges to run
> into.

I think we should talk to the toolchain folks about this. Even if
.arch_extension today does not support the 'bti' argument, it *is*
most definitely an architecture extension, even it it is mandatory in
v8.5 (given that v8.5 is itself an architecture extension).
