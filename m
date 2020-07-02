Return-Path: <SRS0=MdlN=AN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39176C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 07:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A9152089D
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 07:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593675655;
	bh=EveHe0K8xBsqaktkRTE0lxpkMd0h173FAJjJwFEAPpM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=cMchIpPswyVDRJGTVQ8BQxlJilmCwznM3B8PC176lEhkgUlzTHtyD+6bMeHZL0A01
	 evNVnvgui1+evGBhW5GwemYdqrvSmHTi5fIWaET0R3gElRllWmexaPoFpvTQggPlDD
	 T6ITv0/5qAn9C9SYodqVsQboOFRdUVX1iaBffULE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgGBHky (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jul 2020 03:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgGBHky (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jul 2020 03:40:54 -0400
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 220932089D
        for <linux-crypto@vger.kernel.org>; Thu,  2 Jul 2020 07:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593675654;
        bh=EveHe0K8xBsqaktkRTE0lxpkMd0h173FAJjJwFEAPpM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=v3EyZlSPUI4MTlYXse+pkjXBUsiMqL7fYL79+iQxNcnJG/brcxBm22hMxWXB4NQi5
         EKChaqFzbYmgNPhMAvFexehX3Vr4iKlzll2b3MLcb9EUprgDKM5THcu2ODLYT+8iO+
         Cb+yLogdw2Cff56N3xaXrdt3ma0KLrBmfxyOVcqE=
Received: by mail-ot1-f48.google.com with SMTP id 18so23437178otv.6
        for <linux-crypto@vger.kernel.org>; Thu, 02 Jul 2020 00:40:54 -0700 (PDT)
X-Gm-Message-State: AOAM532IDOYO9IFkQxIlx5Am92hqVsI5yOcvuzxvNtjPVbyKLsYJ3asS
        VAGvbdeVchPGvT2oIJ7xG7CgmPRv7++I/sNJO50=
X-Google-Smtp-Source: ABdhPJxz3CUHaKN2saMXFzJE8hUV+gGqIcew3DzksMoeQBxxDbWS+rRXuHJOw3VzDfdg4wScVyM69eEdQWAvyjWUXaE=
X-Received: by 2002:a9d:4a8f:: with SMTP id i15mr27349887otf.77.1593675653489;
 Thu, 02 Jul 2020 00:40:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200702043648.GA21823@gondor.apana.org.au> <CAMj1kXFKkCSf06d4eKRZvdPzxCsVsYhOjRk221XpmLxvrrdKMw@mail.gmail.com>
 <CAMj1kXGEvumaCaQivdZjTFBMMctePWuvoEupENaUbjbdiqmr8Q@mail.gmail.com>
In-Reply-To: <CAMj1kXGEvumaCaQivdZjTFBMMctePWuvoEupENaUbjbdiqmr8Q@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 2 Jul 2020 09:40:42 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGvMe_A_iQ43Pmygg9xaAM-RLy=_M=v+eg--8xNmv9P+w@mail.gmail.com>
Message-ID: <CAMj1kXGvMe_A_iQ43Pmygg9xaAM-RLy=_M=v+eg--8xNmv9P+w@mail.gmail.com>
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

On Thu, 2 Jul 2020 at 09:32, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Thu, 2 Jul 2020 at 09:27, Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > On Thu, 2 Jul 2020 at 06:36, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > >
> > > The arc4 algorithm requires storing state in the request context
> > > in order to allow more than one encrypt/decrypt operation.  As this
> > > driver does not seem to do that, it means that using it for more
> > > than one operation is broken.
> > >
> > > Fixes: eaed71a44ad9 ("crypto: caam - add ecb(*) support")
> > > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > >
> >
> > Acked-by: Ard Biesheuvel <ardb@kernel.org>
> >
> > All internal users of ecb(arc4) use sync skciphers, so this should
> > only affect user space.
> >
> > I do wonder if the others are doing any better - n2 and bcm iproc also
> > appear to keep the state in the TFM object, while I'd expect the
> > setkey() to be a simple memcpy(), and the initial state derivation to
> > be part of the encrypt flow, right?
> >
> > Maybe we should add a test for this to tcrypt, i.e., do setkey() once
> > and do two encryptions of the same input, and check whether we get
> > back the original data.
> >
>
> Actually, it seems the generic ecb(arc4) is broken as well in this regard.

This may be strictly true, but perhaps reusing the key is not such a
great idea to begin with, given the lack of an IV, so the fact that
skcipher::setkey() operates on the TFM and not the request simply does
not match the ARC4 model.

I suppose you are looking into this for chaining algif_skipcher
requests, right? So in that case, the ARC4 state should really be
treated as an IV, which is owned by the caller, and not stored in
either the TFM or the skcipher request object.
