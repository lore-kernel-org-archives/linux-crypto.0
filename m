Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C46AC25B0D
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 04:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiHPEPy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 00:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiHPENJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 00:13:09 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05264363720
        for <linux-crypto@vger.kernel.org>; Mon, 15 Aug 2022 17:45:15 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-324ec5a9e97so113520127b3.7
        for <linux-crypto@vger.kernel.org>; Mon, 15 Aug 2022 17:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=CsC+j0kptQXyDU8jUOJJkLIgy9EO57j1cJI24xW/Lks=;
        b=OolYPV5QGpkoYYSeVMpK+QPcz1RNdoXZNadw16lVGzL8eBCU/ZQOkmG+rXUMpxJsHU
         nwsCWZPyEU1SjU2HNdCKU7zjfbMofUTuL0mx7XTtjqHiXFdNJbm5pWgIKdNeyU4X7+xQ
         8qRGC7/rpsKWmFO7oQQjQanvjlJHtUWh3zxgUNOQrb3ucNFMS7Qi73hXOTKVBHbxt1Mt
         syIsqWfhRmbVx9JltGt9qXunEv2RPZTL4zu/PpK4g87wK6hiMIgyEIn2zEYkV2FQlLzl
         OPbkXcDwzmM0lhniKME3eRB9G8oBePqxCFiIxP0nQxFwuAqY4z2uRbDqJwgfIs9k2GTi
         0woQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=CsC+j0kptQXyDU8jUOJJkLIgy9EO57j1cJI24xW/Lks=;
        b=KFzF6TJWPAo3XVo37m7jfuquqxg4JZMDK4u6YAWlqnBXHI78F/SJninI8A5rae/Qqm
         sXIPcKyjVAVrF7JB9MhZ7qqviMcovZ31DMBq+qxGLKDw7sAZyRkA8guRiwiWKk6UTdHl
         lUfkPCsQ0IZxCL3wehg2h9eZoBw7VZn8Ahw0oCKIes6in9SPO5a8Pcilhz5zevRgnNl2
         CJp8ka4g2U8NHE8PIvfUotvHLaHJXslx73aD07qmnm3l1QuO61akHvCN6T+yR7mCmGnq
         qdAvW0Q+4BJJg0HX5xaTdt4MwoXLhTLwM6YfimzGjZ88tBoVTNzXzWs+b1t+6npq1gCE
         lNbQ==
X-Gm-Message-State: ACgBeo3c7AXZq+e1tdD1/sxrm1PFohJgpZ1Glp9aBGQF2T2EkMHTrp0z
        gAyRXE4hcXdTo5dS+zRtdggH8D3m4wxlpoNn/Br7WyraxvP3VtEtNxQ=
X-Google-Smtp-Source: AA6agR6kRvEAXTC6rICDz8fMwHaAkRYmZXp6g258G/rwJ2LrcSqP+nV4ayUvH8nROfQw/5ncS0ZSehVDX3KfNUBOR+I=
X-Received: by 2002:a25:c709:0:b0:676:bf77:c838 with SMTP id
 w9-20020a25c709000000b00676bf77c838mr14066044ybe.430.1660610714036; Mon, 15
 Aug 2022 17:45:14 -0700 (PDT)
MIME-Version: 1.0
From:   Alec Ari <neotheuser@gmail.com>
Date:   Mon, 15 Aug 2022 19:45:03 -0500
Message-ID: <CAM5Ud7NMr_f_JYvvjj2wm2gobAkMr0fFuQWdBdcSe4W++EB8QQ@mail.gmail.com>
Subject: [PATCH] crypto: Make FIPS_SIGNATURE_SELFTEST depend on CRYPTO_FIPS
To:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Alec Ari <alec@onelabs.com>
Date: Mon, 15 Aug 2022 19:13:12 -0500
Subject: crypto: Make FIPS_SIGNATURE_SELFTEST depend on CRYPTO_FIPS

Would running FIPS selftests be necessary if FIPS is disabled?

Signed-off-by: Alec Ari <alec@onelabs.com>
---
 crypto/asymmetric_keys/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 3df3fe4ed..562bbd774 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -81,6 +81,7 @@ config FIPS_SIGNATURE_SELFTEST
          This option causes some selftests to be run on the signature
          verification code, using some built in data.  This is required
          for FIPS.
+       depends on CRYPTO_FIPS
        depends on KEYS
        depends on ASYMMETRIC_KEY_TYPE
        depends on PKCS7_MESSAGE_PARSER
-- 
2.37.2
