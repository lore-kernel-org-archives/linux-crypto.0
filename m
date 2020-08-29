Return-Path: <SRS0=VKkI=CH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E3A9C433E6
	for <linux-crypto@archiver.kernel.org>; Sat, 29 Aug 2020 01:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FDF320DD4
	for <linux-crypto@archiver.kernel.org>; Sat, 29 Aug 2020 01:53:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AG+xNUEH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgH2Bxt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Aug 2020 21:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgH2Bxs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Aug 2020 21:53:48 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B935C061264;
        Fri, 28 Aug 2020 18:53:48 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id o21so759472wmc.0;
        Fri, 28 Aug 2020 18:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JqoyE3EKNza6pT82ScEiBZn5sSvdlBHTK3RgChqgkMg=;
        b=AG+xNUEH0o1O1eGSPb5g7A4n3BUE1sj7t5GooOB0axi8yLhXEF/jU6vwSRXLw83u+k
         SU6tWKSF5XvN3T0mwWuCFv3pxXMb370qfZtUY9+hmIq55leuuraoRbMu+r0FY3il9FRA
         H4xM+HDsDNyI7RQKCqozSTwOg9CCEkbRngLyKEZIzX3lzvquQqZ86rKqnnWNus8nvlik
         iK93CFuEA2B7rgwRmRRZtw+AuCCjHCfKX64ATDYCs1nIZr22rHoghkeIKBbKumLkKV5B
         j6mmHf1wVFbjD5/9Q8S4vuv/ZrKoHewlHfKnqoO+5bSn/La9+KbhkT9dM1GNbmBJw3Iz
         Pq/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JqoyE3EKNza6pT82ScEiBZn5sSvdlBHTK3RgChqgkMg=;
        b=stISyszXFmuzQSL19w4E2OxyeuO5viIpXns9S3aEjkAdJ1zNpXzawiO2bG6w5otPXm
         WeRMc6iI2wNOgEu4xH8Gs/VJY+9+cNZ1az/IztyjMlWk77gEC3GAnxrDsbTU0oAx8asW
         njHWRX9qGogqvW7LEtKys6fSf9wanFeBwgZ8hjgiLCAcSijU2vqiR/oYigz3+DQElFed
         8OZYUTlSCAYZVAtFrjEwuTSNmxi+KBC4tIkp2nJdg5Vo32rt12KR2mWlyEnpeoQ/OIDr
         WM+z7+1pF47pSzWK98RrMtLiH5X2wpuV3+ayg7bEtol/LuyaUv82pjXE5+VtwOtZ33ml
         LnsA==
X-Gm-Message-State: AOAM5300AkqOT/Ay+mq/BalNcs3gv4HjK7f+GGFGVDoov2moDW73ZIzt
        9PyiN7nS+qVe4nkPfoVfo4I3i4/YJwFHdTJ0Isk=
X-Google-Smtp-Source: ABdhPJyoxtiFtKCU+jtmjROZN73aeHUc1t96itZNv/hLrF5N1g+YgsFTNSPwqxWgAajBmQDfUEqtr0TQyCRyQv0iJ5Y=
X-Received: by 2002:a1c:3985:: with SMTP id g127mr241250wma.32.1598666026989;
 Fri, 28 Aug 2020 18:53:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200821031209.21279-1-acostag.ubuntu@gmail.com> <20200828071931.GB28064@gondor.apana.org.au>
In-Reply-To: <20200828071931.GB28064@gondor.apana.org.au>
From:   George Acosta <acostag.ubuntu@gmail.com>
Date:   Fri, 28 Aug 2020 20:53:36 -0500
Message-ID: <CALhW5_QpsRCb73OCiOKC0xVSwuadz3BVSQg+r=T4AN+qCpSM0w@mail.gmail.com>
Subject: Re: [PATCH] crypto: cavium/nitrox: add an error message to explain
 the failure of pci_request_mem_regions
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Phani Kiran Hemadri <phemadri@marvell.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,
I just noticed a small potential issue about the calling sequence of
pci_disable_device and dev_err.
Do you think it will be better to call dev_err before we call
pci_disable_device(pdev) , or the order here does not matter?

On Fri, Aug 28, 2020 at 2:19 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Aug 20, 2020 at 10:12:08PM -0500, George Acosta wrote:
> > Provide an error message for users when pci_request_mem_regions failed.
> >
> > Signed-off-by: George Acosta <acostag.ubuntu@gmail.com>
> > ---
> >  drivers/crypto/cavium/nitrox/nitrox_main.c | 1 +
> >  1 file changed, 1 insertion(+)
>
> Patch applied.  Thanks.
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


Thanks,
George
