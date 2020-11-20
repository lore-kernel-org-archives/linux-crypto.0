Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 670D9C63777
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 08:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDD222225B
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 08:55:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ft+sc814"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbgKTIza (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Nov 2020 03:55:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgKTIza (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Nov 2020 03:55:30 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2899BC0613CF
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2020 00:55:30 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id y4so8712489edy.5
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2020 00:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=e8nn6AgEofGqyuAf1BSX1B7XgheU9u2AReV9paY/Rb4=;
        b=Ft+sc814RunH7OADrLDO4oLYun8FoYeHajFkFgbGHT81Q7zs/pcB9r4iHsnv/65T9e
         RuAqKzYax8v31XlCkBcYVISmL33cjsYPOwFYiY4GBAHr8j3G+r7XfOjhHKaGsiuVDjVk
         elOUPsuzHiweFlURhLzAohN+AKOAOTDMr+J0UXdXjH6EJdi5maWunnxxgsrlbzF1nO4P
         0CgQvAKp6n6+fbintWSe/gSwemleu6Tj05apR1iZk+/Ka+kNfEW8ogCYcZj4omh9Vg/P
         TnARcBOQIK5Jt5Q2P/yDLPh6b57pamG7+q48bXL5pBRaGO74/tmUTbx8Wca4wqNlzz+t
         2icQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=e8nn6AgEofGqyuAf1BSX1B7XgheU9u2AReV9paY/Rb4=;
        b=TqQqCaEVJcxse5XcvgAdsEsSV6lLRYjObbL1TbIfMM7MLoEz0FyYTq9BawU3v5Z5ca
         MCjgelbjveOSeuWm3b8XhNCOkOu3Iph85N8qXvJYd1lczgnCTcDzHLu6CiGUGZXoH+Xp
         gH3HYsaPmta5IblSax2H2z6ulGwRn0oUYHgbhXdlPsH2MHU8EqHbl5iR9N00Lzrl1SlD
         zEhSKdXxuP/hsSQMloGtg+1bnu5Uy62Lge6ZLMEUtW3Hf3d+N8DSI7zuM5TJJmATMs4C
         UlxV3/rSvl6BnVAWWSi1vys6GhRvdhvC8upL5VYBVvaBgZKS4tX9KpoJquQ7WRWwC+Ew
         eNww==
X-Gm-Message-State: AOAM530hcAoRc8pIKN9cnNUSrW3jpphrOna7NZBF/Bmheu0p2XiGEpaS
        89KKciTrjQ11Xf+luqdXEU0vt3vUgwBBbNt3q8YF1rBOX6k=
X-Google-Smtp-Source: ABdhPJxekYO+j2+7p6Ez3XouXKQ4xax3D+g8AnvTkkAZW6laCqUnN3HHAuL3GjSkvXSmJGin27ad5jK51+OCJRkwPR8=
X-Received: by 2002:aa7:cc14:: with SMTP id q20mr10076827edt.140.1605862528929;
 Fri, 20 Nov 2020 00:55:28 -0800 (PST)
MIME-Version: 1.0
References: <20201117133214.29114-1-ardb@kernel.org> <20201117133214.29114-5-ardb@kernel.org>
In-Reply-To: <20201117133214.29114-5-ardb@kernel.org>
From:   =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Date:   Fri, 20 Nov 2020 09:55:18 +0100
Message-ID: <CAAUqJDtf2dB3D10H6dWgomrEMoExv4Cy97gJ4jCTXQNT=vVYEA@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] crypto: aegis128 - expose SIMD code path as
 separate driver
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ut 17. 11. 2020 o 14:32 Ard Biesheuvel <ardb@kernel.org> nap=C3=ADsal(a):
> Wiring the SIMD code into the generic driver has the unfortunate side
> effect that the tcrypt testing code cannot distinguish them, and will
> therefore not use the latter to fuzz test the former, as it does for
> other algorithms.
>
> So let's refactor the code a bit so we can register two implementations:
> aegis128-generic and aegis128-simd.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Ondrej Mosnacek <omosnacek@gmail.com>
