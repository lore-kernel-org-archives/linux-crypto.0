Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B60C47404
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 15:43:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F33E420830
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 15:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570203837;
	bh=5+4Rg0O8n5iLx3Ezgy1JDlc8iuGDWmVwnLX2O5wl/Ks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=y5B6bwFjSQiQjA0MZ9ly2HtNkvi3lAYjGo2YalMdmA3gdFECLB2xzEAH4uvD1orgY
	 hAL5mP2L4Y2E2OuAEMUtPGEWAX9hzJiMuZWKxrlB5WXMvA0lBuINdKd7HpGWhUaQJJ
	 6WFptpITkQ9SQhINFglgHHKAYIsW2ODgI7Ke1XvY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389131AbfJDPn4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 11:43:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389891AbfJDPnx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 11:43:53 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 700332133F;
        Fri,  4 Oct 2019 15:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570203833;
        bh=5+4Rg0O8n5iLx3Ezgy1JDlc8iuGDWmVwnLX2O5wl/Ks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pLqfEKgVMxzpU2Kq1ZnpJzrr9Zedn+iveYLqdEvhR4OZBmDJfxsOIlRk0GsIx7BMo
         WN8EPKqOeNW+RAZPlh3qXiR2y9i6Cto1TnYnYQsc044HAHI1EjOmaizSGylx3ebFC1
         bt5DMbTrPKsZe5DwXLi9kZlR78e5fkgdXqsRNc2M=
Date:   Fri, 4 Oct 2019 08:43:50 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 04/20] crypto: arm/chacha - expose ARM ChaCha routine
 as library function
Message-ID: <20191004154350.GA698@sol.localdomain>
Mail-Followup-To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-5-ard.biesheuvel@linaro.org>
 <CAHmME9p3a-sNp_MmMKxX7z9PsTi3DdUrVtX=X4vhr_ep=KdCJw@mail.gmail.com>
 <CAKv+Gu8urn0K5pCHr4Y1qJH+8-wcQ=BXAHVSXO9xt4PwZ14xiw@mail.gmail.com>
 <CAHmME9qYtvhqQ25+E-GW0=6AuAwCPmsCeHpw6cS_zs1XSBpR7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9qYtvhqQ25+E-GW0=6AuAwCPmsCeHpw6cS_zs1XSBpR7A@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 04, 2019 at 04:29:57PM +0200, Jason A. Donenfeld wrote:
> On Fri, Oct 4, 2019 at 4:23 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > How is it relevant whether the boot CPU is A5 or A7? These are bL
> > little cores that only implement NEON for feature parity with their bl
> > big counterparts, but CPU intensive tasks are scheduled on big cores,
> > where NEON performance is much better than scalar.
> 
> Yea big-little might confuse things indeed. Though the performance
> difference between the NEON code and the scalar code is not that huge,
> and I suspect that big-little machines might benefit from
> unconditionally using the scalar code, given that sometimes they might
> wind up doing things on the little cores.
> 
> Eric - what did you guys wind up doing on Android with the fast scalar
> implementation?

We're still just using the NEON implementation from the upstream kernel instead.

- Eric
