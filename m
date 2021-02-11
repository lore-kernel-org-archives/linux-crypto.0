Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A06C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Feb 2021 20:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C707964DD1
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Feb 2021 20:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhBKUCS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Feb 2021 15:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbhBKUCK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Feb 2021 15:02:10 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22227C061756
        for <linux-crypto@vger.kernel.org>; Thu, 11 Feb 2021 12:01:30 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id o21so5109717qtr.3
        for <linux-crypto@vger.kernel.org>; Thu, 11 Feb 2021 12:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BkNbbxb6k/17zzJxBEIrJhvukJWdWW3RjEBbcBFX430=;
        b=aLSfsFswKuq9oi6QHQPnxX1RgBgaK69pFL1L25ki5cIqOfjEXzg3hvSdsjnS+kj2nU
         SZUlACzn16zviRTySn580vyva3PmeMoLeehw98PdlRD0Iufjhzo89I1MomR+ZyGWutwU
         55PH3cGa2gTrKT4ShFyFJ1xbwW+RuRAAXmT0nJu4F5iucnr/NhiPblSuT+LM4D/10aSM
         iaRJdyC8H3gAJ2UmO+bY9iVlz/invqKTzrCk4bU/DexCpblvFSiQrLPTbQiQeGfuc0qF
         AaPCG77p3y0SNk3p70KVfaoxx2Vq/zmjUnzGgBhnWx/A52fWk+0LJz/fL9zaYMrJ62rC
         4OEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BkNbbxb6k/17zzJxBEIrJhvukJWdWW3RjEBbcBFX430=;
        b=l4dsikQ950S4TOMS63ywshiH0FoogdXld1caDRHT5fMkQLU2/SHejvisvxmMZWAImu
         80jIZ0q4MeBJC+d/2B63kWYQ2OrPKgjgRNNsl599JBrD+XyjGRuQYimDuh3Gpv+zhLmY
         GemOvLkhulqvqF0q7dlXTFR7Z4DClOMWwVwgAoPar5ICb8ZYbZAWAs1iC1Egj/r1zTTu
         ShdD3Xd737c/I7/EQz+U2H06Hq6gyUxmANIi1mvK78e2xsJiJgr8zYuxO0Jqg0APTXtu
         LyFnBR6Df+1xxO1A5s0e0/XznX0TiRFNIiSfxQnB3ZH1LixzpSAKaJ7z4GOpuohdt2YZ
         hTgQ==
X-Gm-Message-State: AOAM531X/v7Gs6N8LnyR1sfJc4RIaZ0CN9gl1rali+cI1dFJnCkPFPIg
        u6InL387tDFCC53PIZHHDjZACA==
X-Google-Smtp-Source: ABdhPJyhZPMV/JVASbPhZYWUvvWTHlMWbdSWvCWNUcXYOkDnLsz++l0fljwyUxPk+ksF+atBW3GdCQ==
X-Received: by 2002:ac8:51c7:: with SMTP id d7mr9020352qtn.302.1613073689253;
        Thu, 11 Feb 2021 12:01:29 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id 17sm4496243qtu.23.2021.02.11.12.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 12:01:28 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 00/11] Regression fixes/clean ups in the Qualcomm crypto engine driver
Date:   Thu, 11 Feb 2021 15:01:17 -0500
Message-Id: <20210211200128.2886388-1-thara.gopinath@linaro.org>
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

v6->v7:
	- Fixed sparse warning in patch 4 as pointed out by Herbert Xu.
	  This means the checking if any two keys are same for triple
	  des algorithms has been reverted back to using conditional OR
	  instead of using bitwise OR.
	- Rebased to 5.11-rc7.

v5->v6:
	- Return 0 for zero length messages instead of -EOPNOTSUPP in the
	  cipher algorithms as pointed out by Eric Biggers.
	- Remove the wrong TODO in patch 6 which implied that AES CBC can
	  do partial block sizes when it is actually CTS mode that can as
	  pointed out my Eric Biggers.

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
*** BLURB HERE ***

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
 drivers/crypto/qce/skcipher.c |  69 +++++++++++++---
 5 files changed, 126 insertions(+), 115 deletions(-)

-- 
2.25.1

