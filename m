Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:2548 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbfARHNe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 02:13:34 -0500
From: Atul Gupta <atul.gupta@chelsio.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        dt@chelsio.com
Cc: atul.gupta@chelsio.com
Subject: [RFC patch 0/4] Inline TLS client and v6
Date: Thu, 17 Jan 2019 23:13:13 -0800
Message-Id: <20190118071313.9484-1-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Extends Inline TLS record processing to TLS client. connect
API is added to tls_context to setup hardware for TLS
connection and handshake. Functionality wise, this makes the solution
end-to-end Inline TLS capable. TLS server and client
can operate in Inline mode and leverage hardware for complete
TLS offload.
[0004] Adds IPv6 support to Inline TLS server and client.

Atul Gupta (4):
  net/tls: connect routine for Inline TLS client
  crypto/chelsio/chtls: hardware connect API
  crypto/chelsio/chtls: CPL for TLS client
  crypto/chelsio/chtls: IPv6 for Inline TLS

 drivers/crypto/chelsio/chtls/chtls.h          |   18 +-
 drivers/crypto/chelsio/chtls/chtls_cm.c       | 1276 ++++++++++++++++++++++---
 drivers/crypto/chelsio/chtls/chtls_cm.h       |   12 +-
 drivers/crypto/chelsio/chtls/chtls_hw.c       |    7 +-
 drivers/crypto/chelsio/chtls/chtls_io.c       |   41 +-
 drivers/crypto/chelsio/chtls/chtls_main.c     |  168 +++-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h   |   18 +
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h |    2 +
 include/net/tls.h                             |    5 +
 include/net/transp_v6.h                       |    8 +
 net/core/secure_seq.c                         |    1 +
 net/ipv6/tcp_ipv6.c                           |   26 +-
 net/tls/tls_main.c                            |   23 +
 13 files changed, 1455 insertions(+), 150 deletions(-)

-- 
1.8.3.1
