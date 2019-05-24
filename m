Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA012C072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 19:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84DD02184E
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 19:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558726975;
	bh=P4F0yOxDnt7KgIgixW6cWq/d7ndhyoPDVMiTUzFfBsA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=H5Zh9kGIB0jtIk4w92ZeJn5y8fztFMJM5dchDdr6NTGn9tBhQZUWUwtkW9/xldhKg
	 pQAMfyBddXmMqj4KWK/TL4uFulMyZUqIqiZA46J2h1AXainKLr27LvrmKOpeDOxDuQ
	 q2qTG5p4CwqCKuvOWFGz83GRppB1++EvgVtpJlLI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391743AbfEXTmy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 15:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391705AbfEXTmy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 15:42:54 -0400
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7194621871;
        Fri, 24 May 2019 19:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558726973;
        bh=P4F0yOxDnt7KgIgixW6cWq/d7ndhyoPDVMiTUzFfBsA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SFwIDF4Aw3Jd2KfBBerNI895AiBx9F1rWeur2SqXk3w1aiv7VZv6/fqCeVLf/CSxf
         kmvVoELfJgGout+uePXkYNs86jDeyaz4q6NZQp3NbUcDYCsM5NaPrDDn+kRM2P+meO
         3qzh4XVC8UGpU65Jp9qWaIUBYz9HOcjkmnWruQRY=
Received: by mail-qk1-f171.google.com with SMTP id m18so9211362qki.8;
        Fri, 24 May 2019 12:42:53 -0700 (PDT)
X-Gm-Message-State: APjAAAX4+vM+xN3GG5i0S5MpSuTfIw0Vsrg/E56vX4U7/VdaRlFre+01
        qjB9J1N2IFxRMXDM6t0hiiZSvHJvJREkVPURcw==
X-Google-Smtp-Source: APXvYqxP2ozbNjdQZTI8z07dp169gKEcH3wTgMaVgZJd+xk2XZr48eTlRy8nhRjK7gAAZkNfMHlatuL1g+sO3Rt6VYs=
X-Received: by 2002:aed:3f5b:: with SMTP id q27mr86664137qtf.143.1558726972684;
 Fri, 24 May 2019 12:42:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190524162651.28189-1-ard.biesheuvel@linaro.org> <20190524162651.28189-6-ard.biesheuvel@linaro.org>
In-Reply-To: <20190524162651.28189-6-ard.biesheuvel@linaro.org>
From:   Rob Herring <robh@kernel.org>
Date:   Fri, 24 May 2019 14:42:41 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJZwRkq7ciOw101wyHCq1gbWBCZ-PKyLZajgRg_wLG0Vg@mail.gmail.com>
Message-ID: <CAL_JsqJZwRkq7ciOw101wyHCq1gbWBCZ-PKyLZajgRg_wLG0Vg@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] dt-bindings: add Atmel SHA204A I2C crypto processor
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, devicetree@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 24, 2019 at 11:27 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> Add a compatible string for the Atmel SHA204A I2C crypto processor.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  Documentation/devicetree/bindings/trivial-devices.yaml | 2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Rob Herring <robh@kernel.org>
