Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDD7C6FA86
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Sep 2022 14:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbiIVOkh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Sep 2022 10:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiIVOj6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2022 10:39:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1F3FB30C;
        Thu, 22 Sep 2022 07:39:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 50C08CE1F66;
        Thu, 22 Sep 2022 14:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EA2C433C1;
        Thu, 22 Sep 2022 14:38:54 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="M9VlzFc9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1663857532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TlQoCsoLTijzFzomdaxYPHopKiTtNfm02w+VlDEcRqQ=;
        b=M9VlzFc9+72HEECh3Aq4xROs2BOKsCAmWeKyi6wx535PaF3LEIobT6G0qnJMJBo/duuUFE
        M+oFJ5783WVXvFXetMWK6NpPzReUdS56/7AZGQVYz5ssOCl6Z0w/fzXq8+RuR0HgCtD3BT
        J+lLBJptWl6THQwIGlTp+/GR2VHblRk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8d80f2f1 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 22 Sep 2022 14:38:52 +0000 (UTC)
Received: by mail-ua1-f51.google.com with SMTP id i17so3738729uaq.9;
        Thu, 22 Sep 2022 07:38:52 -0700 (PDT)
X-Gm-Message-State: ACrzQf1Lihe0c807BglGUOHOAklT/K741/aqP+Ox7wQY9GPVC4EP6ag5
        5Mm6K5IfugjHi2CwNWXdC+8xk3Jxqbc6xZ7KJoo=
X-Google-Smtp-Source: AMsMyM5DrsitONx+2uxMLp6ot7gjN2dgdXslrjLrSFlRhY3PggrL7vrhvWxku1gVC7Xu09o13N/lV0jMNMdI4vtKnGw=
X-Received: by 2002:ab0:2b0d:0:b0:390:ed8c:c78d with SMTP id
 e13-20020ab02b0d000000b00390ed8cc78dmr1461927uar.49.1663857531211; Thu, 22
 Sep 2022 07:38:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220920141438.2782446-1-Jason@zx2c4.com> <YyxoSV3p0JPMMeWO@owl.dominikbrodowski.net>
In-Reply-To: <YyxoSV3p0JPMMeWO@owl.dominikbrodowski.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 22 Sep 2022 16:38:40 +0200
X-Gmail-Original-Message-ID: <CAHmME9pF9c6rUbd4w6j-fHcP=JTCetHmFbHRHBkXn+zShVfe7g@mail.gmail.com>
Message-ID: <CAHmME9pF9c6rUbd4w6j-fHcP=JTCetHmFbHRHBkXn+zShVfe7g@mail.gmail.com>
Subject: Re: [PATCH] random: throttle hwrng writes if no entropy is credited
To:     linux@dominikbrodowski.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 22, 2022 at 4:01 PM Dominik Brodowski
<linux@dominikbrodowski.net> wrote:
>
> Hi Jason,
>
> thanks for splitting this change out of my other patch. You can add my
> Signed-off-by, but I'd like to suggest rewriting the commit message as
> follows (please modify as needed):
>
>
> In case a hwrng source does not provide (trusted) entropy, it cannot
> assist in initializing the CRNG. Therefore, in case
> add_hwgenerator_randomness() is called with the entropy parameter set
> to zero, go to sleep until one reseed interval has passed.
>
> While the hwrng thread currently only runs under conditions where this
> is non-zero, this change is not harmful and prepares for future updates
> to the hwrng core.

Will do.
