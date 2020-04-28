Return-Path: <SRS0=WjNG=6M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B60C83000
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Apr 2020 15:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D6F72075E
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Apr 2020 15:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgD1Pbj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Apr 2020 11:31:39 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:45675 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbgD1Pbj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Apr 2020 11:31:39 -0400
Received: by mail-ot1-f65.google.com with SMTP id e20so33291189otk.12;
        Tue, 28 Apr 2020 08:31:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H0LOD7XbNY8f26IcdF+mTtRkvNc/cLKM59So7aS3RUw=;
        b=Kh4h/h4ROTQqDh64ylfpPGzS3za/yVYdFZeoCZxjL3yGkQXvlwvtNpURUK1+ORePif
         FkgMwjMxG5nmKPLcAjbrGMOrbSCUKJvztugDgxSCw95QFpzH+Nprzjt9iU+pG1w6Rqm1
         g0ROcLt4kN7c923mEgQKQY7VV+H1Fxrm6L0UF4ym/y4+8HQQrydr51L3xUqGda2C/O4F
         E/bAqqPWO/K49lG7sxmsHoOB9+ZzP0D2iy5oh154/50qzbGpf5FMCSbOSV1vVLOXrPFb
         TO5oJSMciPYaXxzyfXWBWK0bRul4ZkeSCrzQtgsKclWFXk7cFl3OIm9qFGQPrXPsWGOc
         pmAg==
X-Gm-Message-State: AGi0PuZv1ZHZAXM48nUJoXo3HXMFm0JbV745xWMHdMjoQb/5vvE904/5
        wRVBhgt/GvnKjuRuqnE0C6ZSQabUn7V6MT42UbI=
X-Google-Smtp-Source: APiQypKmPPMRmFDEpK+pbxelea00daQWJAo2cqKdKqvVtb9z1shjQduzXoV/x4KObl7etnUGy2BDWPAjQyNgmtVAs6E=
X-Received: by 2002:a9d:7d85:: with SMTP id j5mr21717225otn.107.1588087898648;
 Tue, 28 Apr 2020 08:31:38 -0700 (PDT)
MIME-Version: 1.0
References: <1587987364-4566-1-git-send-email-hadar.gat@arm.com> <1587987364-4566-3-git-send-email-hadar.gat@arm.com>
In-Reply-To: <1587987364-4566-3-git-send-email-hadar.gat@arm.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 28 Apr 2020 17:31:25 +0200
Message-ID: <CAMuHMdWdgnqAp8rHyMj9gCXD2WBweeB6g38OV6S2MJ5KFLyvcw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] hwrng: cctrng - change default to n
To:     Hadar Gat <hadar.gat@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 27, 2020 at 1:39 PM Hadar Gat <hadar.gat@arm.com> wrote:
> For many users, the Arm CryptoCell HW is not available, so the default for
> HW_RANDOM_CCTRNG should to n.
> Remove the line to follow the convention - 'n' is the default anyway so no
> need to state it explicitly.
>
> Signed-off-by: Hadar Gat <hadar.gat@arm.com>

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
