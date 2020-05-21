Return-Path: <SRS0=cmAM=7D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39ABC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 May 2020 13:23:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94CF020671
	for <linux-crypto@archiver.kernel.org>; Thu, 21 May 2020 13:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590067434;
	bh=RheZr/ACF50PLrTLkwoyqU2PDIsZGaDPXMpYDueZCDU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Kvi2dnDs5YrRgTm7AZ4sKmUvBEhEDb+Lg6rmdi7sjSGzETv9w6cqOmGn38+GvjV5b
	 kSYNAcYbulsf9qGV8TfuaPHzrsSqlR3/sjWEbPKGwEGO3cn8t3K4gpVahy0LcrkPjw
	 SWa99TGxpwrJJm8P3EUJQr/8tlrEF3oNxe2e+p9I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729372AbgEUNXy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 May 2020 09:23:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:32822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729352AbgEUNXx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 May 2020 09:23:53 -0400
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3646207F9
        for <linux-crypto@vger.kernel.org>; Thu, 21 May 2020 13:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590067432;
        bh=RheZr/ACF50PLrTLkwoyqU2PDIsZGaDPXMpYDueZCDU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fsUEuLUMqHtuRSm/PyyGYHOzY1/CvCuc1NTmkHUzg5VCgrJTLSjC6XkJMic3/S3U/
         ZdihNuqxFeF0qLkJ0xxQz0dStFzD4nrNsIi9R0H1hKyGIk9JjHNN+1NOR9nYe2AiyO
         d47LTKjkWBXyyd6YWUl0f8f65tb1iTVqlrEfPRlw=
Received: by mail-io1-f51.google.com with SMTP id e18so7364329iog.9
        for <linux-crypto@vger.kernel.org>; Thu, 21 May 2020 06:23:52 -0700 (PDT)
X-Gm-Message-State: AOAM531fPkT8qVi1gQ+KUK+QOem7VbNzWsomgyuPapWZDFDNLg4bl3nh
        H8u6mgrn3kbLPWfEZNK+/X+iVXB5c1CjvS1VBM8=
X-Google-Smtp-Source: ABdhPJwaIQMUfYp1lPhoz8vPxi1MQQFHmLWewLp0OWy6/cyhVbyU0V/aHNV2+SpXxkAeotpL1k1aqpoqE45s6N8cffQ=
X-Received: by 2002:a05:6638:dc3:: with SMTP id m3mr3675051jaj.98.1590067432179;
 Thu, 21 May 2020 06:23:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200519190211.76855-1-ardb@kernel.org> <16394356.0UTfFWEGjO@tauon.chronox.de>
 <CAMj1kXF=Duh1AsAQy+aLWMcJPQ4RFL5p9-Mnmn-XAiCkzyGFbg@mail.gmail.com>
 <2010567.jSmZeKYv2B@tauon.chronox.de> <CAMj1kXGNqo=d-hgK=0zBZCoJYgSxxhhm=Jdk2gAGXPo1-KSCgA@mail.gmail.com>
 <CAOtvUMc8PhToLDVO+Y4NVhVkA6B7yndp3gbaeaQZJtrW_NSzaw@mail.gmail.com>
In-Reply-To: <CAOtvUMc8PhToLDVO+Y4NVhVkA6B7yndp3gbaeaQZJtrW_NSzaw@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 21 May 2020 15:23:41 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFJJcg-YeSw+_FDfyOvjQTJ6w1YyKqWaxCWSjDhRLEDoA@mail.gmail.com>
Message-ID: <CAMj1kXFJJcg-YeSw+_FDfyOvjQTJ6w1YyKqWaxCWSjDhRLEDoA@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH 0/2] crypto: add CTS output IVs for arm64 and testmgr
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 21 May 2020 at 15:01, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>
> Hi Ard,
>
> Thank you for looping me in.
>
> On Wed, May 20, 2020 at 10:09 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > On Wed, 20 May 2020 at 09:01, Stephan Mueller <smueller@chronox.de> wrote:
> > >
> > > Am Mittwoch, 20. Mai 2020, 08:54:10 CEST schrieb Ard Biesheuvel:
> > >
> > > Hi Ard,
> > >
> > > > On Wed, 20 May 2020 at 08:47, Stephan Mueller <smueller@chronox.de> wrote:
> > ...
> > > > > The state of all block chaining modes we currently have is defined with
> > > > > the
> > > > > IV. That is the reason why I mentioned it can be implemented stateless
> > > > > when I am able to get the IV output from the previous operation.
> > > >
> > > > But it is simply the same as the penultimate block of ciphertext. So
> > > > you can simply capture it after encrypt, or before decrypt. There is
> > > > really no need to rely on the CTS transformation to pass it back to
> > > > you via the buffer that is only specified to provide an input to the
> > > > CTS transform.
> > >
> > > Let me recheck that as I am not fully sure on that one. But if it can be
> > > handled that way, it would make life easier.
> >
> > Please refer to patch 2. The .iv_out test vectors were all simply
> > copied from the appropriate offset into the associated .ctext member.
>
> Not surprisingly since to the best of my understanding this behaviour
> is not strictly specified, ccree currently fails the IV output check
> with the 2nd version of the patch.
>

That is what I suspected, hence the cc:

> If I understand you correctly, the expected output IV is simply the
> next to last block of the ciphertext?

Yes. But this happens to work for the generic case because the CTS
driver itself requires the encapsulated CBC mode to return the output
IV, which is simply passed through back to the caller. CTS mode itself
does not specify any kind of output IV, so we should not rely on this
behavior.
