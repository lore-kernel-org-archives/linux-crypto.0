Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E31FA372A
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 16:26:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1B1821A49
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 16:26:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="LgzC5Cn/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393752AbfJPQ0r (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 12:26:47 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34481 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729156AbfJPQ0r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 12:26:47 -0400
Received: by mail-pg1-f194.google.com with SMTP id k20so7240827pgi.1
        for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2019 09:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=2XIK6irSOUYOqaT55Cb2rTG7oY2nstdNhyuJ62jJp1w=;
        b=LgzC5Cn/xPt2olUE60N4pEOt4RSI2ZpcK9ac3jR5QUoHjfZ6KopcgFKySrAzfqZTLK
         xw/GP4Ayp98mwvf5lXiBtokVwF22c/go7Jq2fmAHO3+z/dfZ4UGj2h2lSPA4WPi3wTu5
         kx2xY3EISo3KDeawhuE8CoFt6RS3ckhddrTpZUBfj85vPWLuQ5gjqKgIodSgMg2Z8UOE
         QLXiWAtlZnMJukqaX13llRVWRA5GhM1++i+VT2hv2z7Jz1d1zTL4o+yZm0aV0tI5Dor3
         5/Lm+xvgudiyUXI4Q4b3d+P6YU/hlFTOozKWQPwvl5Qs3pkxxAMSoh8rHBJCZr+G0LNL
         AJnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=2XIK6irSOUYOqaT55Cb2rTG7oY2nstdNhyuJ62jJp1w=;
        b=JvqDCGZjpJX3T5UOAGj4jcIg5sHtEniq1d/FWrII25/jVnyFshQCaTNXv0bdnY8vIl
         X8ORsB24VqpJgZaLATXyIp5gI5Aja7CJQBYVxfUxF5DedqKQe6qR88lP3GopUDEukak9
         apqdtktIeLzaMxzg2s0N9wHWCmyIvQAVM5ZED5PbCFORr0LDXvF7FNXNV0NVY0ZbJrLH
         /dPmjQ5br+tcKrD/T/rHJv2S0OghHtAQqsP8MkK+9a3HRI9aJHwpa4eHgHjJ1e20HRaG
         vUF02d4eiJTQhRVw46CxE+qdkYbfw/9XXdF3capqW0biJj0TFPBdJ/ktqV0Sw2YX7exF
         iRaw==
X-Gm-Message-State: APjAAAUxS1zTzuCrjJXBUmGpGlsweMAcdF6YuMeHTd51ZpB23De3tzTL
        xTRBWAdSPCOgAobrP0OHpzKFTQ==
X-Google-Smtp-Source: APXvYqygm5XuOYj8EY825cN0gcWiXGpwZtxv9FetNVUXLKyxWccm3GGuLgq33/o/9nNMAg3YUL0DMw==
X-Received: by 2002:a63:4705:: with SMTP id u5mr24757808pga.317.1571243205298;
        Wed, 16 Oct 2019 09:26:45 -0700 (PDT)
Received: from localhost (c-71-197-186-152.hsd1.wa.comcast.net. [71.197.186.152])
        by smtp.gmail.com with ESMTPSA id c16sm3155360pja.2.2019.10.16.09.26.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Oct 2019 09:26:44 -0700 (PDT)
From:   Kevin Hilman <khilman@baylibre.com>
To:     YueHaibing <yuehaibing@huawei.com>, herbert@gondor.apana.org.au,
        mpm@selenic.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        ludovic.desroches@microchip.com, f.fainelli@gmail.com,
        rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, eric@anholt.net,
        wahrenst@gmx.net, l.stelmach@samsung.com, kgene@kernel.org,
        krzk@kernel.org, dsaxena@plexity.net, patrice.chotard@st.com
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH -next 06/13] hwrng: meson - use devm_platform_ioremap_resource() to simplify code
In-Reply-To: <20191016104621.26056-7-yuehaibing@huawei.com>
References: <20191016104621.26056-1-yuehaibing@huawei.com> <20191016104621.26056-7-yuehaibing@huawei.com>
Date:   Wed, 16 Oct 2019 09:26:43 -0700
Message-ID: <7h4l08hd18.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> writes:

> Use devm_platform_ioremap_resource() to simplify the code a bit.
> This is detected by coccinelle.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Kevin Hilman <khilman@baylibre.com>
