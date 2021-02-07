Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08EBBC433E0
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 08:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B408864E6E
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 08:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhBGIDi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 7 Feb 2021 03:03:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:55540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhBGIDi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 7 Feb 2021 03:03:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C78B64E6E;
        Sun,  7 Feb 2021 08:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612684977;
        bh=+2GOPQfQ4+OGkWO4z8VvIgNpg1iWJMavGhhiikAuIws=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MG7mOniryz/9bO42HvTNUW0HQTZ/oiyGnwMgf0SQxEidmEG+YDx2r0PGtHx3sqBff
         +/i6KQYRCLHCH4WlMRGRFSDljbLr95Y8OGRwm/HbiHXQo1rATSZVjP0pzjMHo/iWqr
         r9WgzCAqge5jzGp12+ZoZqvE2/M79+YwhK/o84nO7HOq1RnIMLhuD/CCy8lXVkhGZy
         nscN4x7vSpAO50PVbCz4jT+XrtLIL1G1uCKUY4IfTrAW7kVATNx9RaE/NLfiCzA3X9
         ep9aSRPxH22TeY2Epk9t81FlVh1Uoi74LmqC3fQoLgif921cDqV5aekC6/wjpQluRj
         mqeTDDCGoFwZw==
Received: by mail-oi1-f174.google.com with SMTP id k204so10850239oih.3;
        Sun, 07 Feb 2021 00:02:57 -0800 (PST)
X-Gm-Message-State: AOAM532J7Gg+/LrcUb1jyUjqC0yAge6fM7v17V6ILymEqkjL/Z2WUeiy
        GMb+lpgN8kHPEXo2K+vvJhUFPCUN8h4YPLFZJ3A=
X-Google-Smtp-Source: ABdhPJwC5eO4QD0RoLtO/CoO8wP/aqK89IJIw7DDVeqsPIBc/is/fm7XxPyPHThPIclijpri2TdtTQfbALQgTuM/6Kw=
X-Received: by 2002:aca:b6c1:: with SMTP id g184mr7989702oif.47.1612684976939;
 Sun, 07 Feb 2021 00:02:56 -0800 (PST)
MIME-Version: 1.0
References: <1612519857-30714-1-git-send-email-liulongfang@huawei.com>
 <1612519857-30714-4-git-send-email-liulongfang@huawei.com>
 <20210205114435.GA17031@gondor.apana.org.au> <70c0e041-9bcc-aa67-a0ad-a1a202f2e708@huawei.com>
In-Reply-To: <70c0e041-9bcc-aa67-a0ad-a1a202f2e708@huawei.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 7 Feb 2021 09:02:45 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF71nPwMVNM-xwo2UNXW6xq3G=QTCNahLNS7fCfhdSMsA@mail.gmail.com>
Message-ID: <CAMj1kXF71nPwMVNM-xwo2UNXW6xq3G=QTCNahLNS7fCfhdSMsA@mail.gmail.com>
Subject: Re: [PATCH 3/3] crypto: hisilicon/sec - fixes shash test error
To:     liulongfang <liulongfang@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, wangzhou1@hisilicon.com,
        Zaibo Xu <xuzaibo@huawei.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 7 Feb 2021 at 03:47, liulongfang <liulongfang@huawei.com> wrote:
>
> On 2021/2/5 19:44, Herbert Xu write:
> > On Fri, Feb 05, 2021 at 06:10:57PM +0800, Longfang Liu wrote:
> >> If this configuration item is not turned on,
> >> the allocation of crypto_tfm will fail when
> >> the shash algorithm calculates the hash
> >> through the software.
> >>
> >> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> >> ---
> >>  arch/arm64/configs/defconfig | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
> >> index 8383016..7cfc9b6 100644
> >> --- a/arch/arm64/configs/defconfig
> >> +++ b/arch/arm64/configs/defconfig
> >> @@ -117,7 +117,7 @@ CONFIG_KVM=y
> >>  CONFIG_ARM64_CRYPTO=y
> >>  CONFIG_CRYPTO_SHA1_ARM64_CE=y
> >>  CONFIG_CRYPTO_SHA2_ARM64_CE=y
> >> -CONFIG_CRYPTO_SHA512_ARM64_CE=m
> >> +CONFIG_CRYPTO_SHA512_ARM64_CE=y
> >
> > If this is truly needed then it should be enabled through Kconfig.
> >
> > Cheers,
> >
> Hi Herbert,
> The option select CRYPTO_SHA512 already exists in Kconfig.

In that case, how can the shash TFM allocation fail?

> Can I change it to this: select CRYPTO_SHA512 || CRYPTO_SHA512_ARM64_CE

No, you cannot select expressions like that.

Could you please explain the problem you are trying to solve?
