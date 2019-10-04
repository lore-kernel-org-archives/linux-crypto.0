Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95AF1C4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 13:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AC2220700
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 13:42:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="HuOupBf4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388491AbfJDNml (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:42:41 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:54141 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388438AbfJDNml (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 09:42:41 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 0588d916;
        Fri, 4 Oct 2019 12:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=date:from:to
        :cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=mail; bh=vuup28YcsFnhqU/UHJ0fGBHSEj0=; b=HuOupBf
        4v9hRb1vIKNkmLK5dxjTl/qqPa9pywUmkUK8gALy7tjVE/WLEmsdxfLeUJh0kDpV
        QoNeL+/P4uCNIuwg5VPoeNbHpo1QDVcHN1PqvYi/INxEYBKoxemo8rdasUXqFbVd
        AJA18+vUMOppEHjWR+E9/sQtArNsPmdZ3f/Vsp2dLlMy9tXltlGtMEv+JaoqnX8P
        bYy6epyMTHVtefd1W3jK72ZYrQEiZ+BsuX8VaNQMsFjDmYEshDtTUiNCGhhg2UzU
        RTHTqNO5ngyEoHYyTA1zVMtFgpo8K0N5+SaXvyaTOl2xijOJUViy29AY1oSAQWys
        Kz0ZogORcaNDi1Q==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0e548f4d (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 4 Oct 2019 12:55:45 +0000 (UTC)
Date:   Fri, 4 Oct 2019 15:42:33 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 00/20] crypto: crypto API library interfaces for
 WireGuard
Message-ID: <20191004134233.GD112631@zx2c4.com>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <CAKv+Gu-+3AWNAK0WWSFQT15Q3r6ak7wGr3ZROyJ35-4GN6=iJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-+3AWNAK0WWSFQT15Q3r6ak7wGr3ZROyJ35-4GN6=iJQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 03, 2019 at 10:43:29AM +0200, Ard Biesheuvel wrote:
> On Wed, 2 Oct 2019 at 16:17, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> ...
> >
> > In the future, I would like to extend these interfaces to use static calls,
> > so that the accelerated implementations can be [un]plugged at runtime. For
> > the time being, we rely on weak aliases and conditional exports so that the
> > users of the library interfaces link directly to the accelerated versions,
> > but without the ability to unplug them.
> >
> 
> As it turns out, we don't actually need static calls for this.
> Instead, we can simply permit weak symbol references to go unresolved
> between modules (as we already do in the kernel itself, due to the
> fact that ELF permits it), and have the accelerated code live in
> separate modules that may not be loadable on certain systems, or be
> blacklisted by the user.

You're saying that at module insertion time, the kernel will override
weak symbols with those provided by the module itself? At runtime?

Do you know offhand how this patching works? Is there a PLT that gets
patched, and so the calls all go through a layer of function pointer
indirection? Or are all call sites fixed up at insertion time and the
call instructions rewritten with some runtime patching magic?

Unless the method is the latter, I would assume that static calls are
much faster in general? Or the approach already in this series is
perhaps fine enough, and we don't need to break this apart into
individual modules complicating everything?
