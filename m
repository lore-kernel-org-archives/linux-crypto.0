Return-Path: <SRS0=ef2Z=W3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 697FEC3A5A6
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Aug 2019 16:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3340921874
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Aug 2019 16:38:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dYXFBAYx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbfHaQiC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Aug 2019 12:38:02 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35253 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728119AbfHaQiB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Aug 2019 12:38:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id g7so9911685wrx.2
        for <linux-crypto@vger.kernel.org>; Sat, 31 Aug 2019 09:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mHCgJTa167mXOf521wY9Uhp8C8rQVMSZvRt1D4lWNlU=;
        b=dYXFBAYxoNOiN1xNVpdMIn8W8TYv7nuYIRPaL9r9sf2ARnssriUhdkMoOCH8ji3jbb
         y67Np56SMreukzf95+aotZk/sxdeq9j2rEKCTcLkpJcnUI4MYooy/rtu7TBQQORAoxM+
         VSAe9IIfJgUTQETHvvd2mbIEZ2RefeggyVhxa6FgQSnxiiRmIZw9jiLeYBthLnte18ZD
         x45mSZueT0qq9CgxPvD7X/URNqgGSCVS0vONh659TayRHNhrVqMYNb7mE2n9+dowpMqC
         NZJXwH2hZ4F+aZaUKhSfbHROcpn0SK1816l5laIWLogLV3gczX05KA2mlqdae7hTijIr
         9tGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mHCgJTa167mXOf521wY9Uhp8C8rQVMSZvRt1D4lWNlU=;
        b=jXgb/Ac5TepIuQUIuOZ8rkHqOufR1rX86ALU75AknLTTj7TYC136baNYIWsUbg1k37
         HY3Q85HmSSW5wGoSLk5c8VHzznioE29ncjDYZy4WRRtzCJMp4sfJRM9x5evI+IPY35pC
         LRqp1umj/+H0YnVtZewRIsiXRhx2BE9CZxhUgvHtiNEQdD2QaruCCs30fQFyKcJtt3JS
         YcX6PXFDnMVmZIW7qU9rQwjFMEeiUAGaFDoFHjwYI24rm1OINk2nKz14BGL0UoOdqjvr
         K4MU0X/ymZSVYLjxR84Fbq0vKfgzX1tkdTViYlgE+V2achNr4BUbjP/3OsfjBwJx5jIC
         t77g==
X-Gm-Message-State: APjAAAVAZ1zK/OxX8EWu2zY/m72rH/wGDb0aa7tAVvuy/foOE7JPTNIE
        sIE8hPyGLg5A+63tVlpgD5zH66mpar0L2QMRIOKNvA==
X-Google-Smtp-Source: APXvYqxOF01WJIu5hP8TwQQKuuOgCrfcvI06umhuEUCpy+lqt2cBpviobMUs+d2ImL+amyZ4Tf04ZZJPwIXR8WA5nmc=
X-Received: by 2002:adf:ee50:: with SMTP id w16mr7303621wro.93.1567269480090;
 Sat, 31 Aug 2019 09:38:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
 <20190819141738.1231-2-ard.biesheuvel@linaro.org> <20190830045822.GA17901@gondor.apana.org.au>
In-Reply-To: <20190830045822.GA17901@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 31 Aug 2019 19:37:48 +0300
Message-ID: <CAKv+Gu-7c+L4KzC=h=rBxLhZRt3RhK3eO2L2NvVrajR0MX_9+g@mail.gmail.com>
Subject: Re: [PATCH v13 1/6] crypto: essiv - create wrapper template for ESSIV generation
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 30 Aug 2019 at 07:58, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Aug 19, 2019 at 05:17:33PM +0300, Ard Biesheuvel wrote:
> > Implement a template that wraps a (skcipher,shash) or (aead,shash) tuple
> > so that we can consolidate the ESSIV handling in fscrypt and dm-crypt and
> > move it into the crypto API. This will result in better test coverage, and
> > will allow future changes to make the bare cipher interface internal to the
> > crypto subsystem, in order to increase robustness of the API against misuse.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  crypto/Kconfig  |  28 +
> >  crypto/Makefile |   1 +
> >  crypto/essiv.c  | 663 ++++++++++++++++++++
> >  3 files changed, 692 insertions(+)
>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Milan,

Hopefully, this can still be taken for v5.4. If not, please coordinate
with Eric on how to get this queued for v5.5

Thanks,
Ard.
