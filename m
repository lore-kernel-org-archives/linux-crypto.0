Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D5D5C4332F
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Nov 2021 16:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8534860234
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Nov 2021 16:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240408AbhKIQtn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Nov 2021 11:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240345AbhKIQtk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Nov 2021 11:49:40 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8CFC0613F5
        for <linux-crypto@vger.kernel.org>; Tue,  9 Nov 2021 08:46:53 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id z34so2675918lfu.8
        for <linux-crypto@vger.kernel.org>; Tue, 09 Nov 2021 08:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+DobYMn9JpQ+enw2TdOzWV1L7zxSGklfH9GxpMYDKho=;
        b=sxk0uFKMhwTn+CM8H0CHltcLP+zx3SB/DVLc3/ZV2EpxzoTwd7i/FFmTKgom2vg7Cy
         84XnO+mOHJMUaFVLaMVN9Yyblxw95Cm5gf9awuPaTvDxYJFiMi06wWFYcAtYDuCpSqpf
         hy4T4mw9dbtUQMZf3oPlvXWSRKr6vEn1Jz0LoOUXMlI51YBsAdVlXEJv6QQ5XujJeCzf
         MDxETFpwUsvt+SnIxvaK/7gYyvz+QwoU617eZKQfoEkBt3+uWNn6rNz3j3wdRHOpyaGE
         vR93EOuUspGrqdNIl6I9aJXXT9YUcp4/dhTaKG97bZFdKLAIDZYaWT+FApSy0L+jRjxK
         VBzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+DobYMn9JpQ+enw2TdOzWV1L7zxSGklfH9GxpMYDKho=;
        b=3mg/lU1qcDClvaKMKyZprSZFyMwpx1PTewAT01a+GPcnRLzleMbT3hTxbDSRd31iw2
         29hjSeBH+HY+CSP3UI/pDSH2lbc2q6jrG+LHSc9qZhVuBBhv9ZagpHLhqbWJZ92/N2P3
         ddkB0z7Xfd5hpUBglgyWzbldv02c5sXQ4j7nqp/vtXiTPCCkvec98s9vsYEd9EzHEOuR
         MzkQ1j/I04ewOAbDH6e7f5YuqAnc+1BKU5e1LGYTxS5brCMA+yAKmjIAm3b6E9qd/GDD
         2p/9+Bxrl1keI7AunYabzcGuckr/l9q5BGWt/WzsVUapag6sv4TjAgGShqQZ58dBpAAC
         qyNw==
X-Gm-Message-State: AOAM533IVx6TGwZpFfma+DeckEXv9sZgrs0Uip7QQliJCAi6k5Qu+RP6
        1oNh5/g2zZ3YzxnJgai0feLS8KNSnHYaK1DtATzJjQ==
X-Google-Smtp-Source: ABdhPJx8Ubj02xgDy+a1EYHccglsh8KzRnTqS7Goni4XUv7NERlEZm2nzxsi+HgSvub+r6vBHdjdvJ1w3SVniNoez0c=
X-Received: by 2002:a19:ad4d:: with SMTP id s13mr8364668lfd.373.1636476412095;
 Tue, 09 Nov 2021 08:46:52 -0800 (PST)
MIME-Version: 1.0
References: <20211102142331.3753798-1-pgonda@google.com> <20211102142331.3753798-2-pgonda@google.com>
 <YYqhT+Enba5xa4cO@google.com>
