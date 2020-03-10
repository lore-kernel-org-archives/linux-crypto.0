Return-Path: <SRS0=U1Ok=43=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7335BC10F29
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 00:43:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 479A324670
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 00:43:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cH0aaMGZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgCJAn4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Mar 2020 20:43:56 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37981 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727287AbgCJAn4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Mar 2020 20:43:56 -0400
Received: by mail-pg1-f196.google.com with SMTP id x7so5492528pgh.5
        for <linux-crypto@vger.kernel.org>; Mon, 09 Mar 2020 17:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=/f8/6UTLba5f1pJEeKD11zYn6OkBzjFDrlt51osL7kM=;
        b=cH0aaMGZ4KtZXejdVNOPOICAX8Q0cuJ34jLbx2SNF47xbNMZb2VFEJ+usH+Z1W1cpt
         ByIOyslyviEY4mA599PuinJN403ub7pBrGT+FTZlcPZIMUmqVYSzlpCTyVUmXPfhOa4e
         /T7Yl4ggwDqcaIzpk6tJ4PLBo54ZF+Dceme1/oR4Pr4I0p+bNPFYZm/EC6SLaOAqSAt6
         V2QRacfzALJwN/KJYSJeCIzTyXfb0AQOlmwYUqcpqr5tKwXOrVPdtPGGwveNdIjRFU+Q
         Q3euB7/j/aqfELjySrJ6ssrufy/1jwOLrbRoq165oJyHYhQHxtw7H3Rf+aXrmC9baKjA
         WARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=/f8/6UTLba5f1pJEeKD11zYn6OkBzjFDrlt51osL7kM=;
        b=tw8cnHEJqpaAU+gdr3SmzonYm09NjAiAag3Lr8UzvCbOPWKkq6mKTKKM6zelGy40T5
         HGflLW7bq37+Wdwj8JOIy/isX+rDVMBegWY8bJIUUQRUJhFsz3t7JOWJJrkgci8LtgKA
         YrJthJOl/2hcRCymB6ENXqpn2c8e4U8S9GX0ZUMZDdxSL7YcRdEbA/Ae5WL75JmHIkYe
         4qExvIdesPizF/kHnF+niXiu7RAtWrZ0RV0hzCLFMQ+r9UXILhuk7S5dCwYRKc2IjWLk
         Zx6jg4xPxqiV2AXWGWq3V/Bkqc4+RNLdlkUUrWNXaJ2rsso0u+5NkvWekYas5uCXc/B6
         UUlg==
X-Gm-Message-State: ANhLgQ0C2ty/3RAU7sh54g8OUDWcE0GUFnWm2EKtCQbxkix5LszzaNdp
        hSuy3bFfpIxhJYhudj+qBY/Q6w==
X-Google-Smtp-Source: ADFU+vtALF8Ou/zAEflpxN8/Hl9la2CgApc/ydsl3ikLOel2ohS3P6RPBurv08vJzS+1xMz6yprVZA==
X-Received: by 2002:a63:2a4e:: with SMTP id q75mr18684761pgq.358.1583801032302;
        Mon, 09 Mar 2020 17:43:52 -0700 (PDT)
Received: from [2620:15c:17:3:3a5:23a7:5e32:4598] ([2620:15c:17:3:3a5:23a7:5e32:4598])
        by smtp.gmail.com with ESMTPSA id w1sm45687106pgr.4.2020.03.09.17.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 17:43:51 -0700 (PDT)
Date:   Mon, 9 Mar 2020 17:43:50 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     Nathaniel McCallum <npmccallum@redhat.com>
cc:     Connor Kuehl <ckuehl@redhat.com>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        "Hook, Gary" <gary.hook@amd.com>, erdemaktas@google.com,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Bandan Das <bsd@redhat.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] crypto: ccp: use file mode for sev ioctl
 permissions
In-Reply-To: <CAOASepNLcJSQn32xwszD3KDQro1TLWMoqXV5J0j=APUuJrRcoQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2003091742500.156701@chino.kir.corp.google.com>
References: <20200306172010.1213899-1-ckuehl@redhat.com> <20200306172010.1213899-2-ckuehl@redhat.com> <alpine.DEB.2.21.2003081450450.58178@chino.kir.corp.google.com> <CAOASepNLcJSQn32xwszD3KDQro1TLWMoqXV5J0j=APUuJrRcoQ@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 9 Mar 2020, Nathaniel McCallum wrote:

> > > Instead of using CAP_SYS_ADMIN which is restricted to the root user,
> > > check the file mode for write permissions before executing commands that
> > > can affect the platform. This allows for more fine-grained access
> > > control to the SEV ioctl interface. This would allow a SEV-only user
> > > or group the ability to administer the platform without requiring them
> > > to be root or granting them overly powerful permissions.
> > >
> > > For example:
> > >
> > > chown root:root /dev/sev
> > > chmod 600 /dev/sev
> >
> > Hi Connor,
> >
> > I'm curious why do you need to do the two above commands?  It implies that
> > /dev/sev is either not owned by root or that it is not already restricted
> > to only being owner read and writable.
> >
> > Or perhaps these two commands were included only for clarity to explain
> > what the defaults should be?
> 
> Correct. Those are just exemplary. They represent the existing permissions.
> 

Sounds good, thanks.  Maybe showing what ls -l /dev/sev looks like by 
default in the changelog would make it clear.  Otherwise looks good.

