Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2853ECAAA3
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Aug 2022 12:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245361AbiHZMqh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Aug 2022 08:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240616AbiHZMqg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2022 08:46:36 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D4CC0E7D
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2022 05:46:33 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id k18-20020a05600c0b5200b003a5dab49d0bso781742wmr.3
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2022 05:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=K5ruSlY1jCvxqbhtszXYEzO5axSbMBdWGm1jX5xAIDI=;
        b=YDhK5SvJSWefqjsU2WPYj++ObRCDvVYTmwFRnA9yR2lyyCR/tnH5aDqVujU6uS9zMX
         m1qcVILMZ8TblSKP0hyA1JtbrsrYTDSiBDgAB+03OxNYGbKOB6vknSaDxKmoJYo+y2Hk
         kpoqO3qwq4EgS09hnQpN38xfu3gFTSWN36g0IIjZ+xTwjw/OufrYn+NWqzg0GXErZpNd
         jpi0BqbNCvTEvyMD0zA0+kc3Dp0wKrkpqOPEO53z6tdwdb9Ye15gXk/MMB8rPnIb8FHY
         ioOE6r+ywIRMauqPNdeG7rokoPe8SdXkGsFYRZ/QBF2powrJpXM5o+51PGzFQ4+MhrGN
         jyFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=K5ruSlY1jCvxqbhtszXYEzO5axSbMBdWGm1jX5xAIDI=;
        b=lksh38AA6aiLnh8ctwA0OHRq+lASUvwR3lE5X8dpmPxDKH7tfJMIZtDE52M3EgcfoL
         OtfPf6lob1bXTg5kHLWxOPHs72ZYmPU18SsWztzD6IaVdwv0EUQu4ukUBYjb9MOUTWsK
         S8JECJNrfeAFJtTiNKToWMzxYlg4obu9n7frgJXnwB1PzhPIpS9saMgmSP5nsv+yr7r7
         JY0kfDBEzhOhc/7wKhCJZPrn4akeAE2hPCD7PrUfKikD8BaoGtSKzxgIgnEUvQAOoDfQ
         xB5uDU9Ngf4SQVROpk70Kp8owa0v3Aygxia2UfMdMRF42XXLMcMrSlWHzsyV2vyEGsyO
         87dg==
X-Gm-Message-State: ACgBeo19QRVcMw1ZvEGZou+7xsPAPlcLO40mq55Ylo4+bHsPj8IHmZCd
        UE0M562lstCIAPrSO3jCNEgpSA==
X-Google-Smtp-Source: AA6agR47p7+yUpwUH50t0SfB9kxiuFa+blrP6f9OaGblbuFJRK+GbTrAG/eZi4Vsn8YmOBmdlLEnKA==
X-Received: by 2002:a05:600c:22c8:b0:3a5:c134:1f50 with SMTP id 8-20020a05600c22c800b003a5c1341f50mr11466896wmg.55.1661517992442;
        Fri, 26 Aug 2022 05:46:32 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id b3-20020a5d4d83000000b0020fff0ea0a3sm1768406wru.116.2022.08.26.05.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 05:46:31 -0700 (PDT)
Date:   Fri, 26 Aug 2022 14:46:30 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Jack Wang <jinpu.wang@ionos.com>
Cc:     linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org
Subject: Re: [PATCH v1 10/19] crypto: amlogic: Fix dma_map_sg error check
Message-ID: <YwjApjRZis69PI0S@Red>
References: <20220819060801.10443-1-jinpu.wang@ionos.com>
 <20220819060801.10443-11-jinpu.wang@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220819060801.10443-11-jinpu.wang@ionos.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Fri, Aug 19, 2022 at 08:07:52AM +0200, Jack Wang a écrit :
> dma_map_sg return 0 on error.
> 
> Cc: Corentin Labbe <clabbe@baylibre.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-amlogic@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> 
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/crypto/amlogic/amlogic-gxl-cipher.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 


Hello

Tested-by: Corentin Labbe <clabbe@baylibre.com>
Acked-by: Corentin Labbe <clabbe@baylibre.com>

Thanks
Regards