In-Reply-To: <YYqhT+Enba5xa4cO@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 9 Nov 2021 09:46:40 -0700
Message-ID: <CAMkAt6oVySH-1g+EXKvxQ9vmBV8rwTLq=qfe2+VZC+c6vATL7w@mail.gmail.com>
Subject: Re: [PATCH V3 1/4] crypto: ccp - Fix SEV_INIT error logging on init
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas.Lendacky@amd.com, Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 9, 2021 at 9:27 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Nov 02, 2021, Peter Gonda wrote:
> > Currently only the firmware error code is printed. This is incomplete
> > and also incorrect as error cases exists where the firmware is never
> > called and therefore does not set an error code. This change zeros the
> > firmware error code in case the call does not get that far and prints
> > the return code for non firmware errors.
> >
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> > Reviewed-by: Marc Orr <marcorr@google.com>
> > Acked-by: David Rientjes <rientjes@google.com>
> > Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: Brijesh Singh <brijesh.singh@amd.com>
> > Cc: Marc Orr <marcorr@google.com>
> > Cc: Joerg Roedel <jroedel@suse.de>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: John Allen <john.allen@amd.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: linux-crypto@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  drivers/crypto/ccp/sev-dev.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> > index 2ecb0e1f65d8..ec89a82ba267 100644
> > --- a/drivers/crypto/ccp/sev-dev.c
> > +++ b/drivers/crypto/ccp/sev-dev.c
> > @@ -1065,7 +1065,7 @@ void sev_pci_init(void)
> >  {
> >       struct sev_device *sev = psp_master->sev_data;
> >       struct page *tmr_page;
> > -     int error, rc;
> > +     int error = 0, rc;
>
> Wouldn't it be more appropriate to use something the PSP can't return, e.g. -1?
> '0' is SEV_RET_SUCCESS, which is quite misleading, e.g. the below error message
> will print
>
>         SEV: failed to INIT error 0, rc -16
>
> which a bit head scratching without looking at the code.  AFAICT, the PSP return
> codes aren't intrinsically hex, so printing error as a signed demical and thus
>
>         SEV: failed to INIT error -1, rc -16
>
> would be less confusing.
>
> And IMO requiring the caller to initialize error is will be neverending game of
> whack-a-mole.  E.g. sev_ioctl() fails to set "error" in the userspace structure,
> and literally every function exposed via include/linux/psp-sev.h has this same
> issue.  Case in point, the retry path fails to re-initialize "error" and will
> display stale information if the second sev_platform_init() fails without reaching
> the PSP.

OK I can update __sev_platform_init_locked() to set error to -1. That
seems pretty reasonable. Tom, is that OK with you?

>
>         rc = sev_platform_init(&error);
>         if (rc && (error == SEV_RET_SECURE_DATA_INVALID)) {
>                 /*
>                  * INIT command returned an integrity check failure
>                  * status code, meaning that firmware load and
>                  * validation of SEV related persistent data has
>                  * failed and persistent state has been erased.
>                  * Retrying INIT command here should succeed.
>                  */
>                 dev_dbg(sev->dev, "SEV: retrying INIT command");
>                 rc = sev_platform_init(&error); <------ error may or may not be set
>         }
>
> Ideally, error wouldn't be an output param and instead would be squished into the
> true return value, but that'd required quite the refactoring, and might yield ugly
> code generation on non-64-bit architectures (does this code support those?).
>
> As a minimal step toward sanity, sev_ioctl(), __sev_platform_init_locked(), and
> __sev_do_cmd_locked() should initialize the incoming error.  Long term, sev-dev
> really needs to either have well-defined API for when "error" is meaningful, or
> ensure the pointer is initialized in all paths.

These comments seem fine to me. But I'll refrain from updating
anything here since this seems out-of-scope of this series. Happy to
discuss further and work on that if Tom is interested in those
refactors too.

>
> E.g.
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index ec89a82ba267..549686a1e812 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -149,6 +149,9 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>         unsigned int reg, ret = 0;
>         int buf_len;
>
> +       if (psp_ret)
> +               *psp_ret = -1;
> +
>         if (!psp || !psp->sev_data)
>                 return -ENODEV;
>
> @@ -192,9 +195,6 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>         /* wait for command completion */
>         ret = sev_wait_cmd_ioc(sev, &reg, psp_timeout);
>         if (ret) {
> -               if (psp_ret)
> -                       *psp_ret = 0;
> -
>                 dev_err(sev->dev, "sev command %#x timed out, disabling PSP\n", cmd);
>                 psp_dead = true;
>
> @@ -243,6 +243,9 @@ static int __sev_platform_init_locked(int *error)
>         struct sev_device *sev;
>         int rc = 0;
>
> +       if (error)
> +               *error = -1;
> +
>         if (!psp || !psp->sev_data)
>                 return -ENODEV;
>
> @@ -838,6 +841,8 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>         if (input.cmd > SEV_MAX)
>                 return -EINVAL;
>
> +       input.error = -1;
> +
>         mutex_lock(&sev_cmd_mutex);
>
>         switch (input.cmd) {
>
> >       if (!sev)
> >               return;
> > @@ -1104,7 +1104,8 @@ void sev_pci_init(void)
> >       }
> >
> >       if (rc) {
> > -             dev_err(sev->dev, "SEV: failed to INIT error %#x\n", error);
> > +             dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
> > +                     error, rc);
> >               return;
> >       }
> >
> > --
> > 2.33.1.1089.g2158813163f-goog
> >
