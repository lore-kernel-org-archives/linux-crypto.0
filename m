Return-Path: <SRS0=SmAa=EF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21845C4363A
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Oct 2020 10:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADEA6221FF
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Oct 2020 10:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604054331;
	bh=UXqdytnptRfkles0LLOMHaZ1KItSIYi00Dbknf+7zvM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=osn2YsP1tNoX2fNxtY1reHfU6/wfQtDp2hGW7MZ8egjTVwTmPafbE9mt8TJr2SWGW
	 TbvoQnC9paQqGH5DFYpAGYKwetx7jH8dS4wXWiqDgZuY8Ri0zPg3MB9d/eHtQ2typc
	 saWsBRwhKoWH7c0Z9klXU3wFlFNbgRyTyfUuYakU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgJ3Kiv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Oct 2020 06:38:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgJ3Kiu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Oct 2020 06:38:50 -0400
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA49B221FA;
        Fri, 30 Oct 2020 10:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604054330;
        bh=UXqdytnptRfkles0LLOMHaZ1KItSIYi00Dbknf+7zvM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hPWuGxnKPeGGg4xEDQk0B/67C7JPg5fAcMZe6g9C8HgaK77Qr6ctZ6wra7p755LQr
         PxW3dPfEGZuWPi0xajrmCWGwDXYUeay3zw+RSoq4c2wAZZWSKvmHy9IAJANzuary7i
         kz3VpA5AVqFRNosbaiK0QNDx6cqb1+KUJxY3JxGc=
Received: by mail-oi1-f179.google.com with SMTP id u127so6182254oib.6;
        Fri, 30 Oct 2020 03:38:49 -0700 (PDT)
X-Gm-Message-State: AOAM530g3Ohwdb+kI5l5IuBNBvIoaq3skYNCSXc2ffZo4/uT8/DOEk63
        Hud7/l52AlLOn9Iene6458x1qtONw8X4HOsmEnU=
X-Google-Smtp-Source: ABdhPJzacafNknd0/KaizMeFWMq47Lp9y4/nuylAVvss7AW4Pu5kLB/dccb+jSCG2MgSzU2BmtgkIj3SyrJQgsYFMJc=
X-Received: by 2002:aca:2310:: with SMTP id e16mr1028003oie.47.1604054329082;
 Fri, 30 Oct 2020 03:38:49 -0700 (PDT)
MIME-Version: 1.0
References: <1604045940-33684-1-git-send-email-tiantao6@hisilicon.com>
In-Reply-To: <1604045940-33684-1-git-send-email-tiantao6@hisilicon.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 30 Oct 2020 11:38:38 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE-v=mDLUjiL=dhMN+wVs-UNTQiBLdhJftNqVQ3sxSQsQ@mail.gmail.com>
Message-ID: <CAMj1kXE-v=mDLUjiL=dhMN+wVs-UNTQiBLdhJftNqVQ3sxSQsQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64 - move const after static
To:     Tian Tao <tiantao6@hisilicon.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 30 Oct 2020 at 09:18, Tian Tao <tiantao6@hisilicon.com> wrote:
>
> Fixed the WARNING: Move const after static - use 'static const u8'
>
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>

Nak.

What warning is that? This is perfectly valid C, and the const is
already after the static. And in general, const applies to the type on
the left, unless it comes first, so putting it after the type is less
ambiguous:


> ---
>  arch/arm64/crypto/aes-ce-glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/crypto/aes-ce-glue.c b/arch/arm64/crypto/aes-ce-glue.c
> index 56a5f6f..8ba6f04 100644
> --- a/arch/arm64/crypto/aes-ce-glue.c
> +++ b/arch/arm64/crypto/aes-ce-glue.c
> @@ -77,7 +77,7 @@ int ce_aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
>         /*
>          * The AES key schedule round constants
>          */
> -       static u8 const rcon[] = {
> +       static const u8 rcon[] = {
>                 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36,
>         };
>
> --
> 2.7.4
>
