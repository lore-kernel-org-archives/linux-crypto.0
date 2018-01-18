From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: [PATCH v3 0/5] crypto: ahash.c: Require export/import in ahash
Date: Thu, 18 Jan 2018 19:33:59 +0100
Message-ID: <20180118183404.12583-1-k.konieczny@partner.samsung.com>
References: <CGME20180118183438eucas1p2e2e7be8625ae0950c519e27424f9301a@eucas1p2.samsung.com>
Cc: Kamil Konieczny <k.konieczny@partner.samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Vasut <marex@denx.de>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jan Engelhardt <jengelh@inai.de>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Joakim Bech <joakim.bech@linaro.org>,
        linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44284 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755225AbeARSem (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jan 2018 13:34:42 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

First four patches add empty hash export and import functions to each driver,
with the same behaviour as in crypto framework. The last one drops them from
crypto framework. Last one for ahash.c depends on all previous.

Changes in v3:
added change for bfin_crc.c
make this a patchset, instead of unreleated patches
make commit message more descriptive

Kamil Konieczny (5):
  crypto: mxs-dcp: Add empty hash export and import
  crypto: n2_core: Add empty hash export and import
  crypto: ux500/hash: Add empty export and import
  crypto: bfin_crc: Add empty hash export and import
  crypto: ahash.c: Require export/import in ahash

 crypto/ahash.c                        | 18 ++----------------
 drivers/crypto/bfin_crc.c             | 12 ++++++++++++
 drivers/crypto/mxs-dcp.c              | 14 ++++++++++++++
 drivers/crypto/n2_core.c              | 12 ++++++++++++
 drivers/crypto/ux500/hash/hash_core.c | 18 ++++++++++++++++++
 5 files changed, 58 insertions(+), 16 deletions(-)

-- 
2.15.0
