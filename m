Return-Path: <SRS0=xmdE=25=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9DAC00523
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 05:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C09FB20705
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 05:06:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="EMyNfvbX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgAHFGw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jan 2020 00:06:52 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34955 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgAHFGw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jan 2020 00:06:52 -0500
Received: by mail-pl1-f194.google.com with SMTP id g6so623862plt.2
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jan 2020 21:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mu0dUFTj4thZCkpGdg4/BDePJJdw2Ae9SQvJCvq1Dek=;
        b=EMyNfvbXJbFlHI38AQ1taZDy/DaQ57KejCvjq4TBFAd7EBiPVOG8Lq0NcHQXeDlloS
         v+L5zMYqDh0BXIap6exnZaxeabYAOxtmUbbBQzzfc4wWzrZwXrFjFy2ZSFV0vHSXImnK
         0xmSpCeYG4072Ej1iqRakVPX7cDHm0V5PP8OI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mu0dUFTj4thZCkpGdg4/BDePJJdw2Ae9SQvJCvq1Dek=;
        b=W3Xdhur3sDJjoKXj0KRhf61PXhhXE3ZLEPfUj5bKFQR4loXc2b85xi+kyccSgMGghj
         FUR/RLdawmsGeS8xGdahSQmCE+FzXT0K7Y69FY1DpTgCTqzpGhkLqQ0HlAVamKp1GEkq
         gmpGz/XMgMzBjb14Lq3JLhVFTvXK+hX+05znV7rdS9AvPYZOzjaDFjsMiVtYYkCn6wyz
         tfCaC9puyU97yrC8orVB5Y8xLlDvBe+HSObFG/Lv2BP0OmTLDxtTkvJy/JXY4t1EUghl
         kwn/o31XLMeECBFqFbT5YZrU+eWJrZ0SR2/cWX/XfyCuhUrkrQ/8E5q1xR+Hc/t9Y7gd
         SNqg==
X-Gm-Message-State: APjAAAVDoN5gfwqQcv3P765yKTSTnkQapBTyxUUDiYPFPge3trDVinrz
        AkClwjz7WTlDZUjLMxxQWdWsySLAvL4=
X-Google-Smtp-Source: APXvYqwkBYEyK68S9SHLHKUyyaqhbzeVR7yGXcITJnMiFqE2QG5yDtDU3anHiNjE+Vb5uW4lHNlSGQ==
X-Received: by 2002:a17:902:8343:: with SMTP id z3mr3438342pln.178.1578460011371;
        Tue, 07 Jan 2020 21:06:51 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-0092-67e7-3c5d-2c97.static.ipv6.internode.on.net. [2001:44b8:1113:6700:92:67e7:3c5d:2c97])
        by smtp.gmail.com with ESMTPSA id x132sm1380691pfc.148.2020.01.07.21.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 21:06:50 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     linuxppc-dev@lists.ozlabs.org, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Cc:     ardb@kernel.org, nayna@linux.ibm.com, pfsmorigo@gmail.com,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH] crypto: vmx/xts - reject inputs that are too short
Date:   Wed,  8 Jan 2020 16:06:46 +1100
Message-Id: <20200108050646.29220-1-dja@axtens.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When the kernel XTS implementation was extended to deal with ciphertext
stealing in commit 8083b1bf8163 ("crypto: xts - add support for ciphertext
stealing"), a check was added to reject inputs that were too short.

However, in the vmx enablement - commit 239668419349 ("crypto: vmx/xts -
use fallback for ciphertext stealing"), that check wasn't added to the
vmx implementation. This disparity leads to errors like the following:

alg: skcipher: p8_aes_xts encryption unexpectedly succeeded on test vector "random: len=0 klen=64"; expected_error=-22, cfg="random: inplace may_sleep use_finup src_divs=[<flush>66.99%@+10, 33.1%@alignmask+1155]"

Return -EINVAL if asked to operate with a cryptlen smaller than the AES
block size. This brings vmx in line with the generic implementation.

Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206049
Fixes: 239668419349 ("crypto: vmx/xts - use fallback for ciphertext stealing")
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
[dja: commit message]
Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 drivers/crypto/vmx/aes_xts.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/vmx/aes_xts.c b/drivers/crypto/vmx/aes_xts.c
index d59e736882f6..9fee1b1532a4 100644
--- a/drivers/crypto/vmx/aes_xts.c
+++ b/drivers/crypto/vmx/aes_xts.c
@@ -84,6 +84,9 @@ static int p8_aes_xts_crypt(struct skcipher_request *req, int enc)
 	u8 tweak[AES_BLOCK_SIZE];
 	int ret;
 
+	if (req->cryptlen < AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	if (!crypto_simd_usable() || (req->cryptlen % XTS_BLOCK_SIZE) != 0) {
 		struct skcipher_request *subreq = skcipher_request_ctx(req);
 
-- 
2.20.1

