Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE373C001B0
	for <linux-crypto@archiver.kernel.org>; Sat, 15 Jul 2023 20:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjGOUCo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 15 Jul 2023 16:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjGOUCn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 15 Jul 2023 16:02:43 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950A710E9
        for <linux-crypto@vger.kernel.org>; Sat, 15 Jul 2023 13:02:42 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-579ed2829a8so30284547b3.1
        for <linux-crypto@vger.kernel.org>; Sat, 15 Jul 2023 13:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689451362; x=1692043362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UdWH8G7/JxibX+jq7eakhmn5wKNtr6QZ3AvIbtaoqT8=;
        b=Mz58cy0Kt3Z1+wShUaBgVHgGDxpamWmFASj+5ZS65vNBlFE6pTFSlbgIQtK3WVjA6A
         +KUDUfWpkPpfVAogO5+KsQ0NFfm4BuJ6J48O5EVdzzPyWBIRAJdmVrTJ41d8Z/0Qx432
         XmO4UHDIzyGxM4scnj2V1IhMoTLcV1dAca3Xq/Hj8Kk+mykf3bR9xZevexWBjlTWoopM
         ISqAgzN1N5wQT+03yQx6CLfib+MnnbI8bYyVHqasuJTUSIQ9cP2NTnaBKLsxUa3+9Gta
         uUHpWsRlPrzDyO6xEGmSb2Dqs6UvJlS9Ruyt6R0x+nLIo8WGFR8RtDlrRMmcGRY4ATWZ
         VnIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689451362; x=1692043362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UdWH8G7/JxibX+jq7eakhmn5wKNtr6QZ3AvIbtaoqT8=;
        b=HaOg9GkP9OahP0OdwNDkyPnR3bdKezfk7KH5OKBkySjgGxbC5ZncGYSxAQMqj9Uua5
         g0azbt24n+jdruAyUXs4peSIsORZcDkl67G90akEZG1bZKF6MhlNXpzafK8nLtIpJco5
         cmFTx6a2L8DiLXMdkwIk2yDuinNHsGwRZYP2s7ioohXzY104yxP7sm8NglnasLMezdfW
         YJk+fo7Mbd3s0Z1Cz5RpFVfjLtCWH2WqyEA/mv8Urk3AKUqqfC7buQNQ+wTjCQjsMFN2
         BQixY64o/qt+H9Y7KsStr72aQoY9dne4AEQK5XcpGP13b1Qm8Ii0leFxcD0xS6BYqOTF
         MZaQ==
X-Gm-Message-State: ABy/qLamEt1TjvD/vxNQOkyVY9YRskhPhYb05n/LSDwMUGw2Vw5teSjQ
        y2yLcGDch1+BtW+XXmu4ZYRZncbDsFYaAdbAll8m6Q==
X-Google-Smtp-Source: APBJJlF3v6Vw+WtzHjshzitoTc1qC7LX07Q2C3RsD1IvX+Ry88/4NSzUT7fZSVHUgs1bCHW1MQp7pfPnuQEYdOkovmc=
X-Received: by 2002:a0d:d4c6:0:b0:570:1a2c:5844 with SMTP id
 w189-20020a0dd4c6000000b005701a2c5844mr8288945ywd.35.1689451361822; Sat, 15
 Jul 2023 13:02:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230713151518.1513949-1-thomas.bourgoin@foss.st.com>
In-Reply-To: <20230713151518.1513949-1-thomas.bourgoin@foss.st.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 15 Jul 2023 22:02:29 +0200
Message-ID: <CACRpkdYURZbTwyPz_1w94RfiK17KqYvjwXkTf5gbZxz5huKKpQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] Support of HASH on STM32MP13
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

On Thu, Jul 13, 2023 at 5:16=E2=80=AFPM Thomas BOURGOIN
<thomas.bourgoin@foss.st.com> wrote:

> From: Thomas Bourgoin <thomas.bourgoin@foss.st.com>
>
> The STM32MP13 platform introduces a new version of the IP HASH.
> This version of the IP support SHA1, SHA2, SHA3 algorithms and HMAC.
> This serie also add some fixes when using the DMA to feed data to the IP.

The series:
Tested-by: Linus Walleij <linus.walleij@linaro.org>

Thanks for the follow-up!

Yours,
Linus Walleij
