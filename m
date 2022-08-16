Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 773F7C25B0E
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 11:19:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234643AbiHPLTZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 07:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233858AbiHPLS5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 07:18:57 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBF7E0FD2
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 02:43:54 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id 17so8750262pli.0
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 02:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=GTvbctvJNpJ5XFFAVjSyyK1oKWoGjmVgAKwPqHF7qTs=;
        b=n6yB+De5LjG5J02vO6g0oPWkj3A2U2tkMwkcwVOgupo09upQEcL0TRkdI25JKNKj8n
         Pnr5oW7kcZ+bsh8CkL+v4FHrwgbQv9zYbjC4eac45qnROLw8+chC/y4ycI2CsyEYGB7f
         FDwchZJQIAjypZZ1C7XKKktbfWh72dp06/Yh56cBvpO+5jDq4ZLe8huL1FrOJdPibtB7
         E0VY/CgbKLbIOdDOgSZpvFeIgQXszz4HMxIa9NwKNNd+uJrCDH3xcD7HS47ytEPl4VC5
         fWZFSML8wxR5joZXGb6oPgAnLjn8M+UwjptMWBtSWGadM5JgzOLWn7bcyGrY88CglbJ2
         9jfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=GTvbctvJNpJ5XFFAVjSyyK1oKWoGjmVgAKwPqHF7qTs=;
        b=s61V37O43PaAU9zIS3mDDU7r7IdxlvvFNptkByt1ph1NvkczBduxatG/ZBNyOXxdb3
         3o1tmavs8pT1f72mNpPKmjwdi3zRuvszaxo9/2riOyB/d0XXcx5fxNo5ziVpCNeY9nus
         EQ98aUH4Q+PBgSA9RY0ZwVBs2OsK0guF8A0WEAdjD+UVF196/S6/CrN2pmm6FTCAE72U
         Y/WZiejBD2f4wKrVjJaQiLQykotFw1ta3S69Uo91gQpQ0Yu+UO94xQALHJr5F+cf6kN6
         tgbmXMpqdsMfgT1lkLuV4j+Mwi76xtOFEByOxh3R9e2Smn9e2hPDfu9qZTWGIzUy8oXH
         PRTQ==
X-Gm-Message-State: ACgBeo2GKT6rIGYzRnWl2At5LBC2PvPGVzLZaexe3gJ7N1cQ5obiHt4r
        iLCnpFAsQ1Cj8S0gYNnCTct0cw==
X-Google-Smtp-Source: AA6agR6FZQ9i+Tf/3XIz0/damoZoUYQmUBv+ZJ8T1Pk9l/5Np+oxwasrX2uAUzYHFZrxINjaXD6fsA==
X-Received: by 2002:a17:90b:3e86:b0:1f5:2b4f:7460 with SMTP id rj6-20020a17090b3e8600b001f52b4f7460mr32854131pjb.97.1660643033650;
        Tue, 16 Aug 2022 02:43:53 -0700 (PDT)
Received: from FVFDK26JP3YV.bytedance.net ([61.120.150.76])
        by smtp.gmail.com with ESMTPSA id w12-20020a170902e88c00b0016a6caacaefsm8643350plg.103.2022.08.16.02.43.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Aug 2022 02:43:53 -0700 (PDT)
From:   Lei He <helei.sig11@bytedance.com>
To:     mst@redhat.com, herbert@gondor.apana.org.au,
        arei.gonglei@huawei.com
Cc:     virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        pizhenwei@bytedance.com, lei he <helei.sig11@bytedance.com>
Subject: [PATCH v2] virtio-crypto: fix memory-leak
Date:   Tue, 16 Aug 2022 17:43:36 +0800
Message-Id: <20220816094336.27806-1-helei.sig11@bytedance.com>
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

