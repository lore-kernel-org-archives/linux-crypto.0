Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367B3C6FD18
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Mar 2023 22:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjCEWM7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Mar 2023 17:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjCEWMk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Mar 2023 17:12:40 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705D91B306
        for <linux-crypto@vger.kernel.org>; Sun,  5 Mar 2023 14:12:01 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-536c02eea4dso151112027b3.4
        for <linux-crypto@vger.kernel.org>; Sun, 05 Mar 2023 14:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VOAZ0bGuvBp/Aobr9qER3nHn+lNrIRRfqJCfBY1Kvv4=;
        b=gjMCt91aKj3KnGGeBKpADkPrRbbByh/HbyOao5EYCMmIKFQZuta8xQBBvACOMSXs3Y
         cdy3mk1yMMEY4hzjzOtxMLSBbgveLrpi9L1tJbEL8JQkHiiqPHRfVR/n2Buc/sbcWJLe
         3oAv4mL6NsCqcGl4kSrVqNctGFeGdYVj2uLPgWa2XWTwVha1qjwVRnLNXUOALM5aRL0S
         BrG+wTjwv9ZiHZo2JSTsQw6AArnp7by4I52AqvoB44V5yZpPY2R+xNWhaK3X3f43co+z
         BTmxWua/F2R0ZN9n+n9EfxjdQ795CaI7i0XteZt0mGqezR9OAVMah3l/8R8bjSNcC9AO
         3+yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VOAZ0bGuvBp/Aobr9qER3nHn+lNrIRRfqJCfBY1Kvv4=;
        b=V1LWDzrhweBEja4el4x0SgLmAX4un0FLLlRyX8/JJtjcVzZzOgWbYruPMIbHUa8q/0
         UW4epO6iL3s5tU0gOCqKdjyA+ia+ItQz67xTBC2FNbQBownei7QlVflcoA55iMeyJolq
         JlGfm+V3/4x5YxPIuTqnk6+BYe5nKB1LCABZH/PnQFVqQYpBl/4RUazYhfRnlMLzsr9E
         7ICwHOd2k3Rsbz5X9ExuiuuzPuUZUIlOjh/KcGJgVSzREHTB/aNEmc6T5ze5tO6BaXb6
         ZH7Ei0qEFes0lduTwyXq6T095Zm9Rad5tjy2RDkcobT8GJuSSrci65lz+k1dXkrDbva3
         O3rg==
X-Gm-Message-State: AO0yUKXG57GA87T5iPB8IO9YMc2DLxB7L7m5c1Kso3eoPAdr0k7xz4BQ
        muMlfaFjl4wsN5F/rJ0yny+5YnBW82uS++HnMrydYA==
X-Google-Smtp-Source: AK7set+Q8NbS3q7qTFquSTzpie0bRNI7LjXs1EmcDoQ1MgyChDNmE71Qt9JWMzSp4ctpJWlHnEc+39tao4m9fEws64M=
X-Received: by 2002:a81:a783:0:b0:533:9b80:a30e with SMTP id
 e125-20020a81a783000000b005339b80a30emr5155244ywh.10.1678054317791; Sun, 05
 Mar 2023 14:11:57 -0800 (PST)
MIME-Version: 1.0
References: <ZAMQjOdi8GfqDUQI@gondor.apana.org.au> <E1pYOKJ-000GZ9-VW@formenos.hmeau.com>
In-Reply-To: <E1pYOKJ-000GZ9-VW@formenos.hmeau.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 5 Mar 2023 23:11:46 +0100
Message-ID: <CACRpkdaqzdwzG4fuO9C4SUymP3i2F1RcfqGMVLHHkoFDABdBFw@mail.gmail.com>
Subject: Re: [v5 PATCH 4/7] crypto: stm32 - Remove unused hdev->err field
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Lionel Debieve <lionel.debieve@foss.st.com>,
        Li kunyu <kunyu@nfschina.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Mar 4, 2023 at 10:37=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:

> The variable hdev->err is never read so it can be removed.
>
> Also remove a spurious inclusion of linux/crypto.h.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
