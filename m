Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E46C0C61DA4
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Mar 2023 10:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjCFKCC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Mar 2023 05:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjCFKCC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Mar 2023 05:02:02 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE85D23C4E
        for <linux-crypto@vger.kernel.org>; Mon,  6 Mar 2023 02:01:58 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-536bbe5f888so173721097b3.8
        for <linux-crypto@vger.kernel.org>; Mon, 06 Mar 2023 02:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QD4rUPOwl3QwymfiFfudLxgF+k9sizGQtygZ6Xm8TaU=;
        b=En/KrIn6bNmZttBEZpgWZAjYMwbfb90TweOp8cecesdczbo2sLeXNl6Ju8cerTmrvu
         c1fVqDBfsFCMxq2fu9UrEY6qQMWMmzAB8jRd6ipdmCvWjnO5Gqt1ZValbHqzCgWoWLxr
         InCFNKXaVTgLVyN3iNaYH/IrMmVGvhXsRezr8EdfH+dEP/F0R95IrzSbdghn01qDuYi/
         4hzkC95K2bRJek78QyTcf4UnTTIiVwDdiiMxQ9mVHe1Zm0T0QEag0jr0cOYhzCuE3awk
         VCpeMfghlz5KXrFklJkdSHykKMLq5/94TBP2Vg+Kl2Sh2Uqs4/CtJ9/Y87njdc7oQKP4
         yemQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QD4rUPOwl3QwymfiFfudLxgF+k9sizGQtygZ6Xm8TaU=;
        b=N9aJdHFyg10RcezO6cebhOg2UuXOfdhYjsBUHYcmHoND5cSpvvdgR/nvd+dR1yOQj+
         T4EUPM3m0GEkjxvEkmE3XfDxGlHmUYnyFhRF2TxlUW2u+0id7/EkjnlfoMtjbm5R6O1S
         Kd51DqNXhdC/pXhC8feuv9Js2ZqPA1cADd3B6AteZhMJ6xWkE1ICBd8UZRjsV4ntrJET
         gPZJBOneK+nQCmQHNH8nFHPGiuUJAVQcNjPZpPdbXcYkSM7Y/PgIkemAvmcubYmu27OU
         bTMnq7pymmwwBDdJmj9AYsc9TjgwuHLFTQHesxF0oGpELNS5wWJ2z5LmD30DUZMRSV6e
         iSvQ==
X-Gm-Message-State: AO0yUKX6iWHwfS8nhC4Yj/MUfyCK+mkBy3yU8V+SxMKtuExldyYvn3Tl
        sx+QK4fUcugm5CeAsLGj2hEfLyQrP6Mb/WfgHLThZ3mbjjMS8WPb
X-Google-Smtp-Source: AK7set8yVm+4S3McVEwMVY5gRhLLC3IT/8pJgkJO55yRqGWg8PlD44jommdj8TfHnLckgPf3bx0xyH81bt2B2fGRuz0=
X-Received: by 2002:a81:a12:0:b0:533:9d13:a067 with SMTP id
 18-20020a810a12000000b005339d13a067mr8759239ywk.3.1678096918021; Mon, 06 Mar
 2023 02:01:58 -0800 (PST)
MIME-Version: 1.0
References: <ZAVu/XHbL9IR5D3h@gondor.apana.org.au> <E1pZ2fq-000e1q-0T@formenos.hmeau.com>
In-Reply-To: <E1pZ2fq-000e1q-0T@formenos.hmeau.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 6 Mar 2023 11:01:46 +0100
Message-ID: <CACRpkdZrOW3c6QkUVdyZie52S1XmWbexG2K=Ttmoi1fuOD+Nng@mail.gmail.com>
Subject: Re: [v5 PATCH 6/7] crypto: stm32 - Remove unused HASH_FLAGS_ERRORS
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

On Mon, Mar 6, 2023 at 5:42=E2=80=AFAM Herbert Xu <herbert@gondor.apana.org=
.au> wrote:

> The bit HASH_FLAGS_ERRORS was never used.  Remove it.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
