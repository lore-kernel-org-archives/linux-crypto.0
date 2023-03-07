Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E9E2C678D4
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Mar 2023 15:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbjCGPcB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Mar 2023 10:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbjCGPb7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Mar 2023 10:31:59 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F9910D2
        for <linux-crypto@vger.kernel.org>; Tue,  7 Mar 2023 07:31:57 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id n18so11745919ybm.10
        for <linux-crypto@vger.kernel.org>; Tue, 07 Mar 2023 07:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678203117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ej1wMX0xmC5g1dxLkHmNOArc3+7GOqB/eA4DE4RyK4c=;
        b=dZkA6PzJvWsX5mEy6t5JDiwxiahiFz/4Eawhp1d/Bcqk+dR2z7JNj2riwjQyAzKAAe
         ciH0PyY6MAb2wVOkmIiDO4+CKoUZnw1pfewuR8t2OziaNck88JqQL7ydiWq25OX7An9w
         7PgZKQJ1Gbr+HTlUYfGmoHQrRSl5Y2rfdaWC0ZuJJjKOagyHZBWNc+gaiPlUWmRU7Yte
         f+GlwwdjXVHydKtRFbgCoLUzkM71TNc35lZ5Co+HcPeF79NXdhE04gxghtFxXLlZSD17
         CgP1oOjXIDM8OxEh+VvDxMQkhkCtgRbQ0SpAz3xnxIk95wo11cIqS98nHkXmheLpfRh2
         wfDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678203117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ej1wMX0xmC5g1dxLkHmNOArc3+7GOqB/eA4DE4RyK4c=;
        b=iQxexCQLOEMaY5neRO7cH6KA/5+J3OiIKK4iOAVpQKujVmhgRbmisgowFokqPrp6wZ
         4Ut1brrLMeciZ3qpsvrwzbiI8cfW2LzBdtp3I5T7ZZ/9AOInVJEZds7dc9R/AgXNpIht
         Wwu4B4UIEtN6+r8bB5fT6YEnf0+vWrG8JGhPRep1sfzUSIwnZMwldEWwVBpPZD8wdx3J
         f10G5QHIrjOV5bCJwnCkHI8kGHsWmNyEjR5d46Pm4JH8k4mDtOYJuMnjCtIoTh5UfQQA
         3RCkJgoG97p29/GNrxFnPlMuiheAOEyZpFEJH/Is6jZbUfa/laP3QFZbcGNxFb/YknST
         OgPw==
X-Gm-Message-State: AO0yUKUnLPBXsJqT6KEVETSHB04tbTLR2P+0w4OeUns1iG4O3yA9ejp3
        03IVoTrH4hHHfHruAZIGjhtpJRasPvV8SleWpI4O1RByzC3CIL/H
X-Google-Smtp-Source: AK7set9/2bK3mUzyiRzESQsU6pjbcNV8AIUilPKmGcvAAgOXm1cAbDz62p+1ObNkkp4uRo5v+YJxbxzZR5pLCAEFUKE=
X-Received: by 2002:a25:e90b:0:b0:9fc:e3d7:d60f with SMTP id
 n11-20020a25e90b000000b009fce3d7d60fmr6590460ybd.5.1678203116816; Tue, 07 Mar
 2023 07:31:56 -0800 (PST)
MIME-Version: 1.0
References: <ZAVu/XHbL9IR5D3h@gondor.apana.org.au> <E1pZ2fs-000e27-4H@formenos.hmeau.com>
 <CACRpkdY8iN_ga0VuQ-z=8KUWaJ6=5rh2vZEwcp+oNgcBuPFk=g@mail.gmail.com> <ZAcNhtm/+mik1N2m@gondor.apana.org.au>
In-Reply-To: <ZAcNhtm/+mik1N2m@gondor.apana.org.au>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 7 Mar 2023 16:31:44 +0100
Message-ID: <CACRpkdbcrCa9v82xVWtixWdDPvCu6E6Rkw-3Vg3APisdvYGwqQ@mail.gmail.com>
Subject: Re: [v5 PATCH 7/7] crypto: stm32 - Save and restore between each request
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Lionel Debieve <lionel.debieve@foss.st.com>,
        Li kunyu <kunyu@nfschina.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 7, 2023 at 11:10=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
> On Mon, Mar 06, 2023 at 11:08:13AM +0100, Linus Walleij wrote:
> >
> > This partly works (after my folded in fix in patch 5)!
> >
> > Clean SHA1 and SHA256 works flawlessly.
> > HMAC still fails, but not until we start testing random vectors:
> >
> > [    7.541954] alg: ahash: stm32-hmac-sha256 digest() failed on test
> > vector "random: psize=3D0 ksize=3D80"; expected_error=3D0,
> > actual_error=3D-110, cfg=3D"random: may_sleep"
> > [    7.567212] alg: self-tests for hmac(sha256) using
> > stm32-hmac-sha256 failed (rc=3D-110)
>
> So it's timing out.  I wonder if the timeout in stm32_hash_wait_busy
> is long enough.  Perhaps try adding a zero so that the timeout becomes
> 100,000us and see if it still breaks?

Sadly this doesn't work.

I tried increasing with one and even two orders of magnitude,
but the timeouts still happen, usually two of them, sometimes
one sometimes three, depending on randomness, as can be
expected.

I think you mentioned something about that we need to store
the key in the state as well though?

Yours,
Linus Walleij
