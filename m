Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E5F0C433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Nov 2022 09:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbiKGJZV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:25:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbiKGJZH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Nov 2022 04:25:07 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E562418B19
        for <linux-crypto@vger.kernel.org>; Mon,  7 Nov 2022 01:24:31 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id z14so15210856wrn.7
        for <linux-crypto@vger.kernel.org>; Mon, 07 Nov 2022 01:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+354V4bqL0Q80jmGbwChiKqgB2s0lMwmgUyfQySGfaA=;
        b=E71QyXbP3nAgn6MM5N2pgIc3hT3H/iHfIUAU8Ieoh/Ek99yAgL4c+CSCtxXlJFsxi2
         oQKXQt5hRIoFkHwXg4zDilcpzkUaNn5sHtJF+RXJMDmKJ8GvRHLOYuf7jOjKILE7JLXz
         vkf3yrbpQNlPbK3hzs4yvXiGrtLXR4GhK1keNClzSJ68zTACMW9QOlIo3dJBkpqfZkNY
         rYqrcRMkTZr95zGNnMJDUjRbaAgqaqQQ7jKZjfPJlegxtwOWJfPsjbJQDHCwR7WObvjg
         sOXt/xfP3F5lmklHbFiX99USOs+IweJ5rmmNJ3FmYYsx54KH9yB5mizRKoMTndNF34LK
         R5sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+354V4bqL0Q80jmGbwChiKqgB2s0lMwmgUyfQySGfaA=;
        b=Z7WmjBzPSy+xkcimdy+5U3zWWE7zyn+YTdtcCQ2f2QrlzjnUwtHAmuHGVxWSer+KDs
         R3wz5Yc+HYRf/IGcLQiE3YsQi2uvUrUKGRmrCo8o1pIUDKEUty4deIdE4ZtexhFXTac5
         Cu0nAhKnRzVZo73Ga+dTXmer5A5HdAUq6QBB5OQra+TgVMKKW8yK+UNbFeR8LCd+MVCZ
         Tm8u/sgSBE/bJNsozhMfy18irDtSI+mzYQd+k+TnSJl5qIJ0kqvwKFkIeATRqMJXDTXm
         RVUpYLSqhFf9jLRiegadisZSEAD3HiyVdjxTCDULliJJHx5gYxpxVYdSwmsOSUcIEUiV
         jrwg==
X-Gm-Message-State: ACrzQf0Xm54/Tu57lQcyJ9nvClNW37Bjrt6LUzYvjhiqAX2ZxDbXvt1H
        jigE7g+UBzBB6bGUD17PajHcyzHqWyRUTbtv
X-Google-Smtp-Source: AMsMyM76jUbfY3U9anmFeQe0yqiI0jfkssTVhjiLNVk0IeFJjugyoiEQh76BCcrNqUAVsVF7XkG27Q==
X-Received: by 2002:adf:ed89:0:b0:236:8ef6:472d with SMTP id c9-20020adfed89000000b002368ef6472dmr28532719wro.61.1667813070284;
        Mon, 07 Nov 2022 01:24:30 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id bw14-20020a0560001f8e00b00240dcd4d1cesm2268916wrb.105.2022.11.07.01.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 01:24:29 -0800 (PST)
Date:   Mon, 7 Nov 2022 10:24:24 +0100
From:   Corentin LABBE <clabbe@baylibre.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net, heiko@sntech.de,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next v2] crypto: rockchip: Remove surplus dev_err() when
 using platform_get_irq()
Message-ID: <Y2jOyPoor1hJ7xoV@Red>
References: <20221104074527.37353-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221104074527.37353-1-yang.lee@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Fri, Nov 04, 2022 at 03:45:27PM +0800, Yang Li a écrit :
> There is no need to call the dev_err() function directly to print a
> custom message when handling an error from either the platform_get_irq()
> or platform_get_irq_byname() functions as both are going to display an
> appropriate error message in case of a failure.
> 
> ./drivers/crypto/rockchip/rk3288_crypto.c:351:2-9: line 351 is
> redundant because platform_get_irq() already prints an error
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2677
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
> 
> change in v2:
> --According to Corentin's suggestion, make the subject started by "crypto: rockchip:".
> 
>  drivers/crypto/rockchip/rk3288_crypto.c | 1 -
>  1 file changed, 1 deletion(-)
> 

Hello

Acked-by: Corentin Labbe <clabbe@baylibre.com>

Thanks
