Return-Path: <SRS0=kwSW=SM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D3F3C282CE
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 18:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2207F20830
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 18:31:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ChsrIjTR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731564AbfDJSbM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Apr 2019 14:31:12 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:36786 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731527AbfDJSbL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Apr 2019 14:31:11 -0400
Received: by mail-ua1-f67.google.com with SMTP id k32so1128638uae.3
        for <linux-crypto@vger.kernel.org>; Wed, 10 Apr 2019 11:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HZrouuH6qDcbcN0Xir61EX//r5Pvf+jE6u/Bex0vtPA=;
        b=ChsrIjTR2XUXY98NFeP4EYidlDto2ZP21YpmNICKQthef5L3chA1evffBlGc7f5Cpd
         AVLdt06zVihsEe31IHJ9/S+3AZeljeUHUhTc1c2zEZwWOWJ77/kz5jXchKIL0j3RJt7Z
         q8y86gbdDx/7EpkMgNN0PhF3sbVnMJ0w/ySFg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HZrouuH6qDcbcN0Xir61EX//r5Pvf+jE6u/Bex0vtPA=;
        b=qBRmIJ7BpgKwYHHNGeo/XJjjDXbS10CNvgmHZ217vGvU651+S8sJSx9fppGZGw64r4
         ZYeAuWb2fvttMbZ9a04HMBkvpaW/XMvv8SY5UztUgnxOB2OrQfOGO9WS+5kCuZpWNV5w
         tSp5Xp0aJszRx/LjCCdaxAP2ZpW1YT9ayOcUoM6TnpMMoB7oioPmLbWXzBJsdWUnZi3I
         0jVaPIHZZZzTIguprLuJ2OZ0jUIburOQ0Q1DuTFAwLABkw/YXUZNa8aZuVxtte/32RJM
         KhEhSweThaWJHa2Cylb6V/XqkR36zRYfzKsvWd6ANFk2aaC1tcyZYAJ8TmE+75MEDH5Y
         p1LQ==
X-Gm-Message-State: APjAAAU3EDDT0rnGIdmLBQgfCqO3yGgTqZYQ/oL/USPAtF8MI+ScvY31
        W0RKoQw4sV8JeEbw6XiGyYE06IgYgD8=
X-Google-Smtp-Source: APXvYqyT1XtIrmspW40R1CKyXq7blOOrLhReeQ8HqMyJKxXBd7u9jWX34T+jjBe61Bpgh3QOoZpBtw==
X-Received: by 2002:ab0:208d:: with SMTP id r13mr21317287uak.128.1554921069959;
        Wed, 10 Apr 2019 11:31:09 -0700 (PDT)
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com. [209.85.217.50])
        by smtp.gmail.com with ESMTPSA id t11sm5749775vkc.53.2019.04.10.11.31.08
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Apr 2019 11:31:09 -0700 (PDT)
Received: by mail-vs1-f50.google.com with SMTP id d8so1969819vsp.2
        for <linux-crypto@vger.kernel.org>; Wed, 10 Apr 2019 11:31:08 -0700 (PDT)
X-Received: by 2002:a67:7816:: with SMTP id t22mr24108905vsc.115.1554921068268;
 Wed, 10 Apr 2019 11:31:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAMuHMdWhx0-kspDyLOgTp+9udiBpkMHULSGyMg9uPPV16=FWQg@mail.gmail.com>
 <20190319170911.GB202956@gmail.com> <20190320185719.GB180195@gmail.com>
 <CAGXu5jL-5C1ZGZ1JgaNFqK-z1Pp1N1X8gD3_ysKTCa=omD+_VQ@mail.gmail.com>
 <20190321175122.GA1587@sol.localdomain> <20190410031734.GB7140@sol.localdomain>
In-Reply-To: <20190410031734.GB7140@sol.localdomain>
From:   Kees Cook <keescook@chromium.org>
Date:   Wed, 10 Apr 2019 11:30:57 -0700
X-Gmail-Original-Message-ID: <CAGXu5j+SZ2+Zkc=Vp5CXQUHhiR9f_OOnca684JTRW3T0yXdaNQ@mail.gmail.com>
Message-ID: <CAGXu5j+SZ2+Zkc=Vp5CXQUHhiR9f_OOnca684JTRW3T0yXdaNQ@mail.gmail.com>
Subject: Re: crypto: Kernel memory overwrite attempt detected to spans
 multiple pages
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 9, 2019 at 8:17 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Mar 21, 2019 at 10:51:22AM -0700, Eric Biggers wrote:
> > On Thu, Mar 21, 2019 at 10:45:31AM -0700, Kees Cook wrote:
> > > On Wed, Mar 20, 2019 at 11:57 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > > >
> > > > On Tue, Mar 19, 2019 at 10:09:13AM -0700, Eric Biggers wrote:
> > > > > On Tue, Mar 19, 2019 at 12:54:23PM +0100, Geert Uytterhoeven wrote:
> > > > > > When running the sha1-asm crypto selftest on arm with
> > > > > > CONFIG_HARDENED_USERCOPY_PAGESPAN=y:
> > > > > >
> > > > > >     usercopy: Kernel memory overwrite attempt detected to spans
> > > > > > multiple pages (offset 0, size 42)!
> > > > >
> > > > > Well, this must happen with the new (in 5.1) crypto self-tests implementation
> > > > > for any crypto algorithm when CONFIG_HARDENED_USERCOPY_PAGESPAN=y.  I don't
> > > > > understand why hardened usercopy considers it a bug though, as there's no buffer
> > > > > overflow.  The crypto tests use copy_from_iter() to copy data into a 2-page
> > > > > buffer that was allocated with __get_free_pages():
> > > > >
> > > > >       __get_free_pages(GFP_KERNEL, 1)
> > > > >
> > > > > ... where 1 means an order-1 allocation.
> > > > >
> > > > > If it copies to offset=4064 len=42, for example, then hardened usercopy
> > > > > considers it a bug even though the buffer is 8192 bytes long.  Why?
> > > > >
> > > > > It isn't actually copying anything to/from userspace, BTW; it's using iov_iter
> > > > > with ITER_KVEC.
> > > > >
> > > > > - Eric
> > > >
> > > > Kees, any thoughts on why hardened usercopy rejects copies spanning a page
> > > > boundary when they seem to be fine?
> > >
> > > This is due to missing the compound page marking, if I remember
> > > correctly. However, I tend to leave the pagespan test disabled: it
> > > really isn't ready for production use -- there are a lot of missing
> > > annotations still.
> > >
> >
> > So do I need to add __GFP_COMP?  Is there any actual reason to do so?
> > Why does hardened usercopy check for it?
> >
> > - Eric
>
> Hi Kees, any answer to this question?

Hi! Sorry, this got lost in my inbox. Yes, if you can add __GFP_COMP,
that would fix this case. No one has had time lately to track down all
these cases, but avoiding adding new ones would be wonderful. :)

It's in there because it's a state I'd like to get to in the kernel,
but it'll require a lot more work to get there.

-- 
Kees Cook
