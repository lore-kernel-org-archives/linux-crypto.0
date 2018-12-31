Return-Path: <SRS0=0edi=PI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33870C43387
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Dec 2018 10:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00B0D21019
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Dec 2018 10:36:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="G8jMahm9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbeLaKgF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Dec 2018 05:36:05 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:47074 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbeLaKgF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Dec 2018 05:36:05 -0500
Received: by mail-ua1-f67.google.com with SMTP id v24so8532613uap.13
        for <linux-crypto@vger.kernel.org>; Mon, 31 Dec 2018 02:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=txygF5LLaDLoD69gg1L3SgX5YRCduvW+Ym9nSXuZ4rc=;
        b=G8jMahm9IJERMcOEXWFX66BVSPz67+MWSu7YgvBNi2AvvHeJJFcpdea0Z5gNaFX3o3
         A4l0mkV5Dp36+6fTlydAK/G8HjsUP8nOGDbvr8db3HRqWPdns2NXu4xrp6hDnxv1vfHd
         CPRJzEO99LAr1nn2MogB+8AQZ+7UP5tMOLi9c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=txygF5LLaDLoD69gg1L3SgX5YRCduvW+Ym9nSXuZ4rc=;
        b=jQh58+UkFTFcDljoanXItRI7CP0vOc4O0go+l1Jyba3R5wYsYMOy5LHGFW/KNyPpm3
         RFxE10SaXxYkgHQJccTOqqc384k2nNRe3fJ/OstkqtqlHeyXOR9mF80vjbDAp/3O3hEc
         PpLsQBafreNkrWZMpKPtGPaewYvB13S5x7+3AncsooDd/XgBY1Y2ptA3kjuVym2K3uCw
         zwiDc4O0/aAS+JjZfLOuGskZL/5Q3Spft3CyOVvZeQWWXc6rB3AyRfjVI8KlUxH4fCAl
         Z4JJSDhBfTwq7MgEx6NvE5Os1APUiBYKb5DR5Ym57AiCODouYQ8kSnuChtfbIyUvTyWD
         DoLg==
X-Gm-Message-State: AJcUukcHk4s5ZEHlQfeepY8mZuu21mjaDHdJ80zY9JWfFhF4JZV0Z8Le
        EDBalQQ4FCNAx7lQx6G2iKNfuV1eJILAzh7ZfsA3RQ==
X-Google-Smtp-Source: ALg8bN64nCf01LPwNeEMj4+eSpw/eC5+gjXA8MIFeyGVFsORgghngHKX9owT4UQHcXB+coUS2O2rL3UEnIazRJMe8ZY=
X-Received: by 2002:ab0:21c6:: with SMTP id u6mr1223283uan.97.1546252563596;
 Mon, 31 Dec 2018 02:36:03 -0800 (PST)
MIME-Version: 1.0
References: <1545908831-25910-1-git-send-email-sumit.garg@linaro.org>
 <1545908831-25910-3-git-send-email-sumit.garg@linaro.org> <CAKv+Gu9ShfrBhfCuRK_L_ZtZ3KnN7Jb-4hcX9nSO7AYbT8V8LQ@mail.gmail.com>
 <CAFA6WYN5+NWKpPhnGHRnh_ZOF9A8K=MvbbSQ9uvc2Tv1expXcA@mail.gmail.com>
 <CAKv+Gu-Go=GwsO=_WvmTr-OZb4WMGGQrMb2joxX1Kzfhza3JiA@mail.gmail.com>
 <CAFA6WYPm3_SZ59vOxceZkn0uzcJw3ECQZs5R_Ypz0ejpzTgAbQ@mail.gmail.com>
 <20181228144610.GA21561@jax.urgonet> <79744651-991d-ff44-2238-96721ff9bc18@gmail.com>
In-Reply-To: <79744651-991d-ff44-2238-96721ff9bc18@gmail.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Mon, 31 Dec 2018 16:05:52 +0530
Message-ID:
 <CAFA6WYN958Odx7HfB7-zDAt5hpXw8bCLsfQgJT+sjf_L4BmguQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] hwrng: add OP-TEE based rng driver
To:     =?UTF-8?B?VmVzYSBKw6TDpHNrZWzDpGluZW4=?= <dachaac@gmail.com>
Cc:     Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Bhupesh Sharma <bhsharma@redhat.com>, tee-dev@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181231103552.UQe8Slv1lPJR3KFlNqewifu1ehH4ncSyqM52n5m_kJU@z>

On Sun, 30 Dec 2018 at 20:29, Vesa J=C3=A4=C3=A4skel=C3=A4inen <dachaac@gma=
il.com> wrote:
>
> Hi All,
>
> On 28/12/2018 16.46, Jens Wiklander wrote:
> > Hi Sumit,
> >
> > On Fri, Dec 28, 2018 at 06:33:22PM +0530, Sumit Garg wrote:
> >> On Fri, 28 Dec 2018 at 16:08, Ard Biesheuvel <ard.biesheuvel@linaro.or=
g> wrote:
> >> Jens,
> >>
> >> Is there any particular reason to wait indefinitely in
> >> "optee_supp_thrd_req" if there is no supplicant running? I think we
> >> should probably return as follows from "optee_supp_thrd_req" API in
> >> case no supplicant is available:
> >>
> >> --- a/drivers/tee/optee/supp.c
> >> +++ b/drivers/tee/optee/supp.c
> >> @@ -88,10 +88,15 @@ u32 optee_supp_thrd_req(struct tee_context *ctx,
> >> u32 func, size_t num_params,
> >>   {
> >>          struct optee *optee =3D tee_get_drvdata(ctx->teedev);
> >>          struct optee_supp *supp =3D &optee->supp;
> >> -       struct optee_supp_req *req =3D kzalloc(sizeof(*req), GFP_KERNE=
L);
> >> +       struct optee_supp_req *req;
> >>          bool interruptable;
> >>          u32 ret;
> >>
> >> +       /* Return in case there is no supplicant available */
> >> +       if (!supp->ctx)
> >> +               return TEEC_ERROR_COMMUNICATION;
> >> +
> >> +       req =3D kzalloc(sizeof(*req), GFP_KERNEL);
> >>          if (!req)
> >>                  return TEEC_ERROR_OUT_OF_MEMORY;
> >
> >  From a user space point of view it has been more useful to just wait
> > until the supplicant starts to serve requests than polling the interfac=
e
> > until the call succeeds. For this new use case it makes more sense to b=
e
> > able to return an error instead.
> >
> > The proposed change is a user space API change, so we will need to do a
> > bit more than that.
>
> There are parts of kernel that need randomness before user space is ready=
.
>
> Can't we move necessary logic for this to in kernel now that there is
> kernel service requiring TEE services?
>

Yes it is exactly what this optee-rng kernel module is trying to achieve.

> I suppose there are even more services that would be better to be only
> optee<->kernel interface and not exposed as such to user space. One
> example of such would be mass storage encryption key or hardware rooted
> encryption for Linux keyring. Eg. replacement for TPM chip when TEE
> environment is available.
>

Agree, for such use-cases we are working on adding TEE bus support so
that kernel drivers would be able to communicate with TEE based
devices.

-Sumit

> Thanks,
> Vesa J=C3=A4=C3=A4skel=C3=A4inen
