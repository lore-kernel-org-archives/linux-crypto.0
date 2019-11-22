Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12080C432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 01:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E02AD2067D
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 01:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfKVBIi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 20:08:38 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:61600 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbfKVBIi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 20:08:38 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xAM18Uav011878;
        Thu, 21 Nov 2019 17:08:31 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        nirranjan@chelsio.com, atul.gupta@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next v2 0/3] cxgb4: add UDP Segmentation Offload support
Date:   Fri, 22 Nov 2019 06:30:00 +0530
Message-Id: <cover.1574383652.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series of patches add UDP Segmentation Offload (USO) supported
by Chelsio T5/T6 NICs.

Patch 1 updates the current Scatter Gather List (SGL) DMA unmap logic
for USO requests.

Patch 2 adds USO support for NIC and MQPRIO QoS offload Tx path.

Patch 3 adds missing stats for MQPRIO QoS offload Tx path.

Thanks,
Rahul

v2:
- Remove inline keyword from write_eo_udp_wr() in sge.c in patch 2.
  Let the compiler decide.


Rahul Lakkireddy (3):
  cxgb4/chcr: update SGL DMA unmap for USO
  cxgb4: add UDP segmentation offload support
  cxgb4: add stats for MQPRIO QoS offload Tx path

 drivers/crypto/chelsio/chcr_ipsec.c           |  27 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  21 +-
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |   2 +
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    |  16 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  11 +-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c  |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c      | 290 ++++++++++--------
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h |  14 +-
 8 files changed, 218 insertions(+), 165 deletions(-)

-- 
2.24.0

