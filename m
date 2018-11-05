Return-Path: <SRS0=IFNk=NQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:14593 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729067AbeKEVxZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Nov 2018 16:53:25 -0500
From: John Garry <john.garry@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <Jonathan.Cameron@huawei.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 0/2] crypto: hisilicon - A couple of fixes
Date: Mon, 5 Nov 2018 20:35:13 +0800
Message-ID: <1541421315-25623-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset fixes a couple of issues I discovered while attempting to
bringup the driver.

John Garry (2):
  crypto: hisilicon -  Fix NULL dereference for same dst and src
  crypto: hisilicon -  Fix reference after free of memories on error
 path

 drivers/crypto/hisilicon/sec/sec_algs.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

-- 
1.9.1
