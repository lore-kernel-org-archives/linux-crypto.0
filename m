From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [PATCH v13 net-next 00/12] Chelsio Inline TLS
Date: Tue, 27 Mar 2018 23:06:29 +0530
Message-ID: <1522172201-7629-1-git-send-email-atul.gupta@chelsio.com>
Cc: davejwatson@fb.com, sd@queasysnail.net, sbrivio@redhat.com,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        werner@chelsio.com, leedom@chelsio.com,
        swise@opengridcomputing.com, indranil@chelsio.com,
        ganeshgr@chelsio.com
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

"Thank you, Stefano, Sabrina, Dave W. and everyone for reviewing the series."
"Dave, this should apply clean on net-next tree and I think it is ready
 to merge".

Series for Chelsio Inline TLS driver (chtls)

Use tls ULP infrastructure to register chtls as Inline TLS driver.
Chtls use TCP Sockets to Tx/Rx TLS records.
TCP sk_proto APIs are enhanced to offload TLS record.

T6 adapter provides the following features:
        -TLS record offload, TLS header, encrypt, digest and transmit
        -TLS record receive and decrypt
        -TLS keys store
        -TCP/IP engine
        -TLS engine
        -GCM crypto engine [support CBC also]

TLS provides security at the transport layer. It uses TCP to provide
reliable end-to-end transport of application data.
It relies on TCP for any retransmission.
TLS session comprises of three parts:
a. TCP/IP connection
b. TLS handshake
c. Record layer processing

TLS handshake state machine is executed in host (refer standard
implementation eg. OpenSSL).  Setsockopt [SOL_TCP, TCP_ULP]
initialize TCP proto-ops for Chelsio inline tls support.
setsockopt(sock, SOL_TCP, TCP_ULP, "tls", sizeof("tls"));

Tx and Rx Keys are decided during handshake and programmed on
the chip after CCS is exchanged.
struct tls12_crypto_info_aes_gcm_128 crypto_info
setsockopt(sock, SOL_TLS, TLS_TX, &crypto_info, sizeof(crypto_info))
Finish is the first encrypted/decrypted message tx/rx inline.

On the Tx path TLS engine receive plain text from openssl, insert IV,
fetches the tx key, create cipher text records and generate MAC.

TLS header is added to cipher text and forward to TCP/IP engine for
transport layer processing and transmission on wire.
TX PATH:
Apps--openssl--chtls---TLS engine---encrypt/auth---TCP/IP engine---wire

On the Rx side, data received is PDU aligned at record boundaries.
TLS processes only the complete record. If rx key is programmed on
CCS receive, data is decrypted and plain text is posted to host.
RX PATH:
Wire--cipher-text--TCP/IP engine [PDU align]---TLS engine---
decrypt/auth---plain-text--chtls--openssl--application

v13: handle clean ctx free for HW_RECORD in tls_sk_proto_close
    -removed SOCK_INLINE [chtls.h], using csk_conn_inline instead
     in send_abort_rpl,chtls_send_abort_rpl,chtls_sendmsg,chtls_sendpage
    -removed sk_no_receive [chtls_io.c] replaced with sk_shutdown &
     RCV_SHUTDOWN in chtls_pt_recvmsg, peekmsg and chtls_recvmsg
    -cleaned chtls_expansion_size [Stefano Brivio]
    - u8 conf:3 in tls_sw_context to add TLS_HW_RECORD
    -removed is_tls_skb, using tls_skb_inline [Stefano Brivio]
    -reverse christmas tree formatting in chtls_io.c, chtls_cm.c
     [Stefano Brivio]
    -fixed build warning reported by kbuild robot
    -retained ctx conf enum in chtls_main vs earlier versions, tls_prots
     not used in chtls.
    -cleanup [removed syn_sent, base_prot, added synq] [Michael Werner]
    - passing struct fw_wr_hdr * to ofldtxq_stop [Casey]
    - rebased on top of the current net-next

