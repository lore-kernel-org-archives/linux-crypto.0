Return-Path: <SRS0=CB0V=42=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F92C18E5A
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Mar 2020 14:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E70BA20848
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Mar 2020 14:03:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xxyk6Ue9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgCIODm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Mar 2020 10:03:42 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37181 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726275AbgCIODm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Mar 2020 10:03:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583762620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AAx8Db+fYqXMdq0yYrv0VdVkrDWQ8+roRtbZieuiPgc=;
        b=Xxyk6Ue9j//wtRK9emVdjZp5UZ2FkTrCIyqObB9zWzfxeOu5CTyD4M5Y/GzoqS1O6mX074
        AV2bSiOmii/+CgWmeynKmoZi3jsr1LIRKL3n9nxebMXInwQ1ivZbdz4N9x+JXIwtDvZwlL
        36iF87X1lfo423x1f8Bl4mrfEsoJTAw=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-sgM3Je6gPKOX3Gk_iOXrog-1; Mon, 09 Mar 2020 10:03:38 -0400
X-MC-Unique: sgM3Je6gPKOX3Gk_iOXrog-1
Received: by mail-io1-f69.google.com with SMTP id w16so6674896iot.2
        for <linux-crypto@vger.kernel.org>; Mon, 09 Mar 2020 07:03:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AAx8Db+fYqXMdq0yYrv0VdVkrDWQ8+roRtbZieuiPgc=;
        b=L8DfL5EwbLc/ag3eE+007FBQnhtTnFPwA+5BqUD1RcyF0DibnaWnTsnTQzNn617DY3
         5ofA3LZoJLRTh4eXpwdN1vh0EIYoX+j5vQW8I3iHJmNe5VeDEKXX93cEmc9ynIHSlawi
         gF2npjBgz2JmSY7LIQ3o4+HO7Ar3e0HgjKdqM5tKC6YhJ+1PayeXx9jUzdsnzoBH6CEG
         9u4e5ejG6qMK2Hfl2pMXE5RKxB7d3cOhmo78T8zLH+rlfM0kEMMukz2ymVvSYNRCyuot
         DvBe9acAyZutAApgOkiu64XAJLfZLV78/hP5bn4CiuLe02V4xGICokes/tjh849WOisE
         XwLw==
X-Gm-Message-State: ANhLgQ1O/HSDk6dhJFJrIcyI3kQ3YFuBa80Tb3vkIK4VQaOF024nrwJA
        KWHyFzzvwlWzq8QJ5FGHiBL517GXOTnhoVxe7+329Ylrewu46svb6dxsiH+SWvC7KL4gOBgpZwy
        ffOh/gpk3D0ups7eoNXdarUBJwx2HQEvDz9FFhHwN
X-Received: by 2002:a05:6e02:685:: with SMTP id o5mr4046399ils.86.1583762617980;
        Mon, 09 Mar 2020 07:03:37 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vt4cIFMj9otyn2Lqt9XgikIkKQh0PPT/KVUuvAi53LPRuVm8CdzlLRfTdn1l0l6hV1m6QypDgnDQXaETWIm1zM=
X-Received: by 2002:a05:6e02:685:: with SMTP id o5mr4046371ils.86.1583762617640;
 Mon, 09 Mar 2020 07:03:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200306172010.1213899-1-ckuehl@redhat.com> <20200306172010.1213899-2-ckuehl@redhat.com>
 <alpine.DEB.2.21.2003081450450.58178@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.21.2003081450450.58178@chino.kir.corp.google.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Mon, 9 Mar 2020 10:03:26 -0400
Message-ID: <CAOASepNLcJSQn32xwszD3KDQro1TLWMoqXV5J0j=APUuJrRcoQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] crypto: ccp: use file mode for sev ioctl permissions
To:     David Rientjes <rientjes@google.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        "Hook, Gary" <gary.hook@amd.com>, erdemaktas@google.com,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Bandan Das <bsd@redhat.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Mar 8, 2020 at 5:54 PM David Rientjes <rientjes@google.com> wrote:
>
> On Fri, 6 Mar 2020, Connor Kuehl wrote:
>
> > Instead of using CAP_SYS_ADMIN which is restricted to the root user,
> > check the file mode for write permissions before executing commands that
> > can affect the platform. This allows for more fine-grained access
> > control to the SEV ioctl interface. This would allow a SEV-only user
> > or group the ability to administer the platform without requiring them
> > to be root or granting them overly powerful permissions.
> >
> > For example:
> >
> > chown root:root /dev/sev
> > chmod 600 /dev/sev
>
> Hi Connor,
>
> I'm curious why do you need to do the two above commands?  It implies that
> /dev/sev is either not owned by root or that it is not already restricted
> to only being owner read and writable.
>
> Or perhaps these two commands were included only for clarity to explain
> what the defaults should be?

Correct. Those are just exemplary. They represent the existing permissions.

