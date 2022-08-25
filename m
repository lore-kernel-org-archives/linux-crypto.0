Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E8DC28D13
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Aug 2022 07:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236640AbiHYHYZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Aug 2022 03:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235550AbiHYHYY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2022 03:24:24 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850CE98D24
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 00:24:23 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id u9so8824885ejy.5
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 00:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc;
        bh=SnII6Fo2+WTgXrCpEYWOd5rqFgnklJor6N4Ows/yZgk=;
        b=U9MBgRLVFKT2BuVXmI7cAiVOqF5V4v2Rgazy2mJykJGQTPOtjdPQlnMc2WqZRkoOk9
         vwS0rOjCh3If33dE5wmDRFFaMa9jakBa/P9Pmh7rwq9Iq9Um8vklHaqJoNj3BFH4WTl5
         wqZhmDEFGJKL7fFE9Um6dOqUxFJAdOnzV6sjrG9b5TeIKJYg7KGxebAeCjgPELwpVZpO
         7iKETCn5AS0JXPAmbzO9btppZO0jAe1unnjIpXfXhRQecW1R5b0sKCwsfzXW+nBoqS2l
         Jo/rfkwiDQK6oYqwppLAW1wCXH2DF3aWyo0pvxTlMiJ11KTTqnpk0dLEr0Iq9eAaxucL
         LAFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc;
        bh=SnII6Fo2+WTgXrCpEYWOd5rqFgnklJor6N4Ows/yZgk=;
        b=SiP5gQFCeC9XsluqJMOJg9SugX4Lt/exNt26yE3agIngHfheYZp0//HPW0bny6rF9B
         MXJ3nscKgBlexlKHr0UH2SYt0/rRF9a1z1x6Fb81Q9MHuItG0kIKRg8U07cKT0JgHIBE
         FCcczW2zE85j6IVwFRAhoCZBvlCDlvBOJW8Y43DOwdKLc34c66HDeDDeyqGspnzcZLEX
         r2lzF+xOf8gD+mSA2AfDPuu8w907YSIDhOCWT+93JPslj9qTpHdUHgUKxB4yMF+6VEIM
         G6cnzIZStdr6niGOsAILOcpHA4RARB6uhBaUZeQV/SQJXR1wwuVI4CCgB1GahsXoC2mi
         ITRw==
X-Gm-Message-State: ACgBeo2cIpmjtu7JAranY0yAtUqmS1GEfPrgVJ072Bi7fO8kDRz/9IfI
        T00eOkfs/s+R/9q+EEfIrlfDXBBDgbVRfg==
X-Google-Smtp-Source: AA6agR4Bpo8DoRvmLzYOOK9j4RFiswlOIG+WYcA2J3rigargQ5xMz3skEnez478IzZz7NykwKzhaVA==
X-Received: by 2002:a17:907:3f0c:b0:73d:60fc:6594 with SMTP id hq12-20020a1709073f0c00b0073d60fc6594mr1624484ejc.669.1661412262090;
        Thu, 25 Aug 2022 00:24:22 -0700 (PDT)
Received: from lb02065.fritz.box ([2001:9e8:142d:a900:eab:b5b1:a064:1d0d])
        by smtp.gmail.com with ESMTPSA id ky12-20020a170907778c00b0073ce4abf093sm2032281ejc.214.2022.08.25.00.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 00:24:21 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Subject: [PATCH 0/6] Crypto: Fix dma_map_sg error check
Date:   Thu, 25 Aug 2022 09:24:15 +0200
Message-Id: <20220825072421.29020-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, all,

While working on a bugfix on RTRS[1], I noticed there are quite a few other
drivers have the same problem, due to the fact dma_map_sg return 0 on error,
not like most of the cases, return negative value for error.

I "grep -A 5 dma_map_sg' in kernel tree, and audit/fix the one I feel is buggy,
hence this patchset. As suggested by Christoph Hellwig, I now send the patches per
subsystem, this is for crypto subsystem.

Thanks!

[1] https://lore.kernel.org/linux-rdma/20220818105355.110344-1-haris.iqbal@ionos.com/T/#t


Jack Wang (6):
  crypto: gemin: Fix error check for dma_map_sg
  crypto: sahara: Fix error check for dma_map_sg
  crypto: qce: Fix dma_map_sg error check
  crypto: amlogic: Fix dma_map_sg error check
  crypto: allwinner: Fix dma_map_sg error check
  crypto: ccree: Fix dma_map_sg error check

 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 6 +++---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c   | 2 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 4 ++--
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c   | 2 +-
 drivers/crypto/amlogic/amlogic-gxl-cipher.c         | 6 +++---
 drivers/crypto/ccree/cc_buffer_mgr.c                | 2 +-
 drivers/crypto/gemini/sl3516-ce-cipher.c            | 6 +++---
 drivers/crypto/qce/aead.c                           | 4 ++--
 drivers/crypto/qce/sha.c                            | 8 +++++---
 drivers/crypto/qce/skcipher.c                       | 8 ++++----
 drivers/crypto/sahara.c                             | 4 ++--
 11 files changed, 27 insertions(+), 25 deletions(-)

-- 
2.34.1

