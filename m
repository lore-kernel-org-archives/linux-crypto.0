Return-Path: <SRS0=g5s/=PY=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:17551 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729853AbfAPCvR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Jan 2019 21:51:17 -0500
From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangxiongfeng2@huawei.com>, <broonie@kernel.org>,
        <ard.biesheuvel@linaro.org>, <jonathan.cameron@huawei.com>
Subject: [PATCH 0/5] Crypto Cleanup
Date: Wed, 16 Jan 2019 10:50:29 +0800
Message-ID: <1547607034-40948-1-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The patchset introduce a helper to (un)register a array of crypto templates.
The following patches use this helper to simplify the code. This is also
a preparation for a coming patchset, which will register several crypto
templates.

Xiongfeng Wang (5):
  crypto: api - add a helper to (un)register a array of templates
  crypto: ccm - use template array registering API to simplify the code
  crypto: gcm - use template array registering API to simplify the code
  crypto: ctr - use template array registering API to simplify the code
  crypto: chacha20poly1305 - use template array registering API to
    simplify the code

 crypto/algapi.c           | 27 ++++++++++++++++
 crypto/ccm.c              | 81 +++++++++++++++--------------------------------
 crypto/chacha20poly1305.c | 38 +++++++++-------------
 crypto/ctr.c              | 46 ++++++++++-----------------
 crypto/gcm.c              | 76 +++++++++++++++-----------------------------
 include/crypto/algapi.h   |  2 ++
 6 files changed, 113 insertions(+), 157 deletions(-)

-- 
1.7.12.4
