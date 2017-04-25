From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 0/5] crypto: caampkc - extend RSA private key representation
Date: Tue, 25 Apr 2017 16:26:34 +0300
Message-ID: <20170425132639.20178-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Radu Alexe <radu.alexe@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0086.outbound.protection.outlook.com ([104.47.32.86]:57920
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1430992AbdDYN1N (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Apr 2017 09:27:13 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch set adds support for the second and third RSA private key
representations and extends caampkc to use the fastest key when all related
components are present in the private key.

Additionally a rsa tcrypt test has been added.

Radu Alexe (4):
  crypto: tcrypt - include rsa test
  crypto: caampkc - incapsulate dropping leading zeros into function
  crypto: caampkc - add support for RSA key form 2
  crypto: cammpkc - add support for RSA key form 3

Tudor Ambarus (1):
  crypto: caampkc - avoid kzalloc(0) in caam_read_raw_data

 crypto/tcrypt.c                |   6 +-
 drivers/crypto/caam/caampkc.c  | 463 +++++++++++++++++++++++++++++++++++++++--
 drivers/crypto/caam/caampkc.h  |  58 ++++++
 drivers/crypto/caam/pdb.h      |  62 ++++++
 drivers/crypto/caam/pkc_desc.c |  36 ++++
 5 files changed, 603 insertions(+), 22 deletions(-)

-- 
2.12.0.264.gd6db3f216544
