Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD333C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Oct 2021 14:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 898B3610C9
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Oct 2021 14:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235294AbhJLOgv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Oct 2021 10:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237260AbhJLOgu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Oct 2021 10:36:50 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC23C061745
        for <linux-crypto@vger.kernel.org>; Tue, 12 Oct 2021 07:34:48 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id t9so87091717lfd.1
        for <linux-crypto@vger.kernel.org>; Tue, 12 Oct 2021 07:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h5yMuto80JoFAdSRxuic6aOBW+rt2vFNHvAzZQ/3FNs=;
        b=KaqGYXutI6Ybc4eg29VuD7PIlDdKsedh63dB1OtY4vC0jTHTXnN1YEal2Ix/9QGRcg
         AOZtpFM4Co8vmi1m9wsSbOCEyz8neyZrNzuzzVHRym/ePYiGBiS/iuZGPRfn0wSyQwZe
         CUBRDuW45fmObbSWMGOtawFt1in94Lb2uZgJaA+AUeQR801b3SbmwDtISoyJJK6MI6j9
         USB44iK/uzJyHQD4BmTGauqSyh7Bt8cRPiA/6kbqCUnu/2w1A7cGSBNRkpaF7itjoMS/
         Nr6aa766kd99/XGHA+B3Qr7aeYUxfupm7hatK0TugtdI7nDpRiuFbtTxvkxNtmLBeDCk
         FeOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h5yMuto80JoFAdSRxuic6aOBW+rt2vFNHvAzZQ/3FNs=;
        b=5HR+zI4vYCcbDNacMIUy5qDZdZP9FDTXWmcSVkwuGzEob7zGyUVtKinv17tIyKjrH4
         VLv5O2X8uqa9s26gWOcwIe5u/akkm8pHVz8DSg6Lk3CB7NxZeusAoZxa1EM8n/6arAo+
         +yW3XL2eB8/30iRoh+kG2P8h3M9/2dS133uDSQuLezIAaU0EeeY6W+Rxei7x64dT1kBo
         HKHKPZv/BOcOYA8Wsj8E7kPbEV7uJvhLzAxgGA1WeZEsTHU60BauVBdVQq/7LK9UDwk3
         EnxzxUkHZaJQ8f0yKL+vuF/L0bae7xer4AoOdOxwQ67tHjqeILLqlOQUOBskbZUoaIGK
         8f2w==
X-Gm-Message-State: AOAM5334KHizgEmpUpGgeU6OY3gt9P5FRE93tGLpMPn+bV9t3RF4PiCM
        c6rXO82XEW/zly8zUn7T0AHrwfRD8J+UTp2lc407/LmV47c=
X-Google-Smtp-Source: ABdhPJx4XYPBQn3R3kuVR9Ymld5M9oRjbA9SN6AgSqmBTCXLMQ62j7215pABtzQ6meOMLmIqE40l5TbiIU9/CjNehgI=
X-Received: by 2002:a05:6512:398a:: with SMTP id j10mr33390426lfu.402.1634049285215;
 Tue, 12 Oct 2021 07:34:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211005195213.2905030-1-pgonda@google.com> <fdf0c263-38e9-7780-d0ac-943b6d2dd3a3@amd.com>
In-Reply-To: <fdf0c263-38e9-7780-d0ac-943b6d2dd3a3@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 12 Oct 2021 08:34:33 -0600
Message-ID: <CAMkAt6piNiJdHDMzSqgm-aQ0o-xxM=ax4qMgn81fKzVuaNukPg@mail.gmail.com>
Subject: Re: [PATCH] crypto: ccp - Consolidate sev INIT logic
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Rientjes <rientjes@google.com>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 8, 2021 at 9:52 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
>
> On 10/5/21 12:52 PM, Peter Gonda wrote:
> >
> > +static int sev_init_if_required(int cmd_id, bool writable,
> > +                             struct sev_issue_cmd *argp)
> > +{
> > +     struct sev_device *sev = psp_master->sev_data;
> > +
> > +     lockdep_assert_held(&sev_cmd_mutex);
> > +
> > +     if (!writable)
> > +             return -EPERM;
> > +
> > +     if (cmd_id == SEV_FACTORY_RESET || cmd_id == SEV_PLATFORM_STATUS ||
> > +         cmd_id == SEV_GET_ID || cmd_id == SEV_GET_ID2)
> > +             return 0;
> > +
> > +     if (sev->state == SEV_STATE_UNINIT)
> > +             return __sev_platform_init_locked(&argp->error);
> > +
> > +     return 0;
> > +}
> > +
> >  static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
> >  {
> >       void __user *argp = (void __user *)arg;
> > @@ -840,8 +825,11 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
> >
> >       mutex_lock(&sev_cmd_mutex);
> >
> > -     switch (input.cmd) {
> > +     ret = sev_init_if_required(input.cmd, writable, &input);
> > +     if (ret)
> > +             goto copy_out;
>
> We need to call this function only for the SEV commands (i.e input.cmd
> >=0 && input.cmd <= SEV_GET_ID2). Otherwise a invalid command may
> trigger SEV_INIT. e.g below sequence:
>
> 1) SEV_FACTORY_RESET   // this will transition the fw to UNINIT state.
>
> 2) <INVALID_CMD_ID>   // since fw was in uninit this invalid command
> will initialize the fw and then later switch will fail.

Good catch, I took Marc's suggested approach for a V2. Does that sound
reasonable?

>
> thanks
>
>
