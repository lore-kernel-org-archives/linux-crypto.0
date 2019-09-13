Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB2AC4CEC5
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 08:16:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2511F2186A
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 08:16:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PfaFgpOc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387432AbfIMIQB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 04:16:01 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33162 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387398AbfIMIQA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 04:16:00 -0400
Received: by mail-wm1-f67.google.com with SMTP id r17so1273610wme.0;
        Fri, 13 Sep 2019 01:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZegFrMDjH93Hiq0kHvBQhWYD8nMzTsPX5Ki5O2UQQBw=;
        b=PfaFgpOc/mwAvCtHhBsRPA+6Ol+RiRcKVXOGMihUGWWyCWsA1+I6o1qgk/PiSHh6RE
         Ju2GeDAIOlYZa17BJLlN4iW/K68eE6FP1Nf0e0W/AZI9JbmYGaVuTRWXtLRFa4vKcS+I
         QRD5WdlC18keKleZAijwxzfB6JEDtrXoUkD9/c3Tw5LCv+d7LKNswrSDmwCdtEKsODVv
         Zjkcg3sA7er7sa/oskcEj5JGpFQcUH97a4jskF38uGmg9zU9iJ0870v7jd+mz9DpF2+c
         IRoUhaE/7y0FaQf/ZJrozuXnNE5yE+sUMDKs8x2nBWRlP8nNIEvyiy27n1Bwq/lBBPff
         2Uww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZegFrMDjH93Hiq0kHvBQhWYD8nMzTsPX5Ki5O2UQQBw=;
        b=tZIuyRXP9sTpdMnBatjJLTqfmdDcpRSdPAAEcx7zU+8zVjveBKQJxx4A107oXnVfTI
         IeWsBKmnmGih4BGvbRl4V37x6d8Iw0/dMvPXnTBa2EWgMf9X2u2N5OQ4o1vhSdcTunTe
         Wb2+ReZc7rg50gtawpG5l8nOjGesnn/k77wBdXKfQWumTGH/YsEV8ZvEpVxh0XkHlUzl
         RUlNUJteQxKcJyXD0Au9QDgNuuXgZNTpNA/uMELEeStfSJXnHSn/BgkYNbk0HmzaqSgy
         mI1gcIFC0hjX1lssAeDZrYmhU2XOwbIuIisOlAby5ead/ipZ/nwKv9Xp7txQQ2VXzrLj
         K0vg==
X-Gm-Message-State: APjAAAXwNjVMYISarMiPalpOPW6dDnxj3FBFCUeVFumNs3uLBEXByONW
        oONx7MWJZL/ZFXXya125Eb0=
X-Google-Smtp-Source: APXvYqzPD1KCCVP4u+I/AiOqS7VPDqe6WMu/bSWxf0dd5zj8hnFNJt6HCrlNrBbEx+fA2Bvtt9hzFw==
X-Received: by 2002:a7b:c045:: with SMTP id u5mr2263014wmc.139.1568362558329;
        Fri, 13 Sep 2019 01:15:58 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id q25sm1546037wmj.22.2019.09.13.01.15.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 01:15:57 -0700 (PDT)
Date:   Fri, 13 Sep 2019 10:15:55 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Maxime Ripard <mripard@kernel.org>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux@armlinux.org.uk, mark.rutland@arm.com, robh+dt@kernel.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 9/9] sunxi_defconfig: add new crypto options
Message-ID: <20190913081555.GA22538@Red>
References: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
 <20190906184551.17858-10-clabbe.montjoie@gmail.com>
 <20190907040353.hrz7gmqgzpfpo4xj@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190907040353.hrz7gmqgzpfpo4xj@flea>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Sep 07, 2019 at 07:03:53AM +0300, Maxime Ripard wrote:
> On Fri, Sep 06, 2019 at 08:45:51PM +0200, Corentin Labbe wrote:
> > This patch adds the new allwinner crypto configs to sunxi_defconfig
> >
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > ---
> >  arch/arm/configs/sunxi_defconfig | 2 ++
> >  1 file changed, 2 insertions(+)
> 
> Can you also enable it in arm64's defconfig as a module?
> 

Does you prefer adding a Kconfig "DEFAULT m if ARCH_SUNXI" which permit to not touch any defconfig ?
