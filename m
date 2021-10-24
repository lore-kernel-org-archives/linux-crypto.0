Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F1B8C433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Oct 2021 17:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 021FA60F0F
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Oct 2021 17:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhJXSCJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Oct 2021 14:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbhJXSCJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Oct 2021 14:02:09 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A995C061764
        for <linux-crypto@vger.kernel.org>; Sun, 24 Oct 2021 10:59:48 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id u69so12448752oie.3
        for <linux-crypto@vger.kernel.org>; Sun, 24 Oct 2021 10:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BfU5q/0MkozQjzfxR6fQ4i7r2iqV9JZtLKp+vQfhRpU=;
        b=pdYCn35jLstYtIncYgyEJh8mDax2MR4xaFC6pD6fwx1gH+hsNgg5lgS3W+Vr3WgsuX
         TpymYrvpFIg4hKFY08fkxXkP6Or/UK0jSmWYPhEVAaQmfbNq2muoyOF7Kos9er8FNYJb
         UAidjHEc3ImWIz/D2KyeOOCxTzAbJVJKT4oPHp00xlKnx8eH9BSgD5DrnLnLiQ5SOwUa
         p2fgwzwDkpGCwKASvOX4+YChtoDwu+fvof++7Vo+Huugu67jNH/aud7x4pFGKxL3KkZl
         ulwGRu/l5hUOEB4m7fKoJdI3jQdMlJPFYsFDwRS4N/JdZO0/iXfHJE78xBSjib//15ju
         e0iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BfU5q/0MkozQjzfxR6fQ4i7r2iqV9JZtLKp+vQfhRpU=;
        b=wI3DPeryfTK7WHwBOX6CR+UutvMQKBowKBUlXDAYAjwFMYc2jS5cXbZyCEgiqzxVhQ
         IDcKRV0qWmn0jcCMnGSliHtlNYObsTBC+Kk/SfoWJPQi0MUT0B5ZavVdnQQx178RVfyg
         wxwH0/Qe7USJ8f2EN86OykxPEZgf9q2PgeBfEXr3ETC+0+i+swbW/PDLqb8ihCU8wdFE
         wHNb1tzgUrTQYsAf6nx94ypzLkfNGV7mMqjPxt2SRmxxD3kIJMZAr3DUZBrLvGrnzlsx
         aDqOyEoxlox9M+IvlPwAiMS5uCz4U1C0OvInK/Ix84X9ioYEShj/Z8uq+ZKuGzXhx/zm
         uxeg==
X-Gm-Message-State: AOAM533aRafGKrvtCi6/IWALX5nNHtEslwH7pjxRBrlqpUeOopJJMBQ8
        /MvYe86qvmPOrMHFsF7IP2OmZGXnOeM+IGWsxo8Q4Q==
X-Google-Smtp-Source: ABdhPJwrXc5XiQNk9mpeiT9wp9gl8G131w1XhrRufMF0fBvxI0VI61qn0pT1Tj8boCstPSgIVF1w1F5swuRlqjbRdKI=
X-Received: by 2002:a05:6808:181c:: with SMTP id bh28mr19520914oib.12.1635098387495;
 Sun, 24 Oct 2021 10:59:47 -0700 (PDT)
MIME-Version: 1.0
References: <20211013165823.88123-1-bhupesh.sharma@linaro.org>
 <20211013165823.88123-2-bhupesh.sharma@linaro.org> <YXWVYZlCpkSRb7xv@builder.lan>
In-Reply-To: <YXWVYZlCpkSRb7xv@builder.lan>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Sun, 24 Oct 2021 23:29:36 +0530
Message-ID: <CAH=2NtyHpZa0KV5TRDuvciC+uV6mdO03RmEJSKMXES4HZOg-HA@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: qce: Add 'sm8150-qce' compatible string check
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     MSM <linux-arm-msm@vger.kernel.org>, linux-crypto@vger.kernel.org,
        bhupesh.linux@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Thara Gopinath <thara.gopinath@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Bjorn,

On Sun, 24 Oct 2021 at 22:48, Bjorn Andersson
<bjorn.andersson@linaro.org> wrote:
>
> On Wed 13 Oct 11:58 CDT 2021, Bhupesh Sharma wrote:
>
> > Add 'sm8150-qce' compatible string check in qce crypto
> > driver as we add support for sm8150 crypto device in the
> > device-tree in the subsequent patch.
> >
> > Cc: Thara Gopinath <thara.gopinath@linaro.org>
> > Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> > ---
> >  drivers/crypto/qce/core.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> > index 4c55eceb4e7f..ecbe9f7c6c0a 100644
> > --- a/drivers/crypto/qce/core.c
> > +++ b/drivers/crypto/qce/core.c
> > @@ -306,6 +306,7 @@ static int qce_crypto_remove(struct platform_device *pdev)
> >  static const struct of_device_id qce_crypto_of_match[] = {
> >       { .compatible = "qcom,ipq6018-qce", },
> >       { .compatible = "qcom,sdm845-qce", },
> > +     { .compatible = "qcom,sm8150-qce", },
> >       { .compatible = "qcom,sm8250-qce", },
>
> When I look at linux-next I see qce_crypto_of_match defined as:
>
> static const struct of_device_id qce_crypto_of_match[] = {
>         { .compatible = "qcom,crypto-v5.1", },
>         { .compatible = "qcom,crypto-v5.4", },
>         {}
> };
>
> Can you please help me understand what I'm doing wrong?

Oh, you have missed [PATCH 15/20] from the sm8250 qce crypto addition
series (see [1])

This series is dependent on the sm8250 qce enablement series, as I
noted in the cover letter (see [2]).

However, Thara and Vladimir pointed out backward compatibility issues
with PATCH 15/20 of the first series. So I will send a v5 to fix the
same along with other issues pointed in the v4.

Sorry for any confusion caused.

[1]. https://lore.kernel.org/linux-arm-msm/20211013105541.68045-1-bhupesh.sharma@linaro.org/T/#m566546d32d8da7ee94822dfba625e98fd3496d17
[2]. https://www.spinics.net/lists/linux-arm-msm/msg96053.html

Regards,
Bhupesh
