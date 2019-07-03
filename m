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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99321C0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 16:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F723218A4
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 16:27:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OD7BugQk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfGCQ1S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 12:27:18 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41783 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfGCQ1S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 12:27:18 -0400
Received: by mail-pf1-f196.google.com with SMTP id m30so1524007pff.8;
        Wed, 03 Jul 2019 09:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ryQ+KV6I+HBh6xV68vUzaQ/j84wovxLqLnfA8omtyrY=;
        b=OD7BugQkK23UKrAdvIBgZXB8LBubmLCFmJqY3b/p6UcRfTTiHWgohMCNNbEcDS2eeO
         FMrXFQu3ZXoniAXFlPJJPEohRbHY4OcQjgb4eWS9CJV8YP7gRCvVsJSh5ZpFmpWXg7s3
         MxjUhUOqBwYGq/ocXxEwR3EOns2s/1+e3zj2aA0+RSNEsL1kvBWX4062hFoErBOP56oH
         LZHN8Z0Y8vsOuygdEO56hD8aaN8IJL8KnKa74TTxLrJF9rbYRD9U7pRbN2zNuPsJPZ1j
         xk6bsxhqS5gboFfZwQfVsfcLBamqwIq/AoXRqYA/AxsfcF1YgXQUTbFLPa6p9jekVaGO
         CQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ryQ+KV6I+HBh6xV68vUzaQ/j84wovxLqLnfA8omtyrY=;
        b=s+3CLakpy8lZpFw+QJMWaYd9SWAn2zAsmix95WQsnQzYsbuWFPxD+OGhKO14449x+8
         EMwyaYjjmAH+Wh6XaBf6W3farN6nF6DevERq4aOswN1XVZOLYJ9PP9YZQbZij66ymNBk
         MszbZp+153w91WbGB/IBJs4iS59tVTt4emsaEb4w56qP3LyU16sk1gngUVEHahRw7tUT
         paJw3FNc4Caa/5hpm/xeM4fc+WQT+K0+cf4Jt280r/59ztfBUaPUt/MuTxOVUOVr2ie2
         MuxQRtLE41xu/isreql2m2iIXkSNrA54oMgW7/LBZR/lz7qOmrNsK+3Uo1Gdxy22fBrl
         KgdQ==
X-Gm-Message-State: APjAAAUABiDBnJZPBIxFXIvdgXrnYQqtex6y94YKcpnloAS206YuSlzZ
        3QKGxjjk1eB+XDLcdNrqmcw=
X-Google-Smtp-Source: APXvYqzXA1rOPPHweXD5XzmorpU7NYYzo6+KU07FLUuYqjhEoveOo9let3lwgDMUXOQvB3YNvDcZGA==
X-Received: by 2002:a65:60cc:: with SMTP id r12mr32890562pgv.333.1562171237362;
        Wed, 03 Jul 2019 09:27:17 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id s193sm3183112pgc.32.2019.07.03.09.27.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 09:27:16 -0700 (PDT)
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
Subject: [PATCH v2 06/35] crypto: Use kmemdup rather than duplicating its implementation
Date:   Thu,  4 Jul 2019 00:27:08 +0800
Message-Id: <20190703162708.32137-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

kmemdup is introduced to duplicate a region of memory in a neat way.
Rather than kmalloc/kzalloc + memcpy, which the programmer needs to
write the size twice (sometimes lead to mistakes), kmemdup improves
readability, leads to smaller code and also reduce the chances of mistakes.
Suggestion to use kmemdup rather than using kmalloc/kzalloc + memcpy.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
Changes in v2:
  - Fix a typo in commit message (memset -> memcpy)

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

