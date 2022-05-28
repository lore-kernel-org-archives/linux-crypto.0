Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A8D1C433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 28 May 2022 13:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350029AbiE1NAs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 May 2022 09:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344012AbiE1NAr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 May 2022 09:00:47 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4C0C2A;
        Sat, 28 May 2022 06:00:45 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id h189-20020a1c21c6000000b0039aa4d054e2so76164wmh.1;
        Sat, 28 May 2022 06:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=VWS0F56t0fOBh5xypCh8zjIFc6hxsrgivcZl7H9F6LA=;
        b=PrzcA+325+sgBUeqcHDmn4L7QnwPAbf1zUi8X9B3wbQZJnC2E/vNpDjRj9yQ2+/M6X
         hVZA9Y+2MxJCv7KC1+xrDmknqCIqW3gJtSRZAS2Qzec2WmmQD8x50tHxowFpb3Etn4ba
         Zj+s/97+ZBQSoRMH7FZzNJG8PVPcI8aqEhiY+P3fLEeKV0cIcMmSLFNcTrzos88B0AY4
         0eZyGiZM/sva55q2UjkvlcIQIfZNO5ODCZZJrDhmOuv8TwX3rUlmzk8FE3H4Pc+RdzFb
         TuodlU/HaWAatNwwByVVIk8+jlDlvpwJ6CUK0JUIkasUQ5iMnHAdNhtriE7gJFy79oiv
         Zrvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=VWS0F56t0fOBh5xypCh8zjIFc6hxsrgivcZl7H9F6LA=;
        b=vpcTU1m/Nwi4DfC/YqL6orMs+eBc0ojz3vf2gkUrF9aMwdycjO5IZPowpK0ZziF4LJ
         w41vCAmfakIfb5sP7c050EFWT8wkJqvEHsOVtH4EucvTnMdEt1GpksTRhWeWT4TyfAa4
         DvSKpCMGeFejyWwTwP6Q70VmasxViNn58dPKnlc8IvaSc7OJv/lyEyTmzYSQ+oUD2Eyo
         gXjxQLzqZrQBGMfGJ1vxsB5vgm0dID819f/rfnohlCeJwpNNFFqejZevBOdxCZI9pIjb
         oUIRE+WuwAS4Mix5c9SCjBw2WwPPDYt1hi3U57ZPdy6Rae3iFhHL1ZnU49jXkxTu4YMc
         as5w==
X-Gm-Message-State: AOAM532XVFTcWfF54dO+70/LJNxx0vbWnMvhrsw9N8LGi/DLOf1DtlfW
        AZw923bOMZiV2F2sH4u6S7c+xjgqrws=
X-Google-Smtp-Source: ABdhPJzO+5nhwDzTELUOeEMSSdR1F7EwBlN2PhikUDajX3eKDowkhtLyBlk+UYucTI1HfWnQh0SAZA==
X-Received: by 2002:a7b:c4d0:0:b0:397:4636:6bc1 with SMTP id g16-20020a7bc4d0000000b0039746366bc1mr11065865wmk.48.1653742844347;
        Sat, 28 May 2022 06:00:44 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id bw30-20020a0560001f9e00b0020ffa2799f4sm4045530wrb.73.2022.05.28.06.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 May 2022 06:00:44 -0700 (PDT)
Date:   Sat, 28 May 2022 15:00:40 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        linux-crypto@vger.kernel.org, linux-sunxi@lists.linux.dev,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: sun8i-ss - fix error codes in allocate_flows()
Message-ID: <YpIc+FtQIOdm9Ub+@Red>
References: <YoUt+LNsM8qFZYgL@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YoUt+LNsM8qFZYgL@kili>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Wed, May 18, 2022 at 08:33:44PM +0300, Dan Carpenter a écrit :
> These failure paths should return -ENOMEM.  Currently they return
> success.
> 
> Fixes: 359e893e8af4 ("crypto: sun8i-ss - rework handling of IV")
> Fixes: 8eec4563f152 ("crypto: sun8i-ss - do not allocate memory when handling hash requests")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-on: sun8i-a83t-bananapi-m3

Thanks
