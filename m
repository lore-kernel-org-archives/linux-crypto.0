Return-Path: <SRS0=z9QW=ZB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D2F2C43331
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 17:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2544E21924
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 17:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573319503;
	bh=q8m7tb7nKu7N21jk0OBTG9Au4VfKQokzsSa6de+RhW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=nUYNHBbTBAcI1CB7yPYDJQjl4KrLWq09ZbLvv6Z3ru0fn70PkjCXmwshykB38+nac
	 1utBX2NRXCSvLGHB6ckTrGFrMjRNNgS06hPLglWnY3f1QMA3Z73bJfBPSXn+OinCw/
	 zKnKsq9UwhwNFIlI1LRu2Sa350JsJQ6qrUtd3ibg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfKIRLm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 Nov 2019 12:11:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726609AbfKIRLm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 Nov 2019 12:11:42 -0500
Received: from e123331-lin.home (lfbn-mar-1-643-104.w90-118.abo.wanadoo.fr [90.118.215.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B20120659;
        Sat,  9 Nov 2019 17:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573319501;
        bh=q8m7tb7nKu7N21jk0OBTG9Au4VfKQokzsSa6de+RhW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToMbEfV0cMf+MKhqDwAkuyvErgw0umGSt51H6E6oBvANfdUl/T+Dp4q4MvG7iy8sM
         s3iV1JZ9nLn5Xw/PFxaCi1FFyKHqapGKhN8L4lr6vaSS9mobtB9J1gM6pUr3sGnhH9
         OljsUsw+N5TbmlWgihjitmfC5ZOV3DrQ+AEajJ/E=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 27/29] crypto: nx - remove stale comment referring to the blkcipher walk API
Date:   Sat,  9 Nov 2019 18:09:52 +0100
Message-Id: <20191109170954.756-28-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109170954.756-1-ardb@kernel.org>
References: <20191109170954.756-1-ardb@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

These drivers do not use either the deprecated blkcipher or the current
skcipher walk API, so this comment must refer to a previous state of the
driver that no longer exists. So drop the comments.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/crypto/nx/nx-aes-ccm.c | 5 -----
 drivers/crypto/nx/nx-aes-gcm.c | 5 -----
 2 files changed, 10 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-ccm.c b/drivers/crypto/nx/nx-aes-ccm.c
index 84fed736ed2e..4c9362eebefd 100644
--- a/drivers/crypto/nx/nx-aes-ccm.c
+++ b/drivers/crypto/nx/nx-aes-ccm.c
@@ -525,11 +525,6 @@ static int ccm_aes_nx_decrypt(struct aead_request *req)
 	return ccm_nx_decrypt(req, req->iv, req->assoclen);
 }
 
-/* tell the block cipher walk routines that this is a stream cipher by
- * setting cra_blocksize to 1. Even using blkcipher_walk_virt_block
- * during encrypt/decrypt doesn't solve this problem, because it calls
- * blkcipher_walk_done under the covers, which doesn't use walk->blocksize,
- * but instead uses this tfm->blocksize. */
 struct aead_alg nx_ccm_aes_alg = {
 	.base = {
 		.cra_name        = "ccm(aes)",
diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
index 898220e159d3..19c6ed5baea4 100644
--- a/drivers/crypto/nx/nx-aes-gcm.c
+++ b/drivers/crypto/nx/nx-aes-gcm.c
@@ -467,11 +467,6 @@ static int gcm4106_aes_nx_decrypt(struct aead_request *req)
 	return gcm_aes_nx_crypt(req, 0, req->assoclen - 8);
 }
 
-/* tell the block cipher walk routines that this is a stream cipher by
- * setting cra_blocksize to 1. Even using blkcipher_walk_virt_block
- * during encrypt/decrypt doesn't solve this problem, because it calls
- * blkcipher_walk_done under the covers, which doesn't use walk->blocksize,
- * but instead uses this tfm->blocksize. */
 struct aead_alg nx_gcm_aes_alg = {
 	.base = {
 		.cra_name        = "gcm(aes)",
-- 
2.17.1

