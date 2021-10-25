Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D71C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Oct 2021 09:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBB1461002
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Oct 2021 09:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhJYJ4p (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Oct 2021 05:56:45 -0400
Received: from pv50p00im-ztdg10021101.me.com ([17.58.6.44]:59059 "EHLO
        pv50p00im-ztdg10021101.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232572AbhJYJ4o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Oct 2021 05:56:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1635155261;
        bh=L/OmZoxqWxEqfHI4ZtMklvakAfC2zwPeSnx1PF9zsoo=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=eFRi/gn6Q3VeCUa0Tlu1tTZX+rVaUah0Y4mAOaqJeJnA1UdcZcic9EP0KdARvQE/H
         DpEW7sdN8RiM9Q2JZkgR70JTQeRiRzirFabntOYLI4kfnfZouV5zqQ0gOGyXVMiV/B
         A8c6wBybaW8mlfYlbnoLsVYOw+3U6a/Pj2WyB6eGAe3MFtOB6gRrbqidfWa5eFC2a6
         WcWawujoco5xQTlwDUh9rfGBd9xA0vXv3KXMg09TrVDR+KMABGpiSOwAPpQu2mlmaK
         NmDb6a9BOpLrDLIOioz0iHwPtJw/cWqcuf6Sjii+ELwFd9/ODlkFJZUJko0KAu9VXa
         IBZwGJVl71YQg==
Received: from debian.lan (unknown [171.214.215.34])
        by pv50p00im-ztdg10021101.me.com (Postfix) with ESMTPSA id D0A5D18054C;
        Mon, 25 Oct 2021 09:47:39 +0000 (UTC)
From:   Richard van Schagen <vschagen@icloud.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        matthias.bgg@gmail.com
Cc:     linux-crypto@vger.kernel.org,
        Richard van Schagen <vschagen@icloud.com>
Subject: [PATCH 0/2] Enable the Mediatek EIP-93 crypto engine
Date:   Mon, 25 Oct 2021 17:47:23 +0800
Message-Id: <20211025094725.2282336-1-vschagen@icloud.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.790
 definitions=2021-10-25_03:2021-10-25,2021-10-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=675 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2110250060
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series enable the Mediatek EIP-93 crypto engine.

This engine is capable of AES/DES/3DES ciphers in ECB/CBC and CTR modes,
hash and hmac(hash) using MD5, SHA1, SHA224 and SHA256. The engine can do
full authenc(hmac(x), cipher(y)) using mentioned ciphers and hashes.
The engine also has an ANSI X9.31 PRNG.

This driver is fully test and passes all the extra tests when selecting:
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS

For now only simple cipher and authenc are added. In the future I will
add patches for hash/hmac and the PRNG.

Richard van Schagen 

 .../bindings/crypto/mediatek, mtk-eip93.yaml  | 41 +++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/mediatek, mtk-eip93.yaml
 
 drivers/crypto/Kconfig                  |   2 +
 drivers/crypto/Makefile                 |   1 +
 drivers/crypto/mtk-eip93/Kconfig        |  44 ++
 drivers/crypto/mtk-eip93/Makefile       |   6 +
 drivers/crypto/mtk-eip93/eip93-aead.c   | 767 +++++++++++++++++++++++
 drivers/crypto/mtk-eip93/eip93-aead.h   |  43 ++
 drivers/crypto/mtk-eip93/eip93-aes.h    |  15 +
 drivers/crypto/mtk-eip93/eip93-cipher.c | 399 ++++++++++++
 drivers/crypto/mtk-eip93/eip93-cipher.h |  63 ++
 drivers/crypto/mtk-eip93/eip93-common.c | 783 ++++++++++++++++++++++++
 drivers/crypto/mtk-eip93/eip93-common.h |  34 +
 drivers/crypto/mtk-eip93/eip93-des.h    |  15 +
 drivers/crypto/mtk-eip93/eip93-main.c   | 457 ++++++++++++++
 drivers/crypto/mtk-eip93/eip93-main.h   | 146 +++++
 drivers/crypto/mtk-eip93/eip93-regs.h   | 382 ++++++++++++
 15 files changed, 3157 insertions(+)
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
