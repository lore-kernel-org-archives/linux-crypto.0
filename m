From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 00/24] crypto: atmel-aes: global rework of the driver
Date: Thu, 17 Dec 2015 17:48:31 +0100
Message-ID: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:56418 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470AbbLQQse (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Dec 2015 11:48:34 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi all,

this series of patches is a global rework of the Atmel driver. Some
patches improve the performances whereas others fix some bugs like
the counter overflow in CTR mode.

It also updates some part of the code to make them more generic. For
instance the crypto request queue management supports both async block
cipher and AEAD requests, which allows us to add support the the GCM
mode. The support of the GCM mode is only available on sama5d4 and later.

This series is based on linux-next and was tested on sama5d2, sama5d3 and
sama5d4 boards. The driver implementation was validated using the tcrypt
module running modes:
- 10: ecb(aes), cbc(aes), ctr(aes), rfc3686(ctr(aes))
- 35: gcm(aes)

tcrypt speed test was run with modes:
- 211: rfc4106(gcm(aes)), gcm(aes)
- 500: ecb(aes), cbc(aes), ctr(aes), cfb(aes), ofc(aes), rfc3686(ctr(aes))

Finally iperf was run for at least 5 mins over an IPSEC/L2TP tunnel using
the rfc4106(gcm(aes)) cipher suite.


Changelog:

v1: initial version


Cyrille Pitchen (23):
  crypto: atmel-aes: constify value argument of atmel_aes_write_n()
  crypto: atmel-aes: change algorithm priorities
  crypto: atmel-aes: fix unregistration order of crypto algorithms
  crypto: atmel-aes: remove unused header includes
  crypto: atmel-aes: propagate error from atmel_aes_hw_version_init()
  crypto: atmel-aes: change atmel_aes_write_ctrl() signature
  crypto: atmel-aes: make crypto request queue management more generic
  crypto: atmel-aes: remove useless write in the Control Register
  crypto: atmel-aes: simplify the configuration of the AES IP
  crypto: atmel-aes: rework crypto request completion
  crypto: atmel-aes: remove unused 'err' member of struct atmel_aes_dev
  crypto: atmel-aes: reduce latency of DMA completion
  crypto: atmel-aes: remove useless AES_FLAGS_DMA flag
  crypto: atmel-aes: fix atmel_aes_remove()
  crypto: atmel-aes: improve performances of data transfer
  crypto: atmel-aes: use SIZE_IN_WORDS() helper macro
  crypto: atmel-aes: fix typo and indentation
  crypto: atmel-aes: create sections to regroup functions by usage
  crypto: atmel-aes: fix atmel-ctr-aes driver for RFC 3686
  crypto: atmel-aes: fix the counter overflow in CTR mode
  crypto: atmel-aes: change the DMA threshold
  crypto: atmel-aes: add support to GCM mode
  crypto: atmel-aes: add debug facilities to monitor register accesses.

Leilei Zhao (1):
  crypto: atmel-aes: add new version

 drivers/crypto/Kconfig          |    1 +
 drivers/crypto/atmel-aes-regs.h |   10 +
 drivers/crypto/atmel-aes.c      | 1843 +++++++++++++++++++++++++++------------
 3 files changed, 1278 insertions(+), 576 deletions(-)

-- 
1.8.2.2
