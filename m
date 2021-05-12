Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10930C43461
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C72F16023B
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhELVHk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 17:07:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245083AbhELSp6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 14:45:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24EDD61420;
        Wed, 12 May 2021 18:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620845085;
        bh=J6eG/Tivr3/Y2Z/S8213kPBZ77rTUXKnOT9enBbE7Oc=;
        h=From:To:Cc:Subject:Date:From;
        b=Ygmd5QSAS7glzvl3luYS7c+2eGEm+XXoD12V2eXIARjQqXChBmu9TPfU/yRnSgxdp
         MWTF2n3xZhBdN6J4XdcNQtdNA6ykEIfXvzoyyyIsdoIY7mmK2xAhJbbETCigUvcUzK
         jBFgvc7VHiaKAVKUGLRrWKrxliRTz25ogjS0+kdfNHJ0UYb83fvF8Cq4LOuvyk9pG0
         hy8G8YFbOp650HA+2EmV5b8V/7lpCF+ho9H6gQb9ivOebgf/ML8fT9UDipYVQH7xss
         cbAKWIFKeYx8kD1c5ylvspbgIaOl7kf4gJ7/hx0YM3sqaEfeLZ9wiMkoQF70uuBVU4
         IGFNADYUq771g==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v3 0/7] running kernel mode SIMD with softirqs disabled
Date:   Wed, 12 May 2021 20:44:32 +0200
Message-Id: <20210512184439.8778-1-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is a follow-up to [0], but given that the arm64 architectural
pieces have been merged for arm64, the only remaining changes are crypto
specific. Therefore, the audience has been reduced to those people who
are likely to care about these specifics.

Patch #1 addresses an issue in the skcipher walker which doesn't handle
zero sized AEAD inputs entirely consistently, which is uncovered by the
change in patch #7.

Patches #2 and #3 add some sanity checks to the public AEAD and skcipher
APIs to limit their availibility to either task or softirq context
(which is the only way in which they are currently being used). Adding
this restriction permits the arm64 crypto code to get rid of all scalar
fallbacks, given that on this architecture, softirqs are no longer
served while the SIMD unit is being used in kernel mode, which means
that the scalar fallbacks are never needed. These are removed in the
remaining 4 patches.

[0] https://lore.kernel.org/linux-arm-kernel/20210302090118.30666-1-ardb@kernel.org/

Ard Biesheuvel (7):
  crypto: handle zero sized AEAD inputs correctly
  crypto: aead - disallow en/decrypt for non-task or non-softirq context
  crypto: skcipher - disallow en/decrypt for non-task or non-softirq
    context
  crypto: arm64/gcm-aes-ce - remove non-SIMD fallback path
  crypto: arm64/aes-neonbs - stop using SIMD helper for skciphers
  crypto: arm64/aes-ce - stop using SIMD helper for skciphers
  crypto: arm64/aes-ccm - remove non-SIMD fallback path

 arch/arm64/crypto/Kconfig           |   6 -
 arch/arm64/crypto/aes-ce-ccm-core.S |   1 +
 arch/arm64/crypto/aes-ce-ccm-glue.c | 183 +++++------------
 arch/arm64/crypto/aes-glue.c        | 102 ++--------
 arch/arm64/crypto/aes-neonbs-glue.c | 122 +-----------
 arch/arm64/crypto/ghash-ce-glue.c   | 209 +++++---------------
 crypto/aead.c                       |  10 +
 crypto/skcipher.c                   |  12 ++
 8 files changed, 148 insertions(+), 497 deletions(-)

-- 
2.20.1

