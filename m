Return-Path: <SRS0=kwSW=SM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19DD0C10F11
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 23:12:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9480217D4
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 23:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554937921;
	bh=q6C6asliB+R3GiA6MRBIkiZPDalhAROlS4ZO33DglG0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=2Q4wuvcThKdLzCJHfv6KKqAQNF6DZkMfgc5oMigeeBPe8XWU9yW/V+XG722mlnkdV
	 lRWkeHdBCz0LSXuSKMLETToJkBBgTuCrg6TzW9hawtRg1T1bYv8A7lCz5Kzq4MSGqR
	 fiM2ETjJ7MFDVUVLbmk9vvvZb67JprwdkAycCtTk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfDJXMA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Apr 2019 19:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbfDJXMA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Apr 2019 19:12:00 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CE1D20850;
        Wed, 10 Apr 2019 23:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554937919;
        bh=q6C6asliB+R3GiA6MRBIkiZPDalhAROlS4ZO33DglG0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f81Qq4iocQpcOMtiR/t0Rc4UGVCF32ESP7I2KWwf81yZwHCWE9mGd9sRVmo1c0Xlv
         /y9pJUesNDA1OihDE32NMDVFKUK+ByAhVfv/WJT/nXo25R1ENmGuBxDC5/h8G4E99R
         e406h9JxbuxcxrU7vgv31/fKl9m+ewipryJAmJtQ=
Date:   Wed, 10 Apr 2019 16:11:58 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Rik van Riel <riel@surriel.com>
Subject: Re: crypto: Kernel memory overwrite attempt detected to spans
 multiple pages
Message-ID: <20190410231156.GB120258@gmail.com>
References: <CAMuHMdWhx0-kspDyLOgTp+9udiBpkMHULSGyMg9uPPV16=FWQg@mail.gmail.com>
 <20190319170911.GB202956@gmail.com>
 <20190320185719.GB180195@gmail.com>
 <CAGXu5jL-5C1ZGZ1JgaNFqK-z1Pp1N1X8gD3_ysKTCa=omD+_VQ@mail.gmail.com>
 <20190321175122.GA1587@sol.localdomain>
 <20190410031734.GB7140@sol.localdomain>
 <CAGXu5j+SZ2+Zkc=Vp5CXQUHhiR9f_OOnca684JTRW3T0yXdaNQ@mail.gmail.com>
 <20190410190729.GA120258@gmail.com>
 <CAGXu5j+Gfvj9G6s_UQTw6hE11gJb1edt3BXzpbDQdc_dpcHgag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+Gfvj9G6s_UQTw6hE11gJb1edt3BXzpbDQdc_dpcHgag@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 10, 2019 at 02:57:46PM -0700, Kees Cook wrote:
> On Wed, Apr 10, 2019 at 12:07 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > That didn't answer my question.  My question is what is the purpose of this?  If
> > there was actual buffer overflow when __GFP_COMP isn't specified that would make
> > perfect sense, but AFAICS there isn't.  So why does hardened usercopy consider
> > it broken when __GFP_COMP isn't specified?
> 
> The goal of CONFIG_HARDENED_USERCOPY_PAGESPAN was to detect copies
> across page boundaries in memory allocated by the page allocator.
> There appear to be enough cases of allocations that span pages but do
> not mark them with __GFP_COMP, so this logic hasn't proven useful in
> the real world (which is why no one should use the ..._PAGESPAN config
> in production). I'd like to get the kernel to the point where hardened
> usercopy can correctly do these checks (right now it's mainly only
> useful at checking for overflows in slub and slab), but it'll take
> time/focus for a while. No one has had time yet to track all of these
> down and fix them. (I defer to Laura and Rik on the design of the
> pagespan checks; they did the bulk of the work there.)
> 
> Does that help explain it, or am I still missing your question?
> 
> -- 
> Kees Cook

You've explained *what* it does again, but not *why*.  *Why* do you want
hardened usercopy to detect copies across page boundaries, when there is no
actual buffer overflow?

- Eric
