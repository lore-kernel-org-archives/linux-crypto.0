Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6883C433FE
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Oct 2021 13:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89DF560F70
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Oct 2021 13:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhJXNgE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Oct 2021 09:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbhJXNgE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Oct 2021 09:36:04 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4247C061348
        for <linux-crypto@vger.kernel.org>; Sun, 24 Oct 2021 06:33:43 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id v2-20020a05683018c200b0054e3acddd91so8551247ote.8
        for <linux-crypto@vger.kernel.org>; Sun, 24 Oct 2021 06:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HIK+oBs/aRGxhchMLI4wI4uDRRw5QPJtNSu/6AfT09M=;
        b=Xy2+1gH+z2WauJnJbFCbfsGQOf0niJt31JbdZbGIju5V5nPlf4TKzA14wiS1PbAJU0
         Jp4YQgDyQAmvcayNupUkemnS5Kn5Pkv/EXifpAfTM//j6hq3/FxpIcCGSiUsIpaRN5gG
         pQMrNnGNNpcR1Rl8hweAFk1RjMoKVKd7k7/isTKF08eSzHx9i0pP2NxviX6Rx6rl29kj
         02ZQvy/1w2ODTa7EOcfJW3AnjQxObhvWysg5U4EGB4gRt2FbHwDG5pwPPEBhNSj0o/b2
         1kE8N9+OHFjcrD8P1+S+cCHYUHPKuv5HgWXZD6OMV8Zol2PvfizdVHmefJBfAXHKB/52
         Xw7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HIK+oBs/aRGxhchMLI4wI4uDRRw5QPJtNSu/6AfT09M=;
        b=wsf0WVRi4MnBxfiAXz5fl0ekBj7Yd/FsmDx/QIJlplwHdinHZU8j5JnCw6Q/4sQbPX
         EPPmWwEj+eeS6gVmlfmLyl73gAgxrzgWIIQNEQavQ2VQCdM/9crM/Qi4S+NirVtbMqf9
         mw+Gq7Cki2sV2aCggI+fGGQJSrJNhuNwj/1/4DUIFtxiBqJ3xgwhAwPXG2OrrfGcA7j1
         6F038u+1s9CLUmua0l2g7coOHiRZYkPkQysYE475GHuxscT0RnHCiSN4tEqPAGCg3MQz
         fJ4+sUASXFEwkeWth5291XyK3HyWRM6uaTfHskhmsxenWz0m6itIACiA36ch4ekZPIcz
         yXgw==
X-Gm-Message-State: AOAM5320vQ9CDORsvJrc7MoXYLx22KhnnB00RSutE3tTZJiWgzSLNY0v
        H92Jv/s8fMLuXuJG6QAQ6qltKVIIG3YEWqoGG5RbMA==
X-Google-Smtp-Source: ABdhPJxIYbpINdi+DQOp+tHW2M8fIxiOb2JBue1thOWy6OsTzqzua7MkzNxoViZYbzf0jkh/dVhQTDtbcnZ97EP7Ic0=
X-Received: by 2002:a9d:26:: with SMTP id 35mr8926991ota.379.1635082422960;
 Sun, 24 Oct 2021 06:33:42 -0700 (PDT)
MIME-Version: 1.0
References: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
 <20211013105541.68045-18-bhupesh.sharma@linaro.org> <2699de22-4943-685f-5700-82137a4326ae@linaro.org>
In-Reply-To: <2699de22-4943-685f-5700-82137a4326ae@linaro.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Sun, 24 Oct 2021 19:03:31 +0530
Message-ID: <CAH=2NtyJAH3=XzipZx1f9WMYp+-hCTyHXrsivViBdzix4CQpJQ@mail.gmail.com>
Subject: Re: [PATCH v4 17/20] crypto: qce: Print a failure msg in case probe() fails
To:     Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Cc:     MSM <linux-arm-msm@vger.kernel.org>, linux-crypto@vger.kernel.org,
        bhupesh.linux@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Vladimir,

On Thu, 14 Oct 2021 at 00:56, Vladimir Zapolskiy
<vladimir.zapolskiy@linaro.org> wrote:
>
> Hi Bhupesh,
>
> On 10/13/21 1:55 PM, Bhupesh Sharma wrote:
> > Print a failure message (dev_err) in case the qcom qce crypto
> > driver probe() fails.
> >
> > Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Reviewed-by: Thara Gopinath <thara.gopinath@linaro.org>
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> > ---
> >   drivers/crypto/qce/core.c | 2 ++
> >   1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> > index 576c416461f9..cb8c77709e1e 100644
> > --- a/drivers/crypto/qce/core.c
> > +++ b/drivers/crypto/qce/core.c
> > @@ -281,6 +281,8 @@ static int qce_crypto_probe(struct platform_device *pdev)
> >       icc_set_bw(qce->mem_path, 0, 0);
> >   err_mem_path_put:
> >       icc_put(qce->mem_path);
> > +
> > +     dev_err(dev, "%s failed : %d\n", __func__, ret);
> >       return ret;
> >   }
> >
>
> As for me the rationale of this change is quite non-obvious, a user is well
> informed, if a driver probe fails. I would rather ask you to consider to
> drop this change.

Normally, when a driver probe fails, the kernel logging system does pretty
well to hold logs for the same and these can be referred to later for debugging.

However with crypto tests on arm machines, since the arm crypto interfaces are
also normally enabled by default, so boot-on crypto tests (enabled via
CRYPTO_MANAGER_EXTRA_TESTS), which normally take place at algorithm
registration,
it's sometimes difficult to check the qce driver probe errors /
failures, in case the board hangs or reboots while running the boot-on
crypto tests.

In such a case, if qce crypto driver probe fails, it is useful to see
a failure message on the serial console itself.

Regards,
Bhupesh
