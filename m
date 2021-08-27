Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2C3C432BE
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Aug 2021 07:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 662DF60FE7
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Aug 2021 07:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244375AbhH0HEf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Aug 2021 03:04:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244378AbhH0HEf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Aug 2021 03:04:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDFF860FD8;
        Fri, 27 Aug 2021 07:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630047827;
        bh=u/CCoGP7rHcmiVsjQodakbOckmEN6EDWj5s8SDKFUe8=;
        h=From:To:Cc:Subject:Date:From;
        b=c+WRQMGGjVogelzvUKpWsDbD2RfGaowNVXzd+s2r3aiNwtk6rzluFJjnhXXZ/qCKI
         9Hkv6dhSsCDNCs7WuVKLsk01GAqxN8wsnCYk/nhMFbNY/S07UxRx1txcCs1jRhelZM
         VbNJrsmUlbW28urtM5bsrxtI2Jl6Rf5icC+MmIPC59mMb5/TV5//CiscwqgPBYOYeq
         q0C197ZOgow+L5j686xh2LmXgaWScFli3DytObEkUu48YBI0CxYzfEk2jeHRz0Nxs5
         oCvs3AI05S/qp3opM3mam9s6Rif/V74wP/4D0kXnAPM3usM6wkVw1q9fbIZgFFdGTh
         odaezDGSjvMLQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v7 0/7] running kernel mode SIMD with softirqs disabled
Date:   Fri, 27 Aug 2021 09:03:35 +0200
Message-Id: <20210827070342.218276-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
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

Changes since v6:
- add patch to yield the NEON every 4k of input when processing the AAD
- add some more acks from Eric

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

Ard Biesheuvel (7):
  crypto: arm64/gcm-aes-ce - remove non-SIMD fallback path
  crypto: arm64/aes-neonbs - stop using SIMD helper for skciphers
  crypto: arm64/aes-ce - stop using SIMD helper for skciphers
  crypto: arm64/aes-ccm - yield NEON when processing auth-only data
  crypto: arm64/aes-ccm - remove non-SIMD fallback path
  crypto: arm64/aes-ccm - reduce NEON begin/end calls for common case
  crypto: arm64/aes-ccm - avoid by-ref argument for ce_aes_ccm_auth_data

 arch/arm64/crypto/Kconfig           |   6 -
 arch/arm64/crypto/aes-ce-ccm-core.S |  24 +--
 arch/arm64/crypto/aes-ce-ccm-glue.c | 203 ++++++-------------
 arch/arm64/crypto/aes-glue.c        | 102 ++--------
 arch/arm64/crypto/aes-neonbs-glue.c | 122 +-----------
 arch/arm64/crypto/ghash-ce-glue.c   | 209 +++++---------------
 6 files changed, 148 insertions(+), 518 deletions(-)

-- 
2.30.2

