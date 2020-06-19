Return-Path: <SRS0=Y8jf=AA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E8C5C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jun 2020 21:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B990221F2
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jun 2020 21:49:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U71qK9qR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgFSVtS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jun 2020 17:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728105AbgFSVtS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jun 2020 17:49:18 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE076C06174E;
        Fri, 19 Jun 2020 14:49:17 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id t74so6405494lff.2;
        Fri, 19 Jun 2020 14:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rUldccX6Mfa9EMv3MM8tGDpY7SpqEJv/NYMh4QXIOk8=;
        b=U71qK9qRs9YwthJ53aVntPqRMlPaNywRknMLo8EtTj+B/Ee8ILj6wUezKcV9BFPL7O
         Ffc4rwSFPnUEsf86ajqakOlcQcfEolAxCenI4j+1IIf4Wrkn+X7Vfslw8FNpRf0EIDgT
         VZEjelw78lota5yVve8A+IdhtQ4TMNG5LxRkJfGLbMeKNyXHSr3YlndziPZlyC3PQ9Pk
         8colLodWvKLm1R5ZF9Jbgjfdfwhx+bU+BM8uS2NIq/SZls+FSmSilWjs3Muc2vM5F/65
         rUvlsvGhf3Zq10MseIOekggz3+gpNwTMV1FIoLnLhSvect/iyJksxGrU5SewrUPuGesC
         PHig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rUldccX6Mfa9EMv3MM8tGDpY7SpqEJv/NYMh4QXIOk8=;
        b=O5akO4z29jkSVbml0ItwHYgiyx39Vw5CigAv89tC1AHEkc/UVVTfWPojWF8QgmfXqv
         wwXroVHwiZ+mGm8Ek5v0QlUNEfs+ApiPENYFvtXI6VnczmFZs7sh4XJHOP0uq03wDMts
         UxZoLQDsZ/E1HwXWooxJJfpAgL/wwlo4f2Yl0lGuk7/XSPuYTsOfjavtoRe3kI1mv8rn
         toV2kSzQFgvXUZ8Vk1A/yxCG0Y8RFimMUEkJP7oJ6OD5Ouj55ObzEMuaUU369g5LuGYm
         KIFd+J51UkdpX6ifXgmei+wllCV8tu2FF4MkQxWsv8VypIJIxbVLM7lagGCSaa0C/0B+
         ZQiQ==
X-Gm-Message-State: AOAM530yFb5zAzwELzc5tLMBPL3MN7pj6DvkS52ykwPhyAyYlSvljdZX
        w4n+8dyMP5qWzTVjeWXdw/FoJMXqdvb7Bkjv1Dw=
X-Google-Smtp-Source: ABdhPJw+Jc8EiJtExsyj4224wBwNJN1umFBvQuNWb1X2EsFDH23OpL2io4VgdLKMMa+UZpyq54LsilgUzSo+ZKU7rZQ=
X-Received: by 2002:a19:d06:: with SMTP id 6mr2993995lfn.214.1592603356058;
 Fri, 19 Jun 2020 14:49:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200619213347.27826-1-horia.geanta@nxp.com> <20200619213347.27826-5-horia.geanta@nxp.com>
 <CAOMZO5AZLUxXhX-Maop8iQc0Qan5YqH2QFXaDpYq0hL+BP-L+w@mail.gmail.com>
In-Reply-To: <CAOMZO5AZLUxXhX-Maop8iQc0Qan5YqH2QFXaDpYq0hL+BP-L+w@mail.gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 19 Jun 2020 18:49:04 -0300
Message-ID: <CAOMZO5BMS2RgRm2t7qDZnhiFBWE3pPZmHW7-kn-0KOq5NVYKfg@mail.gmail.com>
Subject: Re: [PATCH 4/4] hwrng: imx-rngc: enable driver for i.MX6
To:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Kaiser <martin@kaiser.cx>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 19, 2020 at 6:46 PM Fabio Estevam <festevam@gmail.com> wrote:

> If in the future more SoCs will use this IP, then we will need to keep
> extending this list over and over again.
>
> Maybe you could use:
>
> depends on MACH_IMX || COMPILE_TEST

MACH_MXC is what I meant ;-)
