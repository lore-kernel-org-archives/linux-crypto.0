Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C57C433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 10:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B38A613BD
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 10:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbhEUKWa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 06:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231186AbhEUKW2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 06:22:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26BA76135C;
        Fri, 21 May 2021 10:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621592465;
        bh=N+w5QEO42mQlB9ymFmNmNrF3+V7f2xlncBeYmpsHWVs=;
        h=From:To:Cc:Subject:Date:From;
        b=tttVzajuy000G2FpHHokr6dTFG+sWZTx/MuVQO5Lr/P66zqYVA8/48HkDisGWhqla
         RTVGySsnv3LWGWeWLDXxXX60aVdCKjVHfpHuKPMwyTFh/Ctt/MkHqdqMI42b6maKXs
         EIpa/c8bYWJpq8jKFeantHrmroOr+rVoLfcxbe6DvjrETvJaRUs0jATQQeXQzLiwjO
         RGcROk8y8FOiccMFCfkCpTpWe4eUGGQ81Amip+VsEvWhrMnaKq6Txg/SiShzZOOFXG
         MemreCEArfNOJn+rgL1We0mOrMT/suTOOUdbXtnmZRZYPHoyrFH5hS39lUmwwSo7dM
         nxhXyk/iZvRiw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v5 0/5] running kernel mode SIMD with softirqs disabled
Date:   Fri, 21 May 2021 12:20:48 +0200
Message-Id: <20210521102053.66609-1-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is a follow-up to [0], but given that the arm64 architectural
pieces have been merged for arm64, the only remaining changes are crypto
specific. Therefore, the audience has been reduced to those people who
are somewhat more likely to care about these specifics.

The AEAD and skcipher APIs may only be called from task or softirq
context. This permits the arm64 AEAD and skcipher code to get rid of all
scalar fallbacks, given that on this architecture, softirqs are now no
longer served while the SIMD unit is being used in kernel mode, which
means that the scalar fallbacks are never needed. These are removed in
this series.

Changes since v4:
- drop skcipher_walk layer change to deal with zero sized walks
- drop aead/skcipher layer sanity checks on invocations from hardirq
  context
- add patch to clean up CCM a bit more after removing the SIMD code path

Changes since v3:
- clarify the nature of the issue addressed by patch #1, and apply the
  same fix to the skcipher walker
- update patches #2 and #3 so that the failures can be observed by the
  crypto stats code

[0] https://lore.kernel.org/linux-arm-kernel/20210302090118.30666-1-ardb@kernel.org/

Ard Biesheuvel (5):
  crypto: arm64/gcm-aes-ce - remove non-SIMD fallback path
  crypto: arm64/aes-neonbs - stop using SIMD helper for skciphers
  crypto: arm64/aes-ce - stop using SIMD helper for skciphers
  crypto: arm64/aes-ccm - remove non-SIMD fallback path
  crypto: arm64/aes-ccm - avoid by-ref argument for ce_aes_ccm_auth_data

 arch/arm64/crypto/Kconfig           |   6 -
 arch/arm64/crypto/aes-ce-ccm-core.S |  24 +--
 arch/arm64/crypto/aes-ce-ccm-glue.c | 194 ++++++------------
 arch/arm64/crypto/aes-glue.c        | 102 ++--------
 arch/arm64/crypto/aes-neonbs-glue.c | 122 +-----------
 arch/arm64/crypto/ghash-ce-glue.c   | 209 +++++---------------
 6 files changed, 141 insertions(+), 516 deletions(-)

-- 
2.20.1

