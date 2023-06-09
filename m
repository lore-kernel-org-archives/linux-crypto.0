Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18828C7EE2E
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 19:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjFITKk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 15:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjFITKj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 15:10:39 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220703A9D
        for <linux-crypto@vger.kernel.org>; Fri,  9 Jun 2023 12:10:37 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-565e8d575cbso20207517b3.3
        for <linux-crypto@vger.kernel.org>; Fri, 09 Jun 2023 12:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686337836; x=1688929836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LJ900G5ij4y/xYDI1jpd13Sc6P2wvNe0duR8GNRArV8=;
        b=QfyL3qoBJKLLtm2liQhJFd0F3QPq7oedhrkFEUG0a1S5VO1Ot5UrGcY+/I59134gVM
         QazOr3Z9EvDQXGisE8NGyHHpnYlDDkNQOyZUY6m1xvSEEUp5Lu9PMykhY9Z9KYeswDQo
         ofore2Ow0b98fAdDhaeBEoZDNcYdkzPlgSc0Mr+InFILD0wRvDUQIuFpcoInPudheOIx
         AAGKV9tH7aIVB5uglcsCEGoQwp9IIJoCoZvuTCLoqpg9DCNjGhPHANkq8fq08i9/beQ7
         3hP+fDzl0t82qvEguizUTJc/AS064FC5pSKpgreWcJpluswLT5bAT5c8J/YEn7HcSOFS
         xYpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686337836; x=1688929836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LJ900G5ij4y/xYDI1jpd13Sc6P2wvNe0duR8GNRArV8=;
        b=ZQOFJOmJmgEr7ItR1cJIPfUQLnv4rqI4+qKLWOTDl2FvbwCfE4vfH53/+UiJ7tfbCr
         kS8H6/LXwPrYBp4e19ePHPRwkqWZYRh7q54YewIVb8kHOEDx8D6Mp3oFSOyAQP9E8oQa
         73brjTuesBJMgV73dxVm5576G9+2CwO6X817IDWZ9uLGhvEknS3V7mTK/hZMkf192keb
         k0rOABh+zP08olMdmDc27nAzKQjkYtogTt20XCQ2ByooZo5whG1qX7UEBhewhNKT/H/d
         5YDUvE7GUSGHkt48XnGV8sJ8nJjWeQk76hRyd+ITU6Xzxs5HTtzJAyc0cCiLl+TFLYOH
         0hrA==
X-Gm-Message-State: AC+VfDwETqXbBRjUMAHUw5XFIQBc/GkFDsId8o/FkXZA3tzhDDB5BpyJ
        npC+q01Mi8GMdlv2VL6Yd/TCZ2kokQwFQTyPc93dbR8QxnD1zROR
X-Google-Smtp-Source: ACHHUZ5ETmM9CNHbxrtXFT8B+QGPBNspHfep2ZhFRWOXUKhbuqUHQDU1oTD19drFiTgk70dOzTRUdOtEZ3nSfvaxFOs=
X-Received: by 2002:a05:6902:149:b0:ba7:ad38:5707 with SMTP id
 p9-20020a056902014900b00ba7ad385707mr1781664ybh.50.1686337836352; Fri, 09 Jun
 2023 12:10:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230609140745.65046-1-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230609140745.65046-1-krzysztof.kozlowski@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 9 Jun 2023 21:10:24 +0200
Message-ID: <CACRpkdZzC7ttFbprrsaQgnUkdaEgSBA_Uw6fkhrHYi6LjJekjQ@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: crypto: intel,ixp4xx: drop unneeded quotes
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 9, 2023 at 4:07=E2=80=AFPM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:

> Cleanup bindings dropping unneeded quotes. Once all these are fixed,
> checking for this can be enabled in yamllint.
>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
