Return-Path: <SRS0=l+Io=37=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C60C3B187
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 18:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A6BD2086A
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Feb 2020 18:44:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cogentembedded-com.20150623.gappssmtp.com header.i=@cogentembedded-com.20150623.gappssmtp.com header.b="Peg+EZis"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729433AbgBKSoH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Feb 2020 13:44:07 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43733 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728389AbgBKSoH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Feb 2020 13:44:07 -0500
Received: by mail-lj1-f196.google.com with SMTP id a13so12760409ljm.10
        for <linux-crypto@vger.kernel.org>; Tue, 11 Feb 2020 10:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X0RiGxD598VNdYRw7xmS/5EVhHzz6Ia1q5/DbEyGlgg=;
        b=Peg+EZisEXYABEG3l5R11Ckp1h2TIHD5m5gaWrN4FTdFU/HM704QIQjWyBCW+sKJHm
         TBwrHBxnRi9ykqRhuz6fggtR+GToy1ZdOYJGJ6EiqCUOwXPQ4HxQrOMw58KHNljyfUW0
         OX2DGoRuPaL6yR99d8kVppOVrDyjnE0berQWpLdhSb0K1BZymPluwhOiAvd8KJfy9QNw
         mDZiL8svakmQsQsrVsYVxJtMT2u7Ek6+ZXBPXqy1e7tkXG+yHtUyWterKNF6tUmj11xz
         KARQ4strqt7f56f+/CQuK1Ms/VdxyEA3KzU8eKUxmBgaKcM/kEHF6ABRMmJ4fo7s8Pht
         7w0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=X0RiGxD598VNdYRw7xmS/5EVhHzz6Ia1q5/DbEyGlgg=;
        b=l1UrKoaBxv7U2e4Urv2gaCwDLetN/800u6ryleCSMPdWmBEuodxfo2w9uA1Zal+qT2
         z9YrvbAs7zhcWrIyHFd6IVgXWzRgMgQdDiAoGTWHNJDntLRZsaHmqauZaG2/x3+vXpyc
         rrCecthxOSdnkC6nRmrxc+LDYpOYPjM4qSVTBXENqdhvHObFfvKJKry3QQQsQxQDXPlg
         y+NjF0UOPE3Y6b2vkelveFStLxluOXZJrIssynIcVUGx3Cnb4V4NXpon0eMLxI2VXznd
         MrOIKneX1FrANkTd0sQk88+E6SHFqk3aNZrY8G9rLBXE/Y3CZPTTzdtg9e+MYLny4dJI
         Jb6w==
X-Gm-Message-State: APjAAAXgP83QgUQJ8m5gaIzKhxpM2nBiXR1NXYCpsrr74vnELxhpGS4M
        JHDDs13H1yGS/mpE81HI/IOafw==
X-Google-Smtp-Source: APXvYqw/C3WPKtObJplZ3qp0y3V2KAttt0bItnHGRKkAJLc0CGkZu91ZarSc4OfnExn5g7Nl1yxJGg==
X-Received: by 2002:a2e:96c6:: with SMTP id d6mr5173671ljj.4.1581446645116;
        Tue, 11 Feb 2020 10:44:05 -0800 (PST)
Received: from wasted.cogentembedded.com ([2a00:1fa0:42b3:6bcd:dba3:6f3d:48fb:be1c])
        by smtp.gmail.com with ESMTPSA id n8sm1937902lfi.83.2020.02.11.10.44.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Feb 2020 10:44:04 -0800 (PST)
Subject: Re: [PATCH v2 23/34] crypto: ccree - remove bogus kerneldoc markers
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        linux-crypto@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200211181928.15178-1-geert+renesas@glider.be>
 <20200211181928.15178-24-geert+renesas@glider.be>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <9e74ef25-90d9-0340-4e5f-07ff4d8c3fa3@cogentembedded.com>
Date:   Tue, 11 Feb 2020 21:44:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20200211181928.15178-24-geert+renesas@glider.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello!

On 02/11/2020 09:19 PM, Geert Uytterhoeven wrote:

> Normal comments should start with "/*".
> "/**" is reserver for kerneldoc.

   Reserved for kernel-doc, perhaps?

> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
[...]

MBR, Sergei

