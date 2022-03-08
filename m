Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C0FC433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Mar 2022 20:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239505AbiCHUzO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Mar 2022 15:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238719AbiCHUzO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Mar 2022 15:55:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F213CFDC
        for <linux-crypto@vger.kernel.org>; Tue,  8 Mar 2022 12:54:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 609026170B
        for <linux-crypto@vger.kernel.org>; Tue,  8 Mar 2022 20:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAEBC340EB;
        Tue,  8 Mar 2022 20:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646772856;
        bh=MjaYTObjjDaRntm0u1LlvTEFX+Q45tAdGZoXejXOn6k=;
        h=From:To:Cc:Subject:Date:From;
        b=CBnvVELBhvlrkISe2/SfVOHaJQK5bLyMtGMxfyxj7/QFGDPx5RtFqkBw3UBS1QrPd
         Md+3N66Fc8Isigz1VL3HrVAercO1hfwKR0zGL46GUBubP864EMt523dO/usWBMgzDU
         opA3YAUs1uEYxjc3KwXn2Sk6XcIoUPXCtMG4Ta7ueRMaIWqyVCULM4r/IuFWHdE3cg
         uj4pZg8HlRObh3HXmpKwwC6n+u7f6J4NC/gEZe89g91xB7OvnibYnag3RdNpy8O4Ky
         Gp2dtxr/rZKSq4iSsqWlun+YBM+xTViAA1zBblBrDX4DeLOoTH55I5tpkgEPrm1nVI
         J3/5Ao+wOJM/g==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Gonglei <arei.gonglei@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     zhenwei pi <pizhenwei@bytedance.com>,
        lei he <helei.sig11@bytedance.com>,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, patches@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH -next] crypto: virtio - Select new dependencies
Date:   Tue,  8 Mar 2022 13:53:09 -0700
Message-Id: <20220308205309.2192502-1-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

With ARCH=riscv defconfig, there are errors at link time:

  virtio_crypto_akcipher_algs.c:(.text+0x3ea): undefined reference to `mpi_free'
  virtio_crypto_akcipher_algs.c:(.text+0x48a): undefined reference to `rsa_parse_priv_key'
  virtio_crypto_akcipher_algs.c:(.text+0x4bc): undefined reference to `rsa_parse_pub_key'
  virtio_crypto_akcipher_algs.c:(.text+0x4d0): undefined reference to `mpi_read_raw_data'
  virtio_crypto_akcipher_algs.c:(.text+0x960): undefined reference to `crypto_register_akcipher'
  virtio_crypto_akcipher_algs.c:(.text+0xa3a): undefined reference to `crypto_unregister_akcipher'

The virtio crypto driver started making use of certain libraries and
algorithms without selecting them. Do so to fix these errors.

Fixes: 8a75f36b5d7a ("virtio-crypto: implement RSA algorithm")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/crypto/virtio/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/virtio/Kconfig b/drivers/crypto/virtio/Kconfig
index b894e3a8be4f..5f8915f4a9ff 100644
--- a/drivers/crypto/virtio/Kconfig
+++ b/drivers/crypto/virtio/Kconfig
@@ -3,8 +3,11 @@ config CRYPTO_DEV_VIRTIO
 	tristate "VirtIO crypto driver"
 	depends on VIRTIO
 	select CRYPTO_AEAD
+	select CRYPTO_AKCIPHER2
 	select CRYPTO_SKCIPHER
 	select CRYPTO_ENGINE
+	select CRYPTO_RSA
+	select MPILIB
 	help
 	  This driver provides support for virtio crypto device. If you
 	  choose 'M' here, this module will be called virtio_crypto.

base-commit: c5f633abfd09491ae7ecbc7fcfca08332ad00a8b
-- 
2.35.1

