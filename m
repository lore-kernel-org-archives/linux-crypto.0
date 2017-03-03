From: Daniel Axtens <dja@axtens.net>
Subject: [PATCH] crypto: powerpc - Fix initialisation of crc32c context
Date: Fri,  3 Mar 2017 17:56:55 +1100
Message-ID: <20170303065655.7317-1-dja@axtens.net>
Cc: anton@samba.org, Daniel Axtens <dja@axtens.net>
To: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36003 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751250AbdCCG5i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Mar 2017 01:57:38 -0500
Received: by mail-pf0-f196.google.com with SMTP id j5so9070892pfb.3
        for <linux-crypto@vger.kernel.org>; Thu, 02 Mar 2017 22:57:06 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Turning on crypto self-tests on a POWER8 shows:

    alg: hash: Test 1 failed for crc32c-vpmsum
    00000000: ff ff ff ff

Comparing the code with the Intel CRC32c implementation on which
ours is based shows that we are doing an init with 0, not ~0
as CRC32c requires.

This probably wasn't caught because btrfs does its own weird
open-coded initialisation.

Initialise our internal context to ~0 on init.

This makes the self-tests pass, and btrfs continues to work.

Fixes: 6dd7a82cc54e ("crypto: powerpc - Add POWER8 optimised crc32c")
Cc: Anton Blanchard <anton@samba.org>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 arch/powerpc/crypto/crc32c-vpmsum_glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/crypto/crc32c-vpmsum_glue.c b/arch/powerpc/crypto/crc32c-vpmsum_glue.c
index 9fa046d56eba..411994551afc 100644
--- a/arch/powerpc/crypto/crc32c-vpmsum_glue.c
+++ b/arch/powerpc/crypto/crc32c-vpmsum_glue.c
@@ -52,7 +52,7 @@ static int crc32c_vpmsum_cra_init(struct crypto_tfm *tfm)
 {
 	u32 *key = crypto_tfm_ctx(tfm);
 
-	*key = 0;
+	*key = ~0;
 
 	return 0;
 }
-- 
2.9.3
