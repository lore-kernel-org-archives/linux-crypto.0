Return-Path: <SRS0=tT4M=AV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FAEC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 06:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 218E52078B
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 06:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594362110;
	bh=ZfGuUxZZz6RO0lR3A8MY930nkonafEsFNdUgcMffvf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Ypmd0a+cWEYtwbZD2mT5/2IdBXTpviEZ3rzmJmHZpljJk/DPBhgOeouGdlPoWLe0z
	 OFmXdjkmp5xF3mQ+dDmduBzFME5CaV9TgOHf0uK5WtkluGq6g86cSAmmXfoxIuivjj
	 QB644qVp7bI7SFBHiAUh5shAxf0ZedJ42ncS34yY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725851AbgGJGVt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jul 2020 02:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgGJGVr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jul 2020 02:21:47 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14F95207DF;
        Fri, 10 Jul 2020 06:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594362107;
        bh=ZfGuUxZZz6RO0lR3A8MY930nkonafEsFNdUgcMffvf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wIsdsI/gGx17laq0eBSQr0FYWwfvIU0NZkm/oiDSG5KnznyM/1ezomhmzPurcAjdh
         EL3IEZjkdrp+Gv9k9BRMv/jUqbkpNFjUH2ixOGHCOqnwlBp7u2+ZDlQgW3Rcmsri2f
         Mp5djDLN+H2hzx1+Mg1rgMbgY5b5ot1vNT57O564=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org
Cc:     dm-devel@redhat.com
Subject: [PATCH v2 7/7] dm-crypt: don't use drivers that have CRYPTO_ALG_ALLOCATES_MEMORY
Date:   Thu,  9 Jul 2020 23:20:42 -0700
Message-Id: <20200710062042.113842-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200710062042.113842-1-ebiggers@kernel.org>
References: <20200710062042.113842-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

Don't use crypto drivers that have the flag CRYPTO_ALG_ALLOCATES_MEMORY
set. These drivers allocate memory and thus they are unsuitable for block
I/O processing.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 000ddfab5ba0..7268faacbdf3 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -421,7 +421,8 @@ static int crypt_iv_lmk_ctr(struct crypt_config *cc, struct dm_target *ti,
 		return -EINVAL;
 	}
 
-	lmk->hash_tfm = crypto_alloc_shash("md5", 0, 0);
+	lmk->hash_tfm = crypto_alloc_shash("md5", 0,
+					   CRYPTO_ALG_ALLOCATES_MEMORY);
 	if (IS_ERR(lmk->hash_tfm)) {
 		ti->error = "Error initializing LMK hash";
 		return PTR_ERR(lmk->hash_tfm);
@@ -583,7 +584,8 @@ static int crypt_iv_tcw_ctr(struct crypt_config *cc, struct dm_target *ti,
 		return -EINVAL;
 	}
 
-	tcw->crc32_tfm = crypto_alloc_shash("crc32", 0, 0);
+	tcw->crc32_tfm = crypto_alloc_shash("crc32", 0,
+					    CRYPTO_ALG_ALLOCATES_MEMORY);
 	if (IS_ERR(tcw->crc32_tfm)) {
 		ti->error = "Error initializing CRC32 in TCW";
 		return PTR_ERR(tcw->crc32_tfm);
@@ -770,7 +772,8 @@ static int crypt_iv_elephant_ctr(struct crypt_config *cc, struct dm_target *ti,
 	struct iv_elephant_private *elephant = &cc->iv_gen_private.elephant;
 	int r;
 
-	elephant->tfm = crypto_alloc_skcipher("ecb(aes)", 0, 0);
+	elephant->tfm = crypto_alloc_skcipher("ecb(aes)", 0,
+					      CRYPTO_ALG_ALLOCATES_MEMORY);
 	if (IS_ERR(elephant->tfm)) {
 		r = PTR_ERR(elephant->tfm);
 		elephant->tfm = NULL;
@@ -2090,7 +2093,8 @@ static int crypt_alloc_tfms_skcipher(struct crypt_config *cc, char *ciphermode)
 		return -ENOMEM;
 
 	for (i = 0; i < cc->tfms_count; i++) {
-		cc->cipher_tfm.tfms[i] = crypto_alloc_skcipher(ciphermode, 0, 0);
+		cc->cipher_tfm.tfms[i] = crypto_alloc_skcipher(ciphermode, 0,
+						CRYPTO_ALG_ALLOCATES_MEMORY);
 		if (IS_ERR(cc->cipher_tfm.tfms[i])) {
 			err = PTR_ERR(cc->cipher_tfm.tfms[i]);
 			crypt_free_tfms(cc);
@@ -2116,7 +2120,8 @@ static int crypt_alloc_tfms_aead(struct crypt_config *cc, char *ciphermode)
 	if (!cc->cipher_tfm.tfms)
 		return -ENOMEM;
 
-	cc->cipher_tfm.tfms_aead[0] = crypto_alloc_aead(ciphermode, 0, 0);
+	cc->cipher_tfm.tfms_aead[0] = crypto_alloc_aead(ciphermode, 0,
+						CRYPTO_ALG_ALLOCATES_MEMORY);
 	if (IS_ERR(cc->cipher_tfm.tfms_aead[0])) {
 		err = PTR_ERR(cc->cipher_tfm.tfms_aead[0]);
 		crypt_free_tfms(cc);
@@ -2603,7 +2608,7 @@ static int crypt_ctr_auth_cipher(struct crypt_config *cc, char *cipher_api)
 		return -ENOMEM;
 	strncpy(mac_alg, start, end - start);
 
-	mac = crypto_alloc_ahash(mac_alg, 0, 0);
+	mac = crypto_alloc_ahash(mac_alg, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
 	kfree(mac_alg);
 
 	if (IS_ERR(mac))
-- 
2.27.0

