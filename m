Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC90C25B43
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbjJVISs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbjJVISq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B94CF
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3CAC433CC
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962724;
        bh=Xxrz1naAot6FqR/QVk1c1Y/+JuFedk9AZ4iYx6yrmC4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ospeMnJxYdMITQ6sRmkoqkaRkYQ+AZUGlYevXnqodQVbfWvC1TMrJ5wJgqoUu4AXe
         OXGuFQX5PJ4CSF3Bkxn6I486sBMqzfq7CUybSt2ESJToQgaoBo/gLEmSaqfOqMKrZG
         LpUbnzVIWFeWt39mMq4XVwZGsivaCHOkGnMpnHN+VPMsJBJlSt4fcVMsAMEaxoYMOJ
         TSaVlk2EcIbxEcZvEH3oGQcjqZ1HQRiWXiQ03HsXwEW2bebmsN85YnyIADDXs+syyV
         LMwODyUfa3aQ3jWeIVU7y8RoY3QEKVVXOm3UBfGG7anJxvVGe+uC2nsrP+KdQsqntG
         i+RsW2po/pqaA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 05/30] crypto: atmel - remove unnecessary alignmask for ahashes
Date:   Sun, 22 Oct 2023 01:10:35 -0700
Message-ID: <20231022081100.123613-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231022081100.123613-1-ebiggers@kernel.org>
References: <20231022081100.123613-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The crypto API's support for alignmasks for ahash algorithms is nearly
useless, as its only effect is to cause the API to align the key and
result buffers.  The drivers that happen to be specifying an alignmask
for ahash rarely actually need it.  When they do, it's easily fixable,
especially considering that these buffers cannot be used for DMA.

In preparation for removing alignmask support from ahash, this patch
makes the atmel driver no longer use it.  This driver didn't actually
rely on it; it only writes to the result buffer in
atmel_sha_copy_ready_hash(), simply using memcpy().  And this driver
didn't set an alignmask for any keyed hash algorithms, so the key buffer
need not be considered.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/atmel-sha.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 3622120add625..6cd3fc493027a 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1293,29 +1293,27 @@ static struct ahash_alg sha_224_alg = {
 	.halg.base.cra_blocksize	= SHA224_BLOCK_SIZE,
 
 	.halg.digestsize = SHA224_DIGEST_SIZE,
 };
 
 static struct ahash_alg sha_384_512_algs[] = {
 {
 	.halg.base.cra_name		= "sha384",
 	.halg.base.cra_driver_name	= "atmel-sha384",
 	.halg.base.cra_blocksize	= SHA384_BLOCK_SIZE,
-	.halg.base.cra_alignmask	= 0x3,
 
 	.halg.digestsize = SHA384_DIGEST_SIZE,
 },
 {
 	.halg.base.cra_name		= "sha512",
 	.halg.base.cra_driver_name	= "atmel-sha512",
 	.halg.base.cra_blocksize	= SHA512_BLOCK_SIZE,
-	.halg.base.cra_alignmask	= 0x3,
 
 	.halg.digestsize = SHA512_DIGEST_SIZE,
 },
 };
 
 static void atmel_sha_queue_task(unsigned long data)
 {
 	struct atmel_sha_dev *dd = (struct atmel_sha_dev *)data;
 
 	atmel_sha_handle_queue(dd, NULL);
-- 
2.42.0

