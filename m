Return-Path: <SRS0=3MGL=SB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C57C43381
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Mar 2019 09:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DCE6218AC
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Mar 2019 09:52:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ve8aib5T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730462AbfC3Jws (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 30 Mar 2019 05:52:48 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40842 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730384AbfC3Jws (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 30 Mar 2019 05:52:48 -0400
Received: by mail-io1-f66.google.com with SMTP id d201so3789772iof.7
        for <linux-crypto@vger.kernel.org>; Sat, 30 Mar 2019 02:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4xrq6r7h1UQHZ3msMa956AslB0ZlKR4LtZFl5pMhpN4=;
        b=Ve8aib5TyVJXGJAnU2e7GZDBuIWHpYIBSu9Y+F14+Iyflo5daD0sWqeJwuHa7mG5IG
         hweI1pZkmQc4QvRKa7aTlxRE/j4t7RpEM91Zw1yGUGAHP3iX8ZZwthYWk/b4QmZ8kXQX
         86F4txmv/omTeaIYXzPi51D9AkEbLKliCCkQH2nSUR5QUgWsPOkAXOKua1vvqTuxq2Ig
         HcOe2v9x5Q0K6FsS+UB8nMWcfb6MvSB03EdE07CPoo1FCzIe/xunlJHcTHUp6QKu9s2v
         Yr/AJNjkh0BJ24BtvrZgdHkQbX3klhb8TUUOrTA647IZ5jXYZ6+SLcrdR2wbrwi2JgXA
         c/tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4xrq6r7h1UQHZ3msMa956AslB0ZlKR4LtZFl5pMhpN4=;
        b=XOJLtGJRmND7O1wVS5BoP65VGr76fE5vH6eYAznujNZjZUDg30XijmWfsUjW3Jsn8q
         E1NSqBb9SpMFTDMPujc9VrUPhWvc4jbrBwvoJjCacBKBOSSzDPQuJosOczJFA/D2bW+r
         lRCyTdGj8XXIw1YJck9vwkIiJMPnYILYh3TfqA5vjXHvzNq93RQkYqjDZE7jb9qoc1Xu
         QNSUYYswIOfZe70kwFPvYEMVXYP1CMmfJOGV+76h/qyr6ZY3YZEYORHdRYjFdFr9bTS4
         Fqa/2/cmoqVhJvs7SfDlvk0M8kGfsQnMaFLMncW3zzrfLZZi3F/QwLDeDSBTk3YqKCTH
         3uwg==
X-Gm-Message-State: APjAAAXATfr0Cr1zZjUraYItnKUxSDQ4/F+MrGmZWghe2PBJxPdsWB76
        Xl1kzRoWRvxmYpNSQG4K6omtb6slK5nO+Tz15MzXKqJ/KEmixw==
X-Google-Smtp-Source: APXvYqz5ZOqYGjqGWCnAmzos5p2btTxL8xoXFvNjeOF7/wIbnrbrcFEus2Zu4N/EpqtgtrfSACQgmJDNkMqycPvpE74=
X-Received: by 2002:a5e:8418:: with SMTP id h24mr9670215ioj.170.1553939567080;
 Sat, 30 Mar 2019 02:52:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190330004629.29394-1-andi@firstfloor.org>
In-Reply-To: <20190330004629.29394-1-andi@firstfloor.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 30 Mar 2019 10:52:35 +0100
Message-ID: <CAKv+Gu9pYMQV+qud2=xbpna_duiQ_L7uPqdC-WJ=U5_gOWkKrQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: Use ___cacheline_aligned for aes data
To:     Andi Kleen <andi@firstfloor.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 30 Mar 2019 at 01:46, Andi Kleen <andi@firstfloor.org> wrote:
>
> From: Andi Kleen <ak@linux.intel.com>
>
> cacheline_aligned is a special section. It cannot be const at the same
> time because it's not read-only. It doesn't give any MMU protection.
>
> Mark it ____cacheline_aligned to not place it in a special section,
> but just align it in .rodata
>
> Cc: herbert@gondor.apana.org.au
> Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Fixes: 913a3aa07d ("crypto: arm/aes - add some hardening against
cache-timing attacks")


> ---
>  crypto/aes_generic.c | 8 ++++----
>  include/crypto/aes.h | 8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
> index 13df33aca463..fddcbe3edb0a 100644
> --- a/crypto/aes_generic.c
> +++ b/crypto/aes_generic.c
> @@ -64,7 +64,7 @@ static inline u8 byte(const u32 x, const unsigned n)
>  static const u32 rco_tab[10] = { 1, 2, 4, 8, 16, 32, 64, 128, 27, 54 };
>
>  /* cacheline-aligned to facilitate prefetching into cache */
> -__visible const u32 crypto_ft_tab[4][256] __cacheline_aligned = {
> +__visible const u32 crypto_ft_tab[4][256] ____cacheline_aligned = {
>         {
>                 0xa56363c6, 0x847c7cf8, 0x997777ee, 0x8d7b7bf6,
>                 0x0df2f2ff, 0xbd6b6bd6, 0xb16f6fde, 0x54c5c591,
> @@ -328,7 +328,7 @@ __visible const u32 crypto_ft_tab[4][256] __cacheline_aligned = {
>         }
>  };
>
> -__visible const u32 crypto_fl_tab[4][256] __cacheline_aligned = {
> +__visible const u32 crypto_fl_tab[4][256] ____cacheline_aligned = {
>         {
>                 0x00000063, 0x0000007c, 0x00000077, 0x0000007b,
>                 0x000000f2, 0x0000006b, 0x0000006f, 0x000000c5,
> @@ -592,7 +592,7 @@ __visible const u32 crypto_fl_tab[4][256] __cacheline_aligned = {
>         }
>  };
>
> -__visible const u32 crypto_it_tab[4][256] __cacheline_aligned = {
> +__visible const u32 crypto_it_tab[4][256] ____cacheline_aligned = {
>         {
>                 0x50a7f451, 0x5365417e, 0xc3a4171a, 0x965e273a,
>                 0xcb6bab3b, 0xf1459d1f, 0xab58faac, 0x9303e34b,
> @@ -856,7 +856,7 @@ __visible const u32 crypto_it_tab[4][256] __cacheline_aligned = {
>         }
>  };
>
> -__visible const u32 crypto_il_tab[4][256] __cacheline_aligned = {
> +__visible const u32 crypto_il_tab[4][256] ____cacheline_aligned = {
>         {
>                 0x00000052, 0x00000009, 0x0000006a, 0x000000d5,
>                 0x00000030, 0x00000036, 0x000000a5, 0x00000038,
> diff --git a/include/crypto/aes.h b/include/crypto/aes.h
> index 852eaa9cd4db..0fdb542c70cd 100644
> --- a/include/crypto/aes.h
> +++ b/include/crypto/aes.h
> @@ -28,10 +28,10 @@ struct crypto_aes_ctx {
>         u32 key_length;
>  };
>
> -extern const u32 crypto_ft_tab[4][256];
> -extern const u32 crypto_fl_tab[4][256];
> -extern const u32 crypto_it_tab[4][256];
> -extern const u32 crypto_il_tab[4][256];
> +extern const u32 crypto_ft_tab[4][256] ____cacheline_aligned;
> +extern const u32 crypto_fl_tab[4][256] ____cacheline_aligned;
> +extern const u32 crypto_it_tab[4][256] ____cacheline_aligned;
> +extern const u32 crypto_il_tab[4][256] ____cacheline_aligned;
>
>  int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
>                 unsigned int key_len);
> --
> 2.20.1
>
