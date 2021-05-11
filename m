Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79ABAC433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 18:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DC4C61628
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 18:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbhEKSCb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 May 2021 14:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbhEKSCb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 May 2021 14:02:31 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725E6C061574
        for <linux-crypto@vger.kernel.org>; Tue, 11 May 2021 11:01:24 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id j3-20020a05600c4843b02901484662c4ebso1712584wmo.0
        for <linux-crypto@vger.kernel.org>; Tue, 11 May 2021 11:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ib.tc; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z84ojFnO3I63AGsBdQQkFvZgYzhCDyhB8tix9vTvfK0=;
        b=ccUzi5CHn97bVf/XuZWiU0UtC1uFvLROzJ1gIjX9+ZvEWsBHB+C07HYNxo3rrAh3xI
         oHhUPAb099gY1DH5aXUhQZdm2+6IFqkmqpCf3G+XEeW684kazyPAyEz4+UK6FvLY6m4z
         pfkMUO+XztmLMJLSdZsTtq2pbzw6X1U0+YDIXjyGsLhVZOaidCmchGtSYmzikolaZUFP
         WLikfvj37FyGxw4q1FBhSpHwErCp10FvwVwQcdfXduOmYFH2GKGPmXNEQOCiNy/eDWvb
         YAaMHFaHexvhBe3u187kIGrNpXMuoNqAkY9Y4Qh/kOdb7KYdmuxbhrZzEIV0eG6b1o86
         7t+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z84ojFnO3I63AGsBdQQkFvZgYzhCDyhB8tix9vTvfK0=;
        b=giT8sulce6EQmZlZj3V7+6S+NlGieNt5Iv3aAzk3Jw95mC8vmY4KCPAiHuY+LfjvNi
         GPs6RMyipnVMwKBC2l7Q2BDxqRlK8hSchNjkTWIeJTiG9RIoP37kKCkZQ2qQyGZLEimN
         Iv/vBJk0VNEr59PG1f2zdN5dBFSVVkyvMhlGff/GYAnSWet7zbx34taVWCXfA7DTppt8
         eW3eyQvTLNZrTESoF/ItwN5VWEkr8/qGc7bJPXDNJU09uUG0F/OouULJtYsq0BvJHzSC
         VnETSbop1jI0o2nDzd5IH1Y5PJw+E1wa25TdVmD0Y0fPEy/akNF4iuMIybrIustlYgU+
         t7gA==
X-Gm-Message-State: AOAM530H4RxufzSWI0ejlJyrbT1i4t/tC12GFc8E1Z4ErLKLhSmUzAKr
        yVPnrCNqgzb3jklLXpP5qIbl/xaKzioaYXUMpveaqst+4+77dQ==
X-Google-Smtp-Source: ABdhPJxnLPeoUW0bGkdZbBCr8Q3EbLy8nihuDHUWflhXa8UHmc1D09DOyTogt4Q1aEK6XaFnn6+5o/j93erejMbhXek=
X-Received: by 2002:a7b:c0c4:: with SMTP id s4mr6837739wmh.174.1620756083172;
 Tue, 11 May 2021 11:01:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAE9cyGTQZXW-6YsmHu3mGSHonTztBszqaYske7PKgz0pWHxQKA@mail.gmail.com>
 <CAMj1kXHOVRDAt7-C8UKi=5=MAgQ9kQz=HUtiuK_gt7ch_i950w@mail.gmail.com>
In-Reply-To: <CAMj1kXHOVRDAt7-C8UKi=5=MAgQ9kQz=HUtiuK_gt7ch_i950w@mail.gmail.com>
From:   Mike Brooks <m@ib.tc>
Date:   Tue, 11 May 2021 11:01:11 -0700
Message-ID: <CALFqKjQVz7xyEZN0XWdGGHOfP4wRMsnU6amN11ege0XXbhQq8Q@mail.gmail.com>
Subject: Re: or should block size for xts.c set to 1 instead of AES block size?
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Kestrel seventyfour <kestrelseventyfour@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

xst(ecb()) can only produce a minimum of AES_BLOCK_SIZE of data -
sending in a smaller dataset will still return AES_BLOCK_SIZE of data.
If you try and pass in lets say 4 bytes - and then you truncate the
response to 4 bytes you'll lose data.

Moving to a smaller size is asking for trouble. IMHO.

-Michael Brooks

On Tue, May 11, 2021 at 8:48 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Fri, 7 May 2021 at 08:12, Kestrel seventyfour
> <kestrelseventyfour@gmail.com> wrote:
> >
> > Hi,
> >
> > one more thought, shouldn't the block size for generic xts set to 1 in
> > order to reflect that any input size length is allowed to the
> > algorithm?
> >
>
> I think this was discussed at some point on the list, and Herbert
> seemed to suggest that 1 was a better choice than AES_BLOCK_SIZE.
> You'd have to set the chunksize, though, to ensure that the input is
> presented in the right granularity, i.e., to ensure that the skcipher
> walk layer never presents less than chunksize bytes unless it is the
> end of the input.
>
> However, this is a flag day change, so you'd need to update all
> implementations at the same time. Otherwise, the extended tests (which
> compare accelerated implementations with xts(ecb(aes-generic))) will
> start failing on the cra_blocksize mismatch.
