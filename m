Return-Path: <SRS0=WMWG=SX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC67C10F14
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Apr 2019 08:53:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A7BE20869
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Apr 2019 08:53:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="fFqyKpzb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfDUIxJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Apr 2019 04:53:09 -0400
Received: from mail-vk1-f193.google.com ([209.85.221.193]:39927 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfDUIxH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Apr 2019 04:53:07 -0400
Received: by mail-vk1-f193.google.com with SMTP id s80so1868410vke.6
        for <linux-crypto@vger.kernel.org>; Sun, 21 Apr 2019 01:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s5xsQP5YDYBwGU8VWSjBz2cdQ5Q4j8dwF4B79apg5Bk=;
        b=fFqyKpzbtecgfXBNXuEb0oeonAMt58AZESh+i62CU4pkkEGx6TBx3GRpp6cZBc0OUK
         vEQvrzX8uSb25HwLbttE4RYKH2aJQyGgWxsnnS6hiLcGAnBbHmfH/uQYiUoxjeZh2I2Y
         c01UBoCMnapd9xgxzRSWd89Fjks4hDM8Id+tIumWPTQQAeox0w7UJZ1kA7yHbbBSCLHK
         P77VWGhnPpZeV6vVBiCkLNGRt1K+zPskvYHhk9oHfVUbAUPToRuc3bGG7jvBLxjqCA0D
         Z2YaZtbA7OfKxqJXGtuykV/jVEWaQImQHOIGQ7EfCstUtHm7UqX/FUoPj8WEivrkygoi
         Mfuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s5xsQP5YDYBwGU8VWSjBz2cdQ5Q4j8dwF4B79apg5Bk=;
        b=tPXX2xoaxOlFiF7J74OwgniWKWAc6BZu/KAJzYg9O4q7RS8vS+a2LEDEmrsuT1WZbn
         o56SayaLlV5w0zZUyzcsgYTQQXZwpZ4eVVhQielpsuEasi7A6d0y4fVWdtbjGJE4LBX5
         WbDk4ZnGOO5Xll30Up5PknMkovFoxijkdwYW2uKYzVmtBDDJxbXTYcuVs9TW7T6NUMZG
         mHEM0ugpeygh6MrGsVWlcCiWEuGJyvOxl3z3xlKpQUswdzfOmaR3Aof6xIkfXCdPIe0j
         me6In2Yk2brhopEuEgfuNeZhJoh5YIxsQGNGRJf+d55wdCb1E0LHW0Yygww9Il/45HFL
         muTA==
X-Gm-Message-State: APjAAAWEteXjeHRPgx7IQ5Zbve1B5VUAyMreNV4C8vdIFgMizPLV2hUs
        Drr+sI6eBRkYQSXHvW7JWNBUlen3OFXq4Gvm3eRPWebOe1k=
X-Google-Smtp-Source: APXvYqzKoK6CMvekcxpOoPWY8ueuYi+b7e0zX22woSC0b92n1wLmh71pSCoS74UtPi3Cd4x9VHS+9MjqvPWuoSgx10w=
X-Received: by 2002:a1f:97ce:: with SMTP id z197mr6745383vkd.58.1555836785792;
 Sun, 21 Apr 2019 01:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190418133913.9122-1-gilad@benyossef.com>
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sun, 21 Apr 2019 11:52:55 +0300
Message-ID: <CAOtvUMd9WUZAFgTqVH0U2ZZp8bbHXNg9Ae_ZFvGKJTSKNct8JA@mail.gmail.com>
Subject: Re: [PATCH 00/35] crypto: ccree: features and bug fixes for 5.2
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Cc:     Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 18, 2019 at 4:39 PM Gilad Ben-Yossef <gilad@benyossef.com> wrot=
e:
>
> A set of new features, mostly support for CryptoCell 713
> features including protected keys, security disable mode and
> new HW revision indetification interface alongside many bug fixes.

FYI,

A port of those patches from this patch series which have been marked
for stable is available at
https://github.com/gby/linux/tree/4.19-ccree

Gilad
--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
