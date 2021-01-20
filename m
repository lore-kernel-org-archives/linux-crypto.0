Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0671CC433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 18:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4588233EA
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 18:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392047AbhATSuX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 13:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbhATSt2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 13:49:28 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1EBC0613C1
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jan 2021 10:48:45 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id l14so11391655qvh.2
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jan 2021 10:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MVVhNU0jVxaFNlsItS1vMiG5qpQne1QXE2l8B2YUFJ4=;
        b=RBUMa/VVhCosudUS1Xhd3LCBqXpG0EbMVduHzbsWUTxuWnU881IQ4/EpiIqfunOnXt
         n7bU6qG6cqLN1pZPuNeCutdgGcp/d4co9OosvROdtYtpwpc/P03cTeQ8oi8xzi2Ucy93
         iRpIahG55q8YAePMvIAJvXzdPE4cQT7p0Ie309oWVXiSW2uYNaNeXZ0tTSidbw3Ku8gu
         2bYUGO1Pa6bfdGogQ6aqd4XSYF+xSpUBRUZTwLqG45rXIThQfkgZZnhjkBb5PxeIwpEi
         ElUJ5UOqXwh39jXt0OgWPGoB0G7+8/9leHDoSnwu9MCkrGljYEZ+Yn79ScEbQpMzNipD
         wNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MVVhNU0jVxaFNlsItS1vMiG5qpQne1QXE2l8B2YUFJ4=;
        b=kT7T/L4Xh//RP4OoxNjd/7NP5z24HNuz47Lg+Av0EB4yIHkKNh4WKTvJFN9VpScwLm
         ESioNmVBYFfEwtgL129d64QTtY9qCNgHCCkqfweZkiitgiA8Y9hJ35TcL+1RIFt+ocvC
         8PX67frZONm26dya3UUVErYwtkfE3pZ+dWfXd1RxE9avCTMv9nhoCzPQkY+mRSdH3pDe
         QIkGyLgdrDTrPbYZ3rSg2gaRw0oXjVF3N8CGcVdo9jBMHd3EBE2gvJxzir293coNjQd+
         K+sbmaKK+sVRuc4F66tw6JhLlE97+/DG6m4LmxwWxQ0Hg2IsUDn+yEqfjC5phlxzFJAZ
         R0FA==
X-Gm-Message-State: AOAM531B5GIN7WIuJlU5XFTXcpJvYbmPHRvVBX9QgqXytZz+hSOm/wxt
        eY578ir1uHdduMvyYqpcNx+O5w==
X-Google-Smtp-Source: ABdhPJwbGoPW2RScm/iTHnU362NqZqDFlvBtFyJotT7r8v6wwXX4OrJ+aC5+2yN5+D8FoVS9EQjPhA==
X-Received: by 2002:a05:6214:714:: with SMTP id b20mr10736065qvz.36.1611168525073;
        Wed, 20 Jan 2021 10:48:45 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id w8sm1769903qts.50.2021.01.20.10.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 10:48:44 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/6] Regression fixes/clean ups in the Qualcomm crypto engine driver
Date:   Wed, 20 Jan 2021 13:48:37 -0500
Message-Id: <20210120184843.3217775-1-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch series is a result of running kernel crypto fuzz tests (by
enabling CONFIG_CRYPTO_MANAGER_EXTRA_TESTS) on the transformations
currently supported via the Qualcomm crypto engine on sdm845.  The first
four patches are fixes for various regressions found during testing. The
last two patches are minor clean ups of unused variable and parameters.

v2->v3:
	- Made the comparison between keys to check if any two keys are
	  same for triple des algorithms constant-time as per
	  Nym Seddon's suggestion.
	- Rebased to 5.11-rc4.
v1->v2:
	- Introduced custom struct qce_sha_saved_state to store and restore
	  partial sha transformation.
	- Rebased to 5.11-rc3.

Thara Gopinath (6):
  drivers: crypto: qce: sha: Restore/save ahash state with custom struct
    in export/import
  drivers: crypto: qce: sha: Hold back a block of data to be transferred
    as part of final
  drivers: crypto: qce: skcipher: Fix regressions found during fuzz
    testing
  drivers: crypto: qce: common: Set data unit size to message length for
    AES XTS transformation
  drivers: crypto: qce: Remover src_tbl from qce_cipher_reqctx
  drivers: crypto: qce: Remove totallen and offset in qce_start

 drivers/crypto/qce/cipher.h   |   1 -
 drivers/crypto/qce/common.c   |  25 +++---
 drivers/crypto/qce/common.h   |   3 +-
 drivers/crypto/qce/sha.c      | 143 +++++++++++++---------------------
 drivers/crypto/qce/skcipher.c |  70 ++++++++++++++---
 5 files changed, 127 insertions(+), 115 deletions(-)

-- 
2.25.1

