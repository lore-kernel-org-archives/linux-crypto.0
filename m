Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 761A3C47088
	for <linux-crypto@archiver.kernel.org>; Wed, 26 May 2021 10:07:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55AF261355
	for <linux-crypto@archiver.kernel.org>; Wed, 26 May 2021 10:07:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhEZKJH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 May 2021 06:09:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233771AbhEZKJF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 May 2021 06:09:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FF1B610C7;
        Wed, 26 May 2021 10:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622023654;
        bh=wVLK+SA4YYEJiI1CuzFzq8CqiUL4K4pTwNzHQeI/tto=;
        h=From:To:Cc:Subject:Date:From;
        b=nPqlnVRW361vuZXf/1wA324CXtKD8whR0WMx4g5Pd6zYiknqyebxV+KrKQujsnWiP
         lV8EJ6OfG/ni0yh8Nwhqxu+gWhK8wrXumb9t03Dt3CvQTq22n74Piia5ugzkvHxB/W
         u13F10OaP7PyiVvT7dsqJnwpRgjjE6jdwvmaGhhaNK0t8zMf9e8niBr3YNqXZiy+rd
         zCcc1QSLgtPVM4o2jfiWf1rn896veZGSfw9cCZ9VByi3+NY3ygQDY8CVrISap7TTz2
         hro2TsMpciAjFbTvh1yGj4JICjkN4bZrbBSXVJdCDZ6cgMz2shsk2Uqq+GvSsF26u3
         L73tfT0X72+/g==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v6 0/6] running kernel mode SIMD with softirqs disabled
Date:   Wed, 26 May 2021 12:07:23 +0200
Message-Id: <20210526100729.12939-1-ardb@kernel.org>
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

Changes since v5:
- add Eric's R-b to patches #1 to #3
- split CCM changes into 3 separate patches

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

Ard Biesheuvel (6):
  crypto: arm64/gcm-aes-ce - remove non-SIMD fallback path
  crypto: arm64/aes-neonbs - stop using SIMD helper for skciphers
  crypto: arm64/aes-ce - stop using SIMD helper for skciphers
  crypto: arm64/aes-ccm - remove non-SIMD fallback path
  crypto: arm64/aes-ccm - reduce NEON begin/end calls for common case
  crypto: arm64/aes-ccm - avoid by-ref argument for ce_aes_ccm_auth_data

 arch/arm64/crypto/Kconfig           |   6 -
 arch/arm64/crypto/aes-ce-ccm-core.S |  24 +--
 arch/arm64/crypto/aes-ce-ccm-glue.c | 196 ++++++------------
 arch/arm64/crypto/aes-glue.c        | 102 ++--------
 arch/arm64/crypto/aes-neonbs-glue.c | 122 +-----------
 arch/arm64/crypto/ghash-ce-glue.c   | 209 +++++---------------
 6 files changed, 141 insertions(+), 518 deletions(-)

-- 
2.20.1

