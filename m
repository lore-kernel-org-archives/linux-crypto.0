Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82D0EEE49A8
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Aug 2023 07:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245598AbjHSHeB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 19 Aug 2023 03:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237395AbjHSHde (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Aug 2023 03:33:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3E73AB5
        for <linux-crypto@vger.kernel.org>; Sat, 19 Aug 2023 00:33:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC39F61682
        for <linux-crypto@vger.kernel.org>; Sat, 19 Aug 2023 07:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31117C433C9
        for <linux-crypto@vger.kernel.org>; Sat, 19 Aug 2023 07:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692430412;
        bh=C2ISKbuy+APNa+67gwVD5tyGJ+Fj+Wf7MsY/5Je97Nw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rUAt8wIYKy7fAau1Ji6eXUQZZkUGrXVU8Q95PiHyfA4bQY2pDSeTVpur7/BipJvji
         SJbxkv5CiiDMwYJCgCIWs34YlK2FlaA+QdRoU35kJ8ydPBj7ZlkB5u2fC+AnLtC4JS
         j0OCMhtY9BL+oszj/uIH4Ap8HyNRbVsb4FtMNGTEBCyslFB+dNb4aKPjd34i5EEDC+
         iDdbWqjLMHC+n39/7i65PjErfgPjo/PkE4EAt2Jw4ViI7vTmCgPnROz3WYFF+gJlx4
         sa+ZMJzU6T+anNko75bcpLVCKe541Br9duL5Y2ibD5lscC3kCAMzYgsCtfPaXc0ELp
         T06OVgfvfKvdg==
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2b9db1de50cso24865521fa.3
        for <linux-crypto@vger.kernel.org>; Sat, 19 Aug 2023 00:33:32 -0700 (PDT)
X-Gm-Message-State: AOJu0YzyEa1OI5mSQZa8koQXGVg04RPvtYHbzMTkAddzvZLsKRCsdSgt
        E86g1QDgj0VqTlJ2yMioPxwkdX+nrHgdwNxj8Wc=
X-Google-Smtp-Source: AGHT+IH62t8nSPugzcJ+dStjLTWhbVFvRQERnk4abU3J0RO9J5knX8IZMd++FPFknWzgJ0RW0g+y2jYEr1baM4AbDLw=
X-Received: by 2002:a2e:3210:0:b0:2b6:c081:6323 with SMTP id
 y16-20020a2e3210000000b002b6c0816323mr861036ljy.50.1692430410114; Sat, 19 Aug
 2023 00:33:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230811140749.5202-1-qianweili@huawei.com> <20230811140749.5202-2-qianweili@huawei.com>
 <ZN8oEpUBq87m+r++@gondor.apana.org.au> <CAMj1kXGNesF91=LScsDSgMx7LwQXOuMjLy7RN5SPLjO3ab7SHA@mail.gmail.com>
 <ZOBBH/XS7Fe0yApm@gondor.apana.org.au>
In-Reply-To: <ZOBBH/XS7Fe0yApm@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 19 Aug 2023 09:33:18 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHd6svuQ-JSVmUZK=xUPR4fC4BCoUjMhFKfg2KBZcavrw@mail.gmail.com>
Message-ID: <CAMj1kXHd6svuQ-JSVmUZK=xUPR4fC4BCoUjMhFKfg2KBZcavrw@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] crypto: hisilicon/qm - obtain the mailbox
 configuration at one time
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Weili Qian <qianweili@huawei.com>, Will Deacon <will@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        shenyang39@huawei.com, liulongfang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 19 Aug 2023 at 06:12, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Aug 18, 2023 at 12:21:02PM +0200, Ard Biesheuvel wrote:
> >
> > IIRC there have been other cases (ThunderX?) where 128 bit MMIO
> > accessors were needed for some peripheral, but common arm64 helpers
> > were rejected on the basis that this atomic behavior is not
> > architectural.
> >
> > Obviously, using inline asm in the driver is not the right way either,
> > so perhaps we should consider introducing some common infrastructure
> > anyway, including some expectation management about their guarantees.
>
> The ones in
>
>         drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
>
> look better.  So perhaps copy them into hisilicon?
>

No, that otx2_write128() routine looks buggy, actually, The ! at the
end means writeback, and so the register holding addr will be
modified, which is not reflect in the asm constraints. It also lacks a
barrier.

The generic version just ORs the low and high qwords together, so it
obviously only exists for compile coverage (and the generic atomic add
is clearly broken too)
