Return-Path: <SRS0=b5ak=PZ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:2246 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728158AbfAQGsw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jan 2019 01:48:52 -0500
From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <ebiggers@kernel.org>
CC: <wangxiongfeng2@huawei.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <broonie@kernel.org>,
        <ard.biesheuvel@linaro.org>, <jonathan.cameron@huawei.com>
Subject: [PATCH V2 0/5] Crypto Cleanup
Date: Thu, 17 Jan 2019 14:47:58 +0800
Message-ID: <1547707683-45878-1-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The patchset introduce a helper to (un)register a array of crypto templates.
The following patches use this helper to simplify the code. This is also
a preparation for a coming patchset, which will register several crypto
templates.

Changelog:
v1 -> v2: 
	rebased to cryptodev, fix some format issue

Xiongfeng Wang (5):
  crypto: api - add a helper to (un)register a array of templates
  crypto: ccm - use template array registering API to simplify the code
  crypto: gcm - use template array registering API to simplify the code
  crypto: ctr - use template array registering API to simplify the code
  crypto: chacha20poly1305 - use template array registering API to
    simplify the code

 crypto/algapi.c           | 27 ++++++++++++++++
 crypto/ccm.c              | 78 ++++++++++++++---------------------------------
 crypto/chacha20poly1305.c | 37 +++++++++-------------
 crypto/ctr.c              | 43 +++++++++-----------------
 crypto/gcm.c              | 73 ++++++++++++++------------------------------
 include/crypto/algapi.h   |  2 ++
 6 files changed, 104 insertions(+), 156 deletions(-)

-- 
1.7.12.4
