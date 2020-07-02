Return-Path: <SRS0=MdlN=AN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECED8C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 07:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C93A4208D5
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 07:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593675165;
	bh=kJSfYP89uUbClkFPPhvgXHwodX1WWm7NReqCREnRBzg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=pefa4reWgfBNW2FaNVMIypl2+45CatxrbPx40Hm2n4pfxjEanRImSPkmGnnMR72fb
	 ZRsI6/pKsVNL7MPGbZGcpyo1l4jFK1jWanRe/O3yVQigskQXXyD54dobBj0HSmC47B
	 oZYGwutDq3mE2udtoVYD9BsmTGLAkA0yV8/Gkhh8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgGBHcp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jul 2020 03:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726862AbgGBHco (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jul 2020 03:32:44 -0400
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F38162073E
        for <linux-crypto@vger.kernel.org>; Thu,  2 Jul 2020 07:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593675164;
        bh=kJSfYP89uUbClkFPPhvgXHwodX1WWm7NReqCREnRBzg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BGXz5/XW+VZg6HQEOAEO7uca55k2OFmUy+pPt5rwuzQ2Fz7shwqaAJ1nl+d7hZnMP
         VclmhOO319dUmeQfGcpYioTNW+PqL8PWj+XE6R7bGmx0/H9vuWygofOhiHzk35V+2R
         Q8m9w/V1dbjp7C1rQX3pFl54Mb+C6kiHdrLJlxaY=
Received: by mail-oi1-f178.google.com with SMTP id k22so11557203oib.0
        for <linux-crypto@vger.kernel.org>; Thu, 02 Jul 2020 00:32:43 -0700 (PDT)
X-Gm-Message-State: AOAM533g8GQlO1iFEQPcKVCWghGrNnThrVWHq7KwWzo+oa07BZncgm7V
        bX3/2x179qAXOn2PtXq7RvYZA+r/1Ok6DBHXQMk=
X-Google-Smtp-Source: ABdhPJxX3JY3cHcjHr/neUzPccWOit3ftpOdVrVIHhrMYWC+dtnWUZ1KOyBEzgkf0jTP9wQEx5TZa1t1YWzfuXOYvn4=
X-Received: by 2002:aca:f257:: with SMTP id q84mr9200037oih.174.1593675163373;
 Thu, 02 Jul 2020 00:32:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200702043648.GA21823@gondor.apana.org.au> <CAMj1kXFKkCSf06d4eKRZvdPzxCsVsYhOjRk221XpmLxvrrdKMw@mail.gmail.com>
In-Reply-To: <CAMj1kXFKkCSf06d4eKRZvdPzxCsVsYhOjRk221XpmLxvrrdKMw@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 2 Jul 2020 09:32:32 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGEvumaCaQivdZjTFBMMctePWuvoEupENaUbjbdiqmr8Q@mail.gmail.com>
Message-ID: <CAMj1kXGEvumaCaQivdZjTFBMMctePWuvoEupENaUbjbdiqmr8Q@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam - Remove broken arc4 support
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2 Jul 2020 at 09:27, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Thu, 2 Jul 2020 at 06:36, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > The arc4 algorithm requires storing state in the request context
> > in order to allow more than one encrypt/decrypt operation.  As this
> > driver does not seem to do that, it means that using it for more
> > than one operation is broken.
> >
> > Fixes: eaed71a44ad9 ("crypto: caam - add ecb(*) support")
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> >
>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
>
> All internal users of ecb(arc4) use sync skciphers, so this should
> only affect user space.
>
> I do wonder if the others are doing any better - n2 and bcm iproc also
> appear to keep the state in the TFM object, while I'd expect the
> setkey() to be a simple memcpy(), and the initial state derivation to
> be part of the encrypt flow, right?
>
> Maybe we should add a test for this to tcrypt, i.e., do setkey() once
> and do two encryptions of the same input, and check whether we get
> back the original data.
>

Actually, it seems the generic ecb(arc4) is broken as well in this regard.
