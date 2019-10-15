Return-Path: <SRS0=lMhp=YI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F94ECE58C
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 02:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D784E21925
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 02:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571107543;
	bh=rEgridOr8x0Q5MuTsLI43vItUDgIo4mn9nzaQ9Vl67w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Cd1Bc+dZaqciSs+w1o/6fds8cRbwmslvP5oAqjtI9m1GtM5VIzqhSkMGKGuLulcvT
	 Bdd+at9TnNGy8wxJc9LH5XSR4Dm8S+yN+07x2/tv4g3WNfF1FTZHEPhaonUSd6naB2
	 1FvfDIyI+RvmrJpc02vvz1ctMFdi5tvKAl9v+nRM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfJOCpn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 22:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727243AbfJOCpm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 22:45:42 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02830217F9;
        Tue, 15 Oct 2019 02:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571107542;
        bh=rEgridOr8x0Q5MuTsLI43vItUDgIo4mn9nzaQ9Vl67w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F96iiTbN+pwBwSuudvaRKiotVJp0wfe0Jic4ohAgo+DLyt2dJ/uAeAqplBMMVpIv+
         Hqe4aGidB8cMgFC2IZiaPU5f6NwBkfQ6kwOpN/sCjr7TZ/KYVbNh6t5fEougninXcY
         8UOSBpMpVUx2Iwdr9/deFzDazTEqvVXCLyZrubWU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Markus Stockhausen <stockhausen@collogia.de>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 1/3] crypto: powerpc - don't unnecessarily use atomic scatterwalk
Date:   Mon, 14 Oct 2019 19:45:15 -0700
Message-Id: <20191015024517.52790-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191015024517.52790-1-ebiggers@kernel.org>
References: <20191015024517.52790-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The PowerPC SPE implementations of AES modes only disable preemption
during the actual encryption/decryption, not during the scatterwalk
functions.  It's therefore unnecessary to request an atomic scatterwalk.
So don't do so.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/powerpc/crypto/aes-spe-glue.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/powerpc/crypto/aes-spe-glue.c b/arch/powerpc/crypto/aes-spe-glue.c
index 3a4ca7d32477..319f1dbb3a70 100644
--- a/arch/powerpc/crypto/aes-spe-glue.c
+++ b/arch/powerpc/crypto/aes-spe-glue.c
@@ -186,7 +186,6 @@ static int ppc_ecb_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	unsigned int ubytes;
 	int err;
 
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
 
@@ -214,7 +213,6 @@ static int ppc_ecb_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	unsigned int ubytes;
 	int err;
 
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
 
@@ -242,7 +240,6 @@ static int ppc_cbc_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	unsigned int ubytes;
 	int err;
 
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
 
@@ -270,7 +267,6 @@ static int ppc_cbc_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	unsigned int ubytes;
 	int err;
 
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
 
@@ -298,7 +294,6 @@ static int ppc_ctr_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	unsigned int pbytes, ubytes;
 	int err;
 
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt_block(desc, &walk, AES_BLOCK_SIZE);
 
@@ -329,7 +324,6 @@ static int ppc_xts_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	int err;
 	u32 *twk;
 
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
 	twk = ctx->key_twk;
@@ -360,7 +354,6 @@ static int ppc_xts_decrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 	int err;
 	u32 *twk;
 
-	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
 	twk = ctx->key_twk;
-- 
2.23.0

