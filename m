Return-Path: <SRS0=c5Ty=T4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC038C04AB6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 15:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A02C8208C3
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 15:52:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IVSq5q/I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfE1PwF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 May 2019 11:52:05 -0400
Received: from mail-it1-f178.google.com ([209.85.166.178]:50980 "EHLO
        mail-it1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfE1PwF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 May 2019 11:52:05 -0400
Received: by mail-it1-f178.google.com with SMTP id a186so5218235itg.0
        for <linux-crypto@vger.kernel.org>; Tue, 28 May 2019 08:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l4yZqEsgyzcQICKr9VMFfWmGt5kwBH51mivnqik7jS4=;
        b=IVSq5q/Iyfix9F5OYiLcWLkI/RnjE5kJZ5qHRulDPJKpyCilWcJopPmLFwKRq3IHRO
         HriE6TbwrLKLjWYLJ9YgVB6Kz/iU+NJZNoZpi6VSY8V0A3A3Dix2nNb/NSoZGZmYvu/q
         W27zCBc4+itybx1zmb8R3dWCJYhtL+rTi8omqqTYWebEoPS2ugIR/6t/I7K/b4FIFTVW
         JwWCBXVuhOqzizYSvMAQ+1QdD7ejFfalSl2PAsxxxZ7ijoaE8cZzyfpJDMFfucryFrGl
         9BhLL0CFSLA96II+Ub4jtVKFFTXY9DsMyN0w+6zhcoF0OlMqyahiYuSDA7S6d/Bca670
         pJHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l4yZqEsgyzcQICKr9VMFfWmGt5kwBH51mivnqik7jS4=;
        b=qWHPMya+n1BxbfS2xVnnxcpGX4tIhnuhPCabKsqa/EZluKPCBQymCPEiCAecGE01as
         pGZ7YYCNMth8wyhC6cVz3bj4lt2Lqcf8Mmm9aTkYKBKSwZSIHM2n0/57ZQTaCoNA9mhC
         Fv3D+lClwh0MjHBVzS/OeObaAt+qrB/cfsSpF7IZ72levC5Fa8hf5DoMvXLSoPgAU7tO
         tturOGAo1pEANF0U1zvLSVo74XPI1W7lRPvfz5pelUHGzVOmnp5aYz+QgVFtZdssK5+8
         AlcRGILGzSF0xT8+qLwZhviaMXJpU7YQFxmtzVCeKp+3Mp2Ki/6QxCW6A7tyfku/Ntlw
         hdwQ==
X-Gm-Message-State: APjAAAUKOHmmQflr4cABVAlRjd6OZAOivbfxSVMtQ6RdOAk/ipeo9due
        ek2anZp1n8gN12EWsPe0moXg2i5hJXtzH58FgXUT4B1osyk=
X-Google-Smtp-Source: APXvYqzOTvfKoS03Qnpn+iGvfhdFKXM0o0FzVS05+zCUI1h92Hv2rBgW2dL9jAozER1krVyvw2KQ8U1m3nh6GEcM1ZQ=
X-Received: by 2002:a02:ce37:: with SMTP id v23mr10909803jar.2.1559058723933;
 Tue, 28 May 2019 08:52:03 -0700 (PDT)
MIME-Version: 1.0
References: <AM6PR09MB3523ADF4617CB97D59904616D21E0@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB3523ADF4617CB97D59904616D21E0@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 28 May 2019 17:51:51 +0200
Message-ID: <CAKv+Gu8bReGWAUm4GrCg7kefVR7U0Z8XBt_GVV4WEvgOpCtjpA@mail.gmail.com>
Subject: Re: Conding style question regarding configuration
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 28 May 2019 at 17:47, Pascal Van Leeuwen
<pvanleeuwen@insidesecure.com> wrote:
>
> Hi,
>
> Quick question regarding how to configure out code depending on a CONFIG_xxx
> switch. As far as I understood so far, the proper way to do this is not by
> doing an #ifdef but by using a regular if with IS_ENABLED like so:
>
> if (IS_ENABLED(CONFIG_PCI)) {
> }
>
> Such that the compiler can still check the code even if the switch is
> disabled. Now that all works fine and dandy for statements within a
> function, but how do you configure out, say, global variable definitions
> referencing types that are tied to this configuration switch? Or should
> I just leave them in, depending on the compiler to optimize them away?
>
> Obviously the code depends on those variables again, so if it's not
> done consistently the compiler will complain somehow if the switch is not
> defined ...
>
> Also, with if (IS_ENABLED()) I cannot remove my function prototypes,
> just the function body. Is that really how it's supposed to be done?
>

Yes. Code and data with static linkage will just be optimized away by
the compiler if the CONFIG_xx option is not enabled, so all you need
to guard are the actual statements, function calls etc.
