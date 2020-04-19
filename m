Return-Path: <SRS0=r6//=6D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C9E2C2BA2B
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Apr 2020 08:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2920B214AF
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Apr 2020 08:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587286514;
	bh=B7vop3xwaQJ6PIjFyy41WJ6ZY2Cvtqgx45oek7lxwYc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=vbLM2UOOFScLQSBPXDkv4KCPg3ag/Zpse7uSKS0z+5XBRthVkRBdURgc+OEm1sFXJ
	 hFR7eDjA4M5IeJF/YUGzp9kBV+ESbjFFYEnRntjZLWnk/GseRqrBoyeh8FO9cyw3CC
	 S/1+TkXGGmXZK+GLFSaL/UE6oMdLPC7vHzHV65zA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgDSIzM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Apr 2020 04:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgDSIzM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Apr 2020 04:55:12 -0400
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3C0C214AF;
        Sun, 19 Apr 2020 08:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587286511;
        bh=B7vop3xwaQJ6PIjFyy41WJ6ZY2Cvtqgx45oek7lxwYc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IAD5rMFU6M6EG55Jl0GAqkoc1sbbxlbt7uqnKjRgl4VB6FbVyusUt2xjy8crsYFyV
         YyjXwd79m1ZRSiMDkxIFtfg66929eWiKe6iWafn0MNJW3yBH1lMnFgDEutmux6+Nst
         zoPf0gBihahJ8Xo4WTjVUNjQscu35xsEx1MDRQUg=
Received: by mail-io1-f46.google.com with SMTP id f3so7408612ioj.1;
        Sun, 19 Apr 2020 01:55:11 -0700 (PDT)
X-Gm-Message-State: AGi0PubJW3tMa6nYE9Fbn/DOLAJvWWqf5NiUI9JyWThszyZdfmfOqn/t
        p7EfcgIBxsvXXHbnqVmpfRoYu057dNl89qz4wrE=
X-Google-Smtp-Source: APiQypKcQgkER4Paz90cO5JDq8rFKshjOC7P9sa9VdPg08yX5P11CegPcw2SrKkqWtvC8UcNZPYt6trYdGQIO8cBTiM=
X-Received: by 2002:a02:969a:: with SMTP id w26mr10554759jai.71.1587286511272;
 Sun, 19 Apr 2020 01:55:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200418104343.GA5132@amd> <DB6PR0802MB2533670AFC1473E5C5EDAD28E9D60@DB6PR0802MB2533.eurprd08.prod.outlook.com>
 <VI1PR08MB3584451F0B0B21E00ACF56A7FED70@VI1PR08MB3584.eurprd08.prod.outlook.com>
 <CAOtvUMfNgdYZF5VaqgF-51b0+KtxqgUFD6njXFX7evz1yAJc9A@mail.gmail.com>
In-Reply-To: <CAOtvUMfNgdYZF5VaqgF-51b0+KtxqgUFD6njXFX7evz1yAJc9A@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 19 Apr 2020 10:55:00 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEGSAD2Kkjg56UhMGgjuLBSOAKJ7ZMHdzfP2szGncu-4Q@mail.gmail.com>
Message-ID: <CAMj1kXEGSAD2Kkjg56UhMGgjuLBSOAKJ7ZMHdzfP2szGncu-4Q@mail.gmail.com>
Subject: Re: Fw: Arm CryptoCell driver -- default Y, even on machines where it
 is obviously useless
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Hadar Gat <hadar.gat@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 19 Apr 2020 at 08:33, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>
> > > -----Original Message-----
> > > From: Pavel Machek <pavel@ucw.cz>
> > > Sent: Saturday, 18 April 2020 13:44
> > > To: kernel list <linux-kernel@vger.kernel.org>; Hadar Gat
> > > <Hadar.Gat@arm.com>; herbert@gondor.apana.org.au
> > > Subject: Arm CryptoCell driver -- default Y, even on machines where it is
> > > obviously useless
> > >
> > > Hi!
> > >
> > > I'm configuring kernel for x86, and I get offered HW_RANDOM_CCTRNG with
> > > default=Y, and help text suggesting I should enable it.
> > >
> > > That's... two wrong suggestions, right?
> > >
> > > Best regards,
> > > Pavel
> ...
> > ________________________________________
> > From: Hadar Gat <Hadar.Gat@arm.com>
> > Sent: Saturday, April 18, 2020 11:31 PM
> > To: Pavel Machek; kernel list; herbert@gondor.apana.org.au
> > Cc: Ofir Drang; Gilad Ben Yossef; nd
> > Subject: RE: Arm CryptoCell driver -- default Y, even on machines where it is obviously useless
> >
> > Hi Pavel,
> > I think you got it right..
> > Indeed, Arm CryptoCell CCTRNG driver couldn't be used and obviously useless if the Arm CryptoCell HW does not exist in the system.
>
> There's a delicate point here though - CryptoCell is an independent
> hardware block, it is not tied to a particular CPU architecture.
> There are SoCs with none-Arm architecture CPU using it.
>
> So I would say whatever the answer is, it should be the same for any
> generic embedded style HW block.
>
> And the help text is not architecture specific anyway, is it not..?
>

Both the default y and and the help text are indeed incorrect. This
should be fixed. We don't enable device drivers by default, and
definitely not as as builtins. A conditional default m could be
acceptable if the condition is sufficiently narrow.

While at it, could we add a depends on CONFIG_OF since this code is
definitely unusable on non-DT systems.
