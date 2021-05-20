Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 705CCC43470
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 09:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E74661465
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 09:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbhETJf5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 May 2021 05:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbhETJd5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 May 2021 05:33:57 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E618BC0612A3
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 02:27:37 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id b7so8144589wmh.5
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 02:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dU5Shf+7jgxGf2Em75yJ7P7LzexGKomEfxug1gdGXww=;
        b=WHq5rmnp3uI8DAyWtdVkuqfHWCNoBreRF/GaYNOH/nJ2YdBW4Mv5+dn9HgrlpN5Z6x
         sSv9X1mC66hRC+GzbfRw3ycK1KOwvCIfaPoJc4JXXAUYl6kSEXGh1Wb+f9FSBySC7Zj9
         IF6vnioWscFC/kCaq0GOVcMweXqNS7gp16hUK0t6VBs8UBqh87BXwLc8NjtyJPy6ckTM
         0AGlt1IRVQ6uruiorIZiWHibX/9ZHCjWbprF4nhe5jUkCqYUDwJGxxaF/Q7PqMkPcdDP
         ZjRrYtUZRf+7jwJKbmJcgOT7XahixFIs8Xw3HNGjXK+hi46zDKfaRxJyQcbDBYIRAk+U
         ApOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dU5Shf+7jgxGf2Em75yJ7P7LzexGKomEfxug1gdGXww=;
        b=BogHkAtTLb2RsRt0mD0Y7dsBQzLfxrbNDY637AFeFUY12lAMKr9DuIp2fI6s9Hk55r
         ELsUkRZJ9PqlEJsztTMsJX/Bz7al5Hv/Cuq2OHdenytGe+Wf/nJ2+mr6mcq3BXHCQIs6
         biwYYXO2an6uiCNvugpYJwLqAxHJ/Oo93qvXPN+i20KGMhKX6kcQp5oMLA8E3N9Zi2OT
         HQa2S31Ts0gN0wEjYNMtnFIzfldgXuvdeH1vzQgNPS+TlVnnDCt4Q7b11X6ujNSGbGQH
         mXWOXauE4x1880yr575eVKzwNutM6s3mu5ROdc+NIbR+mMM1lM83rFjmXCeORxpNuv6G
         EkfA==
X-Gm-Message-State: AOAM532QYb2IY5f2nLnwNkEcOuW5wFjAwvqbjDZjXWiRrRIFYUCY00gZ
        5qmXS0/wKTFMMnY9ODDxJB9dHQ==
X-Google-Smtp-Source: ABdhPJzDsTvk4HPlEGrtAcfV1TKzKAUs+Q3Wq9d61G1Q07eGsQmFkUl0v/Yc00uh0/tRpYItTzsFfg==
X-Received: by 2002:a05:600c:4fd6:: with SMTP id o22mr2629786wmq.83.1621502856494;
        Thu, 20 May 2021 02:27:36 -0700 (PDT)
Received: from dell.default ([91.110.221.215])
        by smtp.gmail.com with ESMTPSA id u11sm722971wrw.14.2021.05.20.02.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 02:27:36 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Gary R Hook <gary.hook@amd.com>,
        George Cherian <gcherian@marvell.com>,
        Haren Myneni <haren@us.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 0/3] Rid W=1 warnings from Crypto
Date:   Thu, 20 May 2021 10:27:30 +0100
Message-Id: <20210520092733.3434378-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set is part of a larger effort attempting to clean-up W=1
kernel builds, which are currently overwhelmingly riddled with
niggly little warnings.

Lee Jones (3):
  crypto: cavium: Fix a bunch of kernel-doc related issues
  crypto: nx: nx-aes-gcm: Kernel-doc formatting should not be used for
    headers
  crypto: ccp: ccp-dev: Fix a little doc-rot

 drivers/crypto/cavium/cpt/cptpf_main.c        |  2 +-
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c  |  4 ++--
 drivers/crypto/cavium/nitrox/nitrox_main.c    |  4 ++--
 drivers/crypto/cavium/nitrox/nitrox_mbx.c     |  4 ++--
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c  | 12 ++++++----
 .../crypto/cavium/nitrox/nitrox_skcipher.c    |  2 +-
 drivers/crypto/ccp/ccp-dev.c                  |  2 +-
 drivers/crypto/nx/nx-842-pseries.c            | 24 +++++++++----------
 8 files changed, 27 insertions(+), 27 deletions(-)

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Gary R Hook <gary.hook@amd.com>
Cc: George Cherian <gcherian@marvell.com>
Cc: Haren Myneni <haren@us.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: John Allen <john.allen@amd.com>
Cc: linux-crypto@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
-- 
2.31.1

