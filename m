Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C2AC4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Dec 2022 10:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiLOK1O (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Dec 2022 05:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiLOK1M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Dec 2022 05:27:12 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F83F17
        for <linux-crypto@vger.kernel.org>; Thu, 15 Dec 2022 02:27:10 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id o127so2951373yba.5
        for <linux-crypto@vger.kernel.org>; Thu, 15 Dec 2022 02:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YwZEBKJYU5V3a+h6ICUOLLs2RtIW5lrP2U9zp6ekoJA=;
        b=RrZ/geVHSY940Y7h265mobeJD3vYyklAaA9ScqHScMJgG9pTV9tS2YJ1VfIC+idjEk
         p1hi48WgQBKl6uO4L59b6Or6bSri5WVv6ua53dxeTTiwhajOvof28TGg1YGtdRBi9c8L
         qvgA0OPuSI9ggmbnrsqWQTFKFL/mxgs41h50UHQYqFic3QGHxwvPUIRvUa+L3LZLLEV5
         2HBt059b/D5Qv0gVJRz9sgO+HVVaEmODpt/Hl5V/yM2VF02iB3EUWjRR76bQqXIDtvG+
         DToBURSsKp9yJY5Wu+px/pB+/oUjAJLwrlfTQNfNkVd+II5BFC1zirMLm/T7FF3DtUZi
         m56w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YwZEBKJYU5V3a+h6ICUOLLs2RtIW5lrP2U9zp6ekoJA=;
        b=GZrjqX8zp3eddCJSZj8IqsCu6qNqv9vrSXKr2cmt+2F4lyyr8I4PohCVkZRmPtOQNm
         M4K4RsP7aVmms4F90vx20eA3HCsjGIo8qlNbpJKmQxOKqYUxyZ4fLh5sbHtn7LuEa/Hn
         GrSIXc4rEQ8nqsEAlJ0TxWGIoOMGSxDj+KEknXV44J075f+85U2tBd6Hej7efFHrcP2O
         mQN+Adnzt4OmNYpS20HZf31WD2V1SAeBpIlv9mZvabG4YXvmLdq+FdfG+wgEIvyof+Ch
         GT1v9IsfWS6Rc60nImlPPIqkuJgPS7xL6oILQb4CUIsgXBlQlIlGCwwfy8KOtSOeqNdW
         WkOA==
X-Gm-Message-State: ANoB5pnvifd0h5o6AJxJwLJDBirRzE1OeuHbWxu8faR3moxMKyrXO9zy
        Sc8U8HvND2EErxDFRipBA1aXvhX1aAyA0MZPTsdcVw==
X-Google-Smtp-Source: AA0mqf4XQNVS8RnQIMfKh3JVXKUrK7OJxGlYJrd8edAqsu7pOfDsebYFZiY/5EMfKka7ICc9RBfv0wgVBd2XHWhnB8U=
X-Received: by 2002:a25:d2ce:0:b0:710:f2e2:eb92 with SMTP id
 j197-20020a25d2ce000000b00710f2e2eb92mr3670381ybg.304.1671100029903; Thu, 15
 Dec 2022 02:27:09 -0800 (PST)
MIME-Version: 1.0
References: <20221207103936.2198407-1-ardb@kernel.org> <20221207103936.2198407-3-ardb@kernel.org>
In-Reply-To: <20221207103936.2198407-3-ardb@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 15 Dec 2022 11:26:58 +0100
Message-ID: <CACRpkdYiHQQtw2=iPKos3sXEkeErTNxR7T0FPBrCqhQxtxhCkA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ARM: permit non-nested kernel mode NEON in softirq context
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk,
        linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 7, 2022 at 11:39 AM Ard Biesheuvel <ardb@kernel.org> wrote:

> We currently only permit kernel mode NEON in process context, to avoid
> the need to preserve/restore the NEON register file when taking an
> exception while running in the kernel.
>
> Like we did on arm64, we can relax this restriction substantially, by
> permitting kernel mode NEON from softirq context, while ensuring that
> softirq processing is disabled when the NEON is being used in task
> context. This guarantees that only NEON context belonging to user space
> needs to be preserved and restored, which is already taken care of.
>
> This is especially relevant for network encryption, where incoming
> frames are typically handled in softirq context, and deferring software
> decryption to a kernel thread or falling back to C code are both
> undesirable from a performance PoV.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

So boosting WireGuard as primary SW network encryption user?
This is really neat, BTW:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
