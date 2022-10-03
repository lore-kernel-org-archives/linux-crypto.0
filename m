Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD4DFC433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Oct 2022 11:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiJCLSS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Oct 2022 07:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJCLSS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Oct 2022 07:18:18 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5C040BD7
        for <linux-crypto@vger.kernel.org>; Mon,  3 Oct 2022 04:18:17 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id w18so7476940wro.7
        for <linux-crypto@vger.kernel.org>; Mon, 03 Oct 2022 04:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=zUqA9dEEEJ7hEJcQLWCwrav5hCDSb2JcPcZFlYmYDaQ=;
        b=S45W3iOGRh/R0OtZRvge6cpIOwMboA34XKFCtdz1lfKjgbu0mtL7axvYSTwDA+cysk
         67K4US2o/sJ4TmfcgtUaJ6JGWpJ9fu+g4g1zJtpKLroibXsrAQPW7F1Irqi0VHWf4xWM
         qsNvt4q0CrFtr/WzYMqUx21Wd4X0JekDOP/ZqsstmddiD8UMyUIaoWhFgFJfKqHZzrDv
         KwspYPMprcz9oRPEsDshKKIpS+fmVOc1CwozrbvwQfMzIJbSJVA3e00MHuO5vdwsdqfO
         dnaNgIiyJW1ueN7MNDICl/0qIWtEOtOtCRBtTqtLuMAlVPU2A8Mmh2t2bw3nur5mpnze
         uCVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=zUqA9dEEEJ7hEJcQLWCwrav5hCDSb2JcPcZFlYmYDaQ=;
        b=uNsaQZgfOXwmBpQSuOJDbx8wvCsiZ/bjj+8NpWBaHEuwRpPA/U3K8g/3ut6X4cbbfI
         6jvzBTuSQ4ry3yBR3uFz42z8nLPLkw+4uEriho+2NdKBMr4QnyuE93c+MbHV2MEmQWXj
         geOidNiKvk+MdRf+iC+nXJ61qmNzztfoiPYtdpokSVzLxvKvaYxzTLOJGQUmHgj+4s9z
         u+dOCL5Km6sGZGQqGvoFzGX4u0wYBfs5YgN8dEXfu5TLhuOmQ6ILq4ZR90q+QUwYXxGr
         b1ysnqiKwJgZDSzatEikNfyRu9bjqCSOKUCwXS4iFjU9j0diotRXdZ+kKiGygzUsHwKz
         SQQg==
X-Gm-Message-State: ACrzQf0n/DMEIuC85qSwNIIXLJd1wDOYHBrhbpetV/UYlm3uxIAyWuOT
        wmfBPECu83AwZzIT2j4lWlM=
X-Google-Smtp-Source: AMsMyM6V7No0uuqvh9S0QJhdc3X7w4j/ujTqHz923EBf1gxXy1oBv415KE07SiPs/pM91yX6ZTkmzQ==
X-Received: by 2002:a05:6000:982:b0:229:79e5:6a96 with SMTP id by2-20020a056000098200b0022979e56a96mr12450056wrb.469.1664795895651;
        Mon, 03 Oct 2022 04:18:15 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id x12-20020a05600c2d0c00b003b51369fbbbsm16550909wmf.4.2022.10.03.04.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 04:18:15 -0700 (PDT)
Date:   Mon, 3 Oct 2022 13:18:11 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linus Walleij <linusw@kernel.org>,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>
Subject: Re: crypto: ixp4xx - Fix sparse warnings
Message-ID: <YzrE82pApo21c8tj@Red>
References: <YzaIHqpGR60bQMt0@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YzaIHqpGR60bQMt0@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Fri, Sep 30, 2022 at 02:09:34PM +0800, Herbert Xu a écrit :
> This fixes a number of trivial sparse warnings in ixp4xx.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 

Hello

Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-on: intel-ixp42x-welltech-epbx100

Thanks
