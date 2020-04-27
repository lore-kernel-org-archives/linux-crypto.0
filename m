Return-Path: <SRS0=Oy//=6L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2521AC54FD0
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 06:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0D0E2075B
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 06:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587970766;
	bh=ov6M4aYlkDxT50jIQMegvBYJbk1S2tGCE0FmhuKWQH0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=IN4dIoXZdk91AfrpqMHNqiP62nUYYJEegZmvqCxnNAOc39A8aOFVAi9UsseWBgAVt
	 elZFWRke+H4VOFGCAD11A5HlXY2iXeB1xm+0RJ5tjV+XoE935tdonDVXlc4Sh+cU10
	 K6PGFS3K0tJW3+kXjA1QuivIEzJLDQCVc1YO/gp4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgD0G7Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Apr 2020 02:59:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726692AbgD0G7Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Apr 2020 02:59:25 -0400
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BFB8208FE;
        Mon, 27 Apr 2020 06:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587970764;
        bh=ov6M4aYlkDxT50jIQMegvBYJbk1S2tGCE0FmhuKWQH0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ep8onAZnXVdYGoJ87QmVsTIcOzFERI9ZdAde4GUoc7yFSD0wM7nX6q5mt3Qsyi17L
         wqSJWEhr+U1gX0Zp1GrgIGBEBOoT5GH17TMSca7cWUFISwXIUeRnmFnoIGOyFpp2RE
         fExOUm9+ncAhMxwXwqVkfMesr/3uuEH85Cf+yUjg=
Received: by mail-io1-f50.google.com with SMTP id f3so17711454ioj.1;
        Sun, 26 Apr 2020 23:59:24 -0700 (PDT)
X-Gm-Message-State: AGi0PuaYlEUKekDEO+SIKkrKUZsEIIvapdxh1wIQTp92b0hfvCbVmGBb
        MZsWw7XoNdLfIZwkk/3RPRV/7LkaBApVyniCD8E=
X-Google-Smtp-Source: APiQypLzw5Wlo2ON/5Pd90vRPCEMvEtwyzNHaL6myGvq3E+y/zS7dhbgAMW6zlSBYKCOh9aP0ySlRWzkTND4iQm/bQ0=
X-Received: by 2002:a5d:8b57:: with SMTP id c23mr19677979iot.161.1587970764040;
 Sun, 26 Apr 2020 23:59:24 -0700 (PDT)
MIME-Version: 1.0
References: <1587966099-28139-1-git-send-email-hadar.gat@arm.com> <1587966099-28139-3-git-send-email-hadar.gat@arm.com>
In-Reply-To: <1587966099-28139-3-git-send-email-hadar.gat@arm.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 27 Apr 2020 08:59:13 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGwVZiGbsT2NwWTyka0FVZnQcmfMSeoBKD03PdC=fRZeA@mail.gmail.com>
Message-ID: <CAMj1kXGwVZiGbsT2NwWTyka0FVZnQcmfMSeoBKD03PdC=fRZeA@mail.gmail.com>
Subject: Re: [PATCH 2/3] hwrng: cctrng - change default to n
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

On Mon, 27 Apr 2020 at 07:42, Hadar Gat <hadar.gat@arm.com> wrote:
>
> For many users, the Arm CryptoCell HW is not available, so the
> default for HW_RANDOM_CCTRNG changed to n.
>
> Signed-off-by: Hadar Gat <hadar.gat@arm.com>
> ---
>  drivers/char/hw_random/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index df2d001..0938d3d 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -476,8 +476,8 @@ config HW_RANDOM_KEYSTONE
>
>  config HW_RANDOM_CCTRNG
>         tristate "Arm CryptoCell True Random Number Generator support"
> -       depends on HAS_IOMEM & OF
> -       default HW_RANDOM
> +       depends on HW_RANDOM & HAS_IOMEM & OF

The whole block is guarded by if HW_RANDOM, so I don't think you need
the dependency here.

> +       default n

'default n' is the default so you can just remove the line

>         help
>           This driver provides support for the True Random Number
>           Generator available in Arm TrustZone CryptoCell.
> --
> 2.7.4
>
