Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C6AC47404
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 15:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8AC42133F
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 15:38:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="xUAoqxar"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389710AbfJDPig (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 11:38:36 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:46145 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389669AbfJDPig (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 11:38:36 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 55555943
        for <linux-crypto@vger.kernel.org>;
        Fri, 4 Oct 2019 14:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=cNch+LB8NMWz/cFFKVEJldWZHes=; b=xUAoqx
        arftuHkdAx3lplMohWogacyy7dVJzcEPs4OTFqZ0Gac0vkkoYLPEE5zrlzeaTYXs
        Gbla76RKO068anjF3FolpuHNQnp5l9FMtavG1HN6z8y8dJskZv/7z+HY1MX0QHBk
        EUni2TCON2+qrp0N1sm+01KkOYRXVFcK/GG1OkAFMSbjZTtc/oB1b553AjVJFvpc
        VBkXe4geS4SH00H/Q5nCWvwudZHL65iKGhbfNnFplWr1fSuLVRW9WNyK2tvqKXrD
        rVnECxQzwinmBRWEIz9I3P7awpMn5nWneDl742J/DAcad3T/kxITSDIZm0w50wMs
        9phPejPddEZMHjeA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 004e8c26 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Fri, 4 Oct 2019 14:51:38 +0000 (UTC)
Received: by mail-ot1-f46.google.com with SMTP id g13so5647848otp.8
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 08:38:32 -0700 (PDT)
X-Gm-Message-State: APjAAAVS8ZV3yaVkYKge57vhHKWR02iHk3loqlc5fPJX+DhjR4JaV8n1
        TRDVgmMmW64zWCjQVCiiPs7Q2d1iQRQOmN1BtQM=
X-Google-Smtp-Source: APXvYqyMEj2ZKkvwCK7A39p+5tMQVs4L1zRyyYoyTXoNNrt4ET2Rm0YUm44vDcjK1CEuQNHjpdxrHbkkvPyVeKvQ5ns=
X-Received: by 2002:a05:6830:20cd:: with SMTP id z13mr4369116otq.243.1570203511492;
 Fri, 04 Oct 2019 08:38:31 -0700 (PDT)
MIME-Version: 1.0
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-5-ard.biesheuvel@linaro.org> <CAHmME9p3a-sNp_MmMKxX7z9PsTi3DdUrVtX=X4vhr_ep=KdCJw@mail.gmail.com>
 <CAKv+Gu8urn0K5pCHr4Y1qJH+8-wcQ=BXAHVSXO9xt4PwZ14xiw@mail.gmail.com>
 <CAK8P3a2At0YUwZ7xSOd12QPKcxvnjeG49nfMuDz3E4wO7Tr1fQ@mail.gmail.com> <CAKv+Gu-UGvpSVVrJ+QGoJ2jFXJGNMhCdmK_qysSty8EBK84YZA@mail.gmail.com>
In-Reply-To: <CAKv+Gu-UGvpSVVrJ+QGoJ2jFXJGNMhCdmK_qysSty8EBK84YZA@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 4 Oct 2019 17:38:20 +0200
X-Gmail-Original-Message-ID: <CAHmME9px9m_G2WEnGs5k7jrm4OGCfk4QQ5f74p=0LCbsqHhcRw@mail.gmail.com>
Message-ID: <CAHmME9px9m_G2WEnGs5k7jrm4OGCfk4QQ5f74p=0LCbsqHhcRw@mail.gmail.com>
Subject: Re: [PATCH v2 04/20] crypto: arm/chacha - expose ARM ChaCha routine
 as library function
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
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

On Fri, Oct 4, 2019 at 5:36 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > Just checking for Cortex-A7 being the boot CPU is probably
> > sufficient, that takes care of the common case of all the
> > A7-only embedded chips that people definitely are going to care
> > about for a long time.
> >
>
> But do you agree that disabling kernel mode NEON altogether for these
> systems is probably more sensible than testing for CPU part IDs in an
> arbitrary crypto driver?

No. That NEON code is _still_ faster than the generic C code. But it
is not as fast as the scalar code. There might be another primitive
that has a fast NEON implementation but does not have a fast scalar
implementation. The choice there would be between fast NEON and slow
generic. In that case, we want fast NEON. Also, different algorithms
lend themselves to different implementation strategies. Leave this up
to the chacha code, as Zinc does it, since this is the place that has
the most information to decide what it should be running.
