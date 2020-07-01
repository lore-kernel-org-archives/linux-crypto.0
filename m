Return-Path: <SRS0=MAzA=AM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5198FC433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 22:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 265F5207F5
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 22:07:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AEMZGLOW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgGAWHu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 18:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgGAWHu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 18:07:50 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32A6C08C5C1;
        Wed,  1 Jul 2020 15:07:49 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id z24so4186832ljn.8;
        Wed, 01 Jul 2020 15:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+ohxmBAJip02a1VFP0Ot2Q9zEKcMeu3jnb8Rzmbca/M=;
        b=AEMZGLOWrMk73giLAGv+pg9nTBvFlqQdE7gTL/gQ3oWJ8mYZWviYnK4tuTjt91jR6v
         JyDIu/+10zEKgIdpjHdlHhwtbkqUmzC6r3VG5Id1qPU5ZTZiD7nty+1BZQrh2ZKHQRn6
         ZPxot1ZORNq5skS6P0hlc8pmRW3shkSBtmoWh57nQPUISJ/69Q2MzXrp46MVcKfUIyYj
         /TM3cwwxeBpysJJ2ddEfXv4JNGcSydMWQxJs684IY/bZ13QoWcuXYSMv9e46dTj7pp8p
         hHrOxSMF/8362gA+l05S4i7o5AdH3upOQd+oYMYkvi8zssrpEcVu0V4lBru2CvNEkZZ6
         VyKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+ohxmBAJip02a1VFP0Ot2Q9zEKcMeu3jnb8Rzmbca/M=;
        b=R0KQ80xjTlShSmOCMGq4LWHYOfq/yoxN+qeASCYDpCHLKqkpFtuUFuuMNELcVmfKnK
         4NV4RvXBLiLJpCaBaVjXdieVL0eIVCv2nchwqgn5Zbhqw5q9OUgLYxLM9OMXo2hYrPNi
         iZGMEZBiEf1ld3iNsv/r5e4SgiptyYohFsOt4YNAPq8RO+X5BXSXlvZhCz2FTqeoH3HH
         XR8sLsVw0hFzM+1bY7gtgDbtif9q+joR6ja8kQpB13pzdMHPuTNp/cox3E3xolVuLoew
         MYfNTPzLAQXdTSdqDThnTu8Mo2zI/r9jOFoudumZuZ4uJF7td71gvUU6c44v+BPPHrM3
         +Ymw==
X-Gm-Message-State: AOAM530IKOFpv8fDVpxjsC9KVK4I33M0XTmnffsN6hcVlcgdLtN4Tgjv
        qEv7AP1PsXYqpIt8jgtOXR8=
X-Google-Smtp-Source: ABdhPJzcVEtLSZafFQYSlr60rjQ71eNMW1TNsnWBOsfPWQdVx5f8OXjnqVWxmIxJhZwcZa3v8QZnTw==
X-Received: by 2002:a2e:81c8:: with SMTP id s8mr14480440ljg.281.1593641268276;
        Wed, 01 Jul 2020 15:07:48 -0700 (PDT)
Received: from localhost.localdomain (h-98-128-181-241.NA.cust.bahnhof.se. [98.128.181.241])
        by smtp.gmail.com with ESMTPSA id x17sm2516292lfe.44.2020.07.01.15.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 15:07:47 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
Cc:     mst@redhat.com, jasowang@redhat.com, arei.gonglei@huawei.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [PATCH] crypto: virtio - constify features[] and id_table[]
Date:   Wed,  1 Jul 2020 22:29:36 +0200
Message-Id: <20200701202936.44156-1-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

features[] and id_table[] are not modified and can be made const to
allow the compiler to put them in read-only memory.

Before:
   text    data     bss     dec     hex filename
  11534    2056     160   13750    35b6 drivers/crypto/virtio/virtio_crypto_core.o

After:
   text    data     bss     dec     hex filename
  11630    1992     128   13750    35b6 drivers/crypto/virtio/virtio_crypto_core.o

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/crypto/virtio/virtio_crypto_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
index ba8a19c72391..0c66d6193ca2 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -498,11 +498,11 @@ static int virtcrypto_restore(struct virtio_device *vdev)
 }
 #endif
 
-static unsigned int features[] = {
+static const unsigned int features[] = {
 	/* none */
 };
 
-static struct virtio_device_id id_table[] = {
+static const struct virtio_device_id id_table[] = {
 	{ VIRTIO_ID_CRYPTO, VIRTIO_DEV_ANY_ID },
 	{ 0 },
 };
-- 
2.27.0

