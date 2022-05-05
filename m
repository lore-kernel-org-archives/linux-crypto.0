Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A64DCC433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  5 May 2022 09:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354244AbiEEJci (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 May 2022 05:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354022AbiEEJcW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 May 2022 05:32:22 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FBD522D2
        for <linux-crypto@vger.kernel.org>; Thu,  5 May 2022 02:28:04 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id p6so3328130plr.12
        for <linux-crypto@vger.kernel.org>; Thu, 05 May 2022 02:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6F6fmtEjrSN7+MBeg46/Q6qwb0WfdkL+E9dyellACws=;
        b=sOf3f5whdDiTUgn3OHFpXtRMBGXTZEEPUuM+Zito2LzukzrJA0js+qKWEu1AR+ffPB
         HrrcRDbXA2W0pZnc7YvgqAQ8M7j+f8UQE7PllKnzfi2DCAs79RSnuR257TwY9k5NGT/G
         0YYL4Qi3tZ5DOaMY1iE2/383nu1Cfkd/ZJWPSsDqcih1Sh+grDk4tl+isTcqe3QZzhoY
         lJ+/0xzZwgOBfojAMRAGOpuk6A1Z5a+Gy+/dUfaHpfLL1PD3xJrpw4rtn14L13+0eyoq
         flZWo8ZJsinybkKrTSavz7OQqfHkpeoGSZk2ERRE4NKq2QEjomDWp2zJwO2ytjLHnxOH
         wNYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6F6fmtEjrSN7+MBeg46/Q6qwb0WfdkL+E9dyellACws=;
        b=GkQgSqgwoLazAgLmAiNAtHn4zmidu+oNl5ZSX1YAYo4FeKAEaicZKk+cz77VgPHw0a
         1usFGxlm34Q2H7zfp16/8gAzRUI50aIek8Do2d6t2DVroFMewazjxE4NpTVDaS0wUjDC
         8f7HHhD1Oxc4gRIbq3IbDfozLB7XuilQxU7Ws63J31eHw2DxlCM4Lr7iZ9Kso+SWhBBp
         OWEruHQnhouk4dH+HPCOOpLxf3zm3udinY1SIbFMUshQaYEZVGdg/TzHaB5pQ9yzg5R/
         hRkbkLdetRWSj7uQ5JGfNgFW9gXCDP5fwIXU58FAjNvi7m4spI9tw1Vt3SrEgWS7WDhg
         83rw==
X-Gm-Message-State: AOAM531JRLEMlsjqBNKiuOuNYFLAshdtchdlpJSAAkDi2ukElsekab2B
        OI9iVnhgUcOdO/fiz3NL+DQaeA==
X-Google-Smtp-Source: ABdhPJxURL31yAiE1Fmma/z4loT9dDh2LA26yErXvoNjLFqD0MP2V7b/jFxmB1xjT+/pEschQwl6Iw==
X-Received: by 2002:a17:90b:3a8b:b0:1dc:4eb4:1f2a with SMTP id om11-20020a17090b3a8b00b001dc4eb41f2amr5017601pjb.50.1651742884373;
        Thu, 05 May 2022 02:28:04 -0700 (PDT)
Received: from always-x1.www.tendawifi.com ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id t68-20020a625f47000000b0050dc76281dcsm884224pfb.182.2022.05.05.02.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 02:28:03 -0700 (PDT)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, helei.sig11@bytedance.com,
        pizhenwei@bytedance.com, davem@davemloft.net
Subject: [PATCH v5 0/5] virtio-crypto: Improve performance
Date:   Thu,  5 May 2022 17:24:03 +0800
Message-Id: <20220505092408.53692-1-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

v4 -> v5:
 - Fix potentially dereferencing uninitialized variables in
   'virtio-crypto: use private buffer for control request'.
   Thanks to Dan Carpenter!

v3 -> v4:
 - Don't create new file virtio_common.c, the new functions are added
   into virtio_crypto_core.c
 - Split the first patch into two parts:
     1, change code style,
     2, use private buffer instead of shared buffer
 - Remove relevant change.
 - Other minor changes.

v2 -> v3:
 - Jason suggested that spliting the first patch into two part:
     1, using private buffer
     2, remove the busy polling
   Rework as Jason's suggestion, this makes the smaller change in
   each one and clear.

v1 -> v2:
 - Use kfree instead of kfree_sensitive for insensitive buffer.
 - Several coding style fix.
 - Use memory from current node, instead of memory close to device
 - Add more message in commit, also explain why removing per-device
   request buffer.
 - Add necessary comment in code to explain why using kzalloc to
   allocate struct virtio_crypto_ctrl_request.

v1:
The main point of this series is to improve the performance for
virtio crypto:
- Use wait mechanism instead of busy polling for ctrl queue, this
  reduces CPU and lock racing, it's possiable to create/destroy session
  parallelly, QPS increases from ~40K/s to ~200K/s.
- Enable retry on crypto engine to improve performance for data queue,
  this allows the larger depth instead of 1.
- Fix dst data length in akcipher service.
- Other style fix.

lei he (2):
  virtio-crypto: adjust dst_len at ops callback
  virtio-crypto: enable retry for virtio-crypto-dev

zhenwei pi (3):
  virtio-crypto: change code style
  virtio-crypto: use private buffer for control request
  virtio-crypto: wait ctrl queue instead of busy polling

 .../virtio/virtio_crypto_akcipher_algs.c      |  95 ++++++------
 drivers/crypto/virtio/virtio_crypto_common.h  |  21 ++-
 drivers/crypto/virtio/virtio_crypto_core.c    |  55 ++++++-
 .../virtio/virtio_crypto_skcipher_algs.c      | 140 ++++++++----------
 4 files changed, 182 insertions(+), 129 deletions(-)

-- 
2.20.1

