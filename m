Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F3BEB64D9
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jul 2023 21:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbjGFVmr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jul 2023 17:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbjGFVmp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jul 2023 17:42:45 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA891FE0
        for <linux-crypto@vger.kernel.org>; Thu,  6 Jul 2023 14:42:39 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id 3f1490d57ef6-c4d04d50c4cso1278612276.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Jul 2023 14:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688679759; x=1691271759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+0rENF/WeQpydVVWV122fwfebKo12jRQ+NnRzPzQpr8=;
        b=W/SqLqzt3wFk2cSOkuV+T+EczeUwl3oqInbbKRlT4oXgXFrFobMBlM88wjGhpBU253
         svEE5aOAjYqWkryCcUlYCJuW/m+di6FIaiJdkPSLXboETkhHC3BqRDKKtq5bJ+z2BQAX
         tDRwXpY2Zu8qlvHrtOjOLSelcVKmsuZzTuHdm7lS3OG7eM9MV8j4FMWUa9k76kaFjp4l
         wTkR+KszaKH45YQVXRN0pki6hALtHmL2LxxUYcW8xQ8wZxekpk7FpjKP1bU83cyW7mgg
         7E+XipZ1JacoQzxN0opR0dm1UCUR98tPuw1W2nAmN68HRALf7+hWg4az4Y7dGQ8+p5ya
         pbjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688679759; x=1691271759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+0rENF/WeQpydVVWV122fwfebKo12jRQ+NnRzPzQpr8=;
        b=FDPEGCLUnDE/Phm8BMKq+z9sW6ClBhGb0pvKVx6w7SCwwNAoDW0YWI7Xcw/+qLL75T
         mN6yzBhnBc8H2QvwQIPmMmwKo0E2pkSM5zXZluVToNhf/NVOYfsiZnPT4J1RXVDzprcd
         +aBxkOoA6PuKoYgHH4G4OV0/cPO0zqLN27pfs6fpny9FAaZ7u9UxRxi6qOUp8QTd8lIU
         gWkffFKm3DcKrgTPxqpTzm6KDGizDxxT01dpwfTaVsBdqNT7UIqQ4wjowOt7/sKwE0f/
         vAX2ItrMGCH5IrcK+tVs/e4MdcK43Yv0ciQROexhaRp01rgleaC85euhP/XJlgu6MWeE
         LPNw==
X-Gm-Message-State: ABy/qLag4zhuc+ez9OEL018zDzKpxIo0GSE0KMUeBnZMeaEWZQBlkftL
        xPRY4u+IwN/3/9wGyKzg9z+U/4dfzH+UfaOzAZkdwg==
X-Google-Smtp-Source: APBJJlEAXANJaCshopEoGTyGyT4USXSJCsyd2uuiYqc82UYDe7R2DDGSeNcDz1Nv2iylOJfJTRv7yTcuFYW4NiENZ/k=
X-Received: by 2002:a25:6085:0:b0:c18:1300:6339 with SMTP id
 u127-20020a256085000000b00c1813006339mr2997998ybb.52.1688679758872; Thu, 06
 Jul 2023 14:42:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230706073719.1156288-1-thomas.bourgoin@foss.st.com> <20230706073719.1156288-7-thomas.bourgoin@foss.st.com>
In-Reply-To: <20230706073719.1156288-7-thomas.bourgoin@foss.st.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 6 Jul 2023 23:42:27 +0200
Message-ID: <CACRpkdaF59sJQMc9ZuEM=YFJPaw-oAmvt=s4GYjchEGWQ=yWCw@mail.gmail.com>
Subject: Re: [PATCH 6/7] crypto: stm32 - fix MDMAT condition
To:     Thomas BOURGOIN <thomas.bourgoin@foss.st.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 6, 2023 at 9:39=E2=80=AFAM Thomas BOURGOIN
<thomas.bourgoin@foss.st.com> wrote:

> From: Thomas Bourgoin <thomas.bourgoin@foss.st.com>
>
> If IP has MDMAT support, set or reset the bit MDMAT in Control Register.
>
> Fixes: b56403a25af7 ("crypto: stm32/hash - Support Ux500 hash")
> Signed-off-by: Thomas Bourgoin <thomas.bourgoin@foss.st.com>

Oops probably my fault.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

This should probably be applied for fixes/stable.

Yours,
Linus Walleij
