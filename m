Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71029C43387
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jan 2019 07:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E12C2084C
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jan 2019 07:31:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZlQdUXAO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbfAKHbC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jan 2019 02:31:02 -0500
Received: from mail-ua1-f65.google.com ([209.85.222.65]:39590 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727723AbfAKHbC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 02:31:02 -0500
Received: by mail-ua1-f65.google.com with SMTP id c12so4463554uas.6
        for <linux-crypto@vger.kernel.org>; Thu, 10 Jan 2019 23:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YSKy8uIC12AR58FOss2L6+jhDODyLcnLXMtm7S/wK04=;
        b=ZlQdUXAOsAtx7nFHAPiM4n1CWO3zX2JHOMQoWcR7mxhCsjNR+wcufs8lTTcqRu/UAZ
         KXHiIbUjhQcJmCB8PXK+00qlxzexyt/ffcO56jpAg+qQw41i05SiQPnRS5/2NjGoDl8J
         IXvjf9Z6EvWuK5EAjX6dgwLlMDpGSCcxybjUM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YSKy8uIC12AR58FOss2L6+jhDODyLcnLXMtm7S/wK04=;
        b=aI6sbWXWL20AqbsvWLmNVx9hhFFQIOq62OiVYu7mSGK7CxqybPXqOtfZhZsdrc7Oe9
         zEXgls769gS+b2Y1EKpn1P/xK7UGgW6KBjXY50LSP1ZzQDsk1WQaqn0Nm3h7wDyRnw6m
         BgGnmHXvZM+icceEHvEwYV8Hk/iaQCilI2n7P5yxyqqyDmsK2oJPvugwpyVN1zrJUPWT
         d2XFOkfJAqlnCOyFjGb8CxmWMpykK0K6onqu9QwwfcoV5Qdc+Tfeo9HbYWtSmKRD4z2Y
         fyeaCIW/EwqoFo4q3fwhPcq7RP9wM6yQFah6tAl9p6ag7p30+uAGWXo87/PtkHtSzb6D
         f16A==
X-Gm-Message-State: AJcUukcWulj6TP+SmOIOgrfCanG/ixAJIkjPgMMfKMc2ZBQ69fCJ697t
        nkodtEoAh5SP2ZH02um9JNd24/lpayWhiaGlsMeGWw==
X-Google-Smtp-Source: ALg8bN72MocGPUMW13tG/tMsUgaI0b1p+mkbtN1ZOLyohFz8HNRi7vemampDabgCfCVjf3vB9uDroc1XPVXTFDGJ2bM=
X-Received: by 2002:ab0:21c6:: with SMTP id u6mr5128107uan.97.1547191860630;
 Thu, 10 Jan 2019 23:31:00 -0800 (PST)
MIME-Version: 1.0
References: <1547123097-16431-1-git-send-email-sumit.garg@linaro.org>
 <1547123097-16431-4-git-send-email-sumit.garg@linaro.org> <20190110142355.bcgw62w2qk2mlzj6@holly.lan>
In-Reply-To: <20190110142355.bcgw62w2qk2mlzj6@holly.lan>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Fri, 11 Jan 2019 13:00:49 +0530
Message-ID:
 <CAFA6WYPzA+rKMq58xVPghSe-mLa6fDi4t=1DYxakEaeG+ayQug@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] tee: add supp_nowait flag in tee_context struct
To:     Daniel Thompson <daniel.thompson@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Jens Wiklander <jens.wiklander@linaro.org>, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Bhupesh Sharma <bhsharma@redhat.com>, tee-dev@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20190111073049.jJHvDeN4R74Dx-TmHybLAc0kCjmQM9MoIh71OJtlX3o@z>

