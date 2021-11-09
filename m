Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE19C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Nov 2021 20:46:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82B4961208
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Nov 2021 20:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244679AbhKIUtL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Nov 2021 15:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244690AbhKIUtK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Nov 2021 15:49:10 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAB7C061766
        for <linux-crypto@vger.kernel.org>; Tue,  9 Nov 2021 12:46:23 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id u11so586322lfs.1
        for <linux-crypto@vger.kernel.org>; Tue, 09 Nov 2021 12:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h/+CbKq/m1ljNtqbFpAY5SzIXPWvs2rPCrXQESajW3U=;
        b=Pxiyrg0kL9gFnc303lUkSLXOtBilXGSzuIlg+7snZRipRbEF2vonmMf7LBf5J46PVY
         upPdqY3q2wdW45zgRPeiHPxzjeKNulStrEgNCOY5FqVewkz6RouIPsO5bbnwkfxe8hyV
         XX40SoWRolwbr5VpTmI+vDypESMdipTgzEZ/YikWLcYR7pjuNdkQDm+UjZPemxywvFvm
         Q6R2SJ4DSXcgQZdk+eJRUjnTWltG0eiMfPuJI3e92Xq7grv0Q7gyqylDisIvS+C/HMPF
         OjEFzaa/6oUwEjtanmDw/zxsxmIXuFUCUbfWJVG1LReQ1a53zxb1UnvleEhFYL+1qKwJ
         w9Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h/+CbKq/m1ljNtqbFpAY5SzIXPWvs2rPCrXQESajW3U=;
        b=ODE6dtKQSgE6NRsFwU31iqEHeGQHbtAmopZN/5nadj3GsN6vZGt8C4o2LmlYab4FPf
         unLZBSTWPx21Dx4CDCnSvkt1xjPDLP5f5IrGYUxdefEvhCrAPgEDV5EG7eTknebvxS+9
         dMvmXu9ZH+m/4lmKlKxPl59FZFJhqQtVq+BshIq9lY3pnjqsZrYzceppaaqfH9RwKVqk
         soKZd3qbneT/5LhCZ8uMpnLDHPoPIxjaXL1Bykefr0tnQrzcaYBeINaPAfTl3M8IZxaX
         2WGVyNRsWAm1ODNrWKvVEI1spl6g7/sZKKh/8U4ztFPCd5uvMjZH/ziZh0jdDNOJdFDW
         s8PA==
X-Gm-Message-State: AOAM531fGiZjvZJVBWcYUCjc5Ese+4I/oKb2YuTkS+EAwjc8ZFq+aAdn
        T70rpH+eGm5aD3DoMepcu9nAuHCO7wLP50lbJmzY9zi64mVqGQ==
X-Google-Smtp-Source: ABdhPJyRf41tSXXZGblCI19wMvjqN7NkuJ3p8xKiunNz/ji3yFm05cs5kPxucQ4hbYfeenAKT9BzNOubKOto5zp3H5s=
X-Received: by 2002:a05:6512:39d1:: with SMTP id k17mr9432393lfu.79.1636490781953;
 Tue, 09 Nov 2021 12:46:21 -0800 (PST)
MIME-Version: 1.0
References: <20211102142331.3753798-1-pgonda@google.com> <20211102142331.3753798-5-pgonda@google.com>
 <YYquDWbkIwCkixxD@google.com> <CAMkAt6rHdsdD-L4PbZL7qaOY7GRHmApVJam0V0yY2BnYdhmPjA@mail.gmail.com>
 <YYrZXRTukz3RccPN@google.com>
In-Reply-To: <YYrZXRTukz3RccPN@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 9 Nov 2021 13:46:10 -0700
Message-ID: <CAMkAt6qauoiTBXF9VXRGiqtJD5pTAV=NqKHZgNFXHCkrR50gkg@mail.gmail.com>
Subject: Re: [PATCH V3 4/4] crypto: ccp - Add SEV_INIT_EX support
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas.Lendacky@amd.com, David Rientjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>,
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

