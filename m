From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [RFC crypto v3 0/9] Chelsio Inline TLS
Date: Wed, 20 Dec 2017 17:03:02 +0530
Message-ID: <1513769582-25786-1-git-send-email-atul.gupta@chelsio.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, davejwatson@fb.com
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        ganeshgr@chelsio.com
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

RFC series for Chelsio Inline TLS driver (chtls.ko)

Driver use the ULP infrastructure to register chtls as Inline TLS ULP.
Chtls use TCP Sockets to transmit and receive TLS record. TCP proto_ops
is extended to offload TLS record.

T6 adapter provides the following features:
        -TLS record offload, TLS header, encrypt, digest and transmit
        -TLS record receive and decrypt
        -TLS keys store
        -TCP/IP engine
        -TLS engine
        -GCM crypto engine [support CBC also]

TLS provides security at the transport layer. It uses TCP to provide
reliable end-to-end transport of application data. It relies on TCP
for any retransmission. TLS session comprises of three parts:
a. TCP/IP connection
b. TLS handshake
c. Record layer processing

TLS handshake state machine is executed in host (refer standard
implementation eg. OpenSSL).  Setsockopt [SOL_TCP, TCP_ULP] initialize
TCP proto-ops for Chelsio inline tls support. setsockopt(sock, SOL_TCP,
TCP_ULP, "chtls", sizeof("chtls"));

Tx and Rx Keys are decided during handshake and programmed onto the chip
after CCS is exchanged.
struct tls12_crypto_info_aes_gcm_128 crypto_info
setsockopt(sock, SOL_TLS, TLS_TX, &crypto_info, sizeof(crypto_info))
Finish is the first encrypted/decrypted message tx/rx inline.

On the Tx path TLS engine receive plain text from openssl, insert IV,
fetches the tx key, create cipher text records and generate MAC. TLS
header is added to cipher text and forward to TCP/IP engine for transport
layer processing and transmission on wire.
TX:
Application--openssl--chtls---TLS engine---encrypt/auth---TCP/IP
engine---wire.

On the Rx side, data received is PDU aligned at record
boundaries. TLS processes only the complete record. If rx key is programmed
on CCS receive, data is decrypted and plain text is posted to host.
RX:
Wire--cipher-text--TCP/IP engine [PDU align]---TLS engine---
decrypt/auth---plain-text--chtls--openssl--application

v3: fixed the kbuild test issues
   -made few funtions static
   -initialized few variables

v2: fixed the following based on the review comments of Stephan Mueller,
    Stefano Brivio and Hannes Frederic
    -Added more details in cover letter
    -Fixed indentation and formating issues
    -Using aes instead of aes-generic
    -memset key info after programing the key on chip
    -reordered the patch sequence

Atul Gupta (9):
  chtls: structure and macro definiton
  cxgb4: Inline TLS FW Interface
  cxgb4: LLD driver changes to enable TLS
  chcr: Key Macro
  chtls: Key program
  chtls: CPL handler definition
  chtls: Inline crypto request Tx/Rx
  chtls: Register the ULP
  Makefile Kconfig

 drivers/crypto/chelsio/Kconfig                     |   10 +
 drivers/crypto/chelsio/Makefile                    |    1 +
 drivers/crypto/chelsio/chcr_algo.h                 |   42 +
 drivers/crypto/chelsio/chcr_core.h                 |   55 +-
 drivers/crypto/chelsio/chtls/Makefile              |    4 +
 drivers/crypto/chelsio/chtls/chtls.h               |  480 +++++
 drivers/crypto/chelsio/chtls/chtls_cm.c            | 2045 ++++++++++++++++++++
 drivers/crypto/chelsio/chtls/chtls_cm.h            |  203 ++
 drivers/crypto/chelsio/chtls/chtls_hw.c            |  394 ++++
 drivers/crypto/chelsio/chtls/chtls_io.c            | 1867 ++++++++++++++++++
 drivers/crypto/chelsio/chtls/chtls_main.c          |  584 ++++++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |   18 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   32 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |    7 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |   98 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h        |  121 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h       |    2 +
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h      |  165 +-
 include/uapi/linux/tls.h                           |    1 +
 net/ipv4/tcp_minisocks.c                           |    1 +
 20 files changed, 6111 insertions(+), 19 deletions(-)
 create mode 100644 drivers/crypto/chelsio/chtls/Makefile
 create mode 100644 drivers/crypto/chelsio/chtls/chtls.h
 create mode 100644 drivers/crypto/chelsio/chtls/chtls_cm.c
 create mode 100644 drivers/crypto/chelsio/chtls/chtls_cm.h
 create mode 100644 drivers/crypto/chelsio/chtls/chtls_hw.c
 create mode 100644 drivers/crypto/chelsio/chtls/chtls_io.c
 create mode 100644 drivers/crypto/chelsio/chtls/chtls_main.c

-- 
1.8.3.1
