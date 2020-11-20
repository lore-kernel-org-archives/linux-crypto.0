Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC3C3C63777
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 10:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B23922226
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 10:46:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="rZ5N5DpI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgKTKqK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Nov 2020 05:46:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:46482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726719AbgKTKqJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Nov 2020 05:46:09 -0500
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 059382078B
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2020 10:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605869169;
        bh=BEu6BBG2DEB6J76AM/r3mx9xd3oDkzU4hZ8EL2iWSsk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rZ5N5DpIWjxaZG7qh0J1DoehjnmaQqMMubgozAjT9JuqTvwz1Ps8/zIbVhfhKJoxT
         18xQYCHlCtbi+F2GIkjAuYxU7vzQWSRIeZ2HMyiS4xR6RVX1xDW+VDkKKMsO9n8Jiv
         hvsK4us6kKVf+2dYYlYCkAJiAQmoFWO5cdw5DgUQ=
Received: by mail-oi1-f175.google.com with SMTP id q206so9894377oif.13
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2020 02:46:08 -0800 (PST)
X-Gm-Message-State: AOAM530D2adROI6xKNX9VJJ/Lb2Tj/H98Z56Nbj3JAym4wTn9xSMH4gb
        gaFmbp58nNbnFJJaEgTNDxiaM+bUw7dgepbPLWA=
X-Google-Smtp-Source: ABdhPJxW/k+q/VvYMvDo8Ws/pLVen01KHsn+NCOvpF3SgdJMtMQK+VpFtxVQUjj/CJAy8MFmBhqYtqDcjrdpAex0iYI=
X-Received: by 2002:aca:c657:: with SMTP id w84mr4096676oif.47.1605869168264;
 Fri, 20 Nov 2020 02:46:08 -0800 (PST)
MIME-Version: 1.0
References: <20201109083143.2884-1-ardb@kernel.org> <20201109083143.2884-3-ardb@kernel.org>
 <20201120034440.GA18047@gondor.apana.org.au> <CAMj1kXFd1ab2uLbQ7UvL7_+ObLGbfh=p3aRm3GhAvH0tcOYQ5g@mail.gmail.com>
 <20201120100936.GA22225@gondor.apana.org.au> <CAMj1kXGu67h96=RvVDRM2z9-N4KcvOLnr6EurjkpbPdZQfh6qw@mail.gmail.com>
 <20201120103750.GA22319@gondor.apana.org.au> <CAMj1kXFdhZ8RZp6MQVJ6bgXNoLNr3pfDBkhhVvEGuLFb1xQo3g@mail.gmail.com>
 <20201120104208.GA22365@gondor.apana.org.au> <CAMj1kXGKRU0D=oJpLOkSoEVO49dB5xTG7phP30RmMH-=U6rmZQ@mail.gmail.com>
 <20201120104532.GA22420@gondor.apana.org.au>
In-Reply-To: <20201120104532.GA22420@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 20 Nov 2020 11:45:57 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEGZT5uHJG1Q18Y5e6Qm7ZEP-07GCYSQTjzfNtAbtCWWA@mail.gmail.com>
Message-ID: <CAMj1kXEGZT5uHJG1Q18Y5e6Qm7ZEP-07GCYSQTjzfNtAbtCWWA@mail.gmail.com>
Subject: Re: [PATCH 2/3] crypto: tcrypt - permit tcrypt.ko to be builtin
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 20 Nov 2020 at 11:45, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Nov 20, 2020 at 11:43:40AM +0100, Ard Biesheuvel wrote:
> >
> > That would be an option, but since we basically already have our own
> > local 'EXPERT' option when it comes to crypto testing, I thought I'd
> > use that instead.
>
> Well that creates a loop and changing the select into a dependency
> may confuse non-expert users who actually want to use this.
>
> So I think using EXPERT is the way to go.
>

Fair enough.
