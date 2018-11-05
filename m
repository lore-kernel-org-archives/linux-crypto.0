Return-Path: <SRS0=IFNk=NQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18132C46475
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Nov 2018 13:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D66882081D
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Nov 2018 13:23:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="hNYZNMSh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D66882081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbeKEWm7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Nov 2018 17:42:59 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:33677 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729342AbeKEWm7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Nov 2018 17:42:59 -0500
Received: by mail-it1-f194.google.com with SMTP id p11-v6so7706450itf.0
        for <linux-crypto@vger.kernel.org>; Mon, 05 Nov 2018 05:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=rvYjZ1qca0VX3+3SueX81QrgJpkniRq28GvN3nb0PVo=;
        b=hNYZNMShg+B1oNqnssdhO4CxrOWyEwNtoehfAGDQ2EGOdGUOuWsNwrY62v8Xdf7Tfv
         bX7BuRgd2L7Lnz6aaQd9mhl3DPPLJZjEY8Gm6s5zUVN9oh44X7fCePnKRxEps9vbw8Io
         l5mkZ2jpolRlBTeQvVfKVa+4MYZTwe2YcMY6g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=rvYjZ1qca0VX3+3SueX81QrgJpkniRq28GvN3nb0PVo=;
        b=VOFx89Zw535mwpcxatnkD5ZNAlyO3mUQHZ6L2otGHUCoqNpzI6vD7johT+rgdr3eWF
         WtCLzo1zyVmw1jlC8zhy/o1XiDLm64S555ZL5mrxN+981TWI3QLTNd69aE7kI1M2d5kg
         DvE9xSirW6UfEydwW9CtghdjhWhWgywyPfhpolzuKehOb+4hMVpl273AYHsPQYIFLiDo
         HqkV80M1zjtXtboW39HuBD/eL0xXMzwxN4plk+UQ2sgAkXswqG540hTQ684T6G8rET+/
         Tvb25HVn+efEDmy11EYET7D4WBCeu6sS9520c01Nb5Bd2KzcO6VT5cP7KobS50GiQ9yr
         qZ9g==
X-Gm-Message-State: AGRZ1gJCF6VHJ4LRBD5TDHsHSpXcdK3RtSVVGp+owfIZP2kOmUq7dqLz
        8JHN/IVx9XD5wLmV3AFhwvnSUVq8i4eeF6vgQtN4BQ==
X-Google-Smtp-Source: AJdET5fgnWPC02yEs7xBokRetcNoxkBECzHs6w2HyYp/g/xtQ5gCNNzw8V8jXiyxykqvRZmb4ZSKthu4I40LeU5Q4Xc=
X-Received: by 2002:a05:660c:383:: with SMTP id x3mr6076823itj.121.1541424194022;
 Mon, 05 Nov 2018 05:23:14 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a6b:4f16:0:0:0:0:0 with HTTP; Mon, 5 Nov 2018 05:23:13 -0800 (PST)
In-Reply-To: <20181024032356.3388-3-vt@altlinux.org>
References: <20181024032356.3388-1-vt@altlinux.org> <20181024032356.3388-3-vt@altlinux.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 5 Nov 2018 14:23:13 +0100
Message-ID:
 <CAKv+Gu-DHURWHZdyLY5Tbw5-Te-e_-89k-R91Vv3xRKchhvkYA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] crypto: streebog - register Streebog in hash info
 for IMA
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181105132313.1iQ0cBdkEuDeITzRDFNS8u_q5BF4KHKT3yBkDhyQIgc@z>

On 24 October 2018 at 05:23, Vitaly Chikunov <vt@altlinux.org> wrote:
> Register Streebog hash function in Hash Info arrays to let IMA use
> it for its purposes.
>
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> ---
>  crypto/hash_info.c             | 4 ++++
>  include/crypto/hash_info.h     | 1 +
>  include/uapi/linux/hash_info.h | 2 ++
>  3 files changed, 7 insertions(+)
>
> diff --git a/crypto/hash_info.c b/crypto/hash_info.c
> index 7b1e0b188ce6..b0b91eb0973a 100644
> --- a/crypto/hash_info.c
> +++ b/crypto/hash_info.c
> @@ -32,6 +32,8 @@ const char *const hash_algo_name[HASH_ALGO__LAST] = {
>         [HASH_ALGO_TGR_160]     = "tgr160",
>         [HASH_ALGO_TGR_192]     = "tgr192",
>         [HASH_ALGO_SM3_256]     = "sm3-256",
> +       [HASH_ALGO_SB256]       = "sb256",
> +       [HASH_ALGO_SB512]       = "sb512",
>  };
>  EXPORT_SYMBOL_GPL(hash_algo_name);
>
> @@ -54,5 +56,7 @@ const int hash_digest_size[HASH_ALGO__LAST] = {
>         [HASH_ALGO_TGR_160]     = TGR160_DIGEST_SIZE,
>         [HASH_ALGO_TGR_192]     = TGR192_DIGEST_SIZE,
>         [HASH_ALGO_SM3_256]     = SM3256_DIGEST_SIZE,
> +       [HASH_ALGO_SB256]       = STREEBOG256_DIGEST_SIZE,
> +       [HASH_ALGO_SB512]       = STREEBOG512_DIGEST_SIZE,
>  };
>  EXPORT_SYMBOL_GPL(hash_digest_size);
> diff --git a/include/crypto/hash_info.h b/include/crypto/hash_info.h
> index 56f217d41f12..91786b68dbdb 100644
> --- a/include/crypto/hash_info.h
> +++ b/include/crypto/hash_info.h
> @@ -15,6 +15,7 @@
>
>  #include <crypto/sha.h>
>  #include <crypto/md5.h>
> +#include <crypto/streebog.h>
>
>  #include <uapi/linux/hash_info.h>
>
> diff --git a/include/uapi/linux/hash_info.h b/include/uapi/linux/hash_info.h
> index eea5d02c58de..5e8b8d952ba0 100644
> --- a/include/uapi/linux/hash_info.h
> +++ b/include/uapi/linux/hash_info.h
> @@ -33,6 +33,8 @@ enum hash_algo {
>         HASH_ALGO_TGR_160,
>         HASH_ALGO_TGR_192,
>         HASH_ALGO_SM3_256,
> +       HASH_ALGO_SB256,
> +       HASH_ALGO_SB512,

Could we make this HASH_ALGO_STREEBOG_xxx please?

>         HASH_ALGO__LAST
>  };
>
> --
> 2.11.0
>
