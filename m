Return-Path: <SRS0=ef2Z=W3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14EF0C3A5A6
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Aug 2019 15:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAF2722D6D
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Aug 2019 15:29:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dvJE82KF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbfHaP3p (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Aug 2019 11:29:45 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:46000 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfHaP3p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Aug 2019 11:29:45 -0400
Received: by mail-wr1-f42.google.com with SMTP id q12so9727406wrj.12
        for <linux-crypto@vger.kernel.org>; Sat, 31 Aug 2019 08:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8uBJCRzjM8Or1WLuVheV+xTYWNDbhaPFMHVOz+O85Ho=;
        b=dvJE82KFRWMV41gmHx8YD2y5CkBf5jX2oviEMJo7yvHA3EHOCRO9zaKY5lSahEYTLF
         sA7JEAqFUBkSoPV7j+x3iXG2+LxeRSIwG29g/++HzU8awOb5BI7c5hTCDDg2Gf+cr44x
         JVpoWlGTvlQIKptxVUeXPEqXMM1xUpUyzy73ZkWukpmVq2rJTaVkXcrXHtKitj6rRMqY
         21tM4HdAsTIcZamJ9EwV8sJc2dbcxh4lu5TIR05VgC6vRcuPVD5w16RmlYQyje1fm0hV
         yBVd/KWXQ8tpBOkT/zl1z5AhxaBAldK4cWUQB86rM+QL1B4X8n1FByKKIoRgdH41PcPb
         X3mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8uBJCRzjM8Or1WLuVheV+xTYWNDbhaPFMHVOz+O85Ho=;
        b=J7GLRY3G5QM7UZ6qnzycNgfcfeBUJRgrUq5LECCUdWWZIakGLGlRLD7JzVOS2UkGfq
         ErQAapVYcDp/nJ7AWonD95PXVADsBv35J6V8mx4+imezzspAT8Fqm9Md4ViMNGfVJ217
         RcQQNPFjMWuh+ysNGCIlGx5xtwYV6vCt87RuG973gAj5V14KgdBfiPnyOS/okcv/SYSI
         ml4jwXf8FlJJTFDsFUY8re1Kz9KGdV0kbZSXKelqbrdumBhRSyf4P1J9ghO51ab3OpvG
         TjX0uS7srRGiRCsAY0mCsdGKQJzOSJ+4Z41TiKEm4lccmCRLuZW3ehkYxcHVowsopS2I
         YZig==
X-Gm-Message-State: APjAAAXSsuGiiFxkaFRl3GlHQoAFY3BeHNASMmqAV4nybdW+OaT7LICx
        c9L7odu0gsg0ixw8Jm3rxlLgYjr14WhJDzxaJtUrDQ==
X-Google-Smtp-Source: APXvYqz+f8Iwn5ZpUweFf2owyrK4yLaBWIPuaNneZTZVVoeB6prDeyKOsh4Cd23NyAE2d3EYCbhuGGvrLLN4nB5vpAI=
X-Received: by 2002:a05:6000:128d:: with SMTP id f13mr25943128wrx.241.1567265383460;
 Sat, 31 Aug 2019 08:29:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAKv+Gu8mjM7o+CuP9VrGX+cuix_zRupfozUoDbEWXHVGsW8syw@mail.gmail.com>
 <cdf08891-3b55-e123-1e13-23866af3b289@rock-chips.com> <CAKv+Gu-MdY_OizZBNrAt15hr8NSyDG5rDSE65OV6TDmbTLJymw@mail.gmail.com>
 <a4b0e750-7881-2b07-8235-4ac98c44153e@rock-chips.com>
In-Reply-To: <a4b0e750-7881-2b07-8235-4ac98c44153e@rock-chips.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 31 Aug 2019 18:29:32 +0300
Message-ID: <CAKv+Gu8cph2ogmVO+SV7CQwtDL5QA7ZAdR6RBjdrXrQ9CrC6yg@mail.gmail.com>
Subject: Re: cbc mode broken in rk3288 driver
To:     Elon Zhang <zhangzj@rock-chips.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 23 Aug 2019 at 11:21, Elon Zhang <zhangzj@rock-chips.com> wrote:
>
>
> On 8/23/2019 15:33, Ard Biesheuvel wrote:
> > On Fri, 23 Aug 2019 at 10:10, Elon Zhang <zhangzj@rock-chips.com> wrote:
> >> Hi Ard,
> >>
> >> I will try to fix this bug.
> > Good
> >
> >> Furthermore, I will submit a patch to  set
> >> crypto node default disable in rk3288.dtsi.
> >>
> > Please don't. The ecb mode works fine, and 'fixing' the DT only helps
> > if you use the one that ships with the kernel, which is not always the
> > case.
> >
> But crypto node default 'okay' in SoC dtsi is not good since not all
> boards need this
>
> hardware function. It is better that default 'disbale' in SoC dtsi and
> enabled in specific
>
> board dts.
>

It is not a property of the board whether the crypto accelerator is
needed or not, it is a property of the use case in which the board is
being put to use.

Pretending a h/w block does not exist just because the Linux driver is
broken is not the way to fix this. Disable the driver as long as it is
broken, and re-enable it once it is fixed. And please don't touch the
dts - it describes the hardware, not the software.
