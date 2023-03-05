Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D920AC61DA4
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Mar 2023 21:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjCEVvq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Mar 2023 16:51:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCEVvp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Mar 2023 16:51:45 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A169811145
        for <linux-crypto@vger.kernel.org>; Sun,  5 Mar 2023 13:51:44 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-536c2a1cc07so150224347b3.5
        for <linux-crypto@vger.kernel.org>; Sun, 05 Mar 2023 13:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P4nagVa5A/zThSizaZWcAj9+LI0HVFxK9izn7FANSgc=;
        b=IAn+kCbqQsCW+Kqg1JURWxcIvDd/JjLFYkB3TvbTA+IrrUjtIuNnoObUDW/G/lxUfc
         XqNOE9bwR29rV5d0tGhTiGygqI4cxkDCN9iOdJ2R3WBNPtkIry86TEK7HlYzn7Obq7M+
         vU+KbEzCWj400IbzEN5fZJUaCXY71Xp5OHXD1UZ6Xni01b3EaRQjOTDkd+8R29scMIvJ
         cl3TAsZ1DAxOcPlwD7YFOgwZIrPu+tO7eqo0xHH2jQYlV05MczXTdGJvaVBbrBw8LrW8
         dlrQdfd+WP5+aHVgQZVUJ9+khXmZ2Czaouv3Iz5G3bqaxmnk+DBGraicQ8eAZEo2XCnH
         xzhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P4nagVa5A/zThSizaZWcAj9+LI0HVFxK9izn7FANSgc=;
        b=gHn9VKHxocrc836dXxXisk5oQROwZ9fyFDhUF3X/ecleYmwttkwNwMynmYfsPHWNex
         kXP8PbjOFd/mvCs4b2LGgBEv/lbwA2EdCjOZmm8ttwMARgXyQ/dckvNqRg4OdIJXqm4J
         0ei3v/q8QfITf/zbgdr/P/2ltYVpdHZ+b6Afk9TmVZhTIY2X4zlKI0Pi+hV9EliQn81Q
         i5x/xuXqlCDp2Mlcn8wmbc30YHDBbL+8FHYJBYb1n/jDslS7ObSQkRyxKbZABePqHeNF
         uw1sUcEP+m3+D7CepWpTp8Frqzf5GJYkg1r8CUcswJ+Vn0A36PUrQAa5kc9auU8XX5a+
         Zf1w==
X-Gm-Message-State: AO0yUKU00EfzaagE4jLROY4w06gDoFqDRUasc7MyTTVIk0BPokmmCPCB
        86QNSZqdpqSqu8bSZ10OwXUmSLUtoXIjZBqA8qvsmA==
X-Google-Smtp-Source: AK7set8WqgWYN9z/yS50vyhHB4nsTvSMESsxVTSN3nt8vqTEYgHy8/ZF/JobK9m0Y3iTYswh1vfHlW0HsmFqfaqLJdk=
X-Received: by 2002:a81:b624:0:b0:52e:f77c:315d with SMTP id
 u36-20020a81b624000000b0052ef77c315dmr5580789ywh.3.1678053103873; Sun, 05 Mar
 2023 13:51:43 -0800 (PST)
MIME-Version: 1.0
References: <ZAMQjOdi8GfqDUQI@gondor.apana.org.au> <E1pYOKF-000GYm-MW@formenos.hmeau.com>
In-Reply-To: <E1pYOKF-000GYm-MW@formenos.hmeau.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 5 Mar 2023 22:51:32 +0100
Message-ID: <CACRpkdYH91rgE7wF17pDi58z9Rq68JqNxbR2XMQ0=si_w7aCnA@mail.gmail.com>
Subject: Re: [v5 PATCH 2/7] crypto: stm32 - Move polling into do_one_request
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

> There is no need to poll separate for update and final.  We could
> merge them into do_one_request.
>
> Also fix the error handling so that we don't poll (and overwrite
> the error) when an error has already occurred.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Works like a charm and passes all tests.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
