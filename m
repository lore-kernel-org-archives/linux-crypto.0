Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C5E9C433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 28 May 2022 13:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344012AbiE1NC2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 May 2022 09:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235822AbiE1NC1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 May 2022 09:02:27 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F076BCA;
        Sat, 28 May 2022 06:02:27 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id f23-20020a7bcc17000000b003972dda143eso5966187wmh.3;
        Sat, 28 May 2022 06:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=7wy3dUyQWNogGADw4lO33z6qxHFzYWUYOjv8UwSVAP0=;
        b=ZXQjp8KHD0+l6fo+NIl29eZN8iX0cX6uE+/CQW6bgjq+D8JhDED72B2SUHCYrEbKbm
         mC8qqXJpPkNGvt8DiochAm6q4hK7J/qyq70kHGwl8upA0qgIhGP7F+gAh9aV82wu7hBc
         5FQk61eV2wXtdPP3AVc7Y0uzpE8OVDauRSrFEha9KBD2m2Oiu+5EZuNfAzV7hyEAQh5w
         dvvSSpUIYxU08qcapttqQMbxlKKImU5QEbHiLokj4Yd+QuNmveuke3G5sKwZ8Wt9ChPk
         Tm7D+0t2I+4PO4wt79R59K5XADeovPyV0yvCdaoyC22bO8g6cYDw/dDiLBV7V377fepi
         WD/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=7wy3dUyQWNogGADw4lO33z6qxHFzYWUYOjv8UwSVAP0=;
        b=ODEScRHBNFES0zuN/emtDjBGAzsrit29KpBPoTZee3P9eRVEWMhvQG2EgzKL+gcZ7a
         dq6P2NMvGDzYFUtijlHT4C9Syyg2zHXbv7uCg68lHk4TnVDQW3Gi4PXrqb/apl3jHt09
         aU9Hb0XWpIrtMHGkRJDAuFNroIC17qDD8Z8n50tDkm2q2KY8GWSz0BpbaO32uZ/bJBeq
         MHcCajVjDYQOV1gOpdKqlArWANUP8sBM6P2n3CbxeHfcMN3vH8PTtLPD7ziuh162ggz2
         CWyvbFMZJaNiK6yAswFC3FMGueUDQF2prl2g4llnf94Cd2w62qrFUoSzkvjgVWJliwQu
         99ig==
X-Gm-Message-State: AOAM533qq/jyjQCR0z7PWc5AWCVpy4MSRNU05MtCDHH0y0QP4AKZHiyQ
        UdUzR2iT+ieikgNhmIZtu9c=
X-Google-Smtp-Source: ABdhPJyzFr4UpHJ1pEfZWDzcDmbvmeMbXxoNEk26RmRrq29ebEudvaKSF8uWSnPczdaHYuaHRuhYzA==
X-Received: by 2002:a7b:c109:0:b0:397:43ef:b66f with SMTP id w9-20020a7bc109000000b0039743efb66fmr11025623wmi.44.1653742945710;
        Sat, 28 May 2022 06:02:25 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id m3-20020a5d6243000000b0020cd8f1d25csm4314343wrv.8.2022.05.28.06.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 May 2022 06:02:25 -0700 (PDT)
Date:   Sat, 28 May 2022 15:02:23 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        linux-crypto@vger.kernel.org, linux-sunxi@lists.linux.dev,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: sun8i-ss - Fix error codes for
 dma_mapping_error()
Message-ID: <YpIdX5ipcm/hMw6S@Red>
References: <YoUuAsJndw7aLn+S@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YoUuAsJndw7aLn+S@kili>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Wed, May 18, 2022 at 08:33:54PM +0300, Dan Carpenter a écrit :
> If there is a dma_mapping_error() then return negative error codes.
> Currently this code returns success.
> 
> Fixes: 801b7d572c0a ("crypto: sun8i-ss - add hmac(sha1)")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-on: sun8i-a83t-bananapi-m3

Thanks
