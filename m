Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B60C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 06:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3380964E07
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 06:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhCAGmV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Mar 2021 01:42:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229882AbhCAGmV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Mar 2021 01:42:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A0AB64E09;
        Mon,  1 Mar 2021 06:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614580900;
        bh=EVbcPSlZbhzeSFSnf+YfdXq95zUXxjxHsmfqLwrfB7k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RRnZhKVT3Dk+Ex3vidAJGfekYm2pQbb2qMCStN7y51yjpw8suo5DdeuyZhAnFfIhH
         bijAuEZS3/UWHbjznI3sCFZZ9IixS/HztBErKYuzUJp/c1yaI4rn6RS5uWDCNipl0/
         y56XUK5+KNymSmdHGFF0aorqyOPUXZvI5LtuFgLnNyK7z24SvJDLhYmFqI/LVw4lDX
         EKcUvfBgZa4zedV6bN1bggc417lGa/zk1IVqIkznX6nXFxdViSaCwW4Xrh3wyHdtgW
         Yz/gvCe87gQ8NNWy5Y3/kPDKuqWcKf+YS14WT0TQdoxgcNDMuLsApemFaq9aAxIoBi
         re2LJmAdrwpcQ==
Received: by mail-ej1-f45.google.com with SMTP id gt32so14584704ejc.6;
        Sun, 28 Feb 2021 22:41:40 -0800 (PST)
X-Gm-Message-State: AOAM532Cr9GZYEJXyAs9OuAaTQ7E9T2F04WAQ8j0Cwc8VTFefSkXEl/h
        cXFgUVWLJL4XLT3tEOkBPSqRuxGdHfmDnRfhoUo=
X-Google-Smtp-Source: ABdhPJxbL9O6tOSwygRC8KexLn4m8S5deW0PQqMmlHuOdaYF4yeOUhodZ0Qv3HsZhkHFkURmEWvlpEQTktAcx7R+Njw=
X-Received: by 2002:a17:906:4789:: with SMTP id cw9mr14908976ejc.385.1614580898774;
 Sun, 28 Feb 2021 22:41:38 -0800 (PST)
MIME-Version: 1.0
References: <20200826162954.28636-1-krzk@kernel.org> <20200904082804.GB1214@gondor.apana.org.au>
 <CAJKOXPfktQY_T0UpsZaGv-gUpyWmfrWVbB1yENEBtcJkZv2WKA@mail.gmail.com> <20210301063612.GA28172@gondor.apana.org.au>
In-Reply-To: <20210301063612.GA28172@gondor.apana.org.au>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Mon, 1 Mar 2021 07:41:27 +0100
X-Gmail-Original-Message-ID: <CAJKOXPdXzrL28iOCUBoD9HU5ADZYVRvJ4ndRtmGrfRy68k442g@mail.gmail.com>
Message-ID: <CAJKOXPdXzrL28iOCUBoD9HU5ADZYVRvJ4ndRtmGrfRy68k442g@mail.gmail.com>
Subject: Re: [PATCH 1/3] crypto: sa2ul - Hide pointer and fix
 -Wpointer-to-int-cast in dev_dbg()
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 1 Mar 2021 at 07:36, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Sat, Feb 27, 2021 at 05:37:49PM +0100, Krzysztof Kozlowski wrote:
> >
> > I think this patch was lost, although you replied that the entire set
> > is applied.
> >
> > Can you pick it up?
>
> I think it was not applicable because the following had already
> been applied:
>
> commit ea066b7a3ddf1e4e5ae749495f0adf12766188b4
> Author: YueHaibing <yuehaibing@huawei.com>
> Date:   Tue Aug 18 22:00:01 2020 +0800
>
>     crypto: sa2ul - Fix pointer-to-int-cast warning

Yes, you're right. Sorry for the noise.

Best regards,
Krzysztof
