Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D72C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Mar 2021 07:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1674E64FB5
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Mar 2021 07:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhCQHk3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Mar 2021 03:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhCQHkG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Mar 2021 03:40:06 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FBAC061763
        for <linux-crypto@vger.kernel.org>; Wed, 17 Mar 2021 00:40:06 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id f16so1979262ljm.1
        for <linux-crypto@vger.kernel.org>; Wed, 17 Mar 2021 00:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iObzIxFvftTdKH1/yXifJjIJYlGMiIva4oZnIqTHzmM=;
        b=ZX9iixsaVwsqr/Cn1A2WeoWoFrumH7sNtxSYawUL91Lphse0MaPfjacqjM1FDqo5NV
         bAiKDQJaSGz8eQYBN13LKfX3quYfLXHo06AKoEXrU/lwTNqcjKeZJITR936O79VQUhI6
         wobMISUTMmR4vRvl+SKxW9AWPCf4zKqBsL+w/IbYyVN/yTUpMOLeId+WA+mlkBmeuAfT
         SR6z4Mx3EcIwnv9OPgV9OMrbBmDQxsgYRPycRLcC3dtH0VHkmwD+z9Zc6xICnfWyuCGQ
         b3W1JCznoQqe9WgRzA4SyoIn3U+7fBtfqpAO6ndTTp+GB7kTenXE1vAdmc5JnfW18Ni6
         Usog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iObzIxFvftTdKH1/yXifJjIJYlGMiIva4oZnIqTHzmM=;
        b=e1jiJM1Rw+n2oEm4w65V9uMK1MvGACt17WRHD/tp4JPy6s0v1YmXBxNBZ+oMzh/Oiv
         fn7ziCgJxoZfbXLAvXIbJ2m956fpI7X0fe+2s4HYTShJBX2T7PJnRZNBm2Nv9c5vzxhE
         juaWKWvrgZl06dHlSyqEMdNQmwgcv4ZdEfU5/9aHbYhNwzmtO5JYzDAi6Zv5O06z1FWf
         C/sNN7Euve/DyRoCZloZLw4P4RblG/SOUboNtIt3HXqz0ue0pTxwqhXyqRj6l2AG34Sq
         MLt9LBdyrO8vl3oVR+lr8ECmH3X1140LaBakC0sN5dvHadeI/b9NN3Ld1oy4tJPkuWmW
         5gHQ==
X-Gm-Message-State: AOAM530Leo+fIiGQX1PFxv+SYytQF91b3LyDoeXuTgrR2cXTlD7cWCof
        iImFMBmXmM9o/KcNTmLyrllHZin5ZMMKJQu9AOmdjw==
X-Google-Smtp-Source: ABdhPJxkZg9XDXYoY6hqQYdLLQExVMsp4ITka98+Ps8S1hFlsNeIPJBrvg4kY7aeSo/+tIGP5LduAXhwxBknckTLNck=
X-Received: by 2002:a05:651c:481:: with SMTP id s1mr1539339ljc.152.1615966804665;
 Wed, 17 Mar 2021 00:40:04 -0700 (PDT)
MIME-Version: 1.0
References: <cover.56fff82362af6228372ea82e6bd7e586e23f0966.1615914058.git-series.a.fatoum@pengutronix.de>
 <319e558e1bd19b80ad6447c167a2c3942bdafea2.1615914058.git-series.a.fatoum@pengutronix.de>
 <CAFLxGvxmRcvkweGSRSLGEm5MJDM4M7nzkp9FwOwmhZ+h2RE0vA@mail.gmail.com>
In-Reply-To: <CAFLxGvxmRcvkweGSRSLGEm5MJDM4M7nzkp9FwOwmhZ+h2RE0vA@mail.gmail.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Wed, 17 Mar 2021 13:09:53 +0530
Message-ID: <CAFA6WYNyMzQJNhGds2Ff9waF6mAr_0E-izXA2GBooTJgVDp-3A@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] KEYS: trusted: Introduce support for NXP
 CAAM-based trusted keys
To:     Richard Weinberger <richard.weinberger@gmail.com>
Cc:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        James Bottomley <jejb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>, kernel@pengutronix.de,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Agarwal <udit.agarwal@nxp.com>,
        Jan Luebbe <j.luebbe@penutronix.de>,
        David Gstir <david@sigma-star.at>,
        Franck LENORMAND <franck.lenormand@nxp.com>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Richard,

On Wed, 17 Mar 2021 at 04:45, Richard Weinberger
<richard.weinberger@gmail.com> wrote:
>
> Ahmad,
>
> On Tue, Mar 16, 2021 at 6:24 PM Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
> > +#include <keys/trusted_caam.h>
> > +#include <keys/trusted-type.h>
> > +#include <linux/build_bug.h>
> > +#include <linux/key-type.h>
> > +#include <soc/fsl/caam-blob.h>
> > +
> > +struct caam_blob_priv *blobifier;
>
> Who is using this pointer too?
> Otherwise I'd suggest marking it static.
>
> >  module_param_named(source, trusted_key_source, charp, 0);
> > -MODULE_PARM_DESC(source, "Select trusted keys source (tpm or tee)");
> > +MODULE_PARM_DESC(source, "Select trusted keys source (tpm, tee or caam)");
>
> I didn't closely follow the previous discussions, but is a module
> parameter really the right approach?
> Is there also a way to set it via something like device tree?
>

It's there to support a platform which possesses multiple trusted keys
backends. So that a user is able to select during boot which one to
use as a backend.

-Sumit

> --
> Thanks,
> //richard
