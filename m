Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9A6CC32793
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Jan 2023 21:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjARVl6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Jan 2023 16:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbjARVlt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Jan 2023 16:41:49 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC74A62D10
        for <linux-crypto@vger.kernel.org>; Wed, 18 Jan 2023 13:41:25 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id r9so10798wrw.4
        for <linux-crypto@vger.kernel.org>; Wed, 18 Jan 2023 13:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FMLRObJikupEwzTrRnh2PGmgjZ9Cqtc3WwiwTSH8KzM=;
        b=eCtXeYsP+ADhvJqyR5obWxJN2h47MVmxSPM3WN/yFWVLL7Bofz6ALMqkQ5FmPFSW8x
         UWaka0KuTIy7rIQGm6zFjHry+P1eL6Sk8lHn9fP+GlFKwmKfj/Q6EGvopu1kINYq/tef
         zm8zNYOALlS2vhNm+EkXcXVPzdDc/TXwTPpHmjgDI6AlVHBF2UVGGn5IwZJjA1mkQrTd
         W7/8pHqfbBiiPSMO3n8KjIvPtsQCwLJhGfGrg9lAgqPV+bv5lqOuwfh93c0xePh+Wkpp
         2YLAsoMIKNpdfYZLV7cFr9MhZ4e3JlmJFQlcJhphihQuV+4yzmbAlgwjxUanzoyThCaw
         x8Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FMLRObJikupEwzTrRnh2PGmgjZ9Cqtc3WwiwTSH8KzM=;
        b=gRJTdHzzVhsVCvW02wG/Q0P/gaiSSjNRNV3lHaojoxKABt6diYTQ/rIffq8gseCinL
         zkzGKYjY3hC4w8MDqlGxNBJgqdRa++LhA/qgTlOEzoBCA/ppmif+I5Q1DGBo4JUQInAi
         UYmelOupxowxqEOfO42OhZ6GaJYhEzXGnXjr3n9DnzobMOT306TeUina3KtnewjA5fXw
         0j/uR+lY5RV9E1SJfwMTNHFmVt8iv4fT1D56yTvzFQXWpQfU6D6LIy9qHzKz4tydDxzd
         IaRICfVDSSNiaTUyBlOczgDDXwyAxQnSJ5JYr/wLB/gSQ7Kl2Sc7b2mnS3q0a1+hXV/s
         oAzQ==
X-Gm-Message-State: AFqh2kpVi3pyU0bdBH4/q2tHpcvpAV+lZFr1B53frlAA6TrvBB4lheZ7
        wyg/Y5Ly07YgrlnFbh3DTDV5aQ==
X-Google-Smtp-Source: AMrXdXs9dt7f2UXQjFy9Tfqdc9IqVLQbqXGCkdLvQFCWCdoKDt4UIeux1A+ib39qTp53lS2eyE54aQ==
X-Received: by 2002:a5d:5b0e:0:b0:250:22e4:b89e with SMTP id bx14-20020a5d5b0e000000b0025022e4b89emr8426197wrb.65.1674078084270;
        Wed, 18 Jan 2023 13:41:24 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id m5-20020a056000024500b00267bcb1bbe5sm33186349wrz.56.2023.01.18.13.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 13:41:23 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v4 4/4] crypto/Documentation: Add crypto_pool kernel API
Date:   Wed, 18 Jan 2023 21:41:11 +0000
Message-Id: <20230118214111.394416-5-dima@arista.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118214111.394416-1-dima@arista.com>
References: <20230118214111.394416-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 Documentation/crypto/crypto_pool.rst | 36 ++++++++++++++++++++++++++++
 Documentation/crypto/index.rst       |  1 +
 2 files changed, 37 insertions(+)
 create mode 100644 Documentation/crypto/crypto_pool.rst

diff --git a/Documentation/crypto/crypto_pool.rst b/Documentation/crypto/crypto_pool.rst
new file mode 100644
index 000000000000..84abd1f2ee80
--- /dev/null
+++ b/Documentation/crypto/crypto_pool.rst
@@ -0,0 +1,36 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Per-CPU pool of crypto requests
+===============================
+
+Overview
+--------
+The crypto pool API manages pre-allocated per-CPU pool of crypto requests,
+providing ability to use crypto requests on fast paths, potentially in atomic
+contexts. The allocation and initialization of the requests should be done
+before their usage as it's slow-path and may sleep.
+
+Order of operations
+-------------------
+You are required to allocate a new pool prior using it and manage its lifetime.
+You can allocate a per-CPU pool of ahash requests by crypto_pool_alloc_ahash().
+It will give you a pool id that you can use further on fast-path for hashing.
+You can increase the reference counter for an allocated pool via
+crypto_pool_get(). Decrease the reference counter by crypto_pool_release().
+When the refcounter hits zero, the pool is scheduled for destruction and you
+can't use the corresponding crypto pool id anymore.
+Note that crypto_pool_get() and crypto_pool_release() must be called
+only for an already existing pool and can be called in atomic contexts.
+
+crypto_pool_start() disables bh and returns you back ``struct crypto_pool *``,
+which is a generic type for different crypto requests and has ``scratch`` area
+that can be used as a temporary buffer for your operation.
+
+crypto_pool_end() enables bh back once you've done with your crypto
+operation.
+
+.. kernel-doc:: include/crypto/pool.h
+   :identifiers:
+
+.. kernel-doc:: crypto/crypto_pool.c
+   :identifiers:
diff --git a/Documentation/crypto/index.rst b/Documentation/crypto/index.rst
index 21338fa92642..3eaf4e964e5b 100644
--- a/Documentation/crypto/index.rst
+++ b/Documentation/crypto/index.rst
@@ -25,6 +25,7 @@ for cryptographic use cases, as well as programming examples.
    devel-algos
    userspace-if
    crypto_engine
+   crypto_pool
    api
    api-samples
    descore-readme
-- 
2.39.0

