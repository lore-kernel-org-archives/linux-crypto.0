Return-Path: <SRS0=/E9c=A4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69DC4C433E1
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jul 2020 06:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DB4F20737
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jul 2020 06:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594965608;
	bh=nDlcatnihjXgL75WM8FXrcekQEwTRJfFlIAKwbXs0/w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=JUukJ2CH+eidxbrBFjWHublNJUDbaMf9gvxFpWSCID5LvQkXxrlI/ObIEbYXwFn0B
	 Jgnb42DnTpzuJC8BR4R27gp4tWoZ6jS5ikHTTQZUkLP3nsp3ymUG/rb+owGVH+P4bX
	 ehdUi34ToRAkoPcH/ibVjYYubuvU4VQzkYPet6qM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgGQGAH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Jul 2020 02:00:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbgGQGAH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Jul 2020 02:00:07 -0400
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F01420737;
        Fri, 17 Jul 2020 06:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594965606;
        bh=nDlcatnihjXgL75WM8FXrcekQEwTRJfFlIAKwbXs0/w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IaUCILrvraR8PKoiNxnu3+ZOtkR0nxOKwjLSKtEMJCJlto/Q+dhVfkvVckdEfvoRc
         +5/lpA0RXkmp5cRvSyu3Td+4xAA3sFn0uG8te4lQBAcmQR0Q1cCcRxvP2u4CcPWj+C
         98CLG5tvBoUa/9zxcza46M3XJFw6kYv9AK74g1P0=
Received: by mail-oi1-f174.google.com with SMTP id t4so7116079oij.9;
        Thu, 16 Jul 2020 23:00:06 -0700 (PDT)
X-Gm-Message-State: AOAM533fbQyU3J1J18UCo4AwcoSTmcsh8dCDL4kdJ4Y6+hFmS1j748dE
        Q7B0qJtzOV/1SomR6KjDAlAdOijLq3P3txo/vUQ=
X-Google-Smtp-Source: ABdhPJx5gqnSC4TPhFGG+TsY7j//bGPfkIXQPOIxUazCXvguYVi8naJtG0rhVajNgxKxD7Txjef7Nu1OMcyDNVGD/EE=
X-Received: by 2002:aca:d643:: with SMTP id n64mr6421709oig.33.1594965605971;
 Thu, 16 Jul 2020 23:00:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200716152900.1709694-1-colin.king@canonical.com>
 <CAMj1kXEWyweZ0E3WHthEG9oiOpOS9UxtTB7xskAsF8FeinNg9w@mail.gmail.com> <20200717052139.GB2045@gondor.apana.org.au>
In-Reply-To: <20200717052139.GB2045@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 17 Jul 2020 08:59:54 +0300
X-Gmail-Original-Message-ID: <CAMj1kXH9PHNNUMgwNUv8gBJDxs8w5Eta=AouKM7L=hMWNOQ=HQ@mail.gmail.com>
Message-ID: <CAMj1kXH9PHNNUMgwNUv8gBJDxs8w5Eta=AouKM7L=hMWNOQ=HQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: xts: use memmove to avoid overlapped memory copy
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 17 Jul 2020 at 08:21, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jul 16, 2020 at 06:56:30PM +0300, Ard Biesheuvel wrote:
> > On Thu, 16 Jul 2020 at 18:29, Colin King <colin.king@canonical.com> wrote:
> > >
> > > From: Colin Ian King <colin.king@canonical.com>
> > >
> > > There is a memcpy that performs a potential overlapped memory copy
> > > from source b to destination b + 1.  Fix this by using the safer
> > > memmove instead.
> > >
> > > Addresses-Coverity: ("Overlapping buffer in memory copy")
> > > Fixes: 8083b1bf8163 ("crypto: xts - add support for ciphertext stealing")
> > > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > > ---
> > >  crypto/xts.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/crypto/xts.c b/crypto/xts.c
> > > index 3565f3b863a6..fa3e6e7b7043 100644
> > > --- a/crypto/xts.c
> > > +++ b/crypto/xts.c
> > > @@ -169,7 +169,7 @@ static int cts_final(struct skcipher_request *req,
> > >                                       offset - XTS_BLOCK_SIZE);
> > >
> > >         scatterwalk_map_and_copy(b, rctx->tail, 0, XTS_BLOCK_SIZE, 0);
> > > -       memcpy(b + 1, b, tail);
> > > +       memmove(b + 1, b, tail);
> >
> > This is a false positive: tail is guaranteed to be smaller than
> > sizeof(*b), so memmove() is unnecessary here.
> >
> > If changing to memcpy(&b[1], &b[0], tail) makes the warning go away, i
> > am fine with it, but otherwise we should just leave it as is.
>
> How about a comment perhaps?
>

Or change it to b[1] = b[0] (assuming the compiler allows struct
assignment in that way). This will always copy XTS_BLOCK_SIZE bytes,
but we have sufficient space, and it is probably more efficient  too
in most cases.


> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
