Return-Path: <SRS0=SwA+=7B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0765DC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 17:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B60FC20674
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 17:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589910636;
	bh=0BZRhxHinA0YPEXg7pD4vsgU15bnQZ2vQQ8PJauOyUc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=XFZ5u8LX8Rgs/0w4yjq8paLc5WBN9uHYPMw5rWzXUSvRBqxSoXRAddopDUCgP6jxF
	 ViQZ5wL0QKNq87OQTIN4mF8EyYDWDyb8P1qp7PnASwxdZmmSfzZ5b63OuHEkpyUrxr
	 77j01PtI9YcQ8ATA4XwvWgo1pKiissXDE0zO94hA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbgESRug (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 May 2020 13:50:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbgESRug (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 May 2020 13:50:36 -0400
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75E1D207D8
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2020 17:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589910635;
        bh=0BZRhxHinA0YPEXg7pD4vsgU15bnQZ2vQQ8PJauOyUc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=M7VCm6AqtHVdqaWYlxaqBmsEi/lF5DrDHd9LO85N8OOdVsbl3wA0x73vO8VjHWG2Z
         rOtN0wu2Zzto9vb5lgKjiWfRdJk8x0qmjexcfT5wmdHCl3sDYpvj5rT9bYlDhFyLuG
         NgTwo72hCnMGHzy6t+hjT3f6TIyuQRT6DMiuJ7sE=
Received: by mail-io1-f54.google.com with SMTP id f3so110692ioj.1
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2020 10:50:35 -0700 (PDT)
X-Gm-Message-State: AOAM532oC3YRHQiSt1qVgOVfQA3mDuZ4rU2sSS2srIi2EH5zGfu/mPrv
        VghtS8X9mEhBB0pGw53CE9KUwmdLIxuKvx/NauY=
X-Google-Smtp-Source: ABdhPJwDyxx5So0qypJ9UYS57HEUzcxYOr4922yULg8vI1YZkot+RA72oe/iFrJQ2O3SmY67FJlyVqdzvTWG26nBDJM=
X-Received: by 2002:a02:c48b:: with SMTP id t11mr806385jam.71.1589910634855;
 Tue, 19 May 2020 10:50:34 -0700 (PDT)
MIME-Version: 1.0
References: <4311723.JCXmkh6OgN@tauon.chronox.de> <CAMj1kXHscmtLq=tA7zUgiNqZYgTFjfREL5EK6ZnoDCFp52GWGw@mail.gmail.com>
 <8691076.XE7dyB1q2z@tauon.chronox.de>
In-Reply-To: <8691076.XE7dyB1q2z@tauon.chronox.de>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 19 May 2020 19:50:23 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFfY+1LcJPGw7P8RPAN+Rts2ZJQwO6++WZSTFm3qbwaww@mail.gmail.com>
Message-ID: <CAMj1kXFfY+1LcJPGw7P8RPAN+Rts2ZJQwO6++WZSTFm3qbwaww@mail.gmail.com>
Subject: Re: ARM CE: CTS IV handling
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 19 May 2020 at 19:35, Stephan Mueller <smueller@chronox.de> wrote:
>
> Am Dienstag, 19. Mai 2020, 18:21:01 CEST schrieb Ard Biesheuvel:
>
> Hi Ard,
>
> >
> > To be honest, this looks like the API is being used incorrectly. Is
> > this a similar issue to the one Herbert spotted recently with the CTR
> > code?
> >
> > When you say 'leaving the TFM untouched' do you mean the skcipher
> > request? The TFM should not retain any per-request state in the first
> > place.
> >
> > The skcipher request struct is not meant to retain any state either -
> > the API simply does not support incremental encryption if the input is
> > not a multiple of the chunksize.
> >
> > Could you give some sample code on how you are using the API in this case?
>
> What I am doing technically is to allocate a new tfm and request at the
> beginning and then reuse the TFM and request. In that sense, I think I violate
> that constraint.
>
> But in order to implement such repetition, I can surely clear / allocate a new
> TFM. But in order to get that right, I need the resulting IV after the cipher
> operation.
>
> This IV that I get after the cipher operation completes is different between C
> and CE.
>

So is the expected output IV simply the last block of ciphertext that
was generated (as usual), but located before the truncated block in
the output?
