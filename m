Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF185C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 12:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 813B5206D8
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 12:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595938151;
	bh=AmXXKl/FlIUjItb8aLw3JLhbBR2j2mVy1ozNhmfKOpc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=o7gt+s5UxC7wIyAcjqwNJRfLRUgZ+6qaGWX4GV9hgiMF7IbpSoc49hSiXEldActSC
	 kxaSVaK17AmJg6U3mjDC2lpy8S0xQGw3f+62HvcFpFHgS6HIi2lYBKjJ2WKjUra75m
	 LQYeQSTZAH9Nwe/wl+xAGAGNtdA19l9jKXW2kNcc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgG1MJL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 08:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728560AbgG1MJK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 08:09:10 -0400
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1397206D8
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2020 12:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595938149;
        bh=AmXXKl/FlIUjItb8aLw3JLhbBR2j2mVy1ozNhmfKOpc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ghs4lFPO10uIycZmZN5kFyKru8GCoBXDca85Eu8ZySzbouli7r0XLILUY9PzxFFuT
         EyovpYdqL1E0lXSKlCTWwiQ9pSSGOhyv/9i2tfX+OSgnMEJrqwkiDEZ552lpGmSXOA
         yVjK7OG5r3h1mlzWGwtjlhkwZ3dKNG8dnqpVaq+Q=
Received: by mail-oi1-f171.google.com with SMTP id k6so17223020oij.11
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2020 05:09:09 -0700 (PDT)
X-Gm-Message-State: AOAM532sJbnMRa/OGyH0t++69hz61yybZaxuCzPfZOM1SOWkCNBzSBXs
        wGGhnhXWeO4/QQOClI6oEE344YVrS0QBas3tjYg=
X-Google-Smtp-Source: ABdhPJx1JAeRsQBZMgnXLK7nXv2G7LT26C143ZtqvHPFrSnnekkJEMYBMgs0h3CKz4oR6xhj/NNTD2Gv28TnnaY3Vtk=
X-Received: by 2002:aca:5594:: with SMTP id j142mr3150283oib.33.1595938149210;
 Tue, 28 Jul 2020 05:09:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200728071746.GA22352@gondor.apana.org.au> <E1k0Jsq-0006I8-1l@fornost.hmeau.com>
 <CAMj1kXHoKQhMjHxsGk55xEu+FF87Bu2CGqFWPcp-G6RLUFFAHg@mail.gmail.com>
 <20200728115351.GA30933@gondor.apana.org.au> <CAMj1kXGuOiWmctpCak0beMONGAjbW=QG8tLMi+=9pTxbgX0nWQ@mail.gmail.com>
 <20200728120352.GA31012@gondor.apana.org.au>
In-Reply-To: <20200728120352.GA31012@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 28 Jul 2020 15:08:58 +0300
X-Gmail-Original-Message-ID: <CAMj1kXE-nZ9R0ObyWgRtkGoNSz7vE=KuT8+0LwYnvPEo9MpO-w@mail.gmail.com>
Message-ID: <CAMj1kXE-nZ9R0ObyWgRtkGoNSz7vE=KuT8+0LwYnvPEo9MpO-w@mail.gmail.com>
Subject: Re: [v3 PATCH 3/31] crypto: cts - Add support for chaining
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 28 Jul 2020 at 15:03, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Jul 28, 2020 at 02:59:24PM +0300, Ard Biesheuvel wrote:
> >
> > How is it malformed? Between 16 and 31 bytes of input is perfectly
> > valid for cts(cbc(aes)), and splitting it up after the first chunk
> > should be as well, no?
>
> This is the whole point of final_chunksize.  If you're going to
> do chaining then you must always withhold at least final_chunksize
> bytes until you're at the final chunk.
>
> If you disobey that then you get undefined results.
>

Ah ok, I'm with you now.

So the contract is that using CRYPTO_TFM_REQ_MORE is only permitted if
you take the final chunksize into account. If you don't use that flag,
you can ignore it.
