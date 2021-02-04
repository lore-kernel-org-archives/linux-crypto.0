Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A67DC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 18:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0668664F10
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 18:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239390AbhBDS4U (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 13:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239305AbhBDSzw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 13:55:52 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349C4C0613D6
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 10:55:12 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id a1so4807558wrq.6
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 10:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Z5lY9EzY3p+tNc4fTZ1yzC/M13ykEyZmAgfqdRyvqls=;
        b=QqYJbWMrWsBlPFxWsCq0CbRDCvrcGl79aEqxSyQ1jKdOl4NRz8QU/H6DDQA90dDqh3
         Rq7BNP+DV36q6uNft0NoUesCNmE9T7QJbGA8agou897MPhg0awcbrJP4/sia/y2ALZEu
         ZMHL3hRtPdpO5e3op7CWmKq1OCqUWLs1p/Znt9M4Wg0ScGXsRgQoOYcp41GMsuKBQkla
         3BQZQvGgi1afpIvGY4MBlknZsqu/w/xACPkHiXFcb9f30RQSVIYJskKMgPMowjkCgFM8
         jNdK4PPruyK0aIaqbHM5MZowM7qP89hDwQpz4xaLDsgGTBdJ+oZx78wgGUke9zES/P2r
         F1ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Z5lY9EzY3p+tNc4fTZ1yzC/M13ykEyZmAgfqdRyvqls=;
        b=S/M8jHQnkaE5cjVyLGItIVRR0YjrWn1CprCp4UD8ERoL6Z+hHyEnFRcfRbw+g1N0uR
         nR22fACxN3LFHPC+CLisQk/g+KZ8XMlSpyRaWCA1L2zLS9m2KA1xQGP4+D/cxBDuuyHW
         NXwkhnYM1EyiJtN0qqalbcZgtmpGiiouvwXlLtKjxbfElXPK7QYP4TWt2gn0xr+yL/hN
         YvzKplLcEIm5w61aXR7ZgKEBbvxz4wrpL2l2D/UcKcvMCDYfCf6AaLI5cQBy1aJS8EX2
         9OQjKQ6kVYolVKVE4SL4MfJpnJfinOq0QcHZuyZVLxDLX+Atiy0ptXOFaXMVn9rUpUEh
         7vxQ==
X-Gm-Message-State: AOAM532rCU87dNcdDopAVum78dxvM6x5bLomPHbxPifDd9+HSGtQpQUN
        QxVknaxD4zuJeny2XbHg/hexLA==
X-Google-Smtp-Source: ABdhPJz0W8AtuWvK0NhRHzIgRg1okHD57QcG/E/zOoy/cUJzrM9giNm9DorwZAdlMJ4QhXI6l3b+/w==
X-Received: by 2002:adf:b749:: with SMTP id n9mr784310wre.267.1612464911015;
        Thu, 04 Feb 2021 10:55:11 -0800 (PST)
Received: from dell ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id w25sm7135203wmc.42.2021.02.04.10.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 10:55:10 -0800 (PST)
Date:   Thu, 4 Feb 2021 18:55:08 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Murphy, Declan" <declan.murphy@intel.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 06/20] crypto: keembay: ocs-hcu: Fix incorrectly named
 functions/structs
Message-ID: <20210204185508.GQ2789116@dell>
References: <20210204111000.2800436-1-lee.jones@linaro.org>
 <20210204111000.2800436-7-lee.jones@linaro.org>
 <b8425f8b292e0ca268a2f575e9053ed408bc4c6e.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8425f8b292e0ca268a2f575e9053ed408bc4c6e.camel@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 04 Feb 2021, Alessandrelli, Daniele wrote:

> On Thu, 2021-02-04 at 11:09 +0000, Lee Jones wrote:
> > Fixes the following W=1 kernel build warning(s):
> > 
> >  drivers/crypto/keembay/ocs-hcu.c:107: warning: expecting prototype for struct ocs_hcu_dma_list. Prototype was for struct ocs_hcu_dma_entry instead
> >  drivers/crypto/keembay/ocs-hcu.c:127: warning: expecting prototype for struct ocs_dma_list. Prototype was for struct ocs_hcu_dma_list instead
> >  drivers/crypto/keembay/ocs-hcu.c:610: warning: expecting prototype for ocs_hcu_digest(). Prototype was for ocs_hcu_hash_update() instead
> >  drivers/crypto/keembay/ocs-hcu.c:648: warning: expecting prototype for ocs_hcu_hash_final(). Prototype was for ocs_hcu_hash_finup() instead
> > 
> > Cc: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
> > Cc: Declan Murphy <declan.murphy@intel.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: linux-crypto@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> 
> Acked-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
> 
> 
> Thanks for fixing these.
> 
> For some reason, if the issues are there, I don't get those warnings
> when compiling with W=1; the command I run is:
> 
>    make CROSS_COMPILE=<arm-compiler> ARCH=arm64 -j5 W=4 M=drivers/crypto/keembay

Not sure what would happen with 'W=4'.

Probably nothing, as it only goes up to 3 [0].

> Which command are you running exactly? I'll use it for my next
> submissions.

 rm -rf ../builds/build-arm64/drivers/crypto/
 make -f Makefile -j24 --quiet ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- KBUILD_OUTPUT=../builds/build-arm64 allmodconfig
 make -f Makefile -j24 --quiet ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- KBUILD_OUTPUT=../builds/build-arm64  W=1 drivers/crypto/

Hope that helps.

[0] scripts/Makefile.extrawarn

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
