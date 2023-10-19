Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF36C41513
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Oct 2023 05:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbjJSFyQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Oct 2023 01:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjJSFyO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2023 01:54:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8930C113
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 22:54:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDCFC433CA
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 05:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697694853;
        bh=tlNQT4pmclVG0jdMlLTdGJalZ4STs/Mv0X0OlOW1rOY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Wruq0AfELzjkCoArbHWp7jwAsQ37XYBKPAQ7L16D4s2wcHC0gt2MdZQzeXjvCGMZG
         xbFOf3e1rO9XKgB/dDFBt3tXBbYOH8jXVUbr95wyXlO5xS++BqkQggP4hwBdqBBEtl
         bOtEV6/ZKVnHMk5x/2BGr7MNgFBdasHj4NT5FFCHincaWOtosHA0pwCg+zc/jpRgH8
         9XdjtTtXIZuYCyUv1ZqexeZGTDEi+imddbXkQdnLgH7hdgbmj7Fnpdkq0FPV1f8TNA
         3VRKj7UkkE0xs6DqZ0oB56MOdLnaLqM0Cggrbp30oTnlduaj/wjQtDfObFkhN92+9a
         s5CrXZBA+/IfQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 03/17] crypto: xilinx/zynqmp-sha - remove unnecessary alignmask
Date:   Wed, 18 Oct 2023 22:53:29 -0700
Message-ID: <20231019055343.588846-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231019055343.588846-1-ebiggers@kernel.org>
References: <20231019055343.588846-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The zynqmp-sha3-384 algorithm sets a nonzero alignmask, but it doesn't
appear to actually need it.  Therefore, stop setting it.  This will
allow this algorithm to keep being registered after alignmask support is
removed from shash.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/xilinx/zynqmp-sha.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/xilinx/zynqmp-sha.c b/drivers/crypto/xilinx/zynqmp-sha.c
index 426bf1a72ba66..b0dbf6263b0db 100644
--- a/drivers/crypto/xilinx/zynqmp-sha.c
+++ b/drivers/crypto/xilinx/zynqmp-sha.c
@@ -175,21 +175,20 @@ static struct zynqmp_sha_drv_ctx sha3_drv_ctx = {
 		.digestsize = SHA3_384_DIGEST_SIZE,
 		.base = {
 			.cra_name = "sha3-384",
 			.cra_driver_name = "zynqmp-sha3-384",
 			.cra_priority = 300,
 			.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
 				     CRYPTO_ALG_ALLOCATES_MEMORY |
 				     CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize = SHA3_384_BLOCK_SIZE,
 			.cra_ctxsize = sizeof(struct zynqmp_sha_tfm_ctx),
-			.cra_alignmask = 3,
 			.cra_module = THIS_MODULE,
 		}
 	}
 };
 
 static int zynqmp_sha_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	int err;
 	u32 v;
-- 
2.42.0

