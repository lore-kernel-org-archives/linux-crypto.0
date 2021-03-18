Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99388C433E9
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 12:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6336E64F6F
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 12:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhCRMoz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Mar 2021 08:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbhCRMoc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Mar 2021 08:44:32 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55DFC06175F
        for <linux-crypto@vger.kernel.org>; Thu, 18 Mar 2021 05:44:31 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n11-20020a05600c4f8bb029010e5cf86347so6862537wmq.1
        for <linux-crypto@vger.kernel.org>; Thu, 18 Mar 2021 05:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AJQO8bVI3b81mb68PB08R/oOF3ooV8dt2QQLb5Ex6Hw=;
        b=xLCEVWKkh857JtBePvYh95mpILww1ayRgcQloNKeaL50VqqgjDok4abtvvZuFJWyfw
         dnRyPtwBhPgmGzki0AqxfG2sSSG9B9avGDZDMVKPuxnkv8kf9HjCZbBNsuXIG0kW67D0
         7pKKWVpVt5eSAQKVisuUbMIixNVBlo2/fbE+ZvGSs2611TTmd/yYh2113XLB0mJhA7lS
         gBkOdh/lWFeTpkSWDRUeE90GLO2Isqcusm8lVACorWp5T6FCOP2830dL3UT3ljAw9jpz
         wtjWsIW27awROUFuS5LMJ6B8gtXI2OqOaaLIDVDBxp//GWNNPvucgHnco3AaTdyOHKZG
         ufyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AJQO8bVI3b81mb68PB08R/oOF3ooV8dt2QQLb5Ex6Hw=;
        b=QdMfoEkyl2J2QzX+i/EoPQySF8L3kuzbktXP4zFslqT16ceCdM42FWOhNsxKrDz1AO
         e6jep7nM5s8LT1TgJlYUvgGJgkkIcntavsUcuVLoHWeJqBzVX6CID66JuHMH1rm6B35P
         WnxgFK5uzrxf9NEPZQyCU+6j4gjXx03id0D0eDG3bQFanFn7/tHcupbMGF4Fh1FMEYhF
         MKSzZZBf4tIo5tIQioWb2IfZk3sWRfargcULjUDM40cipXtcvOJqMXxj06v7nWDudbSC
         TfatvTd8+i5KGHTFxbKSCutWZSBJ9kbkBwAhK7rjVCSlOYxEUgvQR1Vv91KpoqsZ0B4q
         j4OQ==
X-Gm-Message-State: AOAM5326qECzbnG4UshYI2GvVOoZmfHl9kRwyPiv/glc25V1+R7I7qIT
        DY2aXUUIvhZINADK+1ftmY7bVQ==
X-Google-Smtp-Source: ABdhPJxnk1k0Mb4aNBzX643EoSOfVjoAuKNDuwWX1gNK4cFB4T9rip/OdnykKJk57tfoH66Iy1z1YQ==
X-Received: by 2002:a7b:c759:: with SMTP id w25mr3467410wmk.139.1616071470493;
        Thu, 18 Mar 2021 05:44:30 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id q15sm2813900wrx.56.2021.03.18.05.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 05:44:30 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andreas Westin <andreas.westin@stericsson.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Berne Hebark <berne.herbark@stericsson.com>,
        =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Declan Murphy <declan.murphy@intel.com>,
        Harsh Jain <harsh@chelsio.com>,
        Henrique Cerri <mhcerri@br.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Jitendra Lulla <jlulla@chelsio.com>,
        Joakim Bech <joakim.xx.bech@stericsson.com>,
        Jonas Linde <jonas.linde@stericsson.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Kent Yoder <yoder1@us.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Manoj Malviya <manojmalviya@chelsio.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        M R Gowda <yeshaswi@chelsio.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Niklas Hernaeus <niklas.hernaeus@stericsson.com>,
        Paul Mackerras <paulus@samba.org>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Rob Rice <rob.rice@broadcom.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Shujuan Chen <shujuan.chen@stericsson.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Zaibo Xu <xuzaibo@huawei.com>
