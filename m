Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4AFAC433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 14:34:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CF6764F72
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 14:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbhBCOdv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 09:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbhBCOdu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 09:33:50 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639D2C0613D6
        for <linux-crypto@vger.kernel.org>; Wed,  3 Feb 2021 06:33:10 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id r20so14075598qtm.3
        for <linux-crypto@vger.kernel.org>; Wed, 03 Feb 2021 06:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hFVpsPmskX5v5OqYWeZ4v5kCJDeC7TSVZUZ0ux0+ShY=;
        b=BFaYS9tA+mKRULFIRN2SY/lioEm3Rj8LTAXQOMEsgMJilhbHf0kKrlgQeNdZuIaCSr
         VHhzrEHqc9v0u+Re5pvN28/nfwJmte7sl0hi/pIXmu5GlHSL1K6EAhgYVBN0b2Mq+ERI
         d8fZ525GvTMXQCfMcB9bCKCtDYHW0MKWC6/NoRQm+Te3o5rd2yVNu5JGiofwbOtRVISf
         g65Y4Ry/eMxuQWZibn2XEMM5Koy5fwaCv2QiSQJdn1kwmtZ9ONpRdftOxLHm6OqQpUWj
         GWbJjZz9VY/XYVZJMBihRCLBolUIqi3p9Zk08G+Pxwcu8momnEJNgPHjSs0Sk07jt347
         r+Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hFVpsPmskX5v5OqYWeZ4v5kCJDeC7TSVZUZ0ux0+ShY=;
        b=cwoF80c6YqrEmD8sBV3L7h/+QZSfIozIWD4TbXuGxvmCekSMozaTGI7dLql2VoLXiS
         CJropNal6nQBWDUxpNKpIhrPMMS1n95e6InfmQ8N6Zon/i3DG0pd0lEUOGHQlyFXfRaV
         ujBSw5NskRWxnNlGeYaiGGN/GQW+lO1+UlqgpN7oDvmGjWf7jBqIBLnJut2VJwPFScux
         YKNeVZNIyHaIZhzhcCfXI1gAbOdyx2Kf7MV7RdqD2KqmxhaCxFLXCB3LiA35K8AQDJDc
         Rq7gH2v3gw9zc9pXtnbdbEiXwKRM+FadMwPdPgBFwCAlmvTJIAQYa9lGM5KJxy2L1Yyp
         FfgQ==
X-Gm-Message-State: AOAM533cghaUgW3YA9RbSy+z6wJerECf6Vqye9E3Pin0v7/CocQxy+89
        xpyCvu/v1Rl5BxQkMz8kwWv1Bg==
X-Google-Smtp-Source: ABdhPJyfZxQNM91CdsDsqtG41dB+ZodLg8UgqzIPM2N3SrqT4/okWdUTCx1q8lgTzUwX/bc4b1wgig==
X-Received: by 2002:ac8:4990:: with SMTP id f16mr2608167qtq.184.1612362789340;
        Wed, 03 Feb 2021 06:33:09 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id v15sm1775433qkv.36.2021.02.03.06.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 06:33:08 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 00/11] Regression fixes/clean ups in the Qualcomm crypto engine driver
Date:   Wed,  3 Feb 2021 09:32:56 -0500
Message-Id: <20210203143307.1351563-1-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch series is a result of running kernel crypto fuzz tests (by
enabling CONFIG_CRYPTO_MANAGER_EXTRA_TESTS) on the transformations
currently supported via the Qualcomm crypto engine on sdm845.  The first
nine patches are fixes for various regressions found during testing. The
last two patches are minor clean ups of unused variable and parameters.

v3->v4:
	- Fixed the bug where only two bytes of byte_count were getting
	  saved and restored instead of all eight bytes. Thanks Bjorn for
	  catching this.
	- Split patch 3 "Fix regressions found during fuzz testing" into
	  6 patches as requested by Bjorn.
	- Dropped crypto from all subject headers.
	- Rebased to 5.11-rc5
v2->v3:
        - Made the comparison between keys to check if any two keys are
          same for triple des algorithms constant-time as per
          Nym Seddon's suggestion.
        - Rebased to 5.11-rc4.
v1->v2:
        - Introduced custom struct qce_sha_saved_state to store and restore
          partial sha transformation.
        - Rebased to 5.11-rc3.

Thara Gopinath (11):
  crypto: qce: sha: Restore/save ahash state with custom struct in
    export/import
  crypto: qce: sha: Hold back a block of data to be transferred as part
    of final
  crypto: qce: skcipher: Return unsupported if key1 and key 2 are same
    for AES XTS algorithm
  crypto: qce: skcipher: Return unsupported if any three keys are same
    for DES3 algorithms
  crypto: qce: skcipher: Return error for zero length messages
  crypto: qce: skcipher: Return error for non-blocksize data(ECB/CBC
    algorithms)
  crypto: qce: skcipher: Set ivsize to 0 for ecb(aes)
  crypto: qce: skcipher: Improve the conditions for requesting AES
    fallback cipher
  crypto: qce: common: Set data unit size to message length for AES XTS
    transformation
  drivers: crypto: qce: Remover src_tbl from qce_cipher_reqctx
  crypto: qce: Remove totallen and offset in qce_start

 drivers/crypto/qce/cipher.h   |   1 -
 drivers/crypto/qce/common.c   |  25 +++---
 drivers/crypto/qce/common.h   |   3 +-
 drivers/crypto/qce/sha.c      | 143 +++++++++++++---------------------
 drivers/crypto/qce/skcipher.c |  72 ++++++++++++++---
 5 files changed, 129 insertions(+), 115 deletions(-)

-- 
2.25.1

