Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE919C4743C
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Jun 2021 00:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A75EE613D8
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Jun 2021 00:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhFEAem (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Jun 2021 20:34:42 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:43996 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhFEAel (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Jun 2021 20:34:41 -0400
Received: by mail-pg1-f176.google.com with SMTP id e22so9124495pgv.10
        for <linux-crypto@vger.kernel.org>; Fri, 04 Jun 2021 17:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=MUq6X8/ZPIBrKdk3i3SE6IJReD3LrwPz//1n2EnyP3Q=;
        b=X074mGFT8XaS9PX3jk/A+Y5QmVPd3uxA8If6/e6C2ICQXasf98PrVS+wNyMdcKxZOo
         wwms5it3fD0KICYLv/aHwUrWzjADgMkMNSrtqnoM1U4q7EmoiHM5pwy3fUIV3a4s8+C8
         wrhA8BAUpJqLdkPdUJu/SHhn00mQSsNJ0mkv89Q4YfGcjSxlBG5mrPMqPh2hVz4Bhs6B
         bCQQAb4VB6h/9n3fRo0BoyqQe3kfi+6y0ay3C0D0nfGkjIQQDvq6yZrBdt45mm509iZO
         3QgRiElKJvfAIhmQXn0RAycoT8ThhOBxDkaeTZtqTiXT/4LjMHDMG5U7lBvi9PQtwWs9
         icVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=MUq6X8/ZPIBrKdk3i3SE6IJReD3LrwPz//1n2EnyP3Q=;
        b=BH1fkLoRbkrAbht8XJhk1S7ivqbkUeP25z4MJBwiNkl53ryvVh8iPzgrsprr73bGZd
         6EWFofB3W0xhEh1ZBo66VkFi8adcTcJzZPzCI0loLoouDqGHd0O3GUerlLpIgQDiaMQq
         x0W/2hls/TaGIbwDCcXaC1xnvdPDXp/Xfju41ASWVP0USW28i3UrXAl7eWsCAd/uIl2X
         G4pptpGt82jigkyJY+fbOQ3ghc2TmP6nRiyGPOa4IGYKREJ5ieYVSUV4b2us3QVIbRLX
         vdcti3DR3HHKwTv9IMOU4p2VCv8HHTRyWaTHu42rDytsXwtnQVnvz4IGVLfDZr+a79u1
         tx5A==
X-Gm-Message-State: AOAM531OZccIw+onaUE0MoV2ib2BRjPiES1rtBhXkFExX1p6/pMNZvW+
        OeRBKd/JWK8yYOTlTeK+004=
X-Google-Smtp-Source: ABdhPJwXiFnJQj4oLIJsGDkMxLgXqAQTko8IVI1OMYwx/T2aA9dKJF9QIzIoABl91TeiLJyK8K0lMQ==
X-Received: by 2002:a62:5444:0:b029:2e9:c69d:dc64 with SMTP id i65-20020a6254440000b02902e9c69ddc64mr6841873pfb.32.1622853102671;
        Fri, 04 Jun 2021 17:31:42 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id 21sm2480032pfh.103.2021.06.04.17.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 17:31:42 -0700 (PDT)
Date:   Sat, 05 Jun 2021 10:31:36 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 04/16] powerpc/vas: Create take/drop pid and mm
 references
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <8d219c0816133a8643d650709066cf04c9c77322.camel@linux.ibm.com>
        <16a319614a7ab4ce843f42a49c3ecf68ed03dd36.camel@linux.ibm.com>
        <1622693213.hz0uqko6dk.astroid@bobo.none>
        <6a67ebd5f728966312063e132c4f6aba70285c72.camel@linux.ibm.com>
In-Reply-To: <6a67ebd5f728966312063e132c4f6aba70285c72.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1622852830.f2v4xyjvwu.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of June 4, 2021 2:08 pm:
> On Thu, 2021-06-03 at 14:21 +1000, Nicholas Piggin wrote:
>> Excerpts from Haren Myneni's message of May 21, 2021 7:31 pm:
>> > Take pid and mm references when each window opens and drops during
>> > close. This functionality is needed for powerNV and pseries. So
>> > this patch defines the existing code as functions in common book3s
>> > platform vas-api.c
>> >=20
>> > Signed-off-by: Haren Myneni <haren@linux.ibm.com>
>>=20
>> Seems like a good idea to put these into their own helper functions.
>>=20
>> > ---
>> >  arch/powerpc/include/asm/vas.h              | 25 +++++++++
>> >  arch/powerpc/platforms/book3s/vas-api.c     | 51
>> > ++++++++++++++++++
>> >  arch/powerpc/platforms/powernv/vas-fault.c  | 10 ++--
>> >  arch/powerpc/platforms/powernv/vas-window.c | 57 ++---------------
>> > ----
>> >  arch/powerpc/platforms/powernv/vas.h        |  6 +--
>> >  5 files changed, 88 insertions(+), 61 deletions(-)
>> >=20
>> > diff --git a/arch/powerpc/include/asm/vas.h
>> > b/arch/powerpc/include/asm/vas.h
>> > index 668303198772..3f2b02461a76 100644
>> > --- a/arch/powerpc/include/asm/vas.h
>> > +++ b/arch/powerpc/include/asm/vas.h
>> > @@ -5,6 +5,9 @@
>> > =20
>> >  #ifndef _ASM_POWERPC_VAS_H
>> >  #define _ASM_POWERPC_VAS_H
>> > +#include <linux/sched/mm.h>
>> > +#include <linux/mmu_context.h>
>> > +#include <asm/icswx.h>
>> >  #include <uapi/asm/vas-api.h>
>> > =20
>> >  struct vas_window;
>> > @@ -49,6 +52,17 @@ enum vas_cop_type {
>> >  	VAS_COP_TYPE_MAX,
>> >  };
>> > =20
>> > +/*
>> > + * User space VAS windows are opened by tasks and take references
>> > + * to pid and mm until windows are closed.
>> > + * Stores pid, mm, and tgid for each window.
>> > + */
>> > +struct vas_user_win_ref {
>> > +	struct pid *pid;	/* PID of owner */
>> > +	struct pid *tgid;	/* Thread group ID of owner */
>> > +	struct mm_struct *mm;	/* Linux process mm_struct */
>> > +};
>> > +
>> >  /*
>> >   * User space window operations used for powernv and powerVM
>> >   */
>> > @@ -59,6 +73,16 @@ struct vas_user_win_ops {
>> >  	int (*close_win)(void *);
>> >  };
>> > =20
>> > +static inline void vas_drop_reference_pid_mm(struct
>> > vas_user_win_ref *ref)
>> > +{
>> > +	/* Drop references to pid and mm */
>> > +	put_pid(ref->pid);
>> > +	if (ref->mm) {
>> > +		mm_context_remove_vas_window(ref->mm);
>> > +		mmdrop(ref->mm);
>> > +	}
>> > +}
>>=20
>> You don't have to make up a new name for such a thing because you=20
>> already have one
>>=20
>> put_vas_user_win_ref(struct vas_user_win_ref *ref)
>>=20
>>=20
>> > +
>> >  /*
>> >   * Receive window attributes specified by the (in-kernel) owner of
>> > window.
>> >   */
>> > @@ -192,4 +216,5 @@ int vas_register_coproc_api(struct module *mod,
>> > enum vas_cop_type cop_type,
>> >  			    struct vas_user_win_ops *vops);
>> >  void vas_unregister_coproc_api(void);
>> > =20
>> > +int vas_reference_pid_mm(struct vas_user_win_ref *task_ref);
>> >  #endif /* __ASM_POWERPC_VAS_H */
>> > diff --git a/arch/powerpc/platforms/book3s/vas-api.c
>> > b/arch/powerpc/platforms/book3s/vas-api.c
>> > index 6c39320bfb9b..a0141bfb2e4b 100644
>> > --- a/arch/powerpc/platforms/book3s/vas-api.c
>> > +++ b/arch/powerpc/platforms/book3s/vas-api.c
>> > @@ -55,6 +55,57 @@ static char *coproc_devnode(struct device *dev,
>> > umode_t *mode)
>> >  	return kasprintf(GFP_KERNEL, "crypto/%s", dev_name(dev));
>> >  }
>> > =20
>> > +/*
>> > + * Take reference to pid and mm
>> > + */
>> > +int vas_reference_pid_mm(struct vas_user_win_ref *task_ref)
>> > +{
>>=20
>> So this is quite different from a typical refcount object in that
>> it's=20
>> opening it for access as well. I would split it in two functions, one
>> matching put_vas_user_win_ref() and appearing in the same place in
>> code,
>> which is up to about mmput and another function that adds the window
>> and
>> does the CP_ABORT etc... hmm, where do you release tgid?
>=20
> Basically copied the existing code in to these functions
> (vas_reference_pid_mm/vas_drop_reference_pid_mm) so that useful for
> both platforms.=20
>=20
> mm_context_add/remove_vas_window() is also like taking reference. So
> instead of adding 2 seperate functions, how about naming
> get/put_vas_user_win_ref()=20

It's actually different though. What I'm asking is the parts where you=20
interact with core kernel data structure refcounts go into their own=20
get/put functions.

Someone who understands that refcounting and looks at the code will care=20
about those bits, so having them all together I think is helpful. They=20
don't know about adding vas windows or CP_ABORT.

> Regarding tgid, the reference is taking only with pid, but not tgid.
> pid reuse can happen only in the case of multithread applications when
> the child that opened VAS window exits. But these windows will be
> closed when tgid exists. So do not need tgid reference.

I don't understand you.  The code you added does take a reference to=20
tgid...

>> > +	/*
>> > +	 * Window opened by a child thread may not be closed when
>> > +	 * it exits. So take reference to its pid and release it
>> > +	 * when the window is free by parent thread.
>> > +	 * Acquire a reference to the task's pid to make sure
>> > +	 * pid will not be re-used - needed only for multithread
>> > +	 * applications.
>> > +	 */
>> > +	task_ref->pid =3D get_task_pid(current, PIDTYPE_PID);

My question is, where is this reference released. I can't see it. I'm=20
asking about existing upstream code really because this patch is just=20
copying existing code around.

Thanks,
Nick

