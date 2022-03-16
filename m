Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F448C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Mar 2022 07:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244761AbiCPHYw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Mar 2022 03:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242653AbiCPHYw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Mar 2022 03:24:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C4D31DE2
        for <linux-crypto@vger.kernel.org>; Wed, 16 Mar 2022 00:23:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07E22612FF
        for <linux-crypto@vger.kernel.org>; Wed, 16 Mar 2022 07:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B846C340EE
        for <linux-crypto@vger.kernel.org>; Wed, 16 Mar 2022 07:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647415416;
        bh=q4j46fhryJnvKa1/K5vmoMKIyPO8wirfdALCJ72+mls=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lojkhxhJmPape33fEH2a70JG8SvZiOxl7eTGNcqCMYXuQAVPgoHUBrE0WdOTKn00x
         EieuEL4R9yVcDFyk5SGadOInO9TMIecSSu8IwBSavpVaVi1Y5vDjvy44PWAU6ArH+r
         GqoBw1k0wuBKS1cgkp2h7nsGH7pwGOqcYylNwXsV9lu0MEnRkXt4/vT2wmdKq8dXrP
         r91Cl95qShyeMbkTEvgXEjjBQuhnx/TFenAxF3lX8GBqXVx0XMqAYoHO7mKW+alDbn
         duYCuo/ATlZCj9h4c7MLTO4NA5EZxUWfgjcz7MAX8VPOZ+ypVtK96AfFlwn4puO2Tw
         ALlgJ8MMdaFfg==
Received: by mail-yb1-f169.google.com with SMTP id w16so2775052ybi.12
        for <linux-crypto@vger.kernel.org>; Wed, 16 Mar 2022 00:23:36 -0700 (PDT)
X-Gm-Message-State: AOAM5324yQIGjCsJb9T7LGS//N9XQuHHV8yyWVornYHaFGab6JjhhKcM
        NqR3HeK1mW46g0EYfkU5dVKpZPuWO7luY6jk+xQ=
X-Google-Smtp-Source: ABdhPJwSlJk6yD5bo/oquhUEqOyNCT41R4aynQ5MZ0x23XPC7uqExHT2QIk0h+QfFOl7FEytgfmyaBJ61322kkSi9C8=
X-Received: by 2002:a25:585:0:b0:628:9860:39da with SMTP id
 127-20020a250585000000b00628986039damr26751848ybf.383.1647415415482; Wed, 16
 Mar 2022 00:23:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220126145322.646723-1-p.zabel@pengutronix.de>
 <c572bf6f0b0a5d7fd3f8f0744a85eb5660a003d4.camel@pengutronix.de> <YjE5UCeoziA8f+Q4@gondor.apana.org.au>
In-Reply-To: <YjE5UCeoziA8f+Q4@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 16 Mar 2022 08:23:24 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF-BdRCN-239cRHgSGM3K9EPSrRFEDJu+e6Gtri2pONaA@mail.gmail.com>
Message-ID: <CAMj1kXF-BdRCN-239cRHgSGM3K9EPSrRFEDJu+e6Gtri2pONaA@mail.gmail.com>
Subject: Re: [PATCH] crypto: algapi - Remove test larvals to fix error paths
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        kernel@pengutronix.de, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 16 Mar 2022 at 02:11, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Jan 26, 2022 at 04:01:04PM +0100, Philipp Zabel wrote:
> >
> > I see this happen on ARM with CONFIG_CRYPTO_AES_ARM_BS=y since v5.16-rc1
> > because the simd_skcipher_create_compat("ecb(aes)", "ecb-aes-neonbs",
> > "__ecb-aes-neonbs") call in arch/arm/crypto/aes-neonbs-glue.c returns
> > -ENOENT. I believe that is the same issue as reported in [1].
>
> I cannot reproduce this crash with qemu.  If you can still
> reproduce this, please send me your complete kconfig file.
>

According to the bisect log in the other thread,
adad556efcdd42a1d9e060cb is the culprit, which does not seem
surprising, at is would result in the SIMD skcipher being encapsulated
to not be available yet when the SIMD helper tries to take a reference
to it.

Given that the resulting algo will be subject to testing as well,
could we simply override the test requirement for the inner algo? That
should make it available immediately, IIUC, and the outer algo test is
guaranteed to cover the inner one.
