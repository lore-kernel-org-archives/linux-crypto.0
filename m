From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [Crypto v4 00/12] Chelsio Inline TLS
Date: Mon, 12 Feb 2018 17:33:13 +0530
Message-ID: <1518436993-14210-1-git-send-email-atul.gupta@chelsio.com>
Cc: sd@queasysnail.net, linux-crypto@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, ganeshgr@chelsio.com
To: davejwatson@fb.com, herbert@gondor.apana.org.au
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
TCP_ULP, "tls", sizeof("tls"));

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

v4: removed chtls ULP type, retained tls ULP
   -registered chtls with net tls
   -defined struct tls_device to register the Inline drivers
   -ethtool interface tls-inline to enable Inline TLS for interface
   -prot update to support inline TLS

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

Atul Gupta (12):
  tls: tls_device struct to register TLS drivers
  ethtool: feature for Inline TLS in HW
  support for inline tls
  chtls: structure and macro definiton
  cxgb4: Inline TLS FW Interface
  cxgb4: LLD driver changes to enable TLS
  chcr: Key Macro
  chtls: Key program
  chtls: CPL handler definition
  chtls: Inline crypto request Tx/Rx
  chtls: Register the chtls Inline TLS with net tls
  Makefile Kconfig

 drivers/crypto/chelsio/Kconfig                     |   11 +
 drivers/crypto/chelsio/Makefile                    |    1 +
 drivers/crypto/chelsio/chcr_algo.h                 |   42 +
 drivers/crypto/chelsio/chcr_core.h                 |   55 +-
 drivers/crypto/chelsio/chtls/Makefile              |    4 +
 drivers/crypto/chelsio/chtls/chtls.h               |  487 +++++
 drivers/crypto/chelsio/chtls/chtls_cm.c            | 2045 ++++++++++++++++++++
 drivers/crypto/chelsio/chtls/chtls_cm.h            |  203 ++
 drivers/crypto/chelsio/chtls/chtls_hw.c            |  394 ++++
 drivers/crypto/chelsio/chtls/chtls_io.c            | 1867 ++++++++++++++++++
 drivers/crypto/chelsio/chtls/chtls_main.c          |  619 ++++++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |   18 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   32 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |    7 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |   98 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h        |  121 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h       |    2 +
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h      |  165 +-
 include/linux/netdev_features.h                    |    2 +
 include/net/tls.h                                  |   21 +
 include/uapi/linux/tls.h                           |    1 +
 net/core/ethtool.c                                 |    1 +
 net/ipv4/tcp_minisocks.c                           |    1 +
 net/tls/tls_main.c                                 |  113 ++
 24 files changed, 6291 insertions(+), 19 deletions(-)
 create mode 100644 drivers/crypto/chelsio/chtls/Makefile
 create mode 100644 drivers/crypto/chelsio/chtls/chtls.h
 create mode 100644 drivers/crypto/chelsio/chtls/chtls_cm.c
 create mode 100644 drivers/crypto/chelsio/chtls/chtls_cm.h
 create mode 100644 drivers/crypto/chelsio/chtls/chtls_hw.c
 create mode 100644 drivers/crypto/chelsio/chtls/chtls_io.c
 create mode 100644 drivers/crypto/chelsio/chtls/chtls_main.c

-- 
1.8.3.1