Subject: [PATCH v3 00/10] Rid W=1 warnings in Crypto
Date:   Thu, 18 Mar 2021 12:44:12 +0000
Message-Id: <20210318124422.3200180-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is set 1 of 2 sets required to fully clean Crypto.

v2: No functional changes since v1.
v3: Description change and additional struct header fix

Lee Jones (10):
  crypto: hisilicon: sec_drv: Supply missing description for
    'sec_queue_empty()'s 'queue' param
  crypto: bcm: Fix a whole host of kernel-doc misdemeanours
  crypto: chelsio: chcr_core: Fix some kernel-doc issues
  crypto: ux500: hash: hash_core: Fix worthy kernel-doc headers and
    remove others
  crypto: keembay: ocs-hcu: Fix incorrectly named functions/structs
  crypto: atmel-ecc: Struct headers need to start with keyword 'struct'
  crypto: caam: caampkc: Provide the name of the function and provide
    missing descriptions
  crypto: vmx: Source headers are not good kernel-doc candidates
  crypto: nx: nx-aes-cbc: Repair some kernel-doc problems
  crypto: cavium: nitrox_isr: Demote non-compliant kernel-doc headers

 drivers/crypto/atmel-ecc.c                |  2 +-
 drivers/crypto/bcm/cipher.c               |  7 ++--
 drivers/crypto/bcm/spu.c                  | 16 ++++-----
 drivers/crypto/bcm/spu2.c                 | 43 +++++++++++++----------
 drivers/crypto/bcm/util.c                 |  4 +--
 drivers/crypto/caam/caamalg_qi2.c         |  3 ++
 drivers/crypto/caam/caampkc.c             |  3 +-
 drivers/crypto/cavium/nitrox/nitrox_isr.c |  4 +--
 drivers/crypto/chelsio/chcr_algo.c        |  8 ++---
 drivers/crypto/chelsio/chcr_core.c        |  2 +-
 drivers/crypto/hisilicon/sec/sec_drv.c    |  1 +
 drivers/crypto/keembay/ocs-hcu.c          |  8 ++---
 drivers/crypto/nx/nx-aes-cbc.c            |  2 +-
 drivers/crypto/nx/nx.c                    |  5 +--
 drivers/crypto/nx/nx_debugfs.c            |  2 +-
 drivers/crypto/ux500/cryp/cryp.c          |  5 +--
 drivers/crypto/ux500/cryp/cryp_core.c     |  5 +--
 drivers/crypto/ux500/cryp/cryp_irq.c      |  2 +-
 drivers/crypto/ux500/hash/hash_core.c     | 15 +++-----
 drivers/crypto/vmx/vmx.c                  |  2 +-
 20 files changed, 73 insertions(+), 66 deletions(-)

Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Andreas Westin <andreas.westin@stericsson.com>
Cc: Atul Gupta <atul.gupta@chelsio.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: Ayush Sawal <ayush.sawal@chelsio.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Berne Hebark <berne.herbark@stericsson.com>
Cc: "Breno Leitão" <leitao@debian.org>
Cc: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Declan Murphy <declan.murphy@intel.com>
Cc: Harsh Jain <harsh@chelsio.com>
Cc: Henrique Cerri <mhcerri@br.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Horia Geantă" <horia.geanta@nxp.com>
Cc: Jitendra Lulla <jlulla@chelsio.com>
Cc: Joakim Bech <joakim.xx.bech@stericsson.com>
Cc: Jonas Linde <jonas.linde@stericsson.com>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Kent Yoder <yoder1@us.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
Cc: Manoj Malviya <manojmalviya@chelsio.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: M R Gowda <yeshaswi@chelsio.com>
Cc: Nayna Jain <nayna@linux.ibm.com>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Niklas Hernaeus <niklas.hernaeus@stericsson.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
Cc: Rob Rice <rob.rice@broadcom.com>
Cc: Rohit Maheshwari <rohitm@chelsio.com>
Cc: Shujuan Chen <shujuan.chen@stericsson.com>
Cc: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc: Zaibo Xu <xuzaibo@huawei.com>
-- 
2.27.0

