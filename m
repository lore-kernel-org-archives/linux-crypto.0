Return-Path: <SRS0=C5lZ=DN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9361AC41604
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Oct 2020 09:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25CA52080A
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Oct 2020 09:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601977850;
	bh=PeSuqk/VTDEBoJqvvMEQqoW1Xu2MaaV6ZO1NmFYY/kw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=RX3A8RXKyTtwXVBckAVN673iR5NGYsZmEjxJkf3DRwL63bZvqTG5v5UGrYh1FCt/L
	 68mLE7zmc+Xad6ktLB0MoMqyNXIhmgZ17XaJ42vZpuDMuynoBcfnI+lybvvgSfC9fT
	 bBCJ+uFxOOwGJ5VcaWYvCbT5MNl2gAwgOCrApJQo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgJFJut (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Oct 2020 05:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgJFJut (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Oct 2020 05:50:49 -0400
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 914852080A;
        Tue,  6 Oct 2020 09:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601977848;
        bh=PeSuqk/VTDEBoJqvvMEQqoW1Xu2MaaV6ZO1NmFYY/kw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NEMirvyv6rsJ5s455o1dpjT1Vjx+M2kXvbXTeVrHWhjFRAvhXB3uxg9F+40YqOQlJ
         xXBNGuieCh82T2WSNKT7Svuu4U6KyQCI/rzPdd10RdyCQcgxm4I7y85L/wEdpKJVo+
         qI+jJeETZMN1hsbWgzRvxLVTADUqzqbCqPr5bg8g=
Received: by mail-oi1-f174.google.com with SMTP id m128so11976720oig.7;
        Tue, 06 Oct 2020 02:50:48 -0700 (PDT)
X-Gm-Message-State: AOAM531GzzmZm7MS3tKzsrB+qc6fiOekSkOhF42RcOOaTmaFBbRnuuKn
        Yjgdfv0QqfD7hi2x44E5VESiuAocDWsrwXnyPc0=
X-Google-Smtp-Source: ABdhPJxBEeiiBphMyrQIZMyEkkAqAtMZ88OEGyAIKH5mqqzSYj9oMaI+RhIeIxd8TdMqbKl+i3qDOQZdwB+1ZCXT2OI=
X-Received: by 2002:a05:6808:8e5:: with SMTP id d5mr2231046oic.33.1601977847799;
 Tue, 06 Oct 2020 02:50:47 -0700 (PDT)
MIME-Version: 1.0
References: <20201005181804.1331237-1-jeremy.linton@arm.com>
 <CAMj1kXEkrRvp5Xd_+D_V7Nr1uiKnfAEdZU4kciC5R7_H8aRNZA@mail.gmail.com>
 <c7959ca7-5212-0dfb-2ebc-6247083d356b@arm.com> <20201006093817.GV6642@arm.com>
In-Reply-To: <20201006093817.GV6642@arm.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 6 Oct 2020 11:50:36 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFQYeiwouX7uWHp29QRySkOU6XnP7tdvXseDhYqJEOUeg@mail.gmail.com>
Message-ID: <CAMj1kXFQYeiwouX7uWHp29QRySkOU6XnP7tdvXseDhYqJEOUeg@mail.gmail.com>
Subject: Re: [BUG][PATCH] arm64: bti: fix BTI to handle local indirect branches
To:     Dave Martin <Dave.Martin@arm.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 6 Oct 2020 at 11:38, Dave Martin <Dave.Martin@arm.com> wrote:
>
> On Mon, Oct 05, 2020 at 02:24:47PM -0500, Jeremy Linton wrote:
> > Hi,
> >
> > On 10/5/20 1:54 PM, Ard Biesheuvel wrote:
> > >On Mon, 5 Oct 2020 at 20:18, Jeremy Linton <jeremy.linton@arm.com> wrote:
> > >>
> > >>The AES code uses a 'br x7' as part of a function called by
> > >>a macro, that ends up needing a BTI_J as a target.
> > >
> > >Could we instead just drop the tail call, i.e, replace it with a ret
> > >and do a 'bl' after it returns? The indirect call does not really
> > >serve a purpose here anyway
> >
> > Yes, that is an option, it adds an extra ret. Which probably doesn't mean
> > much in most cases. I assumed this code was optimized this way because it
> > mattered somewhere.
>
> Since this really does seem to be a tail-call and since x16 and x17
> appear to be otherwise unused here, can we not just use x16 or x17
> instead of x7?
>
> This relies on there being no other calls to veneered functions in the
> mix, but this code is all in a single section so that shouldn't be a
> concern.
>
> Due to the magic status of x16 and x17 in br instructions, the resulting
> jump should be compatible with BTI c.  I think this matches how the
> compiler should typically compile tail-calls.
>

Ah, excellent point. That is definitely the cleanest fix.
