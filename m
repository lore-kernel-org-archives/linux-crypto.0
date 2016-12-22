From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 00/12] crypto: atmel-authenc: add support to authenc(hmac(shaX),Y(aes)) modes
Date: Thu, 22 Dec 2016 17:15:05 +0100
Message-ID: <cover.1482422983.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi all,

this series of patches has been based and tested on next-20161222 with
CRYPTO_MANAGER_DISABLED_TESTS not set.

The series adds support to the hmac(shaX) algorithms first, then combines
both the Atmel SHA and AES hardware accelerators to implement
authenc(hmac(shaX),Y(aes)) algorithms as used by IPSEC/SSL connections.

It has also been tested with strongswan + xl2tpd to create an IPSEC+L2TP
(transport mode) VPN and strongswan only (tunnel mode) for an IPSEC VPN.

Then iperf was used to measure the bandwidth improvement in tunnel mode:

drivers                                    AES SHA SPLIP iperf half-duplex
                                                         Mbit/s
authenc(hmac(sha1-generic),cbc(aes))        SW   SW  N/A 27.7
authenc(hmac(sha1-generic),atmel-cbc-aes)   HW   SW  N/A 30.2 (mainline)
authenc(atmel-hmac-sha1,atmel-cbc-aes)      HW   HW   no 29.1
atmel-authenc-hmac-sha1-cbc-aes             HW   hW  yes 38.8

SPLIP: Secure Protocol Layers Improved Performances (AES+SHA combined).

Some patches of this series are purely transitional: I've split the
modifications into many patches to ease the review.

Best regards,

Cyrille

Cyrille Pitchen (12):
  crypto: atmel-sha: create function to get an Atmel SHA device
  crypto: atmel-sha: update request queue management to make it more
    generic
  crypto: atmel-sha: make atmel_sha_done_task more generic
  crypto: atmel-sha: redefine SHA_FLAGS_SHA* flags to match
    SHA_MR_ALGO_SHA*
  crypto: atmel-sha: add atmel_sha_wait_for_data_ready()
  crypto: atmel-sha: add SHA_MR_MODE_IDATAR0
  crypto: atmel-sha: add atmel_sha_cpu_start()
  crypto: atmel-sha: add simple DMA transfers
  crypto: atmel-sha: add support to hmac(shaX)
  crypto: atmel-aes: fix atmel_aes_handle_queue()
  crypto: atmel-authenc: add support to authenc(hmac(shaX),Y(aes)) modes
  crypto: atmel-sha: add verbose debug facilities to print hw register
    names

 drivers/crypto/Kconfig          |   12 +
 drivers/crypto/atmel-aes-regs.h |   16 +
 drivers/crypto/atmel-aes.c      |  478 ++++++++++++-
 drivers/crypto/atmel-sha-regs.h |   20 +
 drivers/crypto/atmel-sha.c      | 1438 +++++++++++++++++++++++++++++++++++++--
 5 files changed, 1896 insertions(+), 68 deletions(-)

-- 
2.7.4
