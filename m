Return-Path: <SRS0=SwA+=7B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21085C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 17:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0995A207E8
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 17:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589910850;
	bh=BLuKHIqrK9WZLY79C4AHsafY7pqItDoXkx14zosVmsw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=CaZArovpB//Him0YW7R2DH1oaW/moBx6fYTKsqR12pOBT3STRp29iuvjHf0Xu9aul
	 AUis1XJ3NsGQ0GJvWFfRrkel8cYbXW6y+2UAK8e9BgwbIyNw026MSWkxLeaQj6E7+2
	 8GaVMz5/TJjiKIN88Uh4xnQ856atYBdLqsZ9QnZM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgESRyJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 May 2020 13:54:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727814AbgESRyJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 May 2020 13:54:09 -0400
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9991F207D3
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2020 17:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589910848;
        bh=BLuKHIqrK9WZLY79C4AHsafY7pqItDoXkx14zosVmsw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kRNUodjxV/2W4OwEQNv5CUa7vJGWbckT1ChWfuVlHCnG/4dMn/LNs7m9E6Zi6hIAI
         eAIYEboml0niZfcGEo4KIIjn+ez4NkGV+bX//XN/U6TOCUl3L+MWxBHpdXmZvxyJQ4
         8m9vAwUXtCMl0lMJV6xQQ/245sKP23ERjPV7kIGw=
Received: by mail-io1-f44.google.com with SMTP id c16so108492iol.3
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2020 10:54:08 -0700 (PDT)
X-Gm-Message-State: AOAM531pWSWHUJ9PpM9s/a8yPxECZm2c5H+43ZHr/j//hulrYLX/uD1H
        iQTMVW1c1Z12A6BKPj1fm7cIai83K527hYG/RKk=
X-Google-Smtp-Source: ABdhPJzwvs8O1yKvCltt4Xyz15ffuE8PbEUzdPrKq+FqNcIpYCN4OCun0HqH6mvvwq27uKshSrPJelwUWOl4PvctfW0=
X-Received: by 2002:a6b:5008:: with SMTP id e8mr71854iob.161.1589910848060;
 Tue, 19 May 2020 10:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <4311723.JCXmkh6OgN@tauon.chronox.de> <CAMj1kXHscmtLq=tA7zUgiNqZYgTFjfREL5EK6ZnoDCFp52GWGw@mail.gmail.com>
 <8691076.XE7dyB1q2z@tauon.chronox.de> <CAMj1kXFfY+1LcJPGw7P8RPAN+Rts2ZJQwO6++WZSTFm3qbwaww@mail.gmail.com>
In-Reply-To: <CAMj1kXFfY+1LcJPGw7P8RPAN+Rts2ZJQwO6++WZSTFm3qbwaww@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 19 May 2020 19:53:57 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEiijbgq=P53+qKjEzuneiinDbwyBacpMWtcN2YwEKWKA@mail.gmail.com>
Message-ID: <CAMj1kXEiijbgq=P53+qKjEzuneiinDbwyBacpMWtcN2YwEKWKA@mail.gmail.com>
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

On Tue, 19 May 2020 at 19:50, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Tue, 19 May 2020 at 19:35, Stephan Mueller <smueller@chronox.de> wrote:
> >
> > Am Dienstag, 19. Mai 2020, 18:21:01 CEST schrieb Ard Biesheuvel:
> >
> > Hi Ard,
> >
> > >
> > > To be honest, this looks like the API is being used incorrectly. Is
> > > this a similar issue to the one Herbert spotted recently with the CTR
> > > code?
> > >
> > > When you say 'leaving the TFM untouched' do you mean the skcipher
> > > request? The TFM should not retain any per-request state in the first
> > > place.
> > >
> > > The skcipher request struct is not meant to retain any state either -
> > > the API simply does not support incremental encryption if the input is
> > > not a multiple of the chunksize.
> > >
> > > Could you give some sample code on how you are using the API in this case?
> >
> > What I am doing technically is to allocate a new tfm and request at the
> > beginning and then reuse the TFM and request. In that sense, I think I violate
> > that constraint.
> >
> > But in order to implement such repetition, I can surely clear / allocate a new
> > TFM. But in order to get that right, I need the resulting IV after the cipher
> > operation.
> >
> > This IV that I get after the cipher operation completes is different between C
> > and CE.
> >
>
> So is the expected output IV simply the last block of ciphertext that
> was generated (as usual), but located before the truncated block in
> the output?

If so, does the below fix the encrypt case?

index cf618d8f6cec..22f190a44689 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -275,6 +275,7 @@ AES_FUNC_START(aes_cbc_cts_encrypt)
        add             x4, x0, x4
        st1             {v0.16b}, [x4]                  /* overlapping stores */
        st1             {v1.16b}, [x0]
+       st1             {v1.16b}, [x5]
        ret
 AES_FUNC_END(aes_cbc_cts_encrypt)
