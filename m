Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F6DC1B0D8
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 22:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 745D923602
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 22:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgLPWdi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Dec 2020 17:33:38 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:43111 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727167AbgLPWdh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Dec 2020 17:33:37 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f09161a8
        for <linux-crypto@vger.kernel.org>;
        Wed, 16 Dec 2020 22:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=JOWtu1omcs+/9E16DeEz4AU0Nk4=; b=DPjsPg
        Ifh00P9HWTpmQUvcaAIEiYd8+/GtxdQ600s50vt4S70wqGfA1EKlncXmeDmmh5sR
        BdinzixnNw5aGXWxL77vNQ/N9MEmVCDJq0qP3W6dGWtw8WuB1HBuEE8Is4jxfcpY
        70P1e2/ziiI5IrGZJ/Inw/HfrvbETWEl8DcwOpAb0HqhYC3wdFNGoTJVci3WTZyd
        bTrRz3wobJAUoA4fSOKeML76+93jHUwOmscemeZ8FmKWISUgbtafA2Umn5EaJhRx
        HWVShJLJSeeAY+rIE4RMBGUd1rTHTAecSVteTbQ6oFK7aYzScq/0xOLsfyDGnYhc
        GDIXrh6u00NJYPng==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ff0d5c68 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Wed, 16 Dec 2020 22:25:15 +0000 (UTC)
Received: by mail-yb1-f177.google.com with SMTP id w139so23983419ybe.4
        for <linux-crypto@vger.kernel.org>; Wed, 16 Dec 2020 14:32:55 -0800 (PST)
X-Gm-Message-State: AOAM531bXw/6kL0j58COobtm3LrICBH0uQvHDIbGw9QjfBlX3suFCwzH
        6hvL1VNEBR5KVGnfboYZ5cY+HACDg6txr7JNDkA=
X-Google-Smtp-Source: ABdhPJyG7jbTvHGZ3OGV/zORXRnE9z2ICpfUIkSkqXUxk8VSKABJEH43WeCUgs8y9o/etl3jfP7SSQMEtD3TaA5dgGc=
X-Received: by 2002:a25:bb81:: with SMTP id y1mr54022580ybg.456.1608157975181;
 Wed, 16 Dec 2020 14:32:55 -0800 (PST)
MIME-Version: 1.0
References: <20201215234708.105527-1-ebiggers@kernel.org> <X9pyfAaw5hQ6ngTI@gmail.com>
In-Reply-To: <X9pyfAaw5hQ6ngTI@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 16 Dec 2020 23:32:44 +0100
X-Gmail-Original-Message-ID: <CAHmME9qj+D8opq6pnoMd4vsOsTYaL9Ntxk0HvskAiPvXFev75A@mail.gmail.com>
Message-ID: <CAHmME9qj+D8opq6pnoMd4vsOsTYaL9Ntxk0HvskAiPvXFev75A@mail.gmail.com>
Subject: Re: [PATCH 0/5] crypto: add NEON-optimized BLAKE2b
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        Paul Crowley <paulcrowley@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

On Wed, Dec 16, 2020 at 9:48 PM Eric Biggers <ebiggers@kernel.org> wrote:
> By the way, if people are interested in having my ARM scalar implementation of
> BLAKE2s in the kernel too, I can send a patchset for that too.  It just ended up
> being slower than BLAKE2b and SHA-1, so it wasn't as good for the use case
> mentioned above.  If it were to be added as "blake2s-256-arm", we'd have:

I'd certainly be interested in this. Any rough idea how it performs
for pretty small messages compared to the generic implementation?
100-140 byte ranges? Is the speedup about the same as for longer
messages because this doesn't parallelize across multiple blocks?

Jason
