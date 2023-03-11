Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D2BBC61DA4
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Mar 2023 21:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjCKVpH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Mar 2023 16:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjCKVpG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Mar 2023 16:45:06 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721516781C
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 13:45:05 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id o199so6588882ybc.7
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 13:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678571104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V78i6y2U0JrvgA27xfI4kIOjh7BS243z1h7M0b9g4iI=;
        b=CAWhIbPWKjVi7CdJFPa7TuXndq4ajKqJs7evVWtdvZ1Pm8sMxs5sOFbn2CFGHFiVXS
         g2hzPCQRVOgkYRF8TkjIMf1oF+ZamxeA/w5E/VAufRVu5xWmM6UPUQ4KufBLuxnz96mJ
         GSEor/3TSqHw7KHYRUYMR7Id0wWUxney1RDbUuK/Mi0HT6tj/rjG1po4YeIb8F6GA/AM
         P+vGZB4uQgfLL+XzyZnQiLYZSQmQTFLj4GdkShV0lfzb+z0/DroSnhVMUaHtukAWFc+x
         0AH9qEw13tlZn5lJHc29ngleS1VCBg6q0uAyXPdaFV+w2smVJjxa1PO0cogHtqypnOIE
         yfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678571104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V78i6y2U0JrvgA27xfI4kIOjh7BS243z1h7M0b9g4iI=;
        b=OcMlMdksKAHWc3grvlgTRkXb/9Bz9fINxyFtrEojlHD0PL0o0WRrPFPABagSaL0e2E
         69G80Dn+EQWq8Axn2vvVgaL9PmIpeNeXijM8kn37RMUcY3UAYZvonfHqWx5SeZWbFSik
         2Y/VmvIOjx+P1cdokGbWTg75JtJXWd/fqWV3mL8nisQPZg3i4ih3SjrfOMm2pTscJD9t
         tAt14RaKGzXeXGVuU+U88cTpT+uJ//q+Z4C+2e0mP8dI0+qxnDfGg8KzRfus1dXryFII
         6qxc2TCBaug/KQ5XDB35laqYR93zpmAF4H5Pt0YHgXXPjfxmNw5uYK4H8CnZ9ccerkql
         qDxg==
X-Gm-Message-State: AO0yUKXFjc+R76Gp3E4Q+B73IOsRjwW4B5l9KHtJ86aqAV/a4AEIzl1/
        XYQma3bgkGED3Itiq0yZIPyIt4xBbEt+EWh1aiBtuQ==
X-Google-Smtp-Source: AK7set+39HzMoBpl+vvm9JGXuO6EGGnCk4eBVUYGG6a176w4mALlPDxN42Bby7S6RrQONDPKM6nr5DzH2Xk3Aa6DWwk=
X-Received: by 2002:a05:6902:4f4:b0:a06:5ef5:3a82 with SMTP id
 w20-20020a05690204f400b00a065ef53a82mr14712961ybs.5.1678571104368; Sat, 11
 Mar 2023 13:45:04 -0800 (PST)
MIME-Version: 1.0
References: <ZAxFBR3TdA7jUAgJ@gondor.apana.org.au> <E1pavEB-002xbR-I9@formenos.hmeau.com>
In-Reply-To: <E1pavEB-002xbR-I9@formenos.hmeau.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 11 Mar 2023 22:44:52 +0100
Message-ID: <CACRpkdb-tCWAHS3Bt8q2q3sXE5bWVVf42_qOS0ogKhCj_VRksw@mail.gmail.com>
Subject: Re: [v7 PATCH 7/8] crypto: stm32 - Fix empty message processing
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

On Sat, Mar 11, 2023 at 10:09=E2=80=AFAM Herbert Xu <herbert@gondor.apana.o=
rg.au> wrote:

> Change the emptymsg check in stm32_hash_copy_hash to rely on whether
> we have any existing hash state, rather than whether this particular
> update request is empty.
>
> Also avoid computing the hash for empty messages as this could hang.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Excellent patch. Also works flawlessly.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
