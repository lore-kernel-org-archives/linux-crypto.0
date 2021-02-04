Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 162E5C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C941664F97
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBDVoo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 16:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhBDVol (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 16:44:41 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92DB5C061786
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 13:44:01 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id x81so4969764qkb.0
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 13:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G6n3XQ08yWZ9lzKICVX9QM9j4Y+beb5V9nQwAwfR7q4=;
        b=ezB6M2/QlZUpa1ox9B4HIAOSvCFe8I6qZwJcMTf0enbjJeQreVhgCnVQ1x9DwECQea
         5Zo7pvBL8XcjfKNEhZoF18Zcfb1Jw25eI68YktzRsnqiHhJ2UslLMsmDSa1jUwo9wciS
         UuA5TaVjnnnsna4uPNeqAeCiP0kRVaWnIb8mw78UJc8a+rZYW/LOruL7fk/xTXJc8VPl
         2hNaO/oYs0jIAGubvMjJljmrmJ390GNjTZcQ+ADnds58FQuBkuw+waAdoDg6XGr2hTXO
         71aayzIbWeCSud8u5pOSwgLqPQWiGBErlgBO1WfwHBl4bZIT5pRRDkxqUIFEk7B55OQM
         FgpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G6n3XQ08yWZ9lzKICVX9QM9j4Y+beb5V9nQwAwfR7q4=;
        b=Qa5giT2e0HFzZgTZPt0EcbAwrBvOqDDCy1RC9yYEoMZ/xV8YzSVcNbrvuEOwWJ2IjE
         I7ltslu3GKQAus5gwqMHcS9F9PGgqEfK4rMqh5/GXkn86yXpVI1EbRFyf79hGo5VIC9N
         LYabgDZRU5xb+emFEO5PaDM63hqOhyUjNXgM/zTBsXr3GbvMM3DbvGIpHwxlig14SpWG
         hDd50uJtUs9UZsJ4L8QXjCPR1hOzW4WGNbvb78XpJ9zC3tohGgv8q4f0xI0DrOWkyWXN
         A8zpanXxSFmLUYxDWMHOBs9fjfNCO2Q5WlYbeN3/qmp1rgB42D4Vln16uqbRmRqiaiFx
         QtDA==
X-Gm-Message-State: AOAM531BTX6dps9AiCtPtkZo9OOPnhn3Ew7GAhURhY8ILac+jRf5CXC6
        HGl9SXhFpufwhbayIaSP/7idTQ==
X-Google-Smtp-Source: ABdhPJwrZifZ9fFAedIsC9aUP/uvtFhy2VAK6O0lcgbcY3KEZHoQtMI+D8AAKcpJtYAIv47uWFc3DA==
X-Received: by 2002:a37:68f:: with SMTP id 137mr1207526qkg.420.1612475040654;
        Thu, 04 Feb 2021 13:44:00 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id h185sm6353858qkd.122.2021.02.04.13.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 13:44:00 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 00/11] Regression fixes/clean ups in the Qualcomm crypto engine driver
Date:   Thu,  4 Feb 2021 16:43:48 -0500
Message-Id: <20210204214359.1993065-1-thara.gopinath@linaro.org>
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

v4->v5:
	- Fixed build warning/error in patch for wrong assignment of const
	  pointer as reported by kernel test robot <lkp@intel.com>.
	- Rebased to 5.11-rc6.
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
  crypto: qce: Remover src_tbl from qce_cipher_reqctx
  crypto: qce: Remove totallen and offset in qce_start

 drivers/crypto/qce/cipher.h   |   1 -
 drivers/crypto/qce/common.c   |  25 +++---
 drivers/crypto/qce/common.h   |   3 +-
 drivers/crypto/qce/sha.c      | 143 +++++++++++++---------------------
 drivers/crypto/qce/skcipher.c |  72 ++++++++++++++---
 5 files changed, 129 insertions(+), 115 deletions(-)

-- 
2.25.1

