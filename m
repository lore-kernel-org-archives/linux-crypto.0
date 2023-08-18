Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6AE5C678DC
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Aug 2023 10:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358435AbjHRKVW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Aug 2023 06:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359836AbjHRKVU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Aug 2023 06:21:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07CD35A6
        for <linux-crypto@vger.kernel.org>; Fri, 18 Aug 2023 03:21:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D50B64472
        for <linux-crypto@vger.kernel.org>; Fri, 18 Aug 2023 10:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978C5C433C8
        for <linux-crypto@vger.kernel.org>; Fri, 18 Aug 2023 10:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692354075;
        bh=sTfpJjtKSzrc3H24A3dr7dX0JUdWaJKKPjcvYeQPeVE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=b6TEmC9nU9KtWrQpiFYEZiu5asijyFNInlg/oPsN6s1Zx25Txwy9R4c44Szx7QHjd
         xITveB48YBmQW+K/HFv7Ff6O8lAXT4MDC9YBt1wrTxcnfwLLnS3CoRtP2dbwF8ZIuC
         3jDyFQa4gmptHlcQdHzLPd3VN0ecq5Cj1x9P5XXF8YkYhOGgNnaF2gCe8a8Br1Olhu
         uN+DgDomFjxkwdywhVEzgpX0NLaGm/TibDQv6H2xlrGIr3rgrFFFlIYZt5/7N1vp/b
         S4UZssQqpCUyluJmAlq/R5V0qdpcQhqZUgOfdKK4VqGWOMhiAG+d4vKyIrIYbYdLfF
         NX7uCYnhTfc9g==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-4ff8a1746e0so1072016e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 18 Aug 2023 03:21:15 -0700 (PDT)
X-Gm-Message-State: AOJu0YyDKj0o6GZc6NIUpGc5wllJKveiOhvQMICCrvuJW7MdmytYEsxy
        ua+JKaWH4rV4qs2+itCjeI74NZoxzAugKx5Cm+A=
X-Google-Smtp-Source: AGHT+IEUbCkv2iXXSLDStJv0iB5oF01KuyRXpCD0HWUtJBizHkcftZwDUi9HHbk4HB7m3mRRmwDupuD9VWcdXIsdW7k=
X-Received: by 2002:a05:6512:39c3:b0:4fe:c98:789a with SMTP id
 k3-20020a05651239c300b004fe0c98789amr1816856lfu.37.1692354073626; Fri, 18 Aug
 2023 03:21:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230811140749.5202-1-qianweili@huawei.com> <20230811140749.5202-2-qianweili@huawei.com>
 <ZN8oEpUBq87m+r++@gondor.apana.org.au>
In-Reply-To: <ZN8oEpUBq87m+r++@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 18 Aug 2023 12:21:02 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGNesF91=LScsDSgMx7LwQXOuMjLy7RN5SPLjO3ab7SHA@mail.gmail.com>
Message-ID: <CAMj1kXGNesF91=LScsDSgMx7LwQXOuMjLy7RN5SPLjO3ab7SHA@mail.gmail.com>
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

On Fri, 18 Aug 2023 at 10:13, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Aug 11, 2023 at 10:07:43PM +0800, Weili Qian wrote:
> > The malibox needs to be triggered by a 128bit atomic operation. The
> > reason is that one QM hardware entity in one accelerator servers QM
> > mailbox MMIO interfaces in related PF and VFs. A mutex cannot lock
> > mailbox processes in different functions. When multiple functions access
> > the mailbox simultaneously, if the generic IO interface readq/writeq
> > is used to access the mailbox, the data read from mailbox or written to
> > mailbox is unpredictable. Therefore, the generic IO interface is changed
> > to a 128bit atomic operation.
> >
> > Signed-off-by: Weili Qian <qianweili@huawei.com>
> > ---
> >  drivers/crypto/hisilicon/qm.c | 160 ++++++++++++++++++++++------------
> >  include/linux/hisi_acc_qm.h   |   1 -
> >  2 files changed, 105 insertions(+), 56 deletions(-)
> >  mode change 100644 => 100755 drivers/crypto/hisilicon/qm.c
>
> ...
>
> > -     qm_mb_write(qm, mailbox);
> > +#if IS_ENABLED(CONFIG_ARM64)
> > +     asm volatile("ldp %0, %1, %3\n"
> > +                  "stp %0, %1, %2\n"
> > +                  "dmb oshst\n"
> > +                  : "=&r" (tmp0),
> > +                    "=&r" (tmp1),
> > +                    "+Q" (*((char *)dst))
> > +                  : "Q" (*((char __iomem *)fun_base))
> > +                  : "memory");
> > +#endif
>
> You should add a generic 128-bite write primitive for arm64 instead
> of doing it in raw assembly in the driver.
>

IIRC there have been other cases (ThunderX?) where 128 bit MMIO
accessors were needed for some peripheral, but common arm64 helpers
were rejected on the basis that this atomic behavior is not
architectural.

Obviously, using inline asm in the driver is not the right way either,
so perhaps we should consider introducing some common infrastructure
anyway, including some expectation management about their guarantees.
