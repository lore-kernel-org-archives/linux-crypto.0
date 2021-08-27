Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4132FC4320E
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Aug 2021 07:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CB9260FE6
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Aug 2021 07:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244235AbhH0HEm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Aug 2021 03:04:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244378AbhH0HEm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Aug 2021 03:04:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9251A60FDA;
        Fri, 27 Aug 2021 07:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630047833;
        bh=sLIzRDneiqENH/YHWMThBLYK3jPTozGBrqboWLXHwzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCgk/ESIk3S0OG+95k8UNYZ4RuXiTZ4bHL+YPTNuxYynlgt2SHuYqRSC175BokYTL
         yENCAiz5VdFwH+HWznhE8NBDTqcg9ydFm9HJk4mBcfLrgg/97ok66RqPGId9r96BN8
         T8kJDHdzt6e2wXeFwKIQwzlZNttmXHl0Nn0w/qUyBXuh+qBmbTuFgk5oweWDzqCyMx
         d1bKZ5wcbRTNJGolN9JqFdGqWsCubcNNjDKt6ke1A5B6sIml0iVpwgBusc4X1Xk42s
         B3PlyxrMsOron+n4iTocG/z25gpdRSpHEjcT2Wxybw7iu+++kR18xkVMqojnTTseYv
         aGn+JNeUHluXw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v7 4/7] crypto: arm64/aes-ccm - yield NEON when processing auth-only data
Date:   Fri, 27 Aug 2021 09:03:39 +0200
Message-Id: <20210827070342.218276-5-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210827070342.218276-1-ardb@kernel.org>
References: <20210827070342.218276-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In SIMD accelerated crypto drivers, we typically yield the SIMD unit
after processing 4 KiB of input, to avoid scheduling blackouts caused by
the fact that claiming the SIMD unit disables preemption as well as
softirq processing.

The arm64 CCM driver does this implicitly for the ciphertext, due to the
fact that the skcipher API never processes more than a single page at a
time. However, the scatterwalk performed by this driver when processing
the authenticate-only data will keep the SIMD unit occupied until it
completes.

So cap the scatterwalk steps to 4 KiB.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-glue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index f6d19b0dc893..fe9c837ac4b9 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -161,6 +161,7 @@ static void ccm_calculate_auth_mac(struct aead_request *req, u8 mac[])
 			scatterwalk_start(&walk, sg_next(walk.sg));
 			n = scatterwalk_clamp(&walk, len);
 		}
+		n = min_t(u32, n, SZ_4K); /* yield NEON at least every 4k */
 		p = scatterwalk_map(&walk);
 		ccm_update_mac(ctx, mac, p, n, &macp);
 		len -= n;
-- 
2.30.2

