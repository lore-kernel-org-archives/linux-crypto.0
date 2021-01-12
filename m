Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06495C433DB
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 03:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A058222D5B
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 03:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733026AbhALDG2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 22:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731989AbhALDG2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 22:06:28 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C18EC061786
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jan 2021 19:05:47 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id a6so742540qtw.6
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jan 2021 19:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Db6UueaN/+RSAW6s0FX898oyfgOTV6utqe+CUYCp0wg=;
        b=j5fe8wXQ4sOgA0VRFLhBnrUkBl4/VGaDzDaxxX5MwXAHuSyr1/qYO+/hLkHDQSgBbB
         rraG8Zw761QqmWdpSuJYruoMJRVyawk1zu5EiGEDcrJXxz4c7fiNV53hwzERSoWgtgwm
         m5VDJX8J5Vv8sBbxOy0Rm5FhOkvBjNZ5tFGqjobpAXh7CLm4kOTazH2pp+b+XypxAafH
         zEcIYAt++0PxFzh1CFfxF/0Ig0MsMkbUMU7RpSYh3ZuYIktlhMnln7N3dXfWJ4fhZEHb
         SQALrHExGLlFFYiS60BYNazBnnL2ycaqR2NL5FE1UDK7eQ2JNnPV0nlMh38iUSt1LngV
         1kJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Db6UueaN/+RSAW6s0FX898oyfgOTV6utqe+CUYCp0wg=;
        b=oWJu/LCcUrGb++L1PuVVma8RAIRSuMXFhEvO8MQUs9sfv9TqHosdGvVkPrs7oYql7I
         b/cy78+gleawFaTEX7sRX5Osl1m1A5ApNujTwk4cL/shV5oRvJeAVHnbAz10h82s01bY
         3xKI489jWe38BH/h6EgnWGWPiVtpDVAfAhw9Vz0W58kz/JhlzdyfYO7obcGFvrBuBwYC
         QPa/h1w75Lf2Y7FSWaEghV8ed+I01XEQLJa/fhfoWRlDk6nUH+fgzWlgRyqSwC827wyf
         zHrrGzuWALBzxVnl8rrOOjPaEdkNhuX57Lzon2HShgxg0dgZNSX8oYj/RzkQij0xl69K
         nb9Q==
X-Gm-Message-State: AOAM532jOrHjryb7rwLWT3Gp+YRBUU4sSEvx7Ssh/0ZYHNalCTk8lSeA
        GZzDMjuy+XX5+RizNlNLgshDlA==
X-Google-Smtp-Source: ABdhPJx8tqLX0CPDQwvbISN6RIxnHeB2AP3GmCr4sHNF/DtoeVOIbSoVvE5wRuwU0gC5v24920pgaw==
X-Received: by 2002:ac8:6e83:: with SMTP id c3mr2703904qtv.318.1610420746584;
        Mon, 11 Jan 2021 19:05:46 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id c7sm814235qkm.99.2021.01.11.19.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 19:05:46 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] Regression fixes/clean ups in the Qualcomm crypto engine driver
Date:   Mon, 11 Jan 2021 22:05:39 -0500
Message-Id: <20210112030545.669480-1-thara.gopinath@linaro.org>
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

