Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C529C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Jan 2022 02:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348471AbiAUCZv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Jan 2022 21:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348465AbiAUCZv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jan 2022 21:25:51 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55575C061574
        for <linux-crypto@vger.kernel.org>; Thu, 20 Jan 2022 18:25:51 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id r11so6988014pgr.6
        for <linux-crypto@vger.kernel.org>; Thu, 20 Jan 2022 18:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+voPomDve1qXJhFgNfovxhf7gmY1dDR8B+xopqARLyY=;
        b=UubX+tZcZPf+xRM5IS1zf6cFWjDLExzHpy47TQTU53a7DDJ+z7+szHbEi8Kc4JKiDr
         pESA50tf2tHvryDPWX6YJKPyI7jFU5JKjA2MFeX/wwEI6lePBpX3sErdo1NH0iCyFOoQ
         dfN71+F4z9bRbDFkgK77+tryVmB27rBKasejItYIxbaZD7o1I7mAfX/ikFBe8qZnSrL2
         6Zo4pP2mhtPmQSq59RUSdzu7t2styOWR7kzCmaaZGohDinBGVImKDuXpSgkBM4PCasft
         uD2hEapinzSHdsPmyOM9fVhVoAY6ZfaI4o44AHmm84hKkJbR36NGbCUe0ZqC5xlGo+rV
         Cc5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+voPomDve1qXJhFgNfovxhf7gmY1dDR8B+xopqARLyY=;
        b=eslIp8HfC6QYUlWX+AB+ywfCTBsB3MqKS67EsuhNB6h7s84oNz+5tmJjN7c5+sRx+5
         oTYG/dk6554gB2Eyca+LOcE+QLhDPYj7dqFlsY12fQoTktMtGoIXPS8Bifgo+O4zqnfY
         uyxhBFI6vTVb3N/vym+mnemt06UX5DxxSnny/naCA0vhXUBJ7dW1MgLwzPvJY/x3Rprz
         jq6CbZKlvZyGSN9G6f6LHe9VkkPwX8uL5bmsQFcoxMP2S7vMOE2QXLiFVRm/kfJ/tHZw
         wXqYYfdeVwwutTnHQ9GYjC3umF9QwvVBKHX1TZrk26izGbrieL30Mn8KPlHJBzWLx0Bx
         zy8Q==
X-Gm-Message-State: AOAM532WAZp74o2cVhBtIyYZ3jSjNeherIL8O3VshXXsVSSKKKD1qlqh
        eRJeHDfk+As+AtWOMR4zPsgVpA==
X-Google-Smtp-Source: ABdhPJzuqPIc/uwbrarW7/35mk8lweYkpI1GVvOf8Bo6zdOao4Bfeyph3k+rqVP009DK7ztmfllk8A==
X-Received: by 2002:a63:3fc5:: with SMTP id m188mr1339522pga.307.1642731950857;
        Thu, 20 Jan 2022 18:25:50 -0800 (PST)
Received: from libai.bytedance.net ([61.120.150.72])
        by smtp.gmail.com with ESMTPSA id h2sm5057577pfv.31.2022.01.20.18.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 18:25:50 -0800 (PST)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     mst@redhat.com, arei.gonglei@huawei.com
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        helei.sig11@bytedance.com, zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH 0/3] Introduce akcipher service for virtio-crypto
Date:   Fri, 21 Jan 2022 10:24:35 +0800
Message-Id: <20220121022438.1042547-1-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Introduce akcipher service, implement RSA algorithm, and a minor fix.

zhenwei pi (3):
  virtio_crypto: Introduce VIRTIO_CRYPTO_NOSPC
  virtio-crypto: introduce akcipher service
  virtio-crypto: implement RSA algorithm

 drivers/crypto/virtio/Makefile                |   1 +
 .../virtio/virtio_crypto_akcipher_algo.c      | 584 ++++++++++++++++++
 drivers/crypto/virtio/virtio_crypto_common.h  |   3 +
 drivers/crypto/virtio/virtio_crypto_core.c    |   6 +-
 drivers/crypto/virtio/virtio_crypto_mgr.c     |  11 +
 include/uapi/linux/virtio_crypto.h            |  98 ++-
 6 files changed, 693 insertions(+), 10 deletions(-)
 create mode 100644 drivers/crypto/virtio/virtio_crypto_akcipher_algo.c

-- 
2.25.1

