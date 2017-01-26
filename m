From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH v3 00/12] crypto: atmel-authenc: add support to authenc(hmac(shaX),Y(aes)) modes
Date: Thu, 26 Jan 2017 17:07:45 +0100
Message-ID: <cover.1485443478.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <smueller@chronox.de>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <nicolas.ferre@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtpout.microchip.com ([198.175.253.82]:35466 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752517AbdAZQIA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Jan 2017 11:08:00 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi all,

this series of patches has been based and tested on next-20170125 with
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
atmel-authenc-hmac-sha1-cbc-aes             HW   HW  yes 38.8

SPLIP: Secure Protocol Layers Improved Performances (AES+SHA combined).

Some patches of this series are purely transitional: I've split the
modifications into many patches to ease the review.

Best regards,

Cyrille


ChangeLog:

v2 -> v3:
- add calls to memzero_explicit(&keys, ...) before exiting from
  atmel_aes_authenc_setkey().
- add missing comparison test between req->cryptlen and authsize values
  in atmel_aes_authenc_crypt().
- remove the atmel_aes_authenc_copy_assoc() function: I have tested with
  a strongswan IPSec ESP Tunnel Mode connection and it still works even if
  this driver no longer copies the AAD. FWI, I have also tested with the
  crypto/authenc.c driver after having removed the
  crypto_authenc_copy_assoc() function and it worked as well. However I
  didn't check whether I was in the special case req->src == req->dst.

v1 -> v2:
- add missing drivers/crypto/atmel-authenc.h file in patch 11.


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
 drivers/crypto/atmel-aes.c      |  455 ++++++++++++-
 drivers/crypto/atmel-authenc.h  |   64 ++
 drivers/crypto/atmel-sha-regs.h |   20 +
 drivers/crypto/atmel-sha.c      | 1438 +++++++++++++++++++++++++++++++++++++--
 6 files changed, 1937 insertions(+), 68 deletions(-)
 create mode 100644 drivers/crypto/atmel-authenc.h

-- 
2.7.4
