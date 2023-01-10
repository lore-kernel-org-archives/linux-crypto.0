Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A9AC54EBC
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Jan 2023 16:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbjAJQxu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Jan 2023 11:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238958AbjAJQxq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2023 11:53:46 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2E2140BF
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 08:53:45 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id e13so13204512ljn.0
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 08:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UHlQmz4MZPCYm9BygwyVFf2S1z6UZf0NIZ7PiPTX9pQ=;
        b=eOEttK62GmXf0jQCMYIlYh623FQaOyPteJMvs+9gqBGF2BiED7YcvXEXCQPyMkpRna
         MqDTI5zO2JB7sPi8MMKGgWs8qHzcu9xaZ7kdKe94nzBkUQ9Ap0b9Iririg90SObGYe7c
         8mJfMbLaBJZqUbjXfMtt3E2BiHD58XiS6O9d3KpR4Z8Zd09eOfoBHNOal/QxXg1o7/Ih
         uLmjZ4/fl5d3uEtnyqwezEPLSWsEcpm1iCjMv056cTVE7Gw2huxUTiP08y8uqLZ4a1DQ
         1HxRNgQm74sTDb7Q2vmwJtBDjCZPgF38SMqoHI5W6WqeeYufRsMzfpvB5cidW0191Gah
         ynDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UHlQmz4MZPCYm9BygwyVFf2S1z6UZf0NIZ7PiPTX9pQ=;
        b=QaYlKwlXixKlNdfMF7QFGqL06c6UL+NvTynCJbvl8SEWJqNtrrVgHkssqsh0lbVky9
         82py6GMQKP1hF2q++biV+A9kVBWl3yFKJsLkq7ixbq9ZCdIIG/z5vknJmLe0r47XdOdf
         6tOf50iToGFw6x1Vhp9hK559V10t8G4pdZ2/WvF7Xzw5ArglrpgKA2IQ1J8UNzwjSx9e
         HvViW8lX1phOsgr6ulonq/o1Fz2nFJk59KO6F8KBA6k84Ai+3vA+v0daWDoOlg1RINdt
         vdxcD5Jq7mms0GqMDJ2a0gjZTLyjdeJLhBYMeZYdnZ3vDyE2VVFXssVo4VGndVAhR599
         qJLg==
X-Gm-Message-State: AFqh2krv8QHFMHhgFa7ulMNk8RlsPPyBePrxYyoMqAHHK3e0HC8OnrcM
        yz0ir/gIKG5dtrhyuXn93UkpcCe0ksATHgnJcn1EQw==
X-Google-Smtp-Source: AMrXdXt/FTDJ1jQlyl0sPF3dYRo062A9EttvZq77C4MjzFUPN4zhXdMvRHWsX1mn8ECQcKnN7yCNgz1PVzPs7wpARFY=
X-Received: by 2002:a2e:7316:0:b0:283:2205:3ba4 with SMTP id
 o22-20020a2e7316000000b0028322053ba4mr510837ljc.494.1673369623680; Tue, 10
 Jan 2023 08:53:43 -0800 (PST)
MIME-Version: 1.0
References: <20230110161831.2625821-1-trix@redhat.com> <CAMkAt6oqBH35=moST5nO_BXwc8k0M4h_8TvT9H6outR9vOw5qg@mail.gmail.com>
 <ecd0c7f2-f82c-845f-b1fe-a7d3bf495bb1@redhat.com>
In-Reply-To: <ecd0c7f2-f82c-845f-b1fe-a7d3bf495bb1@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 10 Jan 2023 09:53:32 -0700
Message-ID: <CAMkAt6rKfM_uvLRMaN3SSTYVfiMixVGtEyZjo38OG8L1HcfKdg@mail.gmail.com>
Subject: Re: [PATCH] crypto: initialize error
To:     Tom Rix <trix@redhat.com>
Cc:     brijesh.singh@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        nathan@kernel.org, ndesaulniers@google.com, rientjes@google.com,
        marcorr@google.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 10, 2023 at 9:48 AM Tom Rix <trix@redhat.com> wrote:
>
>
> On 1/10/23 8:27 AM, Peter Gonda wrote:
> > On Tue, Jan 10, 2023 at 9:18 AM Tom Rix <trix@redhat.com> wrote:
> >> clang static analysis reports this problem
> >> drivers/crypto/ccp/sev-dev.c:1347:3: warning: 3rd function call
> >>    argument is an uninitialized value [core.CallAndMessage]
> >>      dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
> >>      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >>
> >> __sev_platform_init_locked() can return without setting the
> >> error parameter, causing the dev_err() to report a gargage
> > garbage
> ok
> >
> >> value.
> >>
> >> Fixes: 3d725965f836 ("crypto: ccp - Add SEV_INIT_EX support")
> > Should this be: 'Fixes: 200664d5237f ("crypto: ccp: Add Secure
> > Encrypted Virtualization (SEV) command support")'
> >
> > Since in that patch an uninitialized error can be printed?
>
> It was a bit of a toss up on who is at fault. This is fine, i'll change
> this as well.

Ack. Not trying to play a blame game =]. Just thought this patch might
as well be backported back to anyone using this function.

If you are sending another version you can add:

Reviewed-by: Peter Gonda <pgonda@google.com>

>
> Thanks
>
> Tom
>
>
> > +void psp_pci_init(void)
> > +{
> > +       struct sev_user_data_status *status;
> > +       struct sp_device *sp;
> > +       int error, rc;
> > +
> > +       sp = sp_get_psp_master_device();
> > +       if (!sp)
> > +               return;
> > +
> > +       psp_master = sp->psp_data;
> > +
> > +       /* Initialize the platform */
> > +       rc = sev_platform_init(&error);
> > +       if (rc) {
> > +               dev_err(sp->dev, "SEV: failed to INIT error %#x\n", error);
> > +               goto err;
> > +       }
> >
> >
> > ...
> >
> > +static int __sev_platform_init_locked(int *error)
> > +{
> > +       struct psp_device *psp = psp_master;
> > +       int rc = 0;
> > +
> > +       if (!psp)
> > +               return -ENODEV;
> > +
> > +       if (psp->sev_state == SEV_STATE_INIT)
> > +               return 0;
> >
> >
> > So if !psp an uninitialized error is printed?
> >
> >> Signed-off-by: Tom Rix <trix@redhat.com>
> >> ---
> >>   drivers/crypto/ccp/sev-dev.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> >> index 56998bc579d6..643cccc06a0b 100644
> >> --- a/drivers/crypto/ccp/sev-dev.c
> >> +++ b/drivers/crypto/ccp/sev-dev.c
> >> @@ -1307,7 +1307,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
> >>   void sev_pci_init(void)
> >>   {
> >>          struct sev_device *sev = psp_master->sev_data;
> >> -       int error, rc;
> >> +       int error = 0, rc;
> >>
> >>          if (!sev)
> >>                  return;
> >> --
> >> 2.27.0
> >>
>
