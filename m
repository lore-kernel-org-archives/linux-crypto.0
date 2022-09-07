Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C63E4C38145
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Sep 2022 22:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiIGW61 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Sep 2022 18:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiIGW60 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2022 18:58:26 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB719D13E
        for <linux-crypto@vger.kernel.org>; Wed,  7 Sep 2022 15:58:24 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id f131so8172774ybf.7
        for <linux-crypto@vger.kernel.org>; Wed, 07 Sep 2022 15:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ensB6iG2T4HcBnO54DOwBgrBj2kxQd/wvWtFjiwAVj4=;
        b=ec3pOZdXR+0LpVTRq9xtvqRgWhEPNWOlfQ0mKzRaG/z4seSTW55o6CxkkBbEr2JftY
         QIOxFCzbzFr6nl66WDfRjNHGAcuz2W4A7jc8DFtyjAuMJS274y+3N7RuBtFMZTSlO88S
         NNZHp9ti28xH0kvkd9oi0lKPHhFzwEETdMB1V0XC+oK0QGIiV81gIGM9dh/tRKccoFH/
         3jHFoZfu1No9YL4DeBaje9rPhu7obuP7MNTxm5c80p7NjZdt3VxFDyPAoWtPhlIMarw1
         FoKRtXClZ55xK9N7UXCKFY14lX4YixMYO/No+d+iVll5C5V2ktcRd6Aae+fx0Y6l9FUK
         Cp9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ensB6iG2T4HcBnO54DOwBgrBj2kxQd/wvWtFjiwAVj4=;
        b=W6ijUaK8oN0oO/M6nef4cIjj5gu8e2RyWTpOlrWiaoAU8uP2Frz6v7iKcQRoPXf9w+
         BWKG8F9Ym7z4mis8OJBbyxujAdhn91Bx+IxgV9ZPta+ManS5lZ1qQA7s8SeYQvo/pHET
         z2aHY94ilir/nfu/IPs2DTKu9qvQzDvjYwj+HJqXD06E4Rx/At9w0IhPWTC4nGZ/QCRp
         BlBQg8C27DR1+/Q4bkVLpNSN+zvyaEtrGXaJgYY08ily6LCOPynxa2XGn3LP4ufmro38
         Ps/S82aQyiFM4rAqs1GNEEMMZlIv9bjF2azvu+MTq8Nn15IXCSp1Bic+HTf+/bgXnhUu
         l7Tg==
X-Gm-Message-State: ACgBeo2xAy/CmzpOYCCxlVGI7RRmMZnb05xKgnKmQuBPzSfvF1VfyAas
        hXf6G7bhiChBrSC8c+YOvhmcCRYlzroAwpOjz8FB7w==
X-Google-Smtp-Source: AA6agR65qU6xB2U2255wpOaXm8Hmd9oTgqy80QJ0Bn/k9GJ5kl8p/E1l+APxsu8s42FDlwIGi/yC1fXRghpvTrC1Mho=
X-Received: by 2002:a25:b78a:0:b0:695:900e:e211 with SMTP id
 n10-20020a25b78a000000b00695900ee211mr4602285ybh.427.1662591503842; Wed, 07
 Sep 2022 15:58:23 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1662361354.git.cdleonard@gmail.com> <298e4e87ce3a822b4217b309438483959082e6bb.1662361354.git.cdleonard@gmail.com>
 <CANn89iKq4rUkCwSSD-35u+Lb8s9u-8t5bj1=aZuQ8+oYwuC-Eg@mail.gmail.com> <YxkgC1XKmCNGzk3t@gondor.apana.org.au>
In-Reply-To: <YxkgC1XKmCNGzk3t@gondor.apana.org.au>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 7 Sep 2022 15:58:12 -0700
Message-ID: <CANn89iLXsSotHWkUv4h0jCyNqym+Mb1N2-sfyC0sK76TZ+xPPg@mail.gmail.com>
Subject: Re: [PATCH v8 08/26] tcp: authopt: Disable via sysctl by default
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Leonard Crestez <cdleonard@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Salam Noureddine <noureddine@arista.com>,
        Philip Paeps <philip@trouble.is>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 7, 2022 at 3:50 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Sep 06, 2022 at 04:11:58PM -0700, Eric Dumazet wrote:
> >
> > WRITE_ONCE(sysctl_tcp_authopt, val),  or even better:
> >
> > if (val)
> >      cmpxchg(&sysctl_tcp_authopt, 0, val);
>
> What's the point of the cmpxchg? Since you're simply trying to prevent
> sysctl_tcp_authopt from going back to zero, then the if clause
> by itself is enough:
>
>         if (val)
>                 WRITE_ONCE(sysctl_tcp_authopt, val);
>

Ack.

Original patch was doing something racy, I have not though about the
most efficient way to deal with it.
