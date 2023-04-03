Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3765C76196
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Apr 2023 14:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbjDCOyu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Apr 2023 10:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbjDCOyn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Apr 2023 10:54:43 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B18D1206A
        for <linux-crypto@vger.kernel.org>; Mon,  3 Apr 2023 07:54:21 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id m6-20020a05600c3b0600b003ee6e324b19so18310150wms.1
        for <linux-crypto@vger.kernel.org>; Mon, 03 Apr 2023 07:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112; t=1680533656;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zQ+D+rvKejqeMnWp70EKl6CxPWKKv8D5XFmi8cEhbpo=;
        b=19sjDoEWHn3qr/r+4w4MBgaavARXaINMpW7n0PSpX7v+T4dvwGSdoVh/HKyRReHWTm
         TMAo9mIPCOXH563paV8996QHd7zwtIZetRxP5j4CZLmhykrWSxEPWJ6sizuFUsLf3ox+
         M5JA+htRsFp4IFKV3XhlKH/u9xn+ywEhSY4PQ7mtpViYCU63l2XeVYgSuzHSXG4vgW2j
         /kvVVs0NMt64gqVpmpCNxJREDdMTyg7myayfYJCLWSJ9eXCfYQ2/HGHC+bh7WBiyflk5
         k1oqBHMT1BSJLU5UeR329Dai44m2FR8GEcubaPvs+iasGQYm4WDmbxuF3eWxo15T7sGA
         K88g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680533656;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zQ+D+rvKejqeMnWp70EKl6CxPWKKv8D5XFmi8cEhbpo=;
        b=C7Xy6RQT2jgj2EJ+ESbcvaU3nUo6I7ThKDHqUeFt2o0Do6edTMLgprLc3nNSUO5F0F
         IZaUnM8wLnSmXtRW6SiSnAkKkneZrNEEbb9XWnjofYA1VIzyUYmhk+d/2IEqEzXfC8Do
         m5jhHzfSM0DMttPOM7IbpJ0wHpa573wPJA9dTp+Wnn2cI1id1b50xXkIpPs+ya2G1liZ
         YkV4VZ+mvo5UOOY39i0cgS1VT9cyegc1WHgrPEy9RaZLAEUkegzhKBjqeAA6wX0nV3WA
         xA+0XdOw4D6vZuJjc5jT2RVIuip6lttBfo7xBqqFIXXO88+4/Yh0D+8q8uKVV1kq+cv1
         j4Pw==
X-Gm-Message-State: AAQBX9ex/u5J0MfeXYdrK3Ojr+RpbbSIwo55Pd/p9J7Mz3zVEuAUMKOR
        4XhX+yHYjOBQMPniYMP5HXAL74xzdXbf1v9CZHQ=
X-Google-Smtp-Source: AKy350YV721bPoxlptQMY+4EjEdRARLIo8tlWdaWA0MzyriXcpeXXrhtsduVC2tjei0esd0t3OUJPw==
X-Received: by 2002:a1c:c913:0:b0:3ef:acf6:f815 with SMTP id f19-20020a1cc913000000b003efacf6f815mr14033935wmb.32.1680533656505;
        Mon, 03 Apr 2023 07:54:16 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id u21-20020a05600c00d500b003ee4e99a8f6sm12299588wmm.33.2023.04.03.07.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 07:54:16 -0700 (PDT)
Date:   Mon, 3 Apr 2023 16:54:14 +0200
From:   Corentin LABBE <clabbe@baylibre.com>
To:     Tom Zanussi <tom.zanussi@linux.intel.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        fenghua.yu@intel.com, vkoul@kernel.org, dave.jiang@intel.com,
        tony.luck@intel.com, wajdi.k.feghali@intel.com,
        james.guilford@intel.com, kanchana.p.sridhar@intel.com,
        giovanni.cabiddu@intel.com, daniele.alessandrelli@intel.com,
        prabhjot.khurana@intel.com, mgross@linux.intel.com,
        declan.murphy@intel.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH 2/3] crypto: ixp4xx - Move driver to
 drivers/crypto/intel/ixp4xx
Message-ID: <ZCroljP+zzGVigFi@Red>
References: <20230328153951.126564-1-tom.zanussi@linux.intel.com>
 <20230328153951.126564-3-tom.zanussi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230328153951.126564-3-tom.zanussi@linux.intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Tue, Mar 28, 2023 at 10:39:50AM -0500, Tom Zanussi a écrit :
> With the growing number of Intel crypto drivers, it makes sense to
> group them all into a single drivers/crypto/intel/ directory.
> 
> Create a separate drivers/crypto/intel/ixp4xx directory and move
> drivers/crypto/ixp4xx_crypto.c to it, along with a new Kconfig and
> Makefile to contain the config and make bits.
> 
> Also add a COMPILE_TEST dependency to CRYPTO_DEV_IXP4XX so it can be
> more easily compile-tested.
> 
> Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>

Acked-by: Corentin LABBE <clabbe@baylibre.com>

Thanks
