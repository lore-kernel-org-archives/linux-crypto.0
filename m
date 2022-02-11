Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE46C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Feb 2022 08:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348085AbiBKImj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Feb 2022 03:42:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344677AbiBKImi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Feb 2022 03:42:38 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AC5E63
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 00:42:38 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id n23so15079818pfo.1
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 00:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HXaTm9zy9W/Fk6sBxh9XpKvs2j0diA8uf4CSWloZl88=;
        b=ZtNN+pwUXhbiBI06+s9oYlR4i6za0OUa9R7GlHnn+4GqxABwPRVmaRF5ri+9lXYJPK
         HLyHzYTxO7EHc2mOcMvsZ34WU71pUl7982FTqWh4jttvulqlX3xzyAZkgvO0uUDILprP
         xAEntQJvx0jfHHaPZhafWF2DmrIW1fD8NUPWmYXf2OmkE4sLtEpIYXlMbe10kb7OoEwO
         TfeMk3tjDlAzEl5DLz9lInToE36S5+UfjpkLoOYfcrZ/ehwM/HQtuFX/Bjhd6tcbMu0+
         jKhheTqY6O9ApVLimMn///QayiwA08eEZOwVZ9BiryCZw8+abHDQIfbHW70ywoF2EKeC
         a09A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HXaTm9zy9W/Fk6sBxh9XpKvs2j0diA8uf4CSWloZl88=;
        b=EjvDTtUPuqmusfsHDJF0K2CO2er3AoLjVlEd9JAT+1TpW5lEZ3zDQSYqND5DMgEbgD
         By2GPukOCVHELab0mLCvOk33Z1KML9ZMPyYq+4yznxv3PXBgAlcjXkDv/upRqyiXknJG
         NwXk/t56IQpdi1Do46sRhfvDwhwtA5LmgZMmbNkv2HMQjWJnmOP/sli1Pxj2SKsqaIic
         7q2CawYDK716JUr3VA+GhLjE3EZI0P3bBCgHBys0TYgjdBEiDX+ocKkeuWfQsqbITRph
         KH7/S/nORK0sfD+jIpmcUYxC8y09WSCkRP4N8e75HlI6k/ZOqFsitWMeZV8v0he+DeQP
         ai8Q==
X-Gm-Message-State: AOAM530jXKZLH1UhmQ1kql14eLki4BF9+5c8OzdMO0Sj+wtmQK1x5PJV
        d1ThYJAPJdOg6HgberDkuGLvOg==
X-Google-Smtp-Source: ABdhPJzteqwv0pPYrb+FP+UMxU2H2Cxr4mmWBjR561lIMjdAoQSPgdgi2I6VDtwQVm5+Fr4/fkpeZg==
X-Received: by 2002:a63:8543:: with SMTP id u64mr463644pgd.624.1644568957934;
        Fri, 11 Feb 2022 00:42:37 -0800 (PST)
Received: from libai.bytedance.net ([61.120.150.72])
        by smtp.gmail.com with ESMTPSA id p21sm13368481pfo.97.2022.02.11.00.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 00:42:37 -0800 (PST)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     arei.gonglei@huawei.com, mst@redhat.com
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        helei.sig11@bytedance.com, herbert@gondor.apana.org.au,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v2 0/3] Introduce akcipher service for virtio-crypto
Date:   Fri, 11 Feb 2022 16:41:05 +0800
Message-Id: <20220211084108.1254218-1-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

v1 -> v2:
- Fix 1 compiling warning reported by kernel test robot <lkp@intel.com>
- Put "__le32 akcipher_algo;" instead of "__le32 reserve;" field of
   struct virtio_crypto_config directly without size change.
- Add padding in struct virtio_crypto_ecdsa_session_para to keep
   64-bit alignment.
- Remove irrelevant change by code format alignment.

- Also CC crypto gurus Herbert and linux-crypto@vger.kernel.org.

- Test with QEMU(patched by the v2 version), works fine.

v1:
- Introduce akcipher service, implement RSA algorithm, and a minor fix.

zhenwei pi (3):
  virtio_crypto: Introduce VIRTIO_CRYPTO_NOSPC
  virtio-crypto: introduce akcipher service
  virtio-crypto: implement RSA algorithm

 drivers/crypto/virtio/Makefile                |   1 +
 .../virtio/virtio_crypto_akcipher_algo.c      | 584 ++++++++++++++++++
 drivers/crypto/virtio/virtio_crypto_common.h  |   3 +
 drivers/crypto/virtio/virtio_crypto_core.c    |   6 +-
 drivers/crypto/virtio/virtio_crypto_mgr.c     |  11 +
 include/uapi/linux/virtio_crypto.h            |  82 ++-
 6 files changed, 685 insertions(+), 2 deletions(-)
 create mode 100644 drivers/crypto/virtio/virtio_crypto_akcipher_algo.c

-- 
2.20.1

