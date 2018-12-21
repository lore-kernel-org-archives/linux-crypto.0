Return-Path: <SRS0=edWn=O6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from inva020.nxp.com ([92.121.34.13]:51690 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbeLUP7s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Dec 2018 10:59:48 -0500
From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-crypto@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH 0/3] crypto: caam - add support for xcbc(aes)
Date: Fri, 21 Dec 2018 17:59:07 +0200
Message-Id: <20181221155910.6235-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch set adds support for xcbc(aes) and improves a few ahash things
along the way.

It depends on the following patch:
[v2] crypto: caam - fix SHA support detection
https://patchwork.kernel.org/patch/10740373/

Iuliana Prodan (3):
  crypto: caam - fix error reporting for caam_hash_alloc
  crypto: caam - create ahash shared descriptors only once
  crypto: caam - add support for xcbc(aes)

 drivers/crypto/caam/caamhash.c      | 199 ++++++++++++++++++++++++++++++++----
 drivers/crypto/caam/caamhash_desc.c |  58 ++++++++++-
 drivers/crypto/caam/caamhash_desc.h |   2 +
 3 files changed, 240 insertions(+), 19 deletions(-)

-- 
2.16.2
