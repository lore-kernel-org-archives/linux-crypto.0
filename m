Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EABAC47404
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04A7C2084D
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:55:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Q6xqUa/1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389516AbfJDOzi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:55:38 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:55815 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389043AbfJDOzi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 10:55:38 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 105265e5
        for <linux-crypto@vger.kernel.org>;
        Fri, 4 Oct 2019 14:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=WAr1HtzXyQMemRsOMTLcbLB6ySc=; b=Q6xqUa
        /1VnqQ/FBfws2lWulsmuwE/Zh834FDu3SpUIWxTlj3+M+mdFJqT5iL581ulieYn9
        JKv6LGlwqg7pbTRzf1R+8bBJjqobh+SZKND1MjJ0XlyqNvtwEvMLi5gVKHkQUpPh
        1vRIn4ILkMqRVV8pglMbhQAqAy4kljGT4m96C5zyduRFjtN9C94x+O3RVSxNUuQo
        BRTFTmjdDEsntx0tEwgx2D6vS0ASNuG/bNLan+9HtxmXuc2oyMozD5+rAa4T4xx/
        nSD46uOuN+/TRera31+ZYVpRwOXHslRj+im7hD9nThWriwsMN9SBtyYFgc4ucsc4
        FcI/eoNKQ6VP3yeA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e99ce0b0 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Fri, 4 Oct 2019 14:08:40 +0000 (UTC)
Received: by mail-oi1-f169.google.com with SMTP id w6so5970363oie.11
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 07:55:34 -0700 (PDT)
X-Gm-Message-State: APjAAAWHdkYBIyszobe/tCEMtTopMbOv1FcG8W6Fdta01T2okgBSQheQ
        VXkGNsMC9su5NTBd9raS2OSkC3ZvXm9SyAQErBI=
X-Google-Smtp-Source: APXvYqxLoej9Nu35RdW9DA3+wRK6R70ViZG7xTzQgqmnoVoKH+FefLETsBNBvgmIgAwD8FCtUELA5xLRrCztHg25sIs=
X-Received: by 2002:aca:cd58:: with SMTP id d85mr6936814oig.119.1570200933141;
 Fri, 04 Oct 2019 07:55:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAKv+Gu-Xe-BfYzVDqDaZZ2wawYs8HHHc-CMYPPOU3E=6CPgccA@mail.gmail.com>
 <BE18E4E0-D4CC-40B9-96E1-C44D25B879D9@amacapital.net>
In-Reply-To: <BE18E4E0-D4CC-40B9-96E1-C44D25B879D9@amacapital.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 4 Oct 2019 16:55:20 +0200
X-Gmail-Original-Message-ID: <CAHmME9rMAytP32kHRjWyoyS8LTugG5qf5drok+H-k9K-TkVXew@mail.gmail.com>
Message-ID: <CAHmME9rMAytP32kHRjWyoyS8LTugG5qf5drok+H-k9K-TkVXew@mail.gmail.com>
Subject: Re: [PATCH v2 00/20] crypto: crypto API library interfaces for WireGuard
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 4, 2019 at 4:53 PM Andy Lutomirski <luto@amacapital.net> wrote:
> I think it might be better to allow two different modules to export the same symbol but only allow one of them to be loaded. Or use static calls.

Static calls perform well and are well understood. This would be my preference.
