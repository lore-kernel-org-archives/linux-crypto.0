Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 848CFC0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 13:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54F50218A3
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 13:14:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DGEIzb1k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfGCNOM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 09:14:12 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36628 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCNOM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 09:14:12 -0400
Received: by mail-pg1-f195.google.com with SMTP id c13so1246420pgg.3;
        Wed, 03 Jul 2019 06:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jBkyRyPJyPqYCM7LVKEeTlHKLt/amBJBKugaRL0hZwE=;
        b=DGEIzb1kDhOG9CcvmiofF51lt2Oy3LBkNSFVAyi4SdU9RMsBh0V1qV3pYI6gzIFB8X
         +WZiD2cNpLTG6ASxIPJoB6W9KZ8x9u3XWIq6xQ5/cCqfLU0qAabCO+U8SgkkG5/PqTU5
         Lovz+MSpHRrvjqqgJA38Bsdj382YQcZMoCvqtrg7iiSLesFNpkm1c4zOtzq0oYTCx6/k
         qiNsgR+HsMpilCWODBGJkZ6egXasBuP0QuE1ocEyk5w3eQpaoWc/AxbqQP4DitTn0jnH
         HW/DWB1U2qZl4BE15Ydo3bxKTaJFrrZBJrDox1CXPCEE49MphuvrE9tT8caMvlQb/f01
         dTzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jBkyRyPJyPqYCM7LVKEeTlHKLt/amBJBKugaRL0hZwE=;
        b=gdccX6cS/M5ng8hZF5+1RC9ZqqKYkn+JV8dheADo1HJ1PkZ932dra6tlL0G0lY1h3m
         jI3Dfe8ERyaQzhtraku58K+UyRliSYcdaAxgR/1HnyuTRj619q3Hh/oZ35A0ouEDZ0uo
         9Itt+QDIEkDLL4qnXgeOy8cCSdfu03Kby9TWlM6DbeS1GeqRKc+64zPoxvFbK1fQPt7F
         +L90nQt2UVjAqreXUiKv+gwSbBO9fczUeMQmjuI7WSpXHrRTqSpD5Dtcu22jX6/zXGyn
         3n6De9YbGYzSMgGDB6YJEveAA81PwAQRYVX2v2XfSNlM0Nlxnnk051HnGAV22XpofK9K
         f4BQ==
X-Gm-Message-State: APjAAAVrnzxr6pwzANlyYaPyHwfqxvGmKVMQxAwf9Z8BGb4IFtDTwJg5
        ka/HIVLS+w3rKPpCbVA9Yb8=
X-Google-Smtp-Source: APXvYqyEZ8G/Ytxhng2bseN0byMkFtJdOYaPxiWptFTsBwFatUfS+q+t/spJFJj85TPYnm1YL2gsvA==
X-Received: by 2002:a17:90a:ad41:: with SMTP id w1mr12692927pjv.52.1562159651356;
        Wed, 03 Jul 2019 06:14:11 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id q98sm903544pjq.20.2019.07.03.06.14.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 06:14:11 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Gonglei <arei.gonglei@huawei.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 05/30] crypto: Use kmemdup rather than duplicating its implementation
Date:   Wed,  3 Jul 2019 21:13:58 +0800
Message-Id: <20190703131358.24901-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

kmemdup is introduced to duplicate a region of memory in a neat way.
Rather than kmalloc/kzalloc + memset, which the programmer needs to
write the size twice (sometimes lead to mistakes), kmemdup improves
readability, leads to smaller code and also reduce the chances of mistakes.
Suggestion to use kmemdup rather than using kmalloc/kzalloc + memset.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/crypto/caam/caampkc.c              | 11 +++--------
 drivers/crypto/virtio/virtio_crypto_algs.c |  4 +---
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index fe24485274e1..a03464b4c019 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -816,7 +816,7 @@ static int caam_rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
 		return ret;
 
 	/* Copy key in DMA zone */
-	rsa_key->e = kzalloc(raw_key.e_sz, GFP_DMA | GFP_KERNEL);
+	rsa_key->e = kmemdup(raw_key.e, raw_key.e_sz, GFP_DMA | GFP_KERNEL);
 	if (!rsa_key->e)
 		goto err;
 
@@ -838,8 +838,6 @@ static int caam_rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
 	rsa_key->e_sz = raw_key.e_sz;
 	rsa_key->n_sz = raw_key.n_sz;
 
-	memcpy(rsa_key->e, raw_key.e, raw_key.e_sz);
-
 	return 0;
 err:
 	caam_rsa_free_key(rsa_key);
@@ -920,11 +918,11 @@ static int caam_rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
 		return ret;
 
 	/* Copy key in DMA zone */
-	rsa_key->d = kzalloc(raw_key.d_sz, GFP_DMA | GFP_KERNEL);
+	rsa_key->d = kmemdup(raw_key.d, raw_key.d_sz, GFP_DMA | GFP_KERNEL);
 	if (!rsa_key->d)
 		goto err;
 
-	rsa_key->e = kzalloc(raw_key.e_sz, GFP_DMA | GFP_KERNEL);
+	rsa_key->e = kmemdup(raw_key.e, raw_key.e_sz, GFP_DMA | GFP_KERNEL);
 	if (!rsa_key->e)
 		goto err;
 
@@ -947,9 +945,6 @@ static int caam_rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
 	rsa_key->e_sz = raw_key.e_sz;
 	rsa_key->n_sz = raw_key.n_sz;
 
-	memcpy(rsa_key->d, raw_key.d, raw_key.d_sz);
-	memcpy(rsa_key->e, raw_key.e, raw_key.e_sz);
-
 	caam_rsa_set_priv_key_form(ctx, &raw_key);
 
 	return 0;
diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index 10f266d462d6..42d19205166b 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -129,13 +129,11 @@ static int virtio_crypto_alg_ablkcipher_init_session(
 	 * Avoid to do DMA from the stack, switch to using
 	 * dynamically-allocated for the key
 	 */
-	uint8_t *cipher_key = kmalloc(keylen, GFP_ATOMIC);
+	uint8_t *cipher_key = kmemdup(key, keylen, GFP_ATOMIC);
 
 	if (!cipher_key)
 		return -ENOMEM;
 
-	memcpy(cipher_key, key, keylen);
-
 	spin_lock(&vcrypto->ctrl_lock);
 	/* Pad ctrl header */
 	vcrypto->ctrl.header.opcode =
-- 
2.11.0

