Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C91CC282CE
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 19:26:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C8FF2173C
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 19:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555010773;
	bh=LasD5SVagvvjCam8uG/qKJspYrMcJzP3xU3SkDzSVTE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=HMBijy+OthQlofIOQ8pSXLNuRTSXjs7ww4wvkWJ3A6qk9DoOV70tdQkla1T119r5j
	 sx9VH8b8gjjXPulgWw2F+hMZghjPNsd9fyG8rYmktXBCwbsv7esm5IGhCFvdHyuCGy
	 kNzNTSEB6b56f9KnLLKLl1+R7JZ1dc/ftZGFyfLM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbfDKT0M (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 15:26:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726577AbfDKT0M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 15:26:12 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57EE12083E;
        Thu, 11 Apr 2019 19:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555010770;
        bh=LasD5SVagvvjCam8uG/qKJspYrMcJzP3xU3SkDzSVTE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V9DtTPvVNwlqsH22PAa/i0gPlvgYUv1+TdmrYqwk4eiS/eSLKiDRXU/tYMXNdAK//
         hFDvZ/WGHvhe0Y3wtYwajByOTeptpeyXanjY8JGPSaENDG0oNM5kUU6NvSRT+qN7rG
         WQnO3qgG3/n3qrHYOvo5oJK7jXBMcT7wG9WOMNWM=
Date:   Thu, 11 Apr 2019 12:26:08 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Rik van Riel <riel@surriel.com>
Subject: Re: crypto: Kernel memory overwrite attempt detected to spans
 multiple pages
Message-ID: <20190411192607.GD225654@gmail.com>
References: <CAGXu5jL-5C1ZGZ1JgaNFqK-z1Pp1N1X8gD3_ysKTCa=omD+_VQ@mail.gmail.com>
 <20190321175122.GA1587@sol.localdomain>
 <20190410031734.GB7140@sol.localdomain>
 <CAGXu5j+SZ2+Zkc=Vp5CXQUHhiR9f_OOnca684JTRW3T0yXdaNQ@mail.gmail.com>
 <20190410190729.GA120258@gmail.com>
 <CAGXu5j+Gfvj9G6s_UQTw6hE11gJb1edt3BXzpbDQdc_dpcHgag@mail.gmail.com>
 <20190410231156.GB120258@gmail.com>
 <CAGXu5jKg+oN7yUY=N69U93afOVHBPgwz6Osf=eMDPfiwbzEqmw@mail.gmail.com>
 <20190411175823.GC225654@gmail.com>
 <CAGXu5j+u3f3qUVkQO+zYLN7BDh3r7w-W3k3aa+qdAP11k7A1dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+u3f3qUVkQO+zYLN7BDh3r7w-W3k3aa+qdAP11k7A1dw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 11, 2019 at 11:33:04AM -0700, Kees Cook wrote:
> On Thu, Apr 11, 2019 at 10:58 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Wed, Apr 10, 2019 at 04:27:28PM -0700, Kees Cook wrote:
> > > On Wed, Apr 10, 2019 at 4:12 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > > > You've explained *what* it does again, but not *why*.  *Why* do you want
> > > > hardened usercopy to detect copies across page boundaries, when there is no
> > > > actual buffer overflow?
> > >
> > > But that *is* how it determines it was a buffer overflow: "if you
> > > cross page boundaries (of a non-compound allocation), it *is* a buffer
> > > overflow". This assertion, however, is flawed because many contiguous
> > > allocations are not marked as being grouped together when it reality
> > > they were. It was an attempt to get allocation size information out of
> > > the page allocator, similar to how slab can be queries about
> > > allocation size. I'm open to improvements here, since it's obviously
> > > broken in its current state. :)
> > >
> > > --
> > > Kees Cook
> >
> > Well, I'm still at a loss as to whether I'm actually supposed to "fix" this by
> > adding __GFP_COMP, or whether you're saying the option is broken anyway so I
> 
> I would love it if you could fix it, yes.
> 
> > shouldn't bother doing anything.  IIUC, even the kernel stack is still not
> > marked __GFP_COMP, so copies to/from the stack can trigger this too, despite
> > this being reported over 2 years ago
> > (http://lkml.iu.edu/hypermail/linux/kernel/1701.2/01450.html)?
> > CONFIG_HARDENED_USERCOPY_PAGESPAN is even disabled in syzbot because you already
> > said the option is broken and should not be used.
> 
> stacks are checked before PAGESPAN, so that particular problem should
> no longer be present since commit 7bff3c069973 ("mm/usercopy.c: no
> check page span for stack objects").
> 
> > I worry that people will enable all the hardened usercopy options "because
> > security", then when the pagespan check breaks something they will disable all
> > hardened usercopy options, because they don't understand the individual options.
> > Providing broken options is actively harmful, IMO.
> 
> It's behind EXPERT, default-n, and says:
> 
>           When a multi-page allocation is done without __GFP_COMP,
>           hardened usercopy will reject attempts to copy it. There are,
>           however, several cases of this in the kernel that have not all
>           been removed. This config is intended to be used only while
>           trying to find such users.
> 
> I'd rather leave it since it's still useful.
> 
> Perhaps it could be switched to WARN by default and we reenable it in
> syzbot to improve its utility there?
> 
> diff --git a/mm/usercopy.c b/mm/usercopy.c
> index 14faadcedd06..6e7e28fe062b 100644
> --- a/mm/usercopy.c
> +++ b/mm/usercopy.c
> @@ -208,8 +208,13 @@ static inline void check_page_span(const void
> *ptr, unsigned long n,
>          */
>         is_reserved = PageReserved(page);
>         is_cma = is_migrate_cma_page(page);
> -       if (!is_reserved && !is_cma)
> -               usercopy_abort("spans multiple pages", NULL, to_user, 0, n);
> +       if (!is_reserved && !is_cma) {
> +               usercopy_warn("spans multiple pages without __GFP_COMP",
> +                               NULL, to_user,
> +                               (unsigned long)ptr & (unsigned long)PAGE_MASK,
> +                               n);
> +               return;
> +       }
> 
>         for (ptr += PAGE_SIZE; ptr <= end; ptr += PAGE_SIZE) {
>                 page = virt_to_head_page(ptr);
> 
> 
> -- 
> Kees Cook

Well, I guess I'll just add __GFP_COMP so I at least don't get spammed with
useless bug reports.

But I don't think it's in any way acceptable to change the semantics of the
kernel's page allocator but only under some obscure config option, don't
document it anywhere, ignore the known problems for years, say that the option
is broken anyway so it shouldn't be used, and have to exchange 15 emails to get
anything resembling an explanation.

- Eric