v12: patch against net-next
    -fixed build error [reported by Julia]
    -replace set_queue with skb_set_queue_mapping [Sabrina]
    -copyright year correction [chtls]

v11: formatting and cleanup, few function rename and error
     handling [Stefano Brivio]
     - ctx freed later for TLS_HW_RECORD
     - split tx and rx in different patch

v10: fixed following based on the review comments of Sabrina Dubroca
     -docs header added for struct tls_device [tls.h]
     -changed TLS_FULL_HW to TLS_HW_RECORD
     -similary using tls-hw-record instead of tls-inline for
     ethtool feature config
     -added more description to patch sets
     -replaced kmalloc/vmalloc/kfree with kvzalloc/kvfree
     -reordered the patch sequence
     -formatted entire patch for func return values

v9: corrected __u8 and similar usage
    -create_ctx to alloc tls_context
    -tls_hw_prot before sk !establish check

v8: tls_main.c cleanup comment [Dave Watson]

v7: func name change, use sk->sk_prot where required

v6: modify prot only for FULL_HW
   -corrected commit message for patch 11

v5: set TLS_FULL_HW for registered inline tls drivers
   -set TLS_FULL_HW prot for offload connection else move
    to TLS_SW_TX
   -Case handled for interface with same IP [Dave Miller]
   -Removed Specific IP and INADDR_ANY handling [v4]

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
  tls: support for Inline tls record
  ethtool: enable Inline TLS in HW
  cxgb4: Inline TLS FW Interface
  cxgb4: LLD driver changes to support TLS
  crypto: chcr - Inline TLS Key Macros
  crypto: chtls - structure and macro for Inline TLS
  crypto: chtls - Program the TLS session Key
  crypto : chtls - CPL handler definition
  crypto: chtls - Inline TLS record Tx
  crypto: chtls - Inline TLS record Rx
  crypto: chtls - Register chtls with net tls
  crypto: chtls - Makefile Kconfig

 drivers/crypto/chelsio/Kconfig                  |   11 +
 drivers/crypto/chelsio/Makefile                 |    1 +
 drivers/crypto/chelsio/chcr_algo.h              |   42 +
 drivers/crypto/chelsio/chcr_core.h              |   55 +-
 drivers/crypto/chelsio/chtls/Makefile           |    4 +
 drivers/crypto/chelsio/chtls/chtls.h            |  483 ++++++
 drivers/crypto/chelsio/chtls/chtls_cm.c         | 2057 +++++++++++++++++++++++
 drivers/crypto/chelsio/chtls/chtls_cm.h         |  203 +++
 drivers/crypto/chelsio/chtls/chtls_hw.c         |  394 +++++
 drivers/crypto/chelsio/chtls/chtls_io.c         | 1820 ++++++++++++++++++++
 drivers/crypto/chelsio/chtls/chtls_main.c       |  564 +++++++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |   32 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h  |    7 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c        |  105 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h     |  122 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h    |    2 +
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h   |  165 +-
 include/linux/netdev_features.h                 |    2 +
 include/net/tls.h                               |   32 +-
 net/core/ethtool.c                              |    1 +
 net/ipv4/tcp_minisocks.c                        |    1 +
 net/tls/tls_main.c                              |  115 +-
 22 files changed, 6192 insertions(+), 26 deletions(-)
 create mode 100644 drivers/crypto/chelsio/chtls/Makefile
 create mode 100644 drivers/crypto/chelsio/chtls/chtls.h
 create mode 100644 drivers/crypto/chelsio/chtls/chtls_cm.c
 create mode 100644 drivers/crypto/chelsio/chtls/chtls_cm.h
 create mode 100644 drivers/crypto/chelsio/chtls/chtls_hw.c
 create mode 100644 drivers/crypto/chelsio/chtls/chtls_io.c
 create mode 100644 drivers/crypto/chelsio/chtls/chtls_main.c

-- 
1.8.3.1
