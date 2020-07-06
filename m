Return-Path: <SRS0=JF+M=AR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 369B2C433DF
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jul 2020 13:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F76820724
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jul 2020 13:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594042990;
	bh=qhCTsrFH8RC+7yeFmbNJ7M71AHDtyoJeMzRWtXxIvAE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=a0sjRuzFbpl4yC2F0oASOxYpv3/l4f5VmmSjdUaI/7RuJ/sszBiffoAUXOuyjeOM0
	 NGnKA9eJLYIGCQbeLWSbFgbp5gZ8RnqKdjuXl7fPRJ/vvmBQ+vVfgYcL/Dw9xcVbgE
	 ri4qrNjfSfzZwWIKiSrpgWf0rYOZ2j6HipHZZL+I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbgGFNnJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Jul 2020 09:43:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729054AbgGFNnJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Jul 2020 09:43:09 -0400
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6E6C20702
        for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2020 13:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594042988;
        bh=qhCTsrFH8RC+7yeFmbNJ7M71AHDtyoJeMzRWtXxIvAE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pUGJSHTNYXaLDfeq6SCZTMJgHumhhaz5mRk/hbEK5OxeWXCdSGSraECEOlQMdWt9b
         dhtczAeIO47j90WG2/scOTecVb6KabQ1fyvB4EtHzkR+KB0640K1YbeAW95qVN9NZO
         ssCZXu0cw3UD4KTTjl4gbpp083w9vAXE1R01ZmzI=
Received: by mail-oo1-f50.google.com with SMTP id d125so3935218oob.0
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2020 06:43:08 -0700 (PDT)
X-Gm-Message-State: AOAM532CtemeopySr1IAjDXeAx5dM95vtmQay5ov7LLhU4wnlQYOj6zJ
        kZN/yax+vvXwOdlomFEqn9KAxM28atkgt9PqiGA=
X-Google-Smtp-Source: ABdhPJxB2AqBNWChFnkyHNt1KYdNotaFHn2eZAHBXz/O+Cajni1tsj6ZLGLDRjlijJ7hGJkeOGB3rsZBVEz2ITGrRxQ=
X-Received: by 2002:a4a:de8d:: with SMTP id v13mr19810631oou.45.1594042988075;
 Mon, 06 Jul 2020 06:43:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200702043648.GA21823@gondor.apana.org.au> <31734e86-951a-6063-942a-1d62abeb5490@nxp.com>
In-Reply-To: <31734e86-951a-6063-942a-1d62abeb5490@nxp.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 6 Jul 2020 16:42:56 +0300
X-Gmail-Original-Message-ID: <CAMj1kXGK3v+YWd6E8zNP-tKWgq+aim7X67Ze4Bxrent4hndECw@mail.gmail.com>
Message-ID: <CAMj1kXGK3v+YWd6E8zNP-tKWgq+aim7X67Ze4Bxrent4hndECw@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam - Remove broken arc4 support
To:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 5 Jul 2020 at 22:11, Horia Geant=C4=83 <horia.geanta@nxp.com> wrote=
:
>
> On 7/2/2020 7:36 AM, Herbert Xu wrote:
> > The arc4 algorithm requires storing state in the request context
> > in order to allow more than one encrypt/decrypt operation.  As this
> > driver does not seem to do that, it means that using it for more
> > than one operation is broken.
> >
> The fact that smth. is broken doesn't necessarily means it has to be remo=
ved.
>
> Looking at the HW capabilities, I am sure the implementation could be
> modified to save/restore the internal state to/from the request context.
>
> Anyhow I would like to know if only the correctness is being debated,
> or this patch should be dealt with in the larger context of
> removing crypto API based ecb(arc4) altogether:
> [RFC PATCH 0/7] crypto: get rid of ecb(arc4)
> https://lore.kernel.org/linux-crypto/20200702101947.682-1-ardb@kernel.org=
/
>

The problem with 'fixing' ecb(arc4) is that it will make it less
secure than it already is. For instance, imagine two peers using the
generic ecb(arc4) implementation, and using a pair of skcipher TFMs to
en/decrypt the communication between them, similar to how the WEP code
works today. if we 'fix' the implementation, every request will be
served from the same initial state (including the key), and therefore
reuse the same keystream, resulting in catastrophic failure. (Of
course, the code should set a different key for each request anyway,
but failure to do so does not result in the same security fail with
the current implementation)

So the problem is really that the lack of a key vs IV distinction in
ARC4 means that it does not fit the skcipher model cleanly, and
issuing more than a single request without an intermediate setkey()
operation should be forbidden in any case.

The reason I suggested removing it is that we really have no use for
it in the kernel, and the only known af_alg users are dubious as well,
and so we'd be much better off simply getting rid of ecb(arc4)
entirely, not because any of the implementations are flawed, but
simply because I don't think we should waste more time on it in
general.
