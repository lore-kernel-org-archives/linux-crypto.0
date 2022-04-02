Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F98C433F5
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Apr 2022 20:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243739AbiDBUGL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Apr 2022 16:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348174AbiDBUGK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Apr 2022 16:06:10 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0CE3EB8C
        for <linux-crypto@vger.kernel.org>; Sat,  2 Apr 2022 13:04:16 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id v64-20020a1cac43000000b0038cfd1b3a6dso5380179wme.5
        for <linux-crypto@vger.kernel.org>; Sat, 02 Apr 2022 13:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=yQeqwIeqI5CMAgG8hDfKbZn0Debf8w0vr8QNNYkJmUI=;
        b=rg468YkTGw4qq+7BTqNb+9e2AW7798nZyQsEw7APtpHfEScIn4mAxPp40epSJ/DqqM
         FW1ukFdIVMS8churmP06RZyQPTzPyQdeidOkNAX+hpVRYnSNHIas4ePrAYUdilNlEtP6
         yhnuvRTNyZSAysfMJPll2xZUF3wAuxL6zspWSXz5gwdt66ugNBr5eNsZNqbFT3zYWfIS
         xF11MED8ko9Bbk+x/u3f9nXO5nIl3PYMXVFAdWugobCvQR8MjCmx7qd9kQCp38gnhfrO
         fC+b2Ptuhb93WvKGvSwgJ6rFJy4o9pM7VSVPTbWuBDCRyrqbelhElQJYJEsZnujnWVO5
         McYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=yQeqwIeqI5CMAgG8hDfKbZn0Debf8w0vr8QNNYkJmUI=;
        b=ZZ3eL489ZGVChITxbVW/svWscxrq4YrXwGQylHDeqquvxXIDtb2E/cDIluF0d8a4WP
         uPjvwa+0Rl1y3fp+Ms0WPLHiDDYhU40pK75DUkaV8jAK2Frddui6rchI34CH8TPrEH5M
         NFNHQ7+kCffFt355KwEU7wIQQxPT/Km1XVm9GDaFQ57053iE0TyaBu6s13AUY4Bsrlc6
         rG4RS8UVyZ5VNpCzXAdDP1QxX90Dgt0D42RAqzxho5QXM8rzypEUbVPsPc3LC8RgPUMv
         Wyf+ObLBoK+i6kWKle57zvOfcaKnP2DUgnwgd/SiLZinf3FC99A02t0OhuK9VzrJeKn9
         TqQw==
X-Gm-Message-State: AOAM5324lmQAy/Lt+W6NmU5Lgdnb75w8VJzymOJ8fzLJImqMuPIiYfdi
        MroJibjUziesMGsVAKy4/k5WGQ==
X-Google-Smtp-Source: ABdhPJy6NaiDP7v3t/VgL9bpERiXPtZ6xlytZQf5riyEAwmfhgWKXXpEcvulkX/plHpsKoVk6W8Z4A==
X-Received: by 2002:a05:600c:5029:b0:38c:9768:b4c with SMTP id n41-20020a05600c502900b0038c97680b4cmr13117148wmr.123.1648929854661;
        Sat, 02 Apr 2022 13:04:14 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id h10-20020a05600c144a00b0038ccc75a6adsm13008386wmi.37.2022.04.02.13.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Apr 2022 13:04:13 -0700 (PDT)
Date:   Sat, 2 Apr 2022 22:04:11 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     kernel test robot <lkp@intel.com>
Cc:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        robh+dt@kernel.org, llvm@lists.linux.dev, kbuild-all@lists.01.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v4 10/33] crypto: rockchip: rework by using crypto_engine
Message-ID: <YkisOxklZgCejfad@Red>
References: <20220401201804.2867154-11-clabbe@baylibre.com>
 <202204021634.IhyHrjoT-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202204021634.IhyHrjoT-lkp@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Sat, Apr 02, 2022 at 04:22:56PM +0800, kernel test robot a écrit :
> Hi Corentin,
> 
> I love your patch! Perhaps something to improve:
> 
> [auto build test WARNING on next-20220331]
> [also build test WARNING on v5.17]
> [cannot apply to rockchip/for-next herbert-cryptodev-2.6/master herbert-crypto-2.6/master v5.17 v5.17-rc8 v5.17-rc7]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Corentin-Labbe/crypto-rockchip-permit-to-pass-self-tests/20220402-042221
> base:    fdcbcd1348f4ef713668bae1b0fa9774e1811205
> config: arm64-buildonly-randconfig-r001-20220402 (https://download.01.org/0day-ci/archive/20220402/202204021634.IhyHrjoT-lkp@intel.com/config)
> compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c4a1b07d0979e7ff20d7d541af666d822d66b566)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install arm64 cross compiling tool for clang build
>         # apt-get install binutils-aarch64-linux-gnu
>         # https://github.com/intel-lab-lkp/linux/commit/be381eb03ba20a6e06f0e880a9929d14a1e13064
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Corentin-Labbe/crypto-rockchip-permit-to-pass-self-tests/20220402-042221
>         git checkout be381eb03ba20a6e06f0e880a9929d14a1e13064
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/crypto/rockchip/
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    drivers/crypto/rockchip/rk3288_crypto_skcipher.c:21:46: error: use of undeclared identifier 'tfm'
>            unsigned int bs = crypto_skcipher_blocksize(tfm);
>                                                        ^
> >> drivers/crypto/rockchip/rk3288_crypto_skcipher.c:328:6: warning: variable 'n' set but not used [-Wunused-but-set-variable]
>            int n = 0;
>                ^
>    1 warning and 1 error generated.
> 

Argh, I didnt retry to compile this serie one patch by one.

Thanks, I will fix that in v5.