> > > setfacl -m g:sev:r /dev/sev
> > > setfacl -m g:sev-admin:rw /dev/sev
> > >
> > > In this instance, members of the "sev-admin" group have the ability to
> > > perform all ioctl calls (including the ones that modify platform state).
> > > Members of the "sev" group only have access to the ioctls that do not
> > > modify the platform state.
> > >
> > > This also makes opening "/dev/sev" more consistent with how file
> > > descriptors are usually handled. By only checking for CAP_SYS_ADMIN,
> > > the file descriptor could be opened read-only but could still execute
> > > ioctls that modify the platform state. This patch enforces that the file
> > > descriptor is opened with write privileges if it is going to be used to
> > > modify the platform state.
> > >
> > > This flexibility is completely opt-in, and if it is not desirable by
> > > the administrator then they do not need to give anyone else access to
> > > /dev/sev.
> > >
> > > Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
> > > ---
> > >  drivers/crypto/ccp/sev-dev.c | 33 +++++++++++++++++----------------
> > >  1 file changed, 17 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> > > index e467860f797d..416b80938a3e 100644
> > > --- a/drivers/crypto/ccp/sev-dev.c
> > > +++ b/drivers/crypto/ccp/sev-dev.c
> > > @@ -283,11 +283,11 @@ static int sev_get_platform_state(int *state, int *error)
> > >       return rc;
> > >  }
> > >
> > > -static int sev_ioctl_do_reset(struct sev_issue_cmd *argp)
> > > +static int sev_ioctl_do_reset(struct sev_issue_cmd *argp, bool writable)
> > >  {
> > >       int state, rc;
> > >
> > > -     if (!capable(CAP_SYS_ADMIN))
> > > +     if (!writable)
> > >               return -EPERM;
> > >
> > >       /*
> > > @@ -331,12 +331,12 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
> > >       return ret;
> > >  }
> > >
> > > -static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
> > > +static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
> > >  {
> > >       struct sev_device *sev = psp_master->sev_data;
> > >       int rc;
> > >
> > > -     if (!capable(CAP_SYS_ADMIN))
> > > +     if (!writable)
> > >               return -EPERM;
> > >
> > >       if (sev->state == SEV_STATE_UNINIT) {
> > > @@ -348,7 +348,7 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
> > >       return __sev_do_cmd_locked(cmd, NULL, &argp->error);
> > >  }
> > >
> > > -static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
> > > +static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
> > >  {
> > >       struct sev_device *sev = psp_master->sev_data;
> > >       struct sev_user_data_pek_csr input;
> > > @@ -356,7 +356,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
> > >       void *blob = NULL;
> > >       int ret;
> > >
> > > -     if (!capable(CAP_SYS_ADMIN))
> > > +     if (!writable)
> > >               return -EPERM;
> > >
> > >       if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
> > > @@ -539,7 +539,7 @@ static int sev_update_firmware(struct device *dev)
> > >       return ret;
> > >  }
> > >
> > > -static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp)
> > > +static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
> > >  {
> > >       struct sev_device *sev = psp_master->sev_data;
> > >       struct sev_user_data_pek_cert_import input;
> > > @@ -547,7 +547,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp)
> > >       void *pek_blob, *oca_blob;
> > >       int ret;
> > >
> > > -     if (!capable(CAP_SYS_ADMIN))
> > > +     if (!writable)
> > >               return -EPERM;
> > >
> > >       if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
> > > @@ -698,7 +698,7 @@ static int sev_ioctl_do_get_id(struct sev_issue_cmd *argp)
> > >       return ret;
> > >  }
> > >
> > > -static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp)
> > > +static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
> > >  {
> > >       struct sev_device *sev = psp_master->sev_data;
> > >       struct sev_user_data_pdh_cert_export input;
> > > @@ -708,7 +708,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp)
> > >
> > >       /* If platform is not in INIT state then transition it to INIT. */
> > >       if (sev->state != SEV_STATE_INIT) {
> > > -             if (!capable(CAP_SYS_ADMIN))
> > > +             if (!writable)
> > >                       return -EPERM;
> > >
> > >               ret = __sev_platform_init_locked(&argp->error);
> > > @@ -801,6 +801,7 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
> > >       void __user *argp = (void __user *)arg;
> > >       struct sev_issue_cmd input;
> > >       int ret = -EFAULT;
> > > +     bool writable = file->f_mode & FMODE_WRITE;
> > >
> > >       if (!psp_master || !psp_master->sev_data)
> > >               return -ENODEV;
> > > @@ -819,25 +820,25 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
> > >       switch (input.cmd) {
> > >
> > >       case SEV_FACTORY_RESET:
> > > -             ret = sev_ioctl_do_reset(&input);
> > > +             ret = sev_ioctl_do_reset(&input, writable);
> > >               break;
> > >       case SEV_PLATFORM_STATUS:
> > >               ret = sev_ioctl_do_platform_status(&input);
> > >               break;
> > >       case SEV_PEK_GEN:
> > > -             ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PEK_GEN, &input);
> > > +             ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PEK_GEN, &input, writable);
> > >               break;
> > >       case SEV_PDH_GEN:
> > > -             ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PDH_GEN, &input);
> > > +             ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PDH_GEN, &input, writable);
> > >               break;
> > >       case SEV_PEK_CSR:
> > > -             ret = sev_ioctl_do_pek_csr(&input);
> > > +             ret = sev_ioctl_do_pek_csr(&input, writable);
> > >               break;
> > >       case SEV_PEK_CERT_IMPORT:
> > > -             ret = sev_ioctl_do_pek_import(&input);
> > > +             ret = sev_ioctl_do_pek_import(&input, writable);
> > >               break;
> > >       case SEV_PDH_CERT_EXPORT:
> > > -             ret = sev_ioctl_do_pdh_export(&input);
> > > +             ret = sev_ioctl_do_pdh_export(&input, writable);
> > >               break;
> > >       case SEV_GET_ID:
> > >               pr_warn_once("SEV_GET_ID command is deprecated, use SEV_GET_ID2\n");
> > > --
> > > 2.24.1
> > >
> > >
> >
> 
> 
