Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EBE9CD68ED
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Oct 2023 06:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442179AbjJJGAU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Oct 2023 02:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442195AbjJJGAQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Oct 2023 02:00:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1795CB9
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 23:00:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52682C433CA
        for <linux-crypto@vger.kernel.org>; Tue, 10 Oct 2023 06:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696917613;
        bh=JQLbEoky/WavijC8Ug8Xy7HufpHsnSEqgvhAA5yjxw8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=jV69bAhXZzS3jA+H9zF6/ID+GsL0h1JNt6gzp8drX25cCIZEbDVcjmikAhEvXRLOk
         jKHTpVcwp8LEB11zC5Gutow11pgx1ocy8CL8mjWMTQFuin4JcUZ2Oes1ZeTx1PFTou
         cbEYiObvyVQ8TSpGMJIyKBgf3MpqHvhP6u04Azder7eocVk7HOIk6IhqNbvwLPjxWk
         KwwxLmRwivhDT4NVMC0zHjbFsCpTZFYTgbH0dSirEchoxE+1v+gW6qAZnIIwxtgINZ
         x7sE+buoV3MYgeAa9LfpEKZjOeI8r7J6FoiibUeHqRTi0BM2KGQZBrbIK32luIKA6J
         6kxRGECKjKVSw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 3/4] crypto: arm64/nhpoly1305 - implement ->digest
Date:   Mon,  9 Oct 2023 22:59:45 -0700
Message-ID: <20231010055946.263981-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231010055946.263981-1-ebiggers@kernel.org>
References: <20231010055946.263981-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Implement the ->digest method to improve performance on single-page
messages by reducing the number of indirect calls.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/nhpoly1305-neon-glue.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/crypto/nhpoly1305-neon-glue.c b/arch/arm64/crypto/nhpoly1305-neon-glue.c
index cd882c35d9252..e4a0b463f080e 100644
--- a/arch/arm64/crypto/nhpoly1305-neon-glue.c
+++ b/arch/arm64/crypto/nhpoly1305-neon-glue.c
@@ -27,30 +27,39 @@ static int nhpoly1305_neon_update(struct shash_desc *desc,
 
 		kernel_neon_begin();
 		crypto_nhpoly1305_update_helper(desc, src, n, nh_neon);
 		kernel_neon_end();
 		src += n;
 		srclen -= n;
 	} while (srclen);
 	return 0;
 }
 
+static int nhpoly1305_neon_digest(struct shash_desc *desc,
+				  const u8 *src, unsigned int srclen, u8 *out)
+{
+	return crypto_nhpoly1305_init(desc) ?:
+	       nhpoly1305_neon_update(desc, src, srclen) ?:
+	       crypto_nhpoly1305_final(desc, out);
+}
+
 static struct shash_alg nhpoly1305_alg = {
 	.base.cra_name		= "nhpoly1305",
 	.base.cra_driver_name	= "nhpoly1305-neon",
 	.base.cra_priority	= 200,
 	.base.cra_ctxsize	= sizeof(struct nhpoly1305_key),
 	.base.cra_module	= THIS_MODULE,
 	.digestsize		= POLY1305_DIGEST_SIZE,
 	.init			= crypto_nhpoly1305_init,
 	.update			= nhpoly1305_neon_update,
 	.final			= crypto_nhpoly1305_final,
+	.digest			= nhpoly1305_neon_digest,
 	.setkey			= crypto_nhpoly1305_setkey,
 	.descsize		= sizeof(struct nhpoly1305_state),
 };
 
 static int __init nhpoly1305_mod_init(void)
 {
 	if (!cpu_have_named_feature(ASIMD))
 		return -ENODEV;
 
 	return crypto_register_shash(&nhpoly1305_alg);
-- 
2.42.0

