Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44924 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbeJQXOm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 19:14:42 -0400
From: AnilKumar Chimata <anilc@codeaurora.org>
To: andy.gross@linaro.org, david.brown@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc: linux-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        AnilKumar Chimata <anilc@codeaurora.org>
Subject: [PATCH 0/3] Add Inline Crypto Engine (ICE) driver
Date: Wed, 17 Oct 2018 20:47:53 +0530
Message-Id: <1539789476-6098-1-git-send-email-anilc@codeaurora.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series adds support for QualComm ICE driver which
is embedded in storage device such as UFS/eMMC.

ICE HW provides high throughputs, which meets the line speed
of storage devices. ICE works in bypass or non-bypass mode,
during bypass mode ICE does not perform any crypto operations
but in non-bypass mode ICE will perform encryption/decryption
based on the configuration.

ICE HW supports AES128/256 bit ECB & XTS mode algorithms, which
is used on many SoCs like msm8916, msm8996, msm8953, sdm845 and
many more MTPs from QualComm.

Also adds new functions to firmware driver which are needed to
request secure OS to restore ICE key config when device reset.

These patches have been tested on sdm845 MTP using some additional
patches (a) interconnect changes (b) ufs-ice interface driver
(c) dtsi changes for device init (d) kernel config changes. Once
these patches are accepted rest will be posted.

AnilKumar Chimata (3):
  firmware: qcom: scm: Update qcom_scm_call signature
  dt-bindings: Add ICE device specific parameters
  crypto: qce: ice: Add support for Inline Crypto Engine

 Documentation/crypto/msm/ice.txt                   |  235 +++
 .../devicetree/bindings/crypto/msm/ice.txt         |   34 +
 drivers/crypto/Kconfig                             |   10 +
 drivers/crypto/qce/Makefile                        |    1 +
 drivers/crypto/qce/ice.c                           | 1613 ++++++++++++++++++++
 drivers/crypto/qce/iceregs.h                       |  159 ++
 drivers/firmware/qcom_scm-32.c                     |   30 +-
 drivers/firmware/qcom_scm-64.c                     |   77 +-
 drivers/firmware/qcom_scm.c                        |    8 +-
 drivers/firmware/qcom_scm.h                        |    5 +-
 include/crypto/ice.h                               |   80 +
 include/linux/qcom_scm.h                           |    5 +
 12 files changed, 2213 insertions(+), 44 deletions(-)
 create mode 100644 Documentation/crypto/msm/ice.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/msm/ice.txt
 create mode 100644 drivers/crypto/qce/ice.c
 create mode 100644 drivers/crypto/qce/iceregs.h
 create mode 100644 include/crypto/ice.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
