Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F3EC6FA8E
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Mar 2023 21:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjCEVsU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Mar 2023 16:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjCEVsT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Mar 2023 16:48:19 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4775DEB60
        for <linux-crypto@vger.kernel.org>; Sun,  5 Mar 2023 13:48:18 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-536c02eea4dso150430807b3.4
        for <linux-crypto@vger.kernel.org>; Sun, 05 Mar 2023 13:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QLT9596esNn9+ZcDd3rcdHbsJUKw8b1aHwiveWbhaq4=;
        b=z8VAIRkfAxemi/FtNcAurB8B2D6jDvXRySFM6h+xAQyuToi6WuFeJY1DcnkWkDln4B
         nK0Hkwwq4ZNcB9OpZhT8qq76gu9rv0NWrg89giWkop6p+o3dcPg5T0/VsDc54iolxtEJ
         LTPZuI8c6nNCHC0IyUrbZvR5NdsIoJEOWL+11zsCe2Qu3NH7ng9qB/h8o8Z0YTyDzvFV
         qW1zS1pNW6fsn9UN9F9d+W70tNZFaFDPCTvp3nnu3hHrDXi1qLXirJzWC3nNNcGeVqDF
         J1aAjvlIGTN0R/Rcj+HBn4PQkVuw4CB4pAqjn3+sQXmn/cdZZO9QNH2EKCosQOn+u+Xi
         065Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QLT9596esNn9+ZcDd3rcdHbsJUKw8b1aHwiveWbhaq4=;
        b=EAv8ZJ7TMptI5d8dZ+uJan747/LEeOY9H/Jzemp0xt9YaXhsrIkmoNV+zTXWNYd2yN
         bUE/uh4kn3OhUOJ8iwlMIwBX4AGiUnsligUwkHnITowA84hgZcJO3ciZuxvE/3vCIZkH
         w0El3HcaHpwdCclGx9iWw/I6VdBK9esVKX1zbM0RNHI7evCXGByA24yn9CcHmKzupZ+k
         3CmBxvgiOaDTopN3HWoCnSOSMQ0Ko9FUPa+DBsYLvs7jIHuejoDVFfGmJ936EQU0j4Mt
         jEhk+Dko1g0arSuzMNyGteEd9KFWdB1Jzd6yYrq0M/4KzhzBdAodyrOYVuGkrPbwI+Rh
         /8Gg==
X-Gm-Message-State: AO0yUKUarhypLtApNyiclQ/EupOggvcg7TCXv3uDXDCaffvD+SuNGjZR
        fOYUtGzI5m+tAI3n2GvXl3fnvfQUoJ9GFBUO0PDPiA==
X-Google-Smtp-Source: AK7set9PwbP37M+qcdmd1OrmePnuWQ5cf/oim9FxyxWYN5ZTGhjFStopLAhPM2VM1sBwIOJyAtQgfJUn/9eHK0O0pGA=
X-Received: by 2002:a81:431e:0:b0:533:8080:16ee with SMTP id
 q30-20020a81431e000000b00533808016eemr5437131ywa.10.1678052897405; Sun, 05
 Mar 2023 13:48:17 -0800 (PST)
MIME-Version: 1.0
References: <ZAMQjOdi8GfqDUQI@gondor.apana.org.au> <E1pYOKD-000GYe-HX@formenos.hmeau.com>
In-Reply-To: <E1pYOKD-000GYe-HX@formenos.hmeau.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 5 Mar 2023 22:48:05 +0100
Message-ID: <CACRpkdYcGx_=GufsRwtRm_tCeZFvYFM+R0CGK521=DSRo+WXXw@mail.gmail.com>
Subject: Re: [v5 PATCH 1/7] crypto: stm32 - Save 54 CSR registers
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

> The CSR registers go from 0 to 53.  So the number of registers
> should be 54.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Hm I don't know where this misunderstanding comes from.
I think it's this tendency by some engineers to use index 1 :/

The datasheet for U8500 says:
0xF8            HASH_CSFULL      HASH context full register
0xFC            HASH_CSDATAIN    HASH context swap data input register
0x100           HASH_CSR0        HASH context swap register 0
0x104 to 0x1CC  HASH_CSR1 to 51  HASH context swap register 1 to 51

0xf8, 0xfc, 0x100 =3D 3 registers
0x104 to 0x1cc =3D 51 registers

Indeed 54.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
