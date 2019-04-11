Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05887C282CE
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 17:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBADA2146F
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 17:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555005513;
	bh=pDhoCNdjeWrX/vbXMoWNxoXMBQ5uWIGVajVGVcqJMWQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=KpZ/ABk9BuEM/VTlfTiCHxxe+lu65k4kDX5sAJ8C3QDVUEvfS1KxlGIfX+DDHANJ/
	 chpKzh5Tl6RVjxrDELnVy4u7b4XuxoTn8LKv52GtyATBz8L6NoLtFOG+ne5eOFn7Cp
	 U7ViWW8Y+47luk501ca6zR8DZepgv9J+bTS2nDpM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbfDKR61 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 13:58:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726577AbfDKR61 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 13:58:27 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A37F2070D;
        Thu, 11 Apr 2019 17:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555005506;
        bh=pDhoCNdjeWrX/vbXMoWNxoXMBQ5uWIGVajVGVcqJMWQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TqRT/D2bY+vD2/ipEBuIR7EhPIJZ1dyOdUd1PhF/ZbNz1X2+KRuqX4zrziUuz9cOB
         uTT0Xr1mikQiwpDMnAwdPiA3W4KqXFwtWOzwrjpiHfke0Dw2OoA9d4XEs2qFwSrj+W
         15+Z2cp/nX6yoafj5Xgw7D4l9bqFSqf4r4T8hvIk=
Date:   Thu, 11 Apr 2019 10:58:24 -0700
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
Message-ID: <20190411175823.GC225654@gmail.com>
References: <20190319170911.GB202956@gmail.com>
 <20190320185719.GB180195@gmail.com>
 <CAGXu5jL-5C1ZGZ1JgaNFqK-z1Pp1N1X8gD3_ysKTCa=omD+_VQ@mail.gmail.com>
 <20190321175122.GA1587@sol.localdomain>
 <20190410031734.GB7140@sol.localdomain>
 <CAGXu5j+SZ2+Zkc=Vp5CXQUHhiR9f_OOnca684JTRW3T0yXdaNQ@mail.gmail.com>
 <20190410190729.GA120258@gmail.com>
 <CAGXu5j+Gfvj9G6s_UQTw6hE11gJb1edt3BXzpbDQdc_dpcHgag@mail.gmail.com>
 <20190410231156.GB120258@gmail.com>
 <CAGXu5jKg+oN7yUY=N69U93afOVHBPgwz6Osf=eMDPfiwbzEqmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKg+oN7yUY=N69U93afOVHBPgwz6Osf=eMDPfiwbzEqmw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 10, 2019 at 04:27:28PM -0700, Kees Cook wrote:
> On Wed, Apr 10, 2019 at 4:12 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > You've explained *what* it does again, but not *why*.  *Why* do you want
> > hardened usercopy to detect copies across page boundaries, when there is no
> > actual buffer overflow?
> 
> But that *is* how it determines it was a buffer overflow: "if you
> cross page boundaries (of a non-compound allocation), it *is* a buffer
> overflow". This assertion, however, is flawed because many contiguous
> allocations are not marked as being grouped together when it reality
> they were. It was an attempt to get allocation size information out of
> the page allocator, similar to how slab can be queries about
> allocation size. I'm open to improvements here, since it's obviously
> broken in its current state. :)
> 
> -- 
> Kees Cook

Well, I'm still at a loss as to whether I'm actually supposed to "fix" this by
adding __GFP_COMP, or whether you're saying the option is broken anyway so I
shouldn't bother doing anything.  IIUC, even the kernel stack is still not
marked __GFP_COMP, so copies to/from the stack can trigger this too, despite
this being reported over 2 years ago
(http://lkml.iu.edu/hypermail/linux/kernel/1701.2/01450.html)?
CONFIG_HARDENED_USERCOPY_PAGESPAN is even disabled in syzbot because you already
said the option is broken and should not be used.

I worry that people will enable all the hardened usercopy options "because
security", then when the pagespan check breaks something they will disable all
hardened usercopy options, because they don't understand the individual options.
Providing broken options is actively harmful, IMO.

- Eric
