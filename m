Return-Path: <SRS0=Oy//=6L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE9DC55199
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 06:58:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD64A2084D
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 06:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587970712;
	bh=BH25q4ox23BW3FKdKWlrgv6GNAblqqJelLmOgAaRXfE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=csY79RlbLDUw0MYOcT+wsuzYgjikYJS33oL3EuVqYVcrUrNjo/FclIsoWqAuJQx6O
	 VZvTHCp+OTL7p8l4UIXGRthzESrPFJUhIKF4sY/fzbVt0D/zwj0mi+vmjt0ZJjZ6oh
	 9nqMYsmazYocTr76ql72vQImn8UWgNZQ+Gxe5tIc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgD0G6b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Apr 2020 02:58:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgD0G6b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Apr 2020 02:58:31 -0400
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 722B4217BA;
        Mon, 27 Apr 2020 06:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587970710;
        bh=BH25q4ox23BW3FKdKWlrgv6GNAblqqJelLmOgAaRXfE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KN3VthEga1Dlobi7MKNVeKkx35ynJB0XYaV7ISXyuLI7xev2jzkE2PiTAcOJGKck8
         OOapEHynwz0QiOh8knh0pEywgvwIONTP/7CRxHObodn/D/mrxr/e11D3m/xeZkdVuK
         C3yX5JmdxcTrrl+JMESOX9Rwuvmzhz6CXcfaWkH4=
Received: by mail-il1-f173.google.com with SMTP id m5so7443407ilj.10;
        Sun, 26 Apr 2020 23:58:30 -0700 (PDT)
X-Gm-Message-State: AGi0PualtMOTlEN/xSs0HyD04ua9Epzti94pBSOZzristTOqjHTG0Cb4
        ysoZHaDO4+Ca2O0/lxcQlCpEO5xoLN8/mdju/Vs=
X-Google-Smtp-Source: APiQypLYJKvvsGMLuuLQKHPaoSK2vexjk9mfhROlFt2OzJZ+PerIxGaNFu2HXVpq6ZZKwTR5ejj64dtjHoSK8bQQZCk=
X-Received: by 2002:a92:607:: with SMTP id x7mr18076185ilg.218.1587970709786;
 Sun, 26 Apr 2020 23:58:29 -0700 (PDT)
MIME-Version: 1.0
References: <1587966099-28139-1-git-send-email-hadar.gat@arm.com> <1587966099-28139-2-git-send-email-hadar.gat@arm.com>
In-Reply-To: <1587966099-28139-2-git-send-email-hadar.gat@arm.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 27 Apr 2020 08:58:18 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHN1qzoP9YNmrFcTJRncJE88Jyp_MS_9XrdAiY9v6DAyw@mail.gmail.com>
Message-ID: <CAMj1kXHN1qzoP9YNmrFcTJRncJE88Jyp_MS_9XrdAiY9v6DAyw@mail.gmail.com>
Subject: Re: [PATCH 1/3] hwrng: cctrng - Add dependency on OF
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
> The cctrng is unusable on non-DT systems so we should depend
> on it.
>
> Signed-off-by: Hadar Gat <hadar.gat@arm.com>
> ---
>  drivers/char/hw_random/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 0c99735..df2d001 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -476,7 +476,7 @@ config HW_RANDOM_KEYSTONE
>
>  config HW_RANDOM_CCTRNG
>         tristate "Arm CryptoCell True Random Number Generator support"
> -       depends on HAS_IOMEM
> +       depends on HAS_IOMEM & OF

Does your driver in fact depend on CONFIG_HAS_IOMEM ?

>         default HW_RANDOM
>         help
>           This driver provides support for the True Random Number
> --
> 2.7.4
>
