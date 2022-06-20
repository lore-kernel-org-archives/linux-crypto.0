Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E53EAC43334
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jun 2022 07:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239599AbiFTHw5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jun 2022 03:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239493AbiFTHwz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jun 2022 03:52:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE47CC21
        for <linux-crypto@vger.kernel.org>; Mon, 20 Jun 2022 00:52:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 701BCB80EB2
        for <linux-crypto@vger.kernel.org>; Mon, 20 Jun 2022 07:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC883C3411B;
        Mon, 20 Jun 2022 07:52:49 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="OJ7nLigr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1655711567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QkaaaFSsEAIHmMB7bW5nH+R8SF0XEm/Unj8Mnxq+tWg=;
        b=OJ7nLigrEf8hgCqm3hhEEXN1YFAcVtyL+YEbKhyflIq1hPPIm3J8unt5pGuS75/UDn13cU
        I6CpQISPFjMOXHAO2nJ+fyMVd3FCsGwp0J+YzlpIa/yrI3mOg0JWtpIT8O5dFmoGZGzIbF
        R5jF9VFZR0EAO2NPiwYuD2pt+Y53QvE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0f3c2ca4 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 20 Jun 2022 07:52:47 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] lib/crypto: blake2s: reduce stack frame usage in self test
Date:   Mon, 20 Jun 2022 09:52:43 +0200
Message-Id: <20220620075243.686177-1-Jason@zx2c4.com>
In-Reply-To: <202206200851.gE3MHCgd-lkp@intel.com>
References: <202206200851.gE3MHCgd-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Using 3 blocks here doesn't give us much more than using 2, and it
causes a stack frame size warning on certain compiler/config/arch
combinations:

   lib/crypto/blake2s-selftest.c: In function 'blake2s_selftest':
>> lib/crypto/blake2s-selftest.c:632:1: warning: the frame size of 1088 bytes is larger than 1024 bytes [-Wframe-larger-than=]
     632 | }
         | ^

So this patch just reduces the block from 3 to 2, which makes the
warning go away.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/linux-crypto/202206200851.gE3MHCgd-lkp@intel.com
Fixes: 2d16803c562e ("crypto: blake2s - remove shash module")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 lib/crypto/blake2s-selftest.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/crypto/blake2s-selftest.c b/lib/crypto/blake2s-selftest.c
index 66f505220f43..7d77dea15587 100644
--- a/lib/crypto/blake2s-selftest.c
+++ b/lib/crypto/blake2s-selftest.c
@@ -593,7 +593,7 @@ bool __init blake2s_selftest(void)
 		enum { TEST_ALIGNMENT = 16 };
 		u8 unaligned_block[BLAKE2S_BLOCK_SIZE + TEST_ALIGNMENT - 1]
 					__aligned(TEST_ALIGNMENT);
-		u8 blocks[BLAKE2S_BLOCK_SIZE * 3];
+		u8 blocks[BLAKE2S_BLOCK_SIZE * 2];
 		struct blake2s_state state1, state2;
 
 		get_random_bytes(blocks, sizeof(blocks));
@@ -603,8 +603,8 @@ bool __init blake2s_selftest(void)
     defined(CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S)
 		memcpy(&state1, &state, sizeof(state1));
 		memcpy(&state2, &state, sizeof(state2));
-		blake2s_compress(&state1, blocks, 3, BLAKE2S_BLOCK_SIZE);
-		blake2s_compress_generic(&state2, blocks, 3, BLAKE2S_BLOCK_SIZE);
+		blake2s_compress(&state1, blocks, 2, BLAKE2S_BLOCK_SIZE);
+		blake2s_compress_generic(&state2, blocks, 2, BLAKE2S_BLOCK_SIZE);
 		if (memcmp(&state1, &state2, sizeof(state1))) {
 			pr_err("blake2s random compress self-test %d: FAIL\n",
 			       i + 1);
-- 
2.35.1