On Tue, Nov 9, 2021 at 1:26 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Nov 09, 2021, Peter Gonda wrote:
> > On Tue, Nov 9, 2021 at 10:21 AM Sean Christopherson <seanjc@google.com> wrote:
> > > There's no need for this to be a function pointer, and the duplicate code can be
> > > consolidated.
> > >
> > > static int sev_do_init_locked(int cmd, void *data, int *error)
> > > {
> > >         if (sev_es_tmr) {
> > >                 /*
> > >                  * Do not include the encryption mask on the physical
> > >                  * address of the TMR (firmware should clear it anyway).
> > >                  */
> > >                 data.flags |= SEV_INIT_FLAGS_SEV_ES;
> > >                 data.tmr_address = __pa(sev_es_tmr);
> > >                 data.tmr_len = SEV_ES_TMR_SIZE;
> > >         }
> > >         return __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> > > }
> > >
> > > static int __sev_init_locked(int *error)
> > > {
> > >         struct sev_data_init data;
> > >
> > >         memset(&data, 0, sizeof(data));
> > >         return sev_do_init_locked(cmd, &data, error);
> > > }
> > >
> > > static int __sev_init_ex_locked(int *error)
> > > {
> > >         struct sev_data_init_ex data;
> > >
> > >         memset(&data, 0, sizeof(data));
> > >         data.length = sizeof(data);
> > >         data.nv_address = __psp_pa(sev_init_ex_nv_address);
> > >         data.nv_len = NV_LENGTH;
> > >         return sev_do_init_locked(SEV_CMD_INIT_EX, &data, error);
> > > }
> >
> > I am missing how this removes the duplication of the retry code,
> > parameter checking, and other error checking code.. With what you have
> > typed out I would assume I still need to function pointer between
> > __sev_init_ex_locked and __sev_init_locked. Can you please elaborate
> > here?
>
> Hmm.  Ah, I got distracted between the original thought, the realization that
> the two commands used different structs, and typing up the above.
>
> > Also is there some reason the function pointer is not acceptable?
>
> It's not unacceptable, it would just be nice to avoid, assuming the alternative
> is cleaner.  But I don't think any alternative is cleaner, since as you pointed
> out the above is a half-baked thought.

OK I'll leave as is.

>
> > > > +     rc = init_function(error);
> > > >       if (rc && *error == SEV_RET_SECURE_DATA_INVALID) {
> > > >               /*
> > > >                * INIT command returned an integrity check failure
> > > > @@ -286,8 +423,8 @@ static int __sev_platform_init_locked(int *error)
> > > >                * failed and persistent state has been erased.
> > > >                * Retrying INIT command here should succeed.
> > > >                */
> > > > -             dev_dbg(sev->dev, "SEV: retrying INIT command");
> > > > -             rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> > > > +             dev_notice(sev->dev, "SEV: retrying INIT command");
> > > > +             rc = init_function(error);
> > >
> > > The above comment says "persistent state has been erased", but __sev_do_cmd_locked()
> > > only writes back to the file if a relevant command was successful, which means
> > > that rereading the userspace file in __sev_init_ex_locked() will retry INIT_EX
> > > with the same garbage data.
> >
> > Ack my mistake, that comment is stale. I will update it so its correct
> > for the INIT and INIT_EX flows.
> > >
> > > IMO, the behavior should be to read the file on load and then use the kernel buffer
> > > without ever reloading (unless this is built as a module and is unloaded and reloaded).
> > > The writeback then becomes opportunistic in the sense that if it fails for some reason,
> > > the kernel's internal state isn't blasted away.
> >
> > One issue here is that the file read can fail on load so we use the
> > late retry to guarantee we can read the file.
>
> But why continue loading if reading the file fails on load?
>
> > The other point seems like preference. Users may wish to shutdown the PSP FW,
> > load a new file, and INIT_EX again with that new data. Why should we preclude
> > them from that functionality?
>
> I don't think we should preclude that functionality, but it needs to be explicitly
> tied to a userspace action, e.g. either on module load or on writing the param to
> change the path.  If the latter is allowed, then it needs to be denied if the PSP
> is initialized, otherwise the kernel will be in a non-coherent state and AFAICT
> userspace will have a heck of a time even understanding what state has been used
> to initialize the PSP.

If this driver is builtin the filesystem will be unavailable during
__init. Using the existing retries already built into
sev_platform_init() also the file to be read once userspace is
running, meaning the file system is usable. As I tried to explain in
the commit message. We could remove the sev_platform_init call during
sev_pci_init since this only actually needs to be initialized when the
first command requiring it is issues (either reading some keys/certs
from the PSP or launching an SEV guest). Then userspace in both the
builtin and module usage would know running one of those commands
cause the file to be read for PSP usage. Tom any thoughts on this?
