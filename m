Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B9DC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Apr 2022 14:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbiDYO6p (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Apr 2022 10:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiDYO6o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Apr 2022 10:58:44 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B3338A5
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 07:55:38 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id u7so12057411plg.13
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 07:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=Irud/fjEDwtKGSTM/fX98kdcWDeez0fxLuYrA6kD/Io=;
        b=pt1oE5D/nTEMphPF9Jesa4CreIWYUDt98zEimS+bPB2HqmM+w2iDjYbS9+nfLigt4z
         Vby4H9KCMY1L1V0YNt90Wj9kdCPeN/6pnsOlcQekyw2kux35RQTNFQf3e/QQ/3IPgioc
         ZRzAv4EVKFXtBUbjUpIacROemdBTgIhH6vtMNSmCls8cCiWmWCBteg5UMr/5xrhsLTCd
         LQNPjGjHkMB2xaHd90FwRvVwGaw4ItSQ/oF5hWV9EtLiOYjwnZRuHVl7mOopuZp/e9DU
         sseYqtArUasGUT9jv0nvF8yuuZTF9aGTDzz5vqjJOuyr8/4KRp8Tz+Bh60JMam7zmk1l
         9wgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=Irud/fjEDwtKGSTM/fX98kdcWDeez0fxLuYrA6kD/Io=;
        b=iHhApvxHGSShRrlsbROAK1oovIhMaYGQOcScWtz8h2U66a5nhXMTYacuMSAigMTeUo
         1gsuWAmBSEWl7pXo020g9+Iu7mArTI5EDkgHd5OosWi4mka1/JO7/qSIdr7bIkEr4L4l
         xJwoDQ0GEBNTjtMKu7nlRro8bMCEspA2cFMPbMrE4fRvNBS3gsTcpmvGrR4GRgB9HZFo
         NxDKSBB3Qc1CpeJ5Lal5/WheB82P5MmauhY0wqWResJyErnxGucHases5TY6Nme0GeZA
         sX///JYmYvAriASvLGULL3Qh47tY3BOQUHYD0g8ZkUfhASNZYK7DtzacHQxkjAdZBfpC
         X8bA==
X-Gm-Message-State: AOAM533z55+FvwKnSMrDPvoeUwvjXyyzVYccO3OCn1I2I2uY+xayQvOP
        7cvt8ogtDu96e/jD8NVL3RHMbA==
X-Google-Smtp-Source: ABdhPJxti0iMF/R5gN1kkmkWl7/kAH49jyNvreI6n/Axh2Unj9WVGxFWcE12SV6PDI9nAfgOOd2jxA==
X-Received: by 2002:a17:90a:a385:b0:1cb:bfa8:ae01 with SMTP id x5-20020a17090aa38500b001cbbfa8ae01mr20974567pjp.116.1650898538174;
        Mon, 25 Apr 2022 07:55:38 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id w137-20020a62828f000000b0050d2f9c3409sm6325133pfd.199.2022.04.25.07.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 07:55:37 -0700 (PDT)
Date:   Mon, 25 Apr 2022 07:55:37 -0700 (PDT)
X-Google-Original-Date: Mon, 25 Apr 2022 07:55:33 PDT (-0700)
Subject:     Re: [PATCH v6 08/17] riscv: use fallback for random_get_entropy() instead of zero
In-Reply-To: <20220423212623.1957011-9-Jason@zx2c4.com>
CC:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        tglx@linutronix.de, Arnd Bergmann <arnd@arndb.de>, Jason@zx2c4.com,
        Paul Walmsley <paul.walmsley@sifive.com>
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     Jason@zx2c4.com
Message-ID: <mhng-57e67f41-bbc5-437c-b4cd-c6f5f9924a67@palmer-mbp2014>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 23 Apr 2022 14:26:14 PDT (-0700), Jason@zx2c4.com wrote:
> In the event that random_get_entropy() can't access a cycle counter or
> similar, falling back to returning 0 is really not the best we can do.
> Instead, at least calling random_get_entropy_fallback() would be
> preferable, because that always needs to return _something_, even
> falling back to jiffies eventually. It's not as though
> random_get_entropy_fallback() is super high precision or guaranteed to
> be entropic, but basically anything that's not zero all the time is
> better than returning zero all the time.

Makes sense: we had an architecturally-mandated timer at the time, but 
we don't any more.  Every real implementation has a timer right now, but 
that may change in the future so it doesn't hurt to fix it before it's 
broken.

> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Paul Walmsley <paul.walmsley@sifive.com>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  arch/riscv/include/asm/timex.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/include/asm/timex.h b/arch/riscv/include/asm/timex.h
> index 507cae273bc6..d6a7428f6248 100644
> --- a/arch/riscv/include/asm/timex.h
> +++ b/arch/riscv/include/asm/timex.h
> @@ -41,7 +41,7 @@ static inline u32 get_cycles_hi(void)
>  static inline unsigned long random_get_entropy(void)
>  {
>  	if (unlikely(clint_time_val == NULL))
> -		return 0;
> +		return random_get_entropy_fallback();
>  	return get_cycles();
>  }
>  #define random_get_entropy()	random_get_entropy()

Fine for me if this goes in via some other tree, but also happy to take 
it via the RISC-V tree if you'd like.  IMO we could just call this a 
fix, maybe

Fixes: aa9887608e77 ("RISC-V: Check clint_time_val before use")

(but that just brought this back, so there's likely older kernels broken 
too).  Shouldn't be breaking any real hardware, though, so no rush on my 
end.

Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>

Thanks!