> > setfacl -m g:sev:r /dev/sev
> > setfacl -m g:sev-admin:rw /dev/sev
> >
> > In this instance, members of the "sev-admin" group have the ability to
> > perform all ioctl calls (including the ones that modify platform state).
> > Members of the "sev" group only have access to the ioctls that do not
> > modify the platform state.
> >
> > This also makes opening "/dev/sev" more consistent with how file
> > descriptors are usually handled. By only checking for CAP_SYS_ADMIN,
> > the file descriptor could be opened read-only but could still execute
> > ioctls that modify the platform state. This patch enforces that the file
> > descriptor is opened with write privileges if it is going to be used to
> > modify the platform state.
> >
> > This flexibility is completely opt-in, and if it is not desirable by
> > the administrator then they do not need to give anyone else access to
> > /dev/sev.
> >
> > Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
> > ---
> >  drivers/crypto/ccp/sev-dev.c | 33 +++++++++++++++++----------------
> >  1 file changed, 17 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> > index e467860f797d..416b80938a3e 100644
> > --- a/drivers/crypto/ccp/sev-dev.c
> > +++ b/drivers/crypto/ccp/sev-dev.c
> > @@ -283,11 +283,11 @@ static int sev_get_platform_state(int *state, int *error)
> >       return rc;
> >  }
> >
> > -static int sev_ioctl_do_reset(struct sev_issue_cmd *argp)
> > +static int sev_ioctl_do_reset(struct sev_issue_cmd *argp, bool writable)
> >  {
> >       int state, rc;
> >
> > -     if (!capable(CAP_SYS_ADMIN))
> > +     if (!writable)
> >               return -EPERM;
> >
> >       /*
> > @@ -331,12 +331,12 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
> >       return ret;
> >  }
> >
> > -static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
> > +static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
> >  {
> >       struct sev_device *sev = psp_master->sev_data;
> >       int rc;
> >
> > -     if (!capable(CAP_SYS_ADMIN))
> > +     if (!writable)
> >               return -EPERM;
> >
> >       if (sev->state == SEV_STATE_UNINIT) {
> > @@ -348,7 +348,7 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
> >       return __sev_do_cmd_locked(cmd, NULL, &argp->error);
> >  }
> >
> > -static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
> > +static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
> >  {
> >       struct sev_device *sev = psp_master->sev_data;
> >       struct sev_user_data_pek_csr input;
> > @@ -356,7 +356,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
> >       void *blob = NULL;
> >       int ret;
> >
> > -     if (!capable(CAP_SYS_ADMIN))
> > +     if (!writable)
> >               return -EPERM;
> >
> >       if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
> > @@ -539,7 +539,7 @@ static int sev_update_firmware(struct device *dev)
> >       return ret;
> >  }
> >
> > -static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp)
> > +static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
> >  {
> >       struct sev_device *sev = psp_master->sev_data;
> >       struct sev_user_data_pek_cert_import input;
> > @@ -547,7 +547,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp)
> >       void *pek_blob, *oca_blob;
> >       int ret;
> >
> > -     if (!capable(CAP_SYS_ADMIN))
> > +     if (!writable)
> >               return -EPERM;
> >
> >       if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
> > @@ -698,7 +698,7 @@ static int sev_ioctl_do_get_id(struct sev_issue_cmd *argp)
> >       return ret;
> >  }
> >
> > -static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp)
> > +static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
> >  {
> >       struct sev_device *sev = psp_master->sev_data;
> >       struct sev_user_data_pdh_cert_export input;
> > @@ -708,7 +708,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp)
> >
> >       /* If platform is not in INIT state then transition it to INIT. */
> >       if (sev->state != SEV_STATE_INIT) {
> > -             if (!capable(CAP_SYS_ADMIN))
> > +             if (!writable)
> >                       return -EPERM;
> >
> >               ret = __sev_platform_init_locked(&argp->error);
> > @@ -801,6 +801,7 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
> >       void __user *argp = (void __user *)arg;
> >       struct sev_issue_cmd input;
> >       int ret = -EFAULT;
> > +     bool writable = file->f_mode & FMODE_WRITE;
> >
> >       if (!psp_master || !psp_master->sev_data)
> >               return -ENODEV;
> > @@ -819,25 +820,25 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
> >       switch (input.cmd) {
> >
> >       case SEV_FACTORY_RESET:
> > -             ret = sev_ioctl_do_reset(&input);
> > +             ret = sev_ioctl_do_reset(&input, writable);
> >               break;
> >       case SEV_PLATFORM_STATUS:
> >               ret = sev_ioctl_do_platform_status(&input);
> >               break;
> >       case SEV_PEK_GEN:
> > -             ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PEK_GEN, &input);
> > +             ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PEK_GEN, &input, writable);
> >               break;
> >       case SEV_PDH_GEN:
> > -             ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PDH_GEN, &input);
> > +             ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PDH_GEN, &input, writable);
> >               break;
> >       case SEV_PEK_CSR:
> > -             ret = sev_ioctl_do_pek_csr(&input);
> > +             ret = sev_ioctl_do_pek_csr(&input, writable);
> >               break;
> >       case SEV_PEK_CERT_IMPORT:
> > -             ret = sev_ioctl_do_pek_import(&input);
> > +             ret = sev_ioctl_do_pek_import(&input, writable);
> >               break;
> >       case SEV_PDH_CERT_EXPORT:
> > -             ret = sev_ioctl_do_pdh_export(&input);
> > +             ret = sev_ioctl_do_pdh_export(&input, writable);
> >               break;
> >       case SEV_GET_ID:
> >               pr_warn_once("SEV_GET_ID command is deprecated, use SEV_GET_ID2\n");
> > --
> > 2.24.1
> >
> >
>

