Return-Path: <SRS0=s5hs=P3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 591A0C5AE5E
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Jan 2019 02:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21DD92087E
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Jan 2019 02:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547864841;
	bh=xT3nyrd+hpW3a/FJNvmdTaQvEwzBgNdTXeonqCgY4YI=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=kHe1PaFXmBj5XAbytIaCbcDL1qvCWIN8wnUOZGGb4Gezz0is7LZJRkCmmD7vds2D1
	 7nrrgJCHJzHXjWKJHjUDjiXf3FAsZYfq/KBXkadjhLdtal0bryqIc/Otuc2Esys7ZX
	 JyqJzH6Ly/g7mn+jmTnuWPszkotLUW9x8x+e23gI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbfASC1U (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Jan 2019 21:27:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729624AbfASC1U (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 21:27:20 -0500
Received: from sol.localdomain (c-24-23-143-129.hsd1.ca.comcast.net [24.23.143.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4181520850;
        Sat, 19 Jan 2019 02:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547864839;
        bh=xT3nyrd+hpW3a/FJNvmdTaQvEwzBgNdTXeonqCgY4YI=;
        h=From:To:Cc:Subject:Date:From;
        b=ZXc3jEMm5rAZzLXluAlGEeKPoE9Ay5vm4zBa+wzuF5nUuGLcYhncJk/tGNT5xTqfl
         cEOswFbl/8z8F/92mniSTsgnGfkRDC/bnLdNiF59rYphg80/CVDk0dSr1qIOjRV38l
         EQZQ4OFzVJ0DaEpfJ5p7++lGvWqZVfS0UX5Rj+8s=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Rob Rice <rob.rice@broadcom.com>
Subject: [PATCH] crypto: bcm - remove unused function do_decrypt()
Date:   Fri, 18 Jan 2019 18:26:42 -0800
Message-Id: <20190119022642.6985-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The do_decrypt() function in util.c in the BCM crypto driver is never
used, so remove it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/bcm/util.c | 40 ---------------------------------------
 drivers/crypto/bcm/util.h |  6 ------
 2 files changed, 46 deletions(-)

diff --git a/drivers/crypto/bcm/util.c b/drivers/crypto/bcm/util.c
index a912c6ad3e850..d8cda5fb75ad8 100644
--- a/drivers/crypto/bcm/util.c
+++ b/drivers/crypto/bcm/util.c
@@ -201,46 +201,6 @@ struct sdesc {
 	char ctx[];
 };
 
-/* do a synchronous decrypt operation */
-int do_decrypt(char *alg_name,
-	       void *key_ptr, unsigned int key_len,
-	       void *iv_ptr, void *src_ptr, void *dst_ptr,
-	       unsigned int block_len)
-{
-	struct scatterlist sg_in[1], sg_out[1];
-	struct crypto_blkcipher *tfm =
-	    crypto_alloc_blkcipher(alg_name, 0, CRYPTO_ALG_ASYNC);
-	struct blkcipher_desc desc = {.tfm = tfm, .flags = 0 };
-	int ret = 0;
-	void *iv;
-	int ivsize;
-
-	flow_log("%s() name:%s block_len:%u\n", __func__, alg_name, block_len);
-
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
-
-	crypto_blkcipher_setkey((void *)tfm, key_ptr, key_len);
-
-	sg_init_table(sg_in, 1);
-	sg_set_buf(sg_in, src_ptr, block_len);
-
-	sg_init_table(sg_out, 1);
-	sg_set_buf(sg_out, dst_ptr, block_len);
-
-	iv = crypto_blkcipher_crt(tfm)->iv;
-	ivsize = crypto_blkcipher_ivsize(tfm);
-	memcpy(iv, iv_ptr, ivsize);
-
-	ret = crypto_blkcipher_decrypt(&desc, sg_out, sg_in, block_len);
-	crypto_free_blkcipher(tfm);
-
-	if (ret < 0)
-		pr_err("aes_decrypt failed %d\n", ret);
-
-	return ret;
-}
-
 /**
  * do_shash() - Do a synchronous hash operation in software
  * @name:       The name of the hash algorithm
diff --git a/drivers/crypto/bcm/util.h b/drivers/crypto/bcm/util.h
index 712e029795f86..15c60356518ae 100644
--- a/drivers/crypto/bcm/util.h
+++ b/drivers/crypto/bcm/util.h
@@ -95,12 +95,6 @@ u32 spu_msg_sg_add(struct scatterlist **to_sg,
 
 void add_to_ctr(u8 *ctr_pos, unsigned int increment);
 
-/* do a synchronous decrypt operation */
-int do_decrypt(char *alg_name,
-	       void *key_ptr, unsigned int key_len,
-	       void *iv_ptr, void *src_ptr, void *dst_ptr,
-	       unsigned int block_len);
-
 /* produce a message digest from data of length n bytes */
 int do_shash(unsigned char *name, unsigned char *result,
 	     const u8 *data1, unsigned int data1_len,
-- 
2.20.1

