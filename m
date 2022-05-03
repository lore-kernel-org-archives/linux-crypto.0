Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3118C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  3 May 2022 16:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239181AbiECQOw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 May 2022 12:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239067AbiECQOv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 May 2022 12:14:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E99A91EAD4
        for <linux-crypto@vger.kernel.org>; Tue,  3 May 2022 09:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651594278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wp9YHmXDYvM0vTO+lxeqnR+ljJmF4tJFHnGldB3QeSU=;
        b=KV+iCsZrOzhbduvirDB7peZOcv31XrhO1V+6Do33dz88wlWwBi6aUr85NKYDNQ3SumWk2X
        0kYGN7b5RCD5nVeNYsL6YFroe1c8CJQZan8jFafcF2txyMlij4icweqwQdoA5quW62itd7
        9zko9at3W/cf0Ym+HlfcrKOCtOeOFNk=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-qvKtlpFoNOeptQT-4sDiRA-1; Tue, 03 May 2022 12:11:14 -0400
X-MC-Unique: qvKtlpFoNOeptQT-4sDiRA-1
Received: by mail-qt1-f197.google.com with SMTP id s26-20020a05622a1a9a00b002f3a45205d2so5182994qtc.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 May 2022 09:11:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wp9YHmXDYvM0vTO+lxeqnR+ljJmF4tJFHnGldB3QeSU=;
        b=YLwglMnfaVw2o70Eidm8qG9TfYb1zQE//XJowxyDLf3Re5fluYLUwGwihDICV3BMeZ
         CRXKaWf1kBKtNALmZ6ViJrOINy1bg/DJjul6iESdqxX0xVEybd55IwojqIcUzpmfAcZk
         kitE16jLfAJnLkqbB1zjgFEx5fS0thvSv/DN0IQrzrRNjGBM6qLqzZ2ouTXmi0E3+Pfe
         1VEnh0gJ5+mtOl5OCPop6nBggM0FlooTFONxRVL6eq4V4snN6hWFfew/qeAcDzTqYnQp
         GkADQUtSc4KJXupP2M5cTeVgCEoX/ki2xPKtnr1OZpqfmncw4oWTht+1Wd/hIbuFDbQk
         2mTA==
X-Gm-Message-State: AOAM531DIdMsapOlTWrW9oQfm8zoBU2lZFxMOrIFpEsesxuyFxL0Gwlf
        FTJOc/5j0/7Asw9XSsKRxyZgLySbrMwBDj4Qte+dA4Jb38zYM9gGuIIMwIyF37L9+IfgG2Cs5fq
        TwQEh/6elViF0x08jN5cG3Qp/
X-Received: by 2002:a05:6214:1c8a:b0:443:bc78:25ef with SMTP id ib10-20020a0562141c8a00b00443bc7825efmr14197043qvb.2.1651594273452;
        Tue, 03 May 2022 09:11:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9Rhyqa7jIDuuJrIMnnrirw3u18xc4X+9oWAePPIds5Soeh/PXfrbwcmifKRoacw+7Ubd3rA==
X-Received: by 2002:a05:6214:1c8a:b0:443:bc78:25ef with SMTP id ib10-20020a0562141c8a00b00443bc7825efmr14197011qvb.2.1651594273166;
        Tue, 03 May 2022 09:11:13 -0700 (PDT)
Received: from x1 (c-98-239-145-235.hsd1.wv.comcast.net. [98.239.145.235])
        by smtp.gmail.com with ESMTPSA id f22-20020ac84716000000b002f39b99f679sm5846102qtp.19.2022.05.03.09.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 09:11:12 -0700 (PDT)
Date:   Tue, 3 May 2022 12:11:11 -0400
From:   Brian Masney <bmasney@redhat.com>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: qcom-rng - fix infinite loop on requests not
 multiple of WORD_SZ
Message-ID: <YnFUH6nyVs8fBgED@x1>
References: <20220503115010.1750296-1-omosnace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503115010.1750296-1-omosnace@redhat.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 03, 2022 at 01:50:10PM +0200, Ondrej Mosnacek wrote:
> The commit referenced in the Fixes tag removed the 'break' from the else
> branch in qcom_rng_read(), causing an infinite loop whenever 'max' is
> not a multiple of WORD_SZ. This can be reproduced e.g. by running:
> 
>     kcapi-rng -b 67 >/dev/null
> 
> There are many ways to fix this without adding back the 'break', but
> they all seem more awkward than simply adding it back, so do just that.
> 
> Tested on a machine with Qualcomm Amberwing processor.
> 
> Fixes: a680b1832ced ("crypto: qcom-rng - ensure buffer for generate is completely filled")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>

Reviewed-by: Brian Masney <bmasney@redhat.com>

We should add '# 5.17+' to the end of the stable line.

