Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B84CAC43460
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Apr 2021 03:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AABA61354
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Apr 2021 03:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhDTDgi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Apr 2021 23:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbhDTDgg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Apr 2021 23:36:36 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8DFC061763
        for <linux-crypto@vger.kernel.org>; Mon, 19 Apr 2021 20:36:04 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id er3so9463715qvb.6
        for <linux-crypto@vger.kernel.org>; Mon, 19 Apr 2021 20:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PJriSY/3BoO1fHsVgHab2OGWTgIWKz/XuakYolqJtHg=;
        b=E0hvOm6eMmyEZ2M3MU2QsiHj0zTZy4NxvzMJ4BuGjCki4mRcIXk7NPuyXjMnsPdPAA
         T8mmB/dCDnnKTJo7waaGCoouYsM+rEdpHxjRg624Hrm+KrU319G2jfKtg5Zsn6t+JKUE
         1+p5ccwYfSWxeg05DUjA+Gh9Kiz9CiRLj1/KaNL+sHK5ixXA8oKcbNnZGGOkuN/dD7UA
         yNG89UnljPOlKQwcffDInPUHqBmauqiT1uEU/J7gopgaRVGL+aXAYaB25y0h6rpe4OLF
         j3uEo6c7Cg0EuX8EaUT51G2iok5lnUA0gkTf3S0kDpXlE9nutvI/49+aMCKwcWh+LObV
         a99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PJriSY/3BoO1fHsVgHab2OGWTgIWKz/XuakYolqJtHg=;
        b=igvpJnKfpo99Zt1cS6jaboPPleGKj2GnOEP26aeYSd0WK1eFU3ppq9YLaqLwcHXB1w
         QJaAYlryEXbFDdmXija0wlrXNnDJ1+29FYyEsoWE86C0kugHyUtFQzvmn7RTcqt38Dl1
         Wu6zcY2h338tMNoOCWjy5uhgjDO3KznjOoYR6GssHMUGlvdZi8zCGPOgbvHPEAY+8mjI
         lPztzoyo3zXMt7f5BZNCMMGDLn2XLX7WiloctBzTsJRvfHspPODpw4IF5BgCP1vHDEbK
         rJCMGZfKPSOhRx/FrZCn9P+g4Oxz727EKtLwzzXcb+OsnzFRGVSdZYaRpMDH2tPVAjA7
         208g==
X-Gm-Message-State: AOAM531J6B49HI7SNZwA/sXrgzpkxHzf+DCiceIIoYNnk5dJ5+h5uprW
        A40zCofPIu16WciOj35Dsw8K7Q==
X-Google-Smtp-Source: ABdhPJz/76Nl3IXgE34PV0d/wfa80eH3VqGZ0YzVyMqViE0CQo5/nlB7bzYC0R6svVBMv4mFZVfzHw==
X-Received: by 2002:a0c:eb06:: with SMTP id j6mr24696769qvp.10.1618889763374;
        Mon, 19 Apr 2021 20:36:03 -0700 (PDT)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id b8sm3562643qka.117.2021.04.19.20.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 20:36:02 -0700 (PDT)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [Patch v3 0/7] Add support for AEAD algorithms in Qualcomm Crypto Engine driver
Date:   Mon, 19 Apr 2021 23:35:55 -0400
Message-Id: <20210420033602.1729947-1-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Enable support for AEAD algorithms in Qualcomm CE driver.  The first three
patches in this series are cleanups and add a few missing pieces required
to add support for AEAD algorithms.  Patch 4 introduces supported AEAD
transformations on Qualcomm CE.  Patches 5 and 6 implements the h/w
infrastructure needed to enable and run the AEAD transformations on
Qualcomm CE.  Patch 7 adds support to queue fallback algorithms in case of
unsupported special inputs.

This patch series has been tested with in kernel crypto testing module
tcrypt.ko with fuzz tests enabled as well.

Thara Gopinath (7):
  crypto: qce: common: Add MAC failed error checking
  crypto: qce: common: Make result dump optional
  crypto: qce: Add mode for rfc4309
  crypto: qce: Add support for AEAD algorithms
  crypto: qce: common: Clean up qce_auth_cfg
  crypto: qce: common: Add support for AEAD algorithms
  crypto: qce: aead: Schedule fallback algorithm

 drivers/crypto/Kconfig      |  15 +
 drivers/crypto/qce/Makefile |   1 +
 drivers/crypto/qce/aead.c   | 841 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/qce/aead.h   |  56 +++
 drivers/crypto/qce/common.c | 196 ++++++++-
 drivers/crypto/qce/common.h |   9 +-
 drivers/crypto/qce/core.c   |   4 +
 7 files changed, 1102 insertions(+), 20 deletions(-)
 create mode 100644 drivers/crypto/qce/aead.c
 create mode 100644 drivers/crypto/qce/aead.h

-- 
2.25.1

