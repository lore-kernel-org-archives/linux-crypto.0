Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E26C433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 16 May 2022 17:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344000AbiEPRNW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 May 2022 13:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiEPRNV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 May 2022 13:13:21 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9B431DDD
        for <linux-crypto@vger.kernel.org>; Mon, 16 May 2022 10:13:19 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id l19so18932487ljb.7
        for <linux-crypto@vger.kernel.org>; Mon, 16 May 2022 10:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lnCWwgYB3EALSRrRxrjPf1n9pXx9oCWVrfYCKzTAm98=;
        b=LRFEmYRBoMXSpZQdOYrb+Vu4h9LTz3chVOrf4UH1KxU8nXFyvtdMu7pVYlJFVaoA28
         vs10OOM/ZkZJYcxCryBaEMCHKHw2HXej4fFw+R8g/vQH/Y/Hw3LQV3RMmnh/nFofdw5M
         QLRqxjoSob5cyi20+56fFxCYH2VhvI4CFdKx6uPeBLPJ0viAMHWjXbYBPZMeCTULCpIW
         3sbY5B7SkeYkKLThbwwHnq5GI1a/R5Ld6iVANi6Oe1cTdgoxY/kY2UvexkwLPJjyOMxx
         8+XHyuaZ3BAP1DLSkwbh/P94twlCLQHB3OWlK2ri1tNa2KSct7PeXJjhIyWc4rroM4L7
         pa5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lnCWwgYB3EALSRrRxrjPf1n9pXx9oCWVrfYCKzTAm98=;
        b=NEzab9N7v35zVeE4qnIHaOY5+C4p9NzEjVaUM8+nXmUoMKRjP8q3mGg1vNc/5KMFAq
         D47J1JFnGyYQ8jrOTrCA0MnpB4+yn4UExoOmbngCgTg31xUApElBPb7A7TKyUsIW3ki/
         H9LsfvWShCIBbmblSwRPmiGMhrJQreBiaXeoRkh9AXq4pQZzvLp/8JiUmwORSsBhIP05
         DEoD3KQzs4itrIROYut/jFVkOIEeNXKAM1okoR3xd4bua4sXFSX4mNVnwEEK2RI6p6WP
         EffpztEIs6pNioRj5DmyznTqfV60wLQs/F/D+jIVLVFGT1XRSsKtycwjWRVV40ROR1B8
         v6fw==
X-Gm-Message-State: AOAM531onjXPzsaryNH3C9DIF62MSv7qozNjEZtr+MW7nRWwhYUFbN9R
        ImsCWtMHvIKh0xZzMipWHhAOdq1ihgTnxOZ9J8tvCw==
X-Google-Smtp-Source: ABdhPJzBEHVsSiNzP4zR1stWQaPZPEfQAH5aioIofZ5uwEr6EpYfJWDt/2/kOV8YEszOtT3ZZ/C/6598MObVeLWWWgY=
X-Received: by 2002:a2e:bd09:0:b0:24b:9e3:30c6 with SMTP id
 n9-20020a2ebd09000000b0024b09e330c6mr11544182ljq.282.1652721197296; Mon, 16
 May 2022 10:13:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220516154512.259759-1-john.allen@amd.com> <CAMkAt6oUxUFtNS4W0bzu13oWMdfnzfNrphH3OqwAkmxJcXhOqw@mail.gmail.com>
 <SN6PR12MB27678261F176C5D9B5BF64EF8ECF9@SN6PR12MB2767.namprd12.prod.outlook.com>
In-Reply-To: <SN6PR12MB27678261F176C5D9B5BF64EF8ECF9@SN6PR12MB2767.namprd12.prod.outlook.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 16 May 2022 10:13:05 -0700
Message-ID: <CAMkAt6q7kTGS5QgZRq9xc0HaEYyntmj3GRWehr-3Sb4y2eQ=HQ@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: ccp - Use kzalloc for sev ioctl interfaces to
 prevent kernel memory leak
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     "Allen, John" <John.Allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 16, 2022 at 9:02 AM Kalra, Ashish <Ashish.Kalra@amd.com> wrote:
>
> [AMD Official Use Only - General]
>
> Hello Peter,
>
> -----Original Message-----
> From: Peter Gonda <pgonda@google.com>
> Sent: Monday, May 16, 2022 10:53 AM
> To: Allen, John <John.Allen@amd.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>; Linux Crypto Mailing List <=
linux-crypto@vger.kernel.org>; Sean Christopherson <seanjc@google.com>; Len=
dacky, Thomas <Thomas.Lendacky@amd.com>; Kalra, Ashish <Ashish.Kalra@amd.co=
m>; LKML <linux-kernel@vger.kernel.org>; Andy Nguyen <theflow@google.com>; =
David Rientjes <rientjes@google.com>; stable@vger.kernel.org
> Subject: Re: [PATCH v2] crypto: ccp - Use kzalloc for sev ioctl interface=
s to prevent kernel memory leak
>
> On Mon, May 16, 2022 at 8:46 AM John Allen <john.allen@amd.com> wrote:
> >
> > For some sev ioctl interfaces, input may be passed that is less than
> > or equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data that PSP
> > firmware returns. In this case, kmalloc will allocate memory that is
> > the size of the input rather than the size of the data. Since PSP
> > firmware doesn't fully overwrite the buffer, the sev ioctl interfaces
> > with the issue may return uninitialized slab memory.
> >
> > Currently, all of the ioctl interfaces in the ccp driver are safe, but
> > to prevent future problems, change all ioctl interfaces that allocate
> > memory with kmalloc to use kzalloc.
> >
> > Fixes: e799035609e15 ("crypto: ccp: Implement SEV_PEK_CSR ioctl
> > command")
> > Fixes: 76a2b524a4b1d ("crypto: ccp: Implement SEV_PDH_CERT_EXPORT
> > ioctl command")
> > Fixes: d6112ea0cb344 ("crypto: ccp - introduce SEV_GET_ID2 command")
> > Cc: stable@vger.kernel.org
> > Reported-by: Andy Nguyen <theflow@google.com>
> > Suggested-by: David Rientjes <rientjes@google.com>
> > Suggested-by: Peter Gonda <pgonda@google.com>
> > Signed-off-by: John Allen <john.allen@amd.com>
> > ---
> > v2:
> >   - Add fixes tags and CC stable@vger.kernel.org
> > ---
>
>
> >static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp) { st=
ruct sev_user_data_status data; int ret;
>
> >ret =3D __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, &data, &argp->error=
); if (ret) return ret;
>
> >if (copy_to_user((void __user *)argp->data, &data, sizeof(data))) ret =
=3D -EFAULT;
>
> >return ret;
> >}
>
> >Would it be safer to memset @data here to all zeros too?
>
> It will be, but this command/function is safe as firmware will fill in th=
e whole buffer here with the PLATFORM STATUS data retuned to the user.

That does seem safe for now but I thought we decided it would be
prudent to not trust the PSPs implementation here and clear all the
buffers that eventually get sent to userspace?

>
> Thanks,
> Ashish