On Thu, 10 Jan 2019 at 19:53, Daniel Thompson
<daniel.thompson@linaro.org> wrote:
>
> On Thu, Jan 10, 2019 at 05:54:56PM +0530, Sumit Garg wrote:
> > This flag indicates that requests in this context should not wait for
> > tee-supplicant daemon to be started if not present and just return
> > with an error code. It is needed for requests which should be
> > non-blocking in nature like ones arising from TEE based kernel drivers
> > or any in kernel api that uses TEE internal client interface.
>
> This patch seems out of order in the patch set: Doesn't
> optee_enumarate_devices() require this feature if it is to
> work correctly with a TEE that does not implement the enumeate pTA.
>
> If so better to implement the feature first so that
> optee_emumerate_devices() works correctly when it first appears.
>

Agree, will make this patch as #2 in next version.

> >
> > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> > ---
> >  drivers/tee/optee/supp.c | 10 +++++++++-
> >  drivers/tee/tee_core.c   |  2 ++
> >  include/linux/tee_drv.h  |  6 ++++++
> >  3 files changed, 17 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/tee/optee/supp.c b/drivers/tee/optee/supp.c
> > index 43626e1..92f56b8 100644
> > --- a/drivers/tee/optee/supp.c
> > +++ b/drivers/tee/optee/supp.c
> > @@ -88,10 +88,18 @@ u32 optee_supp_thrd_req(struct tee_context *ctx, u32 func, size_t num_params,
> >  {
> >       struct optee *optee = tee_get_drvdata(ctx->teedev);
> >       struct optee_supp *supp = &optee->supp;
> > -     struct optee_supp_req *req = kzalloc(sizeof(*req), GFP_KERNEL);
> > +     struct optee_supp_req *req;
> >       bool interruptable;
> >       u32 ret;
> >
> > +     /*
> > +      * Return in case there is no supplicant available and
> > +      * non-blocking request.
> > +      */
> > +     if (!supp->ctx && ctx->supp_nowait)
> > +             return TEEC_ERROR_COMMUNICATION;
> > +
> > +     req = kzalloc(sizeof(*req), GFP_KERNEL);
> >       if (!req)
> >               return TEEC_ERROR_OUT_OF_MEMORY;
> >
> > diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
> > index 9ddb89e..5d6c317 100644
> > --- a/drivers/tee/tee_core.c
> > +++ b/drivers/tee/tee_core.c
> > @@ -105,6 +105,7 @@ static int tee_open(struct inode *inode, struct file *filp)
> >       if (IS_ERR(ctx))
> >               return PTR_ERR(ctx);
> >
> > +     ctx->supp_nowait = false;
> >       filp->private_data = ctx;
> >       return 0;
> >  }
> > @@ -981,6 +982,7 @@ tee_client_open_context(struct tee_context *start,
> >       } while (IS_ERR(ctx) && PTR_ERR(ctx) != -ENOMEM);
> >
> >       put_device(put_dev);
> > +     ctx->supp_nowait = true;
>
> Why automatically set supp_nowait inside open_context() ?
>

I think this is the default behaviour (non-blocking request) that any
in kernel client would expect. Also this flag could be configured
again before call to open_session() if any in kernel client requires
different behaviour.

-Sumit

>
> >       return ctx;
> >  }
> >  EXPORT_SYMBOL_GPL(tee_client_open_context);
> > diff --git a/include/linux/tee_drv.h b/include/linux/tee_drv.h
> > index ed16bf1..fe1a920 100644
> > --- a/include/linux/tee_drv.h
> > +++ b/include/linux/tee_drv.h
> > @@ -49,6 +49,11 @@ struct tee_shm_pool;
> >   * @releasing:  flag that indicates if context is being released right now.
> >   *           It is needed to break circular dependency on context during
> >   *              shared memory release.
> > + * @supp_nowait: flag that indicates that requests in this context should not
> > + *              wait for tee-supplicant daemon to be started if not present
> > + *              and just return with an error code. It is needed for requests
> > + *              that arises from TEE based kernel drivers that should be
> > + *              non-blocking in nature.
> >   */
> >  struct tee_context {
> >       struct tee_device *teedev;
> > @@ -56,6 +61,7 @@ struct tee_context {
> >       void *data;
> >       struct kref refcount;
> >       bool releasing;
> > +     bool supp_nowait;
> >  };
> >
> >  struct tee_param_memref {
> > --
> > 2.7.4
> >
