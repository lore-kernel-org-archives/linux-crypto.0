Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0CF1C4332F
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Oct 2023 05:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjJ2FCA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Oct 2023 01:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjJ2FB7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Oct 2023 01:01:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD0AC5
        for <linux-crypto@vger.kernel.org>; Sat, 28 Oct 2023 22:01:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0155CC433C8;
        Sun, 29 Oct 2023 05:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698555717;
        bh=H3TBMwFvCfUQgoAGADY26kx++WBeBqiO7bxMskx7gEc=;
        h=From:To:Cc:Subject:Date:From;
        b=VuCBLEMNOHwXeidEirGT6xTXDB2Ob2Pq66i9fh0+ThmJdmlhzHufY71R6xija2WFV
         aad+OLamPGQ8qQQeQfFsIFOLCARklnzEy1udetiblVbRTPcQbXnwD644c0erqxdVj4
         h9I5u+oIa86KorcPCRoAFMhcS4RajaLGWA8JxKOf3gSaBYraBzQxoKPYy33xhPTDrG
         dZGW7WTRbi8vbdh65c8VB9UnCIpzKGkJaiMyGxewdyo7KxGpdyvgqs0ef2nUqIE/74
         4YXXsf0/38eCw1+NXSs7exhnaryGu/T0enrJB+OIVVGtc8yzH7J6b4Csj8RW4eXLtI
         O5GbgqWQNW7mw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-nvme@lists.infradead.org
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH] nvme-auth: use crypto_shash_tfm_digest()
Date:   Sat, 28 Oct 2023 22:00:40 -0700
Message-ID: <20231029050040.154563-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Simplify nvme_auth_augmented_challenge() by using
crypto_shash_tfm_digest() instead of an alloc+init+update+final
sequence.  This should also improve performance.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/nvme/common/auth.c | 23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index d90e4f0c08b7..54cffbc24b4a 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -324,21 +324,20 @@ static int nvme_auth_hash_skey(int hmac_id, u8 *skey, size_t skey_len, u8 *hkey)
 			 skey_len);
 
 	crypto_free_shash(tfm);
 	return ret;
 }
 
 int nvme_auth_augmented_challenge(u8 hmac_id, u8 *skey, size_t skey_len,
 		u8 *challenge, u8 *aug, size_t hlen)
 {
 	struct crypto_shash *tfm;
-	struct shash_desc *desc;
 	u8 *hashed_key;
 	const char *hmac_name;
 	int ret;
 
 	hashed_key = kmalloc(hlen, GFP_KERNEL);
 	if (!hashed_key)
 		return -ENOMEM;
 
 	ret = nvme_auth_hash_skey(hmac_id, skey,
 				  skey_len, hashed_key);
@@ -352,43 +351,25 @@ int nvme_auth_augmented_challenge(u8 hmac_id, u8 *skey, size_t skey_len,
 		ret = -EINVAL;
 		goto out_free_key;
 	}
 
 	tfm = crypto_alloc_shash(hmac_name, 0, 0);
 	if (IS_ERR(tfm)) {
 		ret = PTR_ERR(tfm);
 		goto out_free_key;
 	}
 
-	desc = kmalloc(sizeof(struct shash_desc) + crypto_shash_descsize(tfm),
-		       GFP_KERNEL);
-	if (!desc) {
-		ret = -ENOMEM;
-		goto out_free_hash;
-	}
-	desc->tfm = tfm;
-
 	ret = crypto_shash_setkey(tfm, hashed_key, hlen);
 	if (ret)
-		goto out_free_desc;
-
-	ret = crypto_shash_init(desc);
-	if (ret)
-		goto out_free_desc;
-
-	ret = crypto_shash_update(desc, challenge, hlen);
-	if (ret)
-		goto out_free_desc;
+		goto out_free_hash;
 
-	ret = crypto_shash_final(desc, aug);
-out_free_desc:
-	kfree_sensitive(desc);
+	ret = crypto_shash_tfm_digest(tfm, challenge, hlen, aug);
 out_free_hash:
 	crypto_free_shash(tfm);
 out_free_key:
 	kfree_sensitive(hashed_key);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nvme_auth_augmented_challenge);
 
 int nvme_auth_gen_privkey(struct crypto_kpp *dh_tfm, u8 dh_gid)
 {

base-commit: 2af9b20dbb39f6ebf9b9b6c090271594627d818e
-- 
2.42.0

