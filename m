Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53299C4708D
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Jan 2023 18:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjACSpw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Jan 2023 13:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238534AbjACSpA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Jan 2023 13:45:00 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB2E1403C
        for <linux-crypto@vger.kernel.org>; Tue,  3 Jan 2023 10:43:12 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id g10so9745802wmo.1
        for <linux-crypto@vger.kernel.org>; Tue, 03 Jan 2023 10:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mCJ7npxHWqpq76xLkWO4j8PK4QmIgUKzcUbzkkrjhHk=;
        b=CZ5qHYLwlLPQI0PG3wJmLeJmMjKX0fENp37n8nEwoXnjIKGMPeZs6j6FtyOBT6Yp5J
         7KgQcqLS3n/tSclWR5Iew/zedibQuNm8CFGB1BLQ/G35Vkng58i/RBKR6P04gmY9bDBU
         OAbSlnzVH2PjtmHk9m5csZGnCiVfOu9zyD68rt6hrYFzWAaBG1CKSLsxPlvVFk83Exft
         G9mrsd04Tnt7S3nYb5O1wCqG68BANgvT1EoiN1b/BXRpP5KIB1jmA5SQWCGKTy5rAvbJ
         HU0a6kiFN1iXZGm2yo/+yeunkHFQxgsBMKPs5l+9vqAzTGamfTJ72LYB/QUwHuMii40r
         LfSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mCJ7npxHWqpq76xLkWO4j8PK4QmIgUKzcUbzkkrjhHk=;
        b=Z/3lHL29W6hgxBOj30/BY1EFLynv4ISDnOCWuGHhTwhY/VKOMmCJtrevCJY9z3WLBe
         CzhM776CDYlk62M+WsdElSkDn0qvvD/vCuIt/54tVgRgmvy24L91Fc3YfF2vlGkk2zp8
         k3p6akm2FQ0T88Lf9PCZatCAtgVGTiXvBI8CkVgyRHlV16/2QWi42Sdqvbgte1LzXHTU
         85DtsOxbTmK767eMggAh2HIoQnLugP/e25vpEbo8VIcVhn78xng0kR/ZGkOeXNnnoeGC
         lxM69iBearmjDNNAhbX/xLUnw3W9N/A0kTdaNKEKh05HqdX7kLifR4k+Fgmg8CRSY34u
         wrVQ==
X-Gm-Message-State: AFqh2kpChsru8pSxZg4mQGlgIXbc3Q8QULY+Bg/j9B08D8cIn03VcNTw
        qmmDLw4P4UdaC0qKe5/fTyjchw==
X-Google-Smtp-Source: AMrXdXtbXCx4js4WZ3kq1vAN/GqYO0G3aTLNuJAMOuTxxZEl1HjjPQFV849khE0HGIATJQTU13cCKw==
X-Received: by 2002:a05:600c:4d21:b0:3d2:2a72:2573 with SMTP id u33-20020a05600c4d2100b003d22a722573mr32110883wmp.11.1672771390924;
        Tue, 03 Jan 2023 10:43:10 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id i18-20020a5d5232000000b0028e55b44a99sm13811578wra.17.2023.01.03.10.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 10:43:10 -0800 (PST)
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
Subject: [PATCH v2 5/5] crypto/Documentation: Add crypto_pool kernel API
Date:   Tue,  3 Jan 2023 18:42:57 +0000
Message-Id: <20230103184257.118069-6-dima@arista.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103184257.118069-1-dima@arista.com>
References: <20230103184257.118069-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 Documentation/crypto/crypto_pool.rst | 33 ++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 Documentation/crypto/crypto_pool.rst

diff --git a/Documentation/crypto/crypto_pool.rst b/Documentation/crypto/crypto_pool.rst
new file mode 100644
index 000000000000..4b8443171421
--- /dev/null
+++ b/Documentation/crypto/crypto_pool.rst
@@ -0,0 +1,33 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Per-CPU pool of crypto requests
+=============
+
+Overview
+--------
+The crypto pool API manages pre-allocated per-CPU pool of crypto requests,
+providing ability to use async crypto requests on fast paths, potentially
+on atomic contexts. The allocation and initialization of the requests should
+be done before their usage as it's slow-path and may sleep.
+
+Order of operations
+-------------------
+You are required to allocate a new pool prior using it and manage its lifetime.
+You can allocate a per-CPU pool of ahash requests by ``crypto_pool_alloc_ahash()``.
+It will give you a pool id that you can use further on fast-path for hashing.
+You can increase the reference counter for an allocated pool via
+``crypto_pool_add()``. Decrease the reference counter by ``crypto_pool_release()``.
+When the refcounter hits zero, the pool is scheduled for destruction and you
+can't use the corresponding crypto pool id anymore.
+Note that ``crypto_pool_add()`` and ``crypto_pool_release()`` must be called
+only for an already existing pool and can be called in atomic contexts.
+
+``crypto_pool_get()`` disables bh and returns you back ``struct crypto_pool *``,
+which is a generic type for different crypto requests and has ``scratch`` area
+that can be used as a temporary buffer for your operation.
+
+``crypto_pool_put()`` enables bh back once you've done with your crypto
+operation.
+
+If you need to pre-allocate a bigger per-CPU ``scratch`` area for you requests,
+you can use ``crypto_pool_reserve_scratch()``.
-- 
2.39.0

