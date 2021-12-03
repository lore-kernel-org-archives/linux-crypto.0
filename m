Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75790C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Dec 2021 21:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383303AbhLCVwZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Dec 2021 16:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383250AbhLCVwY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Dec 2021 16:52:24 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6BFC061353
        for <linux-crypto@vger.kernel.org>; Fri,  3 Dec 2021 13:48:59 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id k23so8764944lje.1
        for <linux-crypto@vger.kernel.org>; Fri, 03 Dec 2021 13:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IDeRdhpoAj5TSghltVaQSNuQnQhtbp2XMUe5m+RBa+I=;
        b=AmnHaybw1fg068uclusv+Qkf8yVpSqijeFrG4mXWsQ+WSlp7R4+WViXHmBDTFmVCpM
         aUnDsTw8VWeCO+uN6p553IHfpe1Xvy/YAnpBLWbOAe/mp12nU3bH9E8k6VL1vxD7ECzs
         jIl5sfF2WjIRwm9rNigtt3g2SZnMWQuhbnSTG+d2OYwEvExlf8qejUhFTurjvYh9zL1/
         Ff7jdhpmm6HEk+QgmCq8SZB7yjg5YKh01/MyUqtvfyUrEVWesoK4I4m99rDgMe/+mCT0
         aQhJIr+NwwbZ5bFGXXAifh2g4xPZkFZE+PsQeVgO5hdOfocvAPkNi5rrzB9TIbDD01L/
         VhRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IDeRdhpoAj5TSghltVaQSNuQnQhtbp2XMUe5m+RBa+I=;
        b=PtDvM6dDKigQUIXI6L4jDcYW0DggaK2spFjRLJkjdnNXTICDU9S37HPsF5eLhsL9Mu
         ReZfBopCg7/2fFH5fcYLQy2b3RWRglwToRgkC7YqcKhgfJTCFVH2O8+vEADQZs1jEbt8
         iMqpjJtnm2BLD/xT1HSPsgYZEubbnKxZGi8tpFnvmUY+KpgW6iqpXAuhjJtT6mkfzmWl
         r3+aK4ZQx/dBHg3RmpLObg/UBQf9o+JMkYMzxV/xtCi8WbHA/CP+zRGT2aGFGlFo8B8s
         xHKiJVmkVVlIbrnpOZDI6Sc+1YmJsXjSu5QWNXbMz2UWFk1zMuPmTZHxntfHq6xD2GqU
         csew==
X-Gm-Message-State: AOAM530c3nzka9/EEOebthr/wE1bjswAs7nuTNjDKl9sYNDW+Eqinu3S
        Er+96BBy8Tl/kPqrdA6w2PHLd57xIRkFB9m6ULk4dw==
X-Google-Smtp-Source: ABdhPJxM7LeVBwx6zhzZJsNSW09G7vvN0O+sWKe2aJIvH1OvYBXnNTsyCYdJVgv1iUularp0CKJShjGpLxkPivWjvAc=
X-Received: by 2002:a2e:b169:: with SMTP id a9mr21273034ljm.369.1638568137816;
 Fri, 03 Dec 2021 13:48:57 -0800 (PST)
MIME-Version: 1.0
References: <20211115174102.2211126-1-pgonda@google.com> <20211126051944.GA17358@gondor.apana.org.au>
In-Reply-To: <20211126051944.GA17358@gondor.apana.org.au>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 3 Dec 2021 14:48:46 -0700
Message-ID: <CAMkAt6o_bjdoQ7zTs7ZY5QrYcd2Wd7GzMzRMq8m5ZUBQRQMtVw@mail.gmail.com>
Subject: Re: [PATCH V4 0/5] Add SEV_INIT_EX support
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Thomas.Lendacky@amd.com, Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 25, 2021 at 10:20 PM Herbert Xu <herbert@gondor.apana.org.au> w=
rote:
>
> On Mon, Nov 15, 2021 at 09:40:57AM -0800, Peter Gonda wrote:
> > SEV_INIT requires users to unlock their SPI bus for the PSP's non
> > volatile (NV) storage. Users may wish to lock their SPI bus for numerou=
s
> > reasons, to support this the PSP firmware supports SEV_INIT_EX. INIT_EX
> > allows the firmware to use a region of memory for its NV storage leavin=
g
> > the kernel responsible for actually storing the data in a persistent
> > way. This series adds a new module parameter to ccp allowing users to
> > specify a path to a file for use as the PSP's NV storage. The ccp drive=
r
> > then reads the file into memory for the PSP to use and is responsible
> > for writing the file whenever the PSP modifies the memory region.
> >
> > V3
> > * Add another module parameter 'psp_init_on_probe' to allow for skippin=
g
> >   PSP init on module init.
> > * Fixes review comments from Sean.
> > * Fixes missing error checking with file reading.
> > * Removed setting 'error' to a set value in patch 1.
>
> This doesn't compile cleanly for me with C=3D1 W=3D1:
>
>   CC [M]  drivers/crypto/ccp/sev-dev.o
> In file included from ../arch/x86/include/asm/bug.h:84,
>                  from ../include/linux/bug.h:5,
>                  from ../include/linux/cpumask.h:14,
>                  from ../arch/x86/include/asm/cpumask.h:5,
>                  from ../arch/x86/include/asm/msr.h:11,
>                  from ../arch/x86/include/asm/processor.h:22,
>                  from ../arch/x86/include/asm/timex.h:5,
>                  from ../include/linux/timex.h:65,
>                  from ../include/linux/time32.h:13,
>                  from ../include/linux/time.h:60,
>                  from ../include/linux/stat.h:19,
>                  from ../include/linux/module.h:13,
>                  from ../drivers/crypto/ccp/sev-dev.c:10:
> ../drivers/crypto/ccp/sev-dev.c: In function =E2=80=98sev_read_init_ex_fi=
le=E2=80=99:
> ../include/linux/lockdep.h:286:52: error: invalid type argument of =E2=80=
=98->=E2=80=99 (have =E2=80=98struct mutex=E2=80=99)
>  #define lockdep_is_held(lock)  lock_is_held(&(lock)->dep_map)
>                                                     ^~
> Please fix and resubmit.

Thanks. Submitted a V5.1 with fixes.

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
