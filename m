Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93099C38142
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Jan 2023 10:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjASKNW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Jan 2023 05:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjASKNV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Jan 2023 05:13:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D694C76AA
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jan 2023 02:13:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FF7261444
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jan 2023 10:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9707C433D2
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jan 2023 10:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674123199;
        bh=yuRMCUSnQCLZiqOi6+BEu50V0tUva5H8OvTeArASwkk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tqVaIrFNobOzWrXcppGINxeh4zUJhqykm/LMwB4z/C9bJqXMU/QRWESWf6wkf9ILZ
         giBKpJ6zMbCTfoSwJYHc57DfNeh0sSwFUyBPz422SotNrRLeSZT8Pvy7KUnO3oNMcJ
         8MaYm24SzEtd4ffyw7uMXr2rcG+q77Pr+PiLDGzWDs44AQPfab6mL9qy9100sKClDt
         l4ejqWgd9bYeTlzmEvEgiiCLexHmmQTJ7HPF2XYgWRBPky9XxmMceJswuLr78eHoSX
         RFSqAZWAl7CA26CdfDap5ofanBm8QrX2Tpn8nyVyMRIaXC05/KKd2vmMCj/gXaZTec
         742hfsV/HFThQ==
Received: by mail-lf1-f45.google.com with SMTP id f34so2483789lfv.10
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jan 2023 02:13:19 -0800 (PST)
X-Gm-Message-State: AFqh2kqg0D2t7T+fwFMNqlBh/YKyfXbgIns1vbrMNJig/SfWdmXcTTnj
        lCJvzq1W+BL3x0KnXFewkgRgVx0T60eLrp/cgLY=
X-Google-Smtp-Source: AMrXdXuYNOouniC/+yfxFssc8dNrgXiIKrz8VyE90e/DsPFj1eoUWDTW6wg6LQSM5ad04COXlKhUBNmt5qnyn0K35ks=
X-Received: by 2002:ac2:4ade:0:b0:4d0:7b7:65dc with SMTP id
 m30-20020ac24ade000000b004d007b765dcmr460658lfp.122.1674123197789; Thu, 19
 Jan 2023 02:13:17 -0800 (PST)
MIME-Version: 1.0
References: <Y8kInrsuWybCTgK0@gondor.apana.org.au> <CAMj1kXGPqHsHSkj+hV_AcwPZxmWMi_=sVBHQWckUPomh6D7uGg@mail.gmail.com>
 <Y8kUJZfZ1+wQnMO0@gondor.apana.org.au>
In-Reply-To: <Y8kUJZfZ1+wQnMO0@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 19 Jan 2023 11:13:06 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEtptbEz=zr8bRrcLsxqkCSxeap=7XOcqAdWw14G9wHyg@mail.gmail.com>
Message-ID: <CAMj1kXEtptbEz=zr8bRrcLsxqkCSxeap=7XOcqAdWw14G9wHyg@mail.gmail.com>
Subject: Re: [PATCH] crypto: xts - Handle EBUSY correctly
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 19 Jan 2023 at 10:58, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jan 19, 2023 at 10:50:26AM +0100, Ard Biesheuvel wrote:
> > On Thu, 19 Jan 2023 at 10:08, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > >
> > > As it is xts only handles the special return value of EINPROGERSS,
> >
> > EINPROGRESS
>
> Thanks, I will fix this.
>
> > > -               rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
> > > +               rctx->subreq.base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
> >
> > I don't get this bit. We used to preserve CRYPTO_TFM_REQ_MAY_BACKLOG
> > before (along with all other flags except MAY_SLEEP), but now, we
> > *only* preserve CRYPTO_TFM_REQ_MAY_BACKLOG.
>
> This change is just in case we introduce any more flags in
> future that we may not wish to pass along (as this code knows
> nothing about it).
>
> > So how is this related? Why are we clearing
> > CRYPTO_TFM_REQ_FORBID_WEAK_KEYS here for instance?
>
> WEAK_KEYS is only defined for setkey.  Only MAY_SLEEP and MAY_BACKLOG
> are currently meaningful for encryption and decryption.
>

Fair enough.

> > Apologies for the noob questions about this aspect of the crypto API,
> > but I suppose this means that, if CRYPTO_TFM_REQ_MAY_BACKLOG was
> > specified, it is up to the skcipher implementation to queue up the
> > request and return -EBUSY, as opposed to starting the request
> > asynchronously and returning -EINPROGRESS?
> >
> > So why the distinction? If the skcipher signals that the request is
> > accepted and will complete asynchronously, couldn't it use EINPROGRESS
> > for both cases? Or is the EBUSY interpreted differently by the caller,
> > for providing back pressure to the source?
>
> EBUSY signals to the caller that it must back off and not issue
> any more requests.  The caller should wait for a completion call
> with EINPROGRESS to indicate that it may issue new requests.
>
> For xts we essentially ignore EBUSY at this point, and assume that
> if our own caller issued any more requests it would directly get
> an EBUSY which should be sufficient to avoid total collapse.
>

Ah right - the request is only split across two calls into the
underlying skcipher if CTS is needed, and otherwise, we just forward
whatever non-zero return value we received.

Thanks for the explanation.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
