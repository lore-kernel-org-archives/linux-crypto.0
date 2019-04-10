Return-Path: <SRS0=kwSW=SM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08721C10F11
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 19:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD7DF2082E
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 19:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554923261;
	bh=l5kx7M5yIhwXZKbmcPL7AM62Ycxqpjj9uZJIKXIkFXk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=AZFaG91uLeCA9t2ckZGf1MN6eBzRRSqKuc/GzM8lEdxvnMQBZz7sKDZPzwIpLIcJj
	 Bgu+yPyERe/uVpo1UlacHIpHcBtEvSxKW+O6rgUg3ZbZkBlbdpa9Jl+J8sNEmhB2t2
	 th4VHApxy7h5ebkaKs78/1UQ1XCcV1pDYVrVCd1M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfDJTHe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Apr 2019 15:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726753AbfDJTHe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Apr 2019 15:07:34 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D39952082E;
        Wed, 10 Apr 2019 19:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554923253;
        bh=l5kx7M5yIhwXZKbmcPL7AM62Ycxqpjj9uZJIKXIkFXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lpbMvmzoK4obAkSjUiVj+EJaYr0Z2YfkhiR34D1ICsugEYR1EAhNnz5I7CbWuJcfg
         ZZdcdlhzwAO3/43bU/AoqBZhciueBKrBKPr0zqNY1P3zcqN738Rj7zmls3BBsZ9YLF
         /5/0OdnzKiGCKE1wYY1814YukGtRhezkGyeOjNpc=
Date:   Wed, 10 Apr 2019 12:07:31 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: crypto: Kernel memory overwrite attempt detected to spans
 multiple pages
Message-ID: <20190410190729.GA120258@gmail.com>
References: <CAMuHMdWhx0-kspDyLOgTp+9udiBpkMHULSGyMg9uPPV16=FWQg@mail.gmail.com>
 <20190319170911.GB202956@gmail.com>
 <20190320185719.GB180195@gmail.com>
 <CAGXu5jL-5C1ZGZ1JgaNFqK-z1Pp1N1X8gD3_ysKTCa=omD+_VQ@mail.gmail.com>
 <20190321175122.GA1587@sol.localdomain>
 <20190410031734.GB7140@sol.localdomain>
 <CAGXu5j+SZ2+Zkc=Vp5CXQUHhiR9f_OOnca684JTRW3T0yXdaNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+SZ2+Zkc=Vp5CXQUHhiR9f_OOnca684JTRW3T0yXdaNQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 10, 2019 at 11:30:57AM -0700, Kees Cook wrote:
> On Tue, Apr 9, 2019 at 8:17 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Thu, Mar 21, 2019 at 10:51:22AM -0700, Eric Biggers wrote:
> > > On Thu, Mar 21, 2019 at 10:45:31AM -0700, Kees Cook wrote:
> > > > On Wed, Mar 20, 2019 at 11:57 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > > > >
> > > > > On Tue, Mar 19, 2019 at 10:09:13AM -0700, Eric Biggers wrote:
> > > > > > On Tue, Mar 19, 2019 at 12:54:23PM +0100, Geert Uytterhoeven wrote:
> > > > > > > When running the sha1-asm crypto selftest on arm with
> > > > > > > CONFIG_HARDENED_USERCOPY_PAGESPAN=y:
> > > > > > >
> > > > > > >     usercopy: Kernel memory overwrite attempt detected to spans
> > > > > > > multiple pages (offset 0, size 42)!
> > > > > >
> > > > > > Well, this must happen with the new (in 5.1) crypto self-tests implementation
> > > > > > for any crypto algorithm when CONFIG_HARDENED_USERCOPY_PAGESPAN=y.  I don't
> > > > > > understand why hardened usercopy considers it a bug though, as there's no buffer
> > > > > > overflow.  The crypto tests use copy_from_iter() to copy data into a 2-page
> > > > > > buffer that was allocated with __get_free_pages():
> > > > > >
> > > > > >       __get_free_pages(GFP_KERNEL, 1)
> > > > > >
> > > > > > ... where 1 means an order-1 allocation.
> > > > > >
> > > > > > If it copies to offset=4064 len=42, for example, then hardened usercopy
> > > > > > considers it a bug even though the buffer is 8192 bytes long.  Why?
> > > > > >
> > > > > > It isn't actually copying anything to/from userspace, BTW; it's using iov_iter
> > > > > > with ITER_KVEC.
> > > > > >
> > > > > > - Eric
> > > > >
> > > > > Kees, any thoughts on why hardened usercopy rejects copies spanning a page
> > > > > boundary when they seem to be fine?
> > > >
> > > > This is due to missing the compound page marking, if I remember
> > > > correctly. However, I tend to leave the pagespan test disabled: it
> > > > really isn't ready for production use -- there are a lot of missing
> > > > annotations still.
> > > >
> > >
> > > So do I need to add __GFP_COMP?  Is there any actual reason to do so?
> > > Why does hardened usercopy check for it?
> > >
> > > - Eric
> >
> > Hi Kees, any answer to this question?
> 
> Hi! Sorry, this got lost in my inbox. Yes, if you can add __GFP_COMP,
> that would fix this case. No one has had time lately to track down all
> these cases, but avoiding adding new ones would be wonderful. :)
> 
> It's in there because it's a state I'd like to get to in the kernel,
> but it'll require a lot more work to get there.
> 

That didn't answer my question.  My question is what is the purpose of this?  If
there was actual buffer overflow when __GFP_COMP isn't specified that would make
perfect sense, but AFAICS there isn't.  So why does hardened usercopy consider
it broken when __GFP_COMP isn't specified?

- Eric
