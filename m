Return-Path: <SRS0=vjnc=7P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084A2C433DF
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 07:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC503206A2
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 07:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgFBHFU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jun 2020 03:05:20 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59910 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725900AbgFBHFT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jun 2020 03:05:19 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 39949AD2E2636535337C;
        Tue,  2 Jun 2020 15:05:18 +0800 (CST)
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.151.115) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Tue, 2 Jun 2020 15:05:10 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <linux-crypto@vger.kernel.org>
CC:     Longpeng <longpeng2@huawei.com>, Gonglei <arei.gonglei@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v3 0/3] crypto: virtio: Fix three  issues                   
Date:   Tue, 2 Jun 2020 15:04:58 +0800
Message-ID: <20200602070501.2023-1-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.151.115]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Patch 1 & 2: fix two crash issues, Link: https://lkml.org/lkml/2020/1/23/205
Patch 3: fix another functional issue

Changes since v2:
 - put another bugfix together

Changes since v1:
 - remove some redundant checks [Jason]
 - normalize the commit message [Markus]

Cc: Gonglei <arei.gonglei@huawei.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org

Longpeng(Mike) (3):
  crypto: virtio: Fix src/dst scatterlist calculation in
    __virtio_crypto_skcipher_do_req()
  crypto: virtio: Fix use-after-free in
    virtio_crypto_skcipher_finalize_req()
  crypto: virtio: Fix dest length calculation in
    __virtio_crypto_skcipher_do_req()

 drivers/crypto/virtio/virtio_crypto_algs.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

-- 
1.8.3.1

