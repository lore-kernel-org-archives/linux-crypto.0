Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C1EC07E96
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Jul 2021 04:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E0B461CDD
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Jul 2021 04:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbhGHEhE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Jul 2021 00:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhGHEhE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Jul 2021 00:37:04 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35851C061574;
        Wed,  7 Jul 2021 21:34:23 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id b2so7166918ejg.8;
        Wed, 07 Jul 2021 21:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=DZpADzPkllhB2f2eevjE66dy2/DnKutR4bBIj2mC0zE=;
        b=HJ07gHdCtEklVmkp4xRYgIPUAD1HZjREgIW3OpJHgt4qXJpC5lFaYD8Ws1nxl82O5t
         v+y2PCjnxaCmhCXhyDcryaFWrUajiTKSJIl/VIPLcpNHBUULHgfShO101pFa0wZmridA
         h78fPgrFXJQ+2f8AwVKD/DIDdmECtjJpoPDmQdztLiHHI7eOT3s9Cacqr8BdZQyZoF4L
         qNzftyyDdT0fBg+eSuJ0VNf5v6saBnI4k3iVC9vAEKXmW10KQQh94LY1gI6dQaBVbHZR
         RxMKoBfID8csPYIXn+512I/Yt+qGGzF702arAv/fUMLqIrLOEQo665o9OquAWkUkEJMM
         jndA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=DZpADzPkllhB2f2eevjE66dy2/DnKutR4bBIj2mC0zE=;
        b=EsHRFWP46FONEJbQafzMXsXIc3dfCIAiSuuRAsAO1Gi5Bfe7DnZ7T8dNMBdhSESC3N
         dm17sjySRkTvy9MaEI/DOiiMXrPkLKFUhZqKQD5ekJ38/dg1WAc+3dbmpjcBmNFrpID+
         nLOsm04FbvE6HK1hm1DV0NFaQcsbtomMtgAgIGn+60lQX4XNBQgrO8h34Mdco89mGuXb
         8z6O+/5EcsZJWMcOi8Tnwg/Eovv9FbmoB8avc/Khv2w3mi3bhtrKlmON8drteRdLEY4h
         vPeHKilom4uF5tPZdVViRyxrlSm0CgJd7NOR9m36MtxtqrIL3TBxfslMMKEtd9EUr/cR
         ltqQ==
X-Gm-Message-State: AOAM533zYdDj7h4f7v42D6K0Zce2bAnd/wvWu5slurWc2V8lkuOhKy6R
        doFB3IH/EwWJ0Bjyl4lqWcAXqSisJC4WeJtX9Q5d4SzhZY+fWK76
X-Google-Smtp-Source: ABdhPJzssqKIKBytGh1QuCXAmejrZd+4ZlIpiWHBYBOqgXdru/TvdJxgKsfMyuHooVJ4FOFPDIFjx5btkZqfgludPPs=
X-Received: by 2002:a17:906:3699:: with SMTP id a25mr22145621ejc.452.1625718861821;
 Wed, 07 Jul 2021 21:34:21 -0700 (PDT)
MIME-Version: 1.0
From:   iLifetruth <yixiaonn@gmail.com>
Date:   Thu, 8 Jul 2021 12:33:47 +0800
Message-ID: <CABv53a8jyUXns9yu3xyd71_R+nNerU+Xj4i7a4rcZUH0bd52kw@mail.gmail.com>
Subject: crypto: prefix additional module autoloading with "crypto-"
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Qiang Liu <cyruscyliu@gmail.com>, yajin@vm-kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, in the latest version of linux kernel, we may have found some
additional incomplete fixed crypto-related modules related to
CVE-2013-7421.

==========
The upstream commit 5d26a105b5a7 ("crypto: prefix module autoloading
with "crypto-"")  provided the fixing patch for CVE-2013-7421 about 7
years ago on 2014-11-24.

This patch changed the automatic module loading when requesting crypto
algorithms to prefix all module requests with "crypto-", so we can
never run the risk of exposing module auto-loading to userspace via a
crypto API, as demonstrated by Mathias Krause:
        https://lkml.org/lkml/2013/3/4/70

=========
And the common fix pattern we found in each crypto-related module is as follows:
1. linux/drivers/crypto/padlock-aes.c
       -MODULE_ALIAS("aes");
       +MODULE_ALIAS_CRYPTO("aes");

or in another module:

2. linux/drivers/crypto/qat/qat_common/adf_ctl_drv.c
      -MODULE_ALIAS("intel_qat");
      +MODULE_ALIAS_CRYPTO("intel_qat");
...

==========
Even though commit 5d26a105b5a7 added those aliases for a large number
of modules,  it is still missing some newly added crypto-related
modules.
For example:
1. for file linux/drivers/crypto/amcc/crypto4xx_trng.c in line 129,
Module_ALIAS is used instead of MODULE_ALIAS_CRYPTO
           MODULE_ALIAS("ppc4xx_rng");
     In fact, ppc4xx-rng was integrated into crypto4xx on 2016-04-18
by commit 5343e674f32fb8, which was committed about 2 years later than
the security bug fixing patch(5d26a105b5a7) committed on 2014-11-24

More modules that may not have been fixed are as follows:
2. linux/crypto/crypto_user_base.c
        MODULE_ALIAS("net-pf-16-proto-21");
3. linux/drivers/crypto/mxs-dcp.c
        MODULE_ALIAS("platform:mxs-dcp");
4. linux/drivers/crypto/omap-sham.c
        MODULE_ALIAS("platform:omap-sham");
5. linux/drivers/crypto/qcom-rng.c
        MODULE_ALIAS("platform:" KBUILD_MODNAME);
6. linux/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
        MODULE_ALIAS("platform:sun4i-ss");
7. linux/drivers/crypto/marvell/cesa/cesa.c
        MODULE_ALIAS("platform:mv_crypto");
8. linux/drivers/crypto/qce/core.c
        MODULE_ALIAS("platform:" KBUILD_MODNAME);

==========
Now, shall we port the fix pattern to these modules from the patch of
CVE-2013-7421?
We would like to contact you to confirm this problem.

Thank you!
