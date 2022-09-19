Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5973EC54EE9
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Sep 2022 07:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiISHwW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Sep 2022 03:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiISHwV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Sep 2022 03:52:21 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83EC186FD
        for <linux-crypto@vger.kernel.org>; Mon, 19 Sep 2022 00:52:19 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ge9so15454125pjb.1
        for <linux-crypto@vger.kernel.org>; Mon, 19 Sep 2022 00:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=GTvbctvJNpJ5XFFAVjSyyK1oKWoGjmVgAKwPqHF7qTs=;
        b=rdAsr8pAkyV2pMx5d7GRQyk06KkZ4Hl2uYy+U8EVqK3K7MWt1wweat9xR1Ybh0GWYV
         TwXknqO5sbScM+BCarzDqQy2sYFoDQsUJzzWD6WXKzhZG/8wCZNbBQ3gADIokGuy/L+s
         H627sQXoPjtP1knfrxVoMpzaZKqiz3m20HU1M0EQjNdwekGUE6PS/HaEZXvHIXkG3qVV
         R8gQXMlRmqazLH8g6MjItsKliJLABLWrj4/qm3nZPyMjJtcCVfsviBAU0IDnk2xAHGG2
         Ytmsvb4rX9ybTzR89rEc89TRK05tIfLLSjRhczrBGOP2a/i3gf4e91BMbGiPSw/TVg4v
         SzCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=GTvbctvJNpJ5XFFAVjSyyK1oKWoGjmVgAKwPqHF7qTs=;
        b=7qIqUYDzkBIwkSHa+noWuJ0NxnO7TcCgJMjN78Elt8uzLhK9fYxCgpl7S8v2xLWmgw
         bvv0CDBZO3oa6BGtQYo+aSLBBdGneaAZ43GEFk0KPeyRunlz6Mw+/z0G3stGNb4MiZGg
         S3B8RA7OlGi2es2wY2s6JeeAmIs+siTtJcM5cCTtsGL2SCGWLf9EZDWWoh87/YmIYiaC
         LWK+5nu5daxfsd8vmKUmXnOrj3DOxUrKNXnEQPkSroMXGOYCDRoIeLwg/YCHSEHI4XsH
         qbIRQcgEROPhlwPRcuzlFIyddK477/A0qffrykG6Lea3kRLJl9JAv8iNutWYZyjqgL5s
         gVKw==
X-Gm-Message-State: ACrzQf0M6qSecaL+jjYQqE99cUpDVUbuUAcITFwDnhxB8CqnbWWyfiUL
        LVHsXELCCGpXWAKVoY6CIbdMKw==
X-Google-Smtp-Source: AMsMyM643hgxLdb849WmJ4RhvZd9n5dCyv1lNXdROrTk43OBSVJLtSsqY08dfcqilV8P5C+JfdYxOw==
X-Received: by 2002:a17:90b:1e47:b0:200:b9b4:ba1e with SMTP id pi7-20020a17090b1e4700b00200b9b4ba1emr19166426pjb.172.1663573939338;
        Mon, 19 Sep 2022 00:52:19 -0700 (PDT)
Received: from FVFDK26JP3YV.bytedance.net ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id k12-20020a65434c000000b00438e0db80dasm15339950pgq.65.2022.09.19.00.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 00:52:18 -0700 (PDT)
From:   Lei He <helei.sig11@bytedance.com>
To:     herbert@gondor.apana.org.au
Cc:     mst@redhat.com, arei.gonglei@huawei.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        pizhenwei@bytedance.com, lei he <helei.sig11@bytedance.com>
Subject: [PATCH v2 RESEND] virtio-crypto: fix memory-leak
Date:   Mon, 19 Sep 2022 15:51:58 +0800
Message-Id: <20220919075158.3625-1-helei.sig11@bytedance.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: lei he <helei.sig11@bytedance.com>

Fix memory-leak for virtio-crypto akcipher request, this problem is
introduced by 59ca6c93387d3(virtio-crypto: implement RSA algorithm).
The leak can be reproduced and tested with the following script
inside virtual machine:

#!/bin/bash

LOOP_TIMES=10000

# required module: pkcs8_key_parser, virtio_crypto
modprobe pkcs8_key_parser # if CONFIG_PKCS8_PRIVATE_KEY_PARSER=m
modprobe virtio_crypto # if CONFIG_CRYPTO_DEV_VIRTIO=m
rm -rf /tmp/data
dd if=/dev/random of=/tmp/data count=1 bs=230

# generate private key and self-signed cert
openssl req -nodes -x509 -newkey rsa:2048 -keyout key.pem \
		-outform der -out cert.der  \
		-subj "/C=CN/ST=GD/L=SZ/O=vihoo/OU=dev/CN=always.com/emailAddress=yy@always.com"
# convert private key from pem to der
openssl pkcs8 -in key.pem -topk8 -nocrypt -outform DER -out key.der

# add key
PRIV_KEY_ID=`cat key.der | keyctl padd asymmetric test_priv_key @s`
echo "priv key id = "$PRIV_KEY_ID
PUB_KEY_ID=`cat cert.der | keyctl padd asymmetric test_pub_key @s`
echo "pub key id = "$PUB_KEY_ID

# query key
keyctl pkey_query $PRIV_KEY_ID 0
keyctl pkey_query $PUB_KEY_ID 0

# here we only run pkey_encrypt becasuse it is the fastest interface
function bench_pub() {
	keyctl pkey_encrypt $PUB_KEY_ID 0 /tmp/data enc=pkcs1 >/tmp/enc.pub
}

# do bench_pub in loop to obtain the memory leak
for (( i = 0; i < ${LOOP_TIMES}; ++i )); do
	bench_pub
done

Signed-off-by: lei he <helei.sig11@bytedance.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gonglei <arei.gonglei@huawei.com>
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
index 2a60d0525cde..168195672e2e 100644
--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -56,6 +56,10 @@ static void virtio_crypto_akcipher_finalize_req(
 	struct virtio_crypto_akcipher_request *vc_akcipher_req,
 	struct akcipher_request *req, int err)
 {
+	kfree(vc_akcipher_req->src_buf);
+	kfree(vc_akcipher_req->dst_buf);
+	vc_akcipher_req->src_buf = NULL;
+	vc_akcipher_req->dst_buf = NULL;
 	virtcrypto_clear_request(&vc_akcipher_req->base);
 
 	crypto_finalize_akcipher_request(vc_akcipher_req->base.dataq->engine, req, err);

base-commit: 568035b01cfb107af8d2e4bd2fb9aea22cf5b868
-- 
2.20.1

