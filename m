Return-Path: <SRS0=XJfk=6W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BD6C38A2A
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 22:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5FA62184D
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 22:35:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mz4AUugu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgEHWfP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 18:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727787AbgEHWfP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 18:35:15 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3FCC061A0C;
        Fri,  8 May 2020 15:35:14 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id a21so3317917ljj.11;
        Fri, 08 May 2020 15:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4l1+zEdmLubEoFU9dE74yltf9DwQFpqJC09hlDxdWy0=;
        b=mz4AUuguwR/IPe82HlThvFLvOz84FN9TCFQLheWdpyXsoc3hc67Yyu2K40PCyp8MzU
         rB7CDB5wTg7X2vUCzAhkW4APGlnEuoZYEYBKLzXrN2/dVdmMlwdqNNWE9QQGfJBwu9un
         /mUOhljBNwj433CCm2wqadrZTyfnrbI1AKFLpHHRZmAsBXGevrHY9FGuKeKRnDyLRBHX
         +xMj1iV1s9yjZ5riI/QPjqvGB6a9sEtYGRShY/OECZtPtPEGT7bwqdBXJp3c4CSor7dR
         MXmajdWCS1dJaCUcMkmrivLLOCbtpbj7HA4RetBk1LFf0YQu55KzoanlXCNsZZSnAXqe
         yAeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4l1+zEdmLubEoFU9dE74yltf9DwQFpqJC09hlDxdWy0=;
        b=IVVLIT+tovEiacNP3wLHt2ZEUXm+tIqWgnbHGqidQgXZ+2/roMNnXfNVT52qCqdR+u
         U8Dq3ELyogBzH9cZoFJ2qiPlvnjVboBaaCMiSyAAntpEjXaqqgx+pEdsTpTvlk/JBBLR
         Eof50I/gp7Be5Za81A4Q7rez50jrNoIGBG23KUPGJkQR3xYZfVBZ1uasDSNUPoSKvTYc
         kp3peXmHx3vXGChUyaLbRUgoK0ZdADimrK0+ncz4CPzPU1b2Nxa24HFWmrWGp5SdM1Zh
         cieO+Dt0IyDTgyoiCaiKIGA8t3SX+EdLCzhEHyS6e/QKyYlXrWwoa/9JDe3asszIbc+u
         bkGA==
X-Gm-Message-State: AOAM531QarN9a986HmmVx4jO0qgTL7tde68z2XIdAWhAPkVcGD0RoO0D
        NGj7JG3xmVgVxH6D1sgYm/M=
X-Google-Smtp-Source: ABdhPJyuEA2maVtreJSA8Los0iFXV/KvcXjVvJpxgvhn/03FRC39cS1s2z6D8jm7tczTG2txstdeRg==
X-Received: by 2002:a2e:a0cf:: with SMTP id f15mr2963303ljm.165.1588977313232;
        Fri, 08 May 2020 15:35:13 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-22.NA.cust.bahnhof.se. [158.174.22.22])
        by smtp.gmail.com with ESMTPSA id s11sm2316501lfo.86.2020.05.08.15.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 15:35:12 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [PATCH 0/4] crypto: constify struct debugfs_reg32
Date:   Sat,  9 May 2020 00:34:58 +0200
Message-Id: <20200508223502.7258-1-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A small series constifying struct debugfs_reg32 where it can be made
const. There's no dependency between the patches.

Rikard Falkeborn (4):
  crypto: ccree - constify struct debugfs_reg32
  crypto: hisilicon/hpre - constify struct debugfs_reg32
  crypto: hisilicon/zip - constify struct debugfs_reg32
  crypto: hisilicon/sec2 - constify sec_dfx_regs

 drivers/crypto/ccree/cc_debugfs.c         | 4 ++--
 drivers/crypto/hisilicon/hpre/hpre_main.c | 4 ++--
 drivers/crypto/hisilicon/sec2/sec_main.c  | 2 +-
 drivers/crypto/hisilicon/zip/zip_main.c   | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.26.2

