Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A3F2C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Feb 2022 20:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353222AbiBKUak (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Feb 2022 15:30:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351181AbiBKUaj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Feb 2022 15:30:39 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA33CCCC
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 12:30:37 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id e17so14046221ljk.5
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 12:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QRDH9vbLQS3f2Q0ccQNr5Qp4Ug7VGO9DxqH6NW74phY=;
        b=NJIxKes7hqTAQq6UETKdRks+KkvgxMtmurUEuG0s8UMHc3d/LRgcB/qBrCsrX0FFVA
         uZ5lyBVJufxhoGZLIH3NGuSNMbTVXbfgT8/MifUJQFws3Ts8wbGQ5JshOYM7+NQUWBgU
         uHwliOvgNoDGpAEG4oKjQVATcchkoR7JLQ8g2524zxfpFA+sVznoAzKcH2nJf8hlgmrE
         meUKL3x10CCZwPRsO3c5IiKsnrWPnR8gbX3KbMrcOY6TtQrMjUh5xSzEUDX9zfZx1UjG
         9j4fdB3t7L4H6AvSjX0NQkcMYL1jASb6M0umgeviBWV96O5v+tT1W+aspMd6uEw6lfdz
         R1sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QRDH9vbLQS3f2Q0ccQNr5Qp4Ug7VGO9DxqH6NW74phY=;
        b=7bInpN0HVWw4d6TNX1hAFp775hwTv89kWAOvr1mDiGvTCbdy4bJolcfLftEBrAeknX
         2TvCoqSJ88I35s52C20/kQeWjg0IhxMjRrBwUtTnECL7zfgkZ17J9Jc5Oar+7Rhjwxwt
         RovHZar8AcXpkuRFhXpdoVik1pi2wI7y/cpRRySgMVEoI/HW6ti61wRkKvL0OyxQd77L
         uNwI0M7XuT2JcFPyuX9XnfC0FdznCt7F03Q3xi6mdl0SBlhPGWJ3mtB/1dHfPrUgkAPy
         j83rZ4JnYPZ/oBekwrNLJViUoHiOGE2laotiCEqFpTnoFl0RlhoRA4y6QnpTElNNLPhi
         EdHw==
X-Gm-Message-State: AOAM5338Imzfobt0SKs3V8+mdZL8PxWjL99F06p/2gCdHpdZmX6dl723
        y9SXWqLqigOmCC6QRdc1cImgZJ6URJ/0ohfi0xizuA==
X-Google-Smtp-Source: ABdhPJxfWl37E4TigA5Fvh4xWmUWWrS7MRbH4TwRMWN+vlf0YThpfF0ou/u3wnod98xlP97ptPCg3iX2g3TIE/OyZKc=
X-Received: by 2002:a2e:8686:: with SMTP id l6mr1951872lji.145.1644611435564;
 Fri, 11 Feb 2022 12:30:35 -0800 (PST)
MIME-Version: 1.0
References: <20220210232812.798387-1-nhuck@google.com> <20220210232812.798387-6-nhuck@google.com>
 <CAMj1kXEJRBcLBsO6HVQJNmGkxmY+aXY+BnyApn6s_MCtXo0eng@mail.gmail.com>
In-Reply-To: <CAMj1kXEJRBcLBsO6HVQJNmGkxmY+aXY+BnyApn6s_MCtXo0eng@mail.gmail.com>
From:   Nathan Huckleberry <nhuck@google.com>
Date:   Fri, 11 Feb 2022 14:30:24 -0600
Message-ID: <CAJkfWY7bet2V-w7NwMxqAsiwUqF5q7-FmFsgKJaMOBYSuY9M2g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 5/7] crypto: arm64/aes-xctr: Add accelerated
 implementation of XCTR
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 11, 2022 at 5:48 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Fri, 11 Feb 2022 at 00:28, Nathan Huckleberry <nhuck@google.com> wrote:
> >
> > Add hardware accelerated version of XCTR for ARM64 CPUs with ARMv8
> > Crypto Extension support.  This XCTR implementation is based on the CTR
> > implementation in aes-modes.S.
> >
> > More information on XCTR can be found in
> > the HCTR2 paper: Length-preserving encryption with HCTR2:
> > https://eprint.iacr.org/2021/1441.pdf
> >
> > Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> > ---
> >
> > Changes since v1:
> >  * Added STRIDE back to aes-glue.c
> >
>
> NAK. Feel free to respond to my comments/questions against v1 if you
> want to discuss this.

 Oops, I misunderstood the tail block behavior of the CTR implementation and
 thought it wouldn't work with XCTR mode.  I have XCTR mirroring the tail
 behavior of CTR now. I'll submit it with the v3.
