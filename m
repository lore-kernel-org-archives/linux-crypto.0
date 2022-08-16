Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D86C2BB41
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 19:31:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237039AbiHPTbP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 15:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236981AbiHPTbP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 15:31:15 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6EC86FD2
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 12:31:13 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-3321c2a8d4cso124789447b3.5
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 12:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=iMxjOZkPS3Xw0tjseLgP2hg27ktJ+UlQhpn4x6B0z1w=;
        b=kxuzVCFQS1AMfk/0UpceVEygJXpfOqBh2OcWKb+SVKQ7IUUxUZE/4sPjqKelLAw7Pl
         nuV4WZKcJcwxZJwzCjLEjFfw5F2POJItL96fjBLnLO1z1IWohs0+3isVwSgtmpmcu1v/
         dCs4KFqmlSUWx+oRJIvhLoAwwATWZz19C8Yd2cIKSikSx0neztCfRg0PGj8ykIC1wnGC
         WBX71r8Sf/3OGg16Bw7wufngsu8PBYYqCju3GM+/3y+Ln/SBUqPbxkqYvagw9Fwo1uf4
         1YYbb7Z1w8O+lYbTK8T8Lv75RiLPeLOAv4SN7LCqwdh8AElmL/vAe5iBtGRgdhW2eUi+
         VFjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=iMxjOZkPS3Xw0tjseLgP2hg27ktJ+UlQhpn4x6B0z1w=;
        b=PbfDFOwMJ3tDJH6y7+3QoiyM/+J92xCEs4q93FqGoNeHItzNxC3mb5BJwKws3vrsue
         WmhVKI4lhCScX/iI6H4pwjqcpW3qqc8z214DsnL9yx3giNxFu+9PHJ8C5VR2EBir4NI/
         kYfna1hp/grcsuLY/OdtpMG4Cpos4NLe4NR9LpkSUVWFuKCUYlvyy6h2JG5aweGLo1ec
         aeySBU9qV/85HsWori6DMxt4LPF2YuMAfh139jtITk6Tyxgck39GJERLRLtzm1e0EqwS
         Pe/VOm2+r7CwDy65zGvNamwXRQowEhVKF9imrMpQzSrTiCF2tq7BAyOpcA4R6e/oZh0r
         IJyg==
X-Gm-Message-State: ACgBeo2aMkjMZC9sQ5FBIDRicN2LCU8HvvkMSm8JTZVXiL3oKuEhXqfp
        jGCmJAnJ6B+R8TZWnGLgySptz821F62UaD0+Qo5m
X-Google-Smtp-Source: AA6agR5TSjOoMoUuomGYvLfA5oTfo+LERdWqWhIESjcEmws/EH7Z9wWjRkWUPTdOn9XQ1lKMaDJfEK60f/aB7snKf4w=
X-Received: by 2002:a25:490:0:b0:67c:22be:65db with SMTP id
 138-20020a250490000000b0067c22be65dbmr16098075ybe.16.1660678272805; Tue, 16
 Aug 2022 12:31:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220802185534.735338-1-jackyli@google.com> <20220802185534.735338-2-jackyli@google.com>
 <8dd975d4-e9fc-00eb-d630-cd09410121dc@amd.com>
In-Reply-To: <8dd975d4-e9fc-00eb-d630-cd09410121dc@amd.com>
From:   Jacky Li <jackyli@google.com>
Date:   Tue, 16 Aug 2022 12:31:01 -0700
Message-ID: <CAJxe5cv4tY0docsvOP2V5bp3hXhNYwepLhpzyiHn+8nfkw5y0Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: ccp - Initialize PSP when reading psp data
 file failed
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Marc Orr <marcorr@google.com>, Alper Gun <alpergun@google.com>,
        Peter Gonda <pgonda@google.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 10, 2022 at 1:28 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 8/2/22 13:55, Jacky Li wrote:
> > Currently the OS fails the PSP initialization when the file specified at
> > 'init_ex_path' does not exist or has invalid content. However the SEV
> > spec just requires users to allocate 32KB of 0xFF in the file, which can
> > be taken care of by the OS easily.
> >
> > To improve the robustness during the PSP init, leverage the retry
> > mechanism and continue the init process:
> >
> > During the first INIT_EX call, if the content is invalid or missing,
> > continue the process by feeding those contents into PSP instead of
> > aborting. PSP will then override it with 32KB 0xFF and return
> > SEV_RET_SECURE_DATA_INVALID status code. In the second INIT_EX call,
> > this 32KB 0xFF content will then be fed and PSP will write the valid
> > data to the file.
> >
> > In order to do this, it's also needed to skip the sev_read_init_ex_file
> > in the second INIT_EX call to prevent the file content from being
> > overwritten by the 32KB 0xFF data provided by PSP in the first INIT_EX
> > call.
> >
> > Co-developed-by: Peter Gonda <pgonda@google.com>
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> > Signed-off-by: Jacky Li <jackyli@google.com>
> > Reported-by: Alper Gun <alpergun@google.com>
> > ---
> >   .../virt/kvm/x86/amd-memory-encryption.rst    |  5 ++--
> >   drivers/crypto/ccp/sev-dev.c                  | 29 +++++++++++++------
> >   2 files changed, 22 insertions(+), 12 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> > index 2d307811978c..935aaeb97fe6 100644
> > --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> > +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> > @@ -89,9 +89,8 @@ context. In a typical workflow, this command should be the first command issued.
> >
> >   The firmware can be initialized either by using its own non-volatile storage or
> >   the OS can manage the NV storage for the firmware using the module parameter
> > -``init_ex_path``. The file specified by ``init_ex_path`` must exist. To create
> > -a new NV storage file allocate the file with 32KB bytes of 0xFF as required by
> > -the SEV spec.
> > +``init_ex_path``. If the file specified by ``init_ex_path`` does not exist or
> > +is invalid, the OS will create or override the file with output from PSP.
> >
> >   Returns: 0 on success, -negative on error
> >
> > diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> > index 799b476fc3e8..5bb2ae250d38 100644
> > --- a/drivers/crypto/ccp/sev-dev.c
> > +++ b/drivers/crypto/ccp/sev-dev.c
> > @@ -75,6 +75,7 @@ static void *sev_es_tmr;
> >    */
> >   #define NV_LENGTH (32 * 1024)
> >   static void *sev_init_ex_buffer;
> > +static bool nv_file_loaded;
> >
> >   static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
> >   {
> > @@ -211,18 +212,19 @@ static int sev_read_init_ex_file(void)
> >       if (IS_ERR(fp)) {
> >               int ret = PTR_ERR(fp);
> >
> > -             dev_err(sev->dev,
> > -                     "SEV: could not open %s for read, error %d\n",
> > -                     init_ex_path, ret);
> > +             if (ret != -ENOENT) {
> > +                     dev_err(sev->dev,
> > +                             "SEV: could not open %s for read, error %d\n",
> > +                             init_ex_path, ret);
> > +             }
>
> Shouldn't there still be some kind of message if the file is missing? A
> typo could result in a file being created that the user isn't expecting.
> At least indicating that the file will now possibly be created might be
> good. Maybe not here, since this is called multiple times, though.
>

This function will actually only be called once during the psp
initialization, I will add an info message here in v2 to indicate the
file would be created when missing, thanks!

> >               return ret;
> >       }
> >
> >       nread = kernel_read(fp, sev_init_ex_buffer, NV_LENGTH, NULL);
> >       if (nread != NV_LENGTH) {
> > -             dev_err(sev->dev,
> > -                     "SEV: failed to read %u bytes to non volatile memory area, ret %ld\n",
> > +             dev_info(sev->dev,
> > +                     "SEV: could not read %u bytes to non volatile memory area, ret %ld\n",
> >                       NV_LENGTH, nread);
> > -             return -EIO;
> >       }
> >
> >       dev_dbg(sev->dev, "SEV: read %ld bytes from NV file\n", nread);
> > @@ -417,9 +419,18 @@ static int __sev_init_ex_locked(int *error)
> >       data.nv_address = __psp_pa(sev_init_ex_buffer);
> >       data.nv_len = NV_LENGTH;
> >
> > -     ret = sev_read_init_ex_file();
> > -     if (ret)
> > -             return ret;
> > +     /*
> > +      * The caller of INIT_EX will retry if it fails. Furthermore, if the
>
> This is a little confusing since this function, __sev_init_ex_locked(), is
> the caller of INIT_EX. Maybe say "The caller of __sev_init_ex_locked()
> will retry..."
>

I'm going to move the sev_read_init_ex_file() to the caller of this
function (i.e. __sev_platform_init_locked) in v2 so that it's less
confusing.

> > +      * failure is due to sev_init_ex_buffer being invalid, the PSP will have
> > +      * properly initialized the buffer already. Therefore, do not initialize
> > +      * it a second time.
> > +      */
> > +     if (!nv_file_loaded) {
> > +             ret = sev_read_init_ex_file();
> > +             if (ret && ret != -ENOENT)
> > +                     return ret;
> > +             nv_file_loaded = true;
>
> This is really meant to show the INIT_EX has been called, right? Maybe
> move this and part of the above comment to just before the call to
> INIT_EX. That will make this a bit less confusing.
>
> But, going back to the changes in sev_read_init_ex_file(), couldn't you
> just return 0 in the "if (IS_ERR(fp)) {" path if ret == -ENOENT? Then you
> don't have to check for it here, too.
>
> Thanks,
> Tom
>

Thanks Tom, this is a great suggestion. I will move the
sev_read_init_ex_file() before the call to the INIT_EX as well as
returning 0 for sev_read_init_ex_file when the file is missing in v2.

Thanks,
Jacky

> > +     }
> >
> >       if (sev_es_tmr) {
> >               /*
