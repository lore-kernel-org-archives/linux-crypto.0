Return-Path: <SRS0=4LZm=7H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531CEC433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 00:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31A722076C
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 00:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388462AbgEYA4t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 May 2020 20:56:49 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5274 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388309AbgEYA4s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 May 2020 20:56:48 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7F86062F009319EF4334;
        Mon, 25 May 2020 08:56:46 +0800 (CST)
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.151.115) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Mon, 25 May 2020 08:56:38 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <linux-crypto@vger.kernel.org>
CC:     "Longpeng(Mike)" <longpeng2@huawei.com>,
        Gonglei <arei.gonglei@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] crypto: virtio: fix two crash issue
Date:   Mon, 25 May 2020 08:56:25 +0800
Message-ID: <20200525005627.707-1-longpeng2@huawei.com>
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

Link: https://lkml.org/lkml/2020/1/23/205

Cc: Gonglei <arei.gonglei@huawei.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org

Longpeng(Mike) (2):
  crypto: virtio: fix src/dst scatterlist calculation
  crypto: virtio: fix an memory use-after-free bug

 drivers/crypto/virtio/virtio_crypto_algs.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

-- 
2.17.1

