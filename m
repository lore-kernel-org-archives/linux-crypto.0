Return-Path: <SRS0=gCBe=74=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32EC2C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 07:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14FB02068E
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 07:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592207469;
	bh=HVJmlSThtvab+c0WpB/Hb1sK+1nO5IfjJIkYMy+ovX0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=N9UCxdp3kohWJ1FsMdDXBE+jeNbiB3qZAdYhXrDTBgGOKYWMHiL6Y8JFDfV0xfPdc
	 HEO/fIDIOA7ky3RrgAbfNsCQzchQs+kwTmcuYMhZlYZp6GT2g79IOUtXOuTVrpZXQ6
	 W2M78V5Ba06lqs1wxFe0bsBRmTfnq1iouWo/+BG4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbgFOHvH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jun 2020 03:51:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729129AbgFOHvE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jun 2020 03:51:04 -0400
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F7D42076A
        for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2020 07:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592207463;
        bh=HVJmlSThtvab+c0WpB/Hb1sK+1nO5IfjJIkYMy+ovX0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=b/qGULM6pPNI6MKC/EepNLcZjE+7/1yVOlYRhA1/pINLuHvw4PnwSM7bEEeN/FjxD
         ysNsJRj0z1b0WtRgsjvm9/+oKMVgH6c4kFs2S8b00eaaYEV25Kks/cWYPd5k/1o1bt
         /WUfpLoCO4XZPFPEy7WkJfX7y2Xapt356f55oCxM=
Received: by mail-oi1-f171.google.com with SMTP id j189so15033675oih.10
        for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2020 00:51:03 -0700 (PDT)
X-Gm-Message-State: AOAM531ut8PgeQQAQoHDNpmsTdlqwP/+oW5fH1pK6wwZHN4h75qTFWuH
        59852gEzuw0KIw8ekjhSOAzC/VCm9lgSMfe/r04=
X-Google-Smtp-Source: ABdhPJzTflZwW4WefQFVgwd0ElyI22B1TYA8XpUveJlfskQBRzb/WTAxkMvvqfoctKzHMRwnka9iXqs3T/sUXG2+zqw=
X-Received: by 2002:aca:ba03:: with SMTP id k3mr1546578oif.33.1592207462445;
 Mon, 15 Jun 2020 00:51:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200612120643.GA15724@gondor.apana.org.au> <E1jjiTA-0005BO-9n@fornost.hmeau.com>
 <1688262.LSb4nGpegl@tauon.chronox.de> <20200612121651.GA15849@gondor.apana.org.au>
 <20200612122105.GA18892@gondor.apana.org.au> <CAMj1kXGg25JL7WCrspMwB1PVPX6vx-rOCesg08a_Fy26_ET7Sg@mail.gmail.com>
 <20200615073024.GA27015@gondor.apana.org.au>
In-Reply-To: <20200615073024.GA27015@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 15 Jun 2020 09:50:50 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHQNHh4PTLmGKaL+sSyuU1AS4u5F=OyjV6XuAaD21e6yg@mail.gmail.com>
Message-ID: <CAMj1kXHQNHh4PTLmGKaL+sSyuU1AS4u5F=OyjV6XuAaD21e6yg@mail.gmail.com>
Subject: Re: [v2 PATCH 0/3] crypto: skcipher - Add support for no chaining and
 partial chaining
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 15 Jun 2020 at 09:30, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Jun 12, 2020 at 06:10:57PM +0200, Ard Biesheuvel wrote:
> >
> > First of all, the default fcsize for all existing XTS implementations
> > should be -1 as well, given that chaining is currently not supported
> > at all at the sckipher interface layer for any of them (due to the
> > fact that the IV gets encrypted with a different key at the start of
>
> Sure.  I was just too lazy to actually set the -1 everywhere.  I'll
> try to do that before I repost again.
>

Fair enough

> > the operation). This also means it is going to be rather tricky to
> > implement for h/w accelerated XTS implementations, and it seems to me
> > that the only way to deal with this is to decrypt the IV in software
> > before chaining the next operation, which is rather horrid and needs
> > to be implemented by all of them.
>
> I don't think we should support chaining for XTS at all so I don't
> see why we need to worry about the hardware accelerated XTS code.
>

I would prefer that. But if it is fine to disallow chaining altogether
for XTS, why can't we do the same for cbc-cts? In both cases, user
space cannot be relying on it today, since the output is incorrect,
even for inputs that are a round multiple of the block size but are
broken up and chained.

> > Given that
> >
> > a) this is wholly an AF_ALG issue, as there are no in-kernel users
> > currently suffering from this afaik,
> > b) using AF_ALG to get access to software implementations is rather
> > pointless in general, given that userspace can simply issue the same
> > instructions directly
> > c) fixing all XTS and CTS implementation on all arches and all
> > accelerators is not a small task
> >
> > wouldn't it be better to special case XTS and CBC-CTS in
> > algif_skcipher instead, rather than polluting the skipcher API this
> > way?
>
> As I said we need to be able to differentiate between the ones
> that can chain vs. the ones that can't.  Putting this knowledge
> directly into algif_skcipher is just too horrid.
>

No disagreement on the horrid. But polluting the API for an issue that
only affects AF_ALG, which can't possibly be working as expected right
now is not a great thing either.

> The alternative is to add this marker into the algorithms.  My
> point was that if you're going to do that you might as well go
> a step further and allow cts to chain as it is so straightforward.
>

Given the fact that algos that require chaining are broken today and
nobody noticed until Stephan started relying on the skcipher request
object's IV field magically retaining its value on subsequent reuse, I
would prefer it if we could simply mark all of them as non-chainable
and be done with it. (Note that Stephan's case was invalid to begin
with)
