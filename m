Return-Path: <SRS0=IEBh=S6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D46C43219
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Apr 2019 07:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB20620881
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Apr 2019 07:10:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="GKPFYjuo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfD1HK6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 28 Apr 2019 03:10:58 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:42792 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbfD1HK6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Apr 2019 03:10:58 -0400
Received: by mail-ua1-f65.google.com with SMTP id h4so2533226uaj.9
        for <linux-crypto@vger.kernel.org>; Sun, 28 Apr 2019 00:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=r5eRwTKZfVVdEmjNT8x1sCtdarNdR8EkiGmNv5UodMQ=;
        b=GKPFYjuoo26gYJ5wNDY9J5RSbR1781K56iLTYnfM0fcPwH6uqo+DWUPO+Ne6s/Tht4
         tV2+VDhaFqdaMdwYqP6g3CQCHUePtiPNLH1sW9lF1JmtuP31F5fc8K60L3XfEOZmNcZR
         A1QpX2i9EiwDQhm44skY7qSK4GAaluSOVuZCDjVSXqZavUjl5sDN9OJqO3Qt3JFfiALJ
         Augj5wGAh1JqnitIekep/XP8DpVhi8bTyh/t6qXhX47qSp9cUDdYporhCeeZV7XRfIb1
         Qfy5l2mp5GtSjYnYLes7zy25l+5UHd71Tb8777UeRv0Pq313z4bE474bwW8Ix8HkKwuG
         F2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=r5eRwTKZfVVdEmjNT8x1sCtdarNdR8EkiGmNv5UodMQ=;
        b=AUppsLtRLeljbNkP3QUTcwC5kfbhpCKRYLlvEq8ATCGgX5ktbio5sXcS1TFjzzusfT
         51XA2p2CBN14KnXicJgV7vehAxWyM6YsxejyChlSTQ/gtTJ1EKWe/Df7Jmxkd0gEKNRV
         OzZSPfSmj0vyJePBmseGBHUv080LGHClVunKG4e3pgTG5ilPYxpxEaPucwQBzsK5r5fO
         g4sO4p0MSBf1tSCYEKoSGJoyHDxewz8PNfiNMIoj8xPWZTw6pTtMOu+JCA2Q78hNPGJR
         oQWnPLA4zbleUY6Xm5/sB+sBbkKpbb4fVnJIUCGra404nFoX8khDp1xF67VGIwOPtiLv
         8AHw==
X-Gm-Message-State: APjAAAWzGqFmxv55Wm5wOdCVdWBie9myCKkX2Nq9XNl2IXijxVGnv6sK
        LKNOGGttboHXa38gFpmbVfvs5Qu3PuvC1hw0vluPjg==
X-Google-Smtp-Source: APXvYqzgYHK3XIKaal8P+h3+kjrSWHq1gJ0X3ACC3FHNew6teibPWU9m1+kjOZ8QlHW7VlGvEUaN9YHkpAKzCWNO+NE=
X-Received: by 2002:ab0:340c:: with SMTP id z12mr897714uap.4.1556435457047;
 Sun, 28 Apr 2019 00:10:57 -0700 (PDT)
MIME-Version: 1.0
References: <201904260948.KwQ0CBJd%lkp@intel.com> <20190426010309.GA57833@ivb42>
In-Reply-To: <20190426010309.GA57833@ivb42>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sun, 28 Apr 2019 10:10:45 +0300
Message-ID: <CAOtvUMf4T8V2XHLnpZx_q=LKuFruYATRu-bRX=MBMLXAS26pxw@mail.gmail.com>
Subject: Re: [RFC PATCH cryptodev] crypto: cc_sec_disable can be static
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@01.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 26, 2019 at 4:03 AM kbuild test robot <lkp@intel.com> wrote:
>
>
> Fixes: f98f6e2134bd ("crypto: ccree - add support for sec disabled mode")
> Signed-off-by: kbuild test robot <lkp@intel.com>

Acked-By: Gilad Ben-Yossef <gilad@benyossef.com>

Thanks!
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
