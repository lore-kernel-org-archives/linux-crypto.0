Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D9AC4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Dec 2022 16:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbiLMQ7a (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Dec 2022 11:59:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235932AbiLMQ65 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Dec 2022 11:58:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F054F24F00
        for <linux-crypto@vger.kernel.org>; Tue, 13 Dec 2022 08:56:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78FD9B812A2
        for <linux-crypto@vger.kernel.org>; Tue, 13 Dec 2022 16:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2511AC433D2
        for <linux-crypto@vger.kernel.org>; Tue, 13 Dec 2022 16:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670950575;
        bh=nRTsgt2s0CXqejPQIsJcMbCKeu5AtyGMg3jBOd2tFQ0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RB2g5tPftDhnakeRd7e01+EqJkVsB7TTumkWWvldZuQys47lIpFIKlREUyplt97RH
         3TAry7FJuNmsvX80Ga7xdNKuaw2mM5+4jo/b2E6ZCz7D0V8qrlPeAAcSCNgNeXGsYE
         dNw5+T9QK3a4OaRxFMLnRZipLCIRZ2WjUkguI50qDqiXv5lbhIr+jMgEgkR02Nf8yU
         7ZwWJAKAwQanRtsFhNyyyHPTrvKLTnCZwIe+habFRX7Q+TSz7SUzzF2K0NABW1iyNN
         NhdW7u4Z093nl/m7K5FhQQ0LTDmC+HS01GG6pIhT/WluJI/ZwmwDxpk6Hr2ld/4Koi
         7DIdNnj8DDLgg==
Received: by mail-lj1-f175.google.com with SMTP id f16so3903583ljc.8
        for <linux-crypto@vger.kernel.org>; Tue, 13 Dec 2022 08:56:15 -0800 (PST)
X-Gm-Message-State: ANoB5plKawPvQzgOvxV2XW9wV3MIMBv8MbdkCavqLczfwpgGdU0b6w7h
        XHMBUqwINV64ZwEBiD6BD4hOLxtvr5rfQSJ97BY=
X-Google-Smtp-Source: AA0mqf7LCKgHF1y1CieLYeW/XxfzO0Q9GMS7KulnVgRKusjeO6WyjxOKBJ+3j8VXUEsXTc3DXTejt/tvDfhSnw55s78=
X-Received: by 2002:a05:651c:1603:b0:26d:d603:8df2 with SMTP id
 f3-20020a05651c160300b0026dd6038df2mr28154018ljq.189.1670950573159; Tue, 13
 Dec 2022 08:56:13 -0800 (PST)
MIME-Version: 1.0
References: <20221207103936.2198407-1-ardb@kernel.org> <60937acc8b143e552aa41a689c03febb1fd3729a.camel@strongswan.org>
In-Reply-To: <60937acc8b143e552aa41a689c03febb1fd3729a.camel@strongswan.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 13 Dec 2022 17:56:02 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHad8wRd9_P7A1Oo8Ucw0H=+19ffO4mss7eouivNwy1vg@mail.gmail.com>
Message-ID: <CAMj1kXHad8wRd9_P7A1Oo8Ucw0H=+19ffO4mss7eouivNwy1vg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] ARM: allow kernel mode NEON in softirq context
To:     Martin Willi <martin@strongswan.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk,
        linux-crypto@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 12 Dec 2022 at 15:38, Martin Willi <martin@strongswan.org> wrote:
>
> Hi Ard,
>
> > Currently on ARM, we only permit kernel mode NEON in task context [...]
> > For IPsec packet encryption involving highly performant crypto
> > implementations, this results in a substantial performance hit [...]
>
> Thanks for your continued work on this.
>
> > Without these changes, an IPsec tunnel from a 32-bit VM to the 64-bit
> > host can achieve a throughput of 9.5 MB/s TX and 11.9 MB/s RX.
> >
> > When the crypto algorithm is permitted to execute in softirq context,
> > the throughput increases to 16.5 MB/s TX and 41 MB/s RX.
>
> In my tests on an Armada 385, I could increase IPsec throughput with
> ChaCha20/Poly1305 on RX from ~230 to ~260 MBit/s when using the NEON
> code path. So you may add my:
>
> Tested-by: Martin Willi <martin@strongswan.org>
>

Thanks!
