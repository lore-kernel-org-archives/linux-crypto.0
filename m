Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D871C77B6E
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Apr 2023 20:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjDMUMU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Apr 2023 16:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjDMUMT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Apr 2023 16:12:19 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAD53C21
        for <linux-crypto@vger.kernel.org>; Thu, 13 Apr 2023 13:12:19 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-54c17fa9ae8so403690447b3.5
        for <linux-crypto@vger.kernel.org>; Thu, 13 Apr 2023 13:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681416738; x=1684008738;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=huT4FujcHXScyzhCCiWxC6Qo3dKvB4TLtzgLZuY6bg4=;
        b=loF2Zs/MUL5DZEttkHR48HL2G4xLa7co1JZa/ZjsBPFQ94c2xdNrhQdAVvBxoYq1rU
         lH+xnCOZe//rfTcRCgZb5PR2dsQAKsf72k9TViqafM5wtRFdrJ2dihjPAywS30NEN1LJ
         gj2yEiEVnZ9d2U//PgtjyxWF7DUTOnRQ6igXlwfy+2NwbVxCtrCSWt54xRZZAvqLletA
         8QQwxTskeQseWSevoIv235O8iagmTnWehYeDlZ+B4RN9CWBKNiHEe4pVn4ZftvLhvWXp
         tqXYrZ8CytHTnpNa/tewuMt3e1wbCVOkb9TKRNZ1vr0EHrDXwoYqXiwjaEAyFaWUw8qM
         yw1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681416738; x=1684008738;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=huT4FujcHXScyzhCCiWxC6Qo3dKvB4TLtzgLZuY6bg4=;
        b=dg3BsVrm+uH1Jpd/O+g1+ry30vjKwQzQLgQTRkhGq7dikjYyne+rW8V16EmjZRhWsu
         BpPzWhWHv39qHloh1xNR5nKWxFCEKEB9H4HSaNEZeKCV/N5sB4KzIOYDnVds70dDIU0l
         wQgOQOaZkb7LPvAFYAXISml1XEJSKBnD2NAYuKGFRru9T4W4lWfFPr0hPgqgKwL+WBi1
         mrBTA1w6CG6pN9unhMun5uRxjxYYiS0DZuhERnEhnEvT0sY8xvMI4MrYn2tC+5ocWwnN
         3G2PT+fkOrGfjrcXmonGZOgn4hkye11rR9dWlCoeTXNXpMNOVuiVRX/7iTsvdhiovC9E
         bKFA==
X-Gm-Message-State: AAQBX9c1P1fd8nBG0MkD4oeaPQyzH7sryjmfl8v3FYpWPHmvz1W82RwK
        k0Qr6vpNVFr1cSlndETDU4YdU9CzVmXKasKx5kgCTg==
X-Google-Smtp-Source: AKy350bJXLu0gVkdee3XTye1rjXA9u/btZu7MnQNaZUQ3umViEaPtAxZrgeXwB+pnPtVn6JPDmnFmoHbMCAWioBMEUQ=
X-Received: by 2002:a81:e503:0:b0:54f:40fe:10cc with SMTP id
 s3-20020a81e503000000b0054f40fe10ccmr2233268ywl.9.1681416737751; Thu, 13 Apr
 2023 13:12:17 -0700 (PDT)
MIME-Version: 1.0
References: <37694343f8b89dc0469d4a1718dad8f5f8c765bd.camel@linux.intel.com> <ZDJtc7C6YBgknbTq@gondor.apana.org.au>
In-Reply-To: <ZDJtc7C6YBgknbTq@gondor.apana.org.au>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 13 Apr 2023 22:12:06 +0200
Message-ID: <CACRpkdYnXdFky0z0EEsmbQ5hbs=J=oRb+3vAcuDpWaLTh1kxmQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: ixp4xx - Do not check word size when compile testing
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Tom Zanussi <tom.zanussi@linux.intel.com>, clabbe@baylibre.com,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Apr 9, 2023 at 9:47=E2=80=AFAM Herbert Xu <herbert@gondor.apana.org=
.au> wrote:
> On Fri, Apr 07, 2023 at 02:37:44PM -0500, Tom Zanussi wrote:
> > COMPILE_TEST was added during the move to drivers/crypto/intel/ but
> > shouldn't have been as it triggers a build bug when not compiled by
> > the target compiler.  So remove it to match the original.
> >
> > Reported-by: kernel test robot <lkp@intel.com>
> > Link: https://lore.kernel.org/oe-kbuild-all/202304061846.G6cpPXiQ-lkp@i=
ntel.com/
> > Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
> > ---
> >  drivers/crypto/intel/ixp4xx/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> We could also fix it by making the BUILD_BUG_ON conditional:
>
> ---8<---
> The BUILD_BUG_ON preventing compilation on foreign architectures
> should be disabled when we're doing compile testing.
>
> Fixes: 1bc7fdbf2677 ("crypto: ixp4xx - Move driver to...")
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202304061846.G6cpPXiQ-lkp@int=
el.com/
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

This fix is more elegant I think, as it keeps the compile coverage.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
