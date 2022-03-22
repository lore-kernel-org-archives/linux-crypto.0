Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D24D4C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Mar 2022 13:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbiCVNV0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 09:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235360AbiCVNVZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 09:21:25 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F716A014
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 06:19:58 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id c62so2130276edf.5
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 06:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uJzve08biZhB4r1QtUm+S3/m2cJlwVKYr43Is/lArT8=;
        b=isioKpILG85LIxzS8L9QmbzGpxJlwVCT5xcPWHLWbkBQGWRo5XDALH1PPTy8OuKuBa
         wlp/ixRVWxUf0hzgva2gcrlpBrUsELB2vigN/BHh7wGlFQmnB06rRQB74hf6DN8Ytn4Q
         Q2sS9PZyTFY3KfT5h6s1dM8/u/JR61e0kMJ/Iqq99Z8+SiTmvRbqCVHocMRWsG+4z6o3
         T88Sphrs+/90nNPGvmf7RnKJXHA2KoXkry5mn6iuPzzDhv8hWqAzYEPOz5R9iY41jWpV
         o1RxdbJXiDDTgPJc81ResXiYMYiKlyt8kth+McPO1Gw1l+Q32Tw8DKjllrv8KVNpYuPb
         wRhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uJzve08biZhB4r1QtUm+S3/m2cJlwVKYr43Is/lArT8=;
        b=qgJfhN0ucEHDWbQbbzVvrqlQ0eMTM4d1V0uvnK9kZwAnwfgxW5qThYHNvYyyHZs1zp
         uOJZDSnNMmc4/6n7Bn7kN7IlJBgSFVw+TG0NcHZ/8xMnhUaUANlJ89JXZMT2l/QnAtS6
         a6OMVYa9cv+ceIovFW4/pwshbvD9f41wKuT9tD6f0miHTZX/s3NAl5djEerSL3EYdQye
         TCqf537SV3D0cA6CdD6GSQ8qhJM6drNhnzwLuQhjikuwDbC0IvXtsnhxV76IEAUJ4f8p
         u3e61pjTBzM9V0cfq+yWRR3+fCX7m7RJ6GXfHJ8CLEhwsRLbmQStEecZtKjFWHYfBT6b
         M7WA==
X-Gm-Message-State: AOAM530eAYKfACC+FghALpeMUj508mDfzBsiabqQHkAB8MmACRHVpbEn
        khQMO8Ba/T5w0pKOlENK4EC5MqyT13qy8LN8hJ85EdRj
X-Google-Smtp-Source: ABdhPJw34eppP/81iFScRAVr/l/ItTww1SYLOwcLrmlxR7o49DrgZ6FqMSznot7KFJKITmF1wkbU+9U/O2MterSqIPs=
X-Received: by 2002:aa7:cf08:0:b0:418:e5f7:b2a1 with SMTP id
 a8-20020aa7cf08000000b00418e5f7b2a1mr27878480edy.76.1647955196602; Tue, 22
 Mar 2022 06:19:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220111124104.2379295-1-festevam@gmail.com> <YfOL3Yxvb5srGKp4@gondor.apana.org.au>
 <ee43a9f9-3746-a48d-5615-b9f4166eaa46@nxp.com>
In-Reply-To: <ee43a9f9-3746-a48d-5615-b9f4166eaa46@nxp.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 22 Mar 2022 10:19:44 -0300
Message-ID: <CAOMZO5AAYHRUUy872KgO9PuYwHbnOTQ80TSCx1jvmtgH+HzDGg@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam - enable prediction resistance conditionally
To:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Andrei Botila <andrei.botila@nxp.com>,
        "andrew.smirnov@gmail.com" <andrew.smirnov@gmail.com>,
        "fredrik.yhlen@endian.se" <fredrik.yhlen@endian.se>,
        "hs@denx.de" <hs@denx.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <festevam@denx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Horia and Varun,

On Fri, Jan 28, 2022 at 4:44 AM Horia Geant=C4=83 <horia.geanta@nxp.com> wr=
ote:

> We've been in contact with Fabio and we're working on a solution.
> Now I realize the list hasn't been Cc-ed - sorry for the confusion
> and for not providing an explicit Nack.
>
> Herbert, could you please revert this patch?
>
> It's doing more harm than good, since it's making the internal CAAM RNG
> work like a DRBG / PRNG (instead of TRNG) while the driver registers
> to hwrng as an entropy source.

Any progress on the proper fix for this issue?

Thanks
