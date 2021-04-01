Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB0BCC43462
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Apr 2021 17:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D30661186
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Apr 2021 17:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbhDARw7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237112AbhDARu3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Apr 2021 13:50:29 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C688C005714
        for <linux-crypto@vger.kernel.org>; Thu,  1 Apr 2021 07:13:02 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id d12so3036287lfv.11
        for <linux-crypto@vger.kernel.org>; Thu, 01 Apr 2021 07:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4LRc5zlX4dmIqJZC4tRXENYZk181mewXwD7X4GEXkKA=;
        b=Vm+Tjv8EGF4ON3BmePiF+an1PklXoMoLGfZKYRESqwWronVx6WRRZIS+F6TP+Lbfr9
         c2fhhAhZk/8su55Y2QryQk7HxxWzqTdDivxWH4tQoshMJgWi+bZJvhsQdFOJrHT3LogF
         ReLuPuqCYkvLIBoIvAIP0KsgTTMVWftEFB2m1jz11/crEDOHsPcdzNSm0vmeT8TittD3
         wxip5yY2IJe+jJ1e9DNffMb2CBHe+fM+0pjqre0pvnviuVjWpxDowfLaDS073O8T2T1r
         S/Tk43FTwPTMksk0XsjA7dB2lZp93arrwSecLvBVeuX60gZ9hxIPny6zhtsP+UkF+xgk
         B/DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4LRc5zlX4dmIqJZC4tRXENYZk181mewXwD7X4GEXkKA=;
        b=DMVNdHkuwq6Rc4gZBaQ5rRHKQvqX/4bxbq8gx65OAPZRDqmIXrGa5krnOAeuG/sITy
         7wEGuFRab/C5U9yYqkgYOt/DMZO9U/zI0uhlvIOzDofMmzjL8qM6O1S3aPmPaOkYjDBz
         jWzsIjbmXQ5VyPwjLJ2DKKUsxdS3dVOLAzC5vb52zb+xYgSmoen9Ue+/LRhJ5qbVEwCa
         iYcVslMCtZUfc48G0Y0lDMrtlfaxVEybSnIKfk2dUxL4qWwr2t64FkVscXm7SlX7wzI/
         mvlSwqNly4YxlWIQyMJEwac4DY/nFttwoolAWyNuj+Js4nwFl/XVoSGMYWVyWUFNdCQg
         isyw==
X-Gm-Message-State: AOAM5317dwvJzHGcIdM5jB+how2aBQlfVo2WpO1FZmqqM6MgGRZuHbWQ
        /V6BtxNB55HSHGRTYS2aBTZTW8rJfSvPd4aLvE8PSQ==
X-Google-Smtp-Source: ABdhPJyNTkFv6LNWIK5vqvAiZQLpPg75ghn4iKbcqKm1L+mPpFDnlADouEnrSfxrIbDhgL/PNaz27oq5y6nNZioEwVg=
X-Received: by 2002:ac2:5970:: with SMTP id h16mr5350347lfp.108.1617286380737;
 Thu, 01 Apr 2021 07:13:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.56fff82362af6228372ea82e6bd7e586e23f0966.1615914058.git-series.a.fatoum@pengutronix.de>
 <CAFLxGvzWLje+_HFeb+hKNch4U1f5uypVUOuP=QrEPn_JNM+scg@mail.gmail.com>
 <ca2a7c17-3ed0-e52f-2e2f-c0f8bbe10323@pengutronix.de> <CAFLxGvwNomKOo3mQLMxYGDA8T8zN=Szpo2q5jrp4D1CaMHydWA@mail.gmail.com>
 <CAFA6WYO29o73nSg4ikU9cyaOr0kpaXFJpcGLGmFLgjKQWchcEg@mail.gmail.com>
 <1666035815.140054.1617283065549.JavaMail.zimbra@nod.at> <ea261e53-8f5d-ac52-f3b9-7f2db4532244@pengutronix.de>
 <CAFA6WYODfsMTiCEyFA2aRGm+UQE0OTe-ui7mMSK-cqUR_YJFTA@mail.gmail.com> <1846277009.140163.1617285566823.JavaMail.zimbra@nod.at>
In-Reply-To: <1846277009.140163.1617285566823.JavaMail.zimbra@nod.at>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Thu, 1 Apr 2021 19:42:49 +0530
Message-ID: <CAFA6WYNjS=1JsAPfh=j8D6HUn9rCEADyZxtWvYWuvbz_FsVbTQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/3] KEYS: trusted: Introduce support for NXP
 CAAM-based trusted keys
To:     Richard Weinberger <richard@nod.at>
Cc:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        horia geanta <horia.geanta@nxp.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        aymen sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        davem <davem@davemloft.net>,
        James Bottomley <jejb@linux.ibm.com>,
        kernel <kernel@pengutronix.de>,
        David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Udit Agarwal <udit.agarwal@nxp.com>,
        Jan Luebbe <j.luebbe@pengutronix.de>,
        david <david@sigma-star.at>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        "open list, ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 1 Apr 2021 at 19:29, Richard Weinberger <richard@nod.at> wrote:
>
> Sumit,
>
> ----- Urspr=C3=BCngliche Mail -----
> > Von: "Sumit Garg" <sumit.garg@linaro.org>
> > In this case why would one prefer to use CAAM when you have standards
> > compliant TPM-Chip which additionally offers sealing to specific PCR
> > (integrity measurement) values.
>
> I don't think we can dictate what good/sane solutions are and which are n=
ot.
> Both CAAM and TPM have pros and cons, I don't see why supporting both is =
a bad idea.

I didn't mean to say that supporting both is a bad idea but rather I
was looking for use-cases where one time selection of the best trust
source (whether it be a TPM or TEE or CAAM etc.) for a platform
wouldn't suffice for user needs.

>
> >> > IMHO allowing only one backend at the same time is a little over sim=
plified.
> >>
> >> It is, but I'd rather leave this until it's actually needed.
> >> What can be done now is adopting a format for the exported keys that w=
ould
> >> make this extension seamless in future.
> >>
> >
> > +1
>
> As long we don't make multiple backends at runtime impossible I'm
> fine and will happily add support for it when needed. :-)
>

You are most welcome to add such support. I will be happy to review it.

-Sumit

> Thanks,
> //richard
