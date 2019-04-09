Return-Path: <SRS0=n6OX=SL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B6DC282DA
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 15:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3978320883
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 15:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbfDIPXZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Apr 2019 11:23:25 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:48108 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbfDIPXY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Apr 2019 11:23:24 -0400
Received: from beagle7.asicdesigners.com (beagle7.asicdesigners.com [10.192.192.157])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x39FMxNq003408;
        Tue, 9 Apr 2019 08:22:59 -0700
From:   Atul Gupta <atul.gupta@chelsio.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        dt@chelsio.com, atul.gupta@chelsio.com
Subject: [crypto 0/4] Inline TLS client and v6 support
Date:   Tue,  9 Apr 2019 08:22:34 -0700
Message-Id: <20190409152234.11100-1-atul.gupta@chelsio.com>
X-Mailer: git-send-email 2.20.0.rc2.7.g965798d
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Extends Inline TLS record processing to TLS client. connect
API is added to tls_context to setup hardware for TLS
connection and handshake. Functionality wise, this makes the solution
end-to-end Inline TLS capable. TLS server and client
can operate in Inline mode and leverage hardware for complete
TLS record offload.
[0004] Adds the IPv6 support for Inline TLS server/client.

RFC series for this patch was created against net-next and 
submitted on 18 Jan'2019.
This series is created against Herbert branch.

Atul Gupta (4):
  net/tls: connect routine for Inine TLS Client
  crypto/chelsio/chtls: hardware connect API
  crypto/chelsio/chtls: CPL for TLS client
  IPv6 changes for Inline TLS

 drivers/crypto/chelsio/chtls/chtls.h          |   18 +-
 drivers/crypto/chelsio/chtls/chtls_cm.c       | 1263 ++++++++++++++++++++++---
 drivers/crypto/chelsio/chtls/chtls_cm.h       |   12 +-
 drivers/crypto/chelsio/chtls/chtls_hw.c       |    7 +-
 drivers/crypto/chelsio/chtls/chtls_io.c       |   51 +-
 drivers/crypto/chelsio/chtls/chtls_main.c     |  164 +++-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h   |   18 +
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h |    2 +
 include/net/tls.h                             |    6 +
 include/net/transp_v6.h                       |    7 +
 net/core/secure_seq.c                         |    1 +
 net/ipv6/tcp_ipv6.c                           |   26 +-
 net/tls/tls_main.c                            |   23 +
 13 files changed, 1442 insertions(+), 156 deletions(-)

-- 
1.8.3.1

