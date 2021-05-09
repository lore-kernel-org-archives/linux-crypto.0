Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69295C433B4
	for <linux-crypto@archiver.kernel.org>; Sun,  9 May 2021 00:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3730C6101E
	for <linux-crypto@archiver.kernel.org>; Sun,  9 May 2021 00:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhEIAfd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 8 May 2021 20:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhEIAfc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 May 2021 20:35:32 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73304C061573
        for <linux-crypto@vger.kernel.org>; Sat,  8 May 2021 17:34:30 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id t11so18081948lfl.11
        for <linux-crypto@vger.kernel.org>; Sat, 08 May 2021 17:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nioUacGgmn1npsnF7UjH/G9jEKx4GaZezabtRTdAHNQ=;
        b=yYcpD96kUzepSQpuQfBGevivuidrKiXsh8ogT+mWIOv1Qcmls5U6isOVtJAS74kOFF
         2/RRdzcW8gis5NsZy5QJZrw2RPGepBediQrFxIDn+Ois12Ne/Q6wwt3WLnl4bq+r8eEo
         Say48A9hZMOjaWV5Iy/A73cfhSeGkz3nGoo1avWJcqw2OavtfZNdYpBcicZUITIVp2UF
         0/QWkWxBl1M3l67KnFoYSDpYeDSHjRwP+h2eZt/9RClBnpfJClfLU1+OLWk9iMsMSs+Q
         vST+tnS90331h/ZuPy+6edYsE9FYCvN1WBbkjGtxEs2zXpyiNISxkZtivUrXni+jS4it
         LlpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nioUacGgmn1npsnF7UjH/G9jEKx4GaZezabtRTdAHNQ=;
        b=ZPNhdVj/Zhu/gnt4YpRa7mesrGbpDNIqvrElF7Vn+d7t/OUOUkMGfqFrvomZHB6JYE
         6z/zFAlQicTdpoHb4mMsjQjKNHXSkzvCYUoYOHmqNS+ztNgHte1ZNc/z26YTvMopyI+G
         pIqN3AN3xd+oDzkuXP/3W3bdluCVDprLHV4pK7MIF+Ni10RUUq/P/zpyLkQqrmKqHP6N
         c8w1C804exqjgQEQQPpcK+QavbyVO4z7VTcv99ArkILJU3IQbf3FhiQ8AavnLetUVzZY
         SSbX1N0xGATcVgJDwdsqsNOzf5DU9o09Tw5529xdZb0OyMeEb1y56fP+0U564oxoTFzC
         OBwg==
X-Gm-Message-State: AOAM532F2AHsG0m/9ZT0ukZD7zjl0OpGLWN5RkvveviVtI+YILMZwIbF
        r7RsW4CKRux1q76y7BjXsiSxAJQf/zWgk8ZxDSTMJA==
X-Google-Smtp-Source: ABdhPJxbPU5qQoWYfS6KGidcbReW4q83/88i0j0ikF/ehy9FP8scZoynk/akVfH99CeiCQ+yfmKsQDO+/cOQgzfatdk=
X-Received: by 2002:a19:b0b:: with SMTP id 11mr11191818lfl.291.1620520469033;
 Sat, 08 May 2021 17:34:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210508070049.2674-1-thunder.leizhen@huawei.com>
In-Reply-To: <20210508070049.2674-1-thunder.leizhen@huawei.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 9 May 2021 02:34:18 +0200
Message-ID: <CACRpkdY9wPVE+mDzLbjxp-=Au6jHn6g378Dc24=fpG50T23qRA@mail.gmail.com>
Subject: Re: [PATCH 1/1] crypto: ux500 - Fix error return code in hash_hw_final()
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Andreas Westin <andreas.westin@stericsson.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, May 8, 2021 at 9:01 AM Zhen Lei <thunder.leizhen@huawei.com> wrote:

> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
>
> Fixes: 8a63b1994c50 ("crypto: ux500 - Add driver for HASH hardware")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
