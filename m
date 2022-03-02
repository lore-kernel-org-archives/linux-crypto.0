Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234D7C433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Mar 2022 21:09:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245022AbiCBVKL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Mar 2022 16:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245020AbiCBVKK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Mar 2022 16:10:10 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2457E08D
        for <linux-crypto@vger.kernel.org>; Wed,  2 Mar 2022 13:09:23 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id bk29so4742909wrb.4
        for <linux-crypto@vger.kernel.org>; Wed, 02 Mar 2022 13:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+SuWPZ2e/7zeEhPWaoi9jelX8WbYRm2ComoX27Rv4U4=;
        b=UKsy+0FXcuJ8Do65rOR9YbcsdUErJHZHS65EmTolGTe9BMmpHY619TGTyBALKgJSQV
         /i1o2tyB9QPtreYoRnIMoLZbDG5n0xaQdAS9OuAhsn8YYqeCNQXP7+VjbkJdmFP66N1B
         z8yQfrvD57bI9vn9nkGNVFzb3IJcIPmS4qZbw4d1GxTNx9FIRRuvvcp/20Bi1hUcPcXq
         1hERbZ3B8OhnuXlZidtmDufDMZ/s0ECxo6n3cVUnCFhP16ENoYDKdc0fgbCEviNgkzHa
         B1gumXaSx6XNweFhIzz6O6zFFm5tpE7+FudcurirFwo8fw6q/vXR8emE33TcuIBitk/1
         1u4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+SuWPZ2e/7zeEhPWaoi9jelX8WbYRm2ComoX27Rv4U4=;
        b=MbB3gxYXn3RpAQv7G1gwpaKvBmeBqzss29+/j2Fgo+cwFegKNmofxqtiWAzsww7Ukh
         TmFJKmQMhZLvieE50X1+i7nhxFqHQu4+DrtdWqr3RxsQ5V/qRnlNqQAlmS30hyfMz8pc
         lftwCyLZ5dTwTfSC3PN1Yeh71/Jyl9x90uxq18x0QDnmc3371pyjDOfv2S1xShVOLiKQ
         jCJggMpkVYsx9QsOMg+vY1VIMT3r5PhNppoUhNhP/v3LfnLy7T4B+KcxfFArmgi6pN1K
         Vus05LifoxraHPmZ2GLh9/JaQSefsg70wj3Z5Ew2LrQMkIhZhX+bG5Y2Mt7P6+nI2Kq7
         rY4w==
X-Gm-Message-State: AOAM530qyltQ+Cu/pzsOKJ0+lieRiogn69Q6eoP8Tl0MbMITsaM5sYiX
        +NVu4WMVC6NoTr/lbPHLTMca0A==
X-Google-Smtp-Source: ABdhPJw1KQWknFtoCAT+qBKsppNuuDAWOhAm97zko+rTSN6HXr4brTteq/LgXKaMD610Tg1naQiAlg==
X-Received: by 2002:a05:6000:50a:b0:1e3:5af:153e with SMTP id a10-20020a056000050a00b001e305af153emr24268852wrf.385.1646255362131;
        Wed, 02 Mar 2022 13:09:22 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id j27-20020adfd21b000000b001e519f3e0d0sm118605wrh.7.2022.03.02.13.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 13:09:21 -0800 (PST)
Date:   Wed, 2 Mar 2022 22:09:19 +0100
From:   LABBE Corentin <clabbe@baylibre.com>
To:     John Keeping <john@metanate.com>
Cc:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski@canonical.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH 10/16] crypto: rockchip: rework by using crypto_engine
Message-ID: <Yh/c//qzz6c20NI6@Red>
References: <20220228194037.1600509-1-clabbe@baylibre.com>
 <20220228194037.1600509-11-clabbe@baylibre.com>
 <Yh4YLGeaXAzzr+PK@donbot>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yh4YLGeaXAzzr+PK@donbot>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Tue, Mar 01, 2022 at 12:57:16PM +0000, John Keeping a écrit :
> On Mon, Feb 28, 2022 at 07:40:31PM +0000, Corentin Labbe wrote:
> > Instead of doing manual queue management, let's use the crypto/engine
> > for that.
> > In the same time, rework the requests handling to be easier to
> > understand (and fix all bugs related to them).
> > 
> > Fixes: ce0183cb6464b ("crypto: rockchip - switch to skcipher API")
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> 
> In addition to the warnings reported by the kernel test robot, this
> needs to add select CRYPTO_ENGINE to Kconfig for the Rockchip driver.
> 

Hello

Thanks for the report, I will fix this in v2

Thanks
