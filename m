From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [crypto 0/8] Chelsio inline TLS
Date: Tue,  5 Dec 2017 17:08:55 +0530
Message-ID: <1512473935-6513-1-git-send-email-atul.gupta@chelsio.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, davejwatson@fb.com,
        ganeshgr@chelsio.com, harsh@chelsio.com
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:36845 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750855AbdLELjN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Dec 2017 06:39:13 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

RFC series for Chelsio Inline TLS driver (chtls.ko)

Chtls driver use the available ULP infrastructure to register
chtls as another ULP. Chtls use the TCP Sockets to transmit and
receive TLS record. TCP proto_ops is extended to offload TLS
record.

T6 adapter provide the following features:
	-TLS record offload, add TLS header, encrypt data and transmit
	-TLS record receive and decrypt
	-TLS keys store
	-GCM crypto engine

Atul Gupta (8):
  cxgb4: Inline TLS
  chcr: changes to chcr driver
  chtls: ulp for Inline TLS processing
  chtls: CPL handler definition
  chtls: Inline crypto request for Tx.
  chtls: TCB and Key program
  chtls: structure and macro definiton
  Kconfig Makefile

 drivers/crypto/chelsio/Kconfig                     |   10 +
 drivers/crypto/chelsio/Makefile                    |    1 +
 drivers/crypto/chelsio/chcr_algo.h                 |   42 +
 drivers/crypto/chelsio/chcr_core.h                 |   55 +-
 drivers/crypto/chelsio/chtls/Makefile              |    4 +
 drivers/crypto/chelsio/chtls/chtls.h               |  481 +++++
 drivers/crypto/chelsio/chtls/chtls_cm.c            | 2048 ++++++++++++++++++++
 drivers/crypto/chelsio/chtls/chtls_cm.h            |  209 ++
 drivers/crypto/chelsio/chtls/chtls_hw.c            |  394 ++++
 drivers/crypto/chelsio/chtls/chtls_io.c            | 1866 ++++++++++++++++++
 drivers/crypto/chelsio/chtls/chtls_main.c          |  585 ++++++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |   18 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   32 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |    7 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |   98 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h        |  121 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h       |    2 +
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h      |  165 +-
 include/uapi/linux/tls.h                           |    1 +
 19 files changed, 6120 insertions(+), 19 deletions(-)
 create mode 100644 drivers/crypto/chelsio/chtls/Makefile
 create mode 100644 drivers/crypto/chelsio/chtls/chtls.h
 create mode 100644 drivers/crypto/chelsio/chtls/chtls_cm.c
 create mode 100644 drivers/crypto/chelsio/chtls/chtls_cm.h
 create mode 100644 drivers/crypto/chelsio/chtls/chtls_hw.c
 create mode 100644 drivers/crypto/chelsio/chtls/chtls_io.c
 create mode 100644 drivers/crypto/chelsio/chtls/chtls_main.c

-- 
1.8.3.1
