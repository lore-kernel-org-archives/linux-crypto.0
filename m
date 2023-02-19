Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 574CAC05027
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Feb 2023 17:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbjBSR2P (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Feb 2023 12:28:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjBSR2O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Feb 2023 12:28:14 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69736BDF2
        for <linux-crypto@vger.kernel.org>; Sun, 19 Feb 2023 09:28:13 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id s24so3659100edw.2
        for <linux-crypto@vger.kernel.org>; Sun, 19 Feb 2023 09:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M6+Yhi5HmzEaYR1Acp/Tiu9ai7miZvMW3BFnNCGbcK4=;
        b=DUffLC6/PkfvC5KK7qPuoyZfR4td2wDofuSGnAXnqS5FmtiVogvk3EMDWqnMNHysLI
         ysIg2jOM7yHguOWZwd46Gm8uGpMUsP5mTYQPiQ345DJCNcizxrNd3sSg6RRsGj5MsD67
         qBB3S6pNTILI1s+rc2CGjmpKvrN9VjOFZl7t+vTuwUynUgEtyFKayhHldGfsVHpC4FRO
         WDF3XXdVIwNmD+/NMDhOUf4+qzAeLk1EqYeZBf7wQN0s5UjtFptWcISIrwZmfSO/cZvF
         elcWmmyCkbTspJwPmSrzWBGvh0nZiNZwjwVz+vSpY2ArSLoHha59Ab5t1oF+24u6XxC6
         ovTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M6+Yhi5HmzEaYR1Acp/Tiu9ai7miZvMW3BFnNCGbcK4=;
        b=eCAdZ+cx27SvflYD4+KwkSG4FV7o7iqp49sDW3O4nOYGvGYUqxHMo3sHOfpGBAJtJB
         YpT+COBltsUCmQtzLbB3tP3oWU7D0PfoBrHlI1l/2b9hOs//vZpr0PFu/c93QIx2PWSU
         aNiHt52gGR0oK2NIBmYAE9H2AyVXyUtPIsJGYsjOmdRpgXjxktKrJJP7f9AD8B27wZNc
         lcrIGfVr/lG9xPQGNBsQ7P80+4hFDBgQ3WDsVBh0WNrqxNFGzPQVnrbhkswKSIkUpqSn
         WvyWATGehIzuy0ESoHLjs1KaUp2MDarRKHw0njZx9x+mi914DzSsmz1v8hDSwUOsAqns
         pzBg==
X-Gm-Message-State: AO0yUKVaRoAhccXAIcExlVLksjQEmbieT2pbagvsMXblGKz1VBDYafhy
        5UTBZTDm3f2YehDm+41/roBaU6ArfHKGHf6VAwU=
X-Google-Smtp-Source: AK7set9VhggQuyGk7wz7IT3ufc2D81c5/+i5d+bwf3B1FoqxAjUyKmwz22UJUEaE+wpg5oRmnnQWN/aGG5VAMrRXxwo=
X-Received: by 2002:a17:907:2b09:b0:8b1:cd2e:177a with SMTP id
 gc9-20020a1709072b0900b008b1cd2e177amr3898709ejc.6.1676827691866; Sun, 19 Feb
 2023 09:28:11 -0800 (PST)
MIME-Version: 1.0
References: <26216f60-d9b9-f40c-2c2a-95b3fde6c3bc@gmail.com> <7d1fc713-850d-d9cd-3fe2-60fd690f406a@gmail.com>
In-Reply-To: <7d1fc713-850d-d9cd-3fe2-60fd690f406a@gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 19 Feb 2023 18:28:01 +0100
Message-ID: <CAFBinCBGxectv891GreHtYLvk7mS7F9DZx8_dVA=qht6Beiz3g@mail.gmail.com>
Subject: Re: [PATCH 3/5] hwrng: meson: remove not needed call to platform_set_drvdata
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Feb 18, 2023 at 9:59 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> drvdata isn't used, therefore remove this call.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
