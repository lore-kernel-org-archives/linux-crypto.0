Return-Path: <SRS0=IiXH=BV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234E6C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Aug 2020 13:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E180820771
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Aug 2020 13:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgHKNmH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Aug 2020 09:42:07 -0400
Received: from mga03.intel.com ([134.134.136.65]:57763 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728516AbgHKNmH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Aug 2020 09:42:07 -0400
IronPort-SDR: Y11Yc7pNhBGKsxSlnnnnXKTUqnG/KHhEoMWsAFDaizpQWRoX6LHPMfYCSZwAGJSzfASUyoE8b3
 XgvMpPb03LoQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9709"; a="153705350"
X-IronPort-AV: E=Sophos;i="5.75,461,1589266800"; 
   d="scan'208";a="153705350"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2020 06:42:06 -0700
IronPort-SDR: nyPLAC8Y2gUJePBr9q89mD3hWjPd2t6n+2/9jm2tASx+VAWfg5XPRL3c1/babEAYSEajSWYC0e
 JQo/MHRgEH9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,461,1589266800"; 
   d="scan'208";a="495150631"
Received: from marshy.an.intel.com ([10.122.105.159])
  by fmsmga005.fm.intel.com with ESMTP; 11 Aug 2020 06:42:05 -0700
From:   richard.gong@linux.intel.com
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        gregkh@linuxfoundation.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        dinguyen@kernel.org, richard.gong@intel.com
Subject: [PATCHv1 0/2] add Intel SoCFPGA crypto service driver 
Date:   Tue, 11 Aug 2020 08:56:20 -0500
Message-Id: <1597154182-26970-1-git-send-email-richard.gong@linux.intel.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Richard Gong <richard.gong@intel.com>

I followed the process to register or request a valid IOCTL number/letter,
but I got the delivery failure status notification.

Cypto service driver and service layer driver patches have been reviewed
internally by colleagues at Intel.

Intel SoCFPGA is composed of a 64 bit quad-core ARM Cortex A53 hard
processor system (HPS) and Secure Device Manager (SDM). SDM is the
hardware which does the FPGA configuration, QSPI, remote system update,
crypto and warm reset.

To meet the whole system security needs and support virtual machine
requesting communication with SDM, only the secure world of software (EL3,
Exception Level 3) can interface with SDM. All software entities running
on other exception levels must channel through the EL3 software whenever
it needs service from SDM.

Intel Stratix10 service layer driver is added to provide the service for
FPGA configuration, Remote System Update and FPGA crypto service (FCS).
Running at privileged exception level (EL1, Exception Level 1), Intel
Stratix10 service layer driver interfaces with the service clients at EL1
and manages secure monitor call (SMC) to communicate with secure monitor
software at secure monitor exception level (EL3).

The crypto services include security certificate, image boot validation,
security key cancellation, get provision data, random number generation,
advance encryption standard (AES) encryption and decryption services.

To perform supporting crypto features on Intel SoCFPGA platforms, Linux
user-space application interacts with FPGA crypto service (FCS) driver via
structures defined in include/uapi/linux/intel_fcs-ioctl.h.

The application allocates spaces for IOCTL structure to hold the contents
or points to the data that FCS driver needs, uses IOCTL calls to passes
data to kernel FCS driver for processing at low level firmware and get
processed data or status back form the low level firmware via FCS driver.

The user-space application named as fcs_client is at
https://github.com/altera-opensource/fcs_apps/tree/fcs_client.

Richard Gong (2):
  firmware: stratix10-svc: extend svc to support new crypto features
  crypto: add Intel SoCFPGA crypto service driver

 drivers/crypto/Kconfig                             |  11 +
 drivers/crypto/Makefile                            |   1 +
 drivers/crypto/intel_fcs.c                         | 709 +++++++++++++++++++++
 drivers/firmware/stratix10-svc.c                   | 178 +++++-
 include/linux/firmware/intel/stratix10-smc.h       | 147 ++++-
 .../linux/firmware/intel/stratix10-svc-client.h    |  42 ++
 include/uapi/linux/intel_fcs-ioctl.h               | 222 +++++++
 7 files changed, 1291 insertions(+), 19 deletions(-)
 create mode 100644 drivers/crypto/intel_fcs.c
 create mode 100644 include/uapi/linux/intel_fcs-ioctl.h

-- 
2.7.4

