Return-Path: <SRS0=MAzA=AM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE5C4C433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 04:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB9D420747
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 04:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593579157;
	bh=ZfGuUxZZz6RO0lR3A8MY930nkonafEsFNdUgcMffvf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=zzakAncQXEWzWeYw+tl6MtuQkXQiSQwqVpL15sDeLbh0l9hzHdt4LsIp8cSIkk6Li
	 88qVM6c/QEFFBPH7l+mmIPLI5aRAjYGwFc0JWVMq2OWlZmi5zslk55eqJmJHq+G4IT
	 rkrXkhYM6QMaf4/dqjuJyYHb3b29Q7VrYGEfJ/zk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgGAEwc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 00:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbgGAEwb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 00:52:31 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F152207CD;
        Wed,  1 Jul 2020 04:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593579150;
        bh=ZfGuUxZZz6RO0lR3A8MY930nkonafEsFNdUgcMffvf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tR3Y9tddZ89baGPAYWgM/wgnJeXaZ5rpVq47z9gGuF/w72VEUlwEgmKvHsUxuVd0s
         Cdp+EN3EcVOzepkAywbvhtJrgnxO6L+/FMLWhHnhGypmuflHx/wVEYFHyWFhI1YdCc
         1SF9650CTpKD5HcBGBXcKaj2wb8l/IQsntKqk8uQ=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org
Cc:     dm-devel@redhat.com
Subject: [PATCH 6/6] dm-crypt: don't use drivers that have CRYPTO_ALG_ALLOCATES_MEMORY
Date:   Tue, 30 Jun 2020 21:52:17 -0700
Message-Id: <20200701045217.121126-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200701045217.121126-1-ebiggers@kernel.org>
References: <20200701045217.121126-1-ebiggers@kernel.org>
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

