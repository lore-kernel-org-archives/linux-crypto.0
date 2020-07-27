Return-Path: <SRS0=C5/f=BG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B846C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jul 2020 04:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24BAC20714
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jul 2020 04:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595825789;
	bh=9mv2NHRKupFqImSSf919VC8iFdyialFr4OrArdTym0M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=elOs1hUVNq6nM5ujZXN+lJPC2WCm4eFlgABgjgHnkcQO8yMGsQ3b0NIIAWI+xTXBl
	 vJyLZiU5ECMg5doVZtUI605JshGtGvWfh4TllbD17G2yRp5f6xbelJnntLt/Ansej2
	 slFPEb6FGP2ln/DBjFetgBnGkI+KkMDclYjWLT+w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgG0E42 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jul 2020 00:56:28 -0400
Received: from conssluserg-04.nifty.com ([210.131.2.83]:28982 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgG0E40 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jul 2020 00:56:26 -0400
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id 06R4u2vZ005262;
        Mon, 27 Jul 2020 13:56:03 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 06R4u2vZ005262
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1595825763;
        bh=VsNfuWLBKO3xt/tClgaisljP3G+NdDWNzhElfMxOfYY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=a1N4XqYgXgZeqAvpuXyZg/EQxm0jnP3s7xKyQ43nza7hGgVA1P6qCNnAjp9XsUi5z
         3rh4B6nM8CZdYZQbTWuPyYaYI54s9FwyuvHV/knkE8KC1A1d3zlcoOKhH6aZUNQ44M
         Du3I2bf73P5wcIlDOltGy1YRkFcPypHTk3dJ3m7WRDLh0isucTBOkFAfO9HJCrxKtZ
         46uV8zN0pWIo3xzHIcJgJ9is0N+1a5X4Ubc6zg3h8ldNg9aHUFaVv8WHImWMEHqU9a
         D1Vj7Rl6jMmOtj9edYkEqvfE5XZu0jLmmJglpU3yt5qfrmrXLZU31tn1ljIy167IIh
         UL/muXbwVOh6A==
X-Nifty-SrcIP: [209.85.222.44]
Received: by mail-ua1-f44.google.com with SMTP id 4so328498uav.8;
        Sun, 26 Jul 2020 21:56:03 -0700 (PDT)
X-Gm-Message-State: AOAM532+N2cI0ng5y97a3Fh+Hp9c75LsQiPYBdPNoCUNPKb+bxTgsQP2
        5DSBeOEJcQtNFv+61tTo4Q/n8O7R8HKr/x+WnEk=
X-Google-Smtp-Source: ABdhPJzBD6NVz4V/UkSdnoYqZT6v6jY8++J4Xf9slSZ/iiqfDsoSYuuWR1bXY9TO8wmRXDEktTQuMDORUmQkciIXFEE=
X-Received: by 2002:ab0:5b91:: with SMTP id y17mr15827254uae.95.1595825761768;
 Sun, 26 Jul 2020 21:56:01 -0700 (PDT)
MIME-Version: 1.0
References: <1595358391-34525-1-git-send-email-clabbe@baylibre.com>
 <1595358391-34525-17-git-send-email-clabbe@baylibre.com> <11ac49bc33546ef9ebc4120878206bd882667d8a.camel@perches.com>
 <b545eb4e3f2b4b676959e4666ef536f2691041eb.camel@perches.com>
In-Reply-To: <b545eb4e3f2b4b676959e4666ef536f2691041eb.camel@perches.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Mon, 27 Jul 2020 13:55:25 +0900
X-Gmail-Original-Message-ID: <CAK7LNATohp=6BySQfn9g5xERm4u2rBG9VaoiGJ33TWovNTZd8w@mail.gmail.com>
Message-ID: <CAK7LNATohp=6BySQfn9g5xERm4u2rBG9VaoiGJ33TWovNTZd8w@mail.gmail.com>
Subject: Re: [PATCH] Makefile.extrawarn: Move sign-compare from W=2 to W=3
To:     Joe Perches <joe@perches.com>
Cc:     Michal Marek <michal.lkml@markovi.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 22, 2020 at 1:57 PM Joe Perches <joe@perches.com> wrote:
>
> This -Wsign-compare compiler warning can be very noisy
> and most of the suggested conversions are unnecessary.
>
> Make the warning W=3 so it's described under the
> "can most likely be ignored" block.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---

Applied to linux-kbuild. Thanks.



> On Tue, 2020-07-21 at 14:32 -0700, Joe Perches wrote:
> > On Tue, 2020-07-21 at 19:06 +0000, Corentin Labbe wrote:
> > > This patch fixes the warning:
> > > warning: comparison of integer expressions of different signedness: 'int' and 'long unsigned int' [-Wsign-compare]
> >
> > I think these do not really need conversion.
> > Are these useful compiler warnings ?
>
> Perhaps move the warning from W=2 to W=3 so
> it's described as "can most likely be ignored"
>
>  scripts/Makefile.extrawarn | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
> index 62c275685b75..95e4cdb94fe9 100644
> --- a/scripts/Makefile.extrawarn
> +++ b/scripts/Makefile.extrawarn
> @@ -66,7 +66,6 @@ KBUILD_CFLAGS += -Wnested-externs
>  KBUILD_CFLAGS += -Wshadow
>  KBUILD_CFLAGS += $(call cc-option, -Wlogical-op)
>  KBUILD_CFLAGS += -Wmissing-field-initializers
> -KBUILD_CFLAGS += -Wsign-compare
>  KBUILD_CFLAGS += -Wtype-limits
>  KBUILD_CFLAGS += $(call cc-option, -Wmaybe-uninitialized)
>  KBUILD_CFLAGS += $(call cc-option, -Wunused-macros)
> @@ -87,6 +86,7 @@ KBUILD_CFLAGS += -Wpacked
>  KBUILD_CFLAGS += -Wpadded
>  KBUILD_CFLAGS += -Wpointer-arith
>  KBUILD_CFLAGS += -Wredundant-decls
> +KBUILD_CFLAGS += -Wsign-compare
>  KBUILD_CFLAGS += -Wswitch-default
>  KBUILD_CFLAGS += $(call cc-option, -Wpacked-bitfield-compat)
>
>
>


--
Best Regards
Masahiro Yamada
