Return-Path: <SRS0=pGAR=XD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4655DC433EF
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Sep 2019 08:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11CF620854
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Sep 2019 08:10:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="MZ1vd8ZW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfIHIKY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 Sep 2019 04:10:24 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:34889 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbfIHIKY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Sep 2019 04:10:24 -0400
Received: by mail-vs1-f68.google.com with SMTP id b11so6821772vsq.2
        for <linux-crypto@vger.kernel.org>; Sun, 08 Sep 2019 01:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k77CMjVjdq78y5ATyrkyyrME48gpK1LxSXD754oXC7Q=;
        b=MZ1vd8ZWmt5aiRlfGNYcsryzQiqVOVFe17rtau5Iaoc1ymFlOsqZ/Vtnj/zdSfNtys
         4xnrsnyKe/1rbDo/dIvjjP2Mu0eUhfWsv3Nt7XfVohyaMeQPsH4vk4ehU8nWOKHUqDER
         nKqsuqkcKO2OQ/eB9Hy6funqV5WFUwY6iYoaamCYuDKU1BwxIrWeRJdZm0P162hJwTiQ
         /xMCH3oHQdVTACcZq2XV5RDPODZ30lr3ZQNRJ7XgbM0wy/9lnkxkRi6PtN5hRtxlFKnl
         fL0rlD6nAvoCcQov21SDHZCQbuhISfK637MSDsfAj0qib8E8SyqPzYcE+0MHaHok4qnS
         E9bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k77CMjVjdq78y5ATyrkyyrME48gpK1LxSXD754oXC7Q=;
        b=dVrJV9u7ZG4SsRQ0bp82OUphDpGr3ve3hgBLBmSBGD1lrXWO6xi/933r6+pHiCf68+
         o1mhjCATiHP0ASjDCCqE9tAzfrGu+EJqtZYjv5ZD/mJfgFZa0Wb+Xz0Wm5rXeDFuKK5i
         ouikf4m2FH3GOzNC0ctZHNog1Kp5H58iG00u7GS0n2z1K+5w8UdqHV40UiSVIK/2lbTl
         oKXUJo+S867ivrEQ2iaWl4s48tJgv8sDlXLfT4Nx9gjpE+A1j5T7ZdQA9N7Up1BHvALh
         2Yk7zoav6eLbLoTufESlzjzqMf34N9BL44zVC638sBrjgIrXFuv01R9p7VM+iP8IqnjS
         Dgqw==
X-Gm-Message-State: APjAAAWAXGVwx9wCh543ID7gPZUn1VFxt0OnD7or+nfV0Yq7eyWitGtM
        bh7NaTTdeequgrUc7ikuRKY/Onl5fRhgyqloAYo1sA==
X-Google-Smtp-Source: APXvYqyUzijf305gU7w755cGPUaW3NmEm24UxLUM3IgWidzj2ivMT8tj2jn7CXKRZeZtUaY+5sdowLg/bNATZnlEzuI=
X-Received: by 2002:a67:fd49:: with SMTP id g9mr3272698vsr.136.1567930222833;
 Sun, 08 Sep 2019 01:10:22 -0700 (PDT)
MIME-Version: 1.0
References: <1567929866-7089-1-git-send-email-uri.shir@arm.com>
In-Reply-To: <1567929866-7089-1-git-send-email-uri.shir@arm.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sun, 8 Sep 2019 11:10:12 +0300
Message-ID: <CAOtvUMcAWgycg+Q5HkHpizvDsTaBX99WJtOYg2a-=dQyxqueGA@mail.gmail.com>
Subject: Re: [PATCH] crypto: ccree - enable CTS support in AES-XTS
To:     Uri Shir <uri.shir@arm.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Sep 8, 2019 at 11:04 AM Uri Shir <uri.shir@arm.com> wrote:
>
> In XTS encryption/decryption the plaintext byte size
> can be >= AES_BLOCK_SIZE. This patch enable the AES-XTS ciphertext
> stealing implementation in ccree driver.
>
> Signed-off-by: Uri Shir <uri.shir@arm.com>


Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Gilad
