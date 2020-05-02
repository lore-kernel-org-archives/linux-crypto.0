Return-Path: <SRS0=ou8b=6Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF5FC47256
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 18:28:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D51221775
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 18:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588444116;
	bh=DIRRWMKKG6PuEZe/jxmnBQSb7EtQNzSmtDxFdL5Rd74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=iMW2lIKTlEdg44nNKMYP3+zYdHJVQAH0WBzeHj3obVAneDBVjVmOaXb/vMLb+bwNV
	 czp81fwQnF+V/oyjuD5pIxfWBQ12eT74UU2oDYLSO5ENlo55k2rgL0bBP8rLOe5rEA
	 W3U5WLEb3o0gG8GxT19vQlIuxMKHdgQBxwstkQ3c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgEBS2c (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 May 2020 14:28:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728418AbgEBS2I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 May 2020 14:28:08 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 010742075B;
        Sat,  2 May 2020 18:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588444088;
        bh=DIRRWMKKG6PuEZe/jxmnBQSb7EtQNzSmtDxFdL5Rd74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWqPGct5HDq0OUWPrgUsx7rK3tDbG+8sNdu4jJJYWt/+/yQ17tK0BnhXBcie2PqXc
         /px/lgw4jBC+9RANyujawdCzcMFCPhOtJ4Mpyc2v0BWrapwq5Dh/7u3Sbtzr22AUEA
         iEOcpPSkn9LnwYA0kldJJj4wxarmeqTpFW1Tmd7U=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Theodore Ts'o <tytso@mit.edu>, linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/7] crypto: powerpc/sha1 - remove unused temporary workspace
Date:   Sat,  2 May 2020 11:24:22 -0700
Message-Id: <20200502182427.104383-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200502182427.104383-1-ebiggers@kernel.org>
References: <20200502182427.104383-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The PowerPC implementation of SHA-1 doesn't actually use the 16-word
temporary array that's passed to the assembly code.  This was probably
meant to correspond to the 'W' array that lib/sha1.c uses.  However, in
sha1-powerpc-asm.S these values are actually stored in GPRs 16-31.

Referencing SHA_WORKSPACE_WORDS from this code also isn't appropriate,
since it's an implementation detail of lib/sha1.c.

Therefore, just remove this unneeded array.

Tested with:

	export ARCH=powerpc CROSS_COMPILE=powerpc-linux-gnu-
	make mpc85xx_defconfig
	cat >> .config << EOF
	# CONFIG_MODULES is not set
	# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
	CONFIG_DEBUG_KERNEL=y
	CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
	CONFIG_CRYPTO_SHA1_PPC=y
	EOF
	make olddefconfig
	make -j32
	qemu-system-ppc -M mpc8544ds -cpu e500 -nographic \
		-kernel arch/powerpc/boot/zImage \
		-append "cryptomgr.fuzz_iterations=1000 cryptomgr.panic_on_fail=1"

Cc: linuxppc-dev@lists.ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/powerpc/crypto/sha1.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/crypto/sha1.c b/arch/powerpc/crypto/sha1.c
index 7b43fc352089b1..db46b6130a9642 100644
--- a/arch/powerpc/crypto/sha1.c
+++ b/arch/powerpc/crypto/sha1.c
@@ -16,12 +16,11 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
 #include <asm/byteorder.h>
 
-extern void powerpc_sha_transform(u32 *state, const u8 *src, u32 *temp);
+void powerpc_sha_transform(u32 *state, const u8 *src);
 
 static int sha1_init(struct shash_desc *desc)
 {
@@ -47,7 +46,6 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 	src = data;
 
 	if ((partial + len) > 63) {
-		u32 temp[SHA_WORKSPACE_WORDS];
 
 		if (partial) {
 			done = -partial;
@@ -56,12 +54,11 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 		}
 
 		do {
-			powerpc_sha_transform(sctx->state, src, temp);
+			powerpc_sha_transform(sctx->state, src);
 			done += 64;
 			src = data + done;
 		} while (done + 63 < len);
 
-		memzero_explicit(temp, sizeof(temp));
 		partial = 0;
 	}
 	memcpy(sctx->buffer + partial, src, len - done);
-- 
2.26.2

