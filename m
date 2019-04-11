Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05558C10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 21:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0DFA2070D
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 21:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555016649;
	bh=rBrc//Q8zkoBO+A9SsRSKoG9WGpSqk/8v99bH2iG5No=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=i+U8qo+JWu75akFMFJi+EpVoLmMyecNjZ88Ihdf/NSYrdQIkDIWE+SI6NSxU9PBMD
	 5gyGomH4Zl47ejtI2OYDKA1gV+Cyaj2B8qIfMIwYbjXvo0rQxOTRcTfb0SICGi275n
	 yB7VPfEMmAXA3RjPguTxUtoSx7HOBO+ytn5AWvG0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfDKVED (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 17:04:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbfDKVED (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 17:04:03 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FE532146F;
        Thu, 11 Apr 2019 20:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555016203;
        bh=rBrc//Q8zkoBO+A9SsRSKoG9WGpSqk/8v99bH2iG5No=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wPDQirIsuHS5B2351kVZEj22FJLGqwUYvVMz4uKk743DHmbgBnRF3JgLtTuw8ph0E
         WaCg0I1PWscaFjRPzGnAO/jGP47dAx4wE2onubgeXY7SL0OS/HYT/Aj0ka7jk2z81K
         BEUUBQOqppvUjGPpabEkBIQe13AjAl2n+O5HhqSI=
Date:   Thu, 11 Apr 2019 13:56:41 -0700
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
Message-ID: <20190411205640.GE225654@gmail.com>
References: <20190410031734.GB7140@sol.localdomain>
 <CAGXu5j+SZ2+Zkc=Vp5CXQUHhiR9f_OOnca684JTRW3T0yXdaNQ@mail.gmail.com>
 <20190410190729.GA120258@gmail.com>
 <CAGXu5j+Gfvj9G6s_UQTw6hE11gJb1edt3BXzpbDQdc_dpcHgag@mail.gmail.com>
 <20190410231156.GB120258@gmail.com>
 <CAGXu5jKg+oN7yUY=N69U93afOVHBPgwz6Osf=eMDPfiwbzEqmw@mail.gmail.com>
 <20190411175823.GC225654@gmail.com>
 <CAGXu5j+u3f3qUVkQO+zYLN7BDh3r7w-W3k3aa+qdAP11k7A1dw@mail.gmail.com>
 <20190411192607.GD225654@gmail.com>
 <CAGXu5jJo0jXhB5Xy0fryrYPy7zN2RhSsMb0r0DPQ91dNR0zPCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJo0jXhB5Xy0fryrYPy7zN2RhSsMb0r0DPQ91dNR0zPCA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 11, 2019 at 01:36:37PM -0700, Kees Cook wrote:
> On Thu, Apr 11, 2019 at 12:26 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > Well, I guess I'll just add __GFP_COMP so I at least don't get spammed with
> > useless bug reports.
> 
> Thanks, I appreciate it.
> 
> > But I don't think it's in any way acceptable to change the semantics of the
> > kernel's page allocator but only under some obscure config option, don't
> > document it anywhere, ignore the known problems for years, say that the option
> > is broken anyway so it shouldn't be used, and have to exchange 15 emails to get
> > anything resembling an explanation.
> 
> I understand what you mean, yeah. I'm sorry I wasn't clear about it
> earlier. What do you think might help the situation as far as
> documentation?
> 

Explanation in Documentation/core-api/memory-allocation.rst of when to use
__GFP_COMP and why.  Where "why" includes the real underlying reason why it's
designed the way it is, not just "you now need to provide this flag in order to
stop the hardened usercopy thing from crashing, even though previously it meant
something else, because that's the way it is."

Also a brief, improved explanation of __GFP_COMP in include/linux/gfp.h.

Also get Documentation/security/self-protection.rst up to date with what's
actually in the kernel.  Currently it doesn't mention hardened usercopy at all,
and it's unclear about what's supported now vs. what is future work.

And actually fix the known problems with the pagespan check, not ignore them for
years.  If not feasible, remove the option.

- Eric
