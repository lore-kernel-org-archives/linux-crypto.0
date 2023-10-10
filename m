Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75AC9CD68F2
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Oct 2023 06:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442187AbjJJGAV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Oct 2023 02:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442192AbjJJGAQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Oct 2023 02:00:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF3ED6
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 23:00:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEF1C433C9
        for <linux-crypto@vger.kernel.org>; Tue, 10 Oct 2023 06:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696917613;
        bh=fxnyQGaJAUgHcUGlbMvpYCnb3x1vkdmKu/IODBTt3a4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Uwa2H7UW5gQ/ZwBH6i7y4hcoabyEF+wq07T7U16MPlz4qWed1Rh0tMyWdiQxssM+m
         j5/JvnPZkjPZ3BkAcbiOHnNKsU3F4p7mfEmqVkg2ACtQbJpTQyOcoPigva7BbZ2kTV
         zAv2Vacb+7TIswBVSApx/eEHWMjJxG7z3/kpxQAMG4oBEFr647imFhfUTZCIbbCqan
         TYNcfaWdWFzKSohn67mcqcwMJb46IfcsdFv60gnNTGCDSHHwvpLQvDHZfiImqObZoG
         KM1PEc/0JUGmVUcEMbcMVrGjljanXMeBmzm284+KofZd1GasNAacmHCgi9bjhK6Jwr
         NMvUJPOUMGaaw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 2/4] crypto: arm/nhpoly1305 - implement ->digest
Date:   Mon,  9 Oct 2023 22:59:44 -0700
Message-ID: <20231010055946.263981-3-ebiggers@kernel.org>
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
 arch/arm/crypto/nhpoly1305-neon-glue.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/crypto/nhpoly1305-neon-glue.c b/arch/arm/crypto/nhpoly1305-neon-glue.c
index e93e41ff26566..62cf7ccdde736 100644
--- a/arch/arm/crypto/nhpoly1305-neon-glue.c
+++ b/arch/arm/crypto/nhpoly1305-neon-glue.c
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
 	if (!(elf_hwcap & HWCAP_NEON))
 		return -ENODEV;
 
 	return crypto_register_shash(&nhpoly1305_alg);
-- 
2.42.0

