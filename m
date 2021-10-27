Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02CFDC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 08:39:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7F8960F9D
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 08:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhJ0ImO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Oct 2021 04:42:14 -0400
Received: from pv50p00im-ztdg10021801.me.com ([17.58.6.56]:48148 "EHLO
        pv50p00im-ztdg10021801.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231551AbhJ0ImO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Oct 2021 04:42:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1635323989;
        bh=PeLpbYJY2kaJF76Inq3Xj2sOmNl8+nqW/HZFwwyqmF0=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=eYytEXEx4kcNXmlEacpB1UMo/WCyJDwXTj79DjfaVqz5rcqEH/9LV1z/09S98s7NW
         SnBB/0tqfX/xDoRN2O/Z20GzqATWft10SFq5TWxQ4Av2LNnIs/5dd1sULv2b6tiwgI
         bjWUx5rg1E/xxzPfhqzTyJwyo0rxxOU0eGag/iu6I0FEQGkQyDhA9IFWkWOQdJkDDj
         zoeWauxsjMNN+H2XT97gpYd4dtCY5OPD+BOOftSqhwJl/GvVydhUFM0Z0F/EsISztU
         3z9/tMHjUh7chNa3SMWp/tm29keNLUPTxBNUkrKwdO99R3rFH/dICGH5VoVBULkZYx
         ZmGzsPbmqslgg==
Received: from debian.lan (dhcp-077-251-223-151.chello.nl [77.251.223.151])
        by pv50p00im-ztdg10021801.me.com (Postfix) with ESMTPSA id 98A713605E2;
        Wed, 27 Oct 2021 08:39:44 +0000 (UTC)
From:   Richard van Schagen <vschagen@icloud.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        matthias.bgg@gmail.com, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org,
        Richard van Schagen <vschagen@icloud.com>
Subject: [PATCH v2 0/2] Enable the Mediatek EIP-93 crypto engine
Date:   Wed, 27 Oct 2021 16:39:00 +0800
Message-Id: <20211027083902.3093181-1-vschagen@icloud.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.790
 definitions=2021-10-27_02:2021-10-26,2021-10-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=365 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2110270052
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series enable the Mediatek EIP-93 crypto engine as found in the MT7621

This engine is capable of AES/DES/3DES ciphers in ECB/CBC and CTR modes,
hash and hmac(hash) using MD5, SHA1, SHA224 and SHA256. The engine can do
full authenc(hmac(x), cipher(y)) using mentioned ciphers and hashes.
The engine also has an ANSI X9.31 PRNG.

This driver is fully test and passes all the extra tests when selecting:
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS

For now only simple cipher and authenc are added. In the future I will
add patches for hash/hmac and the PRNG.

Richard van Schagen

Changes since V1:
 - Fix errors found by kernel test robot.
---
 .../bindings/crypto/mediatek,mtk-eip93.yaml   | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml

 drivers/crypto/Kconfig                  |   2 +
 drivers/crypto/Makefile                 |   1 +
 drivers/crypto/mtk-eip93/Kconfig        |  49 ++
 drivers/crypto/mtk-eip93/Makefile       |   7 +
 drivers/crypto/mtk-eip93/eip93-aead.c   | 767 +++++++++++++++++++++++
 drivers/crypto/mtk-eip93/eip93-aead.h   |  43 ++
 drivers/crypto/mtk-eip93/eip93-aes.h    |  15 +
 drivers/crypto/mtk-eip93/eip93-cipher.c | 399 ++++++++++++
 drivers/crypto/mtk-eip93/eip93-cipher.h |  62 ++
 drivers/crypto/mtk-eip93/eip93-common.c | 784 ++++++++++++++++++++++++
 drivers/crypto/mtk-eip93/eip93-common.h |  34 +
 drivers/crypto/mtk-eip93/eip93-des.h    |  15 +
 drivers/crypto/mtk-eip93/eip93-main.c   | 458 ++++++++++++++
 drivers/crypto/mtk-eip93/eip93-main.h   | 146 +++++
 drivers/crypto/mtk-eip93/eip93-regs.h   | 382 ++++++++++++
 15 files changed, 3164 insertions(+)
 create mode 100644 drivers/crypto/mtk-eip93/Kconfig
 create mode 100644 drivers/crypto/mtk-eip93/Makefile
 create mode 100644 drivers/crypto/mtk-eip93/eip93-aead.c
 create mode 100644 drivers/crypto/mtk-eip93/eip93-aead.h
 create mode 100644 drivers/crypto/mtk-eip93/eip93-aes.h
 create mode 100644 drivers/crypto/mtk-eip93/eip93-cipher.c
 create mode 100644 drivers/crypto/mtk-eip93/eip93-cipher.h
 create mode 100644 drivers/crypto/mtk-eip93/eip93-common.c
 create mode 100644 drivers/crypto/mtk-eip93/eip93-common.h
 create mode 100644 drivers/crypto/mtk-eip93/eip93-des.h
 create mode 100644 drivers/crypto/mtk-eip93/eip93-main.c
 create mode 100644 drivers/crypto/mtk-eip93/eip93-main.h
 create mode 100644 drivers/crypto/mtk-eip93/eip93-regs.h

